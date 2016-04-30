require 'flickraw'
require 'shellwords'

module Jekyll

  class FlickrPhotoTag < Liquid::Tag

    @@cached = {} # Prevents multiple requests for the same photo

    def initialize(tag_name, markup, tokens)
      super
      params = Shellwords.shellwords markup
      @photo = { :id => params[0], :size => params[1] || "Medium", :sizes => {}, :title => "", :caption => "", :url => "", :exif => {} }

    end

    def render(context)
				# auth
				FlickRaw.api_key = context.registers[:site].config["flickr"]["api_key"]
				FlickRaw.shared_secret = context.registers[:site].config["flickr"]["shared_secret"]
        @photo.merge!(@@cached[photo_key] || get_photo)
        
				return "<div class=\"thumbnail\"><img src=\"#{@photo[:source]}\"/>" + "<div class=\"caption\" style=\"text-align: right\">" + "<a href=\"#{@photo[:author_link]}\"><small>flickr photo by #{@photo[:author]}</small></a>" + "</div>" + "</div>"
    end

    def get_photo
				info = flickr.photos.getInfo( :photo_id => @photo[:id])
				@photo[:source] = FlickRaw.url( info)
				@photo[:author] = info.owner[ "username"]
				@photo[:author_link] = FlickRaw.url_photopage( info)
        @@cached[photo_key] = @photo
    end

    def photo_key
        "#{@photo[:id]}"
    end

  end

end

Liquid::Template.register_tag('flickr_photo', Jekyll::FlickrPhotoTag)
