#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Iface/socketudp_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Inet::Record::SocketUdp;;
use Tosf::Collection::Queue;
use Tosf::Exception::Trap;

my $x = Inet::Record::SocketUdp->new();

$x->set_callback_task("task0");
$x->set_callback_opcode(99);
$x->dump();

my $p = $x->dumps();
print("Dumps: $p");
