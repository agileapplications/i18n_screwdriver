module I18nScrewdriver
  class Translation < ActiveSupport::SafeBuffer
    attr_accessor :text, :options

    def self.new(text, options = {}, &block)
      super(I18n.translate(I18nScrewdriver.for_key(text), options)).tap do |translation|
        translation.text = text
        translation.options = options
        translation.linkify(block.binding, *block.call) if block
      end
    end

    def linkify(binding, *urls)
      context = binding ? eval('self', binding) : self
      keep_html_safety do
        gsub!(/<<.+?>>/).each_with_index do |text, index|
          context.instance_eval do
            link_to text[2..-3], *urls[index]
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

