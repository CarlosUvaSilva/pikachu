require 'gosu'
require_relative 'ball'
require_relative 'player'
require 'pry-byebug'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480#, :fullscreen => true

    self.caption = "Pikachu gosta de apanhar bolas"

    @background_image = Gosu::Image.new("media/pallet_town.png", :tileable => true)

    @player = Player.new(self)
    @player.warp(320, 240)
    @font = Gosu::Font.new(20)
    @stars = ["media/pokeball.png","media/masterball.png"]
    @star_anim = Gosu::Image::load_tiles(@stars.sample, 25, 25)
    @stars = Array.new
    @start_music = Gosu::Song.new("media/pokemon_theme_full.wav")
    @start_music.play(true)
  end

  module ZOrder
  Background, Stars, Player, UI = *0..3
  end

  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then
      @player.accelerate
    end

    if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpButton1 then
      @player.stop
    end

     if @player.score == 50
       @evolve = Gosu::Font.new(self, 'Ubuntu Sans', 32)
     end

    if @player.outside_bounds?
      @new_game = Gosu::Font.new(self, 'Ubuntu Sans', 32)
    end

    if @evolve and button_down? Gosu::KbReturn

      @evolve = nil
      @player.score += 10
      @player.pokemon_copy.shift
      image = @player.pokemon_copy[0]
      @player.update_image(image)



    end

    if @new_game and button_down? Gosu::KbReturn
      @new_game = nil
      @score = 0
      @player = Player.new(self)

    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 15 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def draw
    if @new_game
      @new_game.draw("Your Score was #{@player.score}", 5, 200, 100)
      @new_game.draw("Press Return to Try Again", 5, 250, 100)
      @new_game.draw("Or Escape to Close", 5, 300, 100)
     elsif @evolve

       @evolve.draw("Time to Evolve", 5, 300, 100)

    else
      @background_image.draw(0, 0, ZOrder::Background)

      @player.draw
      @stars.each { |star| star.draw }
      @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ff0000)
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new

window.show


