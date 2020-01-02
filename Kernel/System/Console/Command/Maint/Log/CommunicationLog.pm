# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Log::CommunicationLog;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::CommunicationLog::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Management of communication logs.');
    $Self->AddOption(
        Name        => 'force-delete',
        Description => "Delete even if still processing.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name => 'purge',
        Description =>
            'Purge successful communications older than a week and all communications older than a month. These durations are specified in SysConfig.',
        Required => 0,
        HasValue => 0,
    );
    $Self->AddOption(
        Name        => 'delete-by-hours-old',
        Description => 'Delete logs older than these number of hours. Example: --delete-by-hours-old="7"',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'delete-by-date',
        Description => 'Delete from specific date. Example: --delete-by-date="2001-12-01"',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d\d\d\d-\d\d-\d\d$/smx,
    );
    $Self->AddOption(
        Name        => 'delete-by-id',
        Description => 'Delete logs from CommunicationID. Example: --delete-by-id="abcdefg12345"',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^.+$/smx,
    );
    $Self->AddOption(
        Name => 'verbose',
        Description =>
            'Display debug information (can be used with --purge). Example: --purge --verbose',
        Required => 0,
        HasValue => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my %Options;
    for my $Option (qw(delete-by-id delete-by-date delete-by-hours-old purge)) {
        $Options{$Option} = 1 if $Self->GetOption($Option);
    }

    if ( scalar keys %Options > 1 ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Only one type of action allowed per execution!\n";
    }

    if ( !%Options ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --purge, --delete-by-id, --delete-by-date or --delete-by-days-old must be given!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Purge          = $Self->GetOption('purge');
    my $DeleteID       = $Self->GetOption('delete-by-id');
    my $DeleteDate     = $Self->GetOption('delete-by-date');
    my $DeleteHoursOld = $Self->GetOption('delete-by-hours-old');
    my $ForceDelete    = $Self->GetOption('force-delete');

    my $Success = 0;

    if ($DeleteID) {
        $Success = $Self->Delete(
            ID    => $DeleteID,
            Force => $ForceDelete,
        );
    }

    elsif ($DeleteDate) {
        $Success = $Self->Delete(
            Date  => $DeleteDate,
            Force => $ForceDelete,
        );
    }

    elsif ($DeleteHoursOld) {
        $Success = $Self->Delete(
            HoursOld => $DeleteHoursOld,
            Force    => $ForceDelete,
        );
    }

    elsif ($Purge) {
        $Success = $Self->Delete(
            Purge => 1,
        );
    }

    if ($Success) {
        $Self->Print("\n<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->PrintError("Failed.\n\n");
    return $Self->ExitCodeError();
}

sub Delete {
    my ( $Self, %Param ) = @_;

    my $Verbose               = $Self->GetOption('verbose');
    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $Result                = 1;

    if ( $Param{ID} ) {

        $Self->Print(
            sprintf(
                "Going to delete communication with ID '$Param{ID}'%s!\n",
                ( $Param{Force} ? '' : " except if isn't processing" ),
            ),
        );

        $Result = $CommunicationLogDBObj->CommunicationDelete(
            CommunicationID => $Param{ID},
            ( $Param{Force} ? () : ( Status => '!Processing' ) ),
        );
    }

    if ( $Param{Date} ) {

        $Self->Print(
            sprintf(
                "Going to delete all communications of date '$Param{Date}'%s!\n",
                ( $Param{Force} ? '' : " except the ones with Status 'Processing'" ),
            ),
        );

        # Delete all communications for the given date, if 'force'
        #   param isn't present keep the ones that are still being processed.
        $Result = $CommunicationLogDBObj->CommunicationDelete(
            Date => $Param{Date},
            ( $Param{Force} ? () : ( Status => '!Processing' ) ),
        );
    }

    if ( $Param{HoursOld} ) {

        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Subtract( Hours => $Param{HoursOld} );
        my $OlderDate = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' );

        $Self->Print(
            sprintf(
                "Going to delete all communications older than '${ OlderDate }'%s!\n",
                ( $Param{Force} ? '' : " except the ones with Status 'Processing'" ),
            ),
        );

        # Delete all communications older than the given date, if 'force'
        #   param isn't present keep the ones that are still being processed.
        $Result = $CommunicationLogDBObj->CommunicationDelete(
            OlderThan => $OlderDate,
            ( $Param{Force} ? () : ( Status => '!Processing' ) ),
        );
    }

    if ( $Param{Purge} ) {

        my $ConfigObj    = $Kernel::OM->Get('Kernel::Config');
        my $SuccessHours = $ConfigObj->Get('CommunicationLog::PurgeAfterHours::SuccessfulCommunications');
        my $AllHours     = $ConfigObj->Get('CommunicationLog::PurgeAfterHours::AllCommunications');

        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $SuccessDateObject = $DateTimeObject->Clone();
        $SuccessDateObject->Subtract( Hours => $SuccessHours );
        my $SuccessDate = $SuccessDateObject->Format( Format => '%Y-%m-%d %H:%M:%S' );

        $Self->Print("Going to delete all communications older than '${ SuccessDate }' with status 'Successful'!\n");

        $Result = $CommunicationLogDBObj->CommunicationDelete(
            OlderThan => $SuccessDate,
            Status    => 'Successful',
        );

        if ($Result) {
            $DateTimeObject->Subtract( Hours => $AllHours );
            my $AllHoursDate = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' );

            $Self->Print("Going to delete all communications older than '${ AllHoursDate }'!\n");
            $Result = $CommunicationLogDBObj->CommunicationDelete(
                OlderThan => $AllHoursDate,
            );
        }
    }

    if ( !$Result ) {
        $Self->PrintError("Could not delete communication(s)!\n");
    }

    return $Result;
}

1;
