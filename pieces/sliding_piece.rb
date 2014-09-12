require_relative 'piece'

class SlidingPiece < Piece

  RANK_FILE_DELTAS = [[0,1],[0,-1],[1,0],[-1,0]]
  DIAG_DELTAS = [[1,1],[-1,-1],[-1,1],[1,-1]]

  def moves
    moves = []
    current_pos = pos

    move_directions.each do |dx,dy|
      current_pos = [current_pos[0] + dx, current_pos[1] + dy]

      while @board.on_board?(current_pos)
        if @board[current_pos].nil?
          moves << current_pos
          current_pos = [current_pos[0] + dx, current_pos[1] + dy]
        else
          moves << current_pos unless @board[current_pos].color == @color
          break
        end
      end

      current_pos = pos
    end

    moves
  end

end


