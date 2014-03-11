class AuditEvent < ActiveRecord::Base
  def self.analyze_log_files
    #%w(frontend_audit support_audit db_audit app_audit).each do |file_name|
    %w(f_end_audit).each do |file_name|
      analyze_log_file(file_name)
    end
  end

  def self.analyze_log_file(file_name)
    File.open("analyzed_logs/#{file_name}_diff.log") do |f|
      str = f.gets
      while str do
        #if str =~ /CRED_DISP/ && str =~ /sshd/
        #  new(server_name: file_name, kind: 'logout').save_params(str)
        if str =~ /USER_ACCT/ && str =~ /sshd/
          new(server_name: file_name, kind: 'successful_login').save_params(str)
        elsif str =~ /USER_LOGIN/ && str =~ /sshd/ && str =~ /res=failed/ && str !~ /acct=(28756E6B6E6F776E207573657229|28696E76616C6964207573657229)/
          new(server_name: file_name, kind: 'failed_login').save_params(str)
        end
        str = f.gets
      end
    end
  end

  def save_params(str)
    ip = str.match(/addr=(?<ip>.*?) /)[:ip]
    if kind == 'failed_login' || ip != '?'
      self.user_name = str.match(/acct="(?<user_name>.*?)"/)[:user_name]
      self.ip = ip
      self.time_moment = DateTime.parse(str[0..14])
      save
    end
  end
end
