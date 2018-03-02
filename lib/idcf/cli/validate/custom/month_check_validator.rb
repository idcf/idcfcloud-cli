require 'active_model'
require 'idcf/cli/lib/util/option'
require 'ipaddr'

module Idcf
  module Cli
    module Validate
      module Custom
        # target validator
        class MonthCheckValidator < ActiveModel::EachValidator
          MESSAGES = {
            format:  'different format ex)YYYY-MM',
            invalid: 'An invalid date'
          }.freeze

          def validate_each(record, attr, val)
            str = MESSAGES[:format]
            return record.errors.add(attr, str, {}) unless format?(val)
            str = MESSAGES[:invalid]
            return record.errors.add(attr, str, {}) unless valid?(val)
          end

          protected

          def format?(val)
            !(val =~ /\A\d{4}-\d{1,2}\Z/).nil?
          end

          def valid?(val)
            Date.parse("#{val}-01")
            true
          rescue StandardError => _e
            false
          end
        end
      end
    end
  end
end
