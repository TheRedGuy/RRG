RRG
===
This is a script called "Ruby Report Generator" that I developed to generate report PDF files for my laboratory works.

Prerequisites
-------------
- UNUX-like system (I didn't test this script on Windows; it may work, but I don't guaranty it!).
- [Ruby](http://www.ruby-lang.org/en/downloads/) (it's a Ruby script - duh!).
- [Pandoc](http://johnmacfarlane.net/pandoc/installing.html)
- [MikTex](http://www.miktex.org/) (it comes with a command-line tool `pdflatex` which is used in this script).
- [GhostScript](http://ghostscript.com/doc/current/Install.htm) (as far as I know, MacOS users have it by default).

Usage
-----
Copy/paste this script in the directory of your lab or project.  
It expects in the same directory 2 files:
1. `Title.tex` which is the title page of your report.
2. `README.md` which is the contets of your report.
In this repo you'll fine examples of both files. Feel free to use them as templates. Also, you can find the resulting PDF that this script generated.

Note that the filenames are hard-coded in the script. If you want to change them, feel free to do so, it shoudn't be too difficult.

Once you have everything you need, just run the script:
```sh
ruby RRG.rb
```
You should now see a new PDF, with the name `Report_[current_dir_name].pdf` (this is also hard-coded; change it to your needs).

Advanced
--------
Since it's a Ruby script, if you feel that you'll be using it a lot, you can make it an executable, and put it somewhere in your $PATH (ex: "/usr/bin" or "/usr/local/bin").
```sh
cp RRG.rb RRG
chmod 755 RRG
mv RRG /usr/local/bin
```

After this is done, you can just `cd` into any directory which contains the necesarry files, and enter `RRG` in your command-line, and voila! Your report is ready!





