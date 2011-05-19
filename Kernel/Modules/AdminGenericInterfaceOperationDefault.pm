# --
# Kernel/Modules/AdminGenericInterfaceOperationDefault.pm - provides a log view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceOperationDefault.pm,v 1.1 2011-05-19 15:01:55 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceOperationDefault;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

    my $WebserviceID = $Self->{ParamObject}->GetParam( Param => 'WebserviceID' );
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

        return $Self->_ShowScreen(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
            WebserviceName => $WebserviceData->{Name},
            OperationType  => $OperationType,
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
            WebserviceID    => $WebserviceID,
            WebserviceData  => $WebserviceData,
            WebserviceName  => $WebserviceData->{Name},
            Operation       => $Operation,
            OperationConfig => $OperationConfig,
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
        Name => 'Title' . $Self->{Subaction},
        Data => \%Param
    );
    $Self->{LayoutObject}->Block(
        Name => 'Navigation' . $Self->{Subaction},
        Data => \%Param
    );

    my %TemplateParam;

    if ( $Self->{Subaction} eq 'Add' ) {
        $TemplateParam{OperationType} = $Param{OperationType};

    }
    elsif ( $Self->{Subaction} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ActionListDelete',
            Data => \%Param
        );

        $TemplateParam{OperationType} = $Param{OperationConfig}->{Type};
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceOperationDefault',
        Data         => {
            %Param,
            %TemplateParam,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
