package inetApp::Fsm::Render;

#================================================================--
# File Name    : Fsm/Render.pm
#
# Purpose      : Render (web) Client
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
            name => "Fsm::Render->new  taskName undefined"
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
my $streamIface;
my $htmlFileName;

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
         print("In Render\n");
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
               name => "Fsm::Render->new  invalid opcode $opcode"
            )
         );
      }
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "SOUT" ) {
      if ( Inet::Collection::FLAG->get_trace() ) {
         print("Out Render\n");
      }

      Tosf::Table::MESSAGE->wait( $self->{taskName} );
      return ( "SIN" );
   }

   if ( $mmt_currentState ~~ "OP0" ) {
      $generic_pkt->set_src_port($src_port);
      $generic_pkt->set_dest_port(80);
      $generic_pkt->set_opcode(0);
      Tosf::Table::MESSAGE->enqueue( "Udp", $generic_pkt->encode() );
      Tosf::Table::MESSAGE->signal("Udp");
      return ( "SOUT" );
   }

   if ( $mmt_currentState ~~ "OP1" ) {
      open( FH, "> $htmlFileName" ) || die "Cant open $htmlFileName File \n";
      print( FH $generic_pkt->get_msg() );
      return ( "FIREFOX" );
   }

   if ( $mmt_currentState ~~ "FIREFOX" ) {
      close(FH);
      system("firefox $htmlFileName &");
      return ( "SOUT" );
   }

}

sub reset {
   my $self = shift @_;

   $htmlFileName =
     "Plant/Html/" . Inet::Collection::SYSTEM->get_name() . ".html";
   Tosf::Table::MESSAGE->wait( $self->{taskName} );
   $generic_pkt = Inet::Packet::Generic->new();

   $src_port = Inet::Table::SOCKETUDP->open(
      callback_task   => $self->{taskName},
      callback_opcode => 1
   );

   return ("SIN");
}

1;
