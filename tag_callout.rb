module Hesu
	class TagCalloutPrimary < Liquid::Tag
		def initialize( tag_name, markup, tokens)
			super
			@markup = markup 
		end

		def render(context)
			return "<div class=\"bs-callout bs-callout-primary\"><h4>#{@markup}</h4></div>"
		end
	end

#	syntax : 
#	{% callout_primary_for_euler subject~blah~blah %}
#	english link
# korean link(optional)
# {% endcallout_primary_for_euler %}
	class TagCalloutPrimaryForEuler < Liquid::Block
		def initialize( tag_name, markup, tokens)
			super
			@markup = markup 
		end

		def render(context)
			@tokens = super.to_s.split( /\n/)
			@default = "<div class=\"bs-callout bs-callout-primary\">\
							<h4>#{@markup}</h4>\
							<a href=\"#{@tokens[1]}\">[eng]</a>"

			if @tokens.length > 2
				return @default + "<a href=\"#{@tokens[2]}\">[kor]</a>" + "</div>" 
			else
				return @default + "</div>"
			end
		end
	end

end

Liquid::Template.register_tag('callout_primary', Hesu::TagCalloutPrimary)
Liquid::Template.register_tag('callout_primary_for_euler', Hesu::TagCalloutPrimaryForEuler)
