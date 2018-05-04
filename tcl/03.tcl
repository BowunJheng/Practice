puts [tcl::mathfunc::min 10 20]
puts [expr min(10,20)]
puts $argc
puts $argv
puts $argv0

array set fruit {
best kiwi
worst peach
ok banana
}
foreach {key value} [array get fruit] {
# key is ok, best, or worst
# value is some fruit
puts $key
}
puts $fruit("ok")
