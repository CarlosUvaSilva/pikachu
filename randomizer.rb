class Randomizer

  def initiliaze
    @pokemons = ["media/bulbasaur.png","media/pikachu.png","media/raichu.png"]
  end


  def random_poke
    pokemons.sample
  end

end
