package Inet::Record::SocketUdp;
#================================================================--
# File Name    : Record/SocketUdp.pm
#
# Purpose      : implements socket udp record 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub new {
   my $class = shift @_;
   my %params = @_;
   
   my $self = {
      callback_task => my $callback_task = 'none',
      callback_opcode => my $callback_opcode = ' '
   };
                
   bless ($self, $class);
   return $self;
}

sub set_callback_opcode {
   my $self = shift @_;
   my $o = shift @_;

   $self->{callback_opcode} = $o;

   return;
}

sub get_callback_opcode {
   my $self = shift @_;

   return $self->{callback_opcode};
}

sub set_callback_task {
   my $self = shift @_;
   my $t = shift @_;

   $self->{callback_task} = $t;

   return;
}

sub get_callback_task {
   my $self = shift @_;

   return $self->{callback_task};
}

sub dumps {
   my $self = shift @_;

   my $s = '';

   $s = $s . "Callback Task: $self->{callback_task} ";
   $s = $s . "Callback Opcode: $self->{callback_opcode} ";

   return $s;
}

sub dump {
   my $self = shift @_;

   print ("Callback Task: $self->{callback_task} \n");
   print ("Callback Opcode: $self->{callback_opcode} \n");
}

1;
