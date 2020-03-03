# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Web::InterfaceCustomer;

use strict;
use warnings;

use Kernel::System::DateTime;
use Kernel::System::Email;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::CustomerAuth',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Scheduler',
    'Kernel::System::DateTime',
    'Kernel::System::Web::Request',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Web::InterfaceCustomer - the customer web interface

=head1 DESCRIPTION

the global customer web interface (authentication, session handling, ...)

=head1 PUBLIC INTERFACE

=head2 new()

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

=head2 Run()

execute the object

    $InterfaceCustomer->Run();

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
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
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
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }
        if ( $ParamObject->Error() ) {
            $LayoutObject->CustomerFatalError(
                Message => $ParamObject->Error(),
                Comment => Translatable('Please contact the administrator.'),
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
        my $PostPw   = $ParamObject->GetParam(
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
                        || Translatable('Login failed! Your user name or password was entered incorrectly.'),
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
                    Title   => 'Error',
                    Message => Translatable(
                        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.'
                    ),
                    %Param,
                ),
            );
            return;
        }

        # create datetime object
        my $SessionDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

        # Remove certain user attributes that are not needed to be stored in the session.
        #   - SMIME Certificate could be in binary format, if session backend in DB (default)
        #   it wont be possible to be saved in certain databases (see bug#14405).
        my %UserSessionData = %UserData;
        delete $UserSessionData{UserSMIMECertificate};

        # create new session id
        my $NewSessionID = $SessionObject->CreateSessionID(
            %UserSessionData,
            UserLastRequest => $SessionDTObject->ToEpoch(),
            UserType        => 'Customer',
            SessionSource   => 'CustomerInterface',
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

        # execution in 20 seconds
        my $ExecutionTimeObj = $Kernel::OM->Create('Kernel::System::DateTime');
        $ExecutionTimeObj->Add( Seconds => 20 );

        # add a asynchronous executor scheduler task to count the concurrent user
        $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
            ExecutionTime            => $ExecutionTimeObj->ToString(),
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
                Message => Translatable('Session invalid. Please log in again.'),
                %Param,
            );
            return;
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

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
                Comment => Translatable('Please contact the administrator.')
            );
            return;
        }

        # redirect to alternate login
        if ( $ConfigObject->Get('CustomerPanelLogoutURL') ) {
            print $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLogoutURL'),
            );
        }

        # show logout screen
        my $LogoutMessage = $LayoutObject->{LanguageObject}->Translate('Logout successful.');

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
                    Message => Translatable('Feature not active!'),
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

        # verify customer user is valid when requesting password reset
        my @ValidIDs    = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
        my $UserIsValid = grep { $UserData{ValidID} && $UserData{ValidID} == $_ } @ValidIDs;
        if ( !$UserData{UserID} || !$UserIsValid ) {

            # Security: pretend that password reset instructions were actually sent to
            #   make sure that users cannot find out valid usernames by
            #   just trying and checking the result message.
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title       => 'Login',
                    Message     => Translatable('Sent password reset instructions. Please check your email.'),
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
            if ( !$Sent->{Success} ) {
                $LayoutObject->FatalError(
                    Comment => Translatable('Please contact the administrator.'),
                );
                return;
            }
            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title   => 'Login',
                    Message => Translatable('Sent password reset instructions. Please check your email.'),
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
                    Message => Translatable('Invalid Token!'),
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
                    Title   => 'Login',
                    Message => Translatable('Reset password unsuccessful. Please contact the administrator.'),
                    User    => $User,
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
        if ( !$Sent->{Success} ) {
            $LayoutObject->CustomerFatalError(
                Comment => Translatable('Please contact the administrator.')
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
                    Message => Translatable('Feature not active!'),
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

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        Translatable('This e-mail address already exists. Please log in or reset your password.'),
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

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title => 'Login',
                    Message =>
                        Translatable('This email address is not allowed to register. Please contact support staff.'),
                    UserTitle     => $GetParams{UserTitle},
                    UserFirstname => $GetParams{UserFirstname},
                    UserLastname  => $GetParams{UserLastname},
                    UserEmail     => $GetParams{UserEmail},
                ),
            );

            return;
        }

        # create account
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $Now = $DateTimeObject->ToString();

        my $Add = $UserObject->CustomerUserAdd(
            %GetParams,
            Comment => $LayoutObject->{LanguageObject}->Translate( 'Added via Customer Panel (%s)', $Now ),
            ValidID => 1,
            UserID  => $ConfigObject->Get('CustomerPanelUserID'),
        );
        if ( !$Add ) {

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            $LayoutObject->Print(
                Output => \$LayoutObject->CustomerLogin(
                    Title         => 'Login',
                    Message       => Translatable('Customer user can\'t be added!'),
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
        if ( !$Sent->{Success} ) {
            my $Output = $LayoutObject->CustomerHeader(
                Area  => 'Core',
                Title => 'Error'
            );
            $Output .= $LayoutObject->CustomerWarning(
                Comment => Translatable('Can\'t send account info!')
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

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

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
                    Title   => 'Error',
                    Message => Translatable('Error: invalid session.'),
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
                Comment => Translatable('Please contact the administrator.'),
            );
            return;
        }

        # module permission check for action
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

            ( $Param{AccessRo}, $Param{AccessRw} ) = $Self->_CheckModulePermission(
                ModuleReg => $ModuleReg,
                %UserData,
            );

            if ( !$Param{AccessRo} ) {

                # new layout object
                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'No Permission to use this frontend action module!'
                );
                $LayoutObject->CustomerFatalError(
                    Comment => Translatable('Please contact the administrator.'),
                );
                return;
            }

        }

        my $NavigationConfig = $ConfigObject->Get('CustomerFrontend::Navigation')->{ $Param{Action} };

        # module permission check for submenu item
        if ( IsHashRefWithData($NavigationConfig) ) {

            KEY:
            for my $Key ( sort keys %{$NavigationConfig} ) {
                next KEY if $Key                 !~ m/^\d+/i;
                next KEY if $Param{RequestedURL} !~ m/Subaction/i;

                my @ModuleNavigationConfigs;

                # FIXME: Support both old (HASH) and new (ARRAY of HASH) navigation configurations, for reasons of
                #   backwards compatibility. Once we are sure everything has been migrated correctly, support for
                #   HASH-only configuration can be dropped in future major release.
                if ( IsHashRefWithData( $NavigationConfig->{$Key} ) ) {
                    push @ModuleNavigationConfigs, $NavigationConfig->{$Key};
                }
                elsif ( IsArrayRefWithData( $NavigationConfig->{$Key} ) ) {
                    push @ModuleNavigationConfigs, @{ $NavigationConfig->{$Key} };
                }

                # Skip incompatible configuration.
                else {
                    next KEY;
                }

                ITEM:
                for my $Item (@ModuleNavigationConfigs) {
                    if (
                        $Item->{Link} =~ m/Subaction=/i
                        && $Item->{Link} !~ m/$Param{Subaction}/i
                        )
                    {
                        next ITEM;
                    }
                    $Param{AccessRo} = 0;
                    $Param{AccessRw} = 0;

                    # module permission check for submenu item
                    if (
                        ref $Item->{GroupRo} eq 'ARRAY'
                        && !scalar @{ $Item->{GroupRo} }
                        && ref $Item->{Group} eq 'ARRAY'
                        && !scalar @{ $Item->{Group} }
                        )
                    {
                        $Param{AccessRo} = 1;
                        $Param{AccessRw} = 1;
                    }
                    else {

                        ( $Param{AccessRo}, $Param{AccessRw} ) = $Self->_CheckModulePermission(
                            ModuleReg => $Item,
                            %UserData,
                        );

                        if ( !$Param{AccessRo} ) {

                            # new layout object
                            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message  => 'No Permission to use this frontend subaction module!'
                            );
                            $LayoutObject->CustomerFatalError(
                                Comment => Translatable('Please contact the administrator.')
                            );
                            return;
                        }
                    }
                }
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
        if (
            !$ParamObject->IsAJAXRequest()
            || $Param{Action} eq 'CustomerVideoChat'
            )
        {
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            $SessionObject->UpdateSessionID(
                SessionID => $Param{SessionID},
                Key       => 'UserLastRequest',
                Value     => $DateTimeObject->ToEpoch(),
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
                    Priority => 'debug',
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
    $Data{UserTimeZone} = $Self->_UserTimeZoneGet(%Data);
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            %Data,
        },
    );
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->CustomerFatalError(
        Comment => Translatable('Please contact the administrator.'),
    );
    return;
}

=begin Internal:

=head2 _CheckModulePermission()

module permission check

    ($AccessRo, $AccessRw = $AutoResponseObject->_CheckModulePermission(
        ModuleReg => $ModuleReg,
        %UserData,
    );

=cut

sub _CheckModulePermission {
    my ( $Self, %Param ) = @_;

    my $AccessRo = 0;
    my $AccessRw = 0;

    PERMISSION:
    for my $Permission (qw(GroupRo Group)) {
        my $AccessOk = 0;
        my $Group    = $Param{ModuleReg}->{$Permission};

        next PERMISSION if !$Group;

        my $GroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');

        if ( IsArrayRefWithData($Group) ) {
            GROUP:
            for my $Item ( @{$Group} ) {
                next GROUP if !$Item;
                next GROUP if !$GroupObject->PermissionCheck(
                    UserID    => $Param{UserID},
                    GroupName => $Item,
                    Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
                );

                $AccessOk = 1;
                last GROUP;
            }
        }
        else {
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $Param{UserID},
                GroupName => $Group,
                Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
            );
            if ($HasPermission) {
                $AccessOk = 1;
            }
        }
        if ( $Permission eq 'Group' && $AccessOk ) {
            $AccessRo = 1;
            $AccessRw = 1;
        }
        elsif ( $Permission eq 'GroupRo' && $AccessOk ) {
            $AccessRo = 1;
        }
    }

    return ( $AccessRo, $AccessRw );
}

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
