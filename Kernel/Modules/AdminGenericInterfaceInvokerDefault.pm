# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceInvokerDefault;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $WebserviceID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WebserviceID' );
    if ( !IsStringWithData($WebserviceID) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'WebserviceID',
        Value => $WebserviceID
    );

    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $WebserviceID,
    );

    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddEvent' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddEvent(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteEvent' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteEvent(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }

    # Fall-back.
    return $LayoutObject->ErrorScreen(
        Message => Translatable('Invalid Subaction!'),
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $InvokerType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'InvokerType' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$InvokerType ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need InvokerType'),
        );
    }
    if ( !$Self->_InvokerTypeCheck( InvokerType => $InvokerType ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'InvokerType %s is not registered', $InvokerType ),
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Action        => 'Add',
        InvokerConfig => {
            Type => $InvokerType,
        },
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $InvokerType = $ParamObject->GetParam( Param => 'InvokerType' );
    if ( !IsStringWithData($InvokerType) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need InvokerType!'),
        );
    }
    if ( !$Self->_InvokerTypeCheck( InvokerType => $InvokerType ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'InvokerType %s is not registered', $InvokerType ),
        );
    }

    my %Errors;
    my $RequestParams = $Self->_RequestParamsGet();

    # Name already exists.
    my $Invoker = $ParamObject->GetParam( Param => 'Invoker' );
    if (
        !IsStringWithData($Invoker)
        || $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker}
        )
    {
        $Errors{InvokerServerError} = 'ServerError';
    }

    my $InvokerConfig = {
        %{$RequestParams},
        Type => $InvokerType,
    };

    # Validation errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            Action        => 'Add',
            Invoker       => $Invoker,
            InvokerConfig => {
                %{$InvokerConfig},
                Invoker => $Invoker,
            },
        );
    }

    # Add invoker to config.
    $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker} = $InvokerConfig;

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    # Redirect to the edit screen.
    my $RedirectURL =
        'Action='
        . $Self->{Action}
        . ';Subaction=Change;WebserviceID='
        . $Param{WebserviceID}
        . ';Invoker='
        . $LayoutObject->LinkEncode($Invoker)
        . ';';
    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $Invoker = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Invoker' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !IsStringWithData($Invoker) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need Invoker'),
        );
    }

    my $InvokerConfig = $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker};
    if ( !IsHashRefWithData($InvokerConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not determine config for invoker %s', $Invoker ),
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Action        => 'Change',
        Invoker       => $Invoker,
        InvokerConfig => {
            %{$InvokerConfig},
            Invoker => $Invoker,
        },
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $OldInvoker = $ParamObject->GetParam( Param => 'OldInvoker' );
    if ( !IsStringWithData($OldInvoker) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Need %s', 'OldInvoker' ),
        );
    }

    my %Errors;
    my $Invoker = $ParamObject->GetParam( Param => 'Invoker' );
    if ( !IsStringWithData($Invoker) ) {
        $Errors{InvokerServerError} = 'ServerError';
    }

    my $InvokerConfig = $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$OldInvoker};
    if ( !IsHashRefWithData($InvokerConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not determine config for invoker %s', $OldInvoker ),
        );
    }

    # Invoker was renamed, avoid conflicts
    if ( $OldInvoker ne $Invoker ) {

        # New name already exists, bail out.
        if (
            $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker}
            )
        {
            $Errors{InvokerServerError} = 'ServerError';
        }

        # OK, remove old invoker. New one will be added below.
        if ( !%Errors ) {
            delete $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$OldInvoker};
        }
    }

    my $RequestParams = $Self->_RequestParamsGet();

    # Remember configured mapping content if type wasn't changed.
    MAPPINGPARAM:
    for my $MappingParam (qw(MappingInbound MappingOutbound)) {
        next MAPPINGPARAM if !$InvokerConfig->{$MappingParam}->{Type};
        next MAPPINGPARAM if !$RequestParams->{$MappingParam}->{Type};
        next MAPPINGPARAM if $InvokerConfig->{$MappingParam}->{Type} ne $RequestParams->{$MappingParam}->{Type};
        $RequestParams->{$MappingParam} = $InvokerConfig->{$MappingParam};
    }

    $InvokerConfig = {
        %{$RequestParams},
        Events => $InvokerConfig->{Events},
        Type   => $InvokerConfig->{Type},
    };

    # Validation errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            Action        => 'Change',
            Invoker       => $OldInvoker,
            InvokerConfig => {
                %{$InvokerConfig},
                Invoker => $Invoker,
            },
        );
    }

    # Update config.
    $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker} = $InvokerConfig;

    # Take care of error handling modules with invoker filters.
    ERRORHANDLING:
    for my $ErrorHandling ( sort keys %{ $Param{WebserviceData}->{Config}->{Requester}->{ErrorHandling} || {} } ) {
        if ( !IsHashRefWithData( $Param{WebserviceData}->{Config}->{Requester}->{ErrorHandling}->{$ErrorHandling} ) ) {
            next ERRORHANDLING;
        }
        my $InvokerFilter
            = $Param{WebserviceData}->{Config}->{Requester}->{ErrorHandling}->{$ErrorHandling}->{InvokerFilter};
        next ERRORHANDLING if !IsArrayRefWithData($InvokerFilter);
        next ERRORHANDLING if !grep { $_ eq $OldInvoker } @{$InvokerFilter};

        # Rename invoker in error handling invoker filter as well to keep consistency.
        my @NewInvokerFilter = map { $_ eq $OldInvoker ? $Invoker : $_ } @{$InvokerFilter};
        $Param{WebserviceData}->{Config}->{Requester}->{ErrorHandling}->{$ErrorHandling}->{InvokerFilter}
            = \@NewInvokerFilter;
    }

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    # If the user would like to continue editing the invoker config, just redirect to the edit screen.
    my $RedirectURL;
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        $RedirectURL =
            'Action='
            . $Self->{Action}
            . ';Subaction=Change;WebserviceID='
            . $Param{WebserviceID}
            . ';Invoker='
            . $LayoutObject->LinkEncode($Invoker)
            . ';EventType='
            . $ParamObject->GetParam( Param => 'EventType' ) || ''
            . ';';
    }
    else {

        # otherwise return to overview
        $RedirectURL =
            'Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID='
            . $Param{WebserviceID}
            . ';';
    }

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $Invoker = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Invoker' );
    if ( !IsStringWithData($Invoker) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Invoker!',
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    if ( !IsHashRefWithData( $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine config for invoker $Invoker",
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    # Remove invoker from config.
    delete $Param{WebserviceData}->{Config}->{Requester}->{Invoker}->{$Invoker};
    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );

    return $Self->_JSONResponse( Success => $Success );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'Invoker',
        Value => $Param{Invoker}
    );

    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'ActionListDelete',
            Data => \%Param
        );
    }

    my %TemplateData = (
        InvokerType => $Param{InvokerConfig}->{Type},
        Description => $Param{InvokerConfig}->{Description},
        Invoker     => $Param{InvokerConfig}->{Invoker},
        OldInvoker  => $Param{Invoker},
    );

    my $Mappings = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module') || {};

    # Inbound mapping.
    my @MappingList = sort keys %{$Mappings};

    $TemplateData{MappingInboundStrg} = $LayoutObject->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingInbound',
        SelectedValue => $Param{InvokerConfig}->{MappingInbound}->{Type},
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'Modernize RegisterChange',
    );

    if (
        $Param{Action} eq 'Change'
        && $Param{InvokerConfig}->{MappingInbound}->{Type}
        && $Mappings->{ $Param{InvokerConfig}->{MappingInbound}->{Type} }->{ConfigDialog}
        )
    {

        $TemplateData{MappingInboundConfigDialog}
            = $Mappings->{ $Param{InvokerConfig}->{MappingInbound}->{Type} }->{ConfigDialog};
        $LayoutObject->Block(
            Name => 'MappingInboundConfigureButton',
            Data => {
                MappingInboundConfigDialog =>
                    $Mappings->{ $Param{InvokerConfig}->{MappingInbound}->{Type} }->{ConfigDialog},
                }
        );
    }

    # Outbound mapping.
    $TemplateData{MappingOutboundStrg} = $LayoutObject->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingOutbound',
        SelectedValue => $Param{InvokerConfig}->{MappingOutbound}->{Type},
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'Modernize RegisterChange',
    );

    if (
        $Param{Action} eq 'Change'
        && $Param{InvokerConfig}->{MappingOutbound}->{Type}
        && $Mappings->{ $Param{InvokerConfig}->{MappingOutbound}->{Type} }->{ConfigDialog}
        )
    {

        $TemplateData{MappingOutboundConfigDialog}
            = $Mappings->{ $Param{InvokerConfig}->{MappingOutbound}->{Type} }->{ConfigDialog};
        $LayoutObject->Block(
            Name => 'MappingOutboundConfigureButton',
            Data => {
                MappingOutboundConfigDialog =>
                    $Mappings->{ $Param{InvokerConfig}->{MappingOutbound}->{Type} }->{ConfigDialog},
            },
        );
    }

    # Store all invoker event triggers.
    my $InvokerEvents = $Param{InvokerConfig}->{Events};

    if ( !IsArrayRefWithData($InvokerEvents) ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList();

    my %InvokerEventLookup;

    # Create the event triggers table.
    my @Events;
    for my $Event ( @{$InvokerEvents} ) {

        # To store the events that are already assigned to this invoker
        #   the selects should look for this values and omit them from their lists.
        $InvokerEventLookup{ $Event->{Event} } = 1;

        # Set if is Synchronous or Asynchronous.
        my $Asynchronous = 'No';
        if ( $Event->{Asynchronous} ) {
            $Asynchronous = 'Yes'
        }

        # Set if event have a Condition.
        my $Condition = 'No';
        if ( IsHashRefWithData( $Event->{Condition} ) ) {
            $Condition = 'Yes'
        }

        # Set the event type ( event object like Article or Ticket) not currently in use
        #   but left if is needed in future.
        my $EventType;
        EVENTTYPE:
        for my $Type ( sort keys %RegisteredEvents ) {
            if ( grep { $_ eq $Event->{Event} } @{ $RegisteredEvents{$Type} || [] } ) {
                $EventType = $Type;
                last EVENTTYPE;
            }
        }

        push @Events, $Event->{Event};

        # Paint each event row in event triggers table.
        $LayoutObject->Block(
            Name => 'EventRow',
            Data => {
                WebserviceID => $Param{WebserviceID},
                Invoker      => $Param{Invoker},
                Event        => $Event->{Event},
                Type         => $EventType || '-',
                Asynchronous => $Asynchronous,
                Condition    => $Condition,
            },
        );
    }

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'Events',
        Value => \@Events
    );

    my @EventTypeList;

    my $SelectedEventType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'EventType' )
        || 'Ticket';

    # Create event trigger selectors (one for each type).
    TYPE:
    for my $Type ( sort keys %RegisteredEvents ) {

        # Refresh event list for each event type.
        my @EventList = grep { !$InvokerEventLookup{$_} } @{ $RegisteredEvents{$Type} || [] };

        # hide inactive event lists
        my $EventListHidden = '';
        if ( $Type ne $SelectedEventType ) {
            $EventListHidden = 'Hidden';
        }

        # Paint each selector.
        my $EventStrg = $LayoutObject->BuildSelection(
            Data         => \@EventList,
            Name         => $Type . 'Event',
            Sort         => 'AlphanumericValue',
            PossibleNone => 0,
            Title        => $LayoutObject->{LanguageObject}->Translate('Event'),
            Class        => 'EventList GenericInterfaceSpacing ' . $EventListHidden,
        );

        $LayoutObject->Block(
            Name => 'EventAdd',
            Data => {
                EventStrg => $EventStrg,
            },
        );

        push @EventTypeList, $Type;
    }

    # Create event type selector.
    $TemplateData{EventTypeStrg} = $LayoutObject->BuildSelection(
        Data          => \@EventTypeList,
        Name          => 'EventType',
        Sort          => 'AlphanumericValue',
        SelectedValue => $SelectedEventType,
        PossibleNone  => 0,
        Class         => '',
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => {
            %Param,
            %TemplateData,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _AddEvent {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(Invoker NewEvent)) {

        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    # Get config data of existing invoker.
    if ( !IsHashRefWithData( $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for invoker %s', $GetParam{Invoker} ),
        );
    }

    # Get current invoker config.
    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} };

    # Get Asynchronous Mode.
    $GetParam{AsynchronousMode} = $ParamObject->GetParam( Param => 'Asynchronous' ) || 0;

    # Add the new event to the list.
    if ( IsArrayRefWithData( $InvokerConfig->{Events} ) ) {
        push @{ $InvokerConfig->{Events} }, {
            Asynchronous => $GetParam{AsynchronousMode},
            Event        => $GetParam{NewEvent},
        };
    }
    else {
        @{ $InvokerConfig->{Events} } = (
            {
                Asynchronous => $GetParam{AsynchronousMode},
                Event        => $GetParam{NewEvent},
            },
        );
    }

    # Update configurations.
    $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $InvokerConfig;

    # Write new config to database.
    $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # Remember the selected event type.
    my $SelectedEventType = $ParamObject->GetParam( Param => 'EventType' );

    # Stay in edit mode.
    my $RedirectURL = "Action=$Self->{Action};Subaction=Change;WebserviceID=$WebserviceID;"
        . "Invoker=$GetParam{Invoker};EventType=$SelectedEventType";

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteEvent {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    my $WebserviceData = $Param{WebserviceData};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Invoker EventName)) {

        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    # Get config data of existing invoker.
    if ( !IsHashRefWithData( $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for invoker %s', $GetParam{Invoker} ),
        );
    }

    # get current invoker config.
    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} };

    # delete selected event from list of events
    if ( IsArrayRefWithData( $InvokerConfig->{Events} ) ) {
        @{ $InvokerConfig->{Events} } = grep { $_->{Event} ne $GetParam{EventName} } @{ $InvokerConfig->{Events} };
    }

    # Update configuration.
    $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $InvokerConfig;

    # Write new config to database.
    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # Send JSON response.
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

