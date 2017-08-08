# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
