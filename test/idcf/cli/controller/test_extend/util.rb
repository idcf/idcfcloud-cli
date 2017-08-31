module Idcf
  module Cli
    module Controller
      module TestExtend
        # test code utils
        module Util
          protected

          # make unique name
          #
          # @param base_name [String]
          # @param attributes [Array]
          # @param p_name [String] parameter name
          # @return [String]
          def make_unique_name(base_name, attributes, p_name = 'name')
            result = base_name
            loop do
              name = "#{result}#{rand(0..1000)}"
              flg = false
              if attributes.class == Array
                attributes.each do |v|
                  flg = true if v[p_name] == name
                end
              end

              unless flg
                result = name
                break
              end
            end
            result
          end

          # pickup same item
          # Edit confirmation
          #
          # @param a [Mixed] Hash or Array
          # @param b [Mixed] Hash or Array
          # @return [Mixed] Hash or Array
          def pickup_same_item(a, b)
            result = nil
            if a.class == Hash
              result = {}
              a.each do |k, v|
                t_val = b[k]
                next if t_val.nil?
                result[k] = pickup_same_item_val(v, t_val)
              end
            elsif a.class == Array
              result = []
              a.each_index do |k|
                t_val = b[k]
                next if t_val.nil?
                result << pickup_same_item_val(a[k], t_val)
              end
            end

            result
          end

          def pickup_same_item_val(a, b)
            if b.class == Hash || b.class == Array
              pickup_same_item(a, b)
            else
              b
            end
          end
        end
      end
    end
  end
end
