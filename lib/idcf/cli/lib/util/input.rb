module Idcf
  module Cli
    module Lib
      module Util
        # input
        class Input
          class << self
            # qa
            #
            # @param title [String]
            # @param setting [Hash]
            # @param nd [String]
            # @return [String]
            def qa(title, setting, nd = '')
              loop do
                v = qa_setting_list(setting)
                qa_puts_question(title, nd, v)
                result = qa_answer_input(v, nd)
                return result unless result.empty?
              end
            end

            # qa_answer_input
            #
            # @param list [Array]
            # @param nd [String]
            # @return [String]
            def qa_answer_input(list, nd = '')
              loop do
                res    = STDIN.gets.strip
                result = res.empty? ? nd : res
                return result if qa_answer?(result, list)
                puts "from this [#{list.join('/')}]"
                ''
              end
            end

            protected

            # qa_puts_question
            #
            # @param title [String]
            # @param nd [String]
            # @param set_list [Array]
            # @return nil
            def qa_puts_question(title, nd, set_list)
              set_s = set_list.blank? ? '' : "(#{set_list.join('/')})"
              puts "#{title}#{set_s}[#{nd.empty? ? 'NONE' : nd}]"
              nil
            end

            # qa_setting_list
            #
            # @param setting [Hash]
            # @return [Array]
            def qa_setting_list(setting)
              v = setting.class == Hash ? setting[:list] : nil
              v.nil? ? [] : v
            end

            # qa_answer?
            #
            # @param val [String]
            # @param list [Array]
            # @return [Boolean]
            def qa_answer?(val, list)
              return true if list.nil? || list.empty?
              return true if Regexp.new("\\A(#{list.join('|')})\\Z") =~ val
              false
            end
          end
        end
      end
    end
  end
end
