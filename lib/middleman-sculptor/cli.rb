require 'middleman-core/cli'

require 'middleman-sculptor/cli/version'
require 'middleman-sculptor/cli/init'
# require 'middleman-sculptor/cli/server'

module Middleman::Sculptor::Cli
  class Base < Thor
    @@middleman_classes = []

    def self.exit_on_failure?
      true
    end

    def self.add_middleman_task(klass)
      klass.namespace "sculptor_#{klass.namespace}"
      @@middleman_classes << klass
    end

    add_middleman_task Middleman::Cli::Server

    def help(meth=nil, subcommand=false)
      if meth && !self.respond_to?(meth)
        klass, task = Thor::Util.find_class_and_task_by_namespace("sculptor_#{meth}:#{meth}")
        klass.start(['-h', task].compact, shell: shell)
      else
        list = []
        sculptor_classes = Thor::Util.thor_classes_in(Middleman::Sculptor::Cli)
        classes = @@middleman_classes + sculptor_classes
        classes.each do |thor_class|
          list += thor_class.printable_tasks(false)
        end
        list.sort! { |a, b| a[0] <=> b[0] }

        shell.say 'Tasks:'
        shell.print_table(list, indent: 2, truncate: true)
        shell.say
      end
    end

    # Intercept missing methods and search subtasks for them
    # @param [Symbol] meth
    def method_missing(meth, *args)
      meth = meth.to_s
      meth = self.class.map[meth] if self.class.map.key?(meth)

      klass, task = Thor::Util.find_class_and_task_by_namespace("sculptor_#{meth}:#{meth}")

      if klass.nil?
        raise Thor::Error, "Command '#{meth}' not found. Try 'middleman-sculptor help' for a list of commands."
      else
        args.unshift(task) if task
        klass.start(args, shell: shell)
      end
    end
  end
end
