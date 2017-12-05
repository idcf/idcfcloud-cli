require_relative './base'

module Idcf
  module Cli
    module Controller
      # DNS/GSLB
      class Dns < Base
        default_command :help

        class << self
          def description
            'DNS Service'
          end
        end
      end
    end
  end
end
