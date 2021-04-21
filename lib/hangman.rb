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
  letter = ''
  loop do
    puts 'Type your guess:'
    letter = gets.chomp.downcase
    break if /^[a-z]$/.match(letter)
    puts "Enter a single letter!"
  end
  letter
end

def display_secret(secret_word, arr = [])
  secret_word.split('').each_with_index { |letter,index|
    if arr.any? {|i| i == index}
      print letter
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
  def initialize(secret, solved = [], turns = 10)
    @secret = secret
    @solved = solved
    @turns = turns
    @gameover = false
  end

  def start_game
    puts "Hangman game initialized\n\n"
    puts "Try to guess the secret word below!"
    display_secret(@secret, @solved)
    puts "You can miss 9 times, 10th will be game over."
  end

  def game_logic
    until @gameover
      letter = get_input()
      evaluate(@secret, letter)
      show_hangman(@turns)
      display_secret(@secret, @solved)

      if @turns == 0
        @gameover = true
      end
    end

    puts "GAME OVER"
    puts "Out of guesses"
  end

  def evaluate(secret,letter)
    arr = secret.downcase.split('')
    if arr.none? {|i| i == letter}
      @turns -= 1
    else
      arr.each_with_index {|secret_letter, index|
      if secret_letter == letter 
        @solved << index
      end
      }
    end
    puts "Turns left: #{@turns}"
  end

end






game = Game.new(random_word('5desk.txt'))
game.start_game

game.game_logic
