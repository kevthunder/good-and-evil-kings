class ActiveRecordUtil
  class << self
    def random_funct
      adapter = ActiveRecord::Base.connection.adapter_name #not sure what the real output would be here, test it.
      if adapter == "mysql" 
        "RAND()"
      else #if ["sqlite","oracle"].inlcude?(adapter)
        "Random()"
      end
    end
  end
end
