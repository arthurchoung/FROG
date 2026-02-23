#!/usr/bin/perl

$arg = shift @ARGV;
if (not $arg) {
    die('specify interface');
}

if ($arg eq 'lo') {
    exit 0;
}

@lines = `frog-network-listInterfaces.pl`;
chomp @lines;

foreach $line (@lines) {
    $interface = '';
    if ($line =~ m/\binterface:([a-z0-9]+)/) {
        $interface = $1;
        $interface =~ s/\'//g;
    }
    if ($interface ne $arg) {
        next;
    }

    if ($line =~ m/\btype:([^\s]+)/) {
        $type = $1;
        $type =~ s/\'//g;
    }
    if ($line =~ m/\bup:([^\s]+)/) {
        $up = $1;
        $up =~ s/\'//g;
    }
    if ($line =~ m/\blowerUp:([^\s]+)/) {
        $lowerUp = $1;
        $lowerUp =~ s/\'//g;
    }
    if ($line =~ m/\boperstate:([^\s]+)/) {
        $operstate = $1;
        $operstate =~ s/\'//g;
    }
    if ($line =~ m/\baddress:([^\s]+)/) {
        $address = $1;
        $address =~ s/\'//g;
    }
    $dhcpcd = `pgrep -f 'dhcpcd.*$interface'`;
    chomp $dhcpcd;
    if ($dhcpcd =~ m/^(\d+)/) {
        $dhcpcd = $1;
    }

    $wireless = 0;
    open(FH, "iwconfig $interface |") or die('unable to run iwconfig');
    while ($line = <FH>) {
        if ($line =~ m/^$interface/) {
            if ($line =~ m/ESSID:/) {
                $wireless = 1;
            }
        }
    }
    close(FH);

    $text = "What to do with $interface?";
    $text =~ s/\\/\\\\/g;
    $text =~ s/"/\\"/g;
    $dhcpcdcmd = qq{dhcpcd 0 "dhcpcd $interface"};
    if ($dhcpcd) {
        $dhcpcdcmd = qq{killdhcpcd 0 "kill dhcpcd (kill -9 $dhcpcd)"}
    }
    $cmd = sprintf('frog radio OK Cancel %s %s %s %s %s %s %s',
        qq{"$text"},
        'nothing 1 "Do Nothing"',
        $dhcpcdcmd,
        qq{ifconfigup 0 "ifconfig $interface up"},
        qq{ifconfigdown 0 "ifconfig $interface down"},
        qq{rmmod 0 'rmmod e1000e'},
        qq{modrobe 0 'modrobe e1000e'});
    $result = `$cmd`;
    chomp $result;
    if ($result eq 'rmmod') {
        system('sudo', '-A', 'rmmod', 'e1000e');
    } elsif ($result eq 'modprobe') {
        system('sudo', '-A', 'modprobe', 'e1000e');
    } elsif ($result eq 'dhcpcd') {
        system('frog-network-connectInterface.pl', $interface);
    } elsif ($result eq 'killdhcpcd') {
        system('sudo', '-A', 'kill', '-9', $dhcpcd);
    } elsif ($result eq 'ifconfigup') {
        system('sudo', '-A', 'ifconfig', $interface, 'up');
    } elsif ($result eq 'ifconfigdown') {
        system('sudo', '-A', 'ifconfig', $interface, 'down');
    }
}

