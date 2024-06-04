require_relative './base'

module Idcf
  module Cli
    module Controller
      # autoscale
      class Autoscale < Base
        default_command :help

        class << self
          def description
            'Autoscale Service'
          end
        end
      end
    end
  end
end
