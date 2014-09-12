class Queen < SlidingPiece

  def display
    color == :white ? "♕" : "♛"
  end

  def power
    1
  end

  private

  def move_directions
    dirs = RANK_FILE_DELTAS + DIAG_DELTAS
  end

end