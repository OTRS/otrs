# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::UnitTest::Run;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::UnitTest',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Executes unit tests.');
    $Self->AddOption(
        Name        => 'test',
        Description => "Run single test files, e.g. 'Ticket' or 'Ticket:Queue'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'directory',
        Description => "Run all test files in specified directory.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'output',
        Description => "Select output format (ASCII|HTML|XML).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^(ASCII|HTML|XML)$/smx,
    );
    $Self->AddOption(
        Name        => 'submit-url',
        Description => "Send unit test results to a server (url).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'product',
        Description => "Specify a different product name.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest' => {
            Output => $Self->GetOption('output') || '',
        },
    );

    my $FunctionResult = $Kernel::OM->Get('Kernel::System::UnitTest')->Run(
        Name      => $Self->GetOption('test')       || '',
        Directory => $Self->GetOption('directory')  || '',
        Product   => $Self->GetOption('product')    || '',
        SubmitURL => $Self->GetOption('submit-url') || '',
    );

    if ($FunctionResult) {
        return $Self->ExitCodeOk();
    }
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
