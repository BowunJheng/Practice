#!/usr/bin/env ruby
require 'snmp'

allcmd = ["ip","get","getonce","setonce","set","sleep","times"]

def getcmd (file,oidarray)
    SNMP::Manager.open(:Host => @hostip) do |manager|
        response = manager.get(oidarray)
        response.each_varbind do |vb|
            puts "[#{vb.value.asn1_type}]\t#{vb.value.to_s}"
            file.puts(vb.value.to_s)
        end
    end
end

def setcmd oidarray
    manager = SNMP::Manager.new(:Host => @hostip)
    varbindlist=SNMP::VarBindList.new
    index=0
    p oidarray
    while(index<oidarray.count)
        case oidarray[index+1]
            when 't'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::TimeTicks.new(oidarray[index+2]))
            when 'a'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::IpAddress.new(oidarray[index+2]))
            when 'o'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::ObjectId.new(oidarray[index+2]))
            when 's'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::OctetString.new(oidarray[index+2]))
            when 'x'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::OctetString.new(oidarray[index+2]).hex)
            when 'd'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::OctetString.new(oidarray[index+2])..unpack('i'))
            when 'u','U'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::UnsignedInteger.new(oidarray[index+2].to_i))
            when 'i','I'
                varbind = SNMP::VarBind.new(oidarray[index], SNMP::Integer.new(oidarray[index+2].to_i))
            when 'F','D'
                varbind = SNMP::VarBind.new(oidarray[index], Float.induced_from(oidarray[index+2].to_f))
        end
        varbindlist.push(varbind)
        index+=3
    end
    manager.set(varbindlist)
    manager.close
end

if ARGV.size < 1
    filename="Loop"
else
    filename=ARGV[0]
end

cmdarray = Array.new
round=-1
@hostip='192.168.100.1'
openfile = File.open(filename, "r")
openfile.each do |insertLine|
    @thisLine = insertLine.gsub(/(.*)#.*/,'\1').strip
    if(@thisLine.length > 0 ) then
        cmdtype=@thisLine.split(/[\s|\t]+/)
        cmdtype[0]=cmdtype[0].downcase
        if (allcmd.include?(cmdtype[0])) then
            if(cmdtype[0]=="times") then
                round=cmdtype[1].to_i
            else
                cmdarray.push(cmdtype)
            end
        else
            puts "Warming: cmd[ " + cmdtype[0] + " ] is not supported!!\n"
        end
    end
end
openfile.close

writefile = File.open("SNMPlog.txt", "w")
writefile.puts("StartTime: "+Time.now.to_s)
writefile.puts("HOST: "+@hostip)
deletearray = Array.new
while (round > 0 || round<=-1)
    puts Time.now
    count=1
    if(deletearray.empty?()==false) then
        deletearray.each do |deletecmd|
            cmdarray.delete(deletecmd)
        end
        deletearray.clear
    end
    cmdarray.each do |cmd|
        puts count.to_s + ': ' + cmd.join(' ')
        count+=1
        if(cmd[0]=="ip") then
            if(@hostip==cmd[1]) then next end
            writefile.puts("HOST: "+cmd[1])
            @hostip=cmd[1]
        elsif(cmd[0]=="get")
            getcmd(writefile,cmd[1..cmd.length])
        elsif(cmd[0]=="getonce")
            getcmd(writefile,cmd[1..cmd.length])
            deletearray.push(cmd)
        elsif(cmd[0]=="set")
            setcmd cmd[1..cmd.length]
        elsif(cmd[0]=="setonce")
            setcmd cmd[1..cmd.length]
            deletearray.push(cmd)
        elsif(cmd[0]=="sleep")
            sleep cmd[1].to_i
        end
    end
    puts "\n"
    round-=1
end
writefile.puts("EndTime: "+Time.now.to_s)
writefile.close
