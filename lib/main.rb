# frozen_string_literal: true

DICTIONARY = '../src/dictionary.txt'

# any mathod that includes puts gets or print will be considered a UI method and belongs to this module
module UI
  SCREEN_SIZE = 30
  def main_menu(word)
    puts 'Welcome'
    puts word.join
  end

  def main_screen(bar, lives)
    puts "#{lives} lives remaining".rjust(SCREEN_SIZE)
    puts ''
    show_progress_bar(bar)
  end

  def collect_input
    gets.downcase.strip
  end

  def say_result(solved, word)
    puts "You #{solved ? 'win' : 'lose'}!"
    unless solved
      puts "The answer was: #{word.join}"
    end
  end

  def show_progress_bar(bar)
    bar.each { |e| e.nil? ? print('*') : print(e) }
    puts ''
  end
end

# game logic
class Game
  include UI

  def initialize
    @word = choose_random_word(DICTIONARY).split('')
    @progress_bar = Array.new(@word.size, nil)
    @lives = 10
    @solved = false
  end

  def play
    main_menu(@word)
    until @solved || @lives < 1
      main_screen(@progress_bar, @lives)
      guess = collect_input
      update(guess)
      @solved = solved?
    end
    say_result(@solved, @word)
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

hangman = Game.new
hangman.play
