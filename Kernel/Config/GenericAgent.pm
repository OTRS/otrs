# --
# Kernel/Config/GenericAgent.pm - config file of generic agent
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: GenericAgent.pm,v 1.1 2002-08-27 23:24:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Config::GenericAgent;

use strict;
use vars qw($VERSION @ISA @EXPORT %Jobs);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(%Jobs);  

$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# -----------------------------------------------------------------------
# config options
# -----------------------------------------------------------------------
%Jobs = (
   # --
   # [name of job] -> close all tickets in queue spam
   # --
   'close spam' => {
      # get all tickets with this properties  
      Queue => 'spam',
      States => ['new', 'open'],
      Locks => ['unlock'],
      # new ticket properties (no option is required, use just the options
      # witch should be changed!)
      New => {
        # new queue
        Queue => 'spam',
        # possible states (closed succsessful|closed unsuccsessful|open|new|removed) 
        State => 'closed succsessful',
        # new ticket owner (if needed)
        Owner => 'root@localhost',
        # if you want to add a Note
        Note => {
          From => 'GenericAgent',
          Subject => 'spam!',
          Body => 'Closed by GenericAgent.pl because it is spam!',
       },
       # new lock state
       Lock => 'unlock',
     },
   },
   # --
   # [name of job] -> move all tickets from tricky to experts
   # --
   'move tickets from tricky to experts' => {
      # get all tickets with this properties  
      Queue => 'tricky',
      States => ['new', 'open'],
      Locks => ['unlock'],
      # new ticket properties
      New => {
        Queue => 'experts',
        Note => {
          From => 'GenericAgent',
          Subject => 'Moved!',
          Body => 'Moved vrom "tricky" to "experts" because it was not possible to find a sollution!',
       },
     },
   },
);

# -----------------------------------------------------------------------
# end of config options
# -----------------------------------------------------------------------


1;

