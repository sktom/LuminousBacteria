
require 'component'

class Water < Component
	undef :density

	def initialize(volume)
		@volume = volume
	end


end