# =head2 _InvokerTypeCheck()
#
# checks if a given InvokerType is registered in the system.
#
# =cut

sub _InvokerTypeCheck {
    my ( $Self, %Param ) = @_;

    return if !$Param{InvokerType};

    my $Invokers = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Invoker::Module');
    return if !IsHashRefWithData($Invokers);

    return IsHashRefWithData( $Invokers->{ $Param{InvokerType} } ) ? 1 : undef;
}

# =head2 _MappingTypeCheck()
#
# checks if a given MappingType is registered in the system.
#
# =cut

sub _MappingTypeCheck {
    my ( $Self, %Param ) = @_;

    return if !$Param{MappingType};

    my $Mappings = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module');
    return if !IsHashRefWithData($Mappings);

    return IsHashRefWithData( $Mappings->{ $Param{MappingType} } ) ? 1 : undef;
}

sub _RequestParamsGet {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;
    for my $StringParam (
        qw(
        Description
        )
        )
    {
        $GetParam{$StringParam} = $ParamObject->GetParam( Param => $StringParam ) // '';
    }

    # Get, validate and transfer mapping params.
    MAPPINGPARAM:
    for my $MappingParam (qw(MappingInbound MappingOutbound)) {
        my $Mapping = $ParamObject->GetParam( Param => $MappingParam );
        next MAPPINGPARAM if !$Mapping;
        next MAPPINGPARAM if !$Self->_MappingTypeCheck( MappingType => $Mapping );
        $GetParam{$MappingParam} = { Type => $Mapping };
    }

    return \%GetParam;
}

sub _JSONResponse {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Param{Success} // 0,
        },
    );

    # Send JSON response.
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
