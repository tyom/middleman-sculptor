require 'middleman-core'

::Middleman::Extensions.register(:sculptor) do
  require 'middleman-sculptor/extension'
  ::Middleman::SculptorExtension
end
