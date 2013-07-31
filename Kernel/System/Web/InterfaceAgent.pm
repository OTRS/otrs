# --
# Kernel/System/Web/InterfaceAgent.pm - the agent interface file (incl. auth)
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfaceAgent;

use strict;
use warnings;

use vars qw(@INC);

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::Output::HTML::Layout;

=head1 NAME

Kernel::System::Web::InterfaceAgent - the agent web interface

=head1 SYNOPSIS

the global agent web interface (incl. auth, session, ...)

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create agent web interface object

    use Kernel::System::Web::InterfaceAgent;

    my $Debug = 0;
    my $InterfaceAgent = Kernel::System::Web::InterfaceAgent->new(
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

    # create common framework objects 1/2
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{LogObject}    = Kernel::System::Log->new(
        LogPrefix => $Self->{ConfigObject}->Get('CGILogPrefix'),
        %{$Self},
    );
    $Self->{EncodeObject} = Kernel::System::Encode->new( %{$Self} );
    $Self->{MainObject}   = Kernel::System::Main->new( %{$Self} );
    $Self->{TimeObject}   = Kernel::System::Time->new( %{$Self} );
    $Self->{ParamObject}  = Kernel::System::Web::Request->new(
        %{$Self},
        WebRequest => $Param{WebRequest} || 0,
    );

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global handle started...',
        );
    }

    return $Self;
}

=item Run()

execute the object

    $InterfaceAgent->Run();

=cut

