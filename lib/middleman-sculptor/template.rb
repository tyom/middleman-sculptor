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
        copy_file '.bowerrc', File.join(location, '.bowerrc')
        copy_file 'bower.json', File.join(location, 'bower.json')

        directory 'source', File.join(location, 'source')
        directory 'data', File.join(location, 'data')
      end

      def handle_bower
        # Install Bower if necessary
        run("command -v bower >/dev/null 2>&1 || npm install -g bower")
        # Install dependencies
        run("cd #{location}; bower install")
      end
    end
  end
end

Middleman::Templates.register(:sculptor, Middleman::Sculptor::Template)
