require_relative './base'

module Idcf
  module Cli
    module Controller
      # Your
      class Your < Base
        default_command :help

        class << self
          def description
            'Your Service'
          end
        end

        protected

        def make_table_data(data)
          data['data']
        end

        def make_field_data(data)
          make_table_data(data)
        end
      end
    end
  end
end
