# --
# Kernel/Modules/AdminGenericInterfaceOperationDefault.pm - provides a log view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceOperationDefault.pm,v 1.2 2011-05-20 13:01:22 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceOperationDefault;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        my %Errors;
        my %GetParam;

        for my $Needed (qw(Operation OperationType)) {
            $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'ServerError' } = 'ServerError';
            }
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

            return $Self->_ShowScreen(
                %Param,
                %Errors,
                Mode           => 'Add',
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                WebserviceName => $WebserviceData->{Name},
                OperationType  => $GetParam{OperationType},
            );
        }

        my $Config = {
            Type => $GetParam{OperationType},
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
    elsif ( $Self->{Subaction} eq 'Change' ) {

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
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        #TODO: implement
    }

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

        $TemplateData{OperationType} = $Param{OperationConfig}->{Type};
    }

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

    if ( $TemplateData{MappingOutboundConfigDialog} && $Self->{Subaction} eq 'Change' ) {
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
