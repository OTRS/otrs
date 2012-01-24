# --
# Kernel/GenericInterface/Operation/Ticket/TicketSearch.pm - GenericInterface Ticket Search operation backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: TicketSearch.pm,v 1.9 2012-01-24 22:33:48 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketSearch;

use strict;
use warnings;

use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw( :all );
use Kernel::GenericInterface::Operation::Common;
use Kernel::GenericInterface::Operation::Ticket::Common;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketSearch - GenericInterface Ticket Search Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{DFBackendObject}    = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{CommonObject}       = Kernel::GenericInterface::Operation::Common->new( %{$Self} );
    $Self->{TicketCommonObject}
        = Kernel::GenericInterface::Operation::Ticket::Common->new( %{$Self} );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    # get config for this screen
    $Self->{Config} = $Self->{ConfigObject}->Get('GenericInterface::Operation::TicketCreate');

    return $Self;
}

=item Run()

perform TicketSearch Operation. This will return a Ticket ID list.

    my $Result = $OperationObject->Run(
        Data => {
            TicketID => '32,33',
            DynamicFields     => 0, # Optional, 0 as default
            Extended          => 1, # Optional 0 as default
            AllArticles       => 1, # Optional 0 as default
            ArticleSenderType => [ $ArticleSenderType1, $ArticleSenderType2 ], # Optional, only requested article sender types
            ArticleOrder      => 'DESC', # Optional, DESC,ASC - default is ASC
            ArticleLimit      => 5, # Optional
            Attachments       => 1, # Optional, 1 as default
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {},
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->{CommonObject}->Auth(
        %Param
    );

    return $Self->{TicketCommonObject}->ReturnError(
        ErrorCode    => 'TicketSearch.AuthFail',
        ErrorMessage => "TicketSearch: Authorization failing!",
    ) if !$UserID;

    # all needed variables
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Param{Data}->{SortBy}
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $Param{Data}->{OrderBy}
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{FullTextIndex} = $Param{Data}->{FullTextIndex} || 0;

    my $ReturnData = {
        Success => 1,
    };

    # get parameter from data
    my %GetParam = $Self->_GetParams( %{ $Param{Data} } );

    # create time settings
    %GetParam = $Self->_CreateTimeSettings(%GetParam);

    # get dynamic fields
    my %DynamicFieldSearchParameters = $Self->_GetDynamicFields(%GetParam);

    # perform ticket search
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result              => 'ARRAY',
        SortBy              => $Self->{SortBy},
        OrderBy             => $Self->{OrderBy},
        Limit               => $Self->{SearchLimit},
        UserID              => $UserID,
        ConditionInline     => $Self->{Config}->{ExtendedSearchCondition},
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => $Self->{FullTextIndex},
        %GetParam,
        %DynamicFieldSearchParameters,
    );

    if ( !IsArrayRefWithData( \@TicketIDs ) ) {

        my $ErrorMessage = 'Could not get Ticket data'
            . ' in Kernel::GenericInterface::Operation::Ticket::TicketSearch::Run()';

        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketSearch.NotTicketData',
            ErrorMessage => "TicketSearch: $ErrorMessage",
        );

    }

    # set ticket data into return structure
    $ReturnData->{Data}->{Item} = \@TicketIDs;

    # return result
    return $ReturnData;
}

=begin Internal:

=item _GetParams()

get search parameters.

    my %GetParam = _GetParams(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedParams => 'WithContent', # return not empty parameters for search
    }

=cut

