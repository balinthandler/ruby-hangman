require 'json'
require 'pry'

def random_word(path)
  words = File.read(path).split
  length = 0
  until length >= 5 && length <= 12
    word = words[rand(0...words.length)]
    length = word.length
  end
  word
end

def get_input
  guess = ''
  loop do
    puts 'Type your guess:'
    guess = gets.chomp.downcase

    if guess == 'menu'
      return 'menu'
      break
    end

    break if /^[a-z]$/.match(guess)
    puts "Enter a single letter!"

  end
  guess
end

def display_secret(secret_word, arr = [])
  secret_word.split('').each_with_index { |guess,index|
    if arr.any? {|i| i == index}
      print guess
    else
      print "_"
    end
    print " "
  } 
  puts
end

def show_hangman(turns)
  hangman = [
    [
      "         ____       ",
      "        |    |      ",
      "        X    |      ",
      "       /|\\   |      ",
      "       / \\   |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "       /|\\   |      ",
      "       / \\   |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "       /|\\   |      ",
      "       /     |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "       /|\\   |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "       /|    |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "        |    |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "        O    |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "        |    |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "         ____       ",
      "             |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "                    ",
      "             |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "             |      ",
      "_____________|______",
    ],
    [
      "                    ",
      "                    ",
      "                    ",
      "                    ",
      "                    ",
      "                    ",
      "____________________",
    ]
  ]
  hangman[turns].each {|line| puts line}
end

class Game 

  def initialize
    @secret = random_word('5desk.txt')
    @solved_indexes = []
    @turns = 10
    @found = []
    @missed = []
    @gameover = false
    
  end

  def start_game
    puts "Hangman game initialized\n\n"
    puts "Try to guess the secret word below!"
    display_secret(@secret, @solved_indexes)
    puts "You have 10 guess to miss."
    puts "To enter the Game Menu, type menu"
  end

  def menu
    puts "---------  GAME MENU  ---------"
    puts "Available commands:"
    puts "  new   - start new game"
    puts "  save   - save current game"
    puts "  load   - load saved game"
    puts "  delete - delete saved game"
    puts "  exit   - exit menu"
    puts "-------------------------------"
    command = ''
    until /^new$|^save$|^load$|^delete$|^exit$/.match(command)
      puts "Type your command:"
      command = gets.chomp
    end
    if command == 'new'
      puts
      puts "Starting New Game..."
      command_new()
    end
    if command == 'save'
      command_save()
    end
    if command == 'load'
      command_load()
      return 'load'
    end
    if command == 'delete'
      command_delete()
    end

  end

  def command_new

    @secret = random_word('5desk.txt')
    @solved_indexes = []
    @turns = 10
    @found = []
    @missed = []
    @gameover = false
    start_game()
  end

  def command_save
    savegame()
    puts
    puts "Game Saved"
    puts
    
  end

  def command_load
    loadgame()
    puts
    puts "Game Loaded"
    puts
    
  end

  def command_delete
    deletegame
    puts
    puts "Saved game deleted"
    puts
    
  end

  def game_logic
    puts
    start_game()

    until @gameover
      guess = get_input()
      if guess == 'menu'
        menu = menu()
        unless menu == 'load'
          next
        end
      end
      puts
      evaluate(@secret, guess)
      show_hangman(@turns)
      display_secret(@secret, @solved_indexes)
      display_guess(guess)
      puts
      display_found(@found)
      display_missed(@missed)
      display_turns(@turns)
      puts

      if @turns == 0
        @gameover = true
        lose_message()
      elsif @secret.length == @solved_indexes.length
        @gameover = true
        win_message()
      end
    end

  end


  def display_turns(turns)
    puts "Turns left: #{turns}"
  end

  def display_guess(guess)
    puts "Your guess: #{guess}"
  end

  def display_found(found) 
    print "Letters found:"
    found.each_with_index { |e, index|
      unless index == found.length - 1
        print " #{e},"
      else
        print " #{e}."
      end
    }
    puts
  end

  def display_missed(missed) 
    print "Letters missed:"
    missed.each_with_index { |e, index|
      unless index == missed.length - 1
        print " #{e},"
      else
        print " #{e}."
      end
    }
    puts
  end

  def win_message
    puts "CONGRATS!"
    puts "You won!"
  end

  def lose_message
    puts "GAME OVER"
    puts "Out of guesses"
    puts "Secret word was: #{@secret}"
  end

  def evaluate(secret,guess)
    secret_arr = secret.downcase.split('')
    success = false

    secret_arr.each_with_index {|secret_letter, index|
    if secret_letter == guess 
      success = true
      if @solved_indexes.none? {|e| e == index}
        @solved_indexes << index
      end
      if @found.none? {|i| i == guess}
        @found << guess
      end
    end
    }

    #   if secret_arr.none? {|i| i == guess}
    # else
      if !success 
        @turns -= 1
        @missed << guess
      
    end
    
  end

  def savegame
    obj = {}
    instance_variables.map {|var|
      obj[var] = instance_variable_get(var)
    }
    file = File.open('hangman.json', 'w+')
    file.puts JSON.dump obj
    file.close
    
  end

  def loadgame
    file = File.read('hangman.json')
    obj = JSON.parse file
    obj.keys.each { |key|
      instance_variable_set(key, obj[key])
    }
  end

  def deletegame
    file = File.open('hangman.json', 'w+')
    file.close
  end
end






game = Game.new()
game.game_logic


