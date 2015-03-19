require 'middleman-core/cli'

module Middleman::Sculptor::Cli
  class Init < Thor
    namespace :sculptor_init

    desc "init TARGET [options]", 'Create new sculpture TARGET'
    def init(name='.')
      p "Generating new project #{name}"
    end
  end
end
