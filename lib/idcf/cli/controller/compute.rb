require_relative './base'
require 'idcf/faraday_middleware/cdn_signature'

module Idcf
  module Cli
    module Controller
      # compute
      class Compute < Base
        default_command :help

        class_option :region,
                     type:    :string,
                     aliases: '-r',
                     require: true,
                     desc:    'region: jp-east/jp-east-2/jp-west'

        class << self
          def description
            'Computeing Service'
          end
        end

        protected

        # signeture
        #
        # @return String
        def signature
          Idcf::FaradayMiddleware::ComputingSignature
        end

        def faraday_request
          :url_encoded
        end

        def faraday_options(faraday)
          faraday.options.params_encoder = Faraday::FlatParamsEncoder
          faraday
        end

        def make_table_data(data)
          return data unless data.class == Hash
          keys = data.keys
          return data unless keys.count == 2 && keys.include?('count')
          data.each do |k, v|
            return v unless k == 'count'
          end
          data
        end

        def make_field_data(data)
          make_table_data(data)
        end

        # raise api error msg
        #
        # @param res [Faraday::Responce]
        # @return [String]
        def raise_api_error_msg(res)
          body = api_result(res.body)
          "HTTP status code: #{res.status}, " \
          "Error message: #{body['errortext']}"
        end

        def api_result(val)
          val[val.keys.first]
        end

        def async_id(resource)
          return resource['jobid'] if !resource.nil? && resource.class == Hash
          nil
        end

        def do_async(api, api_result, _o, _executed_link)
          result = recurring_calling(:query_async, [api, async_id(api_result)], 24) do |res|
            api_result(res)['jobstatus'] != 0
          end
          result = api_result(result)
          result = result['jobresult'] if result.class == Hash
          return result if result.nil? || result['errorcode'].present?
          api_result(result)
        end

        def query_async(api, job_id)
          params = {
            'jobid' => job_id
          }
          api.do(:queryAsyncJobResult, params)
        end
      end
    end
  end
end
