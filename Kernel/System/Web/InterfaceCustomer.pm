# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfaceCustomer;

use strict;
use warnings;

use Kernel::System::Email;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::CustomerAuth',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Scheduler',
    'Kernel::System::Time',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::Web::InterfaceCustomer - the customer web interface

=head1 SYNOPSIS

the global customer web interface (incl. auth, session, ...)

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create customer web interface object

    use Kernel::System::Web::InterfaceCustomer;

    my $Debug = 0;
    my $InterfaceCustomer = Kernel::System::Web::InterfaceCustomer->new(
        Debug      => $Debug,
        WebRequest => CGI::Fast->new(), # optional, e. g. if fast cgi is used, the CGI object is already provided
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # performance log
    $Self->{PerformanceLogStart} = time();

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix'),
        },
        'Kernel::System::Web::Request' => {
            WebRequest => $Param{WebRequest} || 0,
        },
    );

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Global handle started...',
        );
    }

    return $Self;
}

=item Run()

execute the object

    $InterfaceCustomer->Run();

=cut

sub Run {
    my $Self = shift;

    # get common framework params
    my %Param;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get session id
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName') || 'CSID';
    $Param{SessionID} = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ENV{QUERY_STRING} || '';
    $QueryString =~ s/(\?|&|;|)$Param{SessionName}(=&|=;|=.+?&|=.+?$)/;/g;

    # define framework params
    my $FrameworkParams = {
        Lang         => '',
        Action       => '',
        Subaction    => '',
        RequestedURL => $QueryString,
    };
    for my $Key ( sort keys %{$FrameworkParams} ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key )
            || $FrameworkParams->{$Key};
    }

    # validate language
    if ( $Param{Lang} && $Param{Lang} !~ m{\A[a-z]{2}(?:_[A-Z]{2})?\z}xms ) {
        delete $Param{Lang};
    }

    my $BrowserHasCookie = 0;

    # Check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $ConfigObject->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $ParamObject->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    my $CookieSecureAttribute;
    if ( $ConfigObject->Get('HttpType') eq 'https' ) {

        # Restrict Cookie to HTTPS if it is used.
        $CookieSecureAttribute = 1;
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang => $Param{Lang},
        },
        'Kernel::Language' => {
            UserLanguage => $Param{Lang},
        },
    );

    my $DBCanConnect = $Kernel::OM->Get('Kernel::System::DB')->Connect();

    if ( !$DBCanConnect || $ParamObject->Error() ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if ( !$DBCanConnect ) {
            $LayoutObject->CustomerFatalError(
                Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator'),
            );
            return;
        }
        if ( $ParamObject->Error() ) {
            $LayoutObject->CustomerFatalError(
                Message => $ParamObject->Error(),
                Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator'),
            );
            return;
        }
    }

    my $UserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # get common application and add on application params
    my %CommonObjectParam = %{ $ConfigObject->Get('CustomerFrontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non-word chars)
    $Param{Action} =~ s/\W//g;

    # check request type
    if ( $Param{Action} eq 'PreLogin' ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # login screen
        $LayoutObject->Print(
            Output => \$LayoutObject->CustomerLogin(
                Title => 'Login',
                Mode  => 'PreLogin',
                %Param,
            ),
        );

        return;
    }
    elsif ( $Param{Action} eq 'Login' ) {

        # get params
        my $PostUser = $ParamObject->GetParam( Param => 'User' ) || '';
        my $PostPw = $ParamObject->GetParam(
            Param => 'Password',
            Raw   => 1
        ) || '';
        my $PostTwoFactorToken = $ParamObject->GetParam(
            Param => 'TwoFactorToken',
            Raw   => 1
        ) || '';

        # create AuthObject
        my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

        # check submitted data
        my $User = $AuthObject->Auth(
            User           => $PostUser,
            Pw             => $PostPw,
            TwoFactorToken => $PostTwoFactorToken,
        );

        my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
        if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
            $Expires = '';
        }

        # login is invalid
        if ( !$User ) {
            $Kernel::OM->ObjectParamAdd(
                'Kernel::Output::HTML::Layout' => {
                    SetCookies => {
                        OTRSBrowserHasCookie => $ParamObject->SetCookie(
                            Key      => 'OTRSBrowserHasCookie',
                            Value    => 1,
                            Expires  => $Expires,
                            Path     => $ConfigObject->Get('ScriptAlias'),
                            Secure   => $CookieSecureAttribute,
                            HTTPOnly => 1,
                        ),
                    },
                },
            );

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=LoginFailed;RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
                        Type => 'Info',
                        What => 'Message',
                        )
                        || $AuthObject->GetLastErrorMessage()
                        || $LayoutObject->{LanguageObject}
                        ->Translate('Login failed! Your user name or password was entered incorrectly.'),
                    User        => $PostUser,
                    LoginFailed => 1,
                    %Param,
                ),
            );
            return;
        }

        # login is successful
        my %UserData = $UserObject->CustomerUserDataGet(
            User  => $User,
            Valid => 1
        );

        # check if the browser supports cookies
        if ( $ParamObject->GetCookie( Key => 'OTRSBrowserHasCookie' ) ) {
            $Kernel::OM->ObjectParamAdd(
                'Kernel::Output::HTML::Layout' => {
                    BrowserHasCookie => 1,
                },
            );
        }

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . '?Reason=SystemError',
                );
                return;
            }

            # show need user data error message
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Panic!',
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate(
                        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.'
                        ),
                    %Param,
                ),
            );
            return;
        }

        # get groups rw/ro
        for my $Type (qw(rw ro)) {
            my %GroupData = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
                Result => 'HASH',
                Type   => $Type,
                UserID => $UserData{UserID},
            );
            for ( sort keys %GroupData ) {
                if ( $Type eq 'rw' ) {
                    $UserData{"UserIsGroup[$GroupData{$_}]"} = 'Yes';
                }
                else {
                    $UserData{"UserIsGroupRo[$GroupData{$_}]"} = 'Yes';
                }
            }
        }

        # create new session id
        my $NewSessionID = $SessionObject->CreateSessionID(
            %UserData,
            UserLastRequest => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            UserType        => 'Customer',
        );

        # show error message if no session id has been created
        if ( !$NewSessionID ) {

            # get error message
            my $Error = $SessionObject->SessionIDErrorMessage() || '';

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # output error message
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $Error,
                    %Param,
                ),
            );
            return;
        }

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        # execution in 20 seconds
        my $ExecutionTime = $TimeObject->SystemTime2TimeStamp(
            SystemTime => ( $TimeObject->SystemTime() + 20 ),
        );

        # add a asychronous executor scheduler task to count the concurrent user
        $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
            ExecutionTime            => $ExecutionTime,
            Type                     => 'AsynchronousExecutor',
            Name                     => 'PluginAsynchronous::ConcurrentUser',
            MaximumParallelInstances => 1,
            Data                     => {
                Object   => 'Kernel::System::SupportDataCollector::PluginAsynchronous::OTRS::ConcurrentUsers',
                Function => 'RunAsynchronous',
            },
        );

        # set time zone offset if TimeZoneFeature is active
        if (
            $ConfigObject->Get('TimeZoneUser')
            && $ConfigObject->Get('TimeZoneUserBrowserAutoOffset')
            )
        {
            my $TimeOffset = $ParamObject->GetParam( Param => 'TimeOffset' ) || 0;
            if ( $TimeOffset > 0 ) {
                $TimeOffset = '-' . ( $TimeOffset / 60 );
            }
            else {
                $TimeOffset = ( $TimeOffset / 60 );
                $TimeOffset =~ s/-/+/;
            }
            $UserObject->SetPreferences(
                UserID => $UserData{UserID},
                Key    => 'UserTimeZone',
                Value  => $TimeOffset,
            );
            $SessionObject->UpdateSessionID(
                SessionID => $NewSessionID,
                Key       => 'UserTimeZone',
                Value     => $TimeOffset,
            );
        }

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                SetCookies => {
                    SessionIDCookie => $ParamObject->SetCookie(
                        Key      => $Param{SessionName},
                        Value    => $NewSessionID,
                        Expires  => $Expires,
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => scalar $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),
                    OTRSBrowserHasCookie => $ParamObject->SetCookie(
                        Key      => 'OTRSBrowserHasCookie',
                        Value    => '',
                        Expires  => '-1y',
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),

                },
                SessionID   => $NewSessionID,
                SessionName => $Param{SessionName},
            },
        );

        # redirect with new session id and old params
        # prepare old redirect URL -- do not redirect to Login or Logout (loop)!
        if ( $Param{RequestedURL} =~ /Action=(Logout|Login|LostPassword|PreLogin)/ ) {
            $Param{RequestedURL} = '';
        }

        # redirect with new session id
        print $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect(
            OP    => $Param{RequestedURL},
            Login => 1,
        );
        return 1;
    }

    # logout
    elsif ( $Param{Action} eq 'Logout' ) {

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # new layout object
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID;RequestedURL=$Param{RequestedURL}",
                );
            }

            # show login screen
            print $LayoutObject->CustomerLogin(
                Title   => 'Logout',
                Message => $LayoutObject->{LanguageObject}->Translate('Session invalid. Please log in again.'),
                %Param,
            );
            return;
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        # create new LayoutObject with new '%Param' and '%UserData'
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                SetCookies => {
                    SessionIDCookie => $ParamObject->SetCookie(
                        Key      => $Param{SessionName},
                        Value    => '',
                        Expires  => '-1y',
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => scalar $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),
                },
                %Param,
                %UserData,
            },
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # remove session id
        if ( !$SessionObject->RemoveSessionID( SessionID => $Param{SessionID} ) ) {
            $LayoutObject->CustomerFatalError(
                Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator')
            );
            return;
        }

        # redirect to alternate login
        if ( $ConfigObject->Get('CustomerPanelLogoutURL') ) {
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLogoutURL')
                    . "?Reason=Logout",
            );
        }

        # show logout screen
        my $LogoutMessage = $LayoutObject->{LanguageObject}->Translate(
            'Logout successful. Thank you for using %s!',
            $ConfigObject->Get("ProductName"),
        );

        $LayoutObject->Print(
            Output => \$LayoutObject->CustomerLogin(
                Title       => 'Logout',
                Message     => $LogoutMessage,
                MessageType => 'Success',
                %Param,
            ),
        );
        return 1;
    }

    # CustomerLostPassword
    elsif ( $Param{Action} eq 'CustomerLostPassword' ) {

        # new layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check feature
        if ( !$ConfigObject->Get('CustomerPanelLostPassword') ) {

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $LayoutObject->{LanguageObject}->Translate('Feature not active!'),
                ),
            );
            return;
        }

        # get params
        my $User  = $ParamObject->GetParam( Param => 'User' )  || '';
        my $Token = $ParamObject->GetParam( Param => 'Token' ) || '';

        # get user login by token
        if ( !$User && $Token ) {
            my %UserList = $UserObject->SearchPreferences(
                Key   => 'UserToken',
                Value => $Token,
            );
            USER_ID:
            for my $UserID ( sort keys %UserList ) {
                my %UserData = $UserObject->CustomerUserDataGet(
                    User  => $UserID,
                    Valid => 1,
                );
                if (%UserData) {
                    $User = $UserData{UserLogin};
                    last USER_ID;
                }
            }
        }

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet( User => $User );
        if ( !$UserData{UserID} ) {

            # Security: pretend that password reset instructions were actually sent to
            #   make sure that users cannot find out valid usernames by
            #   just trying and checking the result message.
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $LayoutObject->{LanguageObject}
                        ->Translate('Sent password reset instructions. Please check your email.'),
                    MessageType => 'Success',
                ),
            );
            return;
        }

        # create email object
        my $EmailObject = Kernel::System::Email->new( %{$Self} );

        # send password reset token
        if ( !$Token ) {

            # generate token
            $UserData{Token} = $UserObject->TokenGenerate(
                UserID => $UserData{UserID},
            );

            # send token notify email with link
            my $Body = $ConfigObject->Get('CustomerPanelBodyLostPasswordToken')
                || 'ERROR: CustomerPanelBodyLostPasswordToken is missing!';
            my $Subject = $ConfigObject->Get('CustomerPanelSubjectLostPasswordToken')
                || 'ERROR: CustomerPanelSubjectLostPasswordToken is missing!';
            for ( sort keys %UserData ) {
                $Body =~ s/<OTRS_$_>/$UserData{$_}/gi;
            }
            my $Sent = $EmailObject->Send(
                To       => $UserData{UserEmail},
                Subject  => $Subject,
                Charset  => $LayoutObject->{UserCharset},
                MimeType => 'text/plain',
                Body     => $Body
            );
            if ( !$Sent ) {
                $LayoutObject->FatalError(
                    Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator'),
                );
                return;
            }
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $LayoutObject->{LanguageObject}
                        ->Translate('Sent password reset instructions. Please check your email.'),
                    %Param,
                    MessageType => 'Success',
                ),
            );
            return 1;

        }

        # reset password
        # check if token is valid
        my $TokenValid = $UserObject->TokenCheck(
            Token  => $Token,
            UserID => $UserData{UserID},
        );
        if ( !$TokenValid ) {
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => 'Invalid Token!',
                    %Param,
                ),
            );
            return;
        }

        # get new password
        $UserData{NewPW} = $UserObject->GenerateRandomPassword();

        # update new password
        my $Success = $UserObject->SetPassword(
            UserLogin => $User,
            PW        => $UserData{NewPW}
        );

        if ( !$Success ) {
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        $LayoutObject->{LanguageObject}
                        ->Translate('Reset password unsuccessful. Please contact your administrator'),
                    User => $User,
                ),
            );
            return;
        }

        # send notify email
        my $Body = $ConfigObject->Get('CustomerPanelBodyLostPassword')
            || 'New Password is: <OTRS_NEWPW>';
        my $Subject = $ConfigObject->Get('CustomerPanelSubjectLostPassword')
            || 'New Password!';
        for ( sort keys %UserData ) {
            $Body =~ s/<OTRS_$_>/$UserData{$_}/gi;
        }
        my $Sent = $EmailObject->Send(
            To       => $UserData{UserEmail},
            Subject  => $Subject,
            Charset  => $LayoutObject->{UserCharset},
            MimeType => 'text/plain',
            Body     => $Body
        );
        if ( !$Sent ) {
            $LayoutObject->CustomerFatalError(
                Comment => 'Please contact your administrator'
            );
            return;
        }
        my $Message = $LayoutObject->{LanguageObject}->Translate(
            'Sent new password to %s. Please check your email.',
            $UserData{UserEmail},
        );
        $LayoutObject->Print(
            Output => \$LayoutObject->CustomerLogin(
                Title       => 'Login',
                Message     => $Message,
                User        => $User,
                MessageType => 'Success',
            ),
        );
        return 1;
    }

    # create new customer account
    elsif ( $Param{Action} eq 'CustomerCreateAccount' ) {

        # new layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check feature
        if ( !$ConfigObject->Get('CustomerPanelCreateAccount') ) {

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => $LayoutObject->{LanguageObject}->Translate('Feature not active!'),
                ),
            );
            return;
        }

        # get params
        my %GetParams;
        for my $Entry ( @{ $ConfigObject->Get('CustomerUser')->{Map} } ) {
            $GetParams{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[1] )
                || '';
        }
        $GetParams{ValidID} = 1;

        # check needed params
        if ( !$GetParams{UserCustomerID} ) {
            $GetParams{UserCustomerID} = $GetParams{UserEmail};
        }
        if ( !$GetParams{UserLogin} ) {
            $GetParams{UserLogin} = $GetParams{UserEmail};
        }

        # get new password
        $GetParams{UserPassword} = $UserObject->GenerateRandomPassword();

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet( User => $GetParams{UserLogin} );
        if ( $UserData{UserID} || !$GetParams{UserLogin} ) {
            $LayoutObject->Block( Name => 'SignupError' );
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        $LayoutObject->{LanguageObject}
                        ->Translate('This e-mail address already exists. Please log in or reset your password.'),
                    UserTitle     => $GetParams{UserTitle},
                    UserFirstname => $GetParams{UserFirstname},
                    UserLastname  => $GetParams{UserLastname},
                    UserEmail     => $GetParams{UserEmail},
                ),
            );
            return;
        }

        # check for mail address restrictions
        my @Whitelist = @{
            $ConfigObject->Get('CustomerPanelCreateAccount::MailRestrictions::Whitelist') // []
        };
        my @Blacklist = @{
            $ConfigObject->Get('CustomerPanelCreateAccount::MailRestrictions::Blacklist') // []
        };

        my $WhitelistMatched;
        for my $WhitelistEntry (@Whitelist) {
            my $Regex = eval {qr/$WhitelistEntry/i};
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate(
                        'The customer panel mail address whitelist contains the invalid regular expression $WhitelistEntry, please check and correct it.'
                        ),
                );
            }
            elsif ( $GetParams{UserEmail} =~ $Regex ) {
                $WhitelistMatched++;
            }
        }
        my $BlacklistMatched;
        for my $BlacklistEntry (@Blacklist) {
            my $Regex = eval {qr/$BlacklistEntry/i};
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate(
                        'The customer panel mail address blacklist contains the invalid regular expression $BlacklistEntry, please check and correct it.'
                        ),
                );
            }
            elsif ( $GetParams{UserEmail} =~ $Regex ) {
                $BlacklistMatched++;
            }
        }

        if ( ( @Whitelist && !$WhitelistMatched ) || ( @Blacklist && $BlacklistMatched ) ) {
            $LayoutObject->Block( Name => 'SignupError' );
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        $LayoutObject->{LanguageObject}
                        ->Translate('This email address is not allowed to register. Please contact support staff.'),
                    UserTitle     => $GetParams{UserTitle},
                    UserFirstname => $GetParams{UserFirstname},
                    UserLastname  => $GetParams{UserLastname},
                    UserEmail     => $GetParams{UserEmail},
                ),
            );

            return;
        }

        # create account
        my $Now = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
            SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
        );
        my $Add = $UserObject->CustomerUserAdd(
            %GetParams,
            Comment => "Added via Customer Panel ($Now)",
            ValidID => 1,
            UserID  => $ConfigObject->Get('CustomerPanelUserID'),
        );
        if ( !$Add ) {
            $LayoutObject->Block( Name => 'SignupError' );
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title         => 'Login',
                    Message       => 'Customer user can\'t be added!',
                    UserTitle     => $GetParams{UserTitle},
                    UserFirstname => $GetParams{UserFirstname},
                    UserLastname  => $GetParams{UserLastname},
                    UserEmail     => $GetParams{UserEmail},
                ),
            );
            return;
        }

        # send notify email
        my $EmailObject = Kernel::System::Email->new( %{$Self} );
        my $Body        = $ConfigObject->Get('CustomerPanelBodyNewAccount')
            || 'No Config Option found!';
        my $Subject = $ConfigObject->Get('CustomerPanelSubjectNewAccount')
            || 'New OTRS Account!';
        for ( sort keys %GetParams ) {
            $Body =~ s/<OTRS_$_>/$GetParams{$_}/gi;
        }

        # send account info
        my $Sent = $EmailObject->Send(
            To       => $GetParams{UserEmail},
            Subject  => $Subject,
            Charset  => $LayoutObject->{UserCharset},
            MimeType => 'text/plain',
            Body     => $Body
        );
        if ( !$Sent ) {
            my $Output = $LayoutObject->CustomerHeader(
                Area  => 'Core',
                Title => 'Error'
            );
            $Output .= $LayoutObject->CustomerWarning(
                Comment => 'Can\'t send account info!'
            );
            $Output .= $LayoutObject->CustomerFooter();
            $LayoutObject->Print( Output => \$Output );
            return;
        }

        # show sent account info
        if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                    . "?RequestedURL=$Param{RequestedURL};User=$GetParams{UserLogin};"
                    . "Email=$GetParams{UserEmail};Reason=NewAccountCreated",
            );
            return 1;
        }

        my $AccountCreatedMessage = $LayoutObject->{LanguageObject}->Translate(
            'New account created. Sent login information to %s. Please check your email.',
            $GetParams{UserEmail},
        );

        # login screen
        $LayoutObject->Print(
            Output => \$LayoutObject->CustomerLogin(
                Title       => 'Login',
                Message     => $AccountCreatedMessage,
                User        => $GetParams{UserLogin},
                MessageType => 'Success',
            ),
        );
        return 1;
    }

    # show login site
    elsif ( !$Param{SessionID} ) {

        # new layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # create AuthObject
        my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');
        if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

            # automatic login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                OP => "Action=PreLogin;RequestedURL=$Param{RequestedURL}",
            );
            return;
        }
        elsif ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                    . "?RequestedURL=$Param{RequestedURL}",
            );
            return;
        }

        # login screen
        $LayoutObject->Print(
            Output => \$LayoutObject->CustomerLogin(
                Title => 'Login',
                %Param,
            ),
        );
        return 1;
    }

    # run modules if a version value exists
    elsif ( $Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # create new LayoutObject with new '%Param'
            $Kernel::OM->ObjectParamAdd(
                'Kernel::Output::HTML::Layout' => {
                    SetCookies => {
                        SessionIDCookie => $ParamObject->SetCookie(
                            Key      => $Param{SessionName},
                            Value    => '',
                            Expires  => '-1y',
                            Path     => $ConfigObject->Get('ScriptAlias'),
                            Secure   => scalar $CookieSecureAttribute,
                            HTTPOnly => 1,
                        ),
                    },
                    %Param,
                    }
            );

            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # create AuthObject
            my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');
            if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

                # automatic re-login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    OP => "?Action=PreLogin&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # redirect to alternate login
            elsif ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID;RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show login
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate( $SessionObject->SessionIDErrorMessage() ),
                    %Param,
                ),
            );
            return;
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} || $UserData{UserType} ne 'Customer' ) {
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=SystemError",
                );
                return;
            }

            # show login screen
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Panic!',
                    Message => $LayoutObject->{LanguageObject}->Translate('Panic! Invalid Session!!!'),
                    %Param,
                ),
            );
            return;
        }

        # module registry
        my $ModuleReg = $ConfigObject->Get('CustomerFrontend::Module')->{ $Param{Action} };
        if ( !$ModuleReg ) {

            # new layout object
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
            );
            $LayoutObject->CustomerFatalError(
                Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator'),
            );
            return;
        }

        # module permisson check
        if ( !$ModuleReg->{GroupRo} && !$ModuleReg->{Group} ) {
            $Param{AccessRo} = 1;
            $Param{AccessRw} = 1;
        }
        else {
            PERMISSION:
            for my $Permission (qw(GroupRo Group)) {
                my $AccessOk = 0;
                my $Group    = $ModuleReg->{$Permission};
                my $Key      = "UserIs$Permission";
                next PERMISSION if !$Group;
                if ( ref $Group eq 'ARRAY' ) {
                    GROUP:
                    for ( @{$Group} ) {
                        next GROUP if !$_;
                        next GROUP if !$UserData{ $Key . "[$_]" };
                        next GROUP if $UserData{ $Key . "[$_]" } ne 'Yes';
                        $AccessOk = 1;
                        last GROUP;
                    }
                }
                else {
                    if ( $UserData{ $Key . "[$Group]" } && $UserData{ $Key . "[$Group]" } eq 'Yes' )
                    {
                        $AccessOk = 1;
                    }
                }
                if ( $Permission eq 'Group' && $AccessOk ) {
                    $Param{AccessRo} = 1;
                    $Param{AccessRw} = 1;
                }
                elsif ( $Permission eq 'GroupRo' && $AccessOk ) {
                    $Param{AccessRo} = 1;
                }
            }
            if ( !$Param{AccessRo} ) {

                # new layout object
                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'No Permission to use this frontend module!'
                );
                $LayoutObject->CustomerFatalError( Comment => 'Please contact your administrator' );
                return;
            }
        }

        # create new LayoutObject with new '%Param' and '%UserData'
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                %Param,
                %UserData,
                ModuleReg => $ModuleReg,
            },
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # update last request time
        if ( !$ParamObject->IsAJAXRequest() ) {
            $SessionObject->UpdateSessionID(
                SessionID => $Param{SessionID},
                Key       => 'UserLastRequest',
                Value     => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            );
        }

        # pre application module
        my $PreModule = $ConfigObject->Get('CustomerPanelPreApplicationModule');
        if ($PreModule) {
            my %PreModuleList;
            if ( ref $PreModule eq 'HASH' ) {
                %PreModuleList = %{$PreModule};
            }
            else {
                $PreModuleList{Init} = $PreModule;
            }

            MODULE:
            for my $PreModuleKey ( sort keys %PreModuleList ) {
                my $PreModule = $PreModuleList{$PreModuleKey};
                next MODULE if !$PreModule;
                next MODULE if !$Kernel::OM->Get('Kernel::System::Main')->Require($PreModule);

                # debug info
                if ( $Self->{Debug} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "CustomerPanelPreApplication module $PreModule is used.",
                    );
                }

                # use module
                my $PreModuleObject = $PreModule->new(
                    %Param,
                    %UserData,

                );
                my $Output = $PreModuleObject->PreRun();
                if ($Output) {
                    $LayoutObject->Print( Output => \$Output );
                    return 1;
                }
            }
        }

        # debug info
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
            );
        }

        my $FrontendObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %Param,
            %UserData,
            ModuleReg => $ModuleReg,
        );

        # debug info
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
            );
        }

        # ->Run $Action with $FrontendObject
        $LayoutObject->Print( Output => \$FrontendObject->Run() );

        # log request time
        if ( $ConfigObject->Get('PerformanceLog') ) {
            if ( ( !$QueryString && $Param{Action} ) || $QueryString !~ /Action=/ ) {
                $QueryString = 'Action=' . $Param{Action} . ';Subaction=' . $Param{Subaction};
            }
            my $File = $ConfigObject->Get('PerformanceLog::File');
            ## no critic
            if ( open my $Out, '>>', $File ) {
                ## use critic
                print $Out time()
                    . '::Customer::'
                    . ( time() - $Self->{PerformanceLogStart} )
                    . "::$UserData{UserLogin}::$QueryString\n";
                close $Out;
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => 'Response::Customer: '
                        . ( time() - $Self->{PerformanceLogStart} )
                        . "s taken (URL:$QueryString:$UserData{UserLogin})",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't write $File: $!",
                );
            }
        }
        return 1;
    }

    # print an error screen
    my %Data = $SessionObject->GetSessionIDData(
        SessionID => $Param{SessionID},
    );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            %Data,
        },
    );
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->CustomerFatalError(
        Comment => $LayoutObject->{LanguageObject}->Translate('Please contact your administrator'),
    );
    return;
}

sub DESTROY {
    my $Self = shift;

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Global handle stopped.',
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
