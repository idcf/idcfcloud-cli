require_relative './base'
module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # filter fields
          class FieldFilter < Base
            MSG_NO_TARGETS = '[fields][%s] is not found.'.freeze

            # filter
            #
            # @param data [Hash]
            # @param condition [String]
            # @return Hash
            def filter(data, condition)
              return data if condition.empty?
              cli_error(MSG_NO_DATA) unless [Array, Hash].include?(data.class)
              return extraction(data, condition) if data.class == Hash

              recursion(data, condition)
            end

            protected

            def recursion(values, condition)
              return values unless values.class == Array
              [].tap do |result|
                values.each do |data|
                  case data
                  when Array
                    result << recursion(data, condition)
                  when Hash
                    result << extraction(data, condition)
                  else
                    cli_error(MSG_NO_DATA)
                  end
                end
              end
            end

            def extraction(data, condition)
              check_extraction(data, condition)
              {}.tap do |result|
                condition.split(',').each do |key|
                  next if key.empty?

                  val = data[key]
                  if @options[:table_flag]
                    result[key] = [Array, Hash].include?(val.class) ? val.to_s : val
                    next
                  end
                  result[key] = val
                end
              end
            end

            def check_extraction(data, condition)
              no_targets = []
              condition.split(',').each do |key|
                next if key.empty?
                no_targets << key unless data.key?(key)
              end

              return nil if no_targets.empty?
              cli_error(MSG_NO_TARGETS % no_targets.join(','))
            end
          end
        end
      end
    end
  end
end