sub Run {
    my $Self = shift;

    # get common framework params
    my %Param;

    # get session id
    $Param{SessionName} = $Self->{ConfigObject}->Get('SessionName') || 'SessionID';
    $Param{SessionID} = $Self->{ParamObject}->GetParam( Param => $Param{SessionName} ) || '';

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
        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key )
            || $FrameworkParams->{$Key};
    }

    # check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $Self->{ParamObject}->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    # check common objects
    $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
    if ( !$Self->{DBObject} || $Self->{ParamObject}->Error() ) {
        my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );
        if ( !$Self->{DBObject} ) {
            $LayoutObject->FatalError(
                Comment => 'Please contact your administrator',
            );
            return;
        }
        if ( $Self->{ParamObject}->Error() ) {
            $LayoutObject->FatalError(
                Message => $Self->{ParamObject}->Error(),
                Comment => 'Please contact your administrator',
            );
            return;
        }
    }

    # create common framework objects 2/2
    $Self->{UserObject}    = Kernel::System::User->new( %{$Self} );
    $Self->{GroupObject}   = Kernel::System::Group->new( %{$Self} );
    $Self->{SessionObject} = Kernel::System::AuthSession->new( %{$Self} );

    # application and add-on application common objects
    my %CommonObject = %{ $Self->{ConfigObject}->Get('Frontend::CommonObject') };
    for my $Key ( sort keys %CommonObject ) {
        if ( $Self->{MainObject}->Require( $CommonObject{$Key} ) ) {
            $Self->{$Key} = $CommonObject{$Key}->new( %{$Self} );
        }
        else {

            # print error
            my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );
            $LayoutObject->FatalError( Comment => 'Please contact your administrator' );
            return;
        }
    }

    # get common application and add-on application params
    my %CommonObjectParam = %{ $Self->{ConfigObject}->Get('Frontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non word chars)
    $Param{Action} =~ s/\W//g;

    # check request type
    if ( $Param{Action} eq 'Login' ) {

        # new layout object
        my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );

        # get params
        my $PostUser = $Self->{ParamObject}->GetParam( Param => 'User' ) || '';
        my $PostPw = $Self->{ParamObject}->GetParam( Param => 'Password', Raw => 1 ) || '';

        # create AuthObject
        my $AuthObject = Kernel::System::Auth->new( %{$Self} );

        # check submitted data
        my $User = $AuthObject->Auth( User => $PostUser, Pw => $PostPw );

        # login is invalid
        if ( !$User ) {

            # redirect to alternate login
            if ( $Self->{ConfigObject}->Get('LoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('LoginURL')
                        . "?Reason=LoginFailed&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => $Self->{LogObject}->GetLogEntry(
                        Type => 'Info',
                        What => 'Message',
                        )
                        || 'Login failed! Your username or password was entered incorrectly.',
                    LoginFailed => 1,
                    User        => $User,
                    %Param,
                ),
            );
            return;
        }

        # login is successful
        my %UserData = $Self->{UserObject}->GetUserData( User => $User, Valid => 1 );

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} ) {

            # redirect to alternate login
            if ( $Self->{ConfigObject}->Get('LoginURL') ) {
                print $LayoutObject->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('LoginURL') . '?Reason=SystemError',
                );
                return;
            }

            # show need user data error message
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title => 'Panic!',
                    Message =>
                        'Panic, user authenticated but no user data can be found in OTRS DB!! Perhaps the user is invalid.',
                    %Param,
                ),
            );
            return;
        }

        # get groups rw/ro
        for my $Type (qw(rw ro)) {
            my %GroupData = $Self->{GroupObject}->GroupMemberList(
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
        my $NewSessionID = $Self->{SessionObject}->CreateSessionID(
            %UserData,
            UserLastRequest => $Self->{TimeObject}->SystemTime(),
            UserType        => 'User',
        );

        # show error message if no session id has been created
        if ( !$NewSessionID ) {

            # get error message
            my $Error = $Self->{SessionObject}->SessionIDErrorMessage() || '';

            # output error message
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => $Error,
                    %Param,
                ),
            );
            return;
        }

        # set time zone offset if TimeZoneFeature is active
        if (
            $Self->{ConfigObject}->Get('TimeZoneUser')
            && $Self->{ConfigObject}->Get('TimeZoneUserBrowserAutoOffset')
            && $LayoutObject->{BrowserJavaScriptSupport}
            )
        {
            my $TimeOffset = $Self->{ParamObject}->GetParam( Param => 'TimeOffset' ) || 0;
            if ( $TimeOffset > 0 ) {
                $TimeOffset = '-' . ( $TimeOffset / 60 );
            }
            else {
                $TimeOffset = $TimeOffset / 60;
                $TimeOffset =~ s/-/+/;
            }
            $Self->{UserObject}->SetPreferences(
                UserID => $UserData{UserID},
                Key    => 'UserTimeZone',
                Value  => $TimeOffset,
            );
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $NewSessionID,
                Key       => 'UserTimeZone',
                Value     => $TimeOffset,
            );
        }

        # create a new LayoutObject with SessionIDCookie
        my $Expires = '+' . $Self->{ConfigObject}->Get('SessionMaxTime') . 's';
        if ( !$Self->{ConfigObject}->Get('SessionUseCookieAfterBrowserClose') ) {
            $Expires = '';
        }

        my $SecureAttribute;
        if ( $Self->{ConfigObject}->Get('HttpType') eq 'https' ) {

            # Restrict Cookie to HTTPS if it is used.
            $SecureAttribute = 1;
        }

        $LayoutObject = Kernel::Output::HTML::Layout->new(
            SetCookies => {
                SessionIDCookie => $Self->{ParamObject}->SetCookie(
                    Key     => $Param{SessionName},
                    Value   => $NewSessionID,
                    Expires => $Expires,
                    Path    => $Self->{ConfigObject}->Get('ScriptAlias'),
                    Secure  => scalar $SecureAttribute,
                ),
            },
            SessionID   => $NewSessionID,
            SessionName => $Param{SessionName},
            %{$Self},
        );

        # redirect with new session id and old params
        # prepare old redirect URL -- do not redirect to Login or Logout (loop)!
        if ( $Param{RequestedURL} =~ /Action=(Logout|Login|LostPassword)/ ) {
            $Param{RequestedURL} = '';
        }

        # redirect with new session id
        print $LayoutObject->Redirect( OP => $Param{RequestedURL} );
        return 1;
    }

    # logout
    elsif ( $Param{Action} eq 'Logout' ) {

        # check session id
        if ( !$Self->{SessionObject}->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # new layout object
            my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );

            # redirect to alternate login
            if ( $Self->{ConfigObject}->Get('LoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('LoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show login screen
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Logout',
                    Message => 'Session invalid. Please log in again.',
                    %Param,
                ),
            );
            return;
        }

        # get session data
        my %UserData = $Self->{SessionObject}->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        # create new LayoutObject with new '%Param' and '%UserData'
        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            SetCookies => {
                SessionIDCookie => $Self->{ParamObject}->SetCookie(
                    Key   => $Param{SessionName},
                    Value => '',
                ),
            },
            %{$Self},
            %Param,
            %UserData,
        );

        # Prevent CSRF attacks
        $LayoutObject->ChallengeTokenCheck();

        # remove session id
        if ( !$Self->{SessionObject}->RemoveSessionID( SessionID => $Param{SessionID} ) ) {
            $LayoutObject->FatalError(
                Message => 'Can`t remove SessionID',
                Comment => 'Please contact your administrator',
            );
            return;
        }

        # redirect to alternate login
        if ( $Self->{ConfigObject}->Get('LogoutURL') ) {
            print $LayoutObject->Redirect(
                ExtURL => $Self->{ConfigObject}->Get('LogoutURL') . "?Reason=Logout",
            );
            return 1;
        }

        # show logout screen
        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
                Title   => 'Logout',
                Message => 'Logout successful. Thank you for using %s!", "$Config{"ProductName"}',
                %Param,
            ),
        );
        return 1;
    }

    # user lost password
    elsif ( $Param{Action} eq 'LostPassword' ) {

        # new layout object
        my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );

        # check feature
        if ( !$Self->{ConfigObject}->Get('LostPassword') ) {

            # show normal login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => 'Feature not active!',
                ),
            );
            return;
        }

        # get params
        my $User  = $Self->{ParamObject}->GetParam( Param => 'User' )  || '';
        my $Token = $Self->{ParamObject}->GetParam( Param => 'Token' ) || '';

        # get user login by token
        if ( !$User && $Token ) {
            my %UserList = $Self->{UserObject}->SearchPreferences(
                Key   => 'UserToken',
                Value => $Token,
            );
            for my $UserID ( sort keys %UserList ) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );
                if (%UserData) {
                    $User = $UserData{UserLogin};
                    last;
                }
            }
        }

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData( User => $User, Valid => 1 );
        if ( !$UserData{UserID} ) {

            # Security: pretend that password reset instructions were actually sent to
            #   make sure that users cannot find out valid usernames by
            #   just trying and checking the result message.
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => 'Sent password reset instructions. Please check your email.',
                    %Param,
                ),
            );
            return;
        }

        # create email object
        my $EmailObject = Kernel::System::Email->new( %{$Self} );

        # send password reset token
        if ( !$Token ) {

            # generate token
            $UserData{Token} = $Self->{UserObject}->TokenGenerate(
                UserID => $UserData{UserID},
            );

            # send token notify email with link
            my $Body = $Self->{ConfigObject}->Get('NotificationBodyLostPasswordToken')
                || 'ERROR: NotificationBodyLostPasswordToken is missing!';
            my $Subject = $Self->{ConfigObject}->Get('NotificationSubjectLostPasswordToken')
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
            if ( !$Sent ) {
                $LayoutObject->FatalError(
                    Comment => 'Please contact your administrator',
                );
                return;
            }
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => 'Sent password reset instructions. Please check your email.',
                    %Param,
                ),
            );
            return 1;
        }

        # reset password
        # check if token is valid
        my $TokenValid = $Self->{UserObject}->TokenCheck(
            Token  => $Token,
            UserID => $UserData{UserID},
        );
        if ( !$TokenValid ) {
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => 'Invalid Token!',
                    %Param,
                ),
            );
            return;
        }

        # get new password
        $UserData{NewPW} = $Self->{UserObject}->GenerateRandomPassword();

        # update new password
        $Self->{UserObject}->SetPassword( UserLogin => $User, PW => $UserData{NewPW} );

        # send notify email
        my $Body = $Self->{ConfigObject}->Get('NotificationBodyLostPassword')
            || 'New Password is: <OTRS_NEWPW>';
        my $Subject = $Self->{ConfigObject}->Get('NotificationSubjectLostPassword')
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
            $LayoutObject->FatalError(
                Comment => 'Please contact your administrator',
            );
            return;
        }
        $LayoutObject->Print(
            Output => \$LayoutObject->Login(
                Title => 'Login',
                Message =>
                    "Sent new password to \%s. Please check your email.\", \"$UserData{UserEmail}",
                User => $User,
                %Param,
            ),
        );
        return 1;
    }

    # show login site
    elsif ( !$Param{SessionID} ) {

        # new layout object
        my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );

        # create AuthObject
        my $AuthObject = Kernel::System::Auth->new( %{$Self} );
        if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

            # automatic login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                OP => "Action=Login&RequestedURL=$Param{RequestedURL}",
            );
            return;
        }
        elsif ( $Self->{ConfigObject}->Get('LoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
            print $LayoutObject->Redirect(
                ExtURL => $Self->{ConfigObject}->Get('LoginURL')
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
    elsif ( $Self->{MainObject}->Require("Kernel::Modules::$Param{Action}") ) {

        # check session id
        if ( !$Self->{SessionObject}->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # create new LayoutObject with new '%Param'
            my $LayoutObject = Kernel::Output::HTML::Layout->new(
                SetCookies => {
                    SessionIDCookie => $Self->{ParamObject}->SetCookie(
                        Key   => $Param{SessionName},
                        Value => '',
                    ),
                },
                %{$Self},
                %Param,
            );

            # create AuthObject
            my $AuthObject = Kernel::System::Auth->new( %{$Self} );
            if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

                # automatic re-login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    OP => "?Action=Login&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }
            elsif ( $Self->{ConfigObject}->Get('LoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );
                print $LayoutObject->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('LoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
                return;
            }

            # show login
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Login',
                    Message => $Self->{SessionObject}->SessionIDErrorMessage(),
                    %Param,
                ),
            );
            return;
        }

        # get session data
        my %UserData = $Self->{SessionObject}->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} || $UserData{UserType} ne 'User' ) {

            # new layout object
            my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );

            # redirect to alternate login
            if ( $Self->{ConfigObject}->Get('LoginURL') ) {
                print $LayoutObject->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('LoginURL') . '?Reason=SystemError',
                );
                return;
            }

            # show login screen
            $LayoutObject->Print(
                Output => \$LayoutObject->Login(
                    Title   => 'Panic!',
                    Message => 'Panic! Invalid Session!!!',
                    %Param,
                ),
            );
            return;
        }

        # check module registry
        my $ModuleReg = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Action} };
        if ( !$ModuleReg ) {

            # new layout object
            my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang}, );
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
            );
            $LayoutObject->FatalError( Comment => 'Please contact your administrator' );
            return;
        }

        # module permisson check
        if ( !$ModuleReg->{GroupRo} && !$ModuleReg->{Group} ) {
            $Param{AccessRo} = 1;
            $Param{AccessRw} = 1;
        }
        else {
            for my $Permission (qw(GroupRo Group)) {
                my $AccessOk = 0;
                my $Group    = $ModuleReg->{$Permission};
                my $Key      = "UserIs$Permission";
                next if !$Group;
                if ( ref $Group eq 'ARRAY' ) {
                    for ( @{$Group} ) {
                        next if !$_;
                        next if !$UserData{ $Key . "[$_]" };
                        next if $UserData{ $Key . "[$_]" } ne 'Yes';
                        $AccessOk = 1;
                        last;
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
            if ( !$Param{AccessRo} && !$Param{AccessRw} || !$Param{AccessRo} && $Param{AccessRw} ) {

                # new layout object
                my $LayoutObject = Kernel::Output::HTML::Layout->new(
                    %{$Self},
                    Lang => $Param{Lang},
                );
                print $LayoutObject->NoPermission(
                    Message => 'No Permission to use this frontend module!'
                );
                return;
            }
        }

        # create new LayoutObject with new '%Param' and '%UserData'
        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            %{$Self},
            %Param,
            %UserData,
            ModuleReg => $ModuleReg,
        );

        # updated last request time
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Param{SessionID},
            Key       => 'UserLastRequest',
            Value     => $Self->{TimeObject}->SystemTime(),
        );

        # pre application module
        my $PreModule = $Self->{ConfigObject}->Get('PreApplicationModule');
        if ($PreModule) {
            my %PreModuleList;
            if ( ref $PreModule eq 'HASH' ) {
                %PreModuleList = %{$PreModule};
            }
            else {
                $PreModuleList{Init} = $PreModule;
            }
            for my $PreModuleKey ( sort keys %PreModuleList ) {
                my $PreModule = $PreModuleList{$PreModuleKey};
                next if !$PreModule;
                next if !$Self->{MainObject}->Require($PreModule);

                # debug info
                if ( $Self->{Debug} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "PreApplication module $PreModule is used.",
                    );
                }

                # use module
                my $PreModuleObject = $PreModule->new(
                    %{$Self},
                    %Param,
                    %UserData,
                    ModuleReg    => $ModuleReg,
                    LayoutObject => $LayoutObject,
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
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
            );
        }

        # proof of concept! - create $GenericObject
        my $GenericObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %{$Self},
            %Param,
            %UserData,
            LayoutObject => $LayoutObject,
            ModuleReg    => $ModuleReg,
        );

        # debug info
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
            );
        }

        # ->Run $Action with $GenericObject
        $LayoutObject->Print( Output => \$GenericObject->Run() );

        # log request time
        if ( $Self->{ConfigObject}->Get('PerformanceLog') ) {
            if ( ( !$QueryString && $Param{Action} ) || $QueryString !~ /Action=/ ) {
                $QueryString = 'Action=' . $Param{Action} . '&Subaction=' . $Param{Subaction};
            }
            my $File = $Self->{ConfigObject}->Get('PerformanceLog::File');
            ## no critic
            if ( open my $Out, '>>', $File ) {
                ## use critic
                print $Out time()
                    . '::Agent::'
                    . ( time() - $Self->{PerformanceLogStart} )
                    . "::$UserData{UserLogin}::$QueryString\n";
                close $Out;

                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Response::Agent: "
                        . ( time() - $Self->{PerformanceLogStart} )
                        . "s taken (URL:$QueryString:$UserData{UserLogin})",
                );
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't write $File: $!",
                );
            }
        }
        return 1;
    }

    # print an error screen
    my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $Param{SessionID}, );
    my $LayoutObject = Kernel::Output::HTML::Layout->new(
        %{$Self},
        %Param,
        %Data,
    );
    $LayoutObject->FatalError( Comment => 'Please contact your administrator' );
    return;
}

sub DESTROY {
    my $Self = shift;

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
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
