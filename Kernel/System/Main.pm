# --
# Kernel/System/Main.pm - main core components
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Main.pm,v 1.3 2006-08-29 17:30:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Main;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    return $Self;
}

sub Require {
    my $Self = shift;
    my $Module = shift;
    if (!$Module) {
        $Self->{LogObject}->Log(
             Priority => 'error',
             Message => "Need module!",
        );
    }
    if (eval "require $Module") {
        # log loaded module
        if ($Self->{Debug} > 1) {
            $Self->{LogObject}->Log(
                 Priority => 'debug',
                 Message => "Module: $Module loaded!",
            );
        }
        return 1;
    }
    else {
        # check if file name exists
        my $FileName = $Module.'.pm';
        $FileName =~ s/::/\//g;
        my $Error = 0;
        foreach my $Prefix (@INC) {
             my $File = "$Prefix/$FileName";
             if (-f $File) {
                 $Error = $File;
                 last;
             }
        }
        # if file name exists, show syntax error
        if ($Error) {
            my $R = do $Error;
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "$@",
            );
        }
        # if there is no file, show not found error
        else {
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "Module '$Module' not found!",
            );
        }
        return;
    }
}
1;
