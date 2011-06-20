
class Component
	attr :volume
	def volume=(volume); @volume = [volume, 0.0].max; end
	def density; @volume / @water.volume; end
	def density=(d); @volume = d * @water.volume; end 

	def initialize(water, volume)
		@water = water
		@volume = volume.to_f
	end


end
