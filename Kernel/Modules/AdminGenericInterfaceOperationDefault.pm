# --
# Kernel/Modules/AdminGenericInterfaceOperationDefault.pm - provides a log view for admins
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceOperationDefault;

use strict;
use warnings;

use Kernel::System::GenericInterface::Webservice;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceID = int( $Self->{ParamObject}->GetParam( Param => 'WebserviceID' ) || 0 );
    if ( !$WebserviceID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need WebserviceID!",
        );
    }

    my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

    if ( !IsHashRefWithData($WebserviceData) ) {
        return $Self->{LayoutObject}->ErrorScreen(
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_DeleteAction(
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

    my $OperationType = $Self->{ParamObject}->GetParam( Param => 'OperationType' );

    if ( !$OperationType ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need OperationType",
        );
    }
    if ( !$Self->_OperationTypeCheck( OperationType => $OperationType ) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Operation $OperationType is not registered",
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Mode           => 'Add',
        WebserviceID   => $WebserviceID,
        WebserviceData => $WebserviceData,
        WebserviceName => $WebserviceData->{Name},
        OperationType  => $OperationType,
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my %Errors;
    my %GetParam;

    for my $Needed (qw(Operation OperationType)) {
        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' } = 'ServerError';
        }
    }

    # name already exists, bail out
    if ( exists $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{Operation} } ) {
        $Errors{OperationServerError} = 'ServerError';
    }

    # uncorrectable errors
    if ( !$GetParam{OperationType} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need OperationType",
        );
    }
    if ( !$Self->_OperationTypeCheck( OperationType => $GetParam{OperationType} ) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "OperationType $GetParam{OperationType} is not registered",
        );
    }

    # validation errors
    if (%Errors) {

        # get the description from the web request to send it back again to the screen
        my $OperationConfig;
        $OperationConfig->{Description} = $Self->{ParamObject}->GetParam( Param => 'Description' )
            || '';

        return $Self->_ShowScreen(
            %Param,
            %GetParam,
            %Errors,
            Mode            => 'Add',
            WebserviceID    => $WebserviceID,
            WebserviceData  => $WebserviceData,
            WebserviceName  => $WebserviceData->{Name},
            OperationType   => $GetParam{OperationType},
            OperationConfig => $OperationConfig,
        );
    }

    my $Config = {
        Type => $GetParam{OperationType},
        Description => $Self->{ParamObject}->GetParam( Param => 'Description' ) || '',
    };

    my $MappingInbound = $Self->{ParamObject}->GetParam( Param => 'MappingInbound' );
    $MappingInbound
        = $Self->_MappingTypeCheck( MappingType => $MappingInbound ) ? $MappingInbound : '';

    if ($MappingInbound) {
        $Config->{MappingInbound} = {
            Type => $MappingInbound,
        };
    }

    my $MappingOutbound = $Self->{ParamObject}->GetParam( Param => 'MappingOutbound' );
    $MappingOutbound
        = $Self->_MappingTypeCheck( MappingType => $MappingOutbound ) ? $MappingOutbound : '';

    if ($MappingOutbound) {
        $Config->{MappingOutbound} = {
            Type => $MappingOutbound,
        };
    }

    # check if Operation already exists
    if ( !$WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{Operation} } ) {
        $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{Operation} } = $Config;

        $Self->{WebserviceObject}->WebserviceUpdate(
            %{$WebserviceData},
            UserID => $Self->{UserID},
        );
    }

    my $RedirectURL
        = "Action=AdminGenericInterfaceOperationDefault;Subaction=Change;WebserviceID=$WebserviceID;";
    $RedirectURL
        .= 'Operation=' . $Self->{LayoutObject}->LinkEncode( $GetParam{Operation} ) . ';';

    return $Self->{LayoutObject}->Redirect(
        OP => $RedirectURL,
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    my $Operation = $Self->{ParamObject}->GetParam( Param => 'Operation' );

    if ( !$Operation ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need Operation",
        );
    }

    if (
        ref $WebserviceData->{Config}                                           ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}                            ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}->{Operation}               ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}->{Operation}->{$Operation} ne 'HASH'
        )
    {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not determine config for operation $Operation",
        );
    }

    my $OperationConfig = $WebserviceData->{Config}->{Provider}->{Operation}->{$Operation};

    return $Self->_ShowScreen(
        %Param,
        Mode            => 'Change',
        WebserviceID    => $WebserviceID,
        WebserviceData  => $WebserviceData,
        WebserviceName  => $WebserviceData->{Name},
        Operation       => $Operation,
        OperationConfig => $OperationConfig,
        MappingInbound  => $OperationConfig->{MappingInbound}->{Type},
        MappingOutbound => $OperationConfig->{MappingOutbound}->{Type},
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    my %Errors;

    my $WebserviceID   = $Param{WebserviceID};
    my $WebserviceData = $Param{WebserviceData};

    for my $Needed (qw(Operation OldOperation)) {

        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );

        if ( !$GetParam{$Needed} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # Get config data of existing operation.
    if (
        ref $WebserviceData->{Config}                             ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}              ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}->{Operation} ne 'HASH'
        || ref $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{OldOperation} } ne
        'HASH'
        )
    {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not determine config for operation $GetParam{OldOperation}",
        );
    }

    my $OperationConfig
        = $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{OldOperation} };

    # Operation was renamed, avoid conflicts
    if ( $GetParam{OldOperation} ne $GetParam{Operation} ) {

        # New name already exists, bail out
        if ( exists $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{Operation} } ) {
            $Errors{OperationServerError} = 'ServerError';
        }

        # Ok, remove old Operation. New one will be added below.
        if ( !%Errors ) {
            delete $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{OldOperation} };
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
            Operation       => $GetParam{OldOperation},
            OperationConfig => $OperationConfig,
            MappingInbound  => $OperationConfig->{MappingInbound}->{Type},
            MappingOutbound => $OperationConfig->{MappingOutbound}->{Type},
        );
    }

    # Now handle mappings. If mapping types were not changed, keep the mapping configuration.
    my $MappingInbound = $Self->{ParamObject}->GetParam( Param => 'MappingInbound' );
    $MappingInbound
        = $Self->_MappingTypeCheck( MappingType => $MappingInbound ) ? $MappingInbound : '';

    # No inbound mapping set, make sure it is not present in the configuration.
    if ( !$MappingInbound ) {
        delete $OperationConfig->{MappingInbound};
    }

    # Inbound mapping changed, initialize with empty config.
    my $ConfigMappingInboud = $OperationConfig->{MappingInbound}->{Type} || '';
    if ( $MappingInbound && $MappingInbound ne $ConfigMappingInboud ) {
        $OperationConfig->{MappingInbound} = {
            Type => $MappingInbound,
        };
    }

    my $MappingOutbound = $Self->{ParamObject}->GetParam( Param => 'MappingOutbound' );
    $MappingOutbound
        = $Self->_MappingTypeCheck( MappingType => $MappingOutbound ) ? $MappingOutbound : '';

    # No outbound mapping set, make sure it is not present in the configuration.
    if ( !$MappingOutbound ) {
        delete $OperationConfig->{MappingOutbound};
    }

    # Outbound mapping changed, initialize with empty config.
    my $ConfigMappingOutboud = $OperationConfig->{MappingOutbound}->{Type} || '';
    if ( $MappingOutbound && $MappingOutbound ne $ConfigMappingOutboud ) {
        $OperationConfig->{MappingOutbound} = {
            Type => $MappingOutbound,
        };
    }

    $OperationConfig->{Description} = $Self->{ParamObject}->GetParam( Param => 'Description' )
        || '';

    # Update operation config.
    $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam{Operation} } = $OperationConfig;

    # Write new config to database.
    $Self->{WebserviceObject}->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );

    # Save button: stay in edit mode.
    my $RedirectURL
        = "Action=AdminGenericInterfaceOperationDefault;Subaction=Change;WebserviceID=$WebserviceID;Operation=$GetParam{Operation}";

    # Save and finish button: go to Webservice.
    if ( $Self->{ParamObject}->GetParam( Param => 'ReturnToWebservice' ) ) {
        $RedirectURL
            = "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;";

    }

    return $Self->{LayoutObject}->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceData = $Param{WebserviceData};

    my $Operation = $Self->{ParamObject}->GetParam( Param => 'Operation' );

    if ( !$Operation ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no Operation',
        );
    }

    my $Success;

    # Check if Operation exists and delete it.
    if ( $WebserviceData->{Config}->{Provider}->{Operation}->{$Operation} ) {
        delete $WebserviceData->{Config}->{Provider}->{Operation}->{$Operation};

        $Success = $Self->{WebserviceObject}->WebserviceUpdate(
            %{$WebserviceData},
            UserID => $Self->{UserID},
        );
    }

    # build JSON output
    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Title' . $Param{Mode},
        Data => \%Param
    );
    $Self->{LayoutObject}->Block(
        Name => 'Navigation' . $Param{Mode},
        Data => \%Param
    );

    my %TemplateData;

    if ( $Param{Mode} eq 'Add' ) {
        $TemplateData{OperationType} = $Param{OperationType};

    }
    elsif ( $Param{Mode} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ActionListDelete',
            Data => \%Param
        );

        $Self->{LayoutObject}->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );

        $TemplateData{OperationType} = $Param{OperationConfig}->{Type};
    }

    $TemplateData{Description} = $Param{OperationConfig}->{Description};

    my $Mappings = $Self->{ConfigObject}->Get('GenericInterface::Mapping::Module') || {};

    # Inbound mapping
    my @MappingList = sort keys %{$Mappings};

    my $MappingInbound
        = $Self->_MappingTypeCheck( MappingType => $Param{MappingInbound} )
        ? $Param{MappingInbound}
        : '';

    $TemplateData{MappingInboundStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingInbound',
        SelectedValue => $MappingInbound,
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'RegisterChange',
    );

    if ($MappingInbound) {
        $TemplateData{MappingInboundConfigDialog} = $Mappings->{$MappingInbound}->{ConfigDialog};
    }

    if ( $TemplateData{MappingInboundConfigDialog} && $Param{Mode} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'MappingInboundConfigureButton',
            Data => {
                %Param,
                %TemplateData,
                }
        );
    }

    # Outbound mapping
    my $MappingOutbound
        = $Self->_MappingTypeCheck( MappingType => $Param{MappingOutbound} )
        ? $Param{MappingOutbound}
        : '';

    $TemplateData{MappingOutboundStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => \@MappingList,
        Name          => 'MappingOutbound',
        SelectedValue => $MappingOutbound,
        Sort          => 'AlphanumericValue',
        PossibleNone  => 1,
        Class         => 'RegisterChange',
    );

    if ($MappingOutbound) {
        $TemplateData{MappingOutboundConfigDialog} = $Mappings->{$MappingOutbound}->{ConfigDialog};
    }

    if ( $TemplateData{MappingOutboundConfigDialog} && $Param{Mode} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'MappingOutboundConfigureButton',
            Data => {
                %Param,
                %TemplateData,
                }
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceOperationDefault',
        Data         => {
            %Param,
            %TemplateData,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

=item _OperationTypeCheck()

checks if a given OperationType is registered in the system.

=cut

sub _OperationTypeCheck {
    my ( $Self, %Param ) = @_;

    return 0 if !$Param{OperationType};

    my $Operations = $Self->{ConfigObject}->Get('GenericInterface::Operation::Module');
    return 0 if ref $Operations ne 'HASH';

    return ref $Operations->{ $Param{OperationType} } eq 'HASH' ? 1 : 0;
}

=item _MappingTypeCheck()

checks if a given MappingType is registered in the system.

=cut

sub _MappingTypeCheck {
    my ( $Self, %Param ) = @_;

    return 0 if !$Param{MappingType};

    my $Mappings = $Self->{ConfigObject}->Get('GenericInterface::Mapping::Module');
    return 0 if ref $Mappings ne 'HASH';

    return ref $Mappings->{ $Param{MappingType} } eq 'HASH' ? 1 : 0;
}

1;
