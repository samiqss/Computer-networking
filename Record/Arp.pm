package Inet::Record::Arp;
#================================================================--
# File Name    : Record/Arp.pm
#
# Purpose      : implements Route record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $mac = '';
my $time = '';
sub  new {
   my $class = shift @_;

   my $self = {mac => $mac, Time => $time, queue => [] };
                
   bless ($self, $class);
   return $self;
}

########################################################
sub get_time {
   my $self = shift @_;
   
   return $self->{time};
}

sub set_time {
   my $self = shift @_;
   my $t = shift @_;
 
   $self->{time} = $t;
   return;
}

sub POP {
 my $self = shift @_;
  return pop(@{$self->{queue}});
}

sub PUSH {
   my $self = shift @_;
   my $t = shift @_;
   return push(@{$self->{queue}},$t);
 
}
sub get_pkt_size{
	my $self = shift @_;
    return scalar(@{$self->{queue}});

}

####################
sub get_mac {
   my $self = shift @_;
   
   return $self->{mac};
}

sub set_mac {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{mac} = $m;
   return;
}

sub dumps {
   my $self = shift @_;

   my $s = '';

   $s = $s . "Mac: $self->{mac} ";
   $s = $s . "Time: $self->{time} ";
   $s = $s . "pkt_size:" . scalar@{$self->{queue}};
   return $s;
}


sub dump {
   my $self = shift @_;

   print("Mac: $self->{mac} \n ");
   return;
}

1;
