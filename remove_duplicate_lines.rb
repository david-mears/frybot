read_file_names = ['say_synonyms', 'adverbs']

read_file_names.each do |file_name|
  read_file = File.new(file_name + ".txt", "r").read

  write_file = File.new("#{file_name}_no_duplicates.txt", "w")

  lines = []

  read_file.each_line { |line| lines.push(line) }

  lines.uniq.compact.each do |line|
      write_file.write(line)
  end
end
