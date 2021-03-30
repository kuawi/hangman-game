# frozen_string_literal: true

DICTIONARY = '../src/dictionary.txt'

def choose_random_word(dictionary)
  dictionary = File.open(dictionary)
  random_pos = rand(dictionary.size)
  dictionary.pos = random_pos
  string = dictionary.read(26).downcase
  dictionary.close
  string.match(/\n[a-z]*\n/)[0].strip
end

puts choose_random_word(DICTIONARY)
