require 'idcf/cli/conf/const'

module Idcf
  module Cli
    module Lib
      # document
      class Document
        class << self
          attr_reader :region, :version

          def init(region: '', version: '')
            @region  = region
            @version = version
          end

          def make_document_desc(link)
            "reference : #{make_document_url(link)}"
          end

          def make_document_url(link)
            result       = URI(Idcf::Cli::Conf::Const::DOCUMENT_URL)
            add_params   = {
              'id' => make_document_id(link)
            }.to_param
            result.query = result.query ? "#{result.query}&#{add_params}" : add_params
            result.to_s
          end

          def make_document_id(link)
            titles      = link.parent_titles
            service_str = titles.shift.downcase
            version_str = "#{Idcf::Cli::Conf::Const::DOCUMENT_SPACE_CONVERSION}#{@version}"
            version_str = (@region.present? && @region != 'default' ? '' : version_str)
            id_format   = Idcf::Cli::Conf::Const::DOCUMENT_ID_PREFIX_FORMAT
            prefix      = format(id_format, service: service_str, version: version_str)
            results     = [prefix]
            results.concat(titles)
            result = results.join(Idcf::Cli::Conf::Const::DOCUMENT_ID_SEP)
            result.gsub(/ /, Idcf::Cli::Conf::Const::DOCUMENT_SPACE_CONVERSION)
          end
        end
      end
    end
  end
end
