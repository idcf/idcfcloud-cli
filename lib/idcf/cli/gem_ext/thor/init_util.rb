require 'idcf/cli/lib/util/cli_logger'
require 'idcf/cli/lib/util/name'

# Thor extention
class Thor
  class << self
    # Thor 0.19.4 ( https://github.com/erikhuda/thor/issues/244 )
    def exit_on_failure?
      true
    end

    # initialize settings
    def init
      # When initialization is needed, override.
    end

    # command description
    #
    # @return String
    def description
      raise Idcf::Cli::Error::CliError, 'Required Override'
    end

    # register sub command
    #
    # @param dir [String] underlayer path
    # @param parent_dir_path [Stirng]
    # @param arg [Hash] options
    # @return nil
    def sub_command_regist(under_path, parent_dir_path = '', arg = {})
      b_path = Idcf::Cli::Lib::Util::Name.namespace(name).underscore
      Dir.glob(parent_dir_path + "/#{under_path}/*.rb").each do |f|
        file_name = File.basename(f, '.*')
        next if file_name == 'base'

        command_regist file_name, "#{b_path}/#{under_path}/#{file_name}", arg
      end
    end

    # command regist
    #
    # @param command [String]
    # @param require_path [String]
    # @param o [Hash] options
    def command_regist(command, require_path, arg)
      require require_path

      class_const = require_path.classify.constantize
      class_const.init(arg)
      register class_const,
               command,
               "#{command_help_string(command)} [OPTION]",
               class_const.description
    end

    def command_help_string(command)
      result = [command]
      map.each do |k, v|
        result << k if v.to_s == command.to_s
      end
      result.join('/')
    end

    # module path
    #
    # @return String
    def module_path
      class_names = to_s.underscore.split('/')
      class_names.pop
      class_names.join('/')
    end

    def subcommand_structure
      {}.tap do |result|
        commands.each do |k, _v|
          result[k.to_s] = nil
        end
        result = subcommand_class_structure(result)

        map.each do |k, v|
          result[k.to_s] = result[v.to_s] unless result[v.to_s].nil?
        end
      end
    end

    def error_exit(e)
      STDERR.puts e.message
      Idcf::Cli::Lib::Util::CliLogger.error(e.message)
      Idcf::Cli::Lib::Util::CliLogger.cleaning(options)
      STDERR.puts "log path: #{Idcf::Cli::Lib::Util::CliLogger.current_path}"
      exit 1
    end

    protected

    def subcommand_class_structure(result)
      subcommand_classes.each do |k, v|
        commands       = v.subcommand_structure
        result[k.to_s] = nil
        result[k.to_s] = commands unless commands.empty?
      end
      result
    end
  end
end
