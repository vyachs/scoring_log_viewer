class AideChange < ActiveRecord::Base
  ACTIONS = { added: 1, changed: 2, removed: 3 }
  belongs_to :report_day

end