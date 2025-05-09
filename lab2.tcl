# 2.⁠ ⁠Network Congestion Analysis
#Implement the transmission of ping messages/trace rlab2e over a network topology consisting of 6 nodes and find the number of packets dropped due to congestion.
set ns [ new Simulator ]

$ns color 1 blue
$ns color 2 red

set namfile [open lab2.nam w]
$ns namtrace-all $namfile

set tracefile [open lab2.tr w]
$ns trace-all $tracefile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 0.1Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.4Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 10ms DropTail

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts " node [$node_ id] recieved ping answer from $from with round trip time $rtt ms "
}

set p0 [ new Agent/Ping ]
$p0 set class_ 1
$ns attach-agent $n0 $p0

set p1 [ new Agent/Ping]
$p1 set class_ 1
$ns attach-agent $n5 $p1
$ns connect $p0 $p1

$ns queue-limit $n2 $n3 2

set tcp [ new Agent/TCP ]
$tcp set class_ 2
$tcp set fid_ 1
set sink [ new Agent/TCPSink ]
$ns attach-agent $n2 $tcp
$ns attach-agent $n4 $sink

$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr set packetSize_ 500
$cbr set rate_ 1 Mb
$cbr attach-agent $tcp

proc finish {} {
	global ns tracefile namfile
        $ns flush-trace 	
        close $tracefile
	close $namfile
	exec nam lab2.nam &
	exec echo "The number of ping message dropped is: " &
	exec grep "^d" lab2.tr | cut -d " " -f 5 | grep -c "ping" &
	exit 0
}

$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 0.4 "$cbr start"
$ns at 0.8 "$p0 send"
$ns at 1.0 "$p1 send"
$ns at 1.2 "$cbr stop"
$ns at 1.4 "$p0 send"
$ns at 1.6 "$p1 send"
$ns at 1.8 "finish"
$ns run
