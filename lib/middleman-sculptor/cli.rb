require 'thor'
require 'middleman-core/version'
require 'middleman-sculptor/version'
begin
  # v4
  require 'middleman-cli'
  $template_name = 'tyom/middleman-templates-sculptor#wip'
rescue LoadError
  require 'middleman-core/cli'
  require 'middleman-sculptor/template'
  $template_name = :sculptor
end

module Middleman
  module Sculptor
    module Cli
      class Base < Thor
        desc 'version', 'Show version'
        def version
          say "Sculptor #{Middleman::Sculptor::VERSION} (Middleman #{Middleman::VERSION})"
        end

        desc 'init', 'Initialize new Sculptor project'
        def init(target='.')
          invoke ::Middleman::Cli::Init, [:init, target], template: $template_name
        end
      end
    end
  end
end
