require 'middleman-sprockets/extension'

module Middleman
  class SprocketsExtension < Extension
    def after_configuration
      ::Tilt.register ::Sprockets::EjsTemplate, 'ejs'
      ::Tilt.register ::Sprockets::EcoTemplate, 'eco'
      ::Tilt.register ::Sprockets::JstProcessor, 'jst'

      if app.respond_to?(:template_extensions)
        app.template_extensions :jst => :js, :eco => :js, :ejs => :js
      end

      if app.config.defines_setting?(:debug_assets) && !options.setting(:debug_assets).value_set?
        options[:debug_assets] = app.config[:debug_assets]
      end

      config_environment = @environment
      debug_assets = !app.build? && options[:debug_assets]
      @environment = ::Middleman::Sprockets::Environment.new(app, :debug_assets => debug_assets)
      config_environment.apply_to_environment(@environment)

      append_paths_from_gems
      import_images_and_fonts_from_gems

      # Setup Sprockets Sass options
      if app.config.defines_setting?(:sass)
        app.config[:sass].each { |k, v| ::Sprockets::Sass.options[k] = v }
      end

      # Intercept requests to /javascripts and /stylesheets and pass to sprockets
      our_sprockets = self.environment

      [app.config[:js_dir], app.config[:css_dir], app.config[:images_dir], app.config[:fonts_dir]].each do |dir|
        app.map("/#{dir}") { run our_sprockets }
      end

      # PATCH: Pass any `scripts` directory in `source` through Sprockets
      Dir.glob("#{app.root}/**/scripts").each do |dir|
        relative_dir = (dir.split('/') - (app.root.split('/') << app.source)).join('/')
        if app.config[:js_dir] != relative_dir
          our_sprockets.append_path(dir) # Append custom JS path into our sprockets path
          app.map("/#{relative_dir}") { run our_sprockets }
        end
      end
    end
  end
end
