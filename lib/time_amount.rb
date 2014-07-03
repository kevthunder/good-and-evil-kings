class TimeAmount
  def initialize(sec)  
    @sec = sec
  end
  
  attr_accessor :sec
  
  def pretty
    str = []
    remaining = @sec
    terms = {
      86400 => ['day','days'],
      3600 => 'h',
      60 => 'min',
      1 => 'sec',
    }
    while remaining > 0
      qte, label = terms.select{|k,v| k <= remaining}.first 
      label = ((remaining/qte) == 1 ? label.first : label.last ) if label.respond_to?('each')
      str.push (remaining/qte).to_s + label
      remaining = sec % qte
    end
    str.join " "
  end
end