#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/IFACE/IFACE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Inet::Table::IFACE;
use Inet::Record::Iface;
use Inet::Table::ROUTE;
use Inet::Record::Route;
use Tosf::Collection::Line;
use Tosf::Exception::Trap;


Inet::Table::IFACE->set_opened('p0', '1');
Inet::Table::IFACE->enqueue_packet('p0', 'Test P0');

Inet::Table::IFACE->set_opened('p1', '0');
Inet::Table::IFACE->enqueue_packet('p1', 'Test P1');
Inet::Table::IFACE->dump();

#Inet::Table::IFACE->flush('peter');
Inet::Table::IFACE->dump();

Inet::Table::IFACE->enqueue_packet('Interface9', 'HelloWorld\n');
Inet::Table::IFACE->set_packet_type('Interface9', 'stream');
my $str = Inet::Table::IFACE->get_streamIface();
print("XXX STREAM $str \n");
Inet::Table::IFACE->dump();

print("HHHHHHHHHHHHHHHHHHHHHHH\n");
Inet::Table::IFACE->set_drop_flag("Peter", 22);
my $v = Inet::Table::IFACE->get_drop_flag("Peter");
print("Value of drop $v \n");
Inet::Table::IFACE->set_duplicate_flag("Peter", 33);
$v = Inet::Table::IFACE->get_duplicate_flag("Peter");
print("Value of duplicate $v \n");
Inet::Table::IFACE->dump();

