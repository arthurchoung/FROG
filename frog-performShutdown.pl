#!/usr/bin/perl

$result = `frog confirm Shutdown Cancel 'Shutdown?'`;
chomp $result;

if ($result eq 'Shutdown') {
    system("sudo -A poweroff");
}

