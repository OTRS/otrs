# --
# Kernel/System/PostMaster/Filter/CMD.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CMD.pm,v 1.3 2006-08-29 17:27:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::Filter::CMD;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject ParseObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # get config options
    my %Config = ();
    my %Set = ();
    if ($Param{JobConfig} && ref($Param{JobConfig}) eq 'HASH') {
        %Config = %{$Param{JobConfig}};
        if ($Config{Set}) {
            %Set = %{$Config{Set}};
        }
    }
    # check CMD config param
    if (!$Config{CMD}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need CMD config option in PostMaster::PreFilterModule job!",
        );
        return;
    }
    # execute prog
    my $TmpFile = $Self->{ConfigObject}->Get('TempDir')."/PostMaster.Filter.CMD.$$";
    if (open(PROG, "|$Config{CMD} > $TmpFile")) {
        print PROG $Self->{ParseObject}->GetPlainEmail();
        close (PROG);
    }
    if (-s $TmpFile) {
        open(IN, "< $TmpFile");
        my $Ret = <IN>;
        close (IN);
        # set new params
        foreach (keys %Set) {
           $Param{GetParam}->{$_} = $Set{$_};
           $Self->{LogObject}->Log(
               Priority => 'notice',
               Message => "Set param '$_' to '$Set{$_}' because of '$Ret' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
           );
        }
    }
    unlink $TmpFile;
    return 1;
}

1;
