package Inet::Table::ARP;
#================================================================--
# File Name    : Table/ARP.pm
#
# Purpose      : table of  Arp records
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
   my $ip = shift @_; #primary key
   
   if (!defined($ip)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->delete"));
   }

   if (!exists($table{$ip})) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->delete"));
   }

   delete($table{$ip});

}

sub PUSH {
   my $pkg = shift @_;
   my $ip = shift @_; #primary key
   my $t = shift @_;

   if (!defined($ip) || (!defined($t)) ||(!exists($table{$ip}))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->push"));
   } else {
      $table{$ip}->PUSH($t);
   }

}

sub POP {
	my $pkg = shift @_;
	my $ip = shift @_;

	if (exists($table{$ip})) {
		return $table{$ip}->POP();
	} else{
		return undef;
	}
}

sub get_keys {

   return keys(%table);
}

sub get_time {
   my $pkg = shift @_;
   my $ip = shift @_;

   if (!defined($ip)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->get_time"));
   }

   if (exists($table{$ip})) {
      return $table{$ip}->get_time();
   } else {
      return undef;
   } 
}

sub set_time {
   my $pkg = shift @_;
   my $ip = shift @_;
   my $t = shift @_;

   if (!defined($ip) || (!defined($t)) ||  (!exists($table{$ip})) ) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->set_time"));
   }


   $table{$ip}->set_time($t);
}

sub get_pkt_size{
	my $pkg = shift @_;
	my $ip = shift @_;

    if (!defined($ip)){
		die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->get_pkt_size"));
    }
	if(exists($table{$ip})){
     return $table{$ip}->get_pkt_size();
	}else{
		return undef;
	}
}

sub set_mac {
   my $pkg = shift @_;
   my $ip = shift @_;
   my $mac = shift @_;

   if (!defined($ip) || (!defined($mac))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->set_mac"));
   }

   if (!exists($table{$ip})) {
      $table{$ip} = Inet::Record::Arp->new();
   } 

   $table{$ip}->set_mac($mac);
}

sub get_mac {
   my $pkg = shift @_;
   my $ip = shift @_;

   if (!defined($ip)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::ARP->get_mac"));
   }

   if (exists($table{$ip})) {
      return $table{$ip}->get_mac();
   } else {
      return undef;
   } 
}


sub dumps {
   my $self = shift @_;

   my $key;
   my $s = '';

   foreach $key (keys(%table)) {
      $s = $s . "Net: $key ";
      $s = $s . $table{$key}->dumps();
      $s = $s . "\n";
   } 
   return $s;
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
