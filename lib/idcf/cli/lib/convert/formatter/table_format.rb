require_relative './csv_format'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # table formatter
          class TableFormat < CsvFormat
            def format(data)
              require 'kosi'
              Kosi::Table.new.render(scrape_line(data))
            end
          end
        end
      end
    end
  end
end
