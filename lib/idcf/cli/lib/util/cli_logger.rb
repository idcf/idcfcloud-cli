require 'logger'
require 'idcf/cli/error/init'
require 'fileutils'
require 'idcf/cli/lib/configure'
require_relative 'cli_file'
module Idcf
  module Cli
    module Lib
      module Util
        # logger
        # level: shwo LOG_METHODS
        class CliLogger
          class << self
            attr_reader :logger, :current_path
            LOG_METHODS = %w(debug error fatal info unknown warn).freeze

            def log_instance
              return nil unless output_log?
              return logger unless logger.nil?
              path          = log_path
              @current_path = path
              Idcf::Cli::Lib::Util::CliFile.mkdir(path)

              Idcf::Cli::Lib::Util::CliFile.writable(path) if File.exist?(path)
              @logger      = Logger.new(path)
              logger.level = Idcf::Cli::Conf::Const::LOG_LEVEL
              logger
            end

            # open file delete
            def delete
              return nil unless output_log?
              path = log_path
              return nil unless File.exist?(path)
              File.unlink(path)
            end

            # logrotate file delete
            def cleaning(o)
              paths     = log_paths
              log_limit = Idcf::Cli::Lib::Configure.get_code_conf('log_limit', o).to_i
              return unless paths.size > log_limit
              paths.reverse[log_limit, paths.size].each do |f|
                File.unlink(f)
              end
            end

            def log_paths
              dir_path = File.expand_path('..', log_path)
              Dir.glob("#{dir_path}/#{Idcf::Cli::Conf::Const::LOG_FILE_PREFIX}*")
            end

            def respond_to_missing?(symbol, _include_prvate)
              LOG_METHODS.index(symbol.to_s) ? true : false
            end

            def method_missing(name, *args)
              return super unless LOG_METHODS.index(name.to_s)
              arg = [args[0]]
              arg << args[1] unless args[1].nil?
              add(name, *arg)
            end

            protected

            def output_log?
              conf = Idcf::Cli::Lib::Configure
              return false unless conf.get_user_conf('output_log').casecmp('y').zero?
              path = conf.get_user_conf('log_path')
              path.present?
            rescue => _e
              false
            end

            def log_path
              base_path = Idcf::Cli::Lib::Configure.get_user_conf('log_path')

              path = "#{base_path}/#{Idcf::Cli::Conf::Const::LOG_FILE_NAME}"
              File.expand_path(path)
            rescue => _e
              nil
            end

            def add(severity_name, data)
              return nil unless output_log?
              severity = "Logger::Severity::#{severity_name.upcase}".constantize
              log      = log_instance
              log.add(severity, data.to_s)
            end
          end
        end
      end
    end
  end
end
