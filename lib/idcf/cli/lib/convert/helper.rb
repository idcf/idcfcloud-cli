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
          FILTER_OPTION = [:json_path, :fields].freeze

          # data convert
          #
          # @param data [Hash]
          # @param err_f [Boolean]
          # @param f [String] format
          # @return String
          def format(data, err_f, f)
            cls_load("Formatter::#{f.classify}Format").new.format(data, err_f)
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

          # data convert
          #
          # @param data [Hash]
          # @param o [Hash] format
          # @param table_flag [Boolean]
          # @return Hash
          def filter(data, o, table_flag)
            return data unless [Hash, Array].include?(data.class)
            result = data.deep_dup
            FILTER_OPTION.each do |k|
              next if o[k].nil? || o[k].empty?
              fo = {
                table_flag: table_flag
              }
              result = cls_load("Filter::#{k.to_s.classify}Filter").new(fo).filter(result, o[k])
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
