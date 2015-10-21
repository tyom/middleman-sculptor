# require 'middleman-core/sitemap/resource'
# # This method is patched to make Middleman output the correct path
# # when rendering multiple pages via proxy
# module Middleman
#   module Sitemap
#     class Resource
#       # Render this resource
#       # @return [String]
#       def render(opts={}, locs={}, &block)
#         return app.template_data_for_file(source_file) unless template?
#
#         relative_source = Pathname(source_file).relative_path_from(Pathname(app.root))
#
#         instrument 'render.resource', path: relative_source, destination_path: destination_path  do
#           md   = metadata.dup
#           opts = md[:options].deep_merge(opts)
#
#           # Pass "renderer_options" hash from frontmatter along to renderer
#           if md[:page]['renderer_options']
#             opts[:renderer_options] = {}
#             md[:page]['renderer_options'].each do |k, v|
#               opts[:renderer_options][k.to_sym] = v
#             end
#           end
#
#           locs = md[:locals].deep_merge(locs)
#
#           # Forward remaining data to helpers
#           app.data.store('page', md[:page]) if md.key?(:page)
#
#           blocks = Array(md[:blocks]).dup
#           blocks << block if block_given?
#
#           # PATCH
#           # reset app.current_path to current resource on each render
#           # so that a prerendered resource has the correct mappings to original resource
#           app.current_path = destination_path
#
#           # Certain output file types don't use layouts
#           unless opts.key?(:layout)
#             opts[:layout] = false if %w(.js .json .css .txt).include?(ext)
#           end
#
#           app.render_template(source_file, locs, opts, blocks)
#         end
#       end
#     end
#   end
# end
