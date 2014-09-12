require_relative 'sliding_piece'

class Rook <SlidingPiece
  attr_accessor :has_moved

  def initialize(pos, board, color)
    super(pos, board, color)
    @has_moved = false
  end

  def display
    color == :white ? "♖" : "♜"
  end

  def power
    2
  end

  private

  def move_directions
    dirs = RANK_FILE_DELTAS
  end

end