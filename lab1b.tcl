#same first program for udp [not in syllabus]
set ns [new Simulator]
set nf [open lab1.nam w]
$ns namtrace-all $nf
set tf [open lab1.tr w]
$ns trace-all $tf

proc finish { }
{
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam lab1.nam &
exec echo "Total number of packets dropped " &
exec grep -c "^d" lab1.tr &
exit 0
}
set n0 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 200Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.0024Mb 100ms dropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
setcbr0 [new Application/Traffic/CBR]

$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $udp0
$ns connect $udp0 $null0

$ns at 0.1 "$cbr0 start"
$ns at 1.0 "finish"
$ns run
