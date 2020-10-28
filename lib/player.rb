class Player

  attr_reader :color, :number

  def initialize(color, number)
    @color = color
    @number = number
  end

  def make_guess
    gets.chomp
  end
end
