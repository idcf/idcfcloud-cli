require_relative './base'
require 'idcf/faraday_middleware/cdn_signature'

module Idcf
  module Cli
    module Controller
      # CDN
      class Cdn < Base
        default_command :help

        class << self
          def description
            'Contents Cache Service'
          end
        end

        protected

        # signeture
        #
        # @return String
        def signature
          Idcf::FaradayMiddleware::CdnSignature
        end

        # raise api error msg
        #
        # @param res [Faraday::Responce]
        # @return [String]
        def raise_api_error_msg(res)
          "HTTP status code: #{res.status}, " \
            "Error message: #{res.body['messages']}, "
        end
      end
    end
  end
end
