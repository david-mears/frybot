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

@verbs = []

File.new('verbs_no_duplicates.txt', "r").read.each_line do |line|
  @verbs.push(line.tr("\n", ""))
end

File.new('verbs_which_have_previously_been_rated_highly.txt', 'r').read.each_line do |line|
  @verbs.push(line.tr("\n", ""))
end

# Adverbs which modify other adverbs
@ad_adverbs = ['all too', 'perhaps', 'somewhat', 'tolerably', 'slightly', 'more or less', 'a little', 'sort of', 'kind of', 'fairly', 'altogether', 'perfectly', 'utterly', 'wholly', 'relatively', 'unusually', 'almost', 'nearly', 'nigh-on', 'ever so', 'so', 'quite', 'not quite', 'rather', 'not so', 'not very', 'very', 'overly', 'too', 'not too']

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
  ly_words = [@words_ending_ly.sample, @words_ending_ly.sample]

  adverb_phrase = [ly_words[0]]

  punc = @punctuations_for_ad_adverbs.sample

  ad_adverb = [punc[0] + @ad_adverbs.sample + punc[1], nil].sample

  [0, 0, 0, 0, 1].sample.times { adverb_phrase.push(
    [ad_adverb, ly_words[1]].compact.join(" ")
  )}

  punc = @punctuations_for_interrupting_clause.sample

  verb = @verbs.sample

  interrupting_clause = [
    "as you", adverb_phrase.join(' and '), verb
  ].join(' ')

  ["Good#{punc[0]}#{interrupting_clause}#{punc[1]}#{time_of_day}.", ly_words, verb]
end

def reinforce_component_words(output)
  open('adverbs_which_have_previously_been_rated_highly.txt', 'a') do |f|
    adverbs = output[1]
    adverbs.each { |adv| f << adv + "\n" }
  end

  open('verbs_which_have_previously_been_rated_highly.txt', 'a') { |f| f << output[2] + "\n" }
end

def flag_adverbs_for_removal(output)
  open('adverbs_to_remove_from_lexicon.txt', 'a') do |f|
    adverbs = output[1]
    adverbs.each { |adv| f << adv + "\n" }
  end
end

def store_whole_phrase(output)
  open('favourites_store.txt', 'a') { |f| f << output[0] + "\n" }
end

def try_out
  loop do
    output = generate_phrase
    puts "> " + output[0]
    puts
    puts "    How many stars would you give this output? (0-5)"
    puts "    I will store any outputs rated 5 for potential tweeting."
    puts "    For any output rated 4 or 5, the component words will be weighted more strongly."
    puts "    For any output rated 1, the adverbs will be removed from the lexicon."
    puts "    For any output rated 0, the verb will be removed from the lexicon."
    rating = gets.chomp!
    if rating == '4'
      reinforce_component_words(output)
    elsif rating == '5'
      reinforce_component_words(output)
      store_whole_phrase(output)
    elsif rating == '0'
      open('verbs_to_remove_from_lexicon.txt', 'a') { |f| f << output[2] + "\n" }
    elsif rating == '1'
      flag_adverbs_for_removal(output)
    elsif rating.downcase == 'exit' || rating.downcase == 'quit'
      puts "    Goodbye!\n"
      return
    else
      puts "    Not stored. Ah well. Try another!"
      puts
    end
  end
end
