module Idcf
  module JsonHyperSchema
    module Expands
      # Link Info Base ext
      module LinkInfoBaseExtension
        # is async
        #
        # @return Boolean
        def async?
          !!@data.data['$async']
        end

        # result api link title
        #
        # @return [String]
        def result_api_title
          res = @data.data['$result']
          res && res['title'] ? res['title'] : ''
        end

        # result api params
        #
        # @params args [Array]
        # @params api_result [Hash]
        # @params resource_id [String]
        # @return [Array]
        def result_api_params(args, api_result, resource_id = nil)
          return [] if @data.data['$result'].nil?
          arg    = Marshal.load(Marshal.dump(args))
          target = @data.data['$result']['params']
          target = target.nil? ? [] : target
          raise Idcf::Cli::Error::CliError, 'params is not Array' unless target.class == Array
          result = make_result_api_params(target, arg, api_result, resource_id)
          result
        end

        def make_uri_for_cli(args)
          param_size = url_param_names.size
          url_params = args.slice(0, param_size)
          params     = args[param_size]
          make_uri(url_params, params)
        end

        def make_params_for_cli(args)
          make_params(args[url_param_names.size])
        end

        protected

        def make_result_api_params(target, args, api_result, resource_id)
          case target
          when Hash
            result_api_hash(target, args, api_result, resource_id)
          when Array
            result_api_array(target, args, api_result, resource_id)
          when String
            result_api_str(target, args, api_result, resource_id)
          else
            target
          end
        end

        def result_api_hash(target, args, api_result, resource_id)
          {}.tap do |result|
            target.each do |k, v|
              result[k] = make_result_api_params(v, args, api_result, resource_id)
            end
          end
        end

        def result_api_array(target, args, api_result, resource_id)
          [].tap do |result|
            target.each do |v|
              result << make_result_api_params(v, args, api_result, resource_id)
            end
          end
        end

        def result_api_str(target, args, api_result, resource_id)
          return resource_id if target == '#{resource_id}'
          result_api_str_regexp(target, args, api_result)
        rescue => e
          raise Idcf::Cli::Error::CliError, e.message
        end

        def result_api_str_regexp(target, args, api_result)
          result = target
          case target
          when Regexp.new('\A#\{(.+)\}\Z')
            result = args[url_param_names.index(Regexp.last_match(1))]
          when Regexp.new('\Aresult\[(.*)\]\Z')
            result = result_api_str_result(api_result, Regexp.last_match(1))
          end
          result
        end

        def result_api_str_result(data, path)
          result = data.deep_dup
          path.split('.').each do |k|
            case result
            when Array
              result = result[k.to_i]
            when Hash
              raise Idcf::Cli::Error::CliError, 'not found result key' unless result.key?(k)
              result = result[k]
            end
          end
          result
        end

        def make_query_params(param)
          {}.tap do |result|
            next unless param.class == Hash
            query_param_names.each do |k|
              result[k] = param[k] if param.key?(k)
              reg = Regexp.new("#{k}[\\.\\[].+")
              param.keys.each do |pk|
                result[pk] = param[pk] if (reg =~ pk).present?
              end
            end
          end
        end
      end
    end
  end
end

link_base = Idcf::JsonHyperSchema::Expands::LinkInfoBase
link_base.prepend(Idcf::JsonHyperSchema::Expands::LinkInfoBaseExtension)
