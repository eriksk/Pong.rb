require 'entity.rb'

class Pad < Entity
	attr_accessor :score
	
	def initialize x, y, image
		super x, y, image
		@score = 0
	end
	
	def update
	end
end