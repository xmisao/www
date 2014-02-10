---
layout: blog
title: Rubyのattr_accessor, attr_reader, attr_writerとは何か
tag: ruby
---

# Rubyのattr_accessor, attr_reader, attr_writerとは何か

Ruby初心者であれば構文の一種だと誤解してしまいそうだが、これらはインスタンス変数にアクセスするためのメソッドを定義するメソッドである。

Java等の他の言語を経験した人には、プライベート変数に対するセッタやゲッタを勝手に定義してくれるメソッド、と説明すればわかりやすいかも知れない。

これらのメソッドの役割分担は以下のとおり。
通常は`attr_accessor`を目にする機会が多いと思われる。

- `attr_accessor` -- セッタとゲッタを共に定義する
- `attr_reader` -- ゲッタのみを定義する
- `attr_writer` -- セッタのみを定義する

以下の2つのRubyスクリプトは、どちらも本質的に同じ意味である。
しかし、`attr_accessor`を使うことで、記述量を大幅に減らせていることがわかる。
Rubyでは単なるセッタやゲッタを自分でゴリゴリと定義する代わりに、`attr_*`を使う慣例になっているのだ。

~~~~
class Hoge
  attr_accessor :foo
end
~~~~

~~~~
class Hoge
  def foo=(val)
    @foo = val
  end

  def foo
    @foo
  end
end
~~~~

そして、いずれの例でも、以下のようにクラスのインスタンス変数に外部からアクセスすることができる。

~~~~
hoge = Hoge.new
hoge.foo = "bar"
p hoge.foo #=> "bar"
~~~~

## おまけ1 : attr_accessorを自分で定義する

Rubyではメソッドを定義するメソッドを自分で定義することももちろん可能だ。例えば`attr_accessor`モドキは以下のように実装でき、きちんと動作する。

~~~~
class Object
  def Object.my_attr_accessor(*fields)
    fields.each{|field|
      define_method(field.to_s){
        instance_variable_get('@' + field.to_s)
      }
      define_method(field.to_s + "="){|val|
        instance_variable_set('@' + field.to_s, val)
      }
    }
  end
end

class Hoge
  my_attr_accessor :foo
end

hoge = Hoge.new
hoge.foo = 'bar'
p hoge.foo #=> 'bar'
~~~~

## おまけ2 : Rubyのソースコードを追ってみる

`attr_accessor`、`attr_reader`、`attr_writer`の実装がどうなっているのか気になったので少しRuby 1.9.3のソースコードを追ってみた。(途中で挫折)

まず各メソッドの実装を見てみる。`attr_*`が実装されているのは`object.c`だ。どのメソッドも、渡されたシンボルを順に`rb_attr`に渡している。`rb_attr`を呼び出すフラグが異なるだけで、基本的にはすべて同じことをしているようだ。

~~~~
static VALUE
rb_mod_attr_accessor(int argc, VALUE *argv, VALUE klass)
{
    int i;

    for (i=0; i<argc; i++) {
    rb_attr(klass, rb_to_id(argv[i]), TRUE, TRUE, TRUE);
    }
    return Qnil;
}
~~~~

~~~~
static VALUE
rb_mod_attr_reader(int argc, VALUE *argv, VALUE klass)
{
    int i;

    for (i=0; i<argc; i++) {
    rb_attr(klass, rb_to_id(argv[i]), TRUE, FALSE, TRUE);
    }
    return Qnil;
}
~~~~

~~~~
static VALUE
rb_mod_attr_writer(int argc, VALUE *argv, VALUE klass)
{
    int i;

    for (i=0; i<argc; i++) {
    rb_attr(klass, rb_to_id(argv[i]), FALSE, TRUE, TRUE);
    }
    return Qnil;
}
~~~~

そして`rb_attr`の実装は`vm_method.c`にある。名前から察すると属性を定義する関数のようだ。最後の方で`read`、`write`のフラグに応じて、`rb_add_method`を呼んでいる箇所があるのがわかる。ここがメソッド追加の本体と思われる。

