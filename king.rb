class King < SteppingPiece
  attr_accessor :has_moved

  def initialize(pos, board, color)
    super(pos, board, color)
    @has_moved = false
  end

  def display
    color == :white ? "♔" : "♚"
  end

  private

  def deltas
    [[1, 1],[-1, -1],
     [1, -1],[-1, 1],
     [1, 0],[-1, 0],
     [0, 1],[0, -1]]
  end
end