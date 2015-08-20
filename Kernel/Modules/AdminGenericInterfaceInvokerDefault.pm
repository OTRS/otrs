# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceInvokerDefault;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $WebserviceID
        = int( $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WebserviceID' ) || 0 );
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need WebserviceID!",
        );
    }

    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $WebserviceID,
    );

    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not get data for WebserviceID $WebserviceID",
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

        # challenge token check for write action
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

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddEvent' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddEvent(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteEvent' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteEvent(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }

}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my $InvokerType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'InvokerType' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$InvokerType ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need InvokerType",
        );
    }
    if ( !$Self->_InvokerTypeCheck( InvokerType => $InvokerType ) ) {
        return $LayoutObject->ErrorScreen(
            Message => "Invoker $InvokerType is not registered",
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Mode           => 'Add',
        WebserviceID   => $WebserviceID,
        WebserviceData => $WebserviceData,
        WebserviceName => $WebserviceData->{Name},
        InvokerType    => $InvokerType,
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my %Errors;
    my %GetParam;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Invoker InvokerType)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' } = 'ServerError';
        }
    }

    # name already exists, bail out
    if ( exists $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ) {
        $Errors{InvokerServerError} = 'ServerError';
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # uncorrectable errors
    if ( !$GetParam{InvokerType} ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need InvokerType",
        );
    }
    if ( !$Self->_InvokerTypeCheck( InvokerType => $GetParam{InvokerType} ) ) {
        return $LayoutObject->ErrorScreen(
            Message => "InvokerType $GetParam{InvokerType} is not registered",
        );
    }

    # validation errors
    if (%Errors) {

        # get the description from the web request to send it back again to the screen
        my $InvokerConfig;
        $InvokerConfig->{Description} = $ParamObject->GetParam( Param => 'Description' )
            || '';

        return $Self->_ShowScreen(
            %Param,
            %GetParam,
            %Errors,
            Mode           => 'Add',
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
            WebserviceName => $WebserviceData->{Name},
            InvokerType    => $GetParam{InvokerType},
            InvokerConfig  => $InvokerConfig,
        );
    }

    my $Config = {
        Type        => $GetParam{InvokerType},
        Description => $ParamObject->GetParam( Param => 'Description' ) || '',
    };

    my $MappingInbound = $ParamObject->GetParam( Param => 'MappingInbound' );
    $MappingInbound = $Self->_MappingTypeCheck( MappingType => $MappingInbound ) ? $MappingInbound : '';

    if ($MappingInbound) {
        $Config->{MappingInbound} = {
            Type => $MappingInbound,
        };
    }

    my $MappingOutbound = $ParamObject->GetParam( Param => 'MappingOutbound' );
    $MappingOutbound = $Self->_MappingTypeCheck( MappingType => $MappingOutbound ) ? $MappingOutbound : '';

    if ($MappingOutbound) {
        $Config->{MappingOutbound} = {
            Type => $MappingOutbound,
        };
    }

    # check if Invoker already exists
    if ( !$WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ) {
        $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $Config;

        $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
            %{$WebserviceData},
            UserID => $Self->{UserID},
        );
    }

    my $RedirectURL = "Action=AdminGenericInterfaceInvokerDefault;Subaction=Change;WebserviceID=$WebserviceID;";
    $RedirectURL .= 'Invoker=' . $LayoutObject->LinkEncode( $GetParam{Invoker} ) . ';';

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my $Invoker = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Invoker' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Invoker ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need Invoker",
        );
    }

    if (
        ref $WebserviceData->{Config} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker} ne 'HASH'
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => "Could not determine config for invoker $Invoker",
        );
    }

    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker};

    return $Self->_ShowScreen(
        %Param,
        Mode            => 'Change',
        WebserviceID    => $WebserviceID,
        WebserviceData  => $WebserviceData,
        WebserviceName  => $WebserviceData->{Name},
        Invoker         => $Invoker,
        InvokerConfig   => $InvokerConfig,
        MappingInbound  => $InvokerConfig->{MappingInbound}->{Type},
        MappingOutbound => $InvokerConfig->{MappingOutbound}->{Type},
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    my %Errors;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(Invoker OldInvoker)) {

        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # Get config data of existing invoker.
    if (
        ref $WebserviceData->{Config} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{OldInvoker} } ne
        'HASH'
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => "Could not determine config for invoker $GetParam{OldInvoker}",
        );
    }

    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{OldInvoker} };

    # Invoker was renamed, avoid conflicts
    if ( $GetParam{OldInvoker} ne $GetParam{Invoker} ) {

        # New name already exists, bail out
        if ( exists $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ) {
            $Errors{InvokerServerError} = 'ServerError';
        }

        # OK, remove old Invoker. New one will be added below.
        if ( !%Errors ) {
            delete $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{OldInvoker} };
        }
    }

    if (%Errors) {

        return $Self->_ShowScreen(
            %Param,
            %GetParam,
            %Errors,
            Mode            => 'Change',
            WebserviceID    => $WebserviceID,
            WebserviceData  => $WebserviceData,
            WebserviceName  => $WebserviceData->{Name},
            Invoker         => $GetParam{OldInvoker},
            InvokerConfig   => $InvokerConfig,
            MappingInbound  => $InvokerConfig->{MappingInbound}->{Type},
            MappingOutbound => $InvokerConfig->{MappingOutbound}->{Type},
        );
    }

    # Now handle mappings. If mapping types were not changed, keep the mapping configuration.
    my $MappingInbound = $ParamObject->GetParam( Param => 'MappingInbound' );
    $MappingInbound = $Self->_MappingTypeCheck( MappingType => $MappingInbound ) ? $MappingInbound : '';

    # No inbound mapping set, make sure it is not present in the configuration.
    if ( !$MappingInbound ) {
        delete $InvokerConfig->{MappingInbound};
    }

    # Inbound mapping changed, initialize with empty config.
    my $ConfigMappingInbound = $InvokerConfig->{MappingInbound}->{Type} || '';
    if ( $MappingInbound && $MappingInbound ne $ConfigMappingInbound ) {
        $InvokerConfig->{MappingInbound} = {
            Type => $MappingInbound,
        };
    }

    my $MappingOutbound = $ParamObject->GetParam( Param => 'MappingOutbound' );
    $MappingOutbound = $Self->_MappingTypeCheck( MappingType => $MappingOutbound ) ? $MappingOutbound : '';

    # No outbound mapping set, make sure it is not present in the configuration.
    if ( !$MappingOutbound ) {
        delete $InvokerConfig->{MappingOutbound};
    }

    # Outbound mapping changed, initialize with empty config.
    my $ConfigMappingOutbound = $InvokerConfig->{MappingOutbound}->{Type} || '';
    if ( $MappingOutbound && $MappingOutbound ne $ConfigMappingOutbound ) {
        $InvokerConfig->{MappingOutbound} = {
            Type => $MappingOutbound,
        };
    }

    $InvokerConfig->{Description} = $ParamObject->GetParam( Param => 'Description' )
        || '';

    # Update invoker config.
    $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $InvokerConfig;

    # Write new config to database.
    $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # remember the selected event type
    my $SelectedEventType = $ParamObject->GetParam( Param => 'EventType' );

    # Save button: stay in edit mode.
    my $RedirectURL = "Action=AdminGenericInterfaceInvokerDefault;Subaction=Change;WebserviceID=$WebserviceID;"
        . "Invoker=$GetParam{Invoker};EventType=$SelectedEventType";

    # Save and finish button: go to web service.
    if ( $ParamObject->GetParam( Param => 'ReturnToWebservice' ) ) {
        $RedirectURL = "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;";

    }

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceData = $Param{WebserviceData};

    my $Invoker = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Invoker' );

    if ( !$Invoker ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no Invoker',
        );
    }

    my $Success;

    # Check if Invoker exists and delete it.
    if ( $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker} ) {
        delete $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker};

        $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
            %{$WebserviceData},
            UserID => $Self->{UserID},
        );
    }

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $LayoutObject->Block(
        Name => 'Title' . $Param{Mode},
        Data => \%Param
    );
    $LayoutObject->Block(
        Name => 'Navigation' . $Param{Mode},
        Data => \%Param
    );

    my %TemplateData;

    if ( $Param{Mode} eq 'Add' ) {
        $TemplateData{InvokerType} = $Param{InvokerType};

    }
    elsif ( $Param{Mode} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'ActionListDelete',
            Data => \%Param
        );

        $LayoutObject->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );

        $TemplateData{InvokerType} = $Param{InvokerConfig}->{Type};
    }

    $TemplateData{Description} = $Param{InvokerConfig}->{Description};

    my $Mappings = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module') || {};

    # Inbound mapping
    my @MappingList = sort keys %{$Mappings};

    my $MappingInbound = $Self->_MappingTypeCheck( MappingType => $Param{MappingInbound} )
        ? $Param{MappingInbound}
        : '';

    $TemplateData{MappingInboundStrg} = $LayoutObject->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingInbound',
        SelectedValue => $MappingInbound,
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'Modernize RegisterChange',
    );

    if ($MappingInbound) {
        $TemplateData{MappingInboundConfigDialog} = $Mappings->{$MappingInbound}->{ConfigDialog};
    }

    if ( $TemplateData{MappingInboundConfigDialog} && $Param{Mode} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'MappingInboundConfigureButton',
            Data => {
                %Param,
                %TemplateData,
                }
        );
    }

    # Outbound mapping
    my $MappingOutbound = $Self->_MappingTypeCheck( MappingType => $Param{MappingOutbound} )
        ? $Param{MappingOutbound}
        : '';

    $TemplateData{MappingOutboundStrg} = $LayoutObject->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingOutbound',
        SelectedValue => $MappingOutbound,
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'Modernize RegisterChange',
    );

    if ($MappingOutbound) {
        $TemplateData{MappingOutboundConfigDialog} = $Mappings->{$MappingOutbound}->{ConfigDialog};
    }

    if ( $TemplateData{MappingOutboundConfigDialog} && $Param{Mode} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'MappingOutboundConfigureButton',
            Data => {
                %Param,
                %TemplateData,
            },
        );
    }

    # store all invoker event triggers
    my $InvokerEvents = $Param{InvokerConfig}->{Events};

    if ( !IsArrayRefWithData($InvokerEvents) ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList();

    my %InvokerEventLookup;

    # create the event triggers table
    for my $Event ( @{$InvokerEvents} ) {

        # to store the events that are already assigned to this invoker
        # the selects should look for this values and omit them from their lists
        $InvokerEventLookup{ $Event->{Event} } = 1;

        # set if is Synchronous or Asynchronous
        my $Asynchronous = 'No';
        if ( $Event->{Asynchronous} ) {
            $Asynchronous = 'Yes'
        }

        # set the event type ( event object like Article or Ticket) not currently in use
        # but left if is needed in future
        my $EventType;
        EVENTTYPE:
        for my $Type ( sort keys %RegisteredEvents ) {
            if ( grep { $_ eq $Event->{Event} } @{ $RegisteredEvents{$Type} || [] } ) {
                $EventType = $Type;
                last EVENTTYPE;
            }
        }

        # paint each event row in event triggers table
        $LayoutObject->Block(
            Name => 'EventRow',
            Data => {
                Event        => $Event->{Event},
                Type         => $EventType || '-',
                Asynchronous => $Asynchronous,
            },
        );
    }

    my @EventTypeList;

    my $SelectedEventType
        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'EventType' ) || 'Ticket';

    # create event trigger selectors (one for each type)
    TYPE:
    for my $Type ( sort keys %RegisteredEvents ) {

        # refresh event list for each event type
        my @EventList;

        EVENT:
        for my $Event ( @{ $RegisteredEvents{$Type} || [] } ) {
            next EVENT if $InvokerEventLookup{$Event};    # only add events that are not used yet
            push @EventList, $Event;
        }

        # hide inactive event lists
        my $EventListHidden = '';
        if ( $Type ne $SelectedEventType ) {
            $EventListHidden = 'Hidden';
        }

        # paint each selector
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

    # create event type selector
    $TemplateData{EventTypeStrg} = $LayoutObject->BuildSelection(
        Data          => \@EventTypeList,
        Name          => 'EventType',
        Sort          => 'AlphanumericValue',
        SelectedValue => $SelectedEventType,
        PossibleNone  => 0,
        Class         => '',
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceInvokerDefault',
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

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(Invoker NewEvent)) {

        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # Get config data of existing invoker.
    if (
        ref $WebserviceData->{Config} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ne
        'HASH'
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => "Could not determine config for invoker $GetParam{Invoker}",
        );
    }

    # get current invoker config
    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} };

    # get Asynchronous Mode
    $GetParam{AsynchronousMode} = $ParamObject->GetParam( Param => 'Asynchronous' ) || 0;

    my @Events;

    # store current events associated with the invoker
    if ( IsArrayRefWithData( $InvokerConfig->{Events} ) ) {
        @Events = @{ $InvokerConfig->{Events} };
    }

    # add the new event to the list
    push @Events, {
        Asynchronous => $GetParam{AsynchronousMode},
        Event        => $GetParam{NewEvent},
    };

    # update configurations
    $InvokerConfig->{Events} = \@Events;
    $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $InvokerConfig;

    # Write new config to database.
    $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # remember the selected event type
    my $SelectedEventType = $ParamObject->GetParam( Param => 'EventType' );

    # stay in edit mode.
    my $RedirectURL = "Action=AdminGenericInterfaceInvokerDefault;Subaction=Change;WebserviceID=$WebserviceID;"
        . "Invoker=$GetParam{Invoker};EventType=$SelectedEventType";

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteEvent {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Invoker EventName)) {

        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # Get config data of existing invoker.
    if (
        ref $WebserviceData->{Config} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker} ne 'HASH'
        || ref $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } ne
        'HASH'
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => "Could not determine config for invoker $GetParam{Invoker}",
        );
    }

    # get current invoker config
    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} };

    my @Events;

    # store current events associated with the invoker
    if ( IsArrayRefWithData( $InvokerConfig->{Events} ) ) {
        @Events = @{ $InvokerConfig->{Events} };
    }

    my @UpdatedEvents;

    # delete event from the list
    # this can also be done using "delete" Perl function and an index
    # instead of creating a new array
    EVENT:
    for my $Event (@Events) {
        next EVENT if $Event->{Event} eq $GetParam{EventName};
        push @UpdatedEvents, $Event;
    }

    # update configuration
    $InvokerConfig->{Events} = \@UpdatedEvents;
    $WebserviceData->{Config}->{Requester}->{Invoker}->{ $GetParam{Invoker} } = $InvokerConfig;

    my $Success;

    # Write new config to database.
    $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

=item _InvokerTypeCheck()

checks if a given InvokerType is registered in the system.

=cut

sub _InvokerTypeCheck {
    my ( $Self, %Param ) = @_;

    return 0 if !$Param{InvokerType};

    my $Invokers = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Invoker::Module');
    return 0 if ref $Invokers ne 'HASH';

    return ref $Invokers->{ $Param{InvokerType} } eq 'HASH' ? 1 : 0;
}

=item _MappingTypeCheck()

checks if a given MappingType is registered in the system.

=cut

sub _MappingTypeCheck {
    my ( $Self, %Param ) = @_;

    return 0 if !$Param{MappingType};

    my $Mappings = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module');
    return 0 if ref $Mappings ne 'HASH';

    return ref $Mappings->{ $Param{MappingType} } eq 'HASH' ? 1 : 0;
}

1;
