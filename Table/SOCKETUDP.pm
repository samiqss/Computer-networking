package Inet::Table::SOCKETUDP;
#================================================================--
# File Name    : Table/SOCKETUDP.pm
#
# Purpose      : table of SocketUdp records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;
use constant MAXPORT => 65000;
use constant MINPORT => 2000;

my %table;
my $eport = MINPORT;

sub get_keys {

   return keys(%table);
}

sub get_port {
   
   # assume an open port is available
   while (1) {
      if (!exists($table{$eport})) {
         return $eport;
      }
      if ($eport == MAXPORT) {
         $eport = MINPORT;
      } else {
         $eport = $eport + 1;
      }
   }
}

sub get_callback_task {
   my $pkg = shift @_;
   my $p = shift @_;

   if (!defined($p)) {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->get_callback_task  port undefined"));
   }

   if (!exists($table{$p})) {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->get_callback_task  no table entry"));
   }

   return $table{$p}->get_callback_task();

}

sub get_callback_opcode {
   my $pkg = shift @_;
   my $p = shift @_;

   if (!defined($p)) {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->get_callback_opcode  port undefined"));
   }

   if (!exists($table{$p})) {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->get_callback_opcode  no table entry"));
   }

   return $table{$p}->get_callback_opcode();

}

sub open {
   my $pkg = shift @_;
   my %params = @_;

   my $port;

   if (defined($params{port})) {
      $port = $params{port};
   } else {
      $port = get_port();
   }

   if (!exists($table{$port})) {
      $table{$port} = Inet::Record::SocketUdp->new();
   } else {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->open port $params{port} is a duplicate"));
   }

   if (defined($params{callback_task})) {
      $table{$port}->set_callback_task($params{callback_task});
   } else {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->open  callback task undefined"));
   }

   if (defined($params{callback_opcode})) {
      $table{$port}->set_callback_opcode($params{callback_opcode});
   } else {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->open  callback opcode undefined"));
   }

   return $port;
}

sub close {
   my $pkg = shift @_;
   my $p = shift @_;
   
   if (!exists($table{$p})) {
      die(Tosf::Exception::Trap->new(name => "Table::SOCKETUDP->close port $p is not open"));
   }

   delete ($table{$p});
}


sub dumps {
   my $self = shift @_;

   my $key;
   my $s = '';

   foreach $key (keys(%table)) {
      $s = $s . "Port: $key ";
      $s = $s . $table{$key}->dumps();
      $s = $s . "\n";
   } 

   return $s;
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Port: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
