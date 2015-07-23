# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminUser;

use strict;
use warnings;

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

    # get needed objects
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $LogObject       = $Kernel::OM->Get('Kernel::System::Log');
    my $UserObject      = $Kernel::OM->Get('Kernel::System::User');
    my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    my $Search = $ParamObject->GetParam( Param => 'Search' ) || '';

    # ------------------------------------------------------------ #
    #  switch to user
    # ------------------------------------------------------------ #
    if (
        $Self->{Subaction} eq 'Switch'
        && $ConfigObject->Get('SwitchToUser')
        )
    {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $UserID = $ParamObject->GetParam( Param => 'UserID' ) || '';
        my %UserData = $UserObject->GetUserData(
            UserID        => $UserID,
            NoOutOfOffice => 1,
        );

        # get group object
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # get groups rw
        my %GroupData = $GroupObject->PermissionUserGet(
            UserID => $UserData{UserID},
            Type   => 'rw',
        );
        for my $GroupKey ( sort keys %GroupData ) {
            $UserData{"UserIsGroup[$GroupData{$GroupKey}]"} = 'Yes';
        }

        # get groups ro
        %GroupData = $GroupObject->PermissionUserGet(
            UserID => $UserData{UserID},
            Type   => 'ro',
        );
        for my $GroupKey ( sort keys %GroupData ) {
            $UserData{"UserIsGroupRo[$GroupData{$GroupKey}]"} = 'Yes';
        }
        my $NewSessionID = $Kernel::OM->Get('Kernel::System::AuthSession')->CreateSessionID(
            %UserData,
            UserLastRequest => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            UserType        => 'User',
        );

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

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                %UserData,
                SetCookies => {
                    SessionIDCookie => $ParamObject->SetCookie(
                        Key      => $ConfigObject->Get('SessionName'),
                        Value    => $NewSessionID,
                        Expires  => $Expires,
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => scalar $SecureAttribute,
                        HTTPOnly => 1,
                    ),
                },
                SessionID   => $NewSessionID,
                SessionName => $ConfigObject->Get('SessionName'),
                }
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
        my $LayoutObjectSession = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # log event
        $LogObject->Log(
            Priority => 'notice',
            Message  => "Switched to User ($Self->{UserLogin} -=> $UserData{UserLogin})",
        );

        # redirect with new session id
        return $LayoutObjectSession->Redirect( OP => '' );
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Change' ) {
        my $UserID = $ParamObject->GetParam( Param => 'UserID' )
            || $ParamObject->GetParam( Param => 'ID' )
            || '';
        my %UserData = $UserObject->GetUserData(
            UserID        => $UserID,
            NoOutOfOffice => 1,
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            Search => $Search,
            %UserData,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminUser',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
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
        for my $Parameter (
            qw(UserID UserTitle UserLogin UserFirstname UserLastname UserEmail UserPw UserMobile ValidID Search)
            )
        {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
        $GetParam{Preferences} = $ParamObject->GetParam( Param => 'Preferences' ) || '';

        for my $Needed (qw(UserID UserFirstname UserLastname UserLogin ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check email address
        if (
            $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType();
        }

        # check if a user with this login (username) already exits
        my $UserLoginExists = $UserObject->UserLoginExistsCheck(
            UserLogin => $GetParam{UserLogin},
            UserID    => $GetParam{UserID}
        );
        if ($UserLoginExists) {
            $Errors{UserLoginExists} = 1;
            $Errors{'UserLoginInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors )
        {

            # update user
            my $Update = $UserObject->UserUpdate(
                %GetParam,
                ChangeUserID => $Self->{UserID},
            );

            if ($Update) {
                my %Preferences = %{ $ConfigObject->Get('PreferencesGroups') };

                GROUP:
                for my $Group ( sort keys %Preferences ) {
                    next GROUP if $Group eq 'Password';

                    # get user data
                    my %UserData = $UserObject->GetUserData(
                        UserID        => $GetParam{UserID},
                        NoOutOfOffice => 1,
                    );
                    my $Module = $Preferences{$Group}->{Module};
                    if ( !$MainObject->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }

                    my $Object = $Module->new(
                        %{$Self},
                        UserObject => $UserObject,
                        ConfigItem => $Preferences{$Group},
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( %{ $Preferences{$Group} }, UserData => \%UserData );
                    if (@Params) {
                        my %GetParam;
                        for my $ParamItem (@Params) {
                            my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );
                            if (@Array) {
                                $GetParam{ $ParamItem->{Name} } = \@Array;
                            }
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

                if ( !$Note ) {
                    $Self->_Overview( Search => $Search );
                    my $Output = $LayoutObject->Header();
                    $Output .= $LayoutObject->NavigationBar();
                    $Output .= $LayoutObject->Notify( Info => 'Agent updated!' );
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminUser',
                        Data         => \%Param,
                    );
                    $Output .= $LayoutObject->Footer();
                    return $Output;
                }
            }
            else {
                $Note .= $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }
        my $Output = $LayoutObject->Header();
        $Output .= $Note;
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action    => 'Change',
            Search    => $Search,
            ErrorType => $Errors{ErrorType} || '',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminUser',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();

        $GetParam{UserLogin} = $ParamObject->GetParam( Param => 'UserLogin' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            Search => $Search,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminUser',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
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
        for my $Parameter (
            qw(UserTitle UserLogin UserFirstname UserLastname UserEmail UserPw UserMobile ValidID Search)
            )
        {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
        $GetParam{Preferences} = $ParamObject->GetParam( Param => 'Preferences' ) || '';

        for my $Needed (qw(UserFirstname UserLastname UserLogin UserEmail ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check email address
        if (
            $GetParam{UserEmail}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{UserEmail} )
            )
        {
            $Errors{UserEmailInvalid} = 'ServerError';
            $Errors{ErrorType}        = $CheckItemObject->CheckErrorType();
        }

        # check if a user with this login (username) already exits
        my $UserLoginExists = $UserObject->UserLoginExistsCheck( UserLogin => $GetParam{UserLogin} );
        if ($UserLoginExists) {
            $Errors{UserLoginExists} = 1;
            $Errors{'UserLoginInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors )
        {

            # add user
            my $UserID = $UserObject->UserAdd(
                %GetParam,
                ChangeUserID => $Self->{UserID}
            );

            if ($UserID) {

                # update preferences
                my %Preferences = %{ $ConfigObject->Get('PreferencesGroups') };
                GROUP:
                for my $Group ( sort keys %Preferences ) {
                    next GROUP if $Group eq 'Password';

                    # get user data
                    my %UserData = $UserObject->GetUserData(
                        UserID        => $UserID,
                        NoOutOfOffice => 1,
                    );
                    my $Module = $Preferences{$Group}->{Module};
                    if ( $MainObject->Require($Module) ) {

                        # TODO: Change this to Object Manager
                        my $Object = $Module->new(
                            %{$Self},
                            UserObject => $UserObject,
                            ConfigItem => $Preferences{$Group},
                            Debug      => $Self->{Debug},
                        );
                        my @Params = $Object->Param( UserData => \%UserData );

                        if (@Params) {
                            my %GetParam = ();
                            PARAMITEM:
                            for my $ParamItem (@Params) {
                                next PARAMITEM if !$ParamItem->{Name};
                                my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );

                                $GetParam{ $ParamItem->{Name} } = \@Array;
                            }
                            if (
                                !$Object->Run(
                                    GetParam => \%GetParam,
                                    UserData => \%UserData,
                                )
                                )
                            {
                                $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                            }
                        }
                    }
                    else {
                        return $LayoutObject->FatalError();
                    }
                }

                # redirect
                if (
                    !$ConfigObject->Get('Frontend::Module')->{AdminUserGroup}
                    && $ConfigObject->Get('Frontend::Module')->{AdminRoleUser}
                    )
                {
                    return $LayoutObject->Redirect(
                        OP => "Action=AdminRoleUser;Subaction=User;ID=$UserID",
                    );
                }
                if ( $ConfigObject->Get('Frontend::Module')->{AdminUserGroup} ) {
                    return $LayoutObject->Redirect(
                        OP => "Action=AdminUserGroup;Subaction=User;ID=$UserID",
                    );
                }
                else {
                    return $LayoutObject->Redirect(
                        OP => 'Action=AdminUser',
                    );
                }
            }
            else {
                $Note .= $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }
        my $Output = $LayoutObject->Header();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action    => 'Add',
            Search    => $Search,
            ErrorType => $Errors{ErrorType} || '',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminUser',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview( Search => $Search );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminUser',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
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
        $LayoutObject->Block( Name => 'MarkerMandatory' );
        $LayoutObject->Block(
            Name => 'ShowPasswordHint',
        );
    }

    # add the correct server error message
    if ( $Param{UserEmail} && $Param{ErrorType} ) {

        # display server error message according with the occurred email error type
        $LayoutObject->Block(
            Name => 'UserEmail' . $Param{ErrorType} . 'ServerErrorMsg',
            Data => {},
        );
    }
    else {
        $LayoutObject->Block(
            Name => "UserEmailServerErrorMsg",
            Data => {},
        );
    }

    # show appropriate messages for ServerError
    if ( defined $Param{UserLoginExists} && $Param{UserLoginExists} == 1 ) {
        $LayoutObject->Block( Name => 'ExistUserLoginServerError' );
    }
    else {
        $LayoutObject->Block( Name => 'UserLoginServerError' );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my @Groups = @{ $ConfigObject->Get('PreferencesView') };
    for my $Column (@Groups) {
        my %Data        = ();
        my %Preferences = %{ $ConfigObject->Get('PreferencesGroups') };

        GROUP:
        for my $Group ( sort keys %Preferences ) {
            next GROUP if $Preferences{$Group}->{Column} ne $Column;

            if ( $Data{ $Preferences{$Group}->{Prio} } ) {
                COUNT:
                for ( 1 .. 151 ) {
                    $Preferences{$Group}->{Prio}++;
                    if ( !$Data{ $Preferences{$Group}->{Prio} } ) {
                        $Data{ $Preferences{$Group}->{Prio} } = $Group;
                        last COUNT;
                    }
                }
            }
            $Data{ $Preferences{$Group}->{Prio} } = $Group;
        }

        # sort
        for my $Key ( sort keys %Data ) {
            $Data{ sprintf( "%07d", $Key ) } = $Data{$Key};
            delete $Data{$Key};
        }

        # show each preferences setting
        PRIO:
        for my $Prio ( sort keys %Data ) {
            my $Group = $Data{$Prio};
            if ( !$ConfigObject->{PreferencesGroups}->{$Group} ) {
                next PRIO;
            }
            my %Preference = %{ $ConfigObject->{PreferencesGroups}->{$Group} };
            if ( $Group eq 'Password' ) {
                next PRIO;
            }
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::Preferences::Generic';

            # load module
            if ( $Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {

                # TODO: This needs to be changed to Object Manager
                my $Object = $Module->new(
                    %{$Self},
                    UserObject => $Kernel::OM->Get('Kernel::System::User'),
                    ConfigItem => \%Preference,
                    Debug      => $Self->{Debug},
                );
                my @Params = $Object->Param( UserData => \%Param );
                if (@Params) {
                    for my $ParamItem (@Params) {
                        $LayoutObject->Block(
                            Name => 'Item',
                            Data => { %Param, },
                        );
                        if (
                            ref( $ParamItem->{Data} ) eq 'HASH'
                            || ref( $Preference{Data} ) eq 'HASH'
                            )
                        {
                            my %BuildSelectionParams = (
                                %Preference,
                                %{$ParamItem},
                            );
                            $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );

                            $ParamItem->{'Option'} = $LayoutObject->BuildSelection(
                                %BuildSelectionParams,
                            );
                        }
                        $LayoutObject->Block(
                            Name => $ParamItem->{Block} || $Preference{Block} || 'Option',
                            Data => {
                                Group => $Group,
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
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # when there is no data to show, a message is displayed on the table with this colspan
    my $ColSpan = 7;

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionSearch' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {},
    );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $ConfigObject->Get('SwitchToUser') ) {
        $ColSpan = 8;
        $LayoutObject->Block(
            Name => 'OverviewResultSwitchToUser',
        );
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %List = $UserObject->UserSearch(
        Search => $Param{Search} . '*',
        Limit  => 400,
        Valid  => 0,
    );

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # if there are results to show
    if (%List) {
        for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %UserData = $UserObject->GetUserData(
                UserID        => $ListKey,
                NoOutOfOffice => 1,
            );
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid  => $ValidList{ $UserData{ValidID} },
                    Search => $Param{Search},
                    %UserData,
                },
            );
            if ( $ConfigObject->Get('SwitchToUser') ) {
                $LayoutObject->Block(
                    Name => 'OverviewResultRowSwitchToUser',
                    Data => {
                        Search => $Param{Search},
                        %UserData,
                    },
                );
            }
        }
    }

    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {
                ColSpan => $ColSpan,
            },
        );
    }

    return 1;
}

1;
