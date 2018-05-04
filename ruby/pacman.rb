#!/usr/bin/env ruby
require 'open-uri'

pacmanUrl='http://www.archlinux.org/packages/?limit=all&q='

arch=`uname -m`

if ARGV.size < 1
    print "Search> "; STDOUT.flush; keyword=gets.chomp
else
    keyword=ARGV[0]
end
url=URI.parse("#{pacmanUrl}#{keyword}")
url.open {|f|
    f.each {|line|
        @getresult= @getresult+line
    }
}
