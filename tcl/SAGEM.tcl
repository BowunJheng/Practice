#   Askey Computer Corporation
#   ========= run this test loop for 1 or 2 hours ==============
#   a) opening a SF
#   b) sending some data through UGS during 20 seconds (80 kbps)
#   c) closing this SF
#   d) waiting 20 seconds
#
#   Please install net-snmp first. http://www.net-snmp.org
#   ============================================================
package req IxTclHal
#Parameters
set TotalExecuteTime 2
set CMIP "192.168.100.1"
set SRCIP "10.10.76.211"
set DSTIP "10.10.72.201"
set MibGroup ".1.3.6.1.4.1.1038.28.1.3.1"

set SecondPerLoop 40
set sleepsecond [expr $SecondPerLoop/2*1000]
set MibSrcIpAddress "$MibGroup.2"
set MibDstIpAddress "$MibGroup.3" 
set MibDsSfid "$MibGroup.11"
set MibUsSfid "$MibGroup.12"
set MibAdminStatus "$MibGroup.21"
set MibControlIndex ".1"
set Create 2
set Delete 3
set MaxCounter [expr $TotalExecuteTime * 60 / $SecondPerLoop]

set userName    IxiaTclUser 
set hostname    loopback
set chasId      1
set card        1
set txport1     2
set rxport1     1
set txport2     3
set rxport2     4
             
set txPortList  {{1 1 2} {1 1 3}}
set rxPortList  {{1 1 1} {1 1 4}}
set portList    {{1 1 1} {1 1 2} {1 1 3} {1 1 4}}
    
ixPuts "\n\t Sagem Tcl Test Script"

ixLogin $userName
ixPuts "\nUser logged in as:    $userName"

if [ixConnectToChassis $hostname] {
	return 1
}

if [ixTakeOwnership $portList] {
	return 1
}

ixPuts "\nIxTclHAL Version    :[version cget -ixTclHALVersion]"
ixPuts "Product version     :[version cget -productVersion]"
ixPuts "Installed version   :[version cget -installVersion]\n"
    
set counter 1
exec snmpset -v 1 -c private $CMIP $MibSrcIpAddress$MibControlIndex a $SRCIP
exec snmpset -v 1 -c private $CMIP $MibDstIpAddress$MibControlIndex a $DSTIP

while {$counter<=$MaxCounter} {
    ixPuts "a) opening a SF ($SRCIP <===> $DSTIP)" 
    #exec snmpset -v 1 -c private $CMIP $MibAdminStatus$MibControlIndex i $Create
    #ixPuts "DsSfid:" 
    #exec snmpget -v 1 -c public -O vq $CMIP $MibDsSfid$MibControlIndex
    #ixPuts "UsSfid:" 
    #exec snmpget -v 1 -c public -O vq $CMIP $MibUsSfid$MibControlIndex

    ixPuts "\nb) sending some data through UGS during 20 seconds (80 kbps)" 
    ixPuts "Start capture..." 
    if [ixStartCapture rxPortList] {
	    return -code error
    }
    ixPuts "Start transmit..."
    if [ixStartTransmit txPortList] {
	    return -code error
    }
    after $sleepsecond

    ixPuts "\nc) closing this SF ($SRCIP <!!!> $DSTIP)" 
    #exec snmpset -v 1 -c private $CMIP $MibAdminStatus$MibControlIndex i $Delete
    
    ixPuts "\nd) waiting 20 seconds" 
    ixPuts "Stop transmit..."
    if [ixStopTransmit txPortList] {
	    return -code error
    }
    ixPuts "Stop capture..."
    if [ixStopCapture rxPortList] {
	    return -code error
    }
    after $sleepsecond
    incr counter
}

if [stat get statAllStats $chasId $card $txport1] {
    ixPuts "Statistics get statAllStats failed for $chasId $card $rxport1"
    return 1
} else {
	ixPuts "\nport $txport1"
	ixPuts "Number of frames sent      :[stat cget -framesSent]"
	ixPuts "Tx line speed              :[stat cget -lineSpeed]"
}
if [stat get statAllStats $chasId $card $rxport1] {
    ixPuts "Statistics get statAllStats failed for $chasId $card $rxport1"
    return 1
} else {
	ixPuts "port $rxport1"
	ixPuts "Number of frames received  :[stat cget -framesReceived]"
	ixPuts "Rx line speed              :[stat cget -lineSpeed]"
}  

if [stat get statAllStats $chasId $card $txport2] {
    ixPuts "Statistics get statAllStats failed for $chasId $card $rxport2"
    return 1
} else {
	ixPuts "\nport $txport2"
	ixPuts "Number of frames sent      :[stat cget -framesSent]"
	ixPuts "Tx line speed              :[stat cget -lineSpeed]"
}
if [stat get statAllStats $chasId $card $rxport2] {
    ixPuts "Statistics get statAllStats failed for $chasId $card $rxport2"
    return 1
} else {
	ixPuts "port $rxport2"
	ixPuts "Number of frames received  :[stat cget -framesReceived]"
	ixPuts "Rx line speed              :[stat cget -lineSpeed]"
}  

if [capture get $chasId $card $rxport1] {
	ixPuts "Error getting capture data on $chasId $card $rxport"
	return 1
} else {    							
	ixPuts "\nport $rxport1"
	ixPuts "Number of packets captured :[capture cget -nPackets]"
}

if [capture get $chasId $card $rxport2] {
	ixPuts "Error getting capture data on $chasId $card $rxport2"
	return 1
} else {    							
	ixPuts "port $rxport2"
	ixPuts "Number of packets captured :[capture cget -nPackets]"
}

    ixPuts "\ntest complete.\n"
    ixClearOwnership $portList
    ixLogout
