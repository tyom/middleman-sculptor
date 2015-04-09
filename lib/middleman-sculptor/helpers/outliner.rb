require 'open-uri'
require 'nokogiri'

module Middleman::Sculptor
  module Helpers
    module Outliner
      def outline(&block)
        html = capture_html(&block)
        doc = Nokogiri::HTML.fragment(html, encoding='utf-8')

        elements = parse_elements(doc.children)

        partial('glyptotheque/model-outline', locals: { elements: elements })
      end

      private

      def parse_elements(elements)
        result = []

        elements.each do |e|
          text = e.xpath('text()').text

          next unless e.element?

          class_name = e.attributes['class'] && e.attributes['class'].value
          id = e.attributes['id'] && e.attributes['id'].value
          attributes = e.attributes.reject {|k| k == 'class' || k == 'id' }

          result << {
            el_name: e.name,
            class_name: class_name,
            id: id,
            attrs: attributes.values.map { |a| { name: a.name, value: a.value } },
            children: parse_elements(e.children),
            text: text
          }
        end

        return result
      end
    end
  end
end
