# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Ticket::DynamicField;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Calendar::Ticket::DynamicField - DynamicField appointment type

=head1 DESCRIPTION

DynamicField ticket appointment type.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketDynamicFieldObject = $Kernel::OM->Get('Kernel::System::Calendar::Ticket::DynamicField');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 GetTime()

returns time value for dynamic field appointment type.

    my $StartTime = $TicketDynamicFieldObject->GetTime(
        Type     => 'DynamicField_TestDate',
        TicketID => 1,
    );

=cut

sub GetTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get ticket data incl. dynamic fields
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );
    return if !$Ticket{ $Param{Type} };

    # check if we found a valid time value and return it
    if ( $Ticket{ $Param{Type} } =~ '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}' ) {
        return $Ticket{ $Param{Type} };
    }

    return;
}

=head2 SetTime()

set ticket dynamic field value to supplied time value.

    my $Success = $TicketDynamicFieldObject->SetTime(
        Type     => 'DynamicField_TestDate',
        Value    => '2016-01-01 00:00:00'
        TicketID => 1,
    );

returns 1 if successful.

=cut

sub SetTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Value TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get dynamic field data
    my $DynamicFieldName = $Param{Type};
    $DynamicFieldName =~ s/^DynamicField_//;
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $DynamicFieldName,
    );
    return if !$DynamicField;

    # set dynamic field value
    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
        FieldID  => $DynamicField->{ID},
        ObjectID => $Param{TicketID},
        Value    => [
            {
                ValueDateTime => $Param{Value},
            },
        ],
        UserID => 1,
    );

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
