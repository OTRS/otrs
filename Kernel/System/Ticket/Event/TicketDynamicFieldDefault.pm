# --
# Kernel/System/Ticket/Event/TicketDynamicFieldDefault.pm - a event module for default ticket dynamic field settings
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketDynamicFieldDefault;
use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(
        EncodeObject => $Param{TicketObject}->{EncodeObject},
        MainObject   => $Param{TicketObject}->{MainObject},
        DBObject     => $Param{TicketObject}->{DBObject},
        %Param,
    );
    $Self->{BackendObject} = Kernel::System::DynamicField::Backend->new(
        EncodeObject => $Param{TicketObject}->{EncodeObject},
        MainObject   => $Param{TicketObject}->{MainObject},
        DBObject     => $Param{TicketObject}->{DBObject},
        TimeObject   => $Param{TicketObject}->{TimeObject},
        %Param,
    );

    # get the dynamic fields
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # create a lookup table by name (since name is unique)
    DYNAMICFIELD:
    for my $DynamicField ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !$DynamicField->{Name};

        $Self->{DynamicFieldLookup}->{ $DynamicField->{Name} } = $DynamicField;
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # get settings from sysconfig
    my $ConfigSettings = $Self->{ConfigObject}->Get('Ticket::TicketDynamicFieldDefault');

    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
    );

    ELEMENT:
    for my $ElementName ( sort keys %{$ConfigSettings} ) {
        my $Element = $ConfigSettings->{$ElementName};
        if ( $Param{Event} eq $Element->{Event} ) {

            # do not set default dynamic field if already set
            next ELEMENT if $Ticket{ 'DynamicField_' . $Element->{Name} };

            # check if field is defined and valid
            next ELEMENT if !$Self->{DynamicFieldLookup}->{ $Element->{Name} };

            # get dynamic field config
            my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Element->{Name} };

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Param{Data}->{TicketID},
                Value              => $Element->{Value},
                UserID             => $Param{UserID},
            );

            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Can not set value $Element->{Value} for dynamic field $Element->{Name}!"
                );
            }
        }
    }
    return 1;
}

1;
