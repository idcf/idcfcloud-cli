module Idcf
  module Cli
    module Lib
      module Util
        # input
        class Input
          class << self
            def qa(title, setting, nd = '')
              loop do
                v     = setting.class == Hash ? setting[:list] : nil
                v     = v.nil? ? [] : v
                set_s = v.empty? ? '' : "(#{v.join('/')})"
                puts "#{title}#{set_s}[#{nd.empty? ? 'NONE' : nd}]"
                result = qa_answer_input(v, nd)
                return result unless result.empty?
              end
            end

            def qa_answer_input(list, nd = '')
              loop do
                res = STDIN.gets.strip
                result = res.empty? ? nd : res
                return result if qa_answer?(result, list)
                puts "from this [#{list.join('/')}]"
                ''
              end
            end

            protected

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
