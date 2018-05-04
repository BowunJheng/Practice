#!/usr/bin/env ruby
require 'pathname'

@openDir=''
if ARGV.size > 0
    @openDir= ARGV[0];
else
    print "Code Beautifier File/Directory > "; STDOUT.flush; @openDir=gets.chomp
end

pDir = Pathname.new(@openDir)

if pDir.directory?
    @recursiveDir = Dir.new(@openDir)
    @recursiveDir.each  do |file|
        if(file=="." || file=="..") then next end
        puts "#{file}\n"
    end
elsif pDir.file?
end
