# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::CMD;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # get communication log object and MessageID
    $Self->{CommunicationLogObject}    = $Param{CommunicationLogObject}    || die "Got no CommunicationLogObject!";
    $Self->{CommunicationLogMessageID} = $Param{CommunicationLogMessageID} || die "Got no CommunicationLogMessageID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config options
    my %Config;
    my @Set;
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Set} ) {
            @Set = @{ $Config{Set} };
        }
    }

    # check CMD config param
    if ( !$Config{CMD} ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectType => 'Message',
            ObjectID   => $Self->{CommunicationLogMessageID},
            Priority   => 'Error',
            Key        => 'Kernel::System::PostMaster::Filter::CMD',
            Value      => "Need CMD config option in PostMaster::PreFilterModule job!",
        );
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CMD config option in PostMaster::PreFilterModule job!",
        );
        return;
    }

    # execute prog
    my $TmpFile = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . "/PostMaster.Filter.CMD.$$";

    ## no critic
    if ( open my $Prog, '|-', "$Config{CMD} > $TmpFile" ) {
        ## use critic
        print $Prog $Self->{ParserObject}->GetPlainEmail();
        close $Prog;
    }

    if ( -s $TmpFile ) {
        open my $In, '<', $TmpFile;    ## no critic
        my $Ret = <$In>;
        close $In;

        # set new params
        for my $SetItem (@Set) {
            my $Key   = $SetItem->{Key};
            my $Value = $SetItem->{Value};

            $Param{GetParam}->{$Key} = $Value;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Notice',
                Key        => 'Kernel::System::PostMaster::Filter::CMD',
                Value =>
                    "Set param '$Key' to '$Value' because of '$Ret' (Message-ID: $Param{GetParam}->{'Message-ID'})",
            );
        }
    }

    unlink $TmpFile;

    return 1;
}

1;
