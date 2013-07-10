# --
# Kernel/System/Ticket/Event/DynamicFieldFromCustomerUser.pm - ticket event module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::DynamicFieldFromCustomerUser;

use strict;
use warnings;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject TicketObject LogObject CustomerUserObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # create extra needed objects
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get dynamic fields list
    my $DynamicFields = $Self->{DynamicFieldObject}->DynamicFieldList(
        Valid      => 1,
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );
    $Self->{DynamicFields} = { reverse %{$DynamicFields} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed! in Data",
            );
            return;
        }
    }

    # get mapping config,
    my %Mapping = %{ $Self->{ConfigObject}->Get('DynamicFieldFromCustomerUser::Mapping') || {} };

    # no mapping is OK
    return 1 if !%Mapping;

    # get customer user data, so that values can be stored in dynamic fields
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{Data}->{TicketID} );
    return if !%Ticket;

    my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );

    # also continue if there was no CustomerUser data found - erase values
    # loop over the configured mapping of customer data variables to dynamic fields
    CUSTOMERUSERVARIABLENAME:
    for my $CustomerUserVariableName ( sort keys %Mapping ) {

        # check config for the particular mapping
        if ( !defined $Self->{DynamicFields}->{ $Mapping{$CustomerUserVariableName} } ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "DynamicField $Mapping{$CustomerUserVariableName} in DynamicFieldFromCustomerUser::Mapping must be set in system and valid.",
            );
            next CUSTOMERUSERVARIABLENAME;
        }

        my $DynamicFieldConfig = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $Mapping{$CustomerUserVariableName},
        );

        # update dynamic field value for ticket
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{Data}->{TicketID},
            Value              => $CustomerUserData{$CustomerUserVariableName} || '',
            UserID             => $Param{UserID},
        );
    }

    return 1;
}

1;
