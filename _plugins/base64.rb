require 'base64'

module Jekyll
  class Base64Tag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @base64 = markup
      super
    end

    def render(context)
      Base64.decode64(@base64)
    end
  end
end

Liquid::Template.register_tag('base64', Jekyll::Base64Tag)
