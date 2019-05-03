#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Switch/switch_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Inet::Record::Switch;
use Tosf::Exception::Trap;

my $x = Inet::Record::Switch->new();
$x->set_iface('44');
$x->set_time(100);
$x->dump();

my $y = $x->dumps();
print($y , "\n");
