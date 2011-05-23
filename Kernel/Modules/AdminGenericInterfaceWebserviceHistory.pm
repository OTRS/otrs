# --
# Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm - provides a log view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceWebserviceHistory.pm,v 1.2 2011-05-23 17:33:51 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebserviceHistory;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::WebserviceHistory;

use Kernel::System::VariableCheck qw(:all);

use YAML;

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
    $Self->{WebserviceHistoryObject}
        = Kernel::System::GenericInterface::WebserviceHistory->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceID        = $Self->{ParamObject}->GetParam( Param => 'WebserviceID' );
    my $WebserviceHistoryID = $Self->{ParamObject}->GetParam( Param => 'WebserviceHistoryID' );
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

    if ( $Self->{Subaction} eq 'GetWebserviceList' ) {
        return $Self->_GetWebserviceList(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'GetWebserviceHistoryDetails' ) {
        return $Self->_GetWebserviceHistoryDetails(
            %Param,
            WebserviceHistoryID => $WebserviceHistoryID,
            WebserviceData      => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'Export' ) {
        return $Self->_ExportWebserviceHistory(
            %Param,
            WebserviceID        => $WebserviceID,
            WebserviceHistoryID => $WebserviceHistoryID,
            WebserviceData      => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'ClearWebserviceHistory' ) {
        return $Self->_ClearWebserviceHistory(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }

    # default: show start screen
    return $Self->_ShowScreen(
        %Param,
        WebserviceID   => $WebserviceID,
        WebserviceData => $WebserviceData,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceWebserviceHistory',
        Data         => {
            %Param,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _GetWebserviceList {
    my ( $Self, %Param ) = @_;
    my %LogSearchParam = (
        WebserviceID => $Param{WebserviceID},
    );

    my @List = $Self->{WebserviceHistoryObject}->WebserviceHistoryList(
        WebserviceID => $Param{WebserviceID},
    );

    my @LogData;

    # get webservice history info
    for my $Key (@List) {
        my $WebserviceHistory = $Self->{WebserviceHistoryObject}->WebserviceHistoryGet(
            ID => $Key,
        );
        $WebserviceHistory->{Config} = '';
        push @LogData, $WebserviceHistory;
    }

    # build JSON output
    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => {
            LogData => \@LogData,
        },
    );

    #
    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _GetWebserviceHistoryDetails {
    my ( $Self, %Param ) = @_;

    my $WebserviceHistoryID = $Self->{ParamObject}->GetParam( Param => 'WebserviceHistoryID' );

    if ( !$WebserviceHistoryID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no WebserviceID',
        );

        return;    # return empty response
    }

    my $LogData = $Self->{WebserviceHistoryObject}->WebserviceHistoryGet(
        ID => $WebserviceHistoryID,
    );
    $LogData->{Config} = YAML::Dump( $LogData->{Config} );

    # build JSON output
    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => {
            LogData => $LogData,
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

sub _ExportWebserviceHistory {
    my ( $Self, %Param ) = @_;

    my $WebserviceHistoryID = $Self->{ParamObject}->GetParam( Param => 'WebserviceHistoryID' );

    if ( !$WebserviceHistoryID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no WebserviceID',
        );

        return;    # return empty response
    }

    my $WebserviceData = $Self->{WebserviceHistoryObject}->WebserviceHistoryGet(
        ID => $WebserviceHistoryID,
    );

    # check for valid webservice configuration
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not get history data for WebserviceHistoryID $WebserviceHistoryID",
        );
    }

    # dump configuration into a YAML structure
    my $YAMLContent = YAML::Dump( $WebserviceData->{Config} );

    # return yaml to download
    my $YAMLFile = $WebserviceData->{Name} || 'yamlfile';
    return $Self->{LayoutObject}->Attachment(
        Filename    => $YAMLFile . '.yaml',
        ContentType => "text/plain; charset=" . $Self->{LayoutObject}->{UserCharset},
        Content     => $YAMLContent,
    );
}

sub _ClearWebserviceHistory {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{WebserviceHistoryObject}->LogDelete(
        WebserviceID => $Param{WebserviceID},
    );

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

1;
