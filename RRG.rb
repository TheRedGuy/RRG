#!/usr/bin/env ruby -W0

# Set initial configurations
title  = "Title.tex"
body   = ["README.md"]
report = "Report.pdf"

def show_help
  puts  "Help:", "\n",
        "-h | -help   | --help\t\t\tShow help",
        "-t | -title  | --title  [file]\t\tSpecify title page (.tex)",
        "-o | -output | --output [file]\t\tSpecify output filename (.pdf)", "\n",
        "All other arguments will be treated as report pages"
end

# Simple option parser
unless ARGV.empty?
  arg = ARGV.shift
  case arg
  when '-h', '-help', '--help'
    show_help
    exit
  when '-t', '-title', '--title'
    title = ARGV.shift
  when '-o', '-output', '--output'
    report = ARGV.shift
  else
    body = ARGV
  end
end 

# Check if title file exists
unless File.exists? title
  puts "Error: \"#{title}\" not found"
  exit
end

# Check if body files exist
body.each do |doc|
  unless File.exists? doc
    puts "Error: \"#{doc}\" not found"
    exit
  end
end

# Array of modified files
files = []

### Change URLs of images to local path in body files
body.each_with_index do |doc, idx|
  # Get the contents of file
  file = File.open(doc, 'rb').read

  # Get an array of image URLs
  urls = file.scan(/!\[\w*\]\((\S*)\)/).flatten

  # Get local paths to images, assuming they are all in a folder in repo
  paths = urls.map{|url| url.split("/").last(2).join("/")}

  # Substitute URLs with local paths
  urls.each_with_index do |url, i| file.gsub! url, paths[i] end

  # Write the modified file: file#{idx}.md
  File.open("file\##{idx}.md", 'w') { |f| f.write file }

  # Add file name to array of modified files, to work with later
  files << "file\##{idx}.md"
end

# Create "temp" directory
system "mkdir temp"

# Report body PDFs
pdfs = []

# Create report body PDFs
files.each do |file|
  pdfs << file.sub(/(.md)/, ".pdf")
  system "pandoc #{file} -o temp/#{pdfs.last}"
end

# Change current dir to "temp"
Dir.chdir "temp"

# Create title PDF, as well as other LaTeX junk
system "pdflatex ../#{title}"

# Merge title PDF and body PDFs int report
system "gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=../#{report} #{title.sub /(.tex)/, ".pdf"} #{pdfs.join(' ')}"

# Up dir
Dir.chdir ".."

# Remove "temp" dir
system "rm -Rf temp"

# Remove .md body files
files.each do |file|
  system "rm #{file}"
end

