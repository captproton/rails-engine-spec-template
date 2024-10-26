# lib/documentation_system/registry.rb
# frozen_string_literal: true

module DocumentationSystem
  class Registry
    def self.instance
      @instance ||= new
    end

    def self.clear
      @instance = new
    end

    def initialize
      @sections = {}
    end

    def register(name, content, position: :end)
      validate_section(name, content)
      @sections[name] = Section.new(content, position)
    end

    def get(name)
      @sections[name]
    end

    def features
      get(:features)&.content || []
    end

    def sections
      @sections
    end

    private

    def validate_section(name, content)
      raise ArgumentError, "Section name required" if name.nil? || name.empty?
      raise ArgumentError, "Content required" if content.nil?

      case name
      when :features
        validate_features(content)
      else
        validate_content(content)
      end
    end

    def validate_features(content)
      unless content.is_a?(Array)
        raise ArgumentError, "Features must be an array of strings"
      end

      unless content.all? { |item| item.is_a?(String) }
        raise ArgumentError, "All features must be strings"
      end
    end

    def validate_content(content)
      case content
      when String, Array
        true
      when Hash
        validate_section_hash(content)
      else
        raise ArgumentError, "Invalid content format"
      end
    end

    def validate_section_hash(content)
      required_keys = [:title, :content]
      missing_keys = required_keys - content.keys

      if missing_keys.any?
        raise ArgumentError, "Missing required keys: #{missing_keys.join(', ')}"
      end

      unless content[:title].is_a?(String)
        raise ArgumentError, "Section title must be a string"
      end

      unless content[:content].is_a?(String)
        raise ArgumentError, "Section content must be a string"
      end
    end
  end
end
