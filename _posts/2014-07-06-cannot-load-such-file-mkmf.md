---
layout: blog
title: mkmfが無い場合はruby-devをインストール
tag: ['debian', 'ruby']
---

# mkmfが無い場合はruby-devをインストール

インストールしたてのdebianではgemのビルド時に以下のエラーが出ることがある。

~~~~
Fetching gem metadata from https://rubygems.org/.........
Fetching additional metadata from https://rubygems.org/..
sudo: unable to resolve host hikoboshi

Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/bin/ruby1.9.1 extconf.rb 
/usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- mkmf (LoadError)
        from /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require'
        from extconf.rb:1:in `<main>'


Gem files will remain installed in /tmp/bundler20140706-6975-6is0fx/unf_ext-0.0.6/gems/unf_ext-0.0.6 for inspection.
Results logged to /tmp/bundler20140706-6975-6is0fx/unf_ext-0.0.6/gems/unf_ext-0.0.6/ext/unf_ext/gem_make.out
An error occurred while installing unf_ext (0.0.6), and Bundler cannot continue.
Make sure that `gem install unf_ext -v '0.0.6'` succeeds before bundling.
~~~~

このような場合は`ruby-dev`パッケージをインストールすれば良い。

~~~~
apt-get install ruby-dev
~~~~

何か毎回このエラーが出て、その度に適当に解決しているのでメモ。
