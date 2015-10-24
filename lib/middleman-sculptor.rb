require 'middleman-core'
require 'middleman-sculptor/hash_dot_syntax'
require 'middleman-sculptor/cli'
require 'middleman-sculptor/resource_patch'
require 'middleman-sculptor/sprockets_patch'

::Middleman::Extensions.register(:sculptor) do
  require 'middleman-sculptor/extension'
  ::Middleman::SculptorExtension
end
