require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/template'
require_relative 'update_file'
require 'idcf/cli/lib/util/input'
module Idcf
  module Cli
    module Extend
      # update settings
      module Update
        protected

        include UpdateFile

        COMP_N = 'complement'.freeze

        def do_update(_o)
          s_schemas = schema_data_acquisition
          output_schema(s_schemas)
          output_complement
        end

        def output_schema(s_schemas)
          s_schemas.each do |service, infos|
            infos.each do |version, regions|
              next if regions.nil? || regions.empty?
              regions.each do |region, schema|
                path = make_schema_file_path(service, version, region)
                output_complement_file(JSON.pretty_generate(schema), path)
              end
              output_default_schema(service, version, regions)
            end
          end
        end

        def output_default_schema(service, version, regions)
          return nil if regions.keys.include?('default')
          latist = latest_schema(regions.values)
          path   = make_schema_file_path(service, version, 'default')
          output_complement_file(JSON.pretty_generate(latist), path)
        end

        # get latest schema
        #
        # @param schemas [Array]
        # @return Hash or nil
        def latest_schema(schemas)
          result = nil
          v_str  = '$version'
          schemas.each do |data|
            result ||= data
            v1     = Gem::Version.create(data[v_str])
            v2     = Gem::Version.create(result[v_str])
            next unless v1 > v2
            result = data
          end
          result
        end

        def output_complement
          view = Idcf::Cli::Lib::Util::Template.new
          view.set('variables', make_script_variables)
          paths = {}
          Idcf::Cli::Conf::Const::COMP_PATHS.each do |k, _v|
            str      = view.fetch("#{k}/#{COMP_N}.erb")
            path     = "#{Idcf::Cli::Conf::Const::OUT_DIR}/#{COMP_N}.#{k}"
            paths[k] = File.expand_path(path)
            output_complement_file(str, paths[k])
          end

          output_notification(paths)
        end

        # output notification
        #
        # @param paths [Hash]
        def output_notification(paths)
          script = ENV['SHELL'].split('/').pop.to_sym
          return output_manual_writing(paths) if paths[script].nil?
          startup_script_qa(paths, script)
        end

        def startup_script_qa(paths, script)
          list = %w(y N)
          puts "Do you want to edit the startup script?(#{list.join('/')})"
          puts "[#{startup_script_path(script)}]"
          ans = Idcf::Cli::Lib::Util::Input.qa_answer_input(list)
          if ans == 'y'
            output_startup_script(script, paths)
          else
            output_manual_writing(paths)
          end
        end

        # startup script path
        #
        # @param script [String]
        # @return String
        def startup_script_path(script)
          File.expand_path(Idcf::Cli::Conf::Const::COMP_PATHS[script])
        end

        # output start script
        #
        # @param paths [Hash]
        def output_startup_script(script, paths)
          s_script_path = startup_script_path(script)
          write_str     = "source #{paths[script]}"

          if write_path?(s_script_path, write_str)
            File.open(s_script_path, 'a') do |f|
              f.puts write_str, ''
            end
          end

          puts 'Run the following command:', write_str
        end

        # write path?
        #
        # @param path [String] setting path
        # @param check_str
        # @return Boolean
        # @raise
        def write_path?(path, check_str)
          if File.exist?(path)
            Idcf::Cli::Lib::Util::CliFile.writable(path)
            return !write_line_str_exist?(path, check_str)
          end

          Idcf::Cli::Lib::Util::CliFile.writable(File.expand_path('..', path))
          true
        end

        # write line str exist?
        #
        # @param path [String] setting path
        # @param check_str
        # @return Boolean
        # @raise
        def write_line_str_exist?(path, check_str)
          File.open(path, 'r') do |f|
            f.each_line do |line|
              return true if line.strip == check_str
            end
          end
          false
        end

        # manual write
        #
        # @param paths [Hash]
        def output_manual_writing(paths)
          puts 'please write in'
          Idcf::Cli::Conf::Const::COMP_PATHS.each do |k, v|
            puts v, paths[k]
          end
        end

        def make_script_variables
          self.class.init({})
          make_flat_variables(self.class.subcommand_structure)
        end

        # bash 3.x
        #
        # @param list [Hash]
        # @param names [Array]
        # @return Hash
        def make_flat_variables(list, names = [])
          {}.tap do |result|
            name         = names.empty? ? 'top' : names.join('_')
            result[name] = list.keys
            list.each do |k, v|
              next unless v.class == Hash
              names << k
              result.merge!(make_flat_variables(v, names))
              names.pop
            end
          end
        end

        def extract_commands(thor_class, commands)
          thor_class.commands.keys.each do |k_c|
            commands << k_c if commands.index(k_c).nil?
          end

          commands.sort
        end

        def extract_command_infos(t_class, s_name, infos)
          commands = []
          return extract_commands(t_class, commands) if infos[s_name].nil?
          infos[s_name].keys.each do |name|
            commands << name.to_s
          end
          extract_commands(t_class, commands)
        end
      end
    end
  end
end
