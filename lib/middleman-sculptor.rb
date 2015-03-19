require 'middleman-core'
require 'middleman-sculptor/hash_dot_syntax'
require 'middleman-sculptor/cli'
require 'middleman-sculptor/resource_patch'

begin
  require "middleman-sculptor/template"
rescue LoadError
  # v4
end

::Middleman::Extensions.register(:sculptor) do
  require 'middleman-sculptor/extension'
  ::Middleman::SculptorExtension
end
