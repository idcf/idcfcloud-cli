require_relative './base'

module Idcf
  module Cli
    module Controller
      # ILB
      class Ilb < Base
        default_command :help

        class_option :region,
                     type:    :string,
                     aliases: '-r',
                     require: true,
                     desc:    'region: jp-east/jp-east-2/jp-west'

        class << self
          def description
            'ILB Service'
          end
        end

        protected

        def do_async(_api, api_result, o, _executed_link)
          job_id = api_result['job_id']
          return nil unless do_command('check_job', job_id, o)

          do_command('get_job', job_id, o)
        end
      end
    end
  end
end
