require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestJob < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            job: {}
          )

          def test_list_jobs_sccess(data)
            jobs = do_command(:list_jobs, data)
            assert_equal(jobs.empty?, false)
          end

          data(
            job: {}
          )

          def test_get_job_sccess(_data)
            jobs = do_command(:list_jobs)
            job = jobs.first
            result = do_command(:get_job, job['id'])
            check = pickup_same_item(job, result)
            assert_equal(check, job)
          end

          data(
            del_success:
              {
                method: 'DELETE',
                job_status: 'Success'
              },
            post_success:
              {
                method: 'POST',
                job_status: 'Success'
              },
            patch_success:
              {
                method: 'PATCH',
                job_status: 'Success'
              },
            put_success:
              {
                method: 'PUT',
                job_status: 'Success'
              }
          )

          def test_check_job_success(data)
            jobs = do_command(:list_jobs)
            job = {}
            jobs.each do |j|
              n_flg = false
              data.each do |dk, dv|
                n_flg = true unless dv == j[dk.to_s]
              end

              next if n_flg
              job = j
              break
            end
            return output_skip_info('not job') if job.empty?

            result = do_command(:check_job, job['id'], {}, [], false)
            result = result.nil? ? true : result
            assert(result)
          end

          data(
            del_failed:
              {
                method: 'DELETE',
                job_status: 'Failed'
              },
            post_failed:
              {
                method: 'POST',
                job_status: 'Failed'
              },
            patch_failed:
              {
                method: 'PATCH',
                job_status: 'Failed'
              },
            put_failed:
              {
                method: 'PUT',
                job_status: 'Failed'
              }
          )

          def test_check_job_error(data)
            jobs = do_command(:list_jobs)
            job = {}
            jobs.each do |j|
              n_flg = false
              data.each do |dk, dv|
                n_flg = true unless dv == j[dk.to_s]
              end

              next if n_flg
              job = j
              break
            end
            return output_skip_info("not job #{data}") if job.empty?

            assert_throw(:done) do
              begin
                do_command(:check_job, job['id'], {}, [], false)
              rescue
                throw(:done)
              end
            end
          end

          data(
            job: {}
          )

          def test_jobs(_data)
            result = do_command(:jobs)
            refute(result.empty?)
          end
        end
      end
    end
  end
end
