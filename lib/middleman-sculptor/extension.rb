require 'middleman-sculptor/helpers/resources'
require 'middleman-sculptor/helpers/model'
require 'middleman-sculptor/helpers/outliner'

module Middleman
  class SculptorExtension < Extension
    self.defined_helpers = [
      Middleman::Sculptor::Helpers::Resources,
      Middleman::Sculptor::Helpers::Model,
      Middleman::Sculptor::Helpers::Outliner
    ]
  end
end
