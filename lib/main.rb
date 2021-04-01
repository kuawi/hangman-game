# frozen_string_literal: true

require 'yaml'

DICTIONARY = '../src/dictionary.txt'
MEMORY_SLOT_1 = '../save/save_slot_1.txt'

# any mathod that includes puts gets or print will be considered a UI method and belongs to this module
module UI
  SCREEN_SIZE = 30
  def self.main_menu
    puts 'Welcome'
    ask_type_of_game
  end

  def self.ask_type_of_game
    puts "Type 'new' to start a new game"
    gets.downcase.strip
  end

  def main_screen(bar, lives)
    puts "#{lives} lives remaining".rjust(SCREEN_SIZE)
    puts ''
    show_progress_bar(bar)
  end

  def collect_input
    gets.downcase.strip
  end

  def save_request?(request)
    return true if request == 'save'

    false
  end

  def say_result(solved, word)
    puts "You #{solved ? 'win' : 'lose'}!"
    puts "The answer was: #{word.join}" unless solved
  end

  def show_progress_bar(bar)
    bar.each { |e| e.nil? ? print('*') : print(e) }
    puts ''
  end

  def save_completed_msg
    puts 'Game saved'
    puts 'Returning to main menu'
  end
end

# serialization and writing to file
module SaveGame
  include UI

  def save(word, progress_bar, lives)
    slot = File.open(MEMORY_SLOT_1, 'w')
    slot.puts serialize(word, progress_bar, lives)
    save_completed_msg
  end

  private

  def serialize(word, progress_bar, lives)
    YAML.dump({
                word: word,
                progress_bar: progress_bar,
                lives: lives
              })
  end
end

# game logic
class Game
  include UI
  include SaveGame

  def initialize(word = choose_random_word(DICTIONARY).split(''), progress_bar = Array.new(word.size, nil), lives = 10)
    @word = word
    @progress_bar = progress_bar
    @lives = lives
    @solved = false
  end

  def play
    until @solved || @lives < 1
      main_screen(@progress_bar, @lives)
      guess = collect_input
      if save_request?(guess)
        save(@word, @progress_bar, @lives)
        break
      end
      update(guess)
      @solved = solved?
    end
    say_result(@solved, @word) unless save_request?(guess)
  end

  private

  def update(guess)
    @lives -= 1 if @progress_bar.include?(guess)
    if @word.include?(guess)
      @progress_bar = @progress_bar.each_with_index.map do |spot, i|
        @word[i] == guess ? guess : spot
      end
    else
      @lives -= 1
    end
  end

  def solved?
    return true if @word == @progress_bar

    false
  end

  def choose_random_word(dictionary)
    dictionary = File.open(dictionary)
    random_pos = rand(dictionary.size)
    dictionary.pos = random_pos
    string = dictionary.read(26).downcase
    dictionary.close
    string.match(/\n[a-z]*\n/)[0].strip
  end
end

if UI.main_menu == 'new'
  hangman = Game.new
  hangman.play
end
