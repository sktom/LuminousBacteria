
require 'active_support/inflector'

class Element < Hash
  def volume=(volume); self[:volume] = [volume, 0.0].max; end
  def density
	 	self[:volume] / @water[:volume]; end
  def density=(d); self[volume] = d * @water.volume; end 

  def initialize(water, option)#, comsumption, )
    @water = water || self
		update option
  end

	def consume(bacteria)
		return unless self[:comsumption]
		volume = self[:comsumption] * bacteria[:number] 
		self[:volume] -= volume
		volume
	end


end

