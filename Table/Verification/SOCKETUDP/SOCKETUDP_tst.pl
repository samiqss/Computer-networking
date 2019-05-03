#!/usr/bin/perl
######################################################
# Peter Walsh
# File: SOCKETUDP_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Inet::Table::SOCKETUDP;
use Inet::Record::SocketUdp;
use Tosf::Exception::Trap;


my $p;

$p = Inet::Table::SOCKETUDP->open(
   callback_task => "Peter",
   callback_opcode => 66
);

print("Returned Port $p \n");

$p = Inet::Table::SOCKETUDP->open(
   callback_task => "Paul",
   callback_opcode => 67
);

print("Returned Port $p \n");

$p = Inet::Table::SOCKETUDP->open(
   port => 8080,
   callback_task => "Mary",
   callback_opcode => 68
);

print("Returned Port $p \n");

$p = Inet::Table::SOCKETUDP->open(
   callback_task => "Tom",
   callback_opcode => 99
);

print("Returned Port $p \n \n");


Inet::Table::SOCKETUDP->dump();

print("============================\n\n");

Inet::Table::SOCKETUDP->close($p);

Inet::Table::SOCKETUDP->dump();

print("============================\n\n");

my $cbt = Inet::Table::SOCKETUDP->get_callback_task(2000);
my $cbo = Inet::Table::SOCKETUDP->get_callback_opcode(2000);
print("Callback Task $cbt Callback Opcode $cbo \n");

print("\n \n Typical Usage \n \n");

$p = Inet::Table::SOCKETUDP->open(
   callback_task => "Inc",
   callback_opcode => 1
);

$p = Inet::Table::SOCKETUDP->open(
   port => 40,
   callback_task => "Incd",
   callback_opcode => 1
);

$p = Inet::Table::SOCKETUDP->open(
   callback_task => "Render",
   callback_opcode => 1
);

$p = Inet::Table::SOCKETUDP->open(
   port => 80,
   callback_task => "Renderd",
   callback_opcode => 1
);

Inet::Table::SOCKETUDP->dump();



