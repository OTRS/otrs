# --
# Kernel/System/PostMaster/Filter/CMD.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CMD.pm,v 1.11 2008-08-20 15:10:38 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::Filter::CMD;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject ParserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config options
    my %Config = ();
    my %Set    = ();
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
        }
    }

    # check CMD config param
    if ( !$Config{CMD} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CMD config option in PostMaster::PreFilterModule job!',
        );
        return;
    }

    # execute prog
    my $TmpFile = $Self->{ConfigObject}->Get('TempDir') . "/PostMaster.Filter.CMD.$$";
    if ( open my $Prog, '|-', "$Config{CMD} > $TmpFile" ) {
        print $Prog $Self->{ParserObject}->GetPlainEmail();
        close $Prog;
    }
    if ( -s $TmpFile ) {
        open my $In, '<', $TmpFile;
        my $Ret = <$In>;
        close $In;

        # set new params
        for ( keys %Set ) {
            $Param{GetParam}->{$_} = $Set{$_};
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "Set param '$_' to '$Set{$_}' because of '$Ret' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
            );
        }
    }
    unlink $TmpFile;
    return 1;
}

1;
