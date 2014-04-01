module GarrisonCollection
    def subtract_from(garrisonable)
      garrisons = to_a
      match = garrisonable.garrisons.match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        return false if matched.nil? || matched.qte < garrison.qte
        if matched.qte == garrison.qte
          matched.destroy
        else
          matched.qte -= garrison.qte
          matched.save
        end
      end
      true
    end

    def add_to(garrisonable)
      garrisons = to_a
      match = garrisonable.garrisons.match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        if matched.nil?
          garrison.garrisonable = garrisonable
          garrison.save
        else
          matched.qte += garrison.qte
          matched.save
          garrison.destroy
        end
      end
    end
end