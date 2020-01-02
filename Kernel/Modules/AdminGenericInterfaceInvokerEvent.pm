# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceInvokerEvent;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{DeletedString} = '_GenericInterface_Invoker_Event_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject      = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' );
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable("Need WebserviceID!"),
        );
    }

    my $Invoker = $ParamObject->GetParam( Param => 'Invoker' );
    if ( !$Invoker ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable("Need Invoker!"),
        );
    }

    my $Event = $ParamObject->GetParam( Param => 'Event' );
    if ( !$Event ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable("Need Event!"),
        );
    }

    # Get configured Invoker registrations.
    my $InvokerModules = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Invoker::Module');

    # Check for valid Invoker registration.
    if ( !IsHashRefWithData($InvokerModules) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not get registered modules for Invoker'),
        );
    }

    # Get web service configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    if ( !IsHashRefWithData( $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker} ) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not determine config for invoker %s', $Invoker ),
        );
    }

    my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker};
    my $InvokerType   = $InvokerConfig->{Type};

    # Check for valid InvokerType backend.
    if ( !$InvokerType ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Could not get backend for Invoker %s', $Invoker ),
        );
    }

    # Get the configuration dialog for the event.
    my $InvokerEventFrontendModule = $InvokerModules->{$InvokerType}->{'EventEditDialog'}
        || 'AdminGenericInterfaceInvokerEvent';

    # Get the configuration dialog for the Invoker.
    my $InvokerTypeFrontendModule = $InvokerModules->{$InvokerType}->{'ConfigDialog'};

    my $WebserviceName = $WebserviceData->{Name};
    my @InvokerEvents  = @{ $InvokerConfig->{Events} };

    # Get list of all registered events.
    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList();

    # Prepare details.
    my $EventType;
    my $Condition;
    my $Asynchronous;

    # Loop trough invoker events and compare them with current event.
    INVOKEREVENT:
    for my $InvokerEvent (@InvokerEvents) {

        next INVOKEREVENT if $Event ne $InvokerEvent->{Event};

        # Set the event type (event object like Article or Ticket) and event condition
        EVENTTYPE:
        for my $Type ( sort keys %RegisteredEvents ) {

            if ( grep { $_ eq $InvokerEvent->{Event} } @{ $RegisteredEvents{$Type} || [] } ) {
                $EventType    = $Type;
                $Condition    = $InvokerEvent->{Condition};
                $Asynchronous = $InvokerEvent->{Asynchronous};

                last EVENTTYPE;
            }
        }

        last INVOKEREVENT;
    }

    # Check if we found a valid event
    if ( !$EventType ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'The event %s is not valid.', $Event ),
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'InvokerEvent',
        Value => {
            WebserviceID              => $WebserviceID,
            Invoker                   => $Invoker,
            Event                     => $Event,
            InvokerTypeFrontendModule => $InvokerTypeFrontendModule,
        },
    );

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        return $Self->_ShowEdit(
            %Param,
            WebserviceID               => $WebserviceID,
            WebserviceName             => $WebserviceName,
            Invoker                    => $Invoker,
            InvokerType                => $InvokerType,
            InvokerTypeFrontendModule  => $InvokerTypeFrontendModule,
            InvokerEventFrontendModule => $InvokerEventFrontendModule,
            Event                      => $Event,
            EventType                  => $EventType,
            Condition                  => $Condition,
            Asynchronous               => $Asynchronous,
            Action                     => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # if there is an error return to edit screen
        if ( $GetParam->{Error} ) {
            return $Self->_ShowEdit(
                %Param,
                WebserviceID               => $WebserviceID,
                WebserviceName             => $WebserviceName,
                Invoker                    => $Invoker,
                InvokerType                => $InvokerType,
                InvokerTypeFrontendModule  => $InvokerTypeFrontendModule,
                InvokerEventFrontendModule => $InvokerEventFrontendModule,
                Event                      => $Event,
                EventType                  => $EventType,
                Condition                  => $Condition,
                Asynchronous               => $Asynchronous,
                Action                     => 'Change',
            );
        }

        my %NewCondition = (
            Condition => $GetParam->{Config},
        );

        # This loop goes through the Array of Hashes of
        #   @{ $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker}->{Events} }.
        #
        # If it stumbles upon the array containing the HashKeys "Event" and this Key equals
        #   $Event, it takes the Original Hash and extends the keys by the keys of %NewCondition.
        #
        # If it doesn't match $Event it takes the original unchanged HashRef
        #  (e.g. just extending one single hash of all existing hashes inside the Events Array).
        my @NewEventsArray;
        for my $EventsHashRef ( @{ $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker}->{Events} } ) {
            if ( $EventsHashRef->{Event} && $EventsHashRef->{Event} eq $Event ) {
                push @NewEventsArray, {
                    %{$EventsHashRef},
                    %NewCondition,
                    Asynchronous => $GetParam->{Asynchronous},
                };
            }
            else {
                push @NewEventsArray, $EventsHashRef;
            }
        }
        $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker}->{Events} = \@NewEventsArray;

        # Otherwise save configuration and return to overview screen.
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # Check for successful web service update.
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not update configuration data for WebserviceID %s', $WebserviceID ),
            );
        }

        # If the user would like to finish editing the filter config, just redirect to the invoker edit screen.
        if (
            !IsInteger( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) )
            || $ParamObject->GetParam( Param => 'ContinueAfterSave' ) != 1
            )
        {
            my $RedirectURL = "Action=$InvokerTypeFrontendModule;Subaction=Change;Invoker=$Invoker;"
                . "WebserviceID=$WebserviceID;";

            return $LayoutObject->Redirect(
                OP => $RedirectURL,
            );
        }

        # Recreate structure for edit.
        $Condition = $NewCondition{Condition};

        $Asynchronous = $GetParam->{Asynchronous};

        # Check if stay on invoker events screen or redirect to previous screen.
        return $Self->_ShowEdit(
            %Param,
            WebserviceID               => $WebserviceID,
            WebserviceName             => $WebserviceName,
            Invoker                    => $Invoker,
            InvokerType                => $InvokerType,
            InvokerTypeFrontendModule  => $InvokerTypeFrontendModule,
            InvokerEventFrontendModule => $InvokerEventFrontendModule,
            Event                      => $Event,
            EventType                  => $EventType,
            Condition                  => $Condition,
            Asynchronous               => $Asynchronous,
            Action                     => 'Change',
        );
    }

    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        EVENTCONFIG:
        for my $EventConfig ( @{ $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker}->{Events} } ) {
            next EVENTCONFIG if $EventConfig->{Event} ne $Event;

            delete $EventConfig->{Condition};
            last EVENTCONFIG;
        }

        # Otherwise save configuration and return to overview screen.
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
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

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('This sub-action is not valid'),
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ConditionData = $Param{Condition} || {};

    # Set action for go back button
    $Param{LowerCaseActionType} = lc 'Invoker';

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my %Error;
    if ( defined $Param{WebserviceData}->{Error} ) {
        %Error = %{ $Param{WebserviceData}->{Error} };
    }
    $Param{DeletedString} = $Self->{DeletedString};

    $Param{FreshConditionLinking} = $LayoutObject->BuildSelection(
        Data => {
            'and' => Translatable('and'),
            'or'  => Translatable('or'),
            'xor' => Translatable('xor'),
        },
        Name        => "ConditionLinking[_INDEX_]",
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize W50pc',
    );

    $Param{FreshConditionFieldType} = $LayoutObject->BuildSelection(
        Data => {
            'String' => Translatable('String'),
            'Regexp' => Translatable('Regexp'),
            'Module' => Translatable('Validation Module'),
        },
        SelectedID  => 'String',
        Name        => "ConditionFieldType[_INDEX_][_FIELDINDEX_]",
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize',
    );

    if (
        defined $Param{Action}
        && $Param{Action} eq 'Change'
        && IsHashRefWithData( $Param{Condition} )
        && IsHashRefWithData( $Param{Condition}->{Condition} )
        && IsStringWithData( $Param{Condition}->{ConditionLinking} )
        )
    {

        $Param{OverallConditionLinking} = $LayoutObject->BuildSelection(
            Data => {
                'and' => Translatable('and'),
                'or'  => Translatable('or'),
                'xor' => Translatable('xor'),
            },
            Name        => 'OverallConditionLinking',
            ID          => 'OverallConditionLinking',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'Modernize',
            SelectedID  => $ConditionData->{ConditionLinking},
        );

        my @Conditions = sort { int $a <=> int $b } keys %{ $ConditionData->{Condition} };

        for my $Condition (@Conditions) {

            my %ConditionData = %{ $ConditionData->{Condition}->{$Condition} };

            my $ConditionLinking = $LayoutObject->BuildSelection(
                Data => {
                    'and' => Translatable('and'),
                    'or'  => Translatable('or'),
                    'xor' => Translatable('xor'),
                },
                Name        => "ConditionLinking[$Condition]",
                Sort        => 'AlphanumericKey',
                Translation => 1,
                Class       => 'Modernize',
                SelectedID  => $ConditionData{Type},
            );

            $LayoutObject->Block(
                Name => 'ConditionItemEditRow',
                Data => {
                    ConditionLinking => $ConditionLinking,
                    Index            => $Condition,
                },
            );

            my @Fields = sort keys %{ $ConditionData{Fields} };
            for my $Field (@Fields) {

                my %FieldData          = %{ $ConditionData{Fields}->{$Field} };
                my $ConditionFieldType = $LayoutObject->BuildSelection(
                    Data => {
                        'String' => Translatable('String'),
                        'Regexp' => Translatable('Regexp'),
                        'Module' => Translatable('Validation Module'),
                    },
                    Name        => "ConditionFieldType[$Condition][$Field]",
                    Sort        => 'AlphanumericKey',
                    Translation => 1,
                    SelectedID  => $FieldData{Type},
                    Class       => 'Modernize',
                );

                # Show fields.
                $LayoutObject->Block(
                    Name => "ConditionItemEditRowField",
                    Data => {
                        Index              => $Condition,
                        FieldIndex         => $Field,
                        ConditionFieldType => $ConditionFieldType,
                        %FieldData,
                    },
                );
            }
        }
    }
    else {

        $Param{OverallConditionLinking} = $LayoutObject->BuildSelection(
            Data => {
                'and' => Translatable('and'),
                'or'  => Translatable('or'),
                'xor' => Translatable('xor'),
            },
            Name        => 'OverallConditionLinking',
            ID          => 'OverallConditionLinking',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'Modernize W50pc',
        );

        $Param{ConditionLinking} = $LayoutObject->BuildSelection(
            Data => {
                'and' => Translatable('and'),
                'or'  => Translatable('or'),
                'xor' => Translatable('xor'),
            },
            Name        => 'ConditionLinking[_INDEX_]',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'Modernize W50pc',
        );

        $Param{ConditionFieldType} = $LayoutObject->BuildSelection(
            Data => {
                'String' => Translatable('String'),
                'Regexp' => Translatable('Regexp'),
                'Module' => Translatable('Validation Module'),
            },
            Name        => 'ConditionFieldType[_INDEX_][_FIELDINDEX_]',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            SelectedID  => 'String',
            Class       => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'ConditionItemInitRow',
            Data => {
                %Param,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => $Param{InvokerEventFrontendModule},
        Data         => {
            %Param,
            %{$ConditionData},
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $GetParam;

    # Get parameters from web browser.
    $GetParam->{Name}            = $ParamObject->GetParam( Param => 'Name' ) || '';
    $GetParam->{ConditionConfig} = $ParamObject->GetParam( Param => 'ConditionConfig' )
        || '';

    my $Config = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $GetParam->{ConditionConfig}
    );
    $GetParam->{Config}                     = {};
    $GetParam->{Config}->{Condition}        = $Config;
    $GetParam->{Config}->{ConditionLinking} = $ParamObject->GetParam( Param => 'OverallConditionLinking' ) || '';

    $GetParam->{Asynchronous} = $ParamObject->GetParam( Param => 'Asynchronous' ) || '';

    return $GetParam;
}

1;
