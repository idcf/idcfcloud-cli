require 'idcf/cli/conf/const'
require 'rbconfig'
require 'faraday'
require 'etc'
require 'objspace'
require 'open-uri'
require 'json'
require 'facter'
module Idcf
  module Cli
    module Command
      # morio command
      class Morio
        MORIO_TXT = <<-TEXT.freeze
                        -+sso+-
               ....    -ssssssso`
          `-/ossssss+/. `ssssssso`
        `/ssssssssssssso-  /sssss+
     .-:ossssssssssssssss` sssssss`
  `/sssssssssssssssssssss.+sssssss.
 `ossssssssssssssssssssss`osssssss`
 /sssssssssssssssssssssss-ossssss+
 :sssssssssssssssssssssssssssssso`
  /ssssssssssssssssssssssssssss+`
   ./osssssssssssssssssssssss+.
      `-:+oosssssssssssso+:.
             ``````````
        TEXT
        ATTRIBUTES_OFF = "\e[0m".freeze
        MORIO_COLOR    = "\e[38;5;45m".freeze
        TITLE_COLOR    = "\e[38;5;45m".freeze
        TEXT_COLOR     = "\e[37m".freeze

        attr_reader :client

        def exec
          morio_list = MORIO_TXT.split("\n")
          max        = max_length(morio_list)
          contents   = make_contents

          morio_list.each_with_index do |line, idx|
            fill_cnt = max - line.bytesize
            fill     = fill_cnt > 0 ? ''.ljust(fill_cnt, ' ') : ''
            base_str = "#{MORIO_COLOR}#{line} #{fill}"
            puts make_out_str(base_str, contents, idx)
          end
          puts ATTRIBUTES_OFF
        end

        private

        def max_length(lists)
          result = 0
          lists.each do |line|
            size   = line.bytesize
            result = size if result < size
          end
          result
        end

        def make_contents
          result = [
            ['IDCF Cloud', ''],
            ['CLI', Idcf::Cli::Conf::Const::VERSION_STR]
          ]
          result.concat(find_data_server)
          result << []
          result.concat(find_spec_data)
        end

        def find_data_server
          [].tap do |result|
            @client ||= create_client('http://data-server')

            {
              VMID: 'vm-id',
              SPEC: 'service-offering',
              ZONE: 'availability-zone'
            }.each do |k, v|
              data = @client.get("latest/meta-data/#{v}")
              result << [k.to_s, data.body] if data.success?
            end
          end
        rescue StandardError => _e
          []
        end

        def find_spec_data
          data = Etc.uname
          [
            ['Host', data[:nodename]],
            ['OS', Facter.value(:operatingsystem)],
            ['Kernel', "#{data[:sysname]} #{data[:release]} #{data[:machine]}"],
            ['CPU(s)', Etc.nprocessors],
            ['MEM', Facter.value(:memorysize)]
          ]
        end

        def create_client(url)
          Faraday.new(url: url) do |faraday|
            faraday.adapter Faraday.default_adapter
          end
        end

        def make_out_str(base_str, contents, idx)
          add_str = ''
          content = contents[idx]
          if content && content.class == Array && content.size == 2
            title   = content[1].present? ? "#{content[0]} : " : content[0]
            txt     = content[1].present? ? content[1] : ''
            add_str = format(" #{TITLE_COLOR}%<title>s#{TEXT_COLOR}%<txt>s", title: title, txt: txt)
          end
          "#{base_str}#{add_str}"
        end
      end
    end
  end
end
