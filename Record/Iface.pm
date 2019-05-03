package Inet::Record::Iface;
#================================================================--
# File Name    : Record/Iface.pm
#
# Purpose      : implements interface control record 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub  new {
   my $class = shift @_;
   my %params = @_;
   
   my $self = {
      opened => my $opened = 0,
      packet_type => my $packet_type = "stream",
      ip => my $ip = 'no ip',
      mac => my $mac = 'no mac ',
      heartbeat_count => my $heartbeat_count = 0,
      drop_flag => my $drop_flag = 0,
      duplicate_flag => my $dublicate_flag = 0,
      line => Tosf::Collection::Line->new()
   };
                
   bless ($self, $class);
   return $self;
}

sub set_heartbeat_count {
   my $self = shift @_;
   my $i = shift @_;

   $self->{heartbeat_count} = $i;

   return;
}

 sub increment_heartbeat_count {
   my $self = shift @_;

   $self->{heartbeat_count} = ($self->{heartbeat_count} + 1) % 255;
   if ($self->{heartbeat_count} == 0) {
      $self->{heartbeat_count} = 1;
   }

   return;
}

sub get_hearbeat_count {
   my $self = shift @_;

   return $self->{heartbeat_count};
}

sub get_duplicate_flag {
   my $self = shift @_;

   return $self->{duplicate_flag};
}

sub set_duplicate_flag {
   my $self = shift @_;
   my $f = shift @_;

   $self->{duplicate_flag} = $f;
   return;
}

sub get_drop_flag {
   my $self = shift @_;

   return $self->{drop_flag};
}

sub set_drop_flag {
   my $self = shift @_;
   my $f = shift @_;

   $self->{drop_flag} = $f;
   return;
}


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

sub get_ip {
   my $self = shift @_;

   return $self->{ip};
}

sub set_ip {
   my $self = shift @_;
   my $ip = shift @_;

   $self->{ip} = $ip;
   return;
}

sub set_inLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_inLeftFrame($f);
}

sub set_inRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_inRightFrame($f);
}

sub set_outRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_outRightFrame($f);
}

sub set_outLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_outLeftFrame($f);
}

sub get_packet_type {
   my $self = shift @_;

   return $self->{packet_type};
}

sub set_packet_type {
   my $self = shift @_;
   my $t = shift @_;

   $self->{packet_type} = $t;
   return;
}

sub get_opened {
   my $self = shift @_;

   return $self->{opened};
}

sub set_opened {
   my $self = shift @_;
   my $o = shift @_;

   $self->{opened} = $o;
   return;
}

sub dequeue_packet {
   my $self = shift @_;

   return $self->{line}->dequeue_packet();
}

sub dequeue_packet_fragment {
   my $self = shift @_;
   my $s = shift @_;

   return ($self->{line})->dequeue_packet_fragment($s);
}

sub flush {
   my $self = shift @_;
 
   $self->{line}->flush();
   return;
}

sub enqueue_packet {
   my $self = shift @_;
   my $p = shift @_;
 
   $self->{line}->enqueue_packet($p);
   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $f = shift @_;
 
   $self->{line}->enqueue_packet_fragment($f);
   return;
}

sub dumps {
   my $self = shift @_;

   my $s = '';

   $s = $s . "Opened: $self->{opened} ";
   $s = $s . "Ip: $self->{ip} ";
   $s = $s . "Mac: $self->{mac} ";
   $s = $s . "Heartbeat Count: $self->{heartbeat_count} ";
   $s = $s . "Drop Flag: $self->{drop_flag} ";
   $s = $s . "Duplicate Flag: $self->{duplicate_flag} ";

   return $s;
}

sub dump {
   my $self = shift @_;

   print ("Opened: $self->{opened} \n");
   print ("Packet Type: $self->{packet_type} \n");
   print ("Ip: $self->{ip} \n");
   print ("Mac: $self->{mac} \n");
   print ("Heartbeat Count: $self->{heartbeat_count} \n");
   print ("Drop Flag: $self->{drop_flag} \n");
   print ("Duplicate Flag: $self->{duplicate_flag} \n");
   print ("Line: \n");
   $self->{line}->dump();
}

1;
