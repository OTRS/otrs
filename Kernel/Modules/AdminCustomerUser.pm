# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
    );

    $Self->{DynamicFieldLookup} = { map { $_->{Name} => $_ } @{$DynamicFieldConfigs} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Nav    = $ParamObject->GetParam( Param => 'Nav' )    || '';
    my $Source = $ParamObject->GetParam( Param => 'Source' ) || 'CustomerUser';
    my $Search = $ParamObject->GetParam( Param => 'Search' );
    $Search
        ||= $ConfigObject->Get('AdminCustomerUser::RunInitialWildcardSearch') ? '*' : '';

    # create local object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    my $NavBar       = '';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( $Nav eq 'None' ) {
        $NavBar = $LayoutObject->Header( Type => 'Small' );
    }
    else {
        $NavBar = $LayoutObject->Header();
        $NavBar .= $LayoutObject->NavigationBar(
            Type => $Nav eq 'Agent' ? 'Customers' : 'Admin',
        );
    }

    # Get list of valid IDs.
    my @ValidIDList = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # check the permission for the SwitchToCustomer feature
    if ( $ConfigObject->Get('SwitchToCustomer') ) {

        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # get the group id which is allowed to use the switch to customer feature
        my $SwitchToCustomerGroupID = $GroupObject->GroupLookup(
            Group => $ConfigObject->Get('SwitchToCustomer::PermissionGroup'),
        );

        # get user groups, where the user has the rw privilege
        my %Groups = $GroupObject->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'rw',
        );

        # if the user is a member in this group he can access the feature
        if ( $Groups{$SwitchToCustomerGroupID} ) {
            $Self->{SwitchToCustomerPermission} = 1;
        }
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $MainObject         = $Kernel::OM->Get('Kernel::System::Main');

    # ------------------------------------------------------------ #
    #  switch to customer
    # ------------------------------------------------------------ #
    if (
        $Self->{Subaction} eq 'Switch'
        && $ConfigObject->Get('SwitchToCustomer')
        && $Self->{SwitchToCustomerPermission}
        )
    {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get user data
        my $UserID   = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %UserData = $CustomerUserObject->CustomerUserDataGet(
            User  => $UserID,
            Valid => 1,
        );

        # create new session id
        my $NewSessionID = $Kernel::OM->Get('Kernel::System::AuthSession')->CreateSessionID(
            %UserData,
            UserLastRequest => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
            UserType        => 'Customer',
            SessionSource   => 'CustomerInterface',
        );

        # get customer interface session name
        my $SessionName = $ConfigObject->Get('CustomerPanelSessionName') || 'CSID';

        # create a new LayoutObject with SessionIDCookie
        my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
        if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
            $Expires = '';
        }

        my $SecureAttribute;
        if ( $ConfigObject->Get('HttpType') eq 'https' ) {

            # Restrict Cookie to HTTPS if it is used.
            $SecureAttribute = 1;
        }

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            %{$Self},
            SetCookies => {
                SessionIDCookie => $ParamObject->SetCookie(
                    Key      => $SessionName,
                    Value    => $NewSessionID,
                    Expires  => $Expires,
                    Path     => $ConfigObject->Get('ScriptAlias'),
                    Secure   => scalar $SecureAttribute,
                    HTTPOnly => 1,
                ),
            },
            SessionID   => $NewSessionID,
            SessionName => $ConfigObject->Get('SessionName'),
        );

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "Switched from Agent to Customer ($Self->{UserLogin} -=> $UserData{UserLogin})",
        );

        # build URL to customer interface
        my $URL = $ConfigObject->Get('HttpType')
            . '://'
            . $ConfigObject->Get('FQDN')
            . '/'
            . $ConfigObject->Get('ScriptAlias')
            . 'customer.pl';

        # if no sessions are used we attach the session as URL parameter
        if ( !$ConfigObject->Get('SessionUseCookie') ) {
            $URL .= "?$SessionName=$NewSessionID";
        }

        # redirect to customer interface with new session id
        return $LayoutObject->Redirect( ExtURL => $URL );
    }

    # search user list
    if ( $Self->{Subaction} eq 'Search' ) {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerUser',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # download file preferences
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Group = $ParamObject->GetParam( Param => 'Group' ) || '';
        my $User  = $ParamObject->GetParam( Param => 'ID' )    || '';
        my $File  = $ParamObject->GetParam( Param => 'File' )  || '';

        # get user data
        my %UserData    = $CustomerUserObject->CustomerUserDataGet( User => $User );
        my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };
        my $Module      = $Preferences{$Group}->{Module};
        if ( !$MainObject->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Group},
            UserObject => $CustomerUserObject,
            Debug      => $Self->{Debug},
        );
        my %File = $Object->Download( UserData => \%UserData );

        return $LayoutObject->Attachment(%File);
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Change' ) {
        my $User         = $ParamObject->GetParam( Param => 'ID' )           || '';
        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';

        # get user data
        my %UserData = $CustomerUserObject->CustomerUserDataGet( User => $User );

        my $Output = $NavBar;
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $User,
            %UserData,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # update only the preferences and dynamic fields, if the source is readonly or a ldap backend
        my $UpdateOnlyPreferences;

        if ( $ConfigObject->Get($Source)->{ReadOnly} || $ConfigObject->Get($Source)->{Module} =~ /LDAP/i ) {
            $UpdateOnlyPreferences = 1;
        }

        my $Note = '';
        my ( %GetParam, %Errors );

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) || '';

                next ENTRY if $UpdateOnlyPreferences;

                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }
        }
        $GetParam{ID} = $ParamObject->GetParam( Param => 'ID' ) || '';

        # check email address
        if (
            !$UpdateOnlyPreferences
            && $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            && grep { $_ eq $GetParam{ValidID} } @ValidIDList
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
        }

        # Get the current user data for some checks.
        my %CurrentUserData = $CustomerUserObject->CustomerUserDataGet(
            User => $GetParam{ID},
        );

        # Check CustomerID, if CustomerCompanySupport is enabled and the UserCustomerID was changed.
        if (
            $ConfigObject->Get($Source)->{CustomerCompanySupport}
            && $GetParam{UserCustomerID}
            && $CurrentUserData{UserCustomerID} ne $GetParam{UserCustomerID}
            )
        {

            my %Company = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
                CustomerID => $GetParam{UserCustomerID},
            );

            if ( !%Company ) {
                $Errors{UserCustomerIDInvalid} = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            my $UpdateSuccess;
            if ( !$UpdateOnlyPreferences ) {
                $UpdateSuccess = $CustomerUserObject->CustomerUserUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                );
            }

            if ( $UpdateSuccess || $UpdateOnlyPreferences ) {

                # set dynamic field values
                my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

                ENTRY:
                for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $Note .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            ),
                        );
                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $GetParam{UserLogin},
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $Note .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                        );
                        next ENTRY;
                    }
                }

                # update preferences
                my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };
                GROUP:
                for my $Group ( sort keys %Preferences ) {
                    next GROUP if $Group eq 'Password';

                    # get user data
                    my %UserData = $CustomerUserObject->CustomerUserDataGet(
                        User => $GetParam{UserLogin}
                    );
                    my $Module = $Preferences{$Group}->{Module};
                    if ( !$MainObject->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $CustomerUserObject,
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( UserData => \%UserData );
                    if (@Params) {
                        my %GetParam;
                        for my $ParamItem (@Params) {
                            my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if (
                            !$Object->Run(
                                GetParam => \%GetParam,
                                UserData => \%UserData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                # clear customer user cache
                $CustomerUserObject->CustomerUserCacheClear(
                    UserLogin => $GetParam{UserLogin},
                );

                # get user data and show screen again
                if ( !$Note ) {

                    # if the user would like to continue editing the priority, just redirect to the edit screen
                    if (
                        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                        )
                    {
                        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
                        return $LayoutObject->Redirect(
                            OP =>
                                "Action=$Self->{Action};Subaction=Change;ID=$ID;Search=$Search;Nav=$Nav;Notification=Update"
                        );
                    }
                    else {

                        # otherwise return to overview
                        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                    }
                }
            }
            else {
                $Note .= $LayoutObject->Notify( Priority => 'Error' );
            }
        }

        # something has gone wrong
        my $Output = $NavBar;
        $Output .= $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            Errors => \%Errors,
            %GetParam,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{UserLogin}  = $ParamObject->GetParam( Param => 'UserLogin' )  || '';
        $GetParam{CustomerID} = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            %GetParam,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        my $AutoLoginCreation = $ConfigObject->Get($Source)->{AutoLoginCreation};

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {

            # don't validate UserLogin if AutoLoginCreation is configured
            next ENTRY if ( $AutoLoginCreation && $Entry->[0] eq 'UserLogin' );

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) || '';
                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }
        }

        # check email address
        if (
            $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            && grep { $_ eq $GetParam{ValidID} } @ValidIDList
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
        }

        # Check CustomerID, if CustomerCompanySupport is enabled.
        if ( $ConfigObject->Get($Source)->{CustomerCompanySupport} && $GetParam{UserCustomerID} ) {

            my %Company = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
                CustomerID => $GetParam{UserCustomerID},
            );

            if ( !%Company ) {
                $Errors{UserCustomerIDInvalid} = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add user
            my $User = $CustomerUserObject->CustomerUserAdd(
                %GetParam,
                UserID => $Self->{UserID},
                Source => $Source
            );
            if ($User) {

                # set dynamic field values
                my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

                ENTRY:
                for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $Note .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            ),
                        );
                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $User,
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $Note .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                        );
                        next ENTRY;
                    }
                }

                # update preferences
                my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };
                GROUP:
                for my $Group ( sort keys %Preferences ) {
                    next GROUP if $Group eq 'Password';

                    # get user data
                    my %UserData = $CustomerUserObject->CustomerUserDataGet(
                        User => $User,
                    );
                    my $Module = $Preferences{$Group}->{Module};
                    if ( !$MainObject->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $CustomerUserObject,
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( %{ $Preferences{$Group} }, UserData => \%UserData );
                    if (@Params) {
                        my %GetParam;
                        for my $ParamItem (@Params) {
                            my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if (
                            !$Object->Run(
                                GetParam => \%GetParam,
                                UserData => \%UserData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                # get user data and show screen again
                if ( !$Note ) {

                    # in borrowed view, take the new created customer over into the new ticket
                    if ( $Nav eq 'None' ) {
                        my $Output = $NavBar;

                        $LayoutObject->AddJSData(
                            Key   => 'Customer',
                            Value => $User,
                        );
                        $LayoutObject->AddJSData(
                            Key   => 'Nav',
                            Value => $Nav,
                        );

                        $Output .= $LayoutObject->Output(
                            TemplateFile => 'AdminCustomerUser',
                            Data         => \%Param,
                        );

                        $Output .= $LayoutObject->Footer( Type => 'Small' );

                        return $Output;
                    }

                    $Self->_Overview(
                        Nav    => $Nav,
                        Search => $Search,
                    );

                    my $Output        = $NavBar . $Note;
                    my $URL           = '';
                    my $UserHTMLQuote = $LayoutObject->LinkEncode($User);
                    my $UserQuote     = $LayoutObject->Ascii2Html( Text => $User );
                    if ( $ConfigObject->Get('Frontend::Module')->{AgentTicketPhone} ) {
                        $URL
                            .= "<a href=\"$LayoutObject->{Baselink}Action=AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=2;CustomerUser=$UserHTMLQuote;$LayoutObject->{ChallengeTokenParam}\">"
                            . $LayoutObject->{LanguageObject}->Translate('New phone ticket')
                            . "</a>";
                    }
                    if ( $ConfigObject->Get('Frontend::Module')->{AgentTicketEmail} ) {
                        if ($URL) {
                            $URL .= " - ";
                        }
                        $URL
                            .= "<a href=\"$LayoutObject->{Baselink}Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=2;CustomerUser=$UserHTMLQuote;$LayoutObject->{ChallengeTokenParam}\">"
                            . $LayoutObject->{LanguageObject}->Translate('New email ticket')
                            . "</a>";
                    }
                    if ($URL) {
                        $Output
                            .= $LayoutObject->Notify(
                            Data => $LayoutObject->{LanguageObject}->Translate(
                                'Customer %s added',
                                $UserQuote,
                                )
                                . " ( $URL )!",
                            );
                    }
                    else {
                        $Output
                            .= $LayoutObject->Notify(
                            Data => $LayoutObject->{LanguageObject}->Translate(
                                'Customer %s added',
                                $UserQuote,
                                )
                                . "!",
                            );
                    }
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminCustomerUser',
                        Data         => \%Param,
                    );

                    if ( $Nav eq 'None' ) {
                        $Output .= $LayoutObject->Footer( Type => 'Small' );
                    }
                    else {
                        $Output .= $LayoutObject->Footer();
                    }

                    return $Output;
                }
            }
            else {
                $Note .= $LayoutObject->Notify( Priority => 'Error' );
            }
        }

        # something has gone wrong
        my $Output = $NavBar . $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            Errors => \%Errors,
            %GetParam,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );

        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';
        my $Output       = $NavBar;
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer user updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerUser',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionSearch',
        Data => \%Param,
    );

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # get writable data sources
    my %CustomerSource = $CustomerUserObject->CustomerSourceList(
        ReadOnly => 0,
    );

    # only show Add option if we have at least one writable backend
    if ( scalar keys %CustomerSource ) {
        $Param{SourceOption} = $LayoutObject->BuildSelection(
            Data       => { %CustomerSource, },
            Name       => 'Source',
            SelectedID => $Param{Source} || '',
            Class      => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'ActionAdd',
            Data => \%Param,
        );
    }

    if ( $Param{Search} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # when there is no data to show, a message is displayed on the table with this colspan
        my $ColSpan = 6;

        # same Limit as $Self->{CustomerUserMap}->{CustomerUserSearchListLimit}
        # smallest Limit from all sources
        my $Limit = 400;
        SOURCE:
        for my $Count ( '', 1 .. 10 ) {
            next SOURCE if !$ConfigObject->Get("CustomerUser$Count");
            my $CustomerUserMap = $ConfigObject->Get("CustomerUser$Count");
            next SOURCE if !$CustomerUserMap->{CustomerUserSearchListLimit};
            if ( $CustomerUserMap->{CustomerUserSearchListLimit} < $Limit ) {
                $Limit = $CustomerUserMap->{CustomerUserSearchListLimit};
            }
        }

        my %ListAllItems = $CustomerUserObject->CustomerSearch(
            Search => $Param{Search},
            Limit  => $Limit + 1,
            Valid  => 0,
        );

        if ( keys %ListAllItems <= $Limit ) {
            my $ListAllItems = keys %ListAllItems;
            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    ListAll => $ListAllItems,
                    Limit   => $Limit,
                },
            );
        }

        my %List = $CustomerUserObject->CustomerSearch(
            Search => $Param{Search},
            Valid  => 0,
        );

        if ( keys %ListAllItems > $Limit ) {
            my $ListAllItems   = keys %ListAllItems;
            my $SearchListSize = keys %List;

            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    SearchListSize => $SearchListSize,
                    ListAll        => $ListAllItems,
                    Limit          => $Limit,
                },
            );
        }

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        if ( $ConfigObject->Get('SwitchToCustomer') && $Self->{SwitchToCustomerPermission} && $Param{Nav} ne 'None' )
        {
            $ColSpan = 7;
            $LayoutObject->Block(
                Name => 'OverviewResultSwitchToCustomer',
            );
        }

        # if there are results to show
        if (%List) {

            # get valid list
            my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
            for my $ListKey ( sort { lc($a) cmp lc($b) } keys %List ) {

                my %UserData = $CustomerUserObject->CustomerUserDataGet( User => $ListKey );
                $UserData{UserFullname} = $CustomerUserObject->CustomerName(
                    UserLogin => $UserData{UserLogin},
                );

                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        Valid       => $ValidList{ $UserData{ValidID} || '' } || '-',
                        Search      => $Param{Search},
                        CustomerKey => $ListKey,
                        %UserData,
                    },
                );
                if ( $Param{Nav} eq 'None' ) {
                    $LayoutObject->Block(
                        Name => 'OverviewResultRowLinkNone',
                        Data => {
                            Search      => $Param{Search},
                            CustomerKey => $ListKey,
                            %UserData,
                        },
                    );
                }
                else {
                    $LayoutObject->Block(
                        Name => 'OverviewResultRowLink',
                        Data => {
                            Search      => $Param{Search},
                            Nav         => $Param{Nav},
                            CustomerKey => $ListKey,
                            %UserData,
                        },
                    );
                }

                if (
                    $ConfigObject->Get('SwitchToCustomer')
                    && $Self->{SwitchToCustomerPermission}
                    && $Param{Nav} ne 'None'
                    )
                {
                    $LayoutObject->Block(
                        Name => 'OverviewResultRowSwitchToCustomer',
                        Data => {
                            Search => $Param{Search},
                            %UserData,
                        },
                    );
                }
            }
        }

        # otherwise it displays a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {
                    ColSpan => $ColSpan,
                },
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'Nav',
        Value => $Param{Nav},
    );

    return;
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    # Get layout object.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = '';

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    if ( $Param{Action} eq 'Change' ) {

        # shows edit header
        $LayoutObject->Block( Name => 'HeaderEdit' );

        # shows effective permissions matrix
        $Self->_EffectivePermissions(%Param);
    }

    # shows add header
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    my $UpdateOnlyPreferences;

    # Get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # update user
    if ( $ConfigObject->Get( $Param{Source} )->{ReadOnly} || $ConfigObject->Get( $Param{Source} )->{Module} =~ /LDAP/i )
    {
        $UpdateOnlyPreferences = 1;
    }

    # Get dynamic field backend object.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $ParamObject               = $Kernel::OM->Get('Kernel::System::Web::Request');

    ENTRY:
    for my $Entry ( @{ $ConfigObject->Get( $Param{Source} )->{Map} } ) {
        next ENTRY if !$Entry->[0];

        # Handle dynamic fields
        if ( $Entry->[5] eq 'dynamic_field' ) {

            my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

            next ENTRY if !IsHashRefWithData($DynamicFieldConfig);

            # Get HTML for dynamic field
            my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Param{ $Entry->[0] } ? $Param{ $Entry->[0] } : undef,
                Mandatory          => $Entry->[4],
                LayoutObject       => $LayoutObject,
                ParamObject        => $ParamObject,

                # Server error, if any
                %{ $Param{Errors}->{ $Entry->[0] } },
            );

            # skip fields for which HTML could not be retrieved
            next ENTRY if !IsHashRefWithData($DynamicFieldHTML);

            $LayoutObject->Block(
                Name => 'Item',
                Data => {},
            );

            $LayoutObject->Block(
                Name => 'DynamicField',
                Data => {
                    Name  => $DynamicFieldConfig->{Name},
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                },
            );

            next ENTRY;
        }

        my $Block = 'Input';

        # check input type
        if ( $Entry->[0] =~ /^UserPasswor/i ) {
            $Block = 'Password';
        }

        # check if login auto creation
        if ( $ConfigObject->Get( $Param{Source} )->{AutoLoginCreation} && $Entry->[0] eq 'UserLogin' ) {
            $Block = 'InputHidden';
        }

        if ( $Entry->[7] || $UpdateOnlyPreferences ) {
            $Param{ReadOnly} = 1;
        }
        else {
            $Param{ReadOnly} = 0;
        }

        # show required flag
        if ( $Entry->[4] ) {
            $Param{RequiredClass}          = 'Validate_Required';
            $Param{RequiredLabelClass}     = 'Mandatory';
            $Param{RequiredLabelCharacter} = '*';
        }
        else {
            $Param{RequiredClass}          = '';
            $Param{RequiredLabelClass}     = '';
            $Param{RequiredLabelCharacter} = '';
        }

        # set empty string
        $Param{Errors}->{ $Entry->[0] . 'Invalid' } ||= '';

        # add class to validate emails
        if ( $Entry->[0] eq 'UserEmail' ) {
            $Param{RequiredClass} .= ' Validate_Email';
        }

        # build selections or input fields
        if ( $ConfigObject->Get( $Param{Source} )->{Selections}->{ $Entry->[0] } ) {
            $Block = 'Option';

            # Change the validation class
            if ( $Param{RequiredClass} ) {
                $Param{RequiredClass} = 'Validate_Required';
            }

            # get the data of the current selection
            my $SelectionsData = $ConfigObject->Get( $Param{Source} )->{Selections}->{ $Entry->[0] };

            # make sure the encoding stamp is set
            for my $Key ( sort keys %{$SelectionsData} ) {
                $SelectionsData->{$Key}
                    = $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $SelectionsData->{$Key} );
            }

            # build option string
            $Param{Option} = $LayoutObject->BuildSelection(
                Data        => $SelectionsData,
                Name        => $Entry->[0],
                Translation => 1,
                SelectedID  => $Param{ $Entry->[0] },
                Class       => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
                Disabled    => $UpdateOnlyPreferences ? 1 : 0,
            );
        }
        elsif ( $Entry->[0] =~ /^ValidID/i ) {

            # Change the validation class
            if ( $Param{RequiredClass} ) {
                $Param{RequiredClass} = 'Validate_Required';
            }

            # build ValidID string
            $Block = 'Option';
            $Param{Option} = $LayoutObject->BuildSelection(
                Data       => { $Kernel::OM->Get('Kernel::System::Valid')->ValidList(), },
                Name       => $Entry->[0],
                SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
                Disabled   => $UpdateOnlyPreferences ? 1 : 0,
            );
        }
        elsif (
            $Entry->[0] =~ /^UserCustomerID$/i
            && $ConfigObject->Get( $Param{Source} )->{CustomerCompanySupport}
            )
        {
            my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
            my %CompanyList           = (
                $CustomerCompanyObject->CustomerCompanyList( Limit => 0 ),
                '' => '-',
            );
            if ( $Param{ $Entry->[0] } ) {
                my %Company = $CustomerCompanyObject->CustomerCompanyGet(
                    CustomerID => $Param{ $Entry->[0] },
                );
                if ( !%Company ) {
                    $CompanyList{ $Param{ $Entry->[0] } } = $Param{ $Entry->[0] } . ' (-)';
                }
            }
            $Block = 'Option';

            # Change the validation class
            if ( $Param{RequiredClass} ) {
                $Param{RequiredClass} = 'Validate_Required';
            }

            my $UseAutoComplete = $Kernel::OM->Get('Kernel::Config')->Get('AdminCustomerUser::UseAutoComplete');

            if ($UseAutoComplete) {

                my $Value = $Param{ $Entry->[0] } || $Param{CustomerID};
                $Param{Option} = '<input type="text" id="UserCustomerID" name="UserCustomerID" value="' . $Value . '"
                    class="W50pc CustomerAutoCompleteSimple '
                    . $Param{RequiredClass} . ' '
                    . $Param{Errors}->{ $Entry->[0] . 'Invalid' }
                    . '" data-customer-search-type="CustomerID" />';
            }
            else {
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data       => \%CompanyList,
                    Name       => $Entry->[0],
                    Max        => 80,
                    SelectedID => $Param{ $Entry->[0] } || $Param{CustomerID},
                    Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
                    Disabled   => $UpdateOnlyPreferences ? 1 : 0,
                );
            }
        }
        elsif ( $Param{Action} eq 'Add' && $Entry->[0] =~ /^UserCustomerID$/i ) {

            # Use CustomerID param if called from CIC.
            $Param{Value} = $Param{ $Entry->[0] } || $Param{CustomerID} || '';
        }
        else {
            $Param{Value} = $Param{ $Entry->[0] } || '';
        }

        # add form option
        if ( $Param{Type} && $Param{Type} eq 'hidden' ) {
            $Param{Preferences} .= $Param{Value};
        }
        else {
            $LayoutObject->Block(
                Name => 'PreferencesGeneric',
                Data => {
                    Item => $Entry->[1],
                    %Param
                },
            );
            $LayoutObject->Block(
                Name => "PreferencesGeneric$Block",
                Data => {
                    Item         => $Entry->[1],
                    Name         => $Entry->[0],
                    InvalidField => $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '',
                    %Param,
                },
            );

            # add the correct client side error msg
            if ( $Block eq 'Input' && $Entry->[0] eq 'UserEmail' ) {
                $LayoutObject->Block(
                    Name => 'PreferencesUserEmailErrorMsg',
                    Data => { Name => $Entry->[0] },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => "PreferencesGenericErrorMsg",
                    Data => { Name => $Entry->[0] },
                );
            }

            # add the correct server error msg
            if ( $Block eq 'Input' && $Param{UserEmail} && $Entry->[0] eq 'UserEmail' ) {

                # display server error msg according with the occurred email error type
                $LayoutObject->Block(
                    Name => 'PreferencesUserEmail' . ( $Param{Errors}->{ErrorType} || '' ),
                    Data => { Name => $Entry->[0] },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => "PreferencesGenericServerErrorMsg",
                    Data => { Name => $Entry->[0] },
                );
            }
        }
    }

    my $PreferencesUsed = $ConfigObject->Get( $Param{Source} )->{AdminSetPreferences};
    if ( ( defined $PreferencesUsed && $PreferencesUsed != 0 ) || !defined $PreferencesUsed ) {

        my %Data;
        my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };

        GROUP:
        for my $Group ( sort keys %Preferences ) {

            next GROUP if !$Group;

            my $PreferencesGroup = $Preferences{$Group};

            next GROUP if !$PreferencesGroup;
            next GROUP if ref $PreferencesGroup ne 'HASH';

            if ( $Data{ $PreferencesGroup->{Prio} } ) {

                COUNT:
                for ( 1 .. 151 ) {

                    $PreferencesGroup->{Prio}++;

                    if ( !$Data{ $PreferencesGroup->{Prio} } ) {
                        $Data{ $PreferencesGroup->{Prio} } = $Group;
                        last COUNT;
                    }
                }
            }

            $Data{ $PreferencesGroup->{Prio} } = $Group;
        }

        # sort
        for my $Key ( sort keys %Data ) {
            $Data{ sprintf "%07d", $Key } = $Data{$Key};
            delete $Data{$Key};
        }

        # show each preferences setting
        PRIO:
        for my $Prio ( sort keys %Data ) {

            my $Group = $Data{$Prio};
            if ( !$ConfigObject->{CustomerPreferencesGroups}->{$Group} ) {
                next PRIO;
            }

            my %Preference = %{ $ConfigObject->{CustomerPreferencesGroups}->{$Group} };
            if ( $Group eq 'Password' ) {
                next PRIO;
            }

            my $Module = $Preference{Module}
                || 'Kernel::Output::HTML::CustomerPreferencesGeneric';

            # load module
            if ( $Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                my $Object = $Module->new(
                    %{$Self},
                    ConfigItem => \%Preference,
                    UserObject => $Kernel::OM->Get('Kernel::System::CustomerUser'),
                    Debug      => $Self->{Debug},
                );
                my @Params = $Object->Param( UserData => \%Param );
                if (@Params) {
                    for my $ParamItem (@Params) {
                        $LayoutObject->Block(
                            Name => 'Item',
                            Data => {%Param},
                        );
                        if (
                            ref $ParamItem->{Data} eq 'HASH'
                            || ref $Preference{Data} eq 'HASH'
                            )
                        {
                            my %BuildSelectionParams = (
                                %Preference,
                                %{$ParamItem},
                            );
                            $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );

                            $ParamItem->{Option} = $LayoutObject->BuildSelection(
                                %BuildSelectionParams,
                            );
                        }

                        $LayoutObject->Block(
                            Name => $ParamItem->{Block} || $Preference{Block} || 'Option',
                            Data => {
                                Group => $Group,
                                %Param,
                                %Data,
                                %Preference,
                                %{$ParamItem},
                            },
                        );
                    }
                }
            }
            else {
                return $LayoutObject->FatalError();
            }
        }
    }

    $LayoutObject->AddJSData(
        Key   => 'Nav',
        Value => $Param{Nav},
    );

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUser',
        Data         => \%Param,
    );
}

