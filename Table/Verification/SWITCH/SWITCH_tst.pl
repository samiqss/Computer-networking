#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/SWITCH/SWITCH_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Tosf::Exception::Trap;
use Inet::Table::SWITCH;
use Inet::Record::Switch;

print("Typical usage \n");
Inet::Table::SWITCH->add(400, "iface0");
Inet::Table::SWITCH->dump();

Inet::Table::SWITCH->set_time(400, 600);
my $x = Inet::Table::SWITCH->get_iface(400);
print("Iface $x \n");
my $str = Inet::Table::SWITCH->dumps();
print ($str, "\n"); 
