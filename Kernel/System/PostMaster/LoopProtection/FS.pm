# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::LoopProtection::FS;

use strict;
use warnings;

use parent 'Kernel::System::PostMaster::LoopProtectionCommon';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
);

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = $Type->SUPER::new(%Param);

    $Self->{LoopProtectionLog} = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionLog')
        || die 'No Config option "LoopProtectionLog"!';
    $Self->{LoopProtectionLog} .= '-' . $Self->{LoopProtectionDate} . '.log';

    return $Self;
}

sub SendEmail {
    my ( $Self, %Param ) = @_;

    my $To = $Param{To} || return;

    # write log
    ## no critic
    if ( open( my $Out, '>>', $Self->{LoopProtectionLog} ) ) {
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        ## use critic
        print $Out "$To;" . $DateTimeObject->Format( Format => '%a %b %{day} %H:%M:%S %Y' ) . ";\n";    ## no critic
        close($Out);
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
        );
    }

    return 1;
}

sub Check {
    my ( $Self, %Param ) = @_;

    my $To    = $Param{To} || return;
    my $Count = 0;

    # check existing logfile
    ## no critic
    if ( !open( my $In, '<', $Self->{LoopProtectionLog} ) ) {
        ## use critic

        # create new log file
        ## no critic
        if ( !open( my $Out, '>', $Self->{LoopProtectionLog} ) ) {
            ## use critic
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
            );
        }
        else {
            close($Out);
        }
    }
    else {

        # open old log file
        while (<$In>) {
            my @Data = split( /;/, $_ );
            if ( $Data[0] eq $To ) {
                $Count++;
            }
        }
        close($In);
    }

    # check possible loop
    my $Max = $Self->{PostmasterMaxEmailsPerAddress}{ lc $To } // $Self->{PostmasterMaxEmails};

    if ( $Max && $Count >= $Max ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "LoopProtection: send no more emails to '$To'! Max. count of $Self->{PostmasterMaxEmails} has been reached!",
        );
        return;
    }

    return 1;
}

1;
