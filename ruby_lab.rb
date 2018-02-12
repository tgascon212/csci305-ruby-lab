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
		IO.foreach(file_name) do |line|
			#send the line to the cleanup function to return a proper title
			title = cleanup_title(line)
		end
		puts $counter
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

	# Get user input
end

main_loop()
