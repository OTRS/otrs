# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::Base;

use strict;
use warnings;

use utf8;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

sub _CheckParams {
    my ( $Self, %Param ) = @_;

    my $CommonMessage = $Param{CommonMessage};

    for my $Needed (
        qw(UserID Ticket ProcessEntityID ActivityEntityID TransitionEntityID
        TransitionActionEntityID Config
        )
        )
    {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check if we have Ticket to deal with
    if ( !IsHashRefWithData( $Param{Ticket} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Ticket has no values!",
        );
        return;
    }

    # Check if we have a ConfigHash
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Config has no values!",
        );
        return;
    }

    return 1;
}

sub _OverrideUserID {
    my ( $Self, %Param ) = @_;

    if ( IsNumber( $Param{Config}->{UserID} ) ) {
        $Param{UserID} = $Param{Config}->{UserID};
        delete $Param{Config}->{UserID};
    }

    return $Param{UserID};
}

sub _ReplaceTicketAttributes {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $Attribute ( sort keys %{ $Param{Config} } ) {

        # replace ticket attributes such as <OTRS_Ticket_DynamicField_Name1> or
        # <OTRS_TICKET_DynamicField_Name1>
        # <OTRS_Ticket_*> is deprecated and should be removed in further versions of OTRS
        my $Count = 0;
        REPLACEMENT:
        while (
            $Param{Config}->{$Attribute}
            && $Param{Config}->{$Attribute} =~ m{<OTRS_TICKET_([A-Za-z0-9_]+)>}msxi
            && $Count++ < 1000
            )
        {
            my $TicketAttribute = $1;

            if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
                my $DynamicFieldName = $1;

                my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next REPLACEMENT if !$DynamicFieldConfig;

                # get the display value for each dynamic field
                my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Key                => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
                );

                my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $DisplayValue,
                );

                $Param{Config}->{$Attribute}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

                next REPLACEMENT;
            }

            # if ticket value is scalar substitute all instances (as strings)
            # this will allow replacements for "<OTRS_TICKET_Title> <OTRS_TICKET_Queue"
            if ( !ref $Param{Ticket}->{$TicketAttribute} ) {
                $Param{Config}->{$Attribute}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$Param{Ticket}->{$TicketAttribute} // ''}ige;
            }
            else {

                # if the vale is an array (e.g. a multiselect dynamic field) set the value directly
                # this unfortunately will not let a combination of values to be replaced
                $Param{Config}->{$Attribute} = $Param{Ticket}->{$TicketAttribute};
            }
        }
    }

    return 1;
}

sub _ConvertScalar2ArrayRef {
    my ( $Self, %Param ) = @_;

    my @Data = split /,/, $Param{Data};

    # remove any possible heading and tailing white spaces
    for my $Item (@Data) {
        $Item =~ s{\A\s+}{};
        $Item =~ s{\s+\z}{};
    }

    return \@Data;
}

1;
