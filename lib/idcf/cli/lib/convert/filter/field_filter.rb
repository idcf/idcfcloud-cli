require_relative './base'
module Idcf
  module Cli
    module Lib
      module Convert
        module Filter
          # filter fields
          class FieldFilter < Base
            MSG_NO_TARGETS = '[fields][%<field>s] is not found.'.freeze

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
              result = {}
              condition.split(',').each do |key|
                next if key.blank?

                val         = data[key]
                flg         = @options[:table_flag] && [Array, Hash].include?(val.class)
                result[key] = flg ? val.to_s : val
              end
              result
            end

            def check_extraction(data, condition)
              no_targets = []
              condition.split(',').each do |key|
                next if key.empty?
                no_targets << key unless data.key?(key)
              end

              return nil if no_targets.empty?
              cli_error(format(MSG_NO_TARGETS, field: no_targets.join(',')))
            end
          end
        end
      end
    end
  end
end
