class Piece

  attr_accessor :pos

  attr_reader :color

  def initialize(pos, board, color)
    @pos, @color = pos, color
    @board = board
    @board[pos] = self
  end

  def inspect
    [self.class,color,pos].inspect
  end

  def dup(new_board)
    self.class.new(@pos, new_board, @color)
  end

  def valid_moves
    valids = []

    moves.each do |new_pos|
      temp_board = @board.dup
      temp_board.move!(pos, new_pos)
      valids << new_pos if !temp_board.in_check?(@color)
    end

    valids
  end

end

