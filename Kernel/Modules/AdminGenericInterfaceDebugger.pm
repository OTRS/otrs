# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceDebugger;

use strict;
use warnings;

use utf8;

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

    my $WebserviceID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WebserviceID' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $WebserviceID,
    );

    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Send value to JS.
    $LayoutObject->AddJSData(
        Key   => 'WebserviceID',
        Value => $WebserviceID,
    );

    if ( $Self->{Subaction} eq 'GetRequestList' ) {
        return $Self->_GetRequestList(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'GetCommunicationDetails' ) {
        return $Self->_GetCommunicationDetails(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'ClearDebugLog' ) {
        return $Self->_ClearDebugLog(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
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

    my $FilterLimitStrg = $LayoutObject->BuildSelection(
        Data => [
            '10',
            '25',
            '50',
            '100',
            '250',
            '500',
            '1000',
            '10000',
        ],
        Name          => 'FilterLimit',
        SelectedValue => '10',
        Translate     => 0,
        Class         => 'Modernize',
    );

    my $FilterSortStrg = $LayoutObject->BuildSelection(
        Data => {
            'ASC'  => Translatable('ascending'),
            'DESC' => Translatable('descending'),
        },
        Name         => 'FilterSort',
        PossibleNone => 0,
        SelectedID   => 'DESC',
        Translate    => 0,
        Class        => 'Modernize',
    );

    my $FilterTypeStrg = $LayoutObject->BuildSelection(
        Data => [
            'Provider',
            'Requester',
        ],
        Name         => 'FilterType',
        PossibleNone => 1,
        Translate    => 0,
        Class        => 'Modernize',
    );

    my $FilterFromStrg = $LayoutObject->BuildDateSelection(
        Prefix   => 'FilterFrom',
        DiffTime => -60 * 60 * 24 * 356,
    );

    my $FilterToStrg = $LayoutObject->BuildDateSelection(
        Prefix => 'FilterTo',
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceDebugger',
        Data         => {
            %Param,
            WebserviceName  => $Param{WebserviceData}->{Name},
            FilterLimitStrg => $FilterLimitStrg,
            FilterSortStrg  => $FilterSortStrg,
            FilterTypeStrg  => $FilterTypeStrg,
            FilterFromStrg  => $FilterFromStrg,
            FilterToStrg    => $FilterToStrg,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetRequestList {
    my ( $Self, %Param ) = @_;

    my %LogSearchParam = (
        WebserviceID => $Param{WebserviceID},
    );

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FilterType = $ParamObject->GetParam( Param => 'FilterType' );
    $LogSearchParam{CommunicationType} = $FilterType if ($FilterType);

    my $FilterRemoteIP = $ParamObject->GetParam( Param => 'FilterRemoteIP' );

    if ( $FilterRemoteIP && IsIPv4Address($FilterRemoteIP) ) {
        $LogSearchParam{RemoteIP} = $FilterRemoteIP;
    }

    $LogSearchParam{CreatedAtOrAfter}  = $ParamObject->GetParam( Param => 'FilterFrom' );
    $LogSearchParam{CreatedAtOrBefore} = $ParamObject->GetParam( Param => 'FilterTo' );
    $LogSearchParam{Limit}             = $ParamObject->GetParam( Param => 'FilterLimit' ) || 10;
    $LogSearchParam{Sort}              = $ParamObject->GetParam( Param => 'FilterSort' ) || 'DESC';

    my $LogData = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog')->LogSearch(%LogSearchParam);

    # Get current user time zone.
    my $TimeZone = $Self->{UserTimeZone} || $Kernel::OM->Create('Kernel::System::DateTime')->UserDefaultTimeZoneGet();

    # Set date time format and values for 'Time' column.
    for my $Log ( @{$LogData} ) {
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Log->{Created},
            },
        );

        $DateTimeObject->ToTimeZone(
            TimeZone => $TimeZone,
        );

        $Log->{Created} = $LayoutObject->{LanguageObject}->FormatTimeString(
            $Log->{Created},
            'DateFormat',
        );
    }

    # Fail gracefully.
    $LogData ||= [];

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

sub _GetCommunicationDetails {
    my ( $Self, %Param ) = @_;

    my $CommunicationID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'CommunicationID' );

    if ( !$CommunicationID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no CommunicationID',
        );

        return;    # return empty response
    }

    my $LogData = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog')->LogGetWithData(
        CommunicationID => $CommunicationID,
    );

    # Get current user time zone.
    my $TimeZone = $Self->{UserTimeZone} || $Kernel::OM->Create('Kernel::System::DateTime')->UserDefaultTimeZoneGet();

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Duplicate widgets containing xml data and format the new version for better readability.
    if ( IsArrayRefWithData( $LogData->{Data} ) ) {
        $Kernel::OM->Get('Kernel::System::Main')->Require('XML::LibXML');
        my $XML = XML::LibXML->new();

        INDEX:
        for my $Index ( 0 .. scalar( @{ $LogData->{Data} } ) + 1 ) {

            my $Data = $LogData->{Data}->[$Index]->{Data};

            # remove entries with empty data hashes before JSON encoding
            if ( !IsHashRefWithData( $LogData->{Data}->[$Index] ) ) {
                delete $LogData->{Data}->[$Index];
                next INDEX;
            }

            # Set date time format and values for created log time.
            my $CreatedTime = $LogData->{Data}->[$Index]->{Created};
            if ( $LogData->{Data}->[$Index]->{Created} ) {
                my $DateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $LogData->{Data}->[$Index]->{Created},
                    },
                );

                $DateTimeObject->ToTimeZone(
                    TimeZone => $TimeZone,
                );

                $LogData->{Data}->[$Index]->{Created} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $LogData->{Data}->[$Index]->{Created},
                    'DateFormat',
                );
            }

            next INDEX if !IsStringWithData($Data);
            next INDEX if substr( $Data, 0, 5 ) ne '<?xml';

            # Safely attempt to format xml.
            my $LintedXML;
            eval {
                $LintedXML = $XML->parse_string($Data)->serialize(1);
            };

            next INDEX if !$LintedXML;

            # Prevent double encoding of utf8 data.
            utf8::decode($LintedXML);

            next INDEX if $LintedXML eq $Data;

            # If formatted xml differs from original version, add it to data.
            splice @{ $LogData->{Data} }, $Index + 1, 0, {
                Created    => $CreatedTime,
                Data       => $LintedXML,
                DebugLevel => $LogData->{Data}->[$Index]->{DebugLevel},
                Summary    => $LogData->{Data}->[$Index]->{Summary}
                    . ' (auto-formatted XML, not part of original transmission)',
            };
        }
    }

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

sub _ClearDebugLog {
    my ( $Self, %Param ) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog')->LogDelete(
        WebserviceID => $Param{WebserviceID},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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

1;
