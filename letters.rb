require 'active_support/all'
require './inflection'

print 'Inform letters: '
letters = gets.chomp.downcase
print 'Word length: '
length = gets.chomp.to_i
puts
puts '## Starting'

puts '--> Combining possibilities'
possibilities = letters.split('').sort.permutation(length).map(&:join).uniq

print '--> Loading dic... '
dic = File.readlines('pt-br.dic').map do |word|
  word = word.split('/').first.strip

  next if word.length < length

  word.downcase.mb_chars.normalize(:kd).gsub(/\p{Mn}/, '').to_s
end.compact.uniq.sort
puts "#{dic.length} loaded words"

puts '--> Searching...'
begin
  words = possibilities.map do |word|
    test = word.mb_chars.normalize(:kd).gsub(/\p{Mn}/, '').to_s

    if dic.bsearch { |w| test <=> w } || dic.bsearch { |w| test.pluralize <=> w }
      print '!'

      word
    end
  end.compact.uniq.sort
ensure
  puts
  puts
  print '--> Found: '
  puts words.any? && words.join(', ') || 'nothing'
end
