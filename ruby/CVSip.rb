#!/usr/bin/env ruby
def inputipandcheck type
    print "#{type.upcase} CVS SERVER IP> "; STDOUT.flush; @inputip=gets.chomp
    while !@inputip.match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
        print "Invalid IP specified\n"
        inputipandcheck type
    end
    @inputip
end

print "CVS IP1: 10.10.64.121\n"
print "CVS IP2: 10.194.8.26\n\n"
print "CVS Module (DIR) Bobcat Starfish> "; STDOUT.flush; whichdir=gets.chomp
oldip=inputipandcheck 'old'
newip=inputipandcheck 'new'

filelist=Dir["#{whichdir}/**/CVS/Root"]

@insertLine=''
filecounter=1
filelist.each do |file|
    if @insertLine.length==0
        openfile = File.open(file, "r")
        while (line = openfile.gets)
        @insertLine = @insertLine + line
        end
        openfile.close
        puts "\nChange CVS setting from"
        puts "\t#{@insertLine}"
        @insertLine = @insertLine.gsub(/#{oldip}/, newip)
        puts "\t\tto"
        puts "\t#{@insertLine}\n"
        print "Are you sure? Y/N (yes)> ";STDOUT.flush; confirm=gets.chomp
        if confirm[0] =~ /^[Nn]/
            puts "Quit!"
            exit
        end
    end
    puts "#{filecounter}: #{file}"
    File.rename(file, "#{file}.bak")
    openfile = File.new(file,"w")
    openfile.write(@insertLine)
    openfile.close
    filecounter = filecounter + 1
end
