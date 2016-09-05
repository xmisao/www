# coding:utf-8
module Jekyll
	class TagIndexPage < Page
		def initialize(site, base, dir, tag)
			@site, @base, @dir = site, base, dir
			@name = 'index.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
			self.data['tag'] = tag

			self.data['title'] = "#{tag}タグのエントリ一覧"
			self.data['posts'] = site.tags[tag].sort.reverse
			self.data['title-string'] = "#{tag}タグのエントリ一覧"
      self.data['active-tab'] = 'posts'
		end
	end

	class TagEntryPage < Page
		def initialize(site, base, dir, tag)
			@site, @base, @dir = site, base, dir
			@name = 'entries.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'tag_entries.html')
			self.data['tag'] = tag

			self.data['title'] = "#{tag}タグのエントリ一覧"
			self.data['posts'] = site.tags[tag].sort.reverse
		end
	end

	class TagPageGenerator < Generator
		safe true

		def generate(site)
			dir = 'tags'
			site.tags.keys.each do |tag|
				site.pages << TagIndexPage.new(site, site.source, File.join(dir, tag), tag)
				site.pages << TagEntryPage.new(site, site.source, File.join(dir, tag), tag)
			end
		end
	end
end
