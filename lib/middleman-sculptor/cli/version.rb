require 'middleman-sculptor/version'

module Middleman::Sculptor::Cli
  class Version < Thor
    namespace :sculptor_version

    desc 'version', 'Show version'
    def version
      say "Sculptor #{Middleman::Sculptor::VERSION} (Middleman #{Middleman::VERSION})"
    end
  end
end
