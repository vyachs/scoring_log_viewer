class AuditEvent < ActiveRecord::Base

  def self.analyze_log_files
    #%w(frontend_audit support_audit db_audit app_audit).each do |file_name|
    %w(frontend-server-audit.log).each do |file_name|
      analyze_log_file(file_name)
    end
  end

  def self.analyze_log_file(file_name)
    File.open("analyzed_logs/#{file_name}_diff.log") do |f|
      str = f.gets
      while str do
        if str =~ /CRED_DISP/ && str =~ /sshd/
          new(server_name: file_name, kind: 'logout').save_params(str)
        elsif str =~ /USER_ACCT/ && str =~ /sshd/
          new(server_name: file_name, kind: 'login').save_params(str)
        end
        str = f.gets
      end
    end
  end

  def save_params(str)
    ip = str.match(/addr=(?<ip>.*?) /)[:ip]
    if ip != '?'
      self.user_name = str.match(/acct="(?<user_name>.*?)"/)[:user_name]
      self.ip = ip
      self.time_moment = str[0..14]
      save
    end
  end
end
