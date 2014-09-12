class Player

  attr_accessor :color

  def initialize(name)
    @name = name
    @color = nil
  end

  def choose_move
    puts "#{@name}, please enter your move in the \n
          form of 'a8,b8' (move from A8 to B8).\n
          Type 'short' or 'long' to castle."

    begin
      input = gets.chomp
      check_input(input)

    rescue BadInput, ArgumentError
      puts "Please enter a correctly formatted move."
      retry

    rescue Castling
      return input.to_sym
    end

    input = input.split(",")

    start = [file_to_x(input[0][0]), rank_to_y(input[0][1].to_i)]
    end_pos = [file_to_x(input[1][0]), rank_to_y(input[1][1].to_i)]

    [start, end_pos]
  end

  private

  def check_input(input)
    raise Castling if input == "short" || input == "long"

    raise BadInput if input.size != 5

    Integer(input[1])
    Integer(input[4])

    raise BadInput if !("a".."z").to_a.include?(input[0])
    raise BadInput if !("a".."z").to_a.include?(input[3])
  end

  def rank_to_y(rank)
    rank - 1
  end

  def file_to_x(file)
    'abcdefgh'.index(file)
  end

end
