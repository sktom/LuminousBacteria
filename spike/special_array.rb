
module SpecialArray

  def special_method
    p 'Special? lol'
  end


end

a = [1,2,3]
a.extend SpecialArray
a.special_method