sub _GetParams {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam;

    for my $Item (
        qw(TicketNumber Title From To Cc Subject Body CustomerID CustomerUserLogin StateType
        Agent ResultForm TimeSearchType ChangeTimeSearchType CloseTimeSearchType UseSubQueues
        ArticleTimeSearchType SearchInArchive
        Fulltext ShownAttributes
        ArticleCreateTimePointFormat ArticleCreateTimePoint
        ArticleCreateTimePointStart
        ArticleCreateTimeStart ArticleCreateTimeStartDay ArticleCreateTimeStartMonth
        ArticleCreateTimeStartYear
        ArticleCreateTimeStop ArticleCreateTimeStopDay ArticleCreateTimeStopMonth
        ArticleCreateTimeStopYear
        TicketCreateTimePointFormat TicketCreateTimePoint
        TicketCreateTimePointStart
        TicketCreateTimeStart TicketCreateTimeStartDay TicketCreateTimeStartMonth
        TicketCreateTimeStartYear
        TicketCreateTimeStop TicketCreateTimeStopDay TicketCreateTimeStopMonth
        TicketCreateTimeStopYear
        TicketChangeTimePointFormat TicketChangeTimePoint
        TicketChangeTimePointStart
        TicketChangeTimeStart TicketChangeTimeStartDay TicketChangeTimeStartMonth
        TicketChangeTimeStartYear
        TicketChangeTimeStop TicketChangeTimeStopDay TicketChangeTimeStopMonth
        TicketChangeTimeStopYear
        TicketCloseTimePointFormat TicketCloseTimePoint
        TicketCloseTimePointStart
        TicketCloseTimeStart TicketCloseTimeStartDay TicketCloseTimeStartMonth
        TicketCloseTimeStartYear
        TicketCloseTimeStop TicketCloseTimeStopDay TicketCloseTimeStopMonth
        TicketCloseTimeStopYear
        )
        )
    {

        # get search string params (get submitted params)
        if ( IsStringWithData( $Param{$Item} ) ) {

            $GetParam{$Item} = $Param{$Item};

            # remove white space on the start and end
            $GetParam{$Item} =~ s/\s+$//g;
            $GetParam{$Item} =~ s/^\s+//g;
        }
    }

    # get array params
    for my $Item (
        qw( StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
        CreatedQueueIDs CreatedUserIDs WatchUserIDs ResponsibleIDs
        TypeIDs ServiceIDs SLAIDs LockIDs Queues Types States
        Priorities Services SLAs Locks CreatedTypes CreatedUserIDs
        CreatedTypes CreatedTypeIDs CreatedPriorities
        CreatedPriorityIDs CreatedStates CreatedStateIDs
        CreatedQueues CreatedQueueIDs )
        )
    {

        # get search array params
        my @Values;
        if ( IsArrayRefWithData( $Param{$Item} ) ) {
            @Values = @{ $Param{$Item} };
        }
        elsif ( IsStringWithData( $Param{$Item} ) ) {
            @Values = ( $Param{$Item} );
        }
        $GetParam{$Item} = \@Values if scalar @Values;
    }

    # get escalation times
    my %EscalationTimes = (
        1 => '',
        2 => 'Update',
        3 => 'Response',
        4 => 'Solution',
    );

    for my $Index ( sort keys %EscalationTimes ) {
        for my $PostFix (qw( OlderMinutes NewerMinutes NewerDate OlderDate )) {
            my $Item = 'TicketEscalation' . $EscalationTimes{$Index} . $PostFix;

            # get search string params (get submitted params)
            if ( IsStringWithData( $Param{$Item} ) ) {
                $GetParam{$Item} = $Param{$Item};

                # remove white space on the start and end
                $GetParam{$Item} =~ s/\s+$//g;
                $GetParam{$Item} =~ s/^\s+//g;
            }
        }
    }

    return %GetParam;

}

=item _GetDynamicFields()

get search parameters.

    my %DynamicFieldSearchParameters = _GetDynamicFields(
        %Params,                          # all ticket parameters
    );

    returns:

    %DynamicFieldSearchParameters = {
        'AllAllowedDF' => 'WithData',   # return not empty parameters for search
    }

=cut

sub _GetDynamicFields {
    my ( $Self, %Param ) = @_;

    # dynamic fields search parameters for ticket search
    my %DynamicFieldSearchParameters;

    # get single params
    my %AttributeLookup;

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $Self->{Config}->{DynamicField};

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    for my $ParameterName ( keys %Param ) {
        if ( $ParameterName =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

            # loop over the dynamic fields configured
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                # skip all fields that does not match with current field name ($1)
                # without the 'DynamicField_' prefix
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                # get new search parameter
                my $SearchParameter
                    = $Self->{BackendObject}->CommonSearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{$ParameterName},
                    );

                # add new search parameter
                # set search parameter
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};
                }
            }
        }
    }

    # allow free fields

    return %DynamicFieldSearchParameters;

}

