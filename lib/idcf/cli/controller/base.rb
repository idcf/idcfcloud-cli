require 'thor'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/conf/const'
require 'idcf/cli/lib/convert/helper'
require 'idcf/json_hyper_schema'
require 'idcf/json_hyper_schema/expands/link_info_base'
require 'idcf/cli/gem_ext/idcf/json_hyper_schema/expands/link_info_base_extension'
require_relative './extend/init'
require_relative './include/init'
require 'jsonpath'
require 'idcf/cli/lib/include/recurring_calling'

module Idcf
  module Cli
    module Controller
      # Controller Base
      class Base < Thor
        class_option :output,
                     type:    :string,
                     aliases: '-o',
                     desc:    'output type: table/json/xml/csv'
        class_option :profile,
                     type: :string,
                     desc: 'use profile'
        class_option :api_key,
                     type: :string,
                     desc: 'api key'
        class_option :secret_key,
                     type: :string,
                     desc: 'secret key'
        class_option :no_ssl,
                     desc: 'not use ssl'
        class_option :no_vssl,
                     desc: 'not use verify ssl'
        class_option :json_path,
                     desc: 'data filter json_path'
        class_option :fields,
                     desc: 'field filter'

        attr_reader :config, :code_conf, :cmd, :m_classes

        extend Idcf::Cli::Controller::Extend::Init
        include Idcf::Cli::Controller::Include::Init
        include Idcf::Cli::Lib::Include::RecurringCalling

        class << self
          attr_accessor :links

          def init(argv)
            o = Thor::Options.new(class_options).parse(argv)
            register_schema_method(o)

            make_module_classes.each do |cn, c|
              register_module_method!(cn, c)
            end
          end

          def register_schema_method(o)
            path = make_schema_path(o)

            return nil unless File.exist?(path)

            analyst = Idcf::JsonHyperSchema::Analyst.new
            @links  = analyst.load(path).links
            @links.each do |link|
              register_schema_method_by_link!(link)
            end
          end

          # service name
          #
          # @return String
          def service_name
            name.underscore.split('/').last
          end

          # service version
          #
          # @param o [Hash]
          # @return String
          def service_version(o)
            sn     = service_name
            list   = Idcf::Cli::Lib::Configure.get_code_conf(sn, o)
            result = o[:version].nil? ? list.keys.last : o[:version]
            msg    = "not found input version[#{o[:version]}]"
            raise Idcf::Cli::Error::CliError, msg unless list.keys.include?(result)
            result
          end
        end

        protected

        def execute(cmd, *args)
          data = run(cmd, args, options)
          puts make_result_str(data, false, options)
          Idcf::Cli::Lib::Util::CliLogger.delete
          Idcf::Cli::Lib::Util::CliLogger.cleaning(options)
        rescue => e
          self.class.error_exit(e)
        end

        def run(cmd, args, o)
          @cmd = cmd
          data = do_validate(o)
          raise Idcf::Cli::Error::CliError, data[:message].flatten if data

          data = make_result_data(do_command(cmd, *args, o), o)
          data
        end

        # do command
        #
        # @param cmd [String]
        # @param *args [Array]
        # @param o [Hash]
        # @return Mixed
        # @raise
        def do_command(cmd, *args, o)
          self_class = self.class
          s_class    = self_class.search_module_class(cmd)

          arg    = convert_arg_json(*args)
          client = make_client(o, self_class.get_region(o))
          api    = Idcf::Cli::Lib::Api.new(links: self_class.links, client: client)
          return do_service(s_class, api, o, arg) unless s_class.nil?
          do_api(cmd, api, o, arg)
        end

        # do service
        #
        # @param service_class [Idcf::Cli::Service::Base]
        # @param api [Idcf::Cli::Lib::Api]
        # @param arg [Array]
        # @param o [Hash]
        # @return Mixed
        # @raise
        def do_service(service_class, api, o, arg)
          obj = service_class.new
          obj.between_param?(arg.size)
          result = obj.do(api, o, *arg)
          return result if obj.last_command.empty?
          do_api(obj.last_command, api, o, obj.last_command_args)
        end

        # do api
        #
        # @param cmd [String]
        # @param api [Idcf::Cli::Lib::Api]
        # @param arg [Array]
        # @param o [Hash]
        # @return Mixed
        # @raise
        def do_api(cmd, api, o, arg)
          result      = api_result(api.do(cmd, *arg))
          link        = api.find_link(cmd)
          resource    = link.async? ? do_async(api, result, o, link) : nil
          sync_result = api.result_api(cmd, arg, result, async_id(resource))
          return sync_result if sync_result
          link.async? ? resource : result
        rescue Idcf::Cli::Error::ApiError => e
          raise e, raise_api_error_msg(e)
        end

        def api_result(val)
          val
        end

        def async_id(resource)
          return resource['resource_id'] if !resource.nil? && resource.class == Hash
          nil
        end

        # do_async
        #
        # @param _api [Idcf::Cli::Lib::Api]
        # @param _api_result [Mixed]
        # @param _o [Hash]
        # @param _executed_link [Idcf::JsonHyperSchema::Expands::LinkInfoBase]
        # @result Mixed
        def do_async(_api, _api_result, _o, _executed_link)
          nil
        end

        # raise api error msg
        #
        # @param res [Faraday::Responce]
        # @return [String]
        def raise_api_error_msg(res)
          "HTTP status code: #{res.status}, " \
            "Error message: #{res.body['message']}, " \
            "Reference: #{res.body['reference']}"
        end

        def make_result_data(data, o)
          format     = output_format(o, '')
          table_flag = %w(csv table).include?(format)
          helper     = Idcf::Cli::Lib::Convert::Helper.new

          if helper.filter_target?(o)
            result = helper.filter(data, o, table_flag)
          elsif table_flag
            result = make_table_data(data)
          else
            result        = make_base_response
            result[:data] = data
          end
          result
        end

        # table data
        # @param data [Hash]
        # @return Hash
        def make_table_data(data)
          data
        end
      end
    end
  end
end
