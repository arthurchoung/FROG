#!/usr/bin/perl

$path = shift @ARGV;
if (not $path) {
    die('specify path');
}

#$output = `frog confirm Unmount Cancel 'Unmount $path?'`;
#chomp $output;
#if ($output ne 'Unmount') {
#    exit 1;
#}

system('sudo', '-A', 'umount', $path);
if ($? != 0) {
    system('frog', 'alert', "Unable to unmount $path");
    exit 1;
}
system('sync');
system('frog', 'alert', "$path has been unmounted");
exit 0;

