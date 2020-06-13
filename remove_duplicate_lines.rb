read_file = File.new('say_synonyms.txt', "r").read

write_file = File.new('say_synonyms_no_duplicates.txt', "w")

lines = []

read_file.each_line { |line| lines.push(line) }

lines.uniq.compact.each do |line|
    write_file.write(line)
end
