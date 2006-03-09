# --
# Kernel/Modules/AdminInit.pm - init a new setup
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminInit.pm,v 1.1 2006-03-09 16:38:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminInit;

use strict;
use Kernel::System::Config;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{SysConfigObject} = Kernel::System::Config->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # return do admin screen
    if ($Self->{Subaction} eq 'Done') {
        return $Self->{LayoutObject}->Redirect(OP => "Action=Admin");
    }

    # write default file
    if (!$Self->{SysConfigObject}->WriteDefault()) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # create config object
    $Self->{ConfigObject} = Kernel::Config->new(%{$Self});

    return $Self->{LayoutObject}->Redirect(OP => "Subaction=Done");
}
# --
1;
