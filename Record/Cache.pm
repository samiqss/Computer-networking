package Inet::Record::Cache;
#================================================================--
# File Name    : Record/Cache.pm
#
# Purpose      : implements Route record
#
# Author       : Sami Al-Qusus, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $webip = '';
sub  new {
   my $class = shift @_;

   my $self = {webip => $webip};
                
   bless ($self, $class);
   return $self;
}

sub get_webip {
   my $self = shift @_;
   
   return $self->{webip};
}

sub set_webip {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{webip} = $m;
   return;
}

sub dumps {
   my $self = shift @_;

   my $s = '';

   $s = $s . "Webip: $self->{webip} ";
   return $s;
}

sub dump {
   my $self = shift @_;

   print("Webip: $self->{webip} \n ");
   return;
}

1;
