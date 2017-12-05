require_relative '../base'

module Idcf
  module Cli
    module Service
      module Ilb
        # check_job
        class CheckJob < Idcf::Cli::Service::Base
          attr_reader :api

          class << self
            def description
              'Check job result'
            end
          end

          # do
          #
          # @param api [Idcf::Ilb::Lib::Api]
          # @param _o [Hash] options
          # @param job_id [String]
          def do(api, _o, job_id)
            @api = api
            job  = recurring_calling(:find, [job_id], &:present?)
            return nil if job['method'].casecmp('delete').zero?
            raise Idcf::Cli::Error::ApiError.new(@api.raw), 'Job Timeout.' if job.nil?
            true
          end

          protected

          def find(id)
            res = @api.do(:get_job, id)
            case res['job_status'].downcase
            when 'success'
              return res
            when 'failed'
              raise Idcf::Cli::Error::ApiError.new(@api.raw), 'API Failed.'
            end
            nil
          end
        end
      end
    end
  end
end
