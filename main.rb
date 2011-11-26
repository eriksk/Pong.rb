require 'rubygems'
require 'gosu'
require 'entity.rb'
require 'pad.rb'
require 'ball.rb'

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