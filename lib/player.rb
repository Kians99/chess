class Player

  attr_reader :color, :player_number

  def initialize(color, player_number)
    @color = color
    @player_number = player_number
  end

  def make_guess
    gets.chomp
  end
end
