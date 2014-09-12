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
    end
    
    if input == "short" || input == "long"
      return input.to_sym
    else
      start = [file_to_x(input[0]), rank_to_y(input[1].to_i)]
      fin = [file_to_x(input[3]), rank_to_y(input[4].to_i)]
      return [start, fin]
    end
  end

  private

  def check_input(input)
    unless input == "short" || input == "long"
      raise BadInput if input.size != 5

      Integer(input[1])
      Integer(input[4])

      raise BadInput if !("a".."z").to_a.include?(input[0])
      raise BadInput if !("a".."z").to_a.include?(input[3])
    end
  end

  def rank_to_y(rank)
    rank - 1
  end

  def file_to_x(file)
    'abcdefgh'.index(file)
  end

end
