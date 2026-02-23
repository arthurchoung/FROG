#!/usr/bin/perl

$path = shift @ARGV;
if (not $path) {
    die('specify path');
}

if ($path =~ m/\.(vgm|vgz)$/i) {
    system('vgmplay', $path);
    exit 0;
}

if ($path =~ m/\.mp3$/i) {
    system('ffplay', $path);
    exit 0;
}

if ($path =~ m/\.m4a$/i) {
    system('ffplay', $path);
    exit 0;
}

if ($path =~ m/\.mp4$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.mp4\.part$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.m4v$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.mkv$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.avi$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.webm$/i) {
    system('mpv', '--hwdec=auto', '--force-window=yes', '--volume-max=200', $path);
    exit 0;
}

if ($path =~ m/\.wav$/i) {
    system('ffplay', $path);
    exit 0;
}

if ($path =~ m/\.pdf$/i) {
    system('mupdf', $path);
    exit 0;
}

if ($path =~ m/\.html$/i) {
    system('chromium', $path);
    exit 0;
}

if ($path =~ m/\.mhtml$/i) {
    system('chromium', $path);
    exit 0;
}

if ($path =~ m/\.csv$/i) {
#.csv,"parseCSVFile|asListInterface"
    exit 0;
}

if ($path =~ m/\.jpg$/i) {
    system('feh', $path);
    exit 0;
}

if ($path =~ m/\.jpeg$/i) {
    system('feh', $path);
    exit 0;
}

if ($path =~ m/\.png$/i) {
    system('feh', $path);
    exit 0;
}

if ($path =~ m/\.xpm$/i) {
    system('feh', $path);
    exit 0;
}

if ($path =~ m/\.d64$/i) {
#    system('x64', $path);
    exit 0;
}

if ($path =~ m/\.(nes|smc|sfc|md|smd|sms|gb|bin|a26|sg)$/i) {
    system('frog', 'show', 'arg0|emulatorFromFile', $path);
    exit 0;
}

if ($path =~ m/\.webp$/i) {
    system('chromium', $path);
    exit 0;
}

if ($path =~ m/\.txt$/i) {
    open FH, $path || die;
    @lines = <FH>;
    close FH;
    open FH, "| frog alert" || die;
    foreach $line (@lines) {
        print FH $line;
    }
    close FH;
    exit 0;
}

system('frog', 'alert', "Unknown file type for '$path'");

