require 'json'
require 'colorize'

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
    @lastguess = ""
    @gameover = false
    
  end

  def start_game
    puts
    puts "  ---------------------------------------------- "
    puts " |              WELCOME TO HANGMAN              |"
    puts " |                                              |"
    puts " | The computer selects an english word from a  |"
    puts " | file that contains approx. 65k unique words. |"
    puts " | It will be between 5 and 12 characters long  |"
    puts " | and you have to figure out letter by letter. |"
    puts " |                                              |"
    puts " | You can make 10 mistake, before you lose.    |"
    puts " | Save your game or load your earlier one in   |"
    puts " | the Game Menu. To enter the Game Menu, type  |"
    puts " | " +"menu ".red + "at any point of the game.               |"
    puts "  ---------------------------------------------- "
    puts
    puts "Random word have been chosen. " 
    puts "Try to guess any letter of the word below!"
    display_secret(@secret, @solved_indexes)
  end

  def menu
    puts "---------  GAME MENU  ---------".red
    puts "Available commands:"
    puts "  new".green + "    - start new game"
    puts "  save".green + "   - save current game"
    puts "  load".green + "   - load saved game"
    puts "  delete".green + " - delete saved game"
    puts "  exit".green + "   - exit menu"
    puts "-------------------------------".red
    command = ''
    until /^new$|^save$|^load$|^delete$|^exit$/.match(command)
      puts "Type your command:"
      command = gets.chomp
    end
    if command == 'new'
      puts
      puts "Starting New Game..."
      command_new()
      return 'new'
    end
    if command == 'save'
      command_save()
      return 'save'
    end
    if command == 'load'
      command_load()
      return 'load'
    end
    if command == 'delete'
      command_delete()
      return 'delete'
    end

    if command == 'exit'
      return 'exit'
    end

  end

  def command_new

    @secret = random_word('5desk.txt')
    @solved_indexes = []
    @turns = 10
    @found = []
    @missed = []
    @lastguess = ""
    @gameover = false
    start_game()
  end

  def command_save
    savegame()
    puts
    puts "Game Saved".green
    puts
    
  end

  def command_load
    loadgame()

    
  end

  def command_delete
    deletegame
    puts
    puts "Saved game deleted".red
    puts
    
  end

  def game_logic
    start_game()

    until @gameover
      input = get_input()
      if input == 'menu'
        menu = menu()
        if menu == 'load' || menu == 'save' || menu == 'delete' || 'exit'
          show_hangman(@turns)
          display_secret(@secret, @solved_indexes)
          display_guess(@lastguess)
          puts
    
          display_found(@found)
          display_missed(@missed)
          display_turns(@turns)
          puts
        end
        next
      else
        @lastguess = input
      end

      evaluate(@secret, @lastguess)
      
      show_hangman(@turns)
      display_secret(@secret, @solved_indexes)
      display_guess(@lastguess)
      puts

      display_found(@found)
      display_missed(@missed)
      display_turns(@turns)
      puts

      if @turns == 0
        @gameover = true
        lose_message()
        puts "Want to play another round? y/n"
        ask_newgame()
      elsif @secret.length == @solved_indexes.length
        @gameover = true
        win_message()
        puts "Want to play another round? y/n"
        ask_newgame()
      end
    end

  end

  def ask_newgame
    answer = ''
    until answer == 'y' || answer == 'n'
      answer = gets.chomp.downcase
      if answer == 'y'
        command_new()
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
    if missed.length == 0
      puts
      return    
    else
      missed.each_with_index { |e, index|
        unless index == missed.length - 1
          print " #{e},"
        else
          print " #{e}."
        end
      }
    end
    puts
  end

  def win_message
    puts "CONGRATS!".green
    puts "You won!".green
  end

  def lose_message
    puts "GAME OVER".red
    puts "Out of guesses".red
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


    if !success 
      if @missed.none? {|missed| missed == guess}
        @turns -= 1
        @missed << guess
      end
      
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
    if file == ""
      puts "There is nothing to load.".red
      puts "Try to save a game first!".red
    else
      obj = JSON.parse file
      obj.keys.each { |key|
        instance_variable_set(key, obj[key])
      }
      puts
      puts "Game Loaded".green
      puts
    end
  end

  def deletegame
    file = File.open('hangman.json', 'w+')
    file.close
  end
end






game = Game.new()
game.game_logic


