# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::CustomerCompany::Add;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CustomerCompany',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add a customer company.');
    $Self->AddOption(
        Name        => 'customer-id',
        Description => "Company ID for the new customer company.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'name',
        Description => "Company name for the new customer company.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'street',
        Description => "Street of the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'zip',
        Description => "ZIP code of the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'city',
        Description => "City of the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'country',
        Description => "Country of the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'url',
        Description => "URL of the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'comment',
        Description => "Comment for the new customer company.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding a new customer company...</yellow>\n");

    # add customer company
    if (
        !$Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $Self->GetOption('customer-id'),
            CustomerCompanyName    => $Self->GetOption('name'),
            CustomerCompanyStreet  => $Self->GetOption('street'),
            CustomerCompanyZIP     => $Self->GetOption('zip'),
            CustomerCompanyCity    => $Self->GetOption('city'),
            CustomerCompanyCountry => $Self->GetOption('country'),
            CustomerCompanyURL     => $Self->GetOption('url'),
            CustomerCompanyComment => $Self->GetOption('comment'),
            ValidID                => 1,
            UserID                 => 1,
        )
        )
    {
        $Self->PrintError("Can't add customer company.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
