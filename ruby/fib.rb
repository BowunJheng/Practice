#!/usr/bin/env ruby
def fib invalue
    if invalue < 2
        invalue
    else
        fib(invalue-1) + fib(invalue-2)
    end
end

if ARGV.size==0
    print "value> "; STDOUT.flush; inputvalue=gets.chomp.split(/ /)
else
    inputvalue=ARGV
end

inputvalue.each do |value|
    @value=value.to_i
    puts 'fib(' + value  +') = ' + fib(@value).to_s
end
