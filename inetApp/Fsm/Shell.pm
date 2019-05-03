package inetApp::Fsm::Shell;

#================================================================--
# File Name    : Fsm/Shell.pm
#
# Purpose      : Shell
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
            name => "Fsm::Shell->new  taskName undefined"
         )
      );
   }

   bless( $self, $class );
   return $self;
}

my $raw;
my $pkt;
my $nodeHelpMsg =
"COMMAND\t\t\tBEHAVIOUR\nhelp\t\t\tdisplay help message \nquit\t\t\tshutdown\nsystem\t\t\tdisplay system information\n";
my $additionalHubMsg =
  "tdrop iface\t\ttoggle drop flag\ntduplicate iface\ttoggle duplicate flag\n";
my $hostHelpMsg =
"COMMAND\t\t\tBEHAVIOUR\nhelp\t\t\tdisplay help message \nquit\t\t\tshutdown\nsystem\t\t\tdisplay system information\nincrement ip val\tincrement an integer\nrender ip\t\trender web page\nping ip\t\t\tping\n";
my $helpMsg;
my $msg = '';
my @keys;
my @words;
my $k;
my $ns;
my $gpkt;
my $streamIface;
my $opcode;
my $command;
my $param1;
my $param2;
my $sysType;
my $sysName;
my $sysMsg;
my $flag;
my $search_string =
  "(([0-9]){3})\.(([0-9]){3})\.(([0-9]){1,3})\.(([0-9]){1,3})";

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
         print("In Shell\n");
      }

      $raw = Tosf::Table::MESSAGE->dequeue( $self->{taskName} );
      $gpkt->decode($raw);
      $opcode      = $gpkt->get_opcode();
      $streamIface = Inet::Table::IFACE->get_streamIface();
      $sysName     = Inet::Collection::SYSTEM->get_name();
      $sysType     = Inet::Collection::SYSTEM->get_type();
      $pkt         = $gpkt->get_msg();
      if ( $opcode == 0 ) {
         $ns = "OP0";
      }
      else {
         die(
            Tosf::Exception::Trap->new(
               name => "Fsm::Shell->new  invalid opcode $opcode"
            )
         );
      }
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "SOUT" ) {
      if ( Inet::Collection::FLAG->get_trace() ) {
         print("Out Shell\n");
      }

      Tosf::Table::MESSAGE->wait( $self->{taskName} );
      return ( "SIN" );
   }

   if ( $mmt_currentState ~~ "OP0" ) {
      $msg = '';

      @words = split( '\s|\:', $pkt );

      $command = $words[0];
      $param1  = $words[1];
      $param2  = $words[2];

      if ( !defined($command) ) {
         $command = ' ';
      }

      $ns = 'SOUT';

      if ( $command eq ' ' ) {
         $ns = 'CRLF';
      }
      elsif ( $command eq 'help' ) {
         if ( $sysType eq 'HOST' ) {
            $helpMsg = $hostHelpMsg;
         }
         elsif ( $sysType eq "HUB" ) {
            $helpMsg = $nodeHelpMsg . $additionalHubMsg;
         }
         else {
            $helpMsg = $nodeHelpMsg;
         }
         $ns = 'HELP';
      }
      elsif ( $command eq 'system' ) {
         $sysMsg = "SYSTEM \n" . Inet::Collection::SYSTEM->dumps();
         $sysMsg = $sysMsg . "IFACE \n" . Inet::Table::IFACE->dumps();

         if ( $sysType eq "HOST" ) {
            $sysMsg =
              $sysMsg . "SOCKETUDP \n" . Inet::Table::SOCKETUDP->dumps();
         }

         if ( $sysType eq "SWITCH" ) {
            $sysMsg = $sysMsg . "SWITCH \n" . Inet::Table::SWITCH->dumps();
         }
         if ( $sysType eq "HOST" ) {
            $sysMsg = $sysMsg . "ARP \n" . Inet::Table::ARP->dumps();
         }
         $ns = 'SYSTEM';
      }
      elsif ( ( $sysType eq 'HOST' ) && ( $command eq 'ping' ) ) {
         $ns = "PING";
      }
      elsif ( ( $sysType eq "HUB" ) && ( $command eq 'tdrop' ) ) {
         $ns = "TDROP";
      }
      elsif ( ( $sysType eq "HUB" ) && ( $command eq 'tduplicate' ) ) {
         $ns = "TDUPLICATE";
      }
      elsif ( ( $sysType eq 'HOST' ) && ( $command eq 'increment' ) ) {
         $ns = "INCREMENT";
      }
      elsif ( ( $sysType eq 'HOST' ) && ( $command eq 'render' ) ) {
         $ns = "RENDER";
      }
      elsif ( $command eq 'quit' ) {
         $ns = 'QUIT';
      }
      else {
         $ns = 'ERROR';
      }
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "CRLF" ) {
      $gpkt->set_opcode(1);
      $gpkt->set_interface($streamIface);

      $gpkt->set_msg( $msg . $sysName . " > " );

      Tosf::Table::MESSAGE->enqueue( "IfaceCon", $gpkt->encode() );
      Tosf::Table::MESSAGE->signal("IfaceCon");
      return ( 'SOUT' );
   }

   if ( $mmt_currentState ~~ "ERROR" ) {
      $msg = "ERROR command not found \n";
      return ( 'CRLF' );
   }

   if ( $mmt_currentState ~~ "HELP" ) {
      $msg = $helpMsg;
      return ( 'CRLF' );
   }

   if ( $mmt_currentState ~~ "TDROP" ) {
      if ( defined($param1) ) {
         $flag = Inet::Table::IFACE->get_drop_flag($param1);
         if ( defined($flag) ) {
            if ( $flag == FALSE ) {
               Inet::Table::IFACE->set_drop_flag( $param1, TRUE );
            }
            else {
               Inet::Table::IFACE->set_drop_flag( $param1, FALSE );
            }
         }
         else {
            $msg = "ERROR undefined iface parameter \n";
         }
      }
      else {
         $msg = "ERROR missing parameter(s)\n";
      }
      return ( 'CRLF' );
   }

   if ( $mmt_currentState ~~ "TDUPLICATE" ) {
      if ( defined($param1) ) {
         $flag = Inet::Table::IFACE->get_duplicate_flag($param1);
         if ( defined($flag) ) {
            if ( $flag == FALSE ) {
               Inet::Table::IFACE->set_duplicate_flag( $param1, TRUE );
            }
            else {
               Inet::Table::IFACE->set_duplicate_flag( $param1, FALSE );
            }
         }
         else {
            $msg = "ERROR undefined iface parameter \n";
         }
      }
      else {
         $msg = "ERROR missing parameter(s)\n";
      }
      return (
         'CRLF'

      );
   }

   if ( $mmt_currentState ~~ "SYSTEM" ) {
      $msg = $sysMsg;
      return (
         'CRLF'

      );
   }

   if ( $mmt_currentState ~~ "PING" ) {
      if ( defined($param1) && ( $param1 =~ m/$search_string/ ) ) {
         if ( defined($param2) ) {
            $gpkt->set_ttl($param2);
         }

         $gpkt->set_dest_ip($param1);
         $gpkt->set_opcode(0);
         Tosf::Table::MESSAGE->enqueue( "Icmp", $gpkt->encode() );
         Tosf::Table::MESSAGE->signal("Icmp");

      }
      else {
         $gpkt->set_dest_ip($param1);
         $gpkt->set_opcode(4);
         Tosf::Table::MESSAGE->enqueue( "Icmp", $gpkt->encode() );
         Tosf::Table::MESSAGE->signal("Icmp");

         #$msg = "ERROR missing parameter(s)\n";
      }
      return ( 'CRLF' );
   }

   if ( $mmt_currentState ~~ "INCREMENT" ) {
      if ( ( defined($param1) ) && ( defined($param2) ) ) {
         $gpkt->set_dest_ip($param1);
         $gpkt->set_msg($param2);
         $gpkt->set_opcode(0);
         Tosf::Table::MESSAGE->enqueue( "Inc", $gpkt->encode() );
         Tosf::Table::MESSAGE->signal("Inc");
      }
      else {
         $msg = "ERROR missing ip parameter(s)\n";
      }
      return ( 'CRLF' );
   }

   if ( $mmt_currentState ~~ "RENDER" ) {
      if ( defined($param1) ) {
         $gpkt->set_dest_ip($param1);
         $gpkt->set_opcode(0);
         Tosf::Table::MESSAGE->enqueue( "Render", $gpkt->encode() );
         Tosf::Table::MESSAGE->signal("Render");
      }
      else {
         $msg = "ERROR missing ip parameter\n";
      }
      return (
         'CRLF'

      );
   }

   if ( $mmt_currentState ~~ "QUIT" ) {
      main::leaveScript();
      return ( 'SOUT' );
   }

}

sub reset {
   my $self = shift @_;

   Tosf::Table::MESSAGE->wait( $self->{taskName} );
   $gpkt = Inet::Packet::Generic->new();
   return ("SIN");
}

1;
