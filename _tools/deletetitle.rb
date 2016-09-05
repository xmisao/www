REGEXP_FENCE = /^~~~/
REGEXP_HEAD_SHARP = /^#/

Dir.glob('_posts/*.md'){|path|
  content = open(path){|f| f.read}
  fenced_codeblock = false
  open(path, 'w'){|f|
    content.each_line{|l|
      if l.match(REGEXP_FENCE)
        fenced_codeblock = !fenced_codeblock
      end
      unless fenced_codeblock
        if l.match(REGEXP_HEAD_SHARP)
          l.sub!('#', '')
          unless l.match(REGEXP_HEAD_SHARP)
            l = ''
          end
        end
      end
      f.puts l
    }
  }
}
