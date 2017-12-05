module Idcf
  module Cli
    module Error
      # api error
      class ApiError < StandardError
        attr_reader :responce

        def initialize(res)
          @responce = res
        end

        def status
          responce.status
        end

        def message
          msg = super
          return msg unless msg.empty?
          responce.body.to_param
        end

        def body
          responce.body
        end

        def headers
          responce.headers
        end
      end
    end
  end
end
