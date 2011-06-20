

class ElementList < Hash

	def initialize(hash)
		super
		hash.each{|id, volume| self[id] = volume}
	end

	def []=(id, volume)
		demand id
		super(id, volume)
	end

	private
	def demand(id = nil)
		if id
			require id
		else
			each_value{|id| require id}
		end
	end


end

el = ElementList.new({:oxgen => 5000})
