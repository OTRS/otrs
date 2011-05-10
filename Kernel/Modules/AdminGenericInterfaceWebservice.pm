# --
# Kernel/Modules/AdminGenericInterfaceWebservice.pm - provides a webservice view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceWebservice.pm,v 1.2 2011-05-10 16:57:31 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::Valid;

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

    # create addtional objects
    $Self->{ValidObject}      = Kernel::System::Valid->new( %{$Self} );
    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # default: show start screen
    return $Self->_ShowScreen(
        %Param,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'OverviewHeader' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get webservices list
    my $WebserviceList = $Self->{WebserviceObject}->WebserviceList( Valid => 0 );

    # check if no webservices are registered
    if ( !IsHashRefWithData($WebserviceList) ) {
        $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
    }

    #otherwise show all webservices
    else {
        WEBSERVICEID:
        for my $WebserviceID ( keys %{$WebserviceList} ) {
            next WEBSERVICEID if !$WebserviceID;

            # get webservice data
            my $Webservice = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );
            next WEBSERVICEID if !$Webservice;

            # convert ValidID to text
            my $ValidStrg = $Self->{ValidObject}->ValidLookup(
                ValidID => $Webservice->{ValidID},
            );

            # prepare data to output
            my $Data = {
                ID           => $WebserviceID,
                Name         => $Webservice->{Name},
                Description  => $Webservice->{Config}->{Description},
                RemoteSystem => $Webservice->{Config}->{RemoteSystem},
                Protocol     => $Webservice->{Config}->{Protocol},
                Valid        => $ValidStrg,
            };

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => $Data,
            );
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceWebservice',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
