# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceTransportHTTPSOAP;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ParamObject      = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceID      = $ParamObject->GetParam( Param => 'WebserviceID' )      || '';
    my $CommunicationType = $ParamObject->GetParam( Param => 'CommunicationType' ) || '';

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
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
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # check required parameters
        my %Error;
        for my $ParamName (
            qw( NameSpace )
            )
        {
            if ( !$GetParam->{$ParamName} ) {

                # add server error error class
                $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                $Error{ $ParamName . 'ServerErrorMessage' } = 'This field is required';
            }
        }

        # to store the clean new configuration locally
        my $TransportConfig;

        # get common settings
        $TransportConfig->{NameSpace} = $GetParam->{NameSpace};

        # check if is not provider (requester)
        if ( $CommunicationType ne 'Provider' ) {

            # get requester specific settings
            $TransportConfig->{Endpoint} = $GetParam->{Endpoint};

            if ( !$GetParam->{Endpoint} ) {

                # add server error error class
                $Error{EndpointServerError}        = 'ServerError';
                $Error{EndpointServerErrorMessage} = 'This field is required';
            }

            $TransportConfig->{Encoding}   = $GetParam->{Encoding};
            $TransportConfig->{SOAPAction} = $GetParam->{SOAPAction};

            # check for SOAPAction
            if ( $GetParam->{SOAPAction} && $GetParam->{SOAPAction} eq 'Yes' ) {

                # get SOAPAction separator
                $TransportConfig->{SOAPActionSeparator} = $GetParam->{SOAPActionSeparator};
            }

            # check for BasicAuth Authentication
            if ( $GetParam->{Authentication} && $GetParam->{Authentication} eq 'BasicAuth' ) {

                # get BasicAuth settings
                $TransportConfig->{Authentication}->{Type}     = $GetParam->{Authentication};
                $TransportConfig->{Authentication}->{User}     = $GetParam->{User};
                $TransportConfig->{Authentication}->{Password} = $GetParam->{Password};

                if ( !$GetParam->{User} ) {

                    # add server error error class
                    $Error{'UserServerError'} = 'ServerError';
                }
            }

            # check SSL options
            if ( $GetParam->{UseSSL} && $GetParam->{UseSSL} eq 'Yes' ) {

                # get SSL authentication settings
                $TransportConfig->{SSL}->{UseSSL}            = $GetParam->{UseSSL};
                $TransportConfig->{SSL}->{SSLP12Certificate} = $GetParam->{SSLP12Certificate};
                $TransportConfig->{SSL}->{SSLP12Password}    = $GetParam->{SSLP12Password};
                $TransportConfig->{SSL}->{SSLCAFile}         = $GetParam->{SSLCAFile};
                $TransportConfig->{SSL}->{SSLCADir}          = $GetParam->{SSLCADir};

                if ( !$GetParam->{SSLP12Certificate} ) {

                    # add server error error class
                    $Error{'SSLP12CertificateServerError'} = 'ServerError';
                }

                if ( !$GetParam->{SSLP12Password} ) {

                    # add server error error class
                    $Error{'SSLP12PasswordServerError'} = 'ServerError';
                }
            }

            # get proxy options
            $TransportConfig->{SSL}->{SSLProxy}         = $GetParam->{SSLProxy};
            $TransportConfig->{SSL}->{SSLProxyUser}     = $GetParam->{SSLProxyUser};
            $TransportConfig->{SSL}->{SSLProxyPassword} = $GetParam->{SSLProxyPassword};
        }

        # otherwise is provider
        else {

            # get provider specific settings
            $TransportConfig->{MaxLength} = $GetParam->{MaxLength};

            # set error for non integer contents
            if ( $GetParam->{MaxLength} !~ m{\A\d+\Z}sxi ) {

                # add server error error class
                $Error{MaxLengthServerError}        = 'ServerError';
                $Error{MaxLengthServerErrorMessage} = 'This field should be an integer number.';
            }
        }

        # add scheme options
        for my $Param (qw(RequestNameFreeText ResponseNameFreeText RequestNameScheme ResponseNameScheme)) {
            $TransportConfig->{$Param} = $GetParam->{$Param};
        }

        # add sorting structure
        if ( $GetParam->{Sort} ) {
            my $SortStructure = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $GetParam->{Sort} );
            $TransportConfig->{Sort} = $Self->_PackStructure( Structure => $SortStructure );
        }

        # set new configuration
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config} = $TransportConfig;

        # if there is an error return to edit screen
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

        # otherwise save configuration and return to overview screen
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # Save button: stay in edit mode.
        my $RedirectURL
            = "Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change;WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;";

        # Save and finish button: go to web service.
        if ( $ParamObject->GetParam( Param => 'ReturnToWebservice' ) ) {
            $RedirectURL = "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;";

        }

        return $LayoutObject->Redirect(
            OP => $RedirectURL,
        );
    }

    return $LayoutObject->ErrorScreen(
        Message => "Need Subaction!",
    );
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # configuration
    $Param{Type}           = 'HTTP::SOAP';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    my $TransportConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config};

    # extract display parameters from transport config
    $Param{Endpoint}             = $TransportConfig->{Endpoint};
    $Param{NameSpace}            = $TransportConfig->{NameSpace};
    $Param{Encoding}             = $TransportConfig->{Encoding};
    $Param{RequestNameFreeText}  = $TransportConfig->{RequestNameFreeText};
    $Param{ResponseNameFreeText} = $TransportConfig->{ResponseNameFreeText};
    $Param{MaxLength}            = $TransportConfig->{MaxLength};
    $Param{SOAPAction}           = $TransportConfig->{SOAPAction};
    $Param{SOAPActionSeparator}  = $TransportConfig->{SOAPActionSeparator};
    $Param{Authentication}       = $TransportConfig->{Authentication}->{Type};
    $Param{User}                 = $TransportConfig->{Authentication}->{User};
    $Param{Password}             = $TransportConfig->{Authentication}->{Password};
    $Param{UseSSL}               = $TransportConfig->{SSL}->{UseSSL};
    $Param{SSLP12Certificate}    = $TransportConfig->{SSL}->{SSLP12Certificate};
    $Param{SSLP12Password}       = $TransportConfig->{SSL}->{SSLP12Password};
    $Param{SSLCAFile}            = $TransportConfig->{SSL}->{SSLCAFile};
    $Param{SSLCADir}             = $TransportConfig->{SSL}->{SSLCADir};
    $Param{SSLProxy}             = $TransportConfig->{SSL}->{SSLProxy};
    $Param{SSLProxyUser}         = $TransportConfig->{SSL}->{SSLProxyUser};
    $Param{SSLProxyPassword}     = $TransportConfig->{SSL}->{SSLProxyPassword};

    # get sorting structure
    if ( $TransportConfig->{Sort} ) {
        my $SortStructure = $Self->_UnpackStructure( Structure => $TransportConfig->{Sort} );
        $Param{Sort} = $Kernel::OM->Get('Kernel::System::JSON')->Encode( Data => $SortStructure );
    }

    # call bread crumbs blocks
    $LayoutObject->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    $LayoutObject->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => $Param{WebserviceName},
            Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action}
                . ';WebserviceID=' . $Param{WebserviceID},
            Nav => '',
        },
    );

    $LayoutObject->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => $Param{CommunicationType} . ' Transport ' . $Param{Type},
            Link => 'Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=' . $Param{Action}
                . ';CommunicationType=' . $Param{CommunicationType}
                . ';WebserviceID=' . $Param{WebserviceID},
            Nav => '',
        },
    );

    # create options for request and response name schemes
    for my $Type (qw(Request Response)) {
        my $TypeDefault = $Type eq 'Request' ? 'Plain' : 'Response';
        my $SelectedID = $TransportConfig->{ $Type . 'NameScheme' } || $TypeDefault;
        my %Data = (
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

        # treat depending free text field based on current value
        if ( $SelectedID ne 'Append' && $SelectedID ne 'Replace' ) {
            $Param{"${Type}NameFreeTextHidden"} = 'Hidden';
        }
        else {
            $Param{"${Type}NameFreeTextMandatory"} = 'Validate_Required';
        }
    }

    # check if communication type is not provider (requester)
    if ( $Param{CommunicationType} ne 'Provider' ) {

        # create SOAPAction select
        $Param{SOAPActionStrg} = $LayoutObject->BuildSelection(
            Data => [ 'No', 'Yes' ],
            Name => 'SOAPAction',
            SelectedValue => $Param{SOAPAction} || 'Yes',
            Sort          => 'AlphaNumericValue',
            Class         => 'Modernize',
        );

        # set default SOAPActionSeparator
        my $SelectedSeparator = '#';
        if ( $Param{SOAPActionSeparator} ) {
            $SelectedSeparator = $Param{SOAPActionSeparator};
        }

        # create SOAPActionSeparator select
        $Param{SOAPActionSeparatorStrg} = $LayoutObject->BuildSelection(
            Data          => [ '#', '/' ],
            Name          => 'SOAPActionSeparator',
            SelectedValue => $SelectedSeparator,
            Sort          => 'AlphaNumericValue',
            Class         => 'Modernize',
        );

        # hide SOAPActionSearator if SOAPAction is set to No
        if ( $Param{SOAPAction} && $Param{SOAPAction} eq 'No' ) {
            $Param{SOAPActionHidden} = 'Hidden';
        }

        # create Authentication types select
        $Param{AuthenticationStrg} = $LayoutObject->BuildSelection(
            Data          => ['BasicAuth'],
            Name          => 'Authentication',
            SelectedValue => $Param{Authentication} || '-',
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # hide and disable authentication methods if they are not selected
        $Param{BasicAuthHidden} = 'Hidden';
        if ( $Param{Authentication} && $Param{Authentication} eq 'BasicAuth' )
        {
            $Param{BasicAuthHidden}      = '';
            $Param{UserValidateRequired} = 'Validate_Required';
        }

        # create use SSL select
        $Param{UseSSLStrg} = $LayoutObject->BuildSelection(
            Data => [ 'No', 'Yes' ],
            Name => 'UseSSL',
            SelectedValue => $Param{UseSSL} || 'No',
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # hide and disable SSL options if they are not selected
        $Param{SSLHidden} = 'Hidden';
        if ( $Param{UseSSL} && $Param{UseSSL} eq 'Yes' )
        {
            $Param{SSLHidden}                         = '';
            $Param{SSLP12CertificateValidateRequired} = 'Validate_Required';
            $Param{SSLP12PasswordValidateRequired}    = 'Validate_Required';
        }

        # call Endpoint block
        $LayoutObject->Block(
            Name => 'Endpoint',
            Data => \%Param,
        );
    }

    # call provider or requester specific bocks
    $LayoutObject->Block(
        Name => 'Transport' . $Param{CommunicationType},
        Data => \%Param,
    );

    # call save and finish block
    if ( $Param{NameSpace} ) {
        $LayoutObject->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );
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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw(
        Endpoint NameSpace Encoding  SOAPAction MaxLength Authentication User Password
        SOAPAction SOAPActionSeparator UseSSL SSLP12Certificate SSLP12Password SSLCAFile SSLCADir
        SSLProxy SSLProxyUser SSLProxyPassword Sort
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

    # compatibility workaround
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

        # already processed previously
        next ARRAYCOUNT if ref $Key eq 'ARRAY';

        # check for substructure
        if ( ref $NextKey eq 'ARRAY' ) {
            $Value = $Self->_PackStructure( Structure => $NextKey );
        }

        push @Structure, { $Key => $Value };
    }

    return \@Structure;
}

1;