=item _CreateTimeSettings()

get search parameters.

    my %GetParam = _CreateTimeSettings(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedTimeSettings => 'WithData',   # return not empty parameters for search
    }

=cut

sub _CreateTimeSettings {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam = %Param;

    # get close time settings
    if ( !$GetParam{ChangeTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStart$_"}
                = sprintf( "%02d", $GetParam{"TicketChangeTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStop$_"}
                = sprintf( "%02d", $GetParam{"TicketChangeTimeStop$_"} );
        }
        if (
            $GetParam{TicketChangeTimeStartDay}
            && $GetParam{TicketChangeTimeStartMonth}
            && $GetParam{TicketChangeTimeStartYear}
            )
        {
            $GetParam{TicketChangeTimeNewerDate}
                = $GetParam{TicketChangeTimeStartYear} . '-'
                . $GetParam{TicketChangeTimeStartMonth} . '-'
                . $GetParam{TicketChangeTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketChangeTimeStopDay}
            && $GetParam{TicketChangeTimeStopMonth}
            && $GetParam{TicketChangeTimeStopYear}
            )
        {
            $GetParam{TicketChangeTimeOlderDate}
                = $GetParam{TicketChangeTimeStopYear} . '-'
                . $GetParam{TicketChangeTimeStopMonth} . '-'
                . $GetParam{TicketChangeTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketChangeTimePoint}
            && $GetParam{TicketChangeTimePointStart}
            && $GetParam{TicketChangeTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketChangeTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketChangeTimePoint};
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketChangeTimePointStart} eq 'Before' ) {
                $GetParam{TicketChangeTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketChangeTimeNewerMinutes} = $Time;
            }
        }
    }

    # get close time settings
    if ( !$GetParam{CloseTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStart$_"}
                = sprintf( "%02d", $GetParam{"TicketCloseTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStop$_"}
                = sprintf( "%02d", $GetParam{"TicketCloseTimeStop$_"} );
        }
        if (
            $GetParam{TicketCloseTimeStartDay}
            && $GetParam{TicketCloseTimeStartMonth}
            && $GetParam{TicketCloseTimeStartYear}
            )
        {
            $GetParam{TicketCloseTimeNewerDate}
                = $GetParam{TicketCloseTimeStartYear} . '-'
                . $GetParam{TicketCloseTimeStartMonth} . '-'
                . $GetParam{TicketCloseTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketCloseTimeStopDay}
            && $GetParam{TicketCloseTimeStopMonth}
            && $GetParam{TicketCloseTimeStopYear}
            )
        {
            $GetParam{TicketCloseTimeOlderDate}
                = $GetParam{TicketCloseTimeStopYear} . '-'
                . $GetParam{TicketCloseTimeStopMonth} . '-'
                . $GetParam{TicketCloseTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketCloseTimePoint}
            && $GetParam{TicketCloseTimePointStart}
            && $GetParam{TicketCloseTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketCloseTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketCloseTimePoint};
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketCloseTimePointStart} eq 'Before' ) {
                $GetParam{TicketCloseTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketCloseTimeNewerMinutes} = $Time;
            }
        }
    }

    # prepare full text search
    if ( $GetParam{Fulltext} ) {
        $GetParam{ContentSearch} = 'OR';
        for (qw(From To Cc Subject Body)) {
            $GetParam{$_} = $GetParam{Fulltext};
        }
    }

    # prepare archive flag
    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

        $GetParam{SearchInArchive} ||= '';
        if ( $GetParam{SearchInArchive} eq 'AllTickets' ) {
            $GetParam{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $GetParam{SearchInArchive} eq 'ArchivedTickets' ) {
            $GetParam{ArchiveFlags} = ['y'];
        }
        else {
            $GetParam{ArchiveFlags} = ['n'];
        }
    }

    return %GetParam;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.9 $ $Date: 2012-01-24 22:33:48 $

=cut
