# --
# Kernel/System/Ticket/ColumnFilter.pm - all column filter functions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ColumnFilter;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::Ticket::ColumnFilter - Column Filter library

=head1 SYNOPSIS

All functions for Column Filters.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketColumnFilterObject = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item StateFilterValuesGet()

get a list of states within the given ticket is list

    my $Values = $ColumnFilterObject->StateFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'New',
        4 => 'Open',
    };

=cut

sub StateFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {
        return if !$Param{UserID};

        # get state list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::State',
            FunctionName => 'StateList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.ticket_state_id), ts.name"
            . " FROM ticket t, ticket_state ts"
            . " WHERE t.ticket_state_id = ts.id"
            . $TicketIDString
            . " ORDER BY t.ticket_state_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item QueueFilterValuesGet()

get a list of queues within the given ticket is list

    my $Values = $ColumnFilterObject->QueueFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        2 => 'raw',
        3 => 'Junk',
    };

=cut

sub QueueFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        # check needed param
        return if !$Param{UserID};

        # get queue list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::Queue',
            FunctionName => 'QueueList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.queue_id), q.name"
            . " FROM ticket t, queue q"
            . " WHERE t.queue_id = q.id"
            . $TicketIDString
            . " ORDER BY t.queue_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item PriorityFilterValuesGet()

get a list of priorities within the given ticket is list

    my $Values = $ColumnFilterObject->PriorityFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        3 => '3 Normal',
    };

=cut

sub PriorityFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get priority list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::Priority',
            FunctionName => 'PriorityList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.ticket_priority_id), tp.name"
            . " FROM ticket t, ticket_priority tp"
            . " WHERE t.ticket_priority_id = tp.id"
            . $TicketIDString
            . " ORDER BY t.ticket_priority_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item TypeFilterValuesGet()

get a list of ticket types within the given ticket is list

    my $Values = $ColumnFilterObject->TypeFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'Default',
    };

=cut

sub TypeFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get type list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::Type',
            FunctionName => 'TypeList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.type_id), tt.name"
            . " FROM ticket t, ticket_type tt"
            . " WHERE AND t.type_id = tt.id"
            . $TicketIDString
            . " ORDER BY t.type_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item LockFilterValuesGet()

get a list of ticket lock values within the given ticket is list

    my $Values = $ColumnFilterObject->LockFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'unlock',
        4 => 'lock',
    };

=cut

sub LockFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get lock list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::Lock',
            FunctionName => 'LockList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.ticket_lock_id), tlt.name"
            . " FROM ticket t, ticket_lock_type tlt"
            . " WHERE ticket_lock_id = tlt.id"
            . $TicketIDString
            . " ORDER BY t.ticket_lock_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item ServiceFilterValuesGet()

get a list of services within the given ticket is list

    my $Values = $ColumnFilterObject->ServiceFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'My Service',
    };

=cut

sub ServiceFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get service list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::Service',
            FunctionName => 'ServiceList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.service_id), s.name"
            . " FROM ticket t, service s"
            . " WHERE t.service_id = s.id"
            . $TicketIDString
            . " ORDER BY t.service_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item SLAFilterValuesGet()

get a list of service level agreements within the given ticket is list

    my $Values = $ColumnFilterObject->SLAFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'MySLA',
    };

=cut

sub SLAFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get sla list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::SLA',
            FunctionName => 'SLAList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs => $Param{TicketIDs},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.sla_id), s.name"
            . " FROM ticket t, sla s"
            . " WHERE t.sla_id = s.id"
            . $TicketIDString
            . " ORDER BY t.sla_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    return \%Data;
}

=item CustomerFilterValuesGet()

get a list of customer ids within the given ticket is list

    my $Values = $ColumnFilterObject->CustomerFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        'CompanyA' => 'CompanyA',
    };

=cut

sub CustomerFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketIDs!',
        );
        return;
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs  => $Param{TicketIDs},
        IncludeAdd => 0,
    );

    if ( !$TicketIDString ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs condition string is empty!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.customer_id)"
            . " FROM ticket t"
            . " WHERE $TicketIDString"
            . " ORDER BY t.customer_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[0];
        }
    }

    return \%Data;
}

=item CustomerUserIDFilterValuesGet()

get a list of customer users within the given ticket is list

    my $Values = $ColumnFilterObject->CustomerUserIDFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        'MyCustomer' => 'MyCustomer',
    };

=cut

sub CustomerUserIDFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketIDs!',
        );
        return;
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs  => $Param{TicketIDs},
        IncludeAdd => 0,
    );

    if ( !$TicketIDString ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs condition string is empty!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.customer_user_id)"
            . " FROM ticket t"
            . " WHERE $TicketIDString"
            . " ORDER BY t.customer_user_id DESC",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Data{ $Row[0] } = $Row[0];
        }
    }

    return \%Data;
}

=item OwnerFilterValuesGet()

get a list of ticket owners within the given ticket is list

    my $Values = $ColumnFilterObject->OwnerFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'Admin OTRS',
    };

=cut

sub OwnerFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get user list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::User',
            FunctionName => 'UserList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs  => $Param{TicketIDs},
        IncludeAdd => 0,
    );

    if ( !$TicketIDString ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs condition string is empty!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.user_id)"
            . " FROM ticket t"
            . " WHERE $TicketIDString"
            . " ORDER BY t.user_id DESC",
    );

    my @UserList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            push @UserList, $Row[0];
        }
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %Data;
    if ( scalar @UserList > 0 ) {
        for my $UserID (@UserList) {
            my %User = $UserObject->GetUserData(
                UserID => $UserID,
            );
            if (%User) {
                $Data{$UserID} = $User{UserFirstname} . ' ' . $User{UserLastname};
            }
        }
    }

    return \%Data;
}

