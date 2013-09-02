module I18nScrewdriver
  class Translation < String
    attr_accessor :text, :options

    def self.new(text, options = {}, &block)
      translation = super(options[:raw] ? text : I18n.translate(I18nScrewdriver.for_key(text), options))
      translation.text = text
      translation.options = options

      if block
        urls = Array(block.call)
        urls_to_interpolate_count = translation.scan(/<<.+?>>/).count
        raise ArgumentError, "too few urls specified" if urls.count < urls_to_interpolate_count
        if urls.count > urls_to_interpolate_count
          raise ArgumentError, "too many urls specified (#{urls.count} <> #{urls_to_interpolate_count})" unless urls.last.is_a?(Hash)
          translation = new(translation % urls.last, :raw => true)
        end
        translation.linkify(block.binding, urls)
      end

      translation
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

