require 'active_model'

module Idcf
  module Cli
    module Validate
      module Custom
        # require relation validator
        class RequireRelationValidator < ActiveModel::EachValidator
          MESSAGES = {
            message: 'A related parameter isn\'t input. (%<msg>s)'
          }.freeze

          def validate(record)
            return unless process?(record)

            nones = make_nones(record)
            return if nones.empty?

            msg = format(MESSAGES[:message], msg: nones.join('/'))
            record.errors.add(nones.first, msg, {})
          end

          protected

          def process?(record)
            list = []
            op   = options
            attributes.each do |attr|
              value = record.read_attribute_for_validation(attr)
              next if value.blank? && (op[:allow_nil] || op[:allow_blank])
              list << attr
            end

            list.present?
          end

          def make_nones(record)
            result = []
            attributes.each do |attr|
              value = record.read_attribute_for_validation(attr)
              result << attr if value.blank? || value == attr.to_s
            end

            result
          end
        end
      end
    end
  end
end
