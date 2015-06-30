# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Registration::UpdateSend;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Registration',
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Send an OTRS system registration update to OTRS Group.');

    $Self->AddOption(
        Name        => 'force',
        Description => "Force to execute even if next update time has not been reach.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Sending system registration update...</yellow>\n");

    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');

    my %RegistrationData = $RegistrationObject->RegistrationDataGet();

    if ( $RegistrationData{State} ne 'registered' ) {
        $Self->Print("System is not registered, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $NextUpdateSystemTime = 0;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # if there is a defined NextUpdeTime convert it system time
    if ( $RegistrationData{NextUpdateTime} ) {
        $NextUpdateSystemTime = $TimeObject->TimeStamp2SystemTime(
            String => $RegistrationData{NextUpdateTime},
        );
    }

    my $SystemTime = $TimeObject->SystemTime();

    my $Force = $Self->GetOption('force') || 0;

    # do not update registration info before the next update (unless is forced)
    if ( !$Force && $SystemTime < $NextUpdateSystemTime ) {
        $Self->Print("No need to send the registration update at this moment, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    # send the registration update
    my %Result = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationUpdateSend();

    # if everything is OK return successfully
    if ( $Result{Success} ) {
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    # if there was a error get the registration information once again
    my %UpdatedRegistrationData = $RegistrationObject->RegistrationDataGet();

    my $NextUpdateTime = $UpdatedRegistrationData{NextUpdateTime} // '';
    $RegistrationData{NextUpdateTime} //= '';

    # if the next update time was not set or is the same as the original, there should be a
    # communications issue with the portal, retry in two hours
    if ( !$NextUpdateTime || $RegistrationData{NextUpdateTime} eq $NextUpdateTime ) {

        # calculate next update time set it in two hours
        $NextUpdateTime = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $SystemTime + ( 60 * 60 * 2 ),
        );

        # update or set the NextUpdateTime value
        if ( defined $UpdatedRegistrationData{NextUpdateTime} ) {

            $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataUpdate(
                Key    => 'Registration::NextUpdateTime',
                Value  => $NextUpdateTime,
                UserID => 1,
            );
        }
        else {

            $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataAdd(
                Key    => 'Registration::NextUpdateTime',
                Value  => $NextUpdateTime,
                UserID => 1,
            );
        }
    }

    $Self->PrintError("System registration update was not sent successfully.");
    $Self->PrintError("$Result{Reason}");
    return $Self->ExitCodeError();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
