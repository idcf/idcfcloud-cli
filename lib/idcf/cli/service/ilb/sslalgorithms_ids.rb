require_relative '../base'

module Idcf
  module Cli
    module Service
      module Ilb
        # sslalgorithms_ids
        class SslalgorithmsIds < Idcf::Cli::Service::Base
          class << self
            def description
              'Get a hash of sslalgorithm id array'
            end
          end

          # do
          #
          # @param api [Idcf::Ilb::Lib::Api]
          # @param _o [Hash] options
          def do(api, _o)
            list = api.do(:list_sslalgorithms).collect do |a|
              {
                id: a['id']
              }
            end

            {
              algorithms: list
            }
          end
        end
      end
    end
  end
end
