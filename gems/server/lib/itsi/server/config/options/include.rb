module Itsi
  class Server
    module Config
      class Include < Option
        insert_text "include \"${1|other_file|}\" # Include another file to be loaded within the current configuration"

        detail "Include another file to be loaded within the current configuration"

        schema do
          Type(String) & Required()
        end

        def build!
          caller_location = caller_locations(2, 1).first.path
          included_file = \
            if caller_location =~ %r{lib/itsi/server}
              File.expand_path("#{@params}.rb")
            else
              File.expand_path("#{@params}.rb", File.dirname(caller_location))
            end

          location.instance_eval do
            @included ||= []
            @included << included_file

            if @auto_reloading
              if ENV["BUNDLE_BIN_PATH"]
                watch "#{included_file}", [%w[bundle exec itsi restart]]
              else
                watch "#{included_file}", [%w[itsi restart]]
              end
            end
          end

          code = IO.read(included_file)
          location.instance_eval(code, included_file, 1)
        end
      end
    end
  end
end
