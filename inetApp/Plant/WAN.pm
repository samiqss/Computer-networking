package inetApp::Plant::WAN;
#================================================================--
# File Name    : WAN.pm
#
# Purpose      : Plant set-up for WAN 
#
# Author       : Sami Al-Qusus
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;
use constant MAXSEL => 6 ;
use constant IFACEPOLLFREQ => 0.1;

sub start {
   system('clear');

   my $inp;
   my $sel = -1;

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nWAN Boot Menu\n\n");
      print ("\tR1 0\n");
      print ("\tR2 1\n");
      print ("\tR3 2\n");
      print ("\tEarth 3\n");
      print ("\tWind 4\n");
      print ("\tFire 5\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   my $name;

   if ($sel == 0) {
      
      # R1
      Inet::Collection::SYSTEM->set_name("R1");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_router_flag(1);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');

      my $host = 'localhost';
      my $port = 5070;

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
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::CACHE->set_webip("R1", '192.168.6.2');

      Inet::Table::ARP->set_mac('192.168.6.2', '602');
      Inet::Table::ARP->set_time('192.168.6.2', 'x');

      Inet::Table::IFACE->set_ip($name, '192.168.6.2');
      Inet::Table::IFACE->set_mac($name, 602);
      
      Inet::Table::ROUTE->set_route('192.168.6.2', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.6', '0.0.0.0', $name);
    
     
      $port = 6070;
      $name = "p2p0";
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

      Inet::Table::IFACE->set_packet_type($name, 'IP');
      Inet::Table::IFACE->set_ip($name, '10.0.6.100');     
      Inet::Table::ROUTE->set_route('10.0.6.100', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('10.0.6', '0.0.0.0', $name);
       
      $port = 6090;
      $name = "p2p1";
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

      Inet::Table::IFACE->set_packet_type($name, 'IP');
      Inet::Table::IFACE->set_ip($name, '10.0.8.200');
      Inet::Table::ROUTE->set_route('10.0.8.200', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('10.0.8', '0.0.0.0', $name);

      # note, Ethernet, Ip , Icmp are set up in Inet::Plant
      Inet::Table::ROUTE->set_route('0.0.0.0', '10.0.6.200', "p2p0");

   } elsif ($sel == 1) {

      # R2 
      Inet::Collection::SYSTEM->set_name("R2");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_router_flag(1);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');

      my $host = 'localhost';
      my $port = 5170;

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
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');
      
      Inet::Table::CACHE->set_webip("R2", '192.168.7.2');

      Inet::Table::ARP->set_mac('192.168.7.2', '702');
      Inet::Table::ARP->set_time('192.168.7.2', 'x');

      Inet::Table::IFACE->set_ip($name, '192.168.7.2');
      Inet::Table::IFACE->set_mac($name, 702);
      

      Inet::Table::ROUTE->set_route('192.168.7.2', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.7', '0.0.0.0', $name);
    
     
     $port = 6080;
      $name = "p2p0";
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
      Inet::Table::IFACE->set_packet_type($name, 'IP');

      Inet::Table::IFACE->set_ip($name, '10.0.7.100');
     
      Inet::Table::ROUTE->set_route('10.0.7.100', '0.0.0.0', 'lo');
       
      $port = 6071;
      $name = "p2p1";
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
      Inet::Table::IFACE->set_packet_type($name, 'IP');

      Inet::Table::IFACE->set_ip($name, '10.0.6.200');
     
      Inet::Table::ROUTE->set_route('10.0.6.200', '0.0.0.0', 'lo');

      # note, Ethernet, Ip , Icmp are set up in Inet::Plant
      Inet::Table::ROUTE->set_route('0.0.0.0', '10.0.7.200', "p2p0");

   } elsif ($sel == 2) {
      
      # R3 
      Inet::Collection::SYSTEM->set_name("R3");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_router_flag(1);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');
      my $host = 'localhost';
      my $port = 5270;

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
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::CACHE->set_webip("R3", '192.168.8.2');

      Inet::Table::ARP->set_mac('192.168.8.2', '802');
      Inet::Table::ARP->set_time('192.168.8.2', 'x');

      Inet::Table::IFACE->set_ip($name, '192.168.8.2');
      Inet::Table::IFACE->set_mac($name, 802);
      

      Inet::Table::ROUTE->set_route('192.168.8.2', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.8', '0.0.0.0', $name);
    
     
      $port = 6091;
      $name = "p2p0";
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
      Inet::Table::IFACE->set_packet_type($name, 'IP');

      Inet::Table::IFACE->set_ip($name, '10.0.8.100');
     
      Inet::Table::ROUTE->set_route('10.0.8.100', '0.0.0.0', 'lo');
       
      $port = 6081;
      $name = "p2p1";
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
      Inet::Table::IFACE->set_packet_type($name, 'IP');

      Inet::Table::IFACE->set_ip($name, '10.0.7.200');
     
      Inet::Table::ROUTE->set_route('10.0.7.200', '0.0.0.0', 'lo');

      # note, Ethernet, Ip , Icmp are set up in Inet::Plant
      Inet::Table::ROUTE->set_route('0.0.0.0', '10.0.8.200', "p2p0");

   } elsif ($sel == 3) {

      # Earth 
      Inet::Collection::SYSTEM->set_name("Earth");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');

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

      # note, Ethernet, Ip , Icmp are set up in Inet::Plant
   
      Inet::Table::CACHE->set_webip("Earth", '192.168.6.1');

      Inet::Table::ARP->set_mac('192.168.6.1', '601');
      Inet::Table::ARP->set_time('192.168.6.1', 'x');
      #Inet::Table::ARP->set_mac('192.168.6.2', '602');
      #Inet::Table::ARP->set_mac('192.168.6.3', '603');

      Inet::Table::IFACE->set_ip($name, '192.168.6.1');
      Inet::Table::IFACE->set_mac($name, 601);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.6.1', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.6', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.6.2', $name);

   } elsif ($sel == 4) {

      # Wind 
      Inet::Collection::SYSTEM->set_name("Wind");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');

      my $host = 'localhost';
      my $port = 5173;

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
   
      Inet::Table::CACHE->set_webip("Fire", '192.168.8.1');
      Inet::Table::CACHE->set_webip("Wind", '192.168.7.1');
      Inet::Table::CACHE->set_webip("Earth", '192.168.6.1');
      Inet::Table::CACHE->set_webip("R3", '192.168.8.2');
      Inet::Table::CACHE->set_webip("R2", '192.168.7.2');
      Inet::Table::CACHE->set_webip("R1", '192.168.6.2');

      #Inet::Table::ARP->set_mac('192.168.6.1', '601');
      Inet::Table::ARP->set_mac('192.168.7.1', '701');
      Inet::Table::ARP->set_time('192.168.7.1', 'x');
      #Inet::Table::ARP->set_mac('192.168.6.3', '603');

      Inet::Table::IFACE->set_ip($name, '192.168.7.1');
      Inet::Table::IFACE->set_mac($name, 701);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.7.1', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.7', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.7.2', $name);

   } elsif ($sel == 5) {
      
      # Fire
      Inet::Collection::SYSTEM->set_name("Fire");
      Inet::Collection::SYSTEM->set_type('HOST');
      Inet::Collection::FLAG::->set_trace(FALSE);
      Inet::Collection::SYSTEM->set_DNS('192.168.7.1');

      my $host = 'localhost';
      my $port = 5273;

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
    
      Inet::Table::CACHE->set_webip("Fire", '192.168.8.1');   

      #Inet::Table::ARP->set_mac('192.168.6.1', '601');
      #Inet::Table::ARP->set_mac('192.168.6.2', '602');
      Inet::Table::ARP->set_mac('192.168.8.1', '801');
      Inet::Table::ARP->set_time('192.168.8.1', 'x');

      Inet::Table::IFACE->set_ip($name, '192.168.8.1');
      Inet::Table::IFACE->set_mac($name, 801);
      Inet::Table::IFACE->set_packet_type($name, 'ETHERNET');

      Inet::Table::ROUTE->set_route('192.168.8.1', '0.0.0.0', 'lo');
      Inet::Table::ROUTE->set_route('192.168.8', '0.0.0.0', $name);
      Inet::Table::ROUTE->set_route('0.0.0.0', '192.168.8.2', $name);

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

   $name = "Dns";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Dns->new(
         taskName => $name,
      )
   );
   Tosf::Table::TASK->reset($name);

   $name = "Dnsd";
   Tosf::Table::TASK->new(
      name => $name,
      periodic => FALSE,
      run => FALSE,
      fsm => inetApp::Fsm::Dnsd->new(
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
