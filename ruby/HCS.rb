#!/usr/bin/env ruby

if ARGV.size < 1
    exit
end

@insertLine=''
openfile = File.open(ARGV[0], "rb")
while (line = openfile.gets)
    @insertLine = @insertLine + line
end
openfile.close

mySum=0
byte = [0, 0, 0, 0]
for i in 0 .. 84
    value=@insertLine[i].ord()
    order=i%4;
    mySum = mySum + value
    byte[order] = byte[order] + value 
    #puts byte.ord()
end
puts mySum.to_s(16)
puts (byte[0]%256).to_s(16)+(byte[1]%256).to_s(16)+(byte[2]%256).to_s(16)+(byte[3]%256).to_s(16)
