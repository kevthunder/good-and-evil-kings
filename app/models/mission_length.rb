class MissionLength < ActiveRecord::Base
  belongs_to :target, polymorphic: true

  scope :joins_target_type, (lambda do |type|
    where(target_type: type.name).joins("INNER JOIN #{MissionType.table_name} ON #{MissionType.table_name}.id = #{table_name}.target_id")
  end)
end
