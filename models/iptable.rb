require 'time'
require 'ipaddr'

class Iptable < ActiveRecord::Base
  def self.analyze_log_files
    %w(support_iptables front_iptables).each do |file_name|
      analyze_log_file(file_name)
    end
  end

  def self.analyze_log_file(file_name)
    File.open("analyzed_logs/#{file_name}_diff.log") do |f|
      str = f.gets
      while str do
        if str.include? 'SRC'
          data = str.split(' ')
          create(
            server_name: file_name,
            time_moment: Time.parse(data[0..2].join(' ')),
            src_ip: IPAddr.new(data.find {|x| x.include? 'SRC' }[4..-1])
          )
        end
        str = f.gets
      end
    end
  end

end