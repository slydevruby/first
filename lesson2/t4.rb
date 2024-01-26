all_letters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя".chars
vowels = "аеёиоуыэюя"

vowel_hash = {}
all_letters.each_with_index do |letter, index|
  vowel_hash[letter] = index if vowels.include? letter
end

puts vowel_hash