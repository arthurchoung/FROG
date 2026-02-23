#!/usr/bin/perl

$result = `frog confirm Restart Cancel 'Restart?'`;
chomp $result;

if ($result eq 'Restart') {
    system("sudo -A reboot");
}

