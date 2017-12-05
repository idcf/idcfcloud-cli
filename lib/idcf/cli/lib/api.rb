require 'idcf/cli/lib/util/cli_logger'
module Idcf
  module Cli
    module Lib
      # api execute class
      class Api
        attr_accessor :links, :client, :raw

        class << self
          # command str
          #
          # @param link
          # @return String
          def command_param_str(link)
            list = []
            link.url_param_names.each do |name|
              list << "<#{name}>"
            end

            if !link.query_param_names.size.zero? || !link.properties.size.zero?
              list << (param_required?(link) ? '<params>' : '[params]')
            end

            list.join(' ')
          end

          def param_required?(link)
            param_names = link.properties.keys
            get_names   = link.query_param_names
            link.required.each do |name|
              return true if param_names.include?(name) || get_names.include?(name)
            end
            false
          end
        end

        # initialize
        #
        # @param links [Array] in Idcf::JsonHyperSchema::Expands::LinkinfoBase
        # @param client [Faraday]
        def initialize(links: [], client: nil)
          @links  = links
          @client = client
        end

        # find link
        #
        # @param command [String]
        # @return Idcf::JsonHyperSchema::Expands::LinkInfoBase
        def find_link(command)
          result = nil
          @links.each do |link|
            if link.title.to_s == command.to_s
              result = link
              break
            end
          end
          result
        end

        # do
        #
        # @param command [String]
        # @param args [Array]
        # @return Hash
        # @raise
        def do(command, *args)
          args ||= []
          link = find_link(command)
          cli_error("Not found #{command} Api") if link.nil?

          between_param(link, args)
          @raw = do_api(link, args)
          result_log(@raw)

          return @raw.body if @raw.success?

          raise Idcf::Cli::Error::ApiError.new(@raw), ''
        end

        # result_api
        #
        # @param command [String]
        # @param args [Array]
        # @param api_result [Hash]
        # @param resource_id
        def result_api(command, args, api_result, resource_id = nil)
          link = find_link(command)
          cli_error("Not found #{command} Api") if link.nil?
          r_api_title = link.result_api_title
          return nil if r_api_title.empty?
          r_api_params = link.result_api_params(args, api_result, resource_id)
          self.do(r_api_title, *r_api_params)
        end

        protected

        def result_log(result)
          log = Idcf::Cli::Lib::Util::CliLogger
          log.info("result_headers: #{result.headers}")
          log.info("result_status: #{result.status}")
          log.info("result_body: #{result.body}")
        end

        # between link param
        #
        # @param link [Idcf::JsonHyperSchema::Expands::LinkInfoBase]
        # @param args
        # @raise
        def between_param(link, args)
          offset = (self.class.param_required?(link) ? 1 : 0)
          min    = link.url_param_names.size + offset
          max    = between_max(min, link)

          msg = format('Argument: %s', self.class.command_param_str(link))
          cli_error msg unless args.size.between?(min, max)
        end

        def between_max(min, link)
          offset     = 0
          required_f = self.class.param_required?(link)
          if !required_f && (link.properties.present? || link.query_param_names.present?)
            offset = 1
          end
          min + offset
        end

        def do_api(link, args)
          method         = link.method.downcase
          uri            = link.make_uri_for_cli(args)
          request_params = link.make_params_for_cli(args)

          log = Idcf::Cli::Lib::Util::CliLogger
          log.info("request_headers: #{@client.headers}")
          log.info("arguments: #{args.join(' ')}")
          log.info("uri: #{uri}")
          log.info("method: #{method}")
          log.info("request_params: #{request_params}")

          client_send(method, uri, request_params)
        end

        def client_send(method, uri, request_params)
          case method.to_s
          when 'get', 'delete'
            @client.__send__(method, uri, nil) do |req|
              if request_params.present?
                req.headers[:content_type]    = 'application/json'
                body                          = JSON.generate(request_params)
                req.headers['Content-Length'] = body.size.to_s
                req.body                      = body
              end
            end
          else
            @client.__send__(method, uri, request_params)
          end
        end

        def cli_error(msg)
          raise Idcf::Cli::Error::CliError, msg
        end
      end
    end
  end
end
