require 'test/unit'
require 'idcf/cli/service/ilb/check_job'
require 'idcf/cli/controller/ilb'
require 'idcf/cli/lib/test_util/ilb'
require 'idcf/cli/lib/test_util/include/api_create'

module Idcf
  module Cli
    module Service
      module Ilb
        # test check job
        class TestCheckJob < Test::Unit::TestCase
          attr_reader :target, :lb

          include Idcf::Cli::Lib::TestUtil::Include::ApiCreate

          def setup
            @target = Idcf::Cli::Service::Ilb::CheckJob.new
            @lb     = Idcf::Cli::Lib::TestUtil::Ilb.new
          end

          def cleanup
            @target = nil
          end

          def ilb_class
            Idcf::Cli::Controller::Ilb
          end

          def list_jobs
            @lb.do_command(:list_jobs)[:data]
          end

          def find_job(status, del_f = false)
            list = list_jobs.select do |job|
              method_f = job['method'] != 'DELETE'
              method_f = job['method'] == 'DELETE' if del_f
              job['job_status'] == status && method_f
            end
            list.empty? ? nil : list.first
          end

          data(
            success: 'Success'
          )

          def test_do(data)
            job = find_job(data)
            api = make_api(ilb_class)
            o   = thor_options(ilb_class)

            return output_skip_info("not found #{data} job") if job.nil?
            assert(@target.__send__(:do, api, o, job['id']))
          end

          data(
            success: 'Success'
          )

          def test_do_delete(data)
            job = find_job(data, true)
            api = make_api(ilb_class)
            o   = thor_options(ilb_class)

            return output_skip_info("not found #{data} job") if job.nil?
            assert_equal(@target.__send__(:do, api, o, job['id']), nil)
          end

          data(
            failed:  {
              status:   'Failed',
              delete_f: false
            },
            failed2: {
              status:   'Failed',
              delete_f: true
            }
          )

          def test_not_success_do(data)
            job = find_job(data[:status], data[:delete_f])
            api = make_api(ilb_class)
            o   = thor_options(ilb_class)

            return output_skip_info("not found #{data[:status]} job") if job.nil?
            assert_throw(:done) do
              begin
                assert(@target.__send__(:do, api, o, job['id']))
              rescue StandardError => _e
                throw(:done)
              end
            end
          end
        end
      end
    end
  end
end
