#!tclsh
set A 10;set B "TEST"
puts "[expr $A*5] $B"
unset A
#foreach var {a b c} {
      if {[info exists A]} {
          puts "does indeed exist"
      } else {
          puts "sadly does not exist"
      }
#  }
gets stdin TEST
puts $TEST

