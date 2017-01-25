require 'gosu'

class Player
  def initialize(window,image="media/pikachu.png")
    @window = window
    @x = 320
    @y= 240
    # @pokemons = ["media/bulbasaur.png","media/pikachu.png","media/raichu.png"]
    # @image = Gosu::Image.new(@pokemons.sample)
    @image = Gosu::Image.new(image)
    @beep = Gosu::Sample.new("media/pika.wav")
    @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end


  def turn_left
    @angle -= 5
  end

  def stop
    @vel_x -= Gosu::offset_x(@angle, 0.5)
    @vel_y -= Gosu::offset_y(-@angle, 0.5)
  end

  def turn_right
    @angle += 5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def outside_bounds?
    if @x < 0 or @x > 630
      return true
    elsif @y < 0 or @y > 470
      return true
    else
      return false
    end
  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35 then
        @score += 10

        @beep.play if @score%20 == 0
        true
      else
        false
      end
    end
  end
end
