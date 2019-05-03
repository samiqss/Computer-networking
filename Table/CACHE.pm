package Inet::Table::CACHE;
#================================================================--
# File Name    : Table/CACHE.pm
#
# Purpose      : table of Cache records
#
# Author       : Sami Al-Qusus, Vancouver Island University
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
   my $web = shift @_; #primary key
   
   if (!defined($web)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::CACHE->delete"));
   }

   if (!exists($table{$web})) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::CACHE->delete"));
   }

   delete($table{$web});

}


sub set_webip {
   my $pkg = shift @_;
   my $web = shift @_;
   my $webip = shift @_;

   if (!defined($web) || (!defined($webip))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::CACHE->set_webip"));
   }

   if (!exists($table{$web})) {
      $table{$web} = Inet::Record::Cache->new();
   } 

   $table{$web}->set_webip($webip);
}

sub get_webip {
   my $pkg = shift @_;
   my $webip = shift @_;

   if (!defined($webip)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::CACHE->get_webip"));
   }

   if (exists($table{$webip})) {
      return $table{$webip}->get_webip();
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
