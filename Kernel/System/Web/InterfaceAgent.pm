# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Web::InterfaceAgent;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Auth',
    'Kernel::System::AuthSession',
    'Kernel::System::DB',
    'Kernel::System::Email',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Scheduler',
    'Kernel::System::DateTime',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Web::InterfaceAgent - the agent web interface

=head1 DESCRIPTION

the global agent web interface (authentication, session handling, ...)

=head1 PUBLIC INTERFACE

=head2 new()

create agent web interface object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    my $Debug = 0,
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Web::InterfaceAgent' => {
            Debug   => 0,
            WebRequest => CGI::Fast->new(), # optional, e. g. if fast cgi is used,
                                            # the CGI object is already provided
        }
    );
    my $InterfaceAgent = $Kernel::OM->Get('Kernel::System::Web::InterfaceAgent');

=cut

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = {};
    bless( $Self, $Type );

    # Performance log
    $Self->{PerformanceLogStart} = time();

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

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

=head2 Run()

execute the object

    $InterfaceAgent->Run();

=cut

sub Run {
    my $Self = shift;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $QueryString = $ENV{QUERY_STRING} || '';

    # Check if https forcing is active, and redirect if needed.
    if ( $ConfigObject->Get('HTTPSForceRedirect') ) {

        # Some web servers do not set HTTPS environment variable, so it's not possible to easily know if we are using
        #   https protocol. Look also for similarly named keys in environment hash, since this should prevent loops in
        #   certain cases.
        if (
            (
                !defined $ENV{HTTPS}
                && !grep {/^HTTPS(?:_|$)/} keys %ENV
            )
            || $ENV{HTTPS} ne 'on'
            )
        {
            my $Host = $ENV{HTTP_HOST} || $ConfigObject->Get('FQDN');

            # Redirect with 301 code. Add two new lines at the end, so HTTP headers are validated correctly.
            print "Status: 301 Moved Permanently\nLocation: https://$Host$ENV{REQUEST_URI}\n\n";
            return;
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %Param;

    # get session id
    $Param{SessionName} = $ConfigObject->Get('SessionName')                      || 'SessionID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
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

    # check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    my $BrowserHasCookie = 0;
    if ( $ConfigObject->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $ParamObject->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang         => $Param{Lang},
            UserLanguage => $Param{Lang},
        },
        'Kernel::Language' => {
            UserLanguage => $Param{Lang}
        },
    );

    my $CookieSecureAttribute;
    if ( $ConfigObject->Get('HttpType') eq 'https' ) {

        # Restrict Cookie to HTTPS if it is used.
        $CookieSecureAttribute = 1;
    }

    my $DBCanConnect = $Kernel::OM->Get('Kernel::System::DB')->Connect();

    if ( !$DBCanConnect || $ParamObject->Error() ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if ( !$DBCanConnect ) {
            $LayoutObject->FatalError(
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }
        if ( $ParamObject->Error() ) {
            $LayoutObject->FatalError(
                Message => $ParamObject->Error(),
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }
    }

    # get common application and add-on application params
    my %CommonObjectParam = %{ $ConfigObject->Get('Frontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non word chars)
    $Param{Action} =~ s/\W//g;

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    # check request type
    if ( $Param{Action} eq 'PreLogin' ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        $Param{RequestedURL} = $Param{RequestedURL} || "Action=AgentDashboard";

        # login screen
        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
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
        my $PostPw   = $ParamObject->GetParam(
            Param => 'Password',
            Raw   => 1
        ) || '';
        my $PostTwoFactorToken = $ParamObject->GetParam(
            Param => 'TwoFactorToken',
            Raw   => 1
        ) || '';

        # create AuthObject
        my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

        # check submitted data
        my $User = $AuthObject->Auth(
            User           => $PostUser,
            Pw             => $PostPw,
            TwoFactorToken => $PostTwoFactorToken,
        );

        # login is invalid
        if ( !$User ) {

            my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
            if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
                $Expires = '';
            }

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
                }
            );
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('LoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('LoginURL')
                        . "?Reason=LoginFailed&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
                        Type => 'Info',
                        What => 'Message',
                        )
                        || $LayoutObject->{LanguageObject}->Translate( $AuthObject->GetLastErrorMessage() )
                        || Translatable('Login failed! Your user name or password was entered incorrectly.'),
                    LoginFailed => 1,
                    MessageType => 'Error',
                    User        => $User,
                    %Param,
                ),
            );
            return;
        }

        # login is successful
        my %UserData = $UserObject->GetUserData(
            User          => $User,
            Valid         => 1,
            NoOutOfOffice => 1,
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

            # redirect to alternate login
            if ( $ConfigObject->Get('LoginURL') ) {
                print $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect(
                    ExtURL => $ConfigObject->Get('LoginURL') . '?Reason=SystemError',
                );
                return;
            }

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # show need user data error message
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title => 'Error',
                    Message =>
                        Translatable(
                        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.'
                        ),
                    %Param,
                    MessageType => 'Error',
                ),
            );
            return;
        }

        my $DateTimeObj = $Kernel::OM->Create('Kernel::System::DateTime');

        # create new session id
        my $NewSessionID = $SessionObject->CreateSessionID(
            %UserData,
            UserLastRequest => $DateTimeObj->ToEpoch(),
            UserType        => 'User',
            SessionSource   => 'AgentInterface',
        );

        # show error message if no session id has been created
        if ( !$NewSessionID ) {

            # get error message
            my $Error = $SessionObject->SessionIDErrorMessage() || '';

            # output error message
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title       => 'Login',
                    Message     => $Error,
                    MessageType => 'Error',
                    %Param,
                ),
            );
            return;
        }

        # execution in 20 seconds
        my $ExecutionTimeObj = $DateTimeObj->Clone();
        $ExecutionTimeObj->Add( Seconds => 20 );
        my $ExecutionTime = $ExecutionTimeObj->ToString();

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

        my $UserTimeZone = $Self->_UserTimeZoneGet(%UserData);

        $SessionObject->UpdateSessionID(
            SessionID => $NewSessionID,
            Key       => 'UserTimeZone',
            Value     => $UserTimeZone,
        );

        # check if the time zone offset reported by the user's browser differs from that
        # of the OTRS user's time zone offset
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => $UserTimeZone,
            },
        );
        my $OTRSUserTimeZoneOffset = $DateTimeObject->Format( Format => '%{offset}' ) / 60;
        my $BrowserTimeZoneOffset  = ( $ParamObject->GetParam( Param => 'TimeZoneOffset' ) || 0 ) * -1;

        # TimeZoneOffsetDifference contains the difference of the time zone offset between
        # the user's OTRS time zone setting and the one reported by the user's browser.
        # If there is a difference it can be evaluated later to e. g. show a message
        # for the user to check his OTRS time zone setting.
        my $UserTimeZoneOffsetDifference = abs( $OTRSUserTimeZoneOffset - $BrowserTimeZoneOffset );
        $SessionObject->UpdateSessionID(
            SessionID => $NewSessionID,
            Key       => 'UserTimeZoneOffsetDifference',
            Value     => $UserTimeZoneOffsetDifference,
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

        # Check if Chat is active
        if ( $Kernel::OM->Get('Kernel::Config')->Get('ChatEngine::Active') ) {
            my $ChatReceivingAgentsGroup
                = $Kernel::OM->Get('Kernel::Config')->Get('ChatEngine::PermissionGroup::ChatReceivingAgents');

            my $ChatReceivingAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $UserData{UserID},
                GroupName => $ChatReceivingAgentsGroup,
                Type      => 'rw',
            );

            if (
                $UserData{UserID} != -1
                && $ChatReceivingAgentsGroup
                && $ChatReceivingAgentsGroupPermission
                && $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Agent::UnavailableForExternalChatsOnLogin')
                )
            {
                # Get user preferences
                my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
                    UserID => $UserData{UserID},
                );

                if ( $Preferences{ChatAvailability} && $Preferences{ChatAvailability} == 2 ) {

                    # User is available for external chats. Set his availability to internal only.
                    $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                        Key    => 'ChatAvailability',
                        Value  => '1',
                        UserID => $UserData{UserID},
                    );

                    # Set ChatAvailabilityNotification to display notification in agent interface (only once)
                    $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                        Key    => 'ChatAvailabilityNotification',
                        Value  => '1',
                        UserID => $UserData{UserID},
                    );
                }
            }
        }

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

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # redirect to alternate login
            if ( $ConfigObject->Get('LoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('LoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show login screen
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title => 'Logout',
                    %Param,
                ),
            );
            return;
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

        # create a new LayoutObject with %UserData
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
                %UserData,
            },
        );
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
        $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # Prevent CSRF attacks
        $LayoutObject->ChallengeTokenCheck();

        # remove session id
        if ( !$SessionObject->RemoveSessionID( SessionID => $Param{SessionID} ) ) {
            $LayoutObject->FatalError(
                Message => Translatable('Can`t remove SessionID.'),
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }

        # redirect to alternate login
        if ( $ConfigObject->Get('LogoutURL') ) {
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('LogoutURL'),
            );
            return 1;
        }

        # show logout screen
        my $LogoutMessage = $LayoutObject->{LanguageObject}->Translate('Logout successful.');

        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
                Title       => 'Logout',
                Message     => $LogoutMessage,
                MessageType => 'Success',
                %Param,
            ),
        );
        return 1;
    }

    # user lost password
    elsif ( $Param{Action} eq 'LostPassword' ) {

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check feature
        if ( !$ConfigObject->Get('LostPassword') ) {

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title       => 'Login',
                    Message     => Translatable('Feature not active!'),
                    MessageType => 'Error',
                ),
            );
            return;
        }

        # get params
        my $User  = $ParamObject->GetParam( Param => 'User' )  || '';
        my $Token = $ParamObject->GetParam( Param => 'Token' ) || '';

        # get user login by token
        if ( !$User && $Token ) {

            # Prevent extracting password reset token character-by-character via wildcard injection
            # The wild card characters "%" and "_" could be used to match arbitrary character.
            if ( $Token !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

                # Security: pretend that password reset instructions were actually sent to
                #   make sure that users cannot find out valid usernames by
                #   just trying and checking the result message.
                $LayoutObject->Print(
                    Output => \$LayoutObject->Login(
                        Title       => 'Login',
                        Message     => Translatable('Sent password reset instructions. Please check your email.'),
                        MessageType => 'Success',
                        %Param,
                    ),
                );
                return;
            }

            my %UserList = $UserObject->SearchPreferences(
                Key   => 'UserToken',
                Value => $Token,
            );
            USERS:
            for my $UserID ( sort keys %UserList ) {
                my %UserData = $UserObject->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );
                if (%UserData) {
                    $User = $UserData{UserLogin};
                    last USERS;
                }
            }
        }

        # get user data
        my %UserData = $UserObject->GetUserData(
            User  => $User,
            Valid => 1
        );

        # verify user is valid when requesting password reset
        my @ValidIDs    = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
        my $UserIsValid = grep { $UserData{ValidID} && $UserData{ValidID} == $_ } @ValidIDs;
        if ( !$UserData{UserID} || !$UserIsValid ) {

            # Security: pretend that password reset instructions were actually sent to
            #   make sure that users cannot find out valid usernames by
            #   just trying and checking the result message.
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title       => 'Login',
                    Message     => Translatable('Sent password reset instructions. Please check your email.'),
                    MessageType => 'Success',
                    %Param,
                ),
            );
            return;
        }

        # create email object
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

        # send password reset token
        if ( !$Token ) {

            # generate token
            $UserData{Token} = $UserObject->TokenGenerate(
                UserID => $UserData{UserID},
            );

            # send token notify email with link
            my $Body = $ConfigObject->Get('NotificationBodyLostPasswordToken')
                || 'ERROR: NotificationBodyLostPasswordToken is missing!';
            my $Subject = $ConfigObject->Get('NotificationSubjectLostPasswordToken')
                || 'ERROR: NotificationSubjectLostPasswordToken is missing!';
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
            if ( !$Sent->{Success} ) {
                $LayoutObject->FatalError(
                    Comment => Translatable('Please contact the administrator.'),
                );
                return;
            }
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title       => 'Login',
                    Message     => Translatable('Sent password reset instructions. Please check your email.'),
                    MessageType => 'Success',
                    %Param,
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
                Output => \$LayoutObject->Login(
                    Title       => 'Login',
                    Message     => Translatable('Invalid Token!'),
                    MessageType => 'Error',
                    %Param,
                ),
            );
            return;
        }

        # get new password
        $UserData{NewPW} = $UserObject->GenerateRandomPassword();

        # update new password
        $UserObject->SetPassword(
            UserLogin => $User,
            PW        => $UserData{NewPW}
        );

        # send notify email
        my $Body = $ConfigObject->Get('NotificationBodyLostPassword')
            || 'New Password is: <OTRS_NEWPW>';
        my $Subject = $ConfigObject->Get('NotificationSubjectLostPassword')
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

        if ( !$Sent->{Success} ) {
            $LayoutObject->FatalError(
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }
        my $Message = $LayoutObject->{LanguageObject}->Translate(
            'Sent new password to %s. Please check your email.',
            $UserData{UserEmail},
        );
        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
                Title       => 'Login',
                Message     => $Message,
                User        => $User,
                MessageType => 'Success',
                %Param,
            ),
        );
        return 1;
    }

    # show login site
    elsif ( !$Param{SessionID} ) {

        # create AuthObject
        my $AuthObject   = $Kernel::OM->Get('Kernel::System::Auth');
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

            # automatic login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                OP => "Action=PreLogin&RequestedURL=$Param{RequestedURL}",
            );
            return;
        }
        elsif ( $ConfigObject->Get('LoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('LoginURL')
                    . "?RequestedURL=$Param{RequestedURL}",
            );
            return;
        }

        # login screen
        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
                Title => 'Login',
                %Param,
            ),
        );
        return;
    }

    # run modules if a version value exists
    elsif ( $Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # put '%Param' into LayoutObject
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
                },
            );

            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # create AuthObject
            my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');
            if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

                # automatic re-login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    OP => "?Action=PreLogin&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }
            elsif ( $ConfigObject->Get('LoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('LoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title => 'Login',
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate( $SessionObject->SessionIDErrorMessage() ),
                    MessageType => 'Error',
                    %Param,
                ),
            );
            return;
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} || $UserData{UserType} ne 'User' ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('LoginURL') ) {
                print $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('LoginURL') . '?Reason=SystemError',
                );
                return;
            }

            # show login screen
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title       => 'Error',
                    Message     => Translatable('Error: invalid session.'),
                    MessageType => 'Error',
                    %Param,
                ),
            );
            return;
        }

        # check module registry
        my $ModuleReg = $ConfigObject->Get('Frontend::Module')->{ $Param{Action} };
        if ( !$ModuleReg ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
            );
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }

        # module permisson check
        if (
            ref $ModuleReg->{GroupRo} eq 'ARRAY'
            && !scalar @{ $ModuleReg->{GroupRo} }
            && ref $ModuleReg->{Group} eq 'ARRAY'
            && !scalar @{ $ModuleReg->{Group} }
            )
        {
            $Param{AccessRo} = 1;
            $Param{AccessRw} = 1;
        }
        else {
            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

            PERMISSION:
            for my $Permission (qw(GroupRo Group)) {
                my $AccessOk = 0;
                my $Group    = $ModuleReg->{$Permission};
                next PERMISSION if !$Group;
                if ( ref $Group eq 'ARRAY' ) {
                    INNER:
                    for my $GroupName ( @{$Group} ) {
                        next INNER if !$GroupName;
                        next INNER if !$GroupObject->PermissionCheck(
                            UserID    => $UserData{UserID},
                            GroupName => $GroupName,
                            Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                        );
                        $AccessOk = 1;
                        last INNER;
                    }
                }
                else {
                    my $HasPermission = $GroupObject->PermissionCheck(
                        UserID    => $UserData{UserID},
                        GroupName => $Group,
                        Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                    );
                    if ($HasPermission) {
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
            if ( !$Param{AccessRo} && !$Param{AccessRw} || !$Param{AccessRo} && $Param{AccessRw} ) {

                print $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NoPermission(
                    Message => Translatable('No Permission to use this frontend module!')
                );
                return;
            }
        }

        # put '%Param' and '%UserData' into LayoutObject
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                %Param,
                %UserData,
                ModuleReg => $ModuleReg,
            },
        );
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );

        # update last request time
        if (
            !$ParamObject->IsAJAXRequest()
            || $Param{Action} eq 'AgentVideoChat'
            ||
            (
                $Param{Action} eq 'AgentChat'
                &&
                $Param{Subaction} ne 'ChatGetOpenRequests' &&
                $Param{Subaction} ne 'ChatMonitorCheck'
            )
            )
        {
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            $SessionObject->UpdateSessionID(
                SessionID => $Param{SessionID},
                Key       => 'UserLastRequest',
                Value     => $DateTimeObject->ToEpoch(),
            );
        }

        # Override user settings.
        my $Home = $ConfigObject->Get('Home');
        my $File = "$Home/Kernel/Config/Files/User/$UserData{UserID}.pm";
        if ( -e $File ) {
            eval {
                if ( require $File ) {

                    # Prepare file.
                    $File =~ s/\Q$Home\E//g;
                    $File =~ s/^\///g;
                    $File =~ s/\/\//\//g;
                    $File =~ s/\//::/g;
                    $File =~ s/\.pm$//g;
                    $File->Load($ConfigObject);
                }
                else {
                    die "Cannot load file $File: $!\n";
                }
            };

            # Log error and continue.
            if ($@) {
                my $ErrorMessage = $@;
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => $ErrorMessage,
                );
            }
        }

        # pre application module
        my $PreModule = $ConfigObject->Get('PreApplicationModule');
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
                        Message  => "PreApplication module $PreModule is used.",
                    );
                }

                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

                # use module
                my $PreModuleObject = $PreModule->new(
                    %Param,
                    %UserData,
                    ModuleReg => $ModuleReg,
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
            Debug     => $Self->{Debug},
        );

        # debug info
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
            );
        }

        # ->Run $Action with $FrontendObject
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Print( Output => \$FrontendObject->Run() );

        # log request time
        if ( $ConfigObject->Get('PerformanceLog') ) {
            if ( ( !$QueryString && $Param{Action} ) || $QueryString !~ /Action=/ ) {
                $QueryString = 'Action=' . $Param{Action} . '&Subaction=' . $Param{Subaction};
            }
            my $File = $ConfigObject->Get('PerformanceLog::File');

            # Write to PerformanceLog file only if it is smaller than size limit (see bug#14747).
            if ( -s $File < ( 1024 * 1024 * $ConfigObject->Get('PerformanceLog::FileMax') ) ) {

                ## no critic
                if ( open my $Out, '>>', $File ) {
                    ## use critic
                    print $Out time()
                        . '::Agent::'
                        . ( time() - $Self->{PerformanceLogStart} )
                        . "::$UserData{UserLogin}::$QueryString\n";
                    close $Out;

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "Response::Agent: "
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
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message => "PerformanceLog file '$File' is too large, you need to reset it in PerformanceLog page!",
                );
            }
        }
        return 1;
    }

    # print an error screen
    my %Data = $SessionObject->GetSessionIDData(
        SessionID => $Param{SessionID},
    );
    $Data{UserTimeZone} = $Self->_UserTimeZoneGet(%Data);
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            %Data,
        },
    );
    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
        Comment => Translatable('Please contact the administrator.'),
    );
    return;
}

=begin Internal:

=head2 _UserTimeZoneGet()

Get time zone for the current user. This function will validate passed time zone parameter and return default user time
zone if it's not valid.

    my $UserTimeZone = $Self->_UserTimeZoneGet(
        UserTimeZone => 'Europe/Berlin',
    );

=cut

sub _UserTimeZoneGet {
    my ( $Self, %Param ) = @_;

    my $UserTimeZone;

    # Return passed time zone only if it's valid. It can happen that user preferences or session store an old-style
    #   offset which is not valid anymore. In this case, return the default value.
    #   Please see bug#13374 for more information.
    if (
        $Param{UserTimeZone}
        && Kernel::System::DateTime->IsTimeZoneValid( TimeZone => $Param{UserTimeZone} )
        )
    {
        $UserTimeZone = $Param{UserTimeZone};
    }

    $UserTimeZone ||= Kernel::System::DateTime->UserDefaultTimeZoneGet();

    return $UserTimeZone;
}

=end Internal:

=cut

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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
