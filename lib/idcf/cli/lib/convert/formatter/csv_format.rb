require_relative './base'
require 'csv'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # csv formatter
          class CsvFormat < Base
            def format(data, err_f)
              result = CSV.generate do |csv|
                scrape_line(data, err_f).each do |v|
                  csv << v
                end
              end

              result.strip
            end

            protected

            def scrape_line(data, err_f)
              list = scrape(data, err_f)
              return [] if list.size.zero?

              result  = []
              headers = make_header(list.first)
              result << headers
              push_list(list, headers, result)
            end

            def make_header(first_list)
              result = []
              if first_list.class == Hash
                first_list.each do |k, _v|
                  result << k
                end
              else
                result = [*(0..(first_list.size - 1))]
              end
              result
            end

            def push_list(list, headers, result)
              list.each do |v|
                col = []
                headers.each do |h|
                  col << v[h]
                end
                result << col
              end

              result
            end

            # scrape
            # @param data [Hash]
            # @param err_f [Boolean]
            # @return Array in Hash
            def scrape(data, err_f)
              return [flat_hash(data)] if err_f
              return [flat_hash(data)] if data.class == Hash
              return [[data]] unless data.class == Array

              two_dimensional(data)
            end

            # two dimensional
            # @param list [Array] One-dimensional [array or Hash List]
            # @return Array
            def two_dimensional(list)
              [].tap do |result|
                list.each do |v|
                  next if v.class == Array
                  unless v.class == Hash
                    result << [v]
                    next
                  end
                  result << flat_hash(v)
                end
              end
            end

            def flat_hash(data)
              {}.tap do |result|
                return {} unless data.class == Hash
                data.each do |k, v|
                  value = v
                  arr_f = v.class == Array || v.class == Hash
                  next if k != :message && arr_f
                  value            = flat(value) if arr_f
                  result[k.to_sym] = value
                end
              end
            end

            def flat(list)
              result = []
              list.each do |k, v|
                if list.class == Hash
                  result << "#{k}:#{v.join('/')}"
                  next
                end
                result << (v.nil? ? k : v)
              end

              result.join("\n")
            end
          end
        end
      end
    end
  end
end
