module Jekyll 
	
	class CategoryPage < Page
		def initialize( site, base, dir, name)
#puts( "CategoryPage :: initialize()")
			@site = site
			@base = base
			@dir = dir
			@name = 'index.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'category.html')
			
			# set generated category page's title
			category_title_prefix = site.config['category_title_prefix']
			self.data['title'] =  "#{category_title_prefix}#{name}"
		
			# set page variables used in _layouts/category.html
			# 'categories' of front-matter must be a 'Maincategory/Subcategory' or 'Maincategory'

			@cregex = /(\w+)\/(.+)/
			@list = Hash.new()
			site.categories.each_key do |c|
				@m = @cregex.match( c) # m[1]=MainCategory, m[2]=SubCategory
				
				if @m 
					if @list.has_key?( @m[1])
						#if !(@list[ @m[1]].include? @m[2])
						if !(@list[ @m[1]].has_key?( @m[2]))
							@list[ @m[1]][ @m[2]] = [] 
						end
					else
						@list[ @m[1]] = {}
						@list[ @m[1]][ @m[2]] = [] 
					end
				else # c = MainCategory
					if !(@list.has_key?( c))
						@list[ c] = []
					end
				end
			end
		
			site.posts.each{ |p| 
				p.categories.each{ |c|
					@m = @cregex.match(c)
					if @m
						@postinfo = {}
						@postinfo[ "url"] = p.url()
						@postinfo[ "title"] = p.title()
						@list[ @m[1]][ @m[2]].push( @postinfo)
						#puts( @postinfo)
					else
						#@list[ c].push( p.url())
					end
				}
			}
			
#puts( @list)
			self.data[ 'category_list'] = @list
		end
	end

	class CategoryPageGenerator < Generator 
		safe true
		def generate(site)
#puts( "CategoryPageGenerator::generate()!")
			if site.layouts.key? 'category'
				dir = site.config['category_dir'] || 'category'
				site.pages << CategoryPage.new( site, site.source, File.join(dir, 'category'), 'category')
			end
		end
	end
end
