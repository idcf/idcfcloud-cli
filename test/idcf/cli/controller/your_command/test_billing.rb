require_relative '../test_your'
require 'json'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        # initialize create
        class TestA < Idcf::Cli::Controller::TestYour
          self.test_order = :defined

          data(
            history:
              [
                'list_billing_history',
                [],
                {}
              ],
            detail:
              [
                'list_billing_detail',
                Time.now.strftime('%Y-%m'),
                {}
              ]
          )

          def test_do_sdk_success(data)
            options = {}
            client  = @target.send(:make_client, options)
            result  = @target.send(:do_sdk, client, *data)
            refute(result['meta'].empty?)
          end

          data(
            month_none:
              [
                'list_billing_detail',
                %w(),
                {}
              ],
            month_year:
              [
                'list_billing_detail',
                %W(#{Time.now.strftime('%Y')}),
                {}
              ],
            month_day:
              [
                'list_billing_detail',
                %W(#{Time.now.strftime('%Y-%m-%d')}),
                {}
              ]
          )

          def test_do_sdk_error(data)
            options = {}
            client  = @target.send(:make_client, options)
            assert_throw(:done) do
              begin
                @target.send(:do_sdk, client, *data)
              rescue
                throw(:done)
              end
            end
          end
        end
      end
    end
  end
end
