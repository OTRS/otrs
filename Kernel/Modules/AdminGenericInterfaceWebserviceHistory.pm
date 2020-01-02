# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebserviceHistory;

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $WebserviceHistoryID = $ParamObject->GetParam( Param => 'WebserviceHistoryID' );
    my $WebserviceID        = $ParamObject->GetParam( Param => 'WebserviceID' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$WebserviceID ) {
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
    elsif ( $Self->{Subaction} eq 'Rollback' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_RollbackWebserviceHistory(
            %Param,
            WebserviceID        => $WebserviceID,
            WebserviceHistoryID => $WebserviceHistoryID,
            WebserviceData      => $WebserviceData,
        );
    }

    # Default: show start screen.
    return $Self->_ShowScreen(
        %Param,
        WebserviceID   => $WebserviceID,
        WebserviceData => $WebserviceData,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceWebserviceHistory',
        Data         => {
            %Param,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetWebserviceList {
    my ( $Self, %Param ) = @_;
    my %LogSearchParam = (
        WebserviceID => $Param{WebserviceID},
    );

    # Get web service history object.
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');
    my @List                    = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $Param{WebserviceID},
    );

    my @LogData;

    # Get web service history info.
    for my $Key (@List) {
        my $WebserviceHistory = $WebserviceHistoryObject->WebserviceHistoryGet(
            ID => $Key,
        );
        $WebserviceHistory->{Config} = '';
        push @LogData, $WebserviceHistory;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            LogData => \@LogData,
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

sub _GetWebserviceHistoryDetails {
    my ( $Self, %Param ) = @_;

    my $PasswordMask = '*******';

    my $WebserviceHistoryID = $Param{WebserviceHistoryID};

    if ( !$WebserviceHistoryID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no WebserviceID',
        );

        return;    # return empty response
    }

    my $LogData = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory')->WebserviceHistoryGet(
        ID => $WebserviceHistoryID,
    );

    # Mask password strings.
    if (
        IsStringWithData(
            $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication}->{BasicAuthPassword}
        )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication}->{BasicAuthPassword} = $PasswordMask;
    }
    if (
        IsStringWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{Proxy}->{ProxyPassword} )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{Proxy}->{ProxyPassword} = $PasswordMask;
    }
    if (
        IsStringWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLPassword} )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLPassword} = $PasswordMask;
    }

    # For compatibility (web services changed before OTRS 6).
    if (
        IsStringWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication}->{Password} )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication}->{Password} = $PasswordMask;
    }
    elsif (
        !IsHashRefWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication} )
        )
    {
        delete $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication};
    }
    if (
        IsStringWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLProxyPassword} )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLProxyPassword} = $PasswordMask;
    }
    if (
        IsStringWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLP12Password} )
        )
    {
        $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL}->{SSLP12Password} = $PasswordMask;
    }

    # Remove structure added by auto-vivification.
    if (
        !IsHashRefWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication} )
        )
    {
        delete $LogData->{Config}->{Requester}->{Transport}->{Config}->{Authentication};
    }
    if (
        !IsHashRefWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{Proxy} )
        )
    {
        delete $LogData->{Config}->{Requester}->{Transport}->{Config}->{Proxy};
    }
    if (
        !IsHashRefWithData( $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL} )
        )
    {
        delete $LogData->{Config}->{Requester}->{Transport}->{Config}->{SSL};
    }

    # Dump config.
    $LogData->{Config} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $LogData->{Config},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            LogData => $LogData,
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

sub _ExportWebserviceHistory {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Param{WebserviceHistoryID} ) {
        $LayoutObject->FatalError(
            Message => Translatable('Got no WebserviceHistoryID!'),
        );
    }

    my $WebserviceHistoryID = $Param{WebserviceHistoryID};

    my $WebserviceHistoryData
        = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory')->WebserviceHistoryGet(
        ID => $WebserviceHistoryID,
        );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceHistoryData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}
                ->Translate( 'Could not get history data for WebserviceHistoryID %s', $WebserviceHistoryID ),
        );
    }

    # Dump configuration into a YAML structure.
    my $YAMLContent = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $WebserviceHistoryData->{Config},
    );

    # Return YAML to download.
    my $YAMLFile = $Param{WebserviceData}->{Name} || 'yamlfile';
    return $LayoutObject->Attachment(
        Filename    => $YAMLFile . '.yml',
        ContentType => "text/plain; charset=" . $LayoutObject->{UserCharset},
        Content     => $YAMLContent,
    );
}

sub _RollbackWebserviceHistory {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Param{WebserviceHistoryID} ) {
        $LayoutObject->FatalError(
            Message => Translatable('Got no WebserviceHistoryID!'),
        );
    }

    my $WebserviceID        = $Param{WebserviceID};
    my $WebserviceHistoryID = $Param{WebserviceHistoryID};

    my $WebserviceHistoryData
        = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory')->WebserviceHistoryGet(
        ID => $WebserviceHistoryID,
        );

    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $Param{WebserviceData}->{Name},
        Config  => $WebserviceHistoryData->{Config},
        ValidID => $Param{WebserviceData}->{ValidID},
        UserID  => $Self->{UserID},
    );

    return $LayoutObject->Redirect(
        OP => "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID",
    );
}

1;
