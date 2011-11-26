require 'entity.rb'

class Ball < Entity
	attr_accessor :velX, :velY, :dead
	
	def initialize x, y, image
		super x, y, image
		@velX = rand(1) == 0 ? -4 : 4
		@velY = rand(1) == 0 ? -4 : 4
	end
	
	def update
		@x += @velX
		@y += @velY
		if @x < 0
			@x = 0
			@velX *= -1
		end
		if @x > 800 - 16
			@x = 800 - 16
			@velX *= -1
		end		
		if @y < 0
			@dead = true
		end
		if @y > 600 - 16
			@dead = true
		end
	end
end