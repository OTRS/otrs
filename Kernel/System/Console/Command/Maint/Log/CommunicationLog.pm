# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
            'Purges successful communications older than a week and all communications older than a month.',
        Required => 0,
        HasValue => 0,
    );
    $Self->AddOption(
        Name        => 'delete-by-days-old',
        Description => 'Delete logs older than these number of days. Example: --delete-by-days-old="7"',
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
    for my $Option (qw(delete-by-id delete-by-date delete-by-days-old purge)) {
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

    my $Purge         = $Self->GetOption('purge');
    my $DeleteID      = $Self->GetOption('delete-by-id');
    my $DeleteDate    = $Self->GetOption('delete-by-date');
    my $DeleteDaysOld = $Self->GetOption('delete-by-days-old');
    my $ForceDelete   = $Self->GetOption('force-delete');

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

    elsif ($DeleteDaysOld) {
        $Success = $Self->Delete(
            DaysOld => $DeleteDaysOld,
            Force   => $ForceDelete,
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

    my $Verbose = $Self->GetOption('verbose');

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my @CommunicationIDs;

    if ( $Param{ID} ) {

        $Self->Print("\nRetrieving logs for CommunicationID '<yellow>$Param{ID}</yellow>'\n");

        my $Communication = $CommunicationLogDBObj->CommunicationGet( CommunicationID => $Param{ID} );

        if ( $Communication && ( $Communication->{Status} ne 'Processing' || $Param{Force} ) ) {
            push @CommunicationIDs, $Communication->{CommunicationID};
        }
    }

    if ( $Param{Date} ) {

        $Self->Print("\nRetrieving logs of date '<yellow>$Param{Date}</yellow>'\n");

        my $Communications = $CommunicationLogDBObj->CommunicationList(
            Date => $Param{Date},
        ) || [];

        COMMUNICATION:
        for my $Communication ( @{$Communications} ) {

            next COMMUNICATION if $Communication->{Status} eq 'Processing' && !$Param{Force};
            push @CommunicationIDs, $Communication->{CommunicationID};
        }
    }

    if ( $Param{DaysOld} ) {

        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Subtract( Days => $Param{DaysOld} );
        my $OlderDate = $DateTimeObject->Format( Format => '%Y-%m-%d' );

        $Self->Print("\nRetrieving logs of dates older than '<yellow>$OlderDate</yellow>'\n");

        my $Communications = $CommunicationLogDBObj->CommunicationList(
            OlderThan => $OlderDate,
        ) || [];

        COMMUNICATION:
        for my $Communication ( @{$Communications} ) {

            next COMMUNICATION if $Communication->{Status} eq 'Processing' && !$Param{Force};
            push @CommunicationIDs, $Communication->{CommunicationID};
        }
    }

    if ( $Param{Purge} ) {

        my $Config      = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationLog::Purge');
        my $SuccessDays = $Config->{SuccessDays} || 7;
        my $AllDays     = $Config->{AllDays} || 31;

        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $SuccessDateObject = $DateTimeObject->Clone();
        $SuccessDateObject->Subtract( Days => $SuccessDays );
        my $SuccessDate = $SuccessDateObject->Format( Format => '%Y-%m-%d' );

        my $Communications = $CommunicationLogDBObj->CommunicationList(
            OlderThan => $SuccessDate,
            Status    => 'Successful',
        ) || [];

        $DateTimeObject->Subtract( Days => $AllDays );
        my $AllDaysDate = $DateTimeObject->Format( Format => '%Y-%m-%d' );

        push @{$Communications},
            @{
            $CommunicationLogDBObj->CommunicationList(
                OlderThan => $AllDaysDate,
                )
                || []
            }
            ;

        for my $Communication ( @{$Communications} ) {
            push @CommunicationIDs, $Communication->{CommunicationID};
        }
    }

    my $CommunicationCount = scalar @CommunicationIDs;

    if ( !$CommunicationCount ) {
        $Self->Print("<yellow>No communications found for deletion!</yellow>\n");
        return 1;
    }

    my $DeleteOutput = "Going to delete <yellow>$CommunicationCount</yellow> communication(s)";
    if ( $Param{Purge} ) {
        $DeleteOutput = "Going to purge <yellow>$CommunicationCount</yellow> communication(s).";
    }
    else {
        $DeleteOutput .= $Param{Force} ? '.' : " (ignoring communications with status 'Processing').";
    }
    $Self->Print("$DeleteOutput\n");

    my $Result = 1;

    for my $CommunicationID (@CommunicationIDs) {

        my $Return = $CommunicationLogDBObj->CommunicationDelete(
            CommunicationID => $CommunicationID
        );

        if ( !$Return ) {
            $Self->PrintError("Could not delete communications with id '$CommunicationID'!\n");
            $Result = 0;
        }
    }

    return $Result;
}

1;
