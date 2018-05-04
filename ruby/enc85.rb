#!/usr/bin/env ruby
require 'ipaddr'
ascii85=('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
ascii85.push('!', '#', '$', '%', '&', '(', ')', '*', '+', '-', ';', '<', '=', '>', '?', '@', '^', '_', '`', '{', '|', '}', '~')
index=[]

if ARGV.size > 0
    ipaddr = IPAddr.new ARGV[0]
    addr=ipaddr.to_i
else
    ipaddr = IPAddr.new '1080:0:0:0:8:800:200C:417A'
    addr=0x108000000000000000080800200C417A
end
ipaddrstr=addr.to_s(16)
(1...8).each do |value|
    ipaddrstr.insert(value*4+value-1,':')
end
puts "#{ipaddr} ==> #{ipaddrstr}"
puts "(#{addr})"
while addr>0 do
    index << addr%85
    addr/=85
end

encstr=''
puts index.reverse.join('-')
index.reverse_each do |value|
    encstr="#{encstr}#{ascii85[value]}"
end
puts
puts encstr
