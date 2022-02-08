require 'uri'

module Lono::Bundler::Component::Concerns
  module NotationConcern
    def remove_notations(source)
      remove_subfolder_notation(remove_ref_notation(source))
    end

    def remove_ref_notation(source)
      source.sub(/\?.*/,'')
    end

    def remove_subfolder_notation(source)
      clean = clean_notation(source)
      parts = clean.split('//')
      if parts.size == 2 # has subfolder
        source.split('//')[0..-2].join('//') # remove only subfolder, keep rest of original source
      else
        source
      end
    end

    def subfolder(source)
      clean = clean_notation(source)
      parts = clean.split('//')
      if parts.size == 2 # has subfolder
        remove_ref_notation(parts.last)
      end
    end

    def ref(source)
      url = clean_notation(source)
      uri = URI(url)
      if uri.query
        params = URI::decode_www_form(uri.query).to_h # if you are in 2.1 or later version of Ruby
        params['ref']
      end
    end


    def clean_notation(source)
      clean = source
        .sub(/.*::/,'')            # remove git::
        .sub(%r{http[s?]://},'')   # remove https://
        .sub(%r{git@(.*?):},'')    # remove git@word
      remove_host(clean)
    end

    def remove_host(clean)
      return clean unless clean.include?('ssh://')
      if clean.count(':') == 1
        uri = URI(clean)
        uri.path
      else
        clean.split(':').last
      end
    end
  end
end
