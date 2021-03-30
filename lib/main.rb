# frozen_string_literal: true

DICTIONARY = '../src/dictionary.txt'

# any mathod that includes puts gets or print will be considered a UI method and belongs to this module
module UI
  def main_menu(word)
    puts 'Welcome'
    puts word
  end
end

# game logic
class Game
  include UI

  def initialize
    @secret_word = choose_random_word(DICTIONARY)
    @lives = 10
  end

  def play
    main_menu(@secret_word)
  end

  private

  def choose_random_word(dictionary)
    dictionary = File.open(dictionary)
    random_pos = rand(dictionary.size)
    dictionary.pos = random_pos
    string = dictionary.read(26).downcase
    dictionary.close
    string.match(/\n[a-z]*\n/)[0].strip
  end
end

hangman = Game.new
hangman.play
