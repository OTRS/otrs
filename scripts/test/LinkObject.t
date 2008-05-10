# --
# LinkObject.t - link object module testscript
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObject.t,v 1.3 2008-05-10 12:51:07 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::LinkObject;

$Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );

1;
