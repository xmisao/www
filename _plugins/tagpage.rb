# coding:utf-8
module Jekyll
	class TagPage < Page
		def initialize(site, base, dir, tag)
			@site, @base, @dir = site, base, dir
			@name = 'index.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
			self.data['tag'] = tag

			self.data['title'] = "#{tag}タグのエントリ一覧"
			self.data['posts'] = site.tags[tag]
		end
	end

	class TagPageGenerator < Generator
		safe true

		def generate(site)
			dir = 'tags'
			site.tags.keys.each do |tag|
				site.pages << TagPage.new(site, site.source, File.join(dir, tag), tag)
			end
		end
	end
end