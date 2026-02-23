#!/usr/bin/perl

$interface = shift @ARGV;
if (not $interface) {
    die('specify interface');
}

$dhcpcd = `pgrep -f 'dhcpcd.*$interface'`;
chomp $dhcpcd;
if ($dhcpcd) {
    system('frog', 'alert', "dhcpcd for $interface already running", '', "pid $dhcpcd");
    exit 1;
}

system('sudo', '-A', 'ifconfig', $interface, 'up');

system('frog', 'prgbox', 'sudo', '-A', 'dhcpcd', '-4', $interface);

#if (open FH, "sudo -A dhcpcd -4 $interface 2>&1 | frog progress |") {
#    $addr = undef;
#    while ($line = <FH>) {
#        chomp $line;
#        if ($line =~ m/ leased ([\d\.]+)/) {
#            $addr = $1;
#        }
#    }
#    close(FH);
#    if ($addr) {
#        system('frog', 'alert', "Obtained address $addr");
#    } else {
#        $dhcpcd = `pgrep -f 'dhcpcd.*$interface'`;
#        chomp $dhcpcd;
#        if ($dhcpcd) {
#            `sudo -A kill $dhcpcd`;
#        }
#        system('frog', 'alert', 'Unable to obtain address');
#    }
#}

