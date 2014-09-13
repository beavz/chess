require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board

  def initialize(white_player, black_player)
    @white, @black = white_player, black_player
    @white.color = :white
    @black.color = :black
  end

  def play
    playing = @white
    @board = Board.new
  
    puts "#{@white.name} will play white and #{@black.name} will play black."

    until false # @board.checkmate?
      @board.display
      puts "Check!" if board.in_check?(playing.color)
      
      begin
        move = playing.choose_move

        if move == :long || move == :short
          @board.castle(move, playing.color)
        else
          @board.move(*move, playing.color)
        end

      rescue NoCastleError
        puts "You may not castle with that rook."
        retry

      rescue NotYoPieceError
        puts "Stop cheating. Move your own piece.  Come on man."
        retry

      rescue IllegalMoveError
        puts "You can't move there."
        retry

      rescue MoveToCheckError
        if board.in_check?(playing.color)
          puts "You are in check! Move out of check."
        else
          puts "That will put your King in check. Choose again."
        end
        retry

      rescue NoPieceError
        puts "There is no piece at that position."
        retry
      end
      
      @board.check_for_pawn_promotion(playing.color)

      playing = ( playing == @white ? @black : @white ) #switches turns
    end

    if playing == @white
      puts "Checkmate! Black wins."
    else
      puts "Checkmate! White wins."
    end

    @board.display
  end

end