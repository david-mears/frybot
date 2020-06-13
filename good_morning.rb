# I originally sourced ly words from morewords.com: fed the html source through the below code.
#
# Then spent a few hours removing -ly words that are not adverbs (e.g. 'friendly', 'rely')
#
# require 'nokogiri'
# 
# doc = Nokogiri::HTML(
#   File.open('./words_ending_ly.html', 'r').read
# )
# 
# @words_ending_ly = []
# 
# doc.css('.search-results').css('a').each do |link|
#   @words_ending_ly.push(
#     link.content.tr("0-9", "").tr(" ", "").tr("\n", "")
#   )
# end

@words_ending_ly = []

File.new('adverbs_no_duplicates.txt', 'r').read.each_line do |line|
  @words_ending_ly.push(line.tr("\n", ""))
end

File.new('adverbs_which_have_previously_been_rated_highly.txt', 'r').read.each_line do |line|
  @words_ending_ly.push(line.tr("\n", ""))
end

@say_synonyms = []

File.new('say_synonyms_no_duplicates.txt', "r").read.each_line do |line|
  @say_synonyms.push(line.tr("\n", ""))
end

File.new('say_synonyms_which_have_previously_been_rated_highly.txt', 'r').read.each_line do |line|
  @say_synonyms.push(line.tr("\n", ""))
end

# Adverbs which modify other adverbs
@ad_adverbs = ['perhaps', 'somewhat', 'tolerably', 'slightly', 'more or less', 'a little', 'sort of', 'kind of', 'fairly', 'altogether', 'perfectly', 'utterly', 'wholly', 'relatively', 'unusually', 'almost', 'nearly', 'nigh-on', 'ever so', 'so', 'quite', 'not quite', 'rather', 'not so', 'not very', 'very', 'overly', 'too', 'not too']

@punctuations_for_interrupting_clause = [
  [", ", ", "], [", ", ", "], [", ", ", "], [", ", ", "], [", ", ", "],
  [" - ", " - "],
  [" - ", "! - "],
  [" (", ") "],
  [" (", "!) "]
]

@punctuations_for_ad_adverbs = [
  ["- ", " -"],
  ["- ", "! -"],
  ["- ", "? -"],
  ["(", ")"],
  ["(", "?)"],
  ["(", "!)"],
  ["", ""], ["", ""], ["", ""], ["", ""], ["", ""]
]

def time_of_day
  case Time.now.hour
  when 20..24
    return 'night'
  when 0..4
    return 'night'
  when 17..19
    return 'evening'
  when 12..16
    return %w[afternoon day].sample
  else
    return 'morning'
  end
end

def generate_phrase
  ly_words = [@words_ending_ly.sample]

  punc = @punctuations_for_ad_adverbs.sample

  ad_adverb = [punc[0] + @ad_adverbs.sample + punc[1], nil].sample

  [0, 0, 0, 0, 1].sample.times { ly_words.push(
    [ad_adverb, @words_ending_ly.sample].compact.join(" ")
  )}

  punc = @punctuations_for_interrupting_clause.sample

  say_synonym = @say_synonyms.sample

  interrupting_clause = [
    "as you", ly_words.join(' and '), say_synonym
  ].join(' ')

  ["Good#{punc[0]}#{interrupting_clause}#{punc[1]}#{time_of_day}.", ly_words, say_synonym]
end

def reinforce_component_words(output)
  open('adverbs_which_have_previously_been_rated_highly.txt', 'a') do |f|
    adverbs = output[1]
    adverbs.each { |adv| f << adv + "\n" }
  end

  open('say_synonyms_which_have_previously_been_rated_highly.txt', 'a') { |f| f << output[2] + "\n" }
end

def store_whole_phrase(output)
  open('favourites_store.txt', 'a') { |f| f << output[0] + "\n" }
end

def try_out
  output = generate_phrase
  puts "> " + output[0]
  puts
  puts "    How many stars would you give this output? (0-5)"
  puts "    I will store any outputs rated 5."
  puts "    For any output rated 4 or 5, the component words will be weighted more strongly."
  rating = gets.chomp!
  if rating == '4'
    reinforce_component_words(output)
    try_out
  elsif rating == '5'
    reinforce_component_words(output)
    store_whole_phrase(output)
    try_out
  else
    puts "    Not stored. Ah well. Try another!"
    puts
    try_out
  end
end
