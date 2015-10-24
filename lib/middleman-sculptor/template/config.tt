###################
# Page options, layouts, aliases and proxies
###################

# With alternative layout
page '/**',     layout: 'glyptotheque'
# With no layout
page "/glyptotheque/*", layout: false, directory_index: false
page '*.css',   layout: false
page '*.js',    layout: false
page '*.json',  layout: false

set :site_title, 'Styleguide'

ready do
  # Proxy default site index to Glyptotheque index template
  unless sitemap.find_resource_by_path '/index.html'
    proxy 'index.html', 'glyptotheque/site-index.html'
  end
  proxy 'sitemap.json', 'glyptotheque/sitemap.json'

  last_dir = nil
  # Prerender resources to populate models
  resources = resources_for('/', exclude_indexes: true, allow_hidden: true).each do |r|
    r.render
  end

  # Create mappings for isolated component pages (iframe embeddable)
  resources.each do |r|
    # Create virtual index files
    dir = File.dirname(r.path)
    index_exists = !!sitemap.find_resource_by_path("#{dir}/index.html")

    if last_dir != dir && !index_exists
      proxy "#{dir}/index.html", 'glyptotheque/directory-index.html', locals: {
        section: get_section_of_resource(r)
      }
      last_dir = dir
    end

    if r.metadata[:models]
      dir = File.dirname(r.path)
      r.metadata.models.each do |id, model|
        proxy "#{r.path.sub(r.ext, '')}-#{id}-isolated.html",
          r.path,
          layout: 'isolated',
          iframe: model.iframe,
          id: id,
          locals: {
            section: get_section_of_resource(r)
          }
      end
    end
  end
end

activate :sculptor
activate :syntax, css_class: 'codehilite'
activate :autoprefixer

###################
# Helpers
###################

# helpers do
# end

set :css_dir, 'assets/styles'
set :js_dir, 'assets/scripts'
set :images_dir, 'assets/images'

set :relative_links, true

Slim::Engine.disable_option_validator!
Slim::Engine.set_options pretty: true
Slim::Engine.set_options attr_list_delims: { '(' => ')', '[' => ']' }

# Development-secific configuration
configure :development do
  activate :livereload, no_swf: true
end

# Build-specific configuration
configure :build do
  compass_config do |config|
    config.sass_options = { :line_comments => false }
  end

  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###################
# Additional tasks
###################

# Simple launcher for local evaluation build
# Double click `build/launch.command` (Mac)
after_build do |builder|
  file = "#{build_dir}/launch.command"
  open(file, 'w') do |f|
    f << "#!/bin/bash\n"
    f << 'cd `dirname $0` && open "http://localhost:8000" && python -m SimpleHTTPServer'
  end
  File.chmod(0555, file)
end

# Middleman Deploy
activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end
