class SlidingPiece < Piece

  RANK_FILE_DELTAS = [[0,1],[0,-1],[1,0],[-1,0]]

  DIAG_DELTAS = [[1,1],[-1,-1],[-1,1],[1,-1]]

  def moves

    move_pos = []

    current_pos = pos

    move_directions.each do |dx,dy|
      current_pos = [current_pos[0] + dx, current_pos[1] + dy]

      while @board.on_board?(current_pos)
        if @board[current_pos].nil?
          move_pos << current_pos
          current_pos = [current_pos[0] + dx, current_pos[1] + dy]
        else
          move_pos << current_pos unless @board[current_pos].color == @color
          break
        end
      end

      current_pos = pos
    end

    move_pos
  end

end

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