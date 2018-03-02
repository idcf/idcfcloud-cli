require_relative './base'
require 'csv'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # csv formatter
          class CsvFormat < Base
            def format(data)
              result = CSV.generate(force_quotes: true) do |csv|
                scrape_line(data).each do |v|
                  csv << v
                end
              end

              result.strip
            end

            protected

            def scrape_line(data)
              list = scrape(data)
              return [] if list.size.zero?

              result = []
              headers = make_header(list.first)
              result << headers
              push_list(list, headers, result)
            end

            def make_header(first_list)
              result = []
              if first_list.class == Hash
                first_list.each_key do |k|
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
            # @return Array in Hash
            def scrape(data)
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
              result = {}
              return result unless data.class == Hash
              data.each do |k, v|
                value = v
                value = JSON.generate(value) if v.class == Array || v.class == Hash
                result[k.to_sym] = value
              end
              result
            end
          end
        end
      end
    end
  end
end
