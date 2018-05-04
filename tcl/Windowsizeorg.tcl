set SIMTIMER 100
set PACKETSIZE 512
set CWND 1024

#java::field drcl.inet.transport.TCP AWND_DEFAULT $CWND
java::field drcl.inet.transport.TCP MAXCWND_DEFAULT $CWND
java::field drcl.inet.transport.TCP INIT_SS_THRESHOLD 65536

cd [mkdir -q drcl.comp.Component /WindowSize]
# create the topology
puts "create topology..."
set link_ [java::new drcl.inet.Link]
$link_ setPropDelay 0.01; # 10ms
set adjMatrix_ [java::new {int[][]} 2 { {1} {0} }]
java::call drcl.inet.InetUtil createTopology [! .] $adjMatrix_ $link_

puts "create builders..."
# router builder:
set rb [mkdir drcl.inet.NodeBuilder .routerBuilder]
$rb setBandwidth 1.0e8; #100Mbps

# source builder:
set hb1 [cp $rb .hostBuilder1]
	set tcp_ [mkdir drcl.inet.transport.TCP $hb1/tcp]
	$tcp_ setMSS $PACKETSIZE; # bytes
	set src_ [mkdir drcl.inet.application.BulkSource $hb1/source]
	$src_ setDataUnit $PACKETSIZE
	connect -c $src_/down@ -and $hb1/tcp/up@

# sink builder:
set hb2 [cp $rb .hostBuilder2]
	mkdir drcl.inet.transport.TCPSink $hb2/tcpsink
	set sink_ [mkdir drcl.inet.application.BulkSink $hb2/sink]
	connect -c $sink_/down@ -and $hb2/tcpsink/up@


puts "build..."
$hb1 build [! h0]
$hb2 build [! h1]

# Set up TCP connections
! h0/tcp setPeer 1

puts "setup static routes..."
java::call drcl.inet.InetUtil setupRoutes [! h0] [! h1] "bidirection"

puts "Set up TrafficMonitor & Plotter..."
set plot_ [mkdir drcl.comp.tool.Plotter .plot]
foreach i {1} {
	set tm$i\_ [mkdir drcl.net.tool.TrafficMonitor .tm$i]
	connect -c h$i/csl/6@up -to .tm$i/in@
	set j [expr $i-1]
	connect -c .tm$i/bytecount@ -to $plot_/$j@0
	#connect -c h$i/tcpsink/seqno@ -to $plot_/$j@2
}
! .tm? configure 10.0 4.0; # window size, update interval
foreach i {0} {
	connect -c h$i/tcp/cwnd@ -to $plot_/$i@1
	#connect -c h$i/tcp/srtt@ -to $plot_/$i@3
}

puts "simulation begins..."	
set sim [attach_simulator .]
run h0/source
script {puts [$sim getTime]} -period 50.0 -on $sim
script {puts "END"} -at $SIMTIMER -on $sim
$sim stopAt $SIMTIMER
