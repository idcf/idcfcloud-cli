require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/conf/const'

module Idcf
  module Cli
    module Controller
      module Include
        # validate methods
        module Validate
          protected

          # validate do
          #
          # @param o [Hahs]
          # @return Hash or nil
          def do_validate(o)
            err = first_validate(o)
            return nil if err.empty?
            make_validation_error(err)
          end

          # first validate
          #
          # @param o [Hash] options
          # @return Hash or nil
          def first_validate(o)
            validator = make_validate(o, @cmd)
            validator.valid? ? [] : validator.errors.messages
          end

          # make validate
          #
          # @paeram o [Hash] options
          # @param command [String]
          # @return ActiveModel
          def make_validate(o, command)
            service = self.class.to_s.underscore.split('/').pop
            path    = Idcf::Cli::Conf::Const::VALIDATOR_DIR_PATH
            paths   = [
              "#{path}/#{service}/#{command}",
              "#{path}/#{service}/base",
              "#{path}/base"
            ]
            load_validate(paths, o)
          end

          def load_validate(paths, o)
            paths.each do |path|
              begin
                require path
                return path.classify.constantize.new(o)
              rescue LoadError
                next
              end
            end
            raise Idcf::Cli::CliError, 'Validate load error'
          end

          # make validation error
          #
          # @override
          # @param errors [Hash]
          # @return Hash
          def make_validation_error(errors)
            err = {}
            errors.each do |k, v|
              err[k] = "#{Idcf::Cli::Conf::Const::LOCAL_ERROR_PREFIX}#{v}"
            end
            result           = make_base_response
            result[:status]  = 400
            result[:message] = err
            result
          end
        end
      end
    end
  end
end