~~~~
void
rb_attr(VALUE klass, ID id, int read, int write, int ex)
{
    const char *name;
    ID attriv;
    VALUE aname;
    rb_method_flag_t noex;

    if (!ex) {
    noex = NOEX_PUBLIC;
    }
    else {
    if (SCOPE_TEST(NOEX_PRIVATE)) {
        noex = NOEX_PRIVATE;
        rb_warning((SCOPE_CHECK(NOEX_MODFUNC)) ?
               "attribute accessor as module_function" :
               "private attribute?");
    }
    else if (SCOPE_TEST(NOEX_PROTECTED)) {
        noex = NOEX_PROTECTED;
    }
    else {
        noex = NOEX_PUBLIC;
    }
    }

    if (!rb_is_local_id(id) && !rb_is_const_id(id)) {
    rb_name_error(id, "invalid attribute name `%s'", rb_id2name(id));
    }
    name = rb_id2name(id);
    if (!name) {
    rb_raise(rb_eArgError, "argument needs to be symbol or string");
    }
    aname = rb_sprintf("@%s", name);
    rb_enc_copy(aname, rb_id2str(id));
    attriv = rb_intern_str(aname);
    if (read) {
    rb_add_method(klass, id, VM_METHOD_TYPE_IVAR, (void *)attriv, noex);
    }
    if (write) {
    rb_add_method(klass, rb_id_attrset(id), VM_METHOD_TYPE_ATTRSET, (void *)attriv, noex);
    }
}
~~~~

さらに同ファイルに定義された`rb_add_method`を読んでみる。が、ここから急に難易度が上がり理解不能に…。`VM_METHOD_TYPE_ATTRSET`と`VM_METHOD_TYPE_IVAR`の分岐に落ちること、最後に`method_added`を呼ぶことまではわかるのだが。

~~~~
rb_method_entry_t *
rb_add_method(VALUE klass, ID mid, rb_method_type_t type, void *opts, rb_method_flag_t noex)
{
    rb_thread_t *th;
    rb_control_frame_t *cfp;
    int line;
    rb_method_entry_t *me = rb_method_entry_make(klass, mid, type, 0, noex);
    rb_method_definition_t *def = ALLOC(rb_method_definition_t);
    me->def = def;
    def->type = type;
    def->original_id = mid;
    def->alias_count = 0;
    switch (type) {
      case VM_METHOD_TYPE_ISEQ:
    def->body.iseq = (rb_iseq_t *)opts;
    break;
      case VM_METHOD_TYPE_CFUNC:
    def->body.cfunc = *(rb_method_cfunc_t *)opts;
    break;
      case VM_METHOD_TYPE_ATTRSET:
      case VM_METHOD_TYPE_IVAR:
    def->body.attr.id = (ID)opts;
    def->body.attr.location = Qfalse;
    th = GET_THREAD();
    cfp = rb_vm_get_ruby_level_next_cfp(th, th->cfp);
    if (cfp && (line = rb_vm_get_sourceline(cfp))) {
        VALUE location = rb_ary_new3(2, cfp->iseq->filename, INT2FIX(line));
        def->body.attr.location = rb_ary_freeze(location);
    }
    break;
      case VM_METHOD_TYPE_BMETHOD:
    def->body.proc = (VALUE)opts;
    break;
      case VM_METHOD_TYPE_NOTIMPLEMENTED:
    def->body.cfunc.func = rb_f_notimplement;
    def->body.cfunc.argc = -1;
    break;
      case VM_METHOD_TYPE_OPTIMIZED:
    def->body.optimize_type = (enum method_optimized_type)opts;
    break;
      case VM_METHOD_TYPE_ZSUPER:
      case VM_METHOD_TYPE_UNDEF:
    break;
      default:
    rb_bug("rb_add_method: unsupported method type (%d)\n", type);
    }
    if (type != VM_METHOD_TYPE_UNDEF) {
    method_added(klass, mid);
    }
    return me;
}
~~~~

`attr_accessor`で追加されるメソッドの実装がどうなっているのかまでは突き止めることができなかった。
