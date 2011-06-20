
require 'bacteria'
require 'water'

class System
	attr :bacteria, :water, :element
	
	def initialize(bacteria, water, oxgen, food)
		@water = Water.new(water)
		@element = {
			:oxgen => Oxgen.new(@water, oxgen),
		 	:food => Food.new(@water, food)}
		@bacteria = Bacteria.new(@water, @element, bacteria) 
		@log= Array.new
	end

	def test(term)
		term.times do
			before_do
			routine
			after_do
		end
	end

	def output(file_name)
		File.open(file_name, 'w') do |fout|
			@log.each do |log|
				fout.puts "#{log[0]} #{log[1]}"
			end
		end
		`gnuplot -persist -e "
		plot 'res' using 1"`
	end
		
	protected
	def before_do; end
	def after_do; end
	def routine
		@bacteria.routine
		@log << [@bacteria.volume, @bacteria.brightness]
	end


end

class FlowSystem < System

	def before_do
			import
			export
@bacteria.instance_eval do
	@element.each do |id, entity|
		entity.volume += 15
	end
end
	end

	private
	def import
	end

	def export
	end

end

