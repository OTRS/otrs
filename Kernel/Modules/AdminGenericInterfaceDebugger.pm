# --
# Kernel/Modules/AdminGenericInterfaceDebugger.pm - provides a log view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceDebugger.pm,v 1.1 2011-05-03 12:38:02 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceDebugger;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::DebugLog;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

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
    $Self->{DebugLogObject}   = Kernel::System::GenericInterface::DebugLog->new( %{$Self} );

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

    if ( $Self->{Subaction} eq 'GetRequestList' ) {
        my $LogData = $Self->{DebugLogObject}->LogSearch(
            WebserviceID => $WebserviceID,

     #            CommunicationID   => '6f1ed002ab5595859014ebf0951522d9', # optional
     #            CommunicationType => 'Provider',     # optional, 'Provider' or 'Requester'
     #            CreatedAtOrAfter  => '2011-01-01 00:00:00', # optional
     #            CreatedArOrBefore => '2011-12-31 23:59:59', # optional
     #            RemoteIP          => '192.168.0.1', # optional, must be valid IPv4 or IPv6 address
     #            WithData          => 0, # optional
        );

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
    elsif ( $Self->{Subaction} eq 'GetCommunicationDetails' ) {

        my $CommunicationID = $Self->{ParamObject}->GetParam( Param => 'CommunicationID' );

        if ( !$CommunicationID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Got no CommunicationID',
            );

            return;    # return empty response
        }

        my $LogData = $Self->{DebugLogObject}->LogGetWithData(
            CommunicationID => $CommunicationID,
        );

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

    # default: show start screen
    return $Self->Screen(
        %Param,
        WebserviceID => $WebserviceID,
    );
}

sub Screen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceDebugger',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
