# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::DefaultType;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Type',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    # check, if Ticket::Type is enabled
    my $TicketType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type');

    # if not enabled, stop here
    if ( !$TicketType ) {
        return $Self->GetResults();
    }

    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

    # get default ticket type from config
    my $DefaultTicketType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type::Default');

    # get list of all ticket types
    my %AllTicketTypes = reverse $TypeObject->TypeList();

    if ( $AllTicketTypes{$DefaultTicketType} ) {
        $Self->AddResultOk(
            Label => Translatable('Default Ticket Type'),
            Value => $DefaultTicketType,
        );
    }
    else {
        $Self->AddResultWarning(
            Label => Translatable('Default Ticket Type'),
            Value => $DefaultTicketType,
            Message =>
                Translatable(
                'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.'
                ),
        );
    }

    return $Self->GetResults();
}

1;
