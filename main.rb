require 'rubygems'
require 'gosu'

class Entity
	attr_accessor :x, :y, :image
	
	def initialize x, y, image
		@x, @y, @image = x, y ,image
	end
	
	def draw
		image.draw(x,y, 1)
	end
end

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

class Pad < Entity
	attr_accessor :score
	
	def initialize x, y, image
		super x, y, image
		@score = 0
	end
	
	def update
	end
end

class GameWindow < Gosu::Window	
	def initialize
		super(800, 600, false)
		@width = 800
		@height = 600
		self.caption = "Ruby Pong!"
		@pads = [Pad.new((@width / 2) - 32, 32, Gosu::Image.new(self, "gfx/pad.png", true)),
				 Pad.new((@width / 2) - 32, @height - (8 + 32), Gosu::Image.new(self, "gfx/pad.png", true))]
		@ball = Ball.new(@width / 2.0, @height / 2.0, Gosu::Image.new(self, "gfx/ball.png", true))	
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)	
	end
	
	def win(pad)
		pad.score += 1
		@ball.x = (@width / 2)
		@ball.y = (@height / 2)
		@ball.dead = false
	end
	
	def update
		#Check for goal
		if @ball.dead
			win(@ball.y < @height / 2 ? @pads.last : @pads.first)
		end
		
		@ball.update
		@pads.each{|p| p.update}
		
		@pads.first.x = @ball.x - 32
		if button_down?(Gosu::KbRight)
			@pads.last.x += 8
		end
		if button_down?(Gosu::KbLeft)
			@pads.last.x -= 8
		end
				
		#Boundaries
		@pads.each{|p| 			
			if p.x < 0
				p.x = 0
			end
			if p.x > 800 - 64
				p.x = 800 - 64
			end		
		}
		
		#Collision
		@pads.each{|p| 			
			if @ball.x > p.x && @ball.x < p.x + 64
				if @ball.y + 16 > p.y && @ball.y - 8 < p.y
					#collision
					@ball.velY *= -1
					#correct ball position
					
				end
			end
		}
	end
	
	def draw
		@pads.each{|p| p.draw}
		@ball.draw
		@font.draw("Score: #{@pads.first.score}", 10, 10, 0, 1.0, 1.0, 0xffffffff) 
		@font.draw("Score: #{@pads.last.score}", 10, @height - 30, 0, 1.0, 1.0, 0xffffffff) 
	end	
	
	def button_down(id)
		case id
			when Gosu::KbEscape
				close
		end
	end
end

#Entry point
window = GameWindow.new
window.show