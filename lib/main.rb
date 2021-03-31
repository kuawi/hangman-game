# frozen_string_literal: true

DICTIONARY = '../src/dictionary.txt'

# any mathod that includes puts gets or print will be considered a UI method and belongs to this module
module UI
  SCREEN_SIZE = 30
  def main_menu(word)
    puts 'Welcome'
    puts word.join
    puts '********'.center(SCREEN_SIZE)
  end

  def main_screen(bar, lives)
    puts "#{lives} lives remaining".rjust(SCREEN_SIZE)
    puts ''
    show_progress_bar(bar)
  end

  def show_progress_bar(bar)
    puts bar.join
  end
end

# game logic
class Game
  include UI

  def initialize
    @secret_word_arr = choose_random_word(DICTIONARY).split('')
    @progress_arr = Array.new(@secret_word_arr.size, '-')
    @lives = 10
  end

  def play
    main_menu(@secret_word_arr)
    main_screen(@progress_arr, @lives)
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
