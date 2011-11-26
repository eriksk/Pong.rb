class Entity
	attr_accessor :x, :y, :image
	
	def initialize x, y, image
		@x, @y, @image = x, y ,image
	end
	
	def draw
		image.draw(x,y, 1)
	end
end