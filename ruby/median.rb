#!/usr/bin/env ruby
@randnum=[]
allnum=7
big=0
bigsave=0
small=0
smallsave=0
median=-1

allnum.times do
    @randnum << rand(1000)
end

@randnum.each do |rand|
    puts "| #{rand} | "
    puts "median = #{median}"
    puts "big = #{big}"
    puts "bigsave = #{bigsave}"
    puts "small = #{small}"
    puts "smallsave = #{smallsave}"
    if(median != -1)
        if(rand >= median)
            big = big + 1
            if (big > 1)
                if(rand>=bigsave)
                    median=bigsave
                    big=0
                end
            end
            bigsave=rand
        else
            small = small + 1
            if (small > 1)
                if(rand<smallsave)
                    median=rand
                    small=0
                end
            end
            smallsave=rand
        end
        if(big == 1 && small == 1)
            big=0
            small=0
        end
    else
        median = rand
    end
end
puts median

@randnum = @randnum.sort
p @randnum
if(allnum%2==1)
    puts @randnum[allnum/2]
else
    puts (@randnum[allnum/2-1] + @randnum[allnum/2])/2
end
