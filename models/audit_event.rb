class AuditEvent < ActiveRecord::Base
  def self.analyze_log_file(file_name)
    hh = 0
    gg = 0
    File.open('analyzed_logs/frontend-server-audit.log') do |f|
      str = f.gets
      while str do
        if str =~ /CRED_DISP/ && str =~ /sshd/
          hh += 1
        elsif str =~ /USER_ACCT/ && str =~ /sshd/
          gg += 1
        end
        str = f.gets
      end
    end
    [hh, gg]
  end

  def self.creation(event_kind, str)
    time_moment = str[0..14]

  end
end

#frontend_audit_diff.log
#
#support_audit_diff.log
#
#db_audit_diff.log
#
#app_audit_diff.log
#
