package Inet::Table::SWITCH;
#================================================================--
# File Name    : Table/SWITCH.pm
#
# Purpose      : table of  Switch records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my %table;

sub delete {
   my $pkg = shift @_;
   my $mac = shift @_; #primary key

   if (!defined($mac)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->delete"));
   }

   if (!exists($table{$mac})) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->delete"));
   }

   delete($table{$mac});

}

sub add {
   my $pkg = shift @_;
   my $mac = shift @_; #primary key
   my $iface = shift @_;

   if (!defined($mac) || (!defined($iface))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->add"));
   }

   if (!exists($table{$mac})) {
      $table{$mac} = Inet::Record::Switch->new();
      $table{$mac}->set_iface($iface);
   } else {
      $table{$mac}->set_time(40);
   }

}

sub get_keys {

   return keys(%table);
}

sub get_time {
   my $pkg = shift @_;
   my $mac = shift @_;

   if (!defined($mac)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->get_time"));
   }

   if (exists($table{$mac})) {
      return $table{$mac}->get_time();
   } else {
      return undef;
   } 
}

sub get_iface {
   my $pkg = shift @_;
   my $mac = shift @_;

   if (!defined($mac)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->get_iface"));
   }

   if (exists($table{$mac})) {
      return $table{$mac}->get_iface();
   } else {
      return undef;
   } 
}

sub set_iface {
   my $pkg = shift @_;
   my $mac = shift @_;
   my $iface = shift @_;

   if (!defined($mac) || (!defined($iface)) ||  (!exists($table{$mac})) ) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->set_dev"));
   }


   $table{$mac}->set_iface($iface);
}

sub set_time {
   my $pkg = shift @_;
   my $mac = shift @_;
   my $t = shift @_;

   if (!defined($mac) || (!defined($t)) ||  (!exists($table{$mac})) ) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::SWITCH->set_time"));
   }


   $table{$mac}->set_time($t);
}

sub dumps {
   my $self = shift @_;

   my $key;
   my $s = '';

   foreach $key (keys(%table)) {
      $s = $s . "Mac: $key ";
      $s = $s . $table{$key}->dumps() . "\n";
   } 
   return $s;
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Mac: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
