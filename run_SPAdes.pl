#!/usr/bin/perl

#Runs SPAdes assembler in batch
#Make sure to put SPAdes in your PATH variable
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;

my %paired_files;
foreach my $file (@files){
    my ($file_name,$dir)=fileparse($file);
    if($file_name =~ /(.+)_R([1|2])_/){
	$paired_files{$1}[$2-1]=$file;
    #attempt different naming scheme
    }elsif($file_name =~ /(.+)_([1|2])/){
	$paired_files{$1}[$2-1]=$file;
    }else{
	warn "Input file does not contain '_R1_' or '_R2_' in name: $file";
    }
}

foreach my $name (sort keys %paired_files){
    unless(defined($paired_files{$name}[0]) && defined($paired_files{$name}[1])){
	warn "Couldn't find matching paired end files for file starting with: $name";
	next;
    }
    print "assembling your data....\n";
    print "----------------------\n";
    print "$paired_files{$name}[0]"." <--> "."$paired_files{$name}[1]"."\n";

    my $cmd="spades.py -t 16 --only-assembler -1 $paired_files{$name}[0] -2 $paired_files{$name}[1] -o $paired_files{$name}[0]_assembly";
    print $cmd,"\n";
    die if system($cmd);
}