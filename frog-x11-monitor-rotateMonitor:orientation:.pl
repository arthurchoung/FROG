#!/usr/bin/perl

$matchName = shift @ARGV;
$orientation = shift @ARGV;
if (not $matchName or not $orientation) {
    die('specify matchName and orientation');
}

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system("cat Temp/x11ListMonitors-output.txt | frog-x11-monitor-modifyToRotateMonitor:orientation:.pl $matchName $orientation >Temp/x11SetupMonitors-input.txt");

system('frog-x11-monitor-setupMonitors.pl');

