require 'middleman-core/cli'

module Middleman::Cli
  class Init < Thor
    def init(name='.')
      key = :sculptor
      unless ::Middleman::Templates.registered.key?(key)
        raise Thor::Error, "Unknown project template '#{key}'"
      end

      thor_group = ::Middleman::Templates.registered[key]
      thor_group.new([name], options).invoke_all
    end
  end
end
