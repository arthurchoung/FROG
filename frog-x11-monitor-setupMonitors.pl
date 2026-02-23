#!/usr/bin/perl

$baseDir = __FILE__;
$baseDir =~ s/[^\/]*$//g;
if ($baseDir) {
    chdir $baseDir;
}

system('cat Temp/x11SetupMonitors-input.txt | frog-x11-monitor-generateScriptFromFile.pl | sh');
if (not -d 'Temp') {
    system('mkdir', 'Temp');
    system('chmod', '1777', 'Temp');
}

system('frog-x11-monitor-listMonitors.pl >Temp/x11ListMonitors-output.txt');

