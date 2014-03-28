class Updater

  class << self
    def update
      Mission.to_update.each do |mission|
        mission.next
      end
    end
  end
end