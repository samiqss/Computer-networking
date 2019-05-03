package inetApp::Fsm::Dnsd;

#================================================================--
# File Name    : Fsm/Dnsd.pm
#
# Purpose      : DNS Server
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant TRUE  => 1;
use constant FALSE => 0;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = { taskName => my $taskName };

   if ( defined( $params{taskName} ) ) {
      $self->{taskName} = $params{taskName};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Fsm::Dns->new  taskName undefined"
         )
      );
   }

   bless( $self, $class );
   return $self;
}

my $generic_pkt;
my $raw;
my $ns;
my $opcode;
my $src_port;
my $val;

sub set_name {
   my $self = shift @_;
   my $nme  = shift @_;

   return $nme;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   if ( $mmt_currentState ~~ "SIN" ) {
      if ( Inet::Collection::FLAG->get_trace() ) {
         print("In Dnsd\n");
      }

      $raw = Tosf::Table::MESSAGE->dequeue( $self->{taskName} );
      $generic_pkt->decode($raw);
      $opcode = $generic_pkt->get_opcode();
      if ( $opcode == 0 ) {
         $ns = "OP0";
      }
      elsif ( $opcode == 1 ) {
         $ns = "OP1";
      }
      else {
         die(
            Tosf::Exception::Trap->new(
               name => "Fsm::Dnsd->new  invalid opcode $opcode"
            )
         );
      }
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "SOUT" ) {
      if ( Inet::Collection::FLAG->get_trace() ) {
         print("Out Dnsd\n");
      }

      Tosf::Table::MESSAGE->wait( $self->{taskName} );
      return ( "SIN" );
   }

   if ( $mmt_currentState ~~ "OP0" ) {
      $generic_pkt->set_src_port($src_port);
      $generic_pkt->set_dest_port(53);
      $generic_pkt->set_opcode(0);
      Tosf::Table::MESSAGE->enqueue( "Udp", $generic_pkt->encode() );
      Tosf::Table::MESSAGE->signal("Udp");
      return ( "SOUT" );
   }

   if ( $mmt_currentState ~~ "OP1" ) {
      $val = $generic_pkt->get_msg();
      my $ip = Inet::Table::CACHE->get_webip($val);
      if ( defined($ip) ) {
         $generic_pkt->set_msg($ip);
      }
      else {
         $generic_pkt->set_msg("IP not found");
      }

      $generic_pkt->set_dest_ip( $generic_pkt->get_src_ip() );

      #$src_port = $generic_pkt->get_dest_port();
      $generic_pkt->set_dest_port( $generic_pkt->get_src_port() );
      $generic_pkt->set_src_port($src_port);
      $generic_pkt->set_opcode(0);
      Tosf::Table::MESSAGE->enqueue( "Udp", $generic_pkt->encode() );
      Tosf::Table::MESSAGE->signal("Udp");
      return ( "SOUT" );
   }

}

sub reset {
   my $self = shift @_;

   Tosf::Table::MESSAGE->wait( $self->{taskName} );
   $generic_pkt = Inet::Packet::Generic->new();

   $src_port = Inet::Table::SOCKETUDP->open(
      port            => 53,
      callback_task   => $self->{taskName},
      callback_opcode => 1
   );

   return ("SIN");
}

1;