=item ResponsibleFilterValuesGet()

get a list of ticket responsibles within the given ticket is list

    my $Values = $ColumnFilterObject->ResponsibleFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],                    # array ref list of ticket IDs
    );

    returns

    $Values = {
        1 => 'Admin OTRS',
    };

=cut

sub ResponsibleFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketIDs} ) {

        return if !$Param{UserID};

        # get user list
        return $Self->_GeneralDataGet(
            ModuleName   => 'Kernel::System::User',
            FunctionName => 'UserList',
            UserID       => $Param{UserID},
        );
    }

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs  => $Param{TicketIDs},
        IncludeAdd => 0,
    );

    if ( !$TicketIDString ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs condition string is empty!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(t.responsible_user_id)"
            . " FROM ticket t"
            . " WHERE $TicketIDString"
            . " ORDER BY t.responsible_user_id DESC",
    );

    my @UserList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            push @UserList, $Row[0];
        }
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %Data;
    if ( scalar @UserList > 0 ) {
        for my $UserID (@UserList) {
            my %User = $UserObject->GetUserData(
                UserID => $UserID,
            );
            if (%User) {
                $Data{$UserID} = $User{UserFirstname} . ' ' . $User{UserLastname};
            }
        }
    }

    return \%Data;
}

=item DynamicFieldFilterValuesGet()

get a list of a specific ticket dynamic field values within the given tickets list

    my $Values = $ColumnFilterObject->DynamicFieldFilterValuesGet(
        TicketIDs => [23, 1, 56, 74],    # array ref list of ticket IDs
        ValueType => 'Text',             # Text | Integer | Date
        FieldID   => $FieldID,           # ID of the dynamic field
    );

    returns

    $Values = {
        ValueA => 'ValueA',
        ValueB => 'ValueB',
        ValueC => 'ValueC'
    };

=cut

sub DynamicFieldFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketIDs ValueType FieldID)) {

        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $TicketIDString = $Self->_TicketIDStringGet(
        TicketIDs  => $Param{TicketIDs},
        ColumnName => 'object_id',
    );

    if ( !IsArrayRefWithData( $Param{TicketIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'TicketIDs must be an array ref!',
        );
        return;
    }

    my $ValueType = 'value_text';
    if ( $Param{ValueType} && $Param{ValueType} eq 'DateTime' ) {
        $ValueType = 'value_date';
    }
    elsif ( $Param{ValueType} && $Param{ValueType} eq 'Integer' ) {
        $ValueType = 'value_int';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            "SELECT DISTINCT($ValueType)"
            . ' FROM dynamic_field_value'
            . ' WHERE field_id = ?'
            . $TicketIDString
            . " ORDER BY $ValueType DESC",
        Bind => [ \$Param{FieldID} ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # check if the value is already stored
        if (
            defined $Row[0]
            && $Row[0] ne ''
            && !$Data{ $Row[0] }
            )
        {

            if ( $ValueType eq 'Date' ) {

                # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
                # and 0000-00-00 00:00:00 time stamps)
                if ( $Row[0] eq '0000-00-00 00:00:00' ) {
                    $Row[0] = undef;
                }
                $Row[0] =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
            }

            # store the results
            $Data{ $Row[0] } = $Row[0];
        }
    }

    return \%Data;
}

sub _GeneralDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ModuleName FunctionName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $FuctionName = $Param{FunctionName};

    # set the backend file
    my $BackendModule = $Param{ModuleName};

    # check if backend field exists
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($BackendModule) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't load backend module $BackendModule!",
        );
        return;
    }

    # create a backend object
    my $BackendObject = $BackendModule->new( %{$Self} );

    if ( !$BackendObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Couldn't create a backend object for $BackendModule!",
        );
        return;
    }

    if ( ref $BackendObject ne $BackendModule ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend object for $BackendModule was not created successfuly!",
        );
        return;
    }

    # get data list
    my %DataList = $BackendObject->$FuctionName(
        Valid  => 0,
        UserID => $Param{UserID},
    );

    return \%DataList;
}

sub _TicketIDStringGet {
    my ( $Self, %Param ) = @_;

    $Param{IncludeAdd} = 1 if !defined $Param{IncludeAdd};

    my $ColumnName = $Param{ColumnName} || 't.id';

    my $TicketIDString = '';
    if ( IsArrayRefWithData( $Param{TicketIDs} ) ) {

        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # sort ids to cache the SQL query
        my @SortedIDs = sort { $a <=> $b } @{ $Param{TicketIDs} };

        # quote values
        SORTEDID:
        for my $TicketID ( @SortedIDs ) {
            next SORTEDID if !defined $DBObject->Quote( $TicketID, 'Integer' );
        }

        # split IN statement with more than 900 elements in more statements bombined with OR
        # because Oracle doesn't support more than 1000 elements in one IN statement.
        my @SQLStrings;
        while ( scalar @SortedIDs ) {

            # remove section in the array
            my @SortedIDsPart = splice @SortedIDs, 0, 900;

            # link together IDs
            my $IDString = join ',', @SortedIDsPart;

            # add new statement
            push @SQLStrings, " $ColumnName IN ($IDString) ";
        }

        my $SQLString = join ' OR ', @SQLStrings;

        if ( $Param{IncludeAdd} ) {
            $TicketIDString .= ' AND ( ' . $SQLString . ' ) ';
        }
        else {
            $TicketIDString = $SQLString
        }

    }

    return $TicketIDString;
}


=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
