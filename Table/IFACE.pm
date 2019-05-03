package Inet::Table::IFACE;
#================================================================--
# File Name    : Table/IFACE.pm
#
# Purpose      : table of Iface records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;

my %table;
my $streamIface = 'none';

sub get_keys {

   return keys(%table);
}

sub my_mac {
   my $self = shift @_;
   my $m = shift @_;

   if (!defined($m)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->my_mac"));
   }

   my $key;

   foreach $key (keys(%table)) {
      if ($m eq $table{$key}->get_mac()) {
         return TRUE;
      }
   }

   return FALSE;
}

sub set_heartbeat_count {
   my $pkg = shift @_;
   my $name = shift @_;
   my $i = shift @_;

   if (!defined($name) || (!defined($i))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_heartbeat_count"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_heartbeat_count($i);
}

sub set_ip {
   my $pkg = shift @_;
   my $name = shift @_;
   my $ip = shift @_;

   if (!defined($name) || (!defined($ip))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_ip"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_ip($ip);
}

sub set_mac {
   my $pkg = shift @_;
   my $name = shift @_;
   my $m = shift @_;

   if (!defined($name) || (!defined($m))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_mac"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_mac($m);
}

sub set_inRightFrame {
   my $self = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_inRightFrame"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_inRightFrame($f);

   return;
}

sub set_outRightFrame {
   my $self = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_outRightFrame"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_outRightFrame($f);

   return;
}

sub set_outLeftFrame {
   my $self = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_outLeftFrame"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_outLeftFrame($f);

   return;
}

sub set_inLeftFrame {
   my $self = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_inLeftFrame"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_inLeftFrame($f);

   return;
}

sub set_duplicate_flag {
   my $pkg = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_duplicate_flag  invalid parameters"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_duplicate_flag($f);
}

sub get_duplicate_flag {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_duplicate_flag missing parameter"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_duplicate_flag();
   } else {
      return undef;
   }
}

sub set_drop_flag {
   my $pkg = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_drop_flag  invalid parameters"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_drop_flag($f);
}

sub get_drop_flag {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_drop_flag missing parameter"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_drop_flag();
   } else {
      return undef;
   }
}

sub set_packet_type {
   my $pkg = shift @_;
   my $name = shift @_;
   my $t = shift @_;

   if (!defined($name) || (!defined($t))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_packet_type"));
   }

   if ($streamIface ne 'none') {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_packet_type only one stream is allowed"));
   } elsif ($t eq 'STREAM') {
      $streamIface = $name;
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_packet_type($t);
}

sub get_packet_type {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_packet_type"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_packet_type();
   } else {
      return undef;
   }
}

sub get_heartbeat_count {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_heartbeat_count"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_heartbeat_count();
   } else {
      return undef;
   }
}

sub increment_heartbeat_count {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->increment_heartbeat_count"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->increment_heartbeat_count();
}

sub get_mac {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_mac"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_mac();
   } else {
      return undef;
   }
}

sub get_ip {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_ip"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_ip();
   } else {
      return undef;
   }
}

sub get_streamIface {
   my $pkg = shift @_;

   return $streamIface;

}

sub set_opened {
   my $pkg = shift @_;
   my $name = shift @_;
   my $o = shift @_;

   if (!defined($name) || (!defined($o))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->set_opened"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   }

   $table{$name}->set_opened($o);
}

sub get_opened {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->get_opened name undefined"));
   }

   if (exists($table{$name})) {
      return $table{$name}->get_opened();
   } else {
      return undef;
   }
}

sub flush {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->flush"));
   }

   if (exists($table{$name})) {
      $table{$name}->flush();
   } 
}

sub dequeue_packet_fragment {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->dequeue_packet_fragment"));
   }

   if (exists($table{$name})) {
      return $table{$name}->dequeue_packet_fragment();
   } else {
      return undef;
   } 
}

sub dequeue_packet {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->dequeue_packet"));
   }

   if (exists($table{$name})) {
      return $table{$name}->dequeue_packet();
   } else {
      return undef;
   } 
}

sub enqueue_packet {
   my $pkg = shift @_;
   my $name = shift @_;
   my $p = shift @_;

   if (!defined($name) || (!defined($p))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->enqueue_packet"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   } 

   $table{$name}->enqueue_packet($p);
}

sub enqueue_packet_fragment {
   my $pkg = shift @_;
   my $name = shift @_;
   my $f = shift @_;

   if (!defined($name) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Inet::Table::IFACE->enqueue_packet_fragment"));
   }

   if (!exists($table{$name})) {
      $table{$name} = Inet::Record::Iface->new();
   } 

   $table{$name}->enqueue_packet_fragment($f);
}


sub dumps {
   my $self = shift @_;

   my $key;
   my $s = '';

   foreach $key (keys(%table)) {
      $s = $s . "Iface: $key ";
      $s = $s . $table{$key}->dumps();
      $s = $s . "\n";
   } 

   return $s;
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}


1;
