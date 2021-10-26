module I18nScrewdriver
  class Translation < String
    Error = Class.new(StandardError)

    attr_accessor :text, :options

    def self.new(text, **options, &block)
      translation = super(options[:raw] ? text : I18nScrewdriver.translate(text, **options))
      translation.text = text
      translation.options = options

      if block
        urls = Array(block.call)
        urls_to_interpolate_count = translation.scan(/<<.+?>>/).count
        emit_warning("invalid number of urls specified (#{urls.count} <> #{urls_to_interpolate_count})") unless urls.count == urls_to_interpolate_count
        translation.linkify(block.binding, urls)
      end

      translation
    end

    def self.emit_warning(message)
      raise Error, message unless ::Rails.env.production?
      ::Rails.logger.warn(%|I18nScrewdriver: #{message}\n#{application_frames(caller).join("\n")}|)
    end

    def self.application_frames(backtrace)
      backtrace.select{ |path| path.starts_with?(::Rails.root.to_s) }
    end

    def linkify(binding, urls)
      context = binding ? eval('self', binding) : self
      keep_html_safety do
        gsub!(/<<.+?>>/).each_with_index do |text, index|
          context.instance_eval do
            link_to(text[2..-3], *urls[index])
          end
        end
      end
    end

    private

    def keep_html_safety
      html_safe = @html_safe
      yield
      @html_safe = html_safe
      self
    end
  end
end
