#!/usr/bin/perl
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : main.pl
#
# Purpose      : main inetApp routine for inet applications
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#========================================================

$SIG{INT} = sub {leaveScript();};

$SIG{PIPE} = 'IGNORE';

$SIG{ALRM} = sub {
   my $tl = Tosf::Exception::Monitor->new(
      fn => sub {
	Tosf::Executive::SCHEDULER->tick();
      }
   );
   $tl->run();
};


$|=1;

use strict;
use warnings;
no warnings "experimental::smartmatch";

#use Sys::Mlockall qw(:all);
#if (mlockall(MCL_CURRENT | MCL_FUTURE) != 0) { die "Failed to lock RAM: $!"; }

use lib '../';
use Try::Tiny;
use Time::HiRes qw (ualarm);
use Scalar::Util qw(looks_like_number);
#use HTML::Display;

use IO::Socket::INET;
use IO::Select;
use Tosf::Table::QUEUE;
use Tosf::Table::PQUEUE;
use Tosf::Table::TASK;
use Tosf::Table::SEMAPHORE;
use Tosf::Record::SVar;
use Tosf::Record::Task;
use Tosf::Record::Semaphore;
use Tosf::Record::Message;
use Tosf::Collection::Queue;
use Tosf::Collection::PQueue;
use Tosf::Collection::Line;
use Tosf::Collection::STATUS;
use Tosf::Exception::Trap;
use Tosf::Exception::Monitor;
use Tosf::Table::SVAR;
use Tosf::Table::TASK;
use Tosf::Table::SEMAPHORE;
use Tosf::Table::MESSAGE;
use Tosf::Executive::TIMER;
use Tosf::Executive::SCHEDULER;
use Tosf::Executive::DISPATCHER;
use Tosf::Fsm::To;

use Inet::Record::Iface;
use Inet::Record::Arp;
use Inet::Record::Switch;
use Inet::Record::Route;
use Inet::Record::SocketUdp;
use Inet::Record::Cache;
use Inet::Plant::SETUP;
use Inet::Table::IFACE;
use Inet::Table::ARP;
use Inet::Table::SWITCH;
use Inet::Table::ROUTE;
use Inet::Table::SOCKETUDP;
use Inet::Table::CACHE;
use Inet::Fsm::IfaceCon;
use Inet::Fsm::SocConS;
use Inet::Fsm::SocConC;
use Inet::Fsm::StreamCon;
use Inet::Fsm::HBeat;
use Inet::Fsm::Ethernet;
use Inet::Fsm::Ip;
use Inet::Fsm::Icmp;
use Inet::Fsm::Udp;
use Inet::Fsm::Hub;
use Inet::Fsm::P2p;
use Inet::Fsm::Sniffer;
use Inet::Fsm::Switch;
use Inet::Fsm::SwitchTablePurge;
use Inet::Packet::Ethernet;
use Inet::Packet::Ip;
use Inet::Packet::Icmp;
use Inet::Packet::Udp;
use Inet::Packet::Generic;
use Inet::Fsm::Arp;
use Inet::Fsm::ArpTablePurge;
use Inet::Packet::Arp;
use Inet::Collection::FLAG;
use Inet::Collection::SYSTEM;

use inetApp::Fsm::Shell;
use inetApp::Fsm::Render;
use inetApp::Fsm::Renderd;
use inetApp::Fsm::Inc;
use inetApp::Fsm::Incd;
use inetApp::Fsm::Dns;
use inetApp::Fsm::Dnsd;
use inetApp::Plant::SETUP;
use inetApp::Plant::LAN;
use inetApp::Plant::WAN;
use inetApp::Plant::HOST;
use inetApp::Plant::NODE;

use constant TRUE => 1;
use constant FALSE => 0;
#timer period in seconds
use constant TIMER_PERIOD => 0.005;
use constant NUM_SLOTS => 6;
use constant SCHEDULING_DISCIPLINE => "EDF";
use constant REAL_TIME_TYPE => "SOFT";

sub leaveScript {
   my $ev = shift @_;

   print("\nShutdown Now !!!!! \n");
   if (defined($ev)) {
      exit($ev);
   } else {
      exit(0);
   }
}

my $tl = Tosf::Exception::Monitor->new(
   fn => sub {

      Tosf::Executive::DISPATCHER->set_num_slots(NUM_SLOTS);
      Tosf::Executive::SCHEDULER->set_discipline(SCHEDULING_DISCIPLINE);
      Tosf::Executive::SCHEDULER->set_realTime(REAL_TIME_TYPE);
      Tosf::Executive::TIMER->set_period(TIMER_PERIOD);

      Inet::Collection::FLAG->set_trace(FALSE);

      Inet::Plant::SETUP->start();
      inetApp::Plant::SETUP->start();

      Tosf::Executive::TIMER->start();

      while (1) {
         Tosf::Executive::DISPATCHER->tick();
      }

   }
);

$tl->run();
