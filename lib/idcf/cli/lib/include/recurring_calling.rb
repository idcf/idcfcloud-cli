module Idcf
  module Cli
    module Lib
      module Include
        # Recurring calling
        module RecurringCalling
          # recurring calling
          #
          # @param call_name [String]
          # @param args [Array]
          # @param max [int] loop_count
          # @param sleep_offset [int]
          # @param &block [Proc] check return value
          # @return Mixed
          def recurring_calling(call_name, args, max = 20, sleep_offset = 2)
            (1..max).each do |n|
              res = __send__(call_name.to_sym, *args)
              return res if yield(res)
              sleep sleep_offset * n
            end
            raise Idcf::Cli::Error::CliError, 'Authentication time out '
          end
        end
      end
    end
  end
end
