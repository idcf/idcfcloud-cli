require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/lib/util/name'
require 'active_support/core_ext/string/inflections'

module Idcf
  module Cli
    module Lib
      module Convert
        # format helper
        class Helper
          FILTER_OPTION = %i[json_path fields].freeze

          # data convert
          #
          # @param data [Hash]
          # @param f [String] format
          # @return String
          def format(data, f)
            cls_load("Formatter::#{f.classify}Format").new.format(data)
          end

          # is filter target
          # @param o [Hash]
          # @return Boolean
          def filter_target?(o)
            FILTER_OPTION.each do |k|
              return true if !o[k].nil? && !o[k].empty?
            end
            false
          end

          # only filter
          #
          # @param o [Hash]
          # @return Boolean
          def only_filter_fields?(o)
            return false if o[:fields].nil?
            list = []
            FILTER_OPTION.each do |k|
              list << k if o[k].present?
            end
            list.count == 1
          end

          # data convert
          #
          # @param data [Hash]
          # @param o [Hash] format
          # @param table_flag [Boolean]
          # @return Hash
          def filter(data, o, table_flag)
            result = data.deep_dup
            FILTER_OPTION.each do |k|
              next if o[k].nil? || o[k].empty?
              fo = {
                table_flag: table_flag
              }
              result = cls_load("Filter::#{k.to_s.classify}Filter").new(**fo).filter(result, o[k])
            end
            result
          end

          protected

          def cls_load(path)
            cls = "#{Idcf::Cli::Lib::Util::Name.namespace(self.class.to_s)}::#{path}"
            require cls.underscore
            cls.constantize
          end
        end
      end
    end
  end
end
