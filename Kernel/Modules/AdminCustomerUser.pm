# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use warnings;

use Kernel::System::CheckItem;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

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
        my $UserID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %UserData = $CustomerUserObject->CustomerUserDataGet(
            User  => $UserID,
            Valid => 1,
        );

        # get groups rw/ro
        for my $Type (qw(rw ro)) {
            my %GroupData = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
                Result => 'HASH',
                Type   => $Type,
                UserID => $UserData{UserID},
            );
            for my $GroupKey ( sort keys %GroupData ) {
                if ( $Type eq 'rw' ) {
                    $UserData{"UserIsGroup[$GroupData{$GroupKey}]"} = 'Yes';
                }
                else {
                    $UserData{"UserIsGroupRo[$GroupData{$GroupKey}]"} = 'Yes';
                }
            }
        }

        # create new session id
        my $NewSessionID = $Kernel::OM->Get('Kernel::System::AuthSession')->CreateSessionID(
            %UserData,
            UserLastRequest => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            UserType        => 'Customer',
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
        my $User = $ParamObject->GetParam( Param => 'ID' ) || '';

        # get user data
        my %UserData = $CustomerUserObject->CustomerUserDataGet( User => $User );
        my $Output = $NavBar;
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

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {
            $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) || '';

            # check mandatory fields
            if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
            }
        }
        $GetParam{ID} = $ParamObject->GetParam( Param => 'ID' ) || '';

        # check email address
        if (
            $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update user
            my $Update = $CustomerUserObject->CustomerUserUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ($Update) {

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

                # get user data and show screen again
                if ( !$Note ) {
                    $Self->_Overview(
                        Nav    => $Nav,
                        Search => $Search,
                    );
                    my $Output = $NavBar . $Note;
                    $Output .= $LayoutObject->Notify( Info => 'Customer updated!' );
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

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get($Source)->{Map} } ) {
            $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) || '';

            # don't validate UserLogin if AutoLoginCreation is configured
            next ENTRY if ( $AutoLoginCreation && $Entry->[0] eq 'UserLogin' );

            # check mandatory fields
            if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
            }
        }

        # check email address
        if (
            $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
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

                        $LayoutObject->Block(
                            Name => 'BorrowedViewSubmitJS',
                            Data => {
                                Customer => $User,
                            },
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
        );

        $LayoutObject->Block(
            Name => 'ActionAdd',
            Data => \%Param,
        );
    }

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {},
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # when there is no data to show, a message is displayed on the table with this colspan
    my $ColSpan = 6;

    if ( $Param{Search} ) {
        my %List = $CustomerUserObject->CustomerSearch(
            Search => $Param{Search},
            Valid  => 0,
        );
        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        if ( $ConfigObject->Get('SwitchToCustomer') && $Self->{SwitchToCustomerPermission} )
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
                        Valid => $ValidList{ $UserData{ValidID} || '' } || '-',
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

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

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

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    ENTRY:
    for my $Entry ( @{ $ConfigObject->Get( $Param{Source} )->{Map} } ) {
        next ENTRY if !$Entry->[0];

        my $Block = 'Input';

        # check input type
        if ( $Entry->[0] =~ /^UserPasswor/i ) {
            $Block = 'Password';
        }

        # check if login auto creation
        if (
            $ConfigObject->Get( $Param{Source} )->{AutoLoginCreation}
            && $Entry->[0] eq 'UserLogin'
            )
        {
            $Block = 'InputHidden';
        }
        if ( $Entry->[7] ) {
            $Param{ReadOnlyType} = 'readonly';
            $Param{ReadOnly}     = '*';
        }
        else {
            $Param{ReadOnlyType} = '';
            $Param{ReadOnly}     = '';
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
                Class       => $Param{RequiredClass} . ' ' . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
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
                Class      => $Param{RequiredClass} . ' ' . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
            );
        }
        elsif (
            $Entry->[0] =~ /^UserCustomerID$/i
            && $ConfigObject->Get( $Param{Source} )->{CustomerCompanySupport}
            )
        {
            my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
            my %CompanyList           = (
                $CustomerCompanyObject->CustomerCompanyList(),
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

            $Param{Option} = $LayoutObject->BuildSelection(
                Data       => \%CompanyList,
                Name       => $Entry->[0],
                Max        => 80,
                SelectedID => $Param{ $Entry->[0] } || $Param{CustomerID},
                Class      => $Param{RequiredClass} . ' ' . $Param{Errors}->{ $Entry->[0] . 'Invalid' },
            );
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

        # extract groups
        my @Groups = @{ $ConfigObject->Get('CustomerPreferencesView') };

        for my $Column (@Groups) {

            my %Data;
            my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };

            GROUP:
            for my $Group ( sort keys %Preferences ) {

                next GROUP if !$Group;
                next GROUP if !$Preferences{$Group}->{Column};
                next GROUP if $Preferences{$Group}->{Column} ne $Column;

                if ( $Data{ $Preferences{$Group}->{Prio} } ) {

                    COUNT:
                    for my $Count ( 1 .. 151 ) {

                        $Preferences{$Group}->{Prio}++;

                        next COUNT if $Data{ $Preferences{$Group}->{Prio} };

                        $Data{ $Preferences{$Group}->{Prio} } = $Group;

                        last COUNT;
                    }
                }

                $Data{ $Preferences{$Group}->{Prio} } = $Group;
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
                                $ParamItem->{Option} = $LayoutObject->BuildSelection(
                                    %Preference, %{$ParamItem},
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
    }

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUser',
        Data         => \%Param,
    );
}

1;
