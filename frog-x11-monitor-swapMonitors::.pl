#!/usr/bin/perl

$matchName1 = shift @ARGV;
$matchName2 = shift @ARGV;
if (not $matchName1 or not $matchName2) {
    die('specify matchName1 and matchName2');
}

if ($matchName1 eq $matchName2) {
    die('matchName1 and matchName2 are the same');
}

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system("cat Temp/x11ListMonitors-output.txt | frog-x11-monitor-modifyToSwapMonitors::.pl $matchName1 $matchName2 >Temp/x11SetupMonitors-input.txt");

system('frog-x11-monitor-setupMonitors.pl');

