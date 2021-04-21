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
  end
  letter
end

puts "Hangman game initialized"

random_word('5desk.txt')
get_input()