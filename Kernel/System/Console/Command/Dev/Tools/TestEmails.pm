# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::TestEmails;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand Kernel::System::Console::Command::List);

our @ObjectDependencies = (
    'Kernel::System::Email::Test',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Get emails from test backend and output them to screen.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

    my $Emails = $TestBackendObject->EmailsGet();
    for my $Email ( @{ $Emails || [] } ) {
        my $Header = ${ $Email->{Header} };
        my $From   = 'From - ';
        if ( $Header =~ /Date:\s(.*?)\n/ ) {
            $From .= $1;
        }
        my $Body = ${ $Email->{Body} };
        $Self->Print( $From . "\n" . $Header . "\n\n" . $Body . "\n\n" );
    }

    $TestBackendObject->CleanUp();

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
