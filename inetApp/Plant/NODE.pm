package inetApp::Plant::NODE;
#================================================================--
# File Name    : NODE.pm
#
# Purpose      : Plant set-up for NODE 
#
# Author       : Peter Walsh, Vancouver Island University
#                (Modified By Sami: added p2p)
#
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

      print ("\nNODE Boot Menu\n\n");
      print ("\tSniffer 0\n");
      print ("\tHub 1\n");
      print ("\tPointToPoint 2\n");
      print ("\tSwitch 3\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   my $host;
   my $port;
   my $name;
   my $port0;
   my $host4 = "none";
   my $port4 = "none";

   if ($sel == 0) {

      # no parameter checking is performed on this user data :(

      print("*************************************************\n");
      print("*****            Sniffer Setup              *****\n");
      print("*************************************************\n \n");

      print("Enter Internet host name ");
      chomp($host = <>);
      print("Enter Internet port number: ");
      chomp($port = <>);

      Inet::Collection::SYSTEM->set_name("Peter_Sniffer");
      Inet::Collection::SYSTEM->set_type('SNIFFER');
      Inet::Collection::FLAG::->set_trace(FALSE);

      print("*************************************************\n");
      print("*****               End Setup               *****\n");
      print("*************************************************\n \n");


      # ================ PORT =================

      $name = "p0";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
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

      $name = "Sniffer";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => FALSE,
         run => FALSE,
         fsm => Inet::Fsm::Sniffer->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);

   } elsif ($sel == 1) {

      # no parameter checking is performed on this user data :(

      print("*************************************************\n");
      print("*****              Hub Setup                *****\n");
      print("*************************************************\n \n");
      print("Four consecutive Tcp Internet port numbers are required \n");
      print("on localhost for Hub ports p0 through p3 \n");
      print("Enter Internet port number for Hub p0: ");
      chomp($port0 = <>);
      print("Mapping \n");
      print("\t Hub port p0 to Internet port number ", $port0, "\n");
      print("\t Hub port p1 to Internet port number ", $port0 + 1, "\n");
      print("\t Hub port p2 to Internet port number ", $port0 + 2, "\n");
      print("\t Hub port p3 to Internet port number ", $port0 + 3, "\n \n");

      print("One Tcp Internet port number is required on a connected \n");
      print("host for Hub up-link port p4 \n");
      print("Enter Internet host name for Hub p4 (enter none to disable p4): ");
      chomp($host4 = <>);
      if ($host4 ne "none") {
         print("Enter Internet port number for Hub p4: ");
         chomp($port4 = <>);
         print("Mapping \n");
         print("\t Hub up-link port p4 to Internet port number ", $host4, ":", $port4, "\n \n");
      } else {
         print("Mapping \n");
         print("\t No up-link defined \n \n");
      }

      Inet::Collection::SYSTEM->set_name("Peter_Hub");
      Inet::Collection::SYSTEM->set_type('HUB');
      Inet::Collection::FLAG::->set_trace(FALSE);

      print("*************************************************\n");
      print("*****               End Setup               *****\n");
      print("*************************************************\n \n");

      my $name;

      # ================ PORTS =================
      $name = "p0";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => $port0
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p1";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 1)
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p2";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 2)
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p3";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 3)
         )
      );
      Tosf::Table::TASK->reset($name);

      if ($host4 ne 'none') {

         $name = "p4"; #(Up link)
         Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
         Tosf::Table::TASK->new(
            name => $name, 
            periodic => TRUE, 
            period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
            run => TRUE,
            fsm => Inet::Fsm::SocConC->new(
               taskName => $name,
               ifaceName => $name,
               host => $host4,
               port => $port4
            )
         );
         Tosf::Table::TASK->reset($name);
      }

      $name = "Hub";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => FALSE,
         run => FALSE,
         fsm => Inet::Fsm::Hub->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);

   } elsif ($sel == 2) {
      # no parameter checking is performed on this user data :(

      print("*************************************************\n");
      print("*****              P2p Setup                *****\n");
      print("*************************************************\n \n");
      print("Four consecutive Tcp Internet port numbers are required \n");
      print("on localhost for P2p ports p0 through p1 \n");
      print("Enter Internet port number for P2p p0: ");
      chomp($port0 = <>);
      print("Mapping \n");
      print("\t P2p port p0 to Internet port number ", $port0, "\n");
      print("\t P2p port p1 to Internet port number ", $port0 + 1, "\n");
   
      

      Inet::Collection::SYSTEM->set_name("Peter_P2p");
      Inet::Collection::SYSTEM->set_type('P2P');
      Inet::Collection::FLAG::->set_trace(FALSE);

      print("*************************************************\n");
      print("*****               End Setup               *****\n");
      print("*************************************************\n \n");

      my $name;

      # ================ PORTS =================

      $name = "p0";
      Inet::Table::IFACE->set_packet_type($name, 'IP');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => $port0
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p1";
      Inet::Table::IFACE->set_packet_type($name, 'IP');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 1)
         )
      );
      Tosf::Table::TASK->reset($name);

      
  

      $name = "P2p";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => FALSE,
         run => FALSE,
         fsm => Inet::Fsm::P2p->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);
   } elsif ($sel == 3) {

      # no parameter checking is performed on this user data :(

      print("*************************************************\n");
      print("*****              Switch Setup             *****\n");
      print("*************************************************\n \n");
      print("Four consecutive Tcp Internet port numbers are required \n");
      print("on localhost for Switch ports p0 through p3 \n");
      print("Enter Internet port number for Switch p0: ");
      chomp($port0 = <>);
      print("Mapping \n");
      print("\t Switch port p0 to Internet port number ", $port0, "\n");
      print("\t Switch port p1 to Internet port number ", $port0 + 1, "\n");
      print("\t Switch port p2 to Internet port number ", $port0 + 2, "\n");
      print("\t Switch port p3 to Internet port number ", $port0 + 3, "\n \n");

      print("One Tcp Internet port number is required on a connected \n");
      print("host for Switch up-link port p4 \n");
      print("Enter Internet host name for Switch p4 (enter none to disable p4): ");
      chomp($host4 = <>);
      if ($host4 ne "none") {
         print("Enter Internet port number for Switch p4: ");
         chomp($port4 = <>);
         print("Mapping \n");
         print("\t Switch up-link port p4 to Internet port number ", $host4, ":", $port4, "\n \n");
      } else {
         print("Mapping \n");
         print("\t No up-link defined \n \n");
      }

      Inet::Collection::SYSTEM->set_name("Peter_Switch");
      Inet::Collection::SYSTEM->set_type('SWITCH');
      Inet::Collection::FLAG::->set_trace(FALSE);

      print("*************************************************\n");
      print("*****               End Setup               *****\n");
      print("*************************************************\n \n");

      my $name;

      # ================ PORTS =================

      $name = "p0";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => $port0
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p1";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 1)
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p2";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 2)
         )
      );
      Tosf::Table::TASK->reset($name);

      $name = "p3";
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      Tosf::Table::TASK->new(
         name => $name, 
         periodic => TRUE, 
         period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
         run => TRUE,
         fsm => Inet::Fsm::SocConS->new(
            taskName => $name,
            ifaceName => $name,
            port => ($port0 + 3)
         )
      );
      Tosf::Table::TASK->reset($name);

      if ($host4 ne 'none') {

         $name = "p4"; #(Up link)
         Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
         Tosf::Table::TASK->new(
            name => $name, 
            periodic => TRUE, 
            period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
            run => TRUE,
            fsm => Inet::Fsm::SocConC->new(
               taskName => $name,
               ifaceName => $name,
               host => $host4,
               port => $port4
            )
         );
         Tosf::Table::TASK->reset($name);
      }

      $name = "Switch";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => FALSE,
         run => FALSE,
         fsm => Inet::Fsm::Switch->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);
   
      $name = "SwitchTablePurge";
      Tosf::Table::TASK->new(
         name => $name,
         periodic => TRUE,
         period => Tosf::Executive::TIMER->s2t(1),
         run => TRUE,
         fsm => Inet::Fsm::SwitchTablePurge->new(
            taskName => $name,
         )
      );
      Tosf::Table::TASK->reset($name);

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
