require 'rest-client'
require 'oj'

module Middleman::Sculptor
  module Helpers
    module Resources
      def include_javascripts(javascripts)
        include_assets(:javascript_include_tag, javascripts)
      end

      def include_stylesheets(stylesheets)
        include_assets(:stylesheet_link_tag, stylesheets)
      end

      def resource_file(resource)
        resource.path.split('/').last.gsub(resource.ext, '')
      end

      def resource_dir(resource)
        resource.url.split('/').last
      end

      def resources_for(dir, ext: 'html', exclude_indexes: false, sort_by: nil, ignore: nil, allow_hidden: false)
        filtered = sitemap.resources
          .reject  {|r| r.url == dir}                      # Exclude main directory index
          .select  {|r| r.url.start_with?(dir)}            # Select files in the given dir

        collect_resources(filtered,
          { ext: ext, exclude_indexes: exclude_indexes, sort_by: sort_by, ignore: ignore, allow_hidden: allow_hidden}
        )
      end

      def resource_tree(dir, ext: 'html', data_fields: [:title], exclude_indexes: false, sort_by: nil, ignore: nil)
        resources_for(dir, ext: ext, exclude_indexes: exclude_indexes, sort_by: sort_by, ignore: ignore)
          .map { |r| parse_resource(r, {
              ext: ext,
              data_fields: data_fields,
              exclude_indexes: exclude_indexes,
              sort_by: sort_by,
              ignore: ignore
            })
          }
          .reject { |r| r[:parent] != '/' }  # Remove non-root directories from the root
      end

      def main_sections
        resources_for('/').select do |r|
          r if r.metadata.locals[:name]
        end
      end

      def local_data(path)
        current_path =  current_resource.path
        if current_resource.metadata.page.has_key? :local_url
          current_path = current_resource.metadata.page.local_url
        end
        result = sitemap.find_resource_by_path(relative_dir(current_path, path).to_s)
        raise "#{path} not found" unless result

        case result.ext
        when '.yaml', '.yml'
          result = YAML.load(result.render)
        when '.json'
          result = Oj.load(result.render)
        end

        result
      end

      # Use in layouts, in templates either Frontmatter or this method can be used
      def append_class(block_name, appended_classes='')
        current_page_classes = current_page.data[block_name] || ''
        existing_classes_a = current_page_classes.split(' ')
        appended_classes_a = appended_classes.split(' ')
        classes = existing_classes_a.concat(appended_classes_a).reverse.join(' ')
        content_for(block_name, classes)
      end

      def get(url, options = {})
        begin
          result = RestClient.get(url, options)
        rescue => e
          raise "GET - #{e.message}: '#{url}'"
        end

        Oj.load(result)
      end

      def post(url, params = {}, headers = {})
        begin
          result = RestClient.post(url, params, headers)
        rescue => e
          raise "POST - #{e.message}: '#{url}'"
        end

        Oj.load(result)
      end

      private

      def collect_resources(resources, options)
        resources
          .select  {|r| r.ext == ".#{options[:ext]}"}      # Select only files with specified extension
          .sort_by {|r| r.url }                            # Sort by url (default)
          .sort_by {|r| r.data[options[:sort_by]] || -1}   # Sort by `sort_by` param
          .reject  {|r|                                    # Reject hidden (Front matter)
            r.data.hidden unless options[:allow_hidden]
          }
          .reject  {|r|                                    # Exclude all directory indexes
            options[:exclude_indexes] ? r.directory_index? : false
          }
          .reject  {|r| ignore ? r.url.match(options[:ignore]) : false }  # Ignore URLs matching pattern (if provided)
          .reject  {|r| r.path.end_with? ("-isolated#{r.ext}")}         # Ignore proxied '-isolated' mode pages
          .reject  {|r| r.path.start_with? ("glyptotheque/")}             # Ignore Sculptor’s partials
      end

      def parse_resource(r, options)
        data = {}
        data[:path] = url_for("/#{r.path}")
        data[:url] = r.url

        # Add parent to top-level pages (not containing `/` in path)
        if /^((?!\/).)*$/.match r.path
          data[:parent] = '/'
        end

        if r.children.any?
          data[:children] = collect_resources(r.children, options).map { |c| parse_resource(c, options) }
          if r.parent
            data[:parent] = r.parent.url
          end
        end


        options[:data_fields].each do |field|
          data[field] = r.data[field]
          if field == :title && !r.data.title
            data[field] = resource_dir(r)
          end
        end
        data
      end

      def include_assets(asset_tag, assets)
        return unless assets
        assets = assets.split(/,\s*/) if assets.is_a? String
        resource_path = current_page.metadata && current_page.metadata.page[:local_url] || current_page.path
        Array(assets).map { |a|
          path = a.start_with?('http') ? a : relative_dir(resource_path, a)
          "\n" + method(asset_tag).call(path)
        }.join
      end

      # Constructs path relative to base path (first argument)
      def relative_dir(path, *args)
        relative_path = args ? args.join('/') : ''
        Pathname(path).dirname.join(relative_path)
      end
    end
  end
end
