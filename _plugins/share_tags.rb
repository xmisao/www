module Jekyll
  class ShareHatenaTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']

      "https://b.hatena.ne.jp/entry/" + CGI.escape("#{site_url}#{page_url}")
    end
  end

  class ShareTwitterTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']
      page_title = context.registers[:page]['title']

      "https://twitter.com/intent/tweet?text=" + CGI.escape("#{page_title} #{site_url}#{page_url}")
    end
  end

  class ShareFacebookTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']

      "https://www.facebook.com/sharer/sharer.php?u=" + CGI.escape("#{site_url}#{page_url}")
    end
  end

  class ShareLineTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']
      page_title = context.registers[:page]['title']

      "line://msg/text/" + CGI.escape("#{page_title} #{site_url}#{page_url}")
    end
  end

  class SharePocketTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']

      "http://getpocket.com/edit?url=" + CGI.escape("#{site_url}#{page_url}")
    end
  end

  class ShareGooglePlusTag < Liquid::Tag
    def render(context)
      site_url = context.registers[:site].config['url']
      page_url = context.registers[:page]['url']

      "https://plus.google.com/share?url=" + CGI.escape("#{site_url}#{page_url}")
    end
  end
end

Liquid::Template.register_tag('share_hatena', Jekyll::ShareHatenaTag)
Liquid::Template.register_tag('share_twitter', Jekyll::ShareTwitterTag)
Liquid::Template.register_tag('share_facebook', Jekyll::ShareFacebookTag)
Liquid::Template.register_tag('share_line', Jekyll::ShareLineTag)
Liquid::Template.register_tag('share_pocket', Jekyll::SharePocketTag)
Liquid::Template.register_tag('share_google_plus', Jekyll::ShareGooglePlusTag)