sub _EffectivePermissions {
    my ( $Self, %Param ) = @_;

    # only if customer group feature is active
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') ) {
        return 1;
    }

    # get needed objects
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerGroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');

    # show tables
    $LayoutObject->Block(
        Name => 'EffectivePermissions',
    );

    my %Groups;
    my %Permissions;

    # go through permission types
    my @Types = @{ $ConfigObject->Get('System::Customer::Permission') };
    for my $Type (@Types) {

        # show header
        $LayoutObject->Block(
            Name => "HeaderGroupPermissionType",
            Data => {
                Type => $Type,
            },
        );

        # get groups of the user
        my %UserGroups = $CustomerGroupObject->GroupMemberList(
            UserID         => $Param{ID},
            Type           => $Type,
            Result         => 'HASH',
            RawPermissions => 0,            # get effective permissions
        );

        # store data in lookup hashes
        for my $GroupID ( sort keys %UserGroups ) {
            $Groups{$GroupID} = $UserGroups{$GroupID};
            $Permissions{$GroupID}{$Type} = 1;
        }
    }

    # show message if no permissions found
    if ( !%Permissions ) {
        $LayoutObject->Block(
            Name => 'NoGroupPermissionsFoundMsg',
        );
    }

    # go through groups, sort by name
    else {
        for my $GroupID ( sort { uc( $Groups{$a} ) cmp uc( $Groups{$b} ) } keys %Groups ) {

            # show table rows
            $LayoutObject->Block(
                Name => 'GroupPermissionTableRow',
                Data => {
                    ID   => $GroupID,
                    Name => $Groups{$GroupID},
                },
            );

            # show permission marks
            for my $Type (@Types) {
                my $PermissionMark = $Permissions{$GroupID}{$Type} ? 'On'        : 'Off';
                my $HighlightMark  = $Type eq 'rw'                 ? 'Highlight' : '';
                $LayoutObject->Block(
                    Name => 'GroupPermissionMark',
                );
                $LayoutObject->Block(
                    Name => 'GroupPermissionMark' . $PermissionMark,
                    Data => {
                        Highlight => $HighlightMark,
                    },
                );
            }
        }
    }

    # get all accessible customers of the user
    my %Customers = $CustomerGroupObject->GroupContextCustomers(
        CustomerUserID => $Param{ID},
    );

    # show message if no customers found
    if ( !%Customers ) {
        $LayoutObject->Block(
            Name => 'NoCustomerAccessFoundMsg',
        );
        return 1;
    }

    # get permission contexts
    my $ContextConfig            = $ConfigObject->Get('CustomerGroupPermissionContext');
    my $DirectAccessContextKey   = '001-CustomerID-same';
    my $IndirectAccessContextKey = '100-CustomerID-other';

    # use default context if none are found
    if ( !IsHashRefWithData($ContextConfig) ) {
        $ContextConfig = {
            $DirectAccessContextKey => {
                Name => Translatable('Same Customer'),
            },
        };
    }

    # show default and extra context headers if available
    if ( $ContextConfig->{$DirectAccessContextKey} ) {
        $LayoutObject->Block(
            Name => 'HeaderCustomerAccessContext',
            Data => {
                Name => Translatable('Direct'),
            },
        );
    }
    if ( $ContextConfig->{$IndirectAccessContextKey} ) {
        $LayoutObject->Block(
            Name => 'HeaderCustomerAccessContext',
            Data => {
                Name => Translatable('Indirect'),
            },
        );
    }

    # determine customers for direct and indirect access
    my @UserCustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
        User => $Param{ID},
    );
    my %ExtraCustomerIDs;
    if ( $ContextConfig->{$IndirectAccessContextKey} ) {
        my $ExtraContextName = $CustomerGroupObject->GroupContextNameGet(
            SysConfigName => $IndirectAccessContextKey,
        );

        # for all CustomerIDs get groups with extra access
        my %ExtraPermissionGroups;
        CUSTOMERID:
        for my $CustomerID (@UserCustomerIDs) {
            my %GroupList = $CustomerGroupObject->GroupCustomerList(
                CustomerID => $CustomerID,
                Type       => 'ro',
                Context    => $ExtraContextName,
                Result     => 'HASH',
            );
            next CUSTOMERID if !%GroupList;

            # add to groups
            %ExtraPermissionGroups = (
                %ExtraPermissionGroups,
                %GroupList,
            );
        }

        # add all unique accessible Group<->Customer combinations
        GROUPID:
        for my $GroupID ( sort keys %ExtraPermissionGroups ) {
            my @GroupCustomerIDs = $CustomerGroupObject->GroupCustomerList(
                GroupID => $GroupID,
                Type    => 'ro',
                Result  => 'ID',
            );
            next GROUPID if !@GroupCustomerIDs;

            # add to ExtraCustomerIDs
            %ExtraCustomerIDs = (
                %ExtraCustomerIDs,
                map { $_ => 1 } @GroupCustomerIDs,
            );
        }
    }

    # go through customers
    CUSTOMERID:
    for my $CustomerID ( sort keys %Customers ) {

        # show table rows
        $LayoutObject->Block(
            Name => 'CustomerAccessTableRow',
            Data => {
                ID   => $CustomerID,
                Name => $Customers{$CustomerID},
            },
        );

        # 'Same Customer'
        if ( $ContextConfig->{$DirectAccessContextKey} ) {

            # check if we should show check mark for 'Same Customer'
            my $AccessMark = ( grep { $_ eq $CustomerID } @UserCustomerIDs ) ? 'On' : 'Off';

            # show blocks
            $LayoutObject->Block(
                Name => 'CustomerAccessMark',
            );
            $LayoutObject->Block(
                Name => 'CustomerAccessMark' . $AccessMark,
            );
        }

        # 'Other Customers'
        next CUSTOMERID if !$ContextConfig->{$IndirectAccessContextKey};

        # check if we should show check mark for 'Other Customers'
        my $AccessMark = $ExtraCustomerIDs{$CustomerID} ? 'On' : 'Off';

        # show blocks
        $LayoutObject->Block(
            Name => 'CustomerAccessMark',
        );
        $LayoutObject->Block(
            Name => 'CustomerAccessMark' . $AccessMark,
        );
    }

    return 1;
}

1;
