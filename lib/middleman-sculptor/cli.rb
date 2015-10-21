require 'middleman-cli'
require 'middleman-core/version'
require 'middleman-sculptor/version'

require 'thor'

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
          invoke ::Middleman::Cli::Init, [target], template: 'tyom/middleman-templates-sculptor#wip'
        end
      end
    end
  end
end
