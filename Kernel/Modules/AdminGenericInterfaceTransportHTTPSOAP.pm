# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceTransportHTTPSOAP;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # Set possible values handling strings.
    $Self->{EmptyString}     = '_AdditionalHeaders_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_AdditionalHeaders_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_AdditionalHeaders_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject      = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceID      = $ParamObject->GetParam( Param => 'WebserviceID' )      || '';
    my $CommunicationType = $ParamObject->GetParam( Param => 'CommunicationType' ) || '';

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # Check for WebserviceID.
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need WebserviceID!'),
            );
        }

        # Get web service configuration.
        my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

        # Check for valid web service configuration.
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        return $Self->_ShowEdit(
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # invalid sub-action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} ne 'ChangeAction' ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need valid Subaction!'),
        );
    }

    # ------------------------------------------------------------ #
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #

    # Challenge token check for write action.
    $LayoutObject->ChallengeTokenCheck();

    # Check for WebserviceID.
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    # Get web service configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Get parameter from web browser.
    my $GetParam = $Self->_GetParams();

    # Check required parameters.
    my %Error;
    for my $ParamName (qw( NameSpace SOAPAction )) {
        if ( !$GetParam->{$ParamName} ) {

            # Add server error error class.
            $Error{ $ParamName . 'ServerError' }        = 'ServerError';
            $Error{ $ParamName . 'ServerErrorMessage' } = Translatable('This field is required');
        }
    }

    # To store the clean new configuration locally.
    my $TransportConfig;

    # Get common settings.
    for my $Param (
        qw(
        NameSpace
        SOAPAction SOAPActionSeparator SOAPActionScheme SOAPActionFreeText
        RequestNameScheme RequestNameFreeText
        ResponseNameScheme ResponseNameFreeText
        )
        )
    {
        $TransportConfig->{$Param} = $GetParam->{$Param};
    }

    # Check SOAPAction options.
    if ( $GetParam->{SOAPAction} && $GetParam->{SOAPAction} eq 'Yes' ) {

        my $ServerError        = 'ServerError';
        my $ServerErrorMessage = Translatable('This field is required');

        # Scheme is required if SOAPAction is enabled.
        if ( !$GetParam->{SOAPActionScheme} ) {
            $Error{SOAPActionSchemeServerError}        = $ServerError;
            $Error{SOAPActionSchemeServerErrorMessage} = $ServerErrorMessage;
        }
        elsif (
            $GetParam->{SOAPActionScheme} eq 'SeparatorOperation'
            && $GetParam->{SOAPActionScheme} eq 'NameSpaceSeparatorOperation'
            )
        {

            # Separator if required if SOAPAction is enabled and selected scheme uses separator.
            if ( !$GetParam->{SOAPActionSeparator} ) {
                $Error{SOAPActionSeparatorServerError}        = $ServerError;
                $Error{SOAPActionSeparatorServerErrorMessage} = $ServerErrorMessage;
            }
        }
        elsif ( $GetParam->{SOAPActionScheme} eq 'FreeText' ) {

            # Free text if required if SOAPAction is enabled and selected scheme uses free text.
            if ( !$GetParam->{SOAPActionSeparator} ) {
                $Error{SOAPActionSeparatorServerError}        = $ServerError;
                $Error{SOAPActionSeparatorServerErrorMessage} = $ServerErrorMessage;
            }
        }
    }

    # Add sorting structure.
    if ( $GetParam->{Sort} ) {
        my $SortStructure = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $GetParam->{Sort} );
        $TransportConfig->{Sort} = $Self->_PackStructure( Structure => $SortStructure );
    }

    # Get requester specific settings.
    if ( $CommunicationType eq 'Requester' ) {

        $TransportConfig->{Encoding} = $GetParam->{Encoding};

        NEEDED:
        for my $Needed (qw( Endpoint Timeout )) {
            $TransportConfig->{$Needed} = $GetParam->{$Needed};
            next NEEDED if defined $GetParam->{$Needed};

            $Error{ $Needed . 'ServerError' }        = 'ServerError';
            $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
        }

        # Set error for non integer content.
        if ( $GetParam->{Timeout} && !IsInteger( $GetParam->{Timeout} ) ) {
            $Error{TimeoutServerError}        = 'ServerError';
            $Error{TimeoutServerErrorMessage} = Translatable('This field should be an integer.');
        }

        # Check authentication options.
        if ( $GetParam->{AuthType} && $GetParam->{AuthType} eq 'BasicAuth' ) {

            # Get BasicAuth settings.
            for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword )) {
                $TransportConfig->{Authentication}->{$ParamName} = $GetParam->{$ParamName};
            }
            NEEDED:
            for my $Needed (qw( BasicAuthUser BasicAuthPassword )) {
                next NEEDED if defined $GetParam->{$Needed} && length $GetParam->{$Needed};

                $Error{ $Needed . 'ServerError' }        = 'ServerError';
                $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
            }
        }

        # Check proxy options.
        if ( $GetParam->{UseProxy} && $GetParam->{UseProxy} eq 'Yes' ) {

            # Get Proxy settings.
            for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
                $TransportConfig->{Proxy}->{$ParamName} = $GetParam->{$ParamName};
            }
        }

        # Check SSL options.
        if ( $GetParam->{UseSSL} && $GetParam->{UseSSL} eq 'Yes' ) {

            # Get SSL authentication settings.
            for my $ParamName (qw( UseSSL SSLPassword )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};
            }
            PARAMNAME:
            for my $ParamName (qw( SSLCertificate SSLKey SSLCAFile SSLCADir )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};

                # Check if file/directory exists and is accessible.
                next PARAMNAME if !$GetParam->{$ParamName};
                if ( $ParamName eq 'SSLCADir' ) {
                    next PARAMNAME if -d $GetParam->{$ParamName};
                }
                else {
                    next PARAMNAME if -f $GetParam->{$ParamName};
                }
                $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                $Error{ $ParamName . 'ServerErrorMessage' } = Translatable('File or Directory not found.');
            }
        }
    }

    # Get provider specific settings.
    else {

        if ( !defined $GetParam->{MaxLength} ) {

            # Add server error error class.
            $Error{MaxLengthServerError}        = 'ServerError';
            $Error{MaxLengthServerErrorMessage} = Translatable('This field is required');
        }

        $TransportConfig->{MaxLength} = $GetParam->{MaxLength};

        # Set error for non integer content.
        if ( $GetParam->{MaxLength} && !IsInteger( $GetParam->{MaxLength} ) ) {
            $Error{MaxLengthServerError}        = 'ServerError';
            $Error{MaxLengthServerErrorMessage} = Translatable('This field should be an integer.');
        }

        # Get additional headers.
        $TransportConfig->{AdditionalHeaders} = $Self->_GetAdditionalHeaders();
    }

    # Set new configuration.
    $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config} = $TransportConfig;

    # If there is an error return to edit screen.
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_ShowEdit(
            %Error,
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # Otherwise save configuration and return to overview screen.
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceData->{Name},
        Config  => $WebserviceData->{Config},
        ValidID => $WebserviceData->{ValidID},
        UserID  => $Self->{UserID},
    );

    # If the user would like to continue editing the transport config, just redirect to the edit screen.
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Change;WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;",
        );
    }
    else {

        # Otherwise return to overview.
        return $LayoutObject->Redirect(
            OP => "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;",
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Param{Type}           = 'HTTP::SOAP';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    my $TransportConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config};

    # Extract display parameters from transport config.
    for my $ParamName (
        qw(
        Endpoint NameSpace Encoding MaxLength Timeout
        RequestNameFreeText ResponseNameFreeText
        SOAPActionFreeText
        AdditionalHeaders
        )
        )
    {
        $Param{$ParamName} = $TransportConfig->{$ParamName};
    }
    for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword )) {
        $Param{$ParamName} = $TransportConfig->{Authentication}->{$ParamName};
    }
    for my $ParamName (qw( UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir )) {
        $Param{$ParamName} = $TransportConfig->{SSL}->{$ParamName};
    }
    for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
        $Param{$ParamName} = $TransportConfig->{Proxy}->{$ParamName};
    }

    # Get sorting structure.
    if ( $TransportConfig->{Sort} ) {
        my $SortStructure = $Self->_UnpackStructure( Structure => $TransportConfig->{Sort} );
        $Param{Sort} = $Kernel::OM->Get('Kernel::System::JSON')->Encode( Data => $SortStructure );

        # Send data to JS.
        $LayoutObject->AddJSData(
            Key   => 'SortData',
            Value => $Param{Sort},
        );
    }

    # Create options for request and response name schemes.
    for my $Type (qw(Request Response)) {
        my $TypeDefault = $Type eq 'Request' ? 'Plain' : 'Response';
        my $SelectedID  = $TransportConfig->{ $Type . 'NameScheme' } || $TypeDefault;
        my %Data        = (
            'Plain'   => "<FunctionName>DATA</FunctionName>",
            $Type     => "<FunctionName${Type}>DATA</FunctionName${Type}>",
            'Append'  => "<FunctionNameFreeText>DATA</FunctionNameFreeText>",
            'Replace' => '<FreeText>DATA</FreeText>',
        );
        if ( $Type eq 'Request' ) {
            delete $Data{'Replace'};
        }
        $Param{ $Type . 'NameSchemeStrg' } = $LayoutObject->BuildSelection(
            Data       => \%Data,
            Name       => $Type . 'NameScheme',
            SelectedID => $SelectedID,
            Sort       => 'AlphaNumericValue',
            Class      => 'Modernize',
        );

        # Treat depending free text field based on current value.
        if ( $SelectedID ne 'Append' && $SelectedID ne 'Replace' ) {
            $Param{"${Type}NameFreeTextHidden"} = 'Hidden';
        }
        else {
            $Param{"${Type}NameFreeTextMandatory"} = 'Validate_Required';
        }
    }

    # Create SOAPAction select.
    my $SelectedSOAPAction = $TransportConfig->{SOAPAction} || Translatable('Yes');
    $Param{SOAPActionStrg} = $LayoutObject->BuildSelection(
        Data => {
            'No'  => Translatable('No'),
            'Yes' => Translatable('Yes'),
        },
        Name          => 'SOAPAction',
        SelectedValue => $SelectedSOAPAction,
        Sort          => 'AlphaNumericValue',
        Class         => 'Modernize Validate_Required',
    );

    # Create options for SOAPAction scheme.
    if ( $SelectedSOAPAction eq 'Yes' ) {
        $Param{SOAPActionSchemeMandatory} = 'Validate_Required';
    }
    else {
        $Param{SOAPActionSchemeHidden} = 'Hidden';
    }
    my $SelectedSOAPActionScheme = $TransportConfig->{SOAPActionScheme} || 'NameSpaceSeparatorOperation';
    my $VisibleOperationName     = $Param{CommunicationType} eq 'Request' ? 'Invoker' : 'Operation';
    $Param{SOAPActionSchemeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'FreeText',
                Value => '<FreeText>',
            },
            {
                Key   => 'Operation',
                Value => "<$VisibleOperationName>",
            },
            {
                Key   => 'SeparatorOperation',
                Value => "<Separator><$VisibleOperationName>",
            },
            {
                Key   => 'NameSpaceSeparatorOperation',
                Value => "<NameSpace><Separator><$VisibleOperationName>",
            },
        ],
        Name       => 'SOAPActionScheme',
        SelectedID => $SelectedSOAPActionScheme,
        Sort       => 'AlphaNumericValue',
        Class      => 'Modernize ' . ( $Param{SOAPActionSchemeMandatory} || '' ),
    );

    # Create options for SOAPAction separator.
    if (
        $SelectedSOAPAction eq 'Yes'
        && (
            $SelectedSOAPActionScheme eq 'SeparatorOperation'
            || $SelectedSOAPActionScheme eq 'NameSpaceSeparatorOperation'
        )
        )
    {
        $Param{SOAPActionSeparatorMandatory} = 'Validate_Required';
    }
    else {
        $Param{SOAPActionSeparatorHidden} = 'Hidden';
    }
    $Param{SOAPActionSeparatorStrg} = $LayoutObject->BuildSelection(
        Data          => [ '#', '/' ],
        Name          => 'SOAPActionSeparator',
        SelectedValue => $TransportConfig->{SOAPActionSeparator} || '#',
        Sort          => 'AlphaNumericValue',
        Class         => 'Modernize ' . ( $Param{SOAPActionSeparatorMandatory} || '' ),
    );

    # Create options for SOAPAction free text.
    if ( $SelectedSOAPAction eq 'Yes' && $SelectedSOAPActionScheme eq 'FreeText' ) {
        $Param{SOAPActionFreeTextMandatory} = 'Validate_Required';
    }
    else {
        $Param{SOAPActionFreeTextHidden} = 'Hidden';
    }

    # Check if communication type is requester.
    if ( $Param{CommunicationType} eq 'Requester' ) {

        # Create Timeout select.
        $Param{TimeoutStrg} = $LayoutObject->BuildSelection(
            Data          => [ '30', '60', '90', '120', '150', '180', '210', '240', '270', '300' ],
            Name          => 'Timeout',
            SelectedValue => $Param{Timeout} || '120',
            Sort          => 'NumericValue',
            Class         => 'Modernize',
        );

        # Create Authentication types select.
        $Param{AuthenticationStrg} = $LayoutObject->BuildSelection(
            Data          => ['BasicAuth'],
            Name          => 'AuthType',
            SelectedValue => $Param{AuthType} || '-',
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable authentication methods if they are not selected.
        $Param{BasicAuthHidden} = 'Hidden';
        if ( $Param{AuthType} && $Param{AuthType} eq 'BasicAuth' ) {
            $Param{BasicAuthHidden}                   = '';
            $Param{BasicAuthUserServerError}          = 'Validate_Required';
            $Param{BasicAuthPasswordValidateRequired} = 'Validate_Required';
        }

        # Create use Proxy select.
        $Param{UseProxyStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseProxy',
            SelectedValue => $Param{UseProxy} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create Proxy exclude select.
        $Param{ProxyExcludeStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'ProxyExclude',
            SelectedValue => $Param{ProxyExclude} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable Proxy options if they are not selected.
        $Param{ProxyHidden} = 'Hidden';
        if ( $Param{UseProxy} && $Param{UseProxy} eq 'Yes' )
        {
            $Param{ProxyHidden} = '';
        }

        # Create use SSL select.
        $Param{UseSSLStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseSSL',
            SelectedValue => $Param{UseSSL} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable SSL options if they are not selected.
        $Param{SSLHidden} = 'Hidden';
        if ( $Param{UseSSL} && $Param{UseSSL} eq 'Yes' )
        {
            $Param{SSLHidden} = '';
        }
    }

    # Check if communication type is requester.
    elsif ( $Param{CommunicationType} eq 'Provider' ) {

        $LayoutObject->Block(
            Name => 'AdditionalHeaders',
            Data => {
                %Param,
            },
        );

        # Output the possible values and errors within (if any).
        my $ValueCounter = 1;
        for my $Key ( sort keys %{ $Param{AdditionalHeaders} || {} } ) {
            $LayoutObject->Block(
                Name => 'ValueRow',
                Data => {
                    Key          => $Key,
                    ValueCounter => $ValueCounter,
                    Value        => $Param{AdditionalHeaders}->{$Key},
                },
            );

            $ValueCounter++;
        }

        # Create the possible values template.
        $LayoutObject->Block(
            Name => 'ValueTemplate',
            Data => {
                %Param,
            },
        );

        # Set value counter.
        $Param{ValueCounter} = $ValueCounter;
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceTransportHTTPSOAP',
        Data         => { %Param, },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $GetParam;

    # Get parameters from web browser.
    for my $ParamName (
        qw(
        Endpoint NameSpace Encoding MaxLength Sort Timeout
        AuthType BasicAuthUser BasicAuthPassword
        UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude
        UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir
        SOAPAction SOAPActionSeparator SOAPActionScheme SOAPActionFreeText
        RequestNameFreeText ResponseNameFreeText RequestNameScheme ResponseNameScheme
        )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }
    return $GetParam;
}

sub _UnpackStructure {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Structure} ) {
        return [];
    }

    # Compatibility workaround.
    if ( ref $Param{Structure}->[0] eq 'ARRAY' ) {
        $Param{Structure} = $Param{Structure}->[0];
    }

    my @Structure;
    ARRAYELEMENT:
    for my $ArrayElement ( @{ $Param{Structure} } ) {
        my ($Key) = sort keys %{$ArrayElement};
        push @Structure, $Key;
        next ARRAYELEMENT if !defined $ArrayElement->{$Key};

        push @Structure, $Self->_UnpackStructure( Structure => $ArrayElement->{$Key} );
    }

    return \@Structure;
}

sub _PackStructure {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Structure} ) {
        return [];
    }

    my @Structure;
    ARRAYCOUNT:
    for my $ArrayCount ( 0 .. scalar @{ $Param{Structure} } - 1 ) {
        my $Key     = $Param{Structure}->[$ArrayCount];
        my $NextKey = $Param{Structure}->[ $ArrayCount + 1 ];
        my $Value   = undef;

        # Already processed previously.
        next ARRAYCOUNT if ref $Key eq 'ARRAY';

        # Check for substructure.
        if ( ref $NextKey eq 'ARRAY' ) {
            $Value = $Self->_PackStructure( Structure => $NextKey );
        }

        push @Structure, { $Key => $Value };
    }

    return \@Structure;
}

sub _GetAdditionalHeaders {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get ValueCounters.
    my $ValueCounter = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;

    # Get possible values.
    my $AdditionalHeaderConfig;
    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $ParamObject->GetParam( Param => 'Key' . '_' . $ValueIndex ) // '';

        # Check if key was deleted by the user and skip it.
        next VALUEINDEX if $Key eq $Self->{DeletedString};

        # Skip empty key.
        next VALUEINDEX if $Key eq '';

        my $Value = $ParamObject->GetParam( Param => 'Value' . '_' . $ValueIndex ) // '';
        $AdditionalHeaderConfig->{$Key} = $Value;
    }

    return $AdditionalHeaderConfig;
}

1;
