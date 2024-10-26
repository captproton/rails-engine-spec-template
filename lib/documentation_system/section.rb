# lib/documentation_system/section.rb
# frozen_string_literal: true

module DocumentationSystem
  class Section
    attr_reader :content, :position

    def initialize(content, position)
      @content = content
      @position = position
    end

    def to_s
      case content
      when Array
        content.join("\n")
      when Hash
        "#{content[:title]}\n\n#{content[:content]}"
      else
        content.to_s
      end
    end
  end
end
