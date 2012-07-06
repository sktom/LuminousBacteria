
module SpecialArray

  def special_method
    p 'Special? lol'
  end


end

a = (1..3).to_a
a.extend SpecialArray
a.special_method
