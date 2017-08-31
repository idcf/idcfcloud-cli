require_relative './csv_format'

module Idcf
  module Cli
    module Lib
      module Convert
        module Formatter
          # table formatter
          class TableFormat < CsvFormat
            def format(data, err_f)
              require 'kosi'
              Kosi::Table.new.render(scrape_line(data, err_f))
            end
          end
        end
      end
    end
  end
end
