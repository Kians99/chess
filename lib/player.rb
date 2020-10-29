class Player

  attr_reader :color, :number, :direction

  def initialize(color, number, direction)
    @color = color
    @number = number
    @direction = direction
  end

  def make_guess
    gets.chomp
  end
end
