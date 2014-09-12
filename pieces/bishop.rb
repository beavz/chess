require_relative 'sliding_piece'

class Bishop <SlidingPiece

  def display
    color == :white ? "♗" : "♝"
  end

  def power
    3
  end

  private

  def move_directions
    dirs = DIAG_DELTAS
  end

end