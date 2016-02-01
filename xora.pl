#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
#use Data::Dumper;
use POSIX;
# === Global Variables ========================================================
my $inputFile = shift || die;
# === Main ====================================================================
sub main {
	open my $FH_IN, '<' . $inputFile || die;
	binmode $FH_IN;

	my $outputFile = $inputFile . '.xor';
	open my $FH_OUT, '>' . $outputFile || die;
	binmode $FH_OUT;
	
	my $buffer;
	my $size;
	while($size = read($FH_IN, $buffer, 4096)) {
		my @out = ();
		foreach my $val (unpack('C*', $buffer)) {
			push(@out, $val ^ 0xFF);
		}
		syswrite $FH_OUT, pack('C*', @out);
	}
	close $FH_OUT;
	close $FH_IN;
	exit 0;
}
&main();
__END__;
