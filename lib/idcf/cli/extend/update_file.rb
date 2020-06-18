require 'fileutils'
require 'idcf/cli/conf/const'
require 'open_uri_redirections'

module Idcf
  module Cli
    module Extend
      # update file
      module UpdateFile
        BROKEN_UPDATE_FILE = <<-TEXT.strip_heredoc.freeze
          The update file is damaged.
          Please consult with the administrator.
        TEXT
        BROKEN_JSON_SCHEMA = <<-TEXT.strip_heredoc.freeze
          Failed to verify the update file.
          Use the following commands to try updating the gem.

          # gem update idcfcloud
          # idcfcloud init
        TEXT

        protected

        def schema_data_acquisition
          {}.tap do |result|
            self.class.subcommand_classes.each do |s_name, cls|
              result[s_name] = service_schema_data_acquisition(cls)
            end
          end
        end

        def service_schema_data_acquisition(cls)
          {}.tap do |result|
            schema_file_paths(cls).each do |version, infos|
              result[version] = {}
              infos.each do |region, path|
                j = download_schema_file(path)
                update_data_check(j)
                result[version][region] = j
              end
            end
          end
        end

        def download_schema_file(path)
          d = file_load(path)
          JSON.parse(d)
        rescue StandardError => _e
          Idcf::Cli::Lib::Util::CliLogger.info("json format error:#{path}")
          raise Idcf::Cli::Error::CliError, BROKEN_UPDATE_FILE
        end

        def update_data_check(j)
          check_json_schema(j)
          check_api_version_format(j['$version'])
        end

        def check_json_schema(j)
          analyst = Idcf::JsonHyperSchema::Analyst.new
          analyst.schema_links(j)
        rescue StandardError => e
          Idcf::Cli::Lib::Util::CliLogger.info('json-schema format error')
          log_msg = "#{BROKEN_JSON_SCHEMA}:#{e.message}"
          Idcf::Cli::Lib::Util::CliLogger.error(log_msg)
          raise Idcf::Cli::Error::CliError, BROKEN_JSON_SCHEMA
        end

        def file_load(path)
          URI.open(path).read
        rescue StandardError => _e
          nil
        end

        def schema_file_paths(cls)
          {}.tap do |result|
            Idcf::Cli::Lib::Configure.get_code_conf(cls.service_name).each do |k, v|
              regions = {}
              v['region'].each_key do |region|
                target          = "#{cls.service_name}.#{k}.region.#{region}.schema"
                url             = Idcf::Cli::Lib::Configure.get_code_conf(target)
                regions[region] = create_schema_url(url)
              end

              result[k] = regions
            end
          end
        end

        def create_schema_url(path)
          href_regexp = Idcf::Cli::Conf::Const::FULL_HREF_REGEXP
          return path if path =~ href_regexp
          path = File.expand_path("../#{path}", Idcf::Cli::Conf::Const::BASE_PATH)
          return path if File.exist?(path)
          File.expand_path(path)
        end

        # check api version format
        #
        # @param v_str [String] version string
        # @return Boolean
        # @raise
        def check_api_version_format(v_str)
          msg = 'Please inform an administrator.'
          raise Idcf::Cli::Error::CliError, msg unless v_str =~ /\A\d+\.\d+\.\d+\Z/
          true
        end

        # make schema file path
        #
        # @param service [String]
        # @param version [String]
        # @param region [String]
        # @return String
        # @raise At a writing in right error
        def make_schema_file_path(service, version, region)
          b_dir    = schema_file_output_base_path
          ext      = Idcf::Cli::Conf::Const::CMD_FILE_EXT
          path     = "#{b_dir}/#{service}_#{version}_#{region}.#{ext}"
          cli_file = Idcf::Cli::Lib::Util::CliFile
          if File.exist?(path)
            cli_file.writable(path)
          else
            cli_file.writable(File.dirname(path))
          end
          path
        end

        def schema_file_output_base_path
          result = File.expand_path(Idcf::Cli::Conf::Const::CMD_FILE_DIR)
          FileUtils.mkdir_p(result) unless Dir.exist?(result)
          Idcf::Cli::Lib::Util::CliFile.writable(File.dirname(result))
          result
        end

        def output_yaml(s_name, data)
          dir  = Idcf::Cli::Conf::Const::CMD_FILE_DIR
          ext  = Idcf::Cli::Conf::Const::CMD_FILE_EXT
          path = "#{File.expand_path(dir)}/#{s_name}.#{ext}"
          write_file(path, data.to_yaml)
        end

        def output_complement_file(str, outpath)
          dir_path = File.dirname(outpath)
          cli_file = Idcf::Cli::Lib::Util::CliFile
          cli_file.mkdir(dir_path)
          cli_file.writable(dir_path)

          write_file(outpath, str)
        end

        def write_file(path, str)
          File.open(path, 'w', 0o755) do |f|
            f.puts(str)
          end
        end
      end
    end
  end
end
