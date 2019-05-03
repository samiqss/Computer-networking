package inetApp::Plant::LAN;
#================================================================--
# File Name    : LAN.pm
#
# Purpose      : Plant set-up for LAN 
#
# Author       : Peter Walsh, Vancouver Island University
#                (Modified by Sami: Edited for arp)
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;
use constant MAXSEL => 3 ;
use constant IFACEPOLLFREQ => 0.1;

sub start {
   system('clear');

   my $inp;
   my $sel = -1;

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nLAN Boot Menu\n\n");
      print ("\tEarth 0\n");
      print ("\tWind 1\n");
      print ("\tFire 2\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   my $name;

   if ($sel == 0) {

      # Earth 
      Inet::Collection::SYSTEM->set_name("Earth");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);

      my $host = 'localhost';
      my $port = 5071;

      # no parameter checking is performed on this user data :(

      # ================ PORT =================

      $name = "eth0";

      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConC->new(
            taskName => $name,
            ifaceName => $name,
            host => $host,
            port => $port
         )
      );
      Tosf::Table::TASK->reset($name);

      # note, Ethernet, Ip , Icmp are set up in Inet::Plant
   
      Inet::Table::ARP->set_mac('192.168.6.1', '601');
      Inet::Table::ARP->set_time('192.168.6.1', 'x');
      #Inet::Table::ARP->set_mac('192.168.6.2', '602');
      #Inet::Table::ARP->set_mac('192.168.6.3', '603');

      Inet::Table::IFACE->set_ip($name, '192.168.6.1');
      Inet::Table::IFACE->set_mac($name, 601);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.6.1', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.6', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.6.0', $name);

   } elsif ($sel == 1) {

      # Wind 
      Inet::Collection::SYSTEM->set_name("Wind");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);

      my $host = 'localhost';
      my $port = 5072;

      # no parameter checking is performed on this user data :(

      # ================ PORT =================

      $name = "eth0";

      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConC->new(
            taskName => $name,
            ifaceName => $name,
            host => $host,
            port => $port
         )
      );
      Tosf::Table::TASK->reset($name);

      # note, Ethernet, IP , ICMP are set up in Inet::Plant
   
      #Inet::Table::ARP->set_mac('192.168.6.1', '601');
      Inet::Table::ARP->set_mac('192.168.6.2', '602');
      Inet::Table::ARP->set_time('192.168.6.2', 'x');
      #Inet::Table::ARP->set_mac('192.168.6.3', '603');

      Inet::Table::IFACE->set_ip($name, '192.168.6.2');
      Inet::Table::IFACE->set_mac($name, 602);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.6.2', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.6', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.6.0', $name);

   } elsif ($sel == 2) {
      
      # Fire
      Inet::Collection::SYSTEM->set_name("Fire");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);

      my $host = 'localhost';
      my $port = 5073;

      # no parameter checking is performed on this user data :(

      # ================ PORT =================

      $name = "eth0";

      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConC->new(
            taskName => $name,
            ifaceName => $name,
            host => $host,
            port => $port
         )
      );
      Tosf::Table::TASK->reset($name);

      # note, Ethernet, IP , ICMP are set up in Inet::Plant
   
      #Inet::Table::ARP->set_mac('192.168.6.1', '601');
      #Inet::Table::ARP->set_mac('192.168.6.2', '602');
      Inet::Table::ARP->set_mac('192.168.6.3', '603');
      Inet::Table::ARP->set_time('192.168.6.3', 'x');

      Inet::Table::IFACE->set_ip($name, '192.168.6.3');
      Inet::Table::IFACE->set_mac($name, 603);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.6.3', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.6', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.6.0', $name);

   }     

   # All SYSTEM types require the following tasks.

   # ========== IFACE CONTROLLER  ============

      $name = "IfaceCon";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => FALSE,
         run => FALSE,
         fsm => Inet::Fsm::IfaceCon->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);

   # ============== STREAM CONTROLLER  ==============

   $name = "s0";
   Inet::Table::IFACE->set_packet_type($name, 'STREAM');
   Tosf::Table::TASK->new(
      name => $name,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
      run => TRUE,
      fsm => Inet::Fsm::StreamCon->new(
         taskName => $name,
         ifaceName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Shell";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Shell->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Inc";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Inc->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Incd";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Incd->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Render";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Render->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Renderd";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Renderd->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   # ================ HEARTBEAT =================

   $name = "HBeat";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(20),
      run => TRUE,
      fsm => Inet::Fsm::HBeat->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

}

1;
