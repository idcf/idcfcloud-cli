require 'thor'
require 'active_support'
require 'active_support/core_ext'
require_relative './version'
require 'idcf/cli/conf/const'
require 'idcf/cli/error/cli_error'
require_relative './validate/custom/init'
require_relative './gem_ext/thor/init_util'
require_relative './extend/init'

module Idcf
  module Cli
    # Index
    class Index < Thor
      @variables   = nil
      # command alias [alias] => [command]
      COMMAND_MAPS = {}.freeze

      include Idcf::Cli::Extend::Init

      class << self
        def init
          map COMMAND_MAPS
          sub_command_regist('controller', File.dirname(__FILE__))
        end
      end

      def initialize(*args)
        @variables = {}
        super(*args)
      end

      desc 'init', 'initialize'
      options global: true,
              profile: 'default'

      def init
        configure
        update
      rescue => e
        puts e.message
      end

      desc 'update', 'list update'

      def update
        do_update(options)
      rescue => e
        puts e.message
      end

      desc 'configure', 'create configure'
      options global: true,
              profile: 'default'

      def configure
        do_configure(options)
      rescue => e
        puts e.message
      end

      desc 'version', 'version string'

      def version
        puts "idcfcloud version #{Idcf::Cli::VERSION}"
      rescue => e
        puts e.message
      end
    end
  end
end
