# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::StandardTemplate::QueueLink;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Queue',
    'Kernel::System::StandardTemplate',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Link a template to a queue.');
    $Self->AddOption(
        Name        => 'template-name',
        Description => "Name of the template which should be linked to the given queue.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'queue-name',
        Description => "Name of the queue the given template should be linked to.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check template
    $Self->{TemplateName} = $Self->GetOption('template-name');
    $Self->{TemplateID}   = $Kernel::OM->Get('Kernel::System::StandardTemplate')
        ->StandardTemplateLookup( StandardTemplate => $Self->{TemplateName} );
    if ( !$Self->{TemplateID} ) {
        die "Standard template '$Self->{TemplateName}' does not exist.\n";
    }

    # check queue
    $Self->{QueueName} = $Self->GetOption('queue-name');
    $Self->{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Self->{QueueName} );
    if ( !$Self->{QueueID} ) {
        die "Queue '$Self->{QueueName}' does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trying to link template $Self->{TemplateName} to queue $Self->{QueueName}...</yellow>\n");

    if (
        !$Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberAdd(
            StandardTemplateID => $Self->{TemplateID},
            QueueID            => $Self->{QueueID},
            Active             => 1,
            UserID             => 1,
        )
        )
    {
        $Self->PrintError("Can't link template to queue.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
