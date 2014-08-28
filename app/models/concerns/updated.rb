module Updated
  extend ActiveSupport::Concern
  
  
  included do
    scope :to_update, (lambda do
      or_conds = Array.new
      replace = {now:Time.now}
      updated_columns.each do |col|
        or_conds.push table_name + col[:column] + ' < :now'
      end
      where(or_conds.join(' OR '), replace)
    end)
  end
  
  def to_update_from_col?(col)
    val = send(col)
    !val.nil? && val < Time.now
  end
  
  def active_updater_callbacks()
    self.class.updated_columns.select{ 
      |col| to_update_from_col?(col[:column]) 
    }.map{ |col| Updater::UpdaterCallback.new(self,col[:method],col[:column]) }
  end
  
  module ClassMethods
    attr_accessor :updated_columns
    def updated_column(col,method)
      if updated_columns.nil?
        updated_columns = []
        Updater.add_updated self
      end
      updated_columns.push({column:col,method:method});
    end
    
    def get_update_callbacks
      to_update.to_a.map{ |updated|
        updated.active_updater_callbacks
      }.flatten(1)
    end
  end
end