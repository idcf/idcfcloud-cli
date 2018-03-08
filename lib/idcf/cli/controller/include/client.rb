require 'idcf/faraday_middleware'

module Idcf
  module Cli
    module Controller
      module Include
        # client
        module Client
          protected

          # Create a new client
          #
          # @param o [Hash] other options
          # @param region [String]
          # @return [Response] Mixed
          def make_client(o, region)
            Faraday::Request.register_middleware(
              signature: signature
            )

            Faraday.new(url: make_host(o, region), ssl: make_ssl_option(o)) do |faraday|
              faraday_setting(faraday, o)
            end
          end

          # signeture
          #
          # @return String
          def signature
            Idcf::FaradayMiddleware::Signature
          end

          def make_host(o, region)
            protocol = o.key?(:no_ssl) ? 'http' : 'https'
            v = self.class.service_version(o)
            path     = "#{self.class.service_name}.#{v}.region.#{region}.host"
            host     = Idcf::Cli::Lib::Configure.get_code_conf(path, o)
            "#{protocol}://#{host}"
          end

          # ssl option
          #
          # @param o [Hash] options
          # @return Hash
          def make_ssl_option(o)
            { verify: o.key?(:no_vssl) ? false : true }
          end

          # setting
          #
          # @param faraday [Faraday]
          # @param o [Hash] options
          # @return Faraday
          def faraday_setting(faraday, o)
            prof = Idcf::Cli::Lib::Configure.get_profile(o)
            op   = {}
            %i[api_key secret_key].each do |v|
              op[v] = o.key?(v) ? o[v] : Idcf::Cli::Lib::Configure.get_user_conf(v.to_s, prof)
            end
            faraday.request(faraday_request)
            faraday.request(:signature, op)
            faraday.response(:json)
            faraday.adapter Faraday.default_adapter
            faraday_headers(faraday)
            faraday_options(faraday)
          end

          def faraday_request
            :json
          end

          def faraday_headers(faraday)
            Idcf::Cli::Conf::Const::HEADERS.each do |k, v|
              faraday.headers[k] = v
            end
            faraday
          end

          def faraday_options(faraday)
            faraday
          end
        end
      end
    end
  end
end
