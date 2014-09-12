require_relative 'stepping_piece'

class Knight < SteppingPiece

  def display
    color == :white ? "♘" : "♞"
  end

  def power
    4
  end

  private

  def deltas
    [[2, 1],[2, -1],
     [-2, 1],[-2, -1],
     [1, 2],[1, -2],
     [-1, 2],[-1, -2]]
  end

end