#!/usr/bin/ruby

###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <Tanner> <Gascon>
# <tanner.a.gascon@gmail.com>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "<Tanner> <Gascon>"
$counter = 0

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
					# do something for each line (if using windows)
				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				# do something for each line (if using macos or linux)
				cleanup_title(line)
			end
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end



def cleanup_title(line)
	# split the line on the value "<SEP>"
	values = line.split("<SEP>")

	# create a variable title and store the title of the song
	title = values[3]

	# Erase everything after a left parenthesis, bracket, curley brace, +, \, *, /, _, -, :, ', =, and following feat.
	title = title.gsub(/(\(.*|\[.*|\{.*|\+.*|\\.*|\*.*|\/.*|_.*|-.*|:.*|'.*|=.*|(feat..*))/,"")

	# Remove characters ?  ¿  !  ¡  .  ;  &  @  %  #  |
	title = title.gsub(/(\?|¿|!|¡|\.|;|&|@|%|#|\|)/,"")

	# Downcase the title
	title = title.downcase

	# Remove any non-ASCII song titles
	if title.match(/^[\d\w\s']+$/)
		#print the title and increment the counter
		puts title
		$counter=$counter+1
	end

	create_bigram(title)

	return title
end

def create_bigram(title)
	# split the song title into an array of words
	words = title.split(" ")
	# loop through the array adding the words to the hash table
	i=0
	words.each do |word|
		# Check if on the last word in the array
		if word != words.last
			# If the word exists in the hash table and the key word pair exists
			if $bigrams.has_key?(word) && $bigrams[word].has_key?(words[i+1])
				# increment the occurrence of the pair
				$bigrams[word][words[i+1]] = $bigrams[word][words[i+1]] + 1
			# else if the word exists in the hash table
			elsif $bigrams.has_key?(word)
				# add the paired word to the second hash and set the occurrence of the pairs to 1
				$bigrams[word][words[i+1]] = 1
			else
				# else the word is not in the hash table so create a new double
				# hash of the paired words and set the occurrence to 1
				$bigrams[word] = Hash.new()
				$bigrams[word][words[i+1]] = 1
			end
		end
		i=i+1
	end
end

# create function mcw to find the most common word
def mcw(input)
	# create variables
	count = 0
	mcw = ""

	# loop through the keys in the second hash based off the search word
	$bigrams[input].each_key do |word|
		# if the number of occurrences hasnt been set yet
		if count == 0
			#set the most common word to the first word
			mcw = word
			#set the count to the first number of occurrences
			count = $bigrams[input][word]
		#else if the number of occurrences of the current word is equal to the count of the mcw
		elsif $bigrams[input][word]==count
			#create a winning number 0 or 1
			winningNumber = rand(2)
			#if the winning number is zero
			if winningNumber == 0
				#change the most common word else it stays
				mcw = word
			end
		#else if the number of occurrences is greater than that of the current mcw
		elsif $bigrams[input][word] > count
			#change the mcw to the new word
			mcw = word
			#update the count
			count = $bigrams[input][word]
		end
	end
	#return the most common word
	return mcw
end

def create_title(word)
	counter = 0
	title = ""
	if title.length == 0 && $bigrams.has_key?(word)
		title = word
		word = mcw(word)
	else
		return word
	end
	while counter<19 && $bigrams[word].size>0
		temp = mcw(word)
		if
			title = title + " " + word
			word = temp
		end
		counter = counter+1
	end
	return title
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])
	puts $counter

	puts $bigrams["girl"]

	puts $bigrams["hey"]

	#Get user input until q is entered
	loop do
		puts "Enter a word [Enter 'q' to quit]:"
		#get word from user and store in word
		word = STDIN.gets.chomp
		#check if q was entered, if so break from loop
		break if word.eql?('q')
		#if a word was entered create a new title and display
		puts create_title(word)
	end
end

if __FILE__==$0
	main_loop()
end
