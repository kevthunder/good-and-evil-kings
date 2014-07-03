class Option < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  
  def read_val
    if target.respond_to?(:opt_read_val)
      res = target.opt_read_val(self)
      return res unless res.nil?
    end
    val.humanize
  end
end
