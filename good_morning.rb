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

File.new('adverbs.txt', 'r').read.each_line do |line|
  @words_ending_ly.push(line.tr("\n", ""))
end

@say_synonyms = []

File.new('say_synonyms_no_duplicates.txt', "r").read.each_line do |line|
  @say_synonyms.push(line.tr("\n", ""))
end

# Adverbs which modify other adverbs
@ad_adverbs = ['perhaps', 'somewhat', 'tolerably', 'slightly', 'more or less', 'a little', 'sort of', 'kind of', 'fairly', 'altogether', 'perfectly', 'utterly', 'wholly', 'relatively', 'unusually', 'almost', 'nearly', 'nigh-on', 'ever so', 'so', 'quite', 'not quite', 'rather', 'not so', 'not very', 'very', 'overly', 'too', 'not too']

@punctuations = [
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

def generate_phrase
  ly_words = [@words_ending_ly.sample]

  punc = @punctuations_for_ad_adverbs.sample

  ad_adverb = [punc[0] + @ad_adverbs.sample + punc[1], nil].sample

  [0, 0, 0, 0, 1].sample.times { ly_words.push(
    [ad_adverb, @words_ending_ly.sample].compact.join(" ")
  )}

  punc = @punctuations.sample

  interrupting_clause = [
    "as you", ly_words.join(' and '), @say_synonyms.sample
  ].join(' ')

  case Time.now.hour
  when 20..24
    @time_of_day = 'night'
  when 0..4
    @time_of_day = 'night'
  when 17..19
    @time_of_day = 'evening'
  when 12..16
    @time_of_day = 'day'
  else
    @time_of_day = 'morning'
  end

  "Good#{punc[0]}#{interrupting_clause}#{punc[1]}#{@time_of_day}."
end

def try_out
  output = generate_phrase
  puts "> " + output
  puts
  puts "    How many stars would you give this output? (0-5)"
  puts "    (I will store any outputs scoring 4 or higher. I don't store the rating.)"
  rating = gets.chomp!
  if rating == '4' || rating == '5'
    open('favourites_store.txt', 'a') do |f|
      f << output + "\n"
    end
    try_out
  else
    puts "    Not stored. Ah well. Try another!"
    puts
    try_out
  end
end
