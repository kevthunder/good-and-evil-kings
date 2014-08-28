module Updated
  extend ActiveSupport::Concern
  
  
  included do
    include BelongsToResolver
  
    scope :to_update, (lambda do
      or_conds = Array.new
      replace = {now:Time.now}
      updated_columns.each do |col|
        or_conds.push table_name + '.' + col[:column].to_s + ' < :now'
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
  
  def set_context_objects(objects)
    resolve_belongs_to_with(objects);
  end
  
  module ClassMethods
    def updated_columns
      class_variable_get "@@updated_columns"
    end 
    def updated_columns=(new_val)
      class_variable_set "@@updated_columns", new_val
    end
    
    def updated_column(col,method)
      unless class_variable_defined?(:@@updated_columns)
        self.updated_columns = []
        Updater.add_updated self
      end
      updated_columns.push({column:col,method:method});
    end
    
    def get_update_callbacks
      to_update.to_a.map{ |updated|
        updated.class.unscoped do
          updated.active_updater_callbacks
        end
      }.flatten(1)
    end
  end
end