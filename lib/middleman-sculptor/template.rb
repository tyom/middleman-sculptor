require 'middleman-core/templates'

module Middleman
  module Sculptor
    class Template < Middleman::Templates::Base
      class_option 'css_dir', default: 'assets/styles'
      class_option 'js_dir', default: 'assets/scripts'
      class_option 'images_dir', default: 'assets/images'

      def self.source_root
        File.join(File.dirname(__FILE__), 'template')
      end

      def self.gemfile_template
        'Gemfile.tt'
      end

      def build_scaffold
        template 'config.tt', File.join(location, 'config.rb')
        copy_file '.gitignore', File.join(location, '.gitignore')
        copy_file '.editorconfig', File.join(location, '.editorconfig')
        copy_file 'Procfile', File.join(location, 'Procfile')
        copy_file 'package.json', File.join(location, 'package.json')
        copy_file 'webpack.config.js', File.join(location, 'webpack.config.js')

        directory 'source', File.join(location, 'source')
        directory 'data', File.join(location, 'data')
      end

      def run_npm
        run("cd #{location}; npm install")
      end
    end
  end
end

Middleman::Templates.register(:sculptor, Middleman::Sculptor::Template)
