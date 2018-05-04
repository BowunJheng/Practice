#!/usr/bin/env ruby
st="\033[7m"
en="\033[m"
str="this is a test"

puts "Enter an empty string at any time to exit."

while true
    if str.length == 0
        print "str> "; STDOUT.flush; str = gets.chop
        break if str.empty?
    end
    print "pat> "; STDOUT.flush; pat = gets.chop
    break if pat.empty?
    if pat=="newstr"
        str=""
    end
    re=Regexp.new(pat)
    puts str.gsub(re,"#{st}\\&#{en}")
end
