#!/usr/bin/env ruby

# Check if "Title.tex" exists
unless File.exists? "Title.tex"
  puts "Error: \"Title.tex\" not found"
  exit
end

# Check if "README.md" exists
unless File.exists? "README.md"
  puts "Error: \"README.md\" not found"
  exit
end

# Change URL of images to a local path, in README.md
# Get the contents of "README.md"
readme = File.open("README.md", "rb").read
# Get an array of image URLs
urls = readme.scan(/!\[\w*\]\((\S*)\)/).flatten
# Get local paths to those images
# It assumes your pictures are all in a folder in lab dir
paths = urls.map{|url| url.split("/").last(2).join("/")}
# Substitute URLs with local paths
urls.each_with_index do |url, i| readme.gsub! url, paths[i] end
# Write a modified README.md => "README_local.md"
File.open("README_local.md", 'w') { |file| file.write readme }

# Set postfix (ex: "lab#1", if current dir is "lab#1")
postfix = Dir.pwd.split(/[\/|\\]/).last

# Create "temp" directory
system "mkdir temp"

# Create "Content.pdf" in "temp" dir
system "pandoc README_local.md -o temp/Content.pdf"

# Change current dir to "temp"
Dir.chdir "temp"

# Create "Title.pdf" and other LaTeX junk in "temp" dir
system "pdflatex ../Title.tex"

# Set report filename (ex: "Report_lab#1.pdf")
filename = "Report_" + postfix + ".pdf"

# Merge "Title.pdf" and "Content.pdf" into "../Report"
system "gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=../#{filename} Title.pdf Content.pdf"

# Up dir
Dir.chdir ".."

# Remove "temp" dir
system "rm -Rf temp"

# Remove "README_local.md"
system "rm README_local.md"







