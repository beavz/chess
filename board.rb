require './pieces.rb'
require 'colorize'
require 'debugger'

class Board
  attr_accessor :white_king, :black_king, :grid

  def initialize(duplicate = false)
    @grid = Array.new(8) {Array.new(8)}
    setup unless duplicate
    @jail = []
  end

  def setup

    @white_king = King.new([4,0], self, :white)
    @black_king = King.new([4,7], self, :black)

    Queen.new([3,0], self, :white)
    Queen.new([3,7], self, :black)

    Bishop.new([2,0], self, :white)
    Bishop.new([5,0], self, :white)
    Bishop.new([2,7], self, :black)
    Bishop.new([5,7], self, :black)

    Knight.new([1,0], self, :white)
    Knight.new([6,0], self, :white)
    Knight.new([1,7], self, :black)
    Knight.new([6,7], self, :black)

    Rook.new([0,0], self, :white)
    Rook.new([7,0], self, :white)
    Rook.new([0,7], self, :black)
    Rook.new([7,7], self, :black)

    8.times do |i|
      Pawn.new([i,1], self, :white)
      Pawn.new([i,6], self, :black)
    end

    nil
  end

  # def display
 #      print "   ┌#{"───┬"* (7)}───┐ ".colorize(:light_cyan)
 #      @jail.each {|piece| print piece.display if piece.color == :black}
 #      print "\n"
 #
 #      (0...8).to_a.reverse.each do |y|
 #        print " #{y+1}".colorize(:light_black)
 #        print " │".colorize(:light_cyan)
 #        8.times do |x|
 #          if !self[[x,y]].nil?
 #            print " #{self[[x,y]].display} "
 #          else
 #            print "   "
 #          end
 #          print "│".colorize(:light_cyan)
 #        end
 #        print "\n"
 #        print "   ├#{"───┼" * (7)}───┤\n".colorize(:light_cyan) unless y == 0
 #      end
 #      print "   └#{"───┴"* (7)}───┘ ".colorize(:light_cyan)
 #      @jail.each {|piece| print piece.display if piece.color == :white}
 #      print "\n"
 #      print "     A   B   C   D   E   F   G   H  \n".colorize(:light_black)
 #      nil
 #  end

   def display
     colors = { 0 => :light_white, 1 => :white }
     7.downto(0) do |y| #underscore?
        print " #{y+1} ".colorize(:light_black)

        8.times do |x|
          if self[[x,y]].nil?
            print "  ".colorize( :background => colors[(x+y)%2] )
          else
            print "#{self[[x,y]].display} ".colorize( :background => colors[(x+y)%2] )
          end
        end

        if y == 7
          @jail.each {|piece| print piece.display if piece.color == :black}
        elsif y == 0
          @jail.each {|piece| print piece.display if piece.color == :white}
        end

        print "\n"
      end


      print "   A B C D E F G H \n".colorize(:light_black)
    end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos, obj)
    x,y = pos
    @grid[x][y] = obj

    nil
  end

  def move(start, fin, color)
    if self[start].nil?
      raise NoPieceError
      
    elsif self[start].color != color
      raise NotYoPieceError
      
    elsif self[start].valid_moves.include?(fin)
      if self[fin] #move a captured piece to jail
        @jail << self[fin] 
        @jail.compact!
        @jail.sort_by! { |piece| piece.power }
      end
      
      self.move!(start, fin) 
      self[fin].has_moved = true if [King, Rook].include?(self[fin].class)

    elsif self[start].moves.include?(fin)
      raise MoveToCheckError
      
    else
      raise IllegalMoveError
    end
    
    nil
  end

  def move!(start, fin)
    self[fin], self[start] = self[start], nil
    self[fin].pos = fin
  end

  def castle(side, color)
    raise NoCastleError if in_check?(color) #may not be in check
    
    y = (color == :white ? 0 : 7)
    king_x = 4
    rook_x = (side == :long ? 0 : 7)
    
    raise NoCastleError if self[[king_x,y]].has_moved || #can only be first move for both pieces
                            self[[rook_x,y]].has_moved

    in_between_x = ( side == :long ? [1,2,3] : [5,6] ) #all spaces passed through must be empty
    raise noCastleError unless in_between_x.all? { |x| self[[x,y]].nil? }
    
    ( side == :long ? [3, 2] : [5, 6] ).each do |passed_x| #king must not pass through check
      temp_board = self.dup
      temp_board.move!([king_x,y], [passed_x,y])
      raise NoCastleError if temp_board.in_check?(color)
    end
    
    new_king_x = ( side == :long ? 2 : 6 )
    new_rook_x = ( side == :long ? 3 : 5 )
    
    self.move!([king_x, y], [new_king_x, y])
    self.move!([rook_x, y], [new_rook_x, y]) 
  end

  def check_for_pawn_promotion(color)
    last_rank = (color == :white ? 7 : 0)
    position = nil
    
    8.times do |x|
      if self[[x,last_rank]].class == Pawn && self[[x,last_rank]].color == color
        promote_pawn([x,last_rank])
        break
      end
    end
    
    nil
  end
  
  def promote_pawn(pos)
    puts "You must promote your pawn. \nEnter 'Q', 'R', 'B', or 'N' to select a piece."
    pieces = { q: Queen, r: Rook, b: Bishop, n: Knight }
    
    while true
      input = gets.chomp.downcase
      
      if pieces[input]
        pieces[input].new(pos, self, color)
        break
      else
        puts "Try again."
      end
    end
    
    nil
  end

  def on_board?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def dup
    dup_board = Board.new(true)

    @grid.flatten.compact.each do |piece|
      if piece.class == King
        if piece.color == :white
          dup_board.white_king = piece.dup(dup_board)
        else
          dup_board.black_king = piece.dup(dup_board)
        end
      else
        piece.dup(dup_board)
      end
    end

    dup_board
  end
  
  def pieces
    @grid.flatten.compact
  end

  def in_check?(color)
    king_pos = (color == :white ? @white_king.pos : @black_king.pos)
    
    pieces.each do |piece|
      unless piece.color == color
        return true if piece.moves.include?(king_pos)
      end
    end
    
    false
  end

  def color_checkmate?(color)
    return false if !self.in_check?(color)

    pieces.all do |piece|
      piece.color != color || piece.valid_moves.empty?
    end
  end

  def checkmate?
    self.color_checkmate?(:white) || self.color_checkmate?(:black)
  end

end

class IllegalMoveError < StandardError
end

class NoPieceError < StandardError
end

class NotYoPieceError < StandardError
end

class MoveToCheckError < StandardError
end

class NoCastleError < StandardError
end

class BadInput < StandardError
end