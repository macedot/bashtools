#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
#use Data::Dumper;
use Thread qw(async);
use threads::shared;
use POSIX;
# === Global Variables ========================================================
my $numThreads = 10;
my $verbose = 0;
my $params = GetOptions (
 'threads=n' => \$numThreads,
 'verbose|v' => \$verbose,
);
my @retCodes :shared;
# === Main ====================================================================
sub main {
	{
		lock(@retCodes);
		@retCodes = ();
	}
	my @threads = ();
	$numThreads = 1 if $numThreads < 1;
	foreach my $cmd (<>) {
		chomp $cmd;
		my $thd = async {
			my $ret = system("$cmd");
			print "CMD=[$cmd];RET=$ret\n" if $verbose;
			{ lock(@retCodes); push(@retCodes, $ret); }
		};
		push(@threads, $thd);
		while(threads->list(threads::running) >= $numThreads) {
			sleep 1;
		}
	}
	map { $_->join; } @threads;	
	my $ret = 0;  map { $ret |= $_; } @retCodes;
	exit ($ret != 0);
}
&main();
__END__;
