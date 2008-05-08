# --
# Kernel/System/Web/InterfaceCustomer.pm - the customer interface file (incl. auth)
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: InterfaceCustomer.pm,v 1.30 2008-05-08 09:58:21 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Web::InterfaceCustomer;

use strict;
use warnings;

use vars qw($VERSION @INC);
$VERSION = qw($Revision: 1.30 $) [1];

# all framework needed modules
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::AuthSession;
use Kernel::System::CustomerAuth;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerGroup;
use Kernel::Output::HTML::Layout;

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
    my $InterfaceCustomer = Kernel::System::Web::InterfaceCustomer->new(Debug => $Debug);

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

    # create common framework objects 1/3
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{LogObject}    = Kernel::System::Log->new(
        LogPrefix => $Self->{ConfigObject}->Get('CGILogPrefix'),
        %{$Self},
    );
    $Self->{MainObject}   = Kernel::System::Main->new( %{$Self} );
    $Self->{EncodeObject} = Kernel::System::Encode->new( %{$Self} );
    $Self->{TimeObject}   = Kernel::System::Time->new( %{$Self} );
    $Self->{ParamObject}
        = Kernel::System::Web::Request->new( %{$Self}, WebRequest => $Param{WebRequest} || 0, );

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

    $InterfaceCustomer->Run();

=cut

sub Run {
    my ($Self) = @_;

    # get common framework params
    my %Param = ();

    # get session id
    $Param{SessionName} = $Self->{ConfigObject}->Get('CustomerPanelSessionName') || 'CSID';
    $Param{SessionID} = $Self->{ParamObject}->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ENV{QUERY_STRING} || '';
    $QueryString =~ s/(\?|&|)$Param{SessionName}(=&|=.+?&|=.+?$)/&/g;

    # definde frame work params
    my $FramworkPrams = {
        Lang         => '',
        Action       => '',
        Subaction    => '',
        RequestedURL => $QueryString,
    };
    for my $Key ( keys %{$FramworkPrams} ) {
        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key )
            || $FramworkPrams->{$Key};
    }

    # Check if the brwoser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $Self->{ParamObject}->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    # create common framework objects 2/3
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self}, Lang => $Param{Lang} );

    # check common objects
    $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
    if ( !$Self->{DBObject} ) {
        $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your admin' );
    }
    if ( $Self->{ParamObject}->Error() ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => $Self->{ParamObject}->Error(),
            Comment => 'Please contact your admin'
        );
    }

    # create common framework objects 3/3
    $Self->{UserObject}    = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{GroupObject}   = Kernel::System::CustomerGroup->new( %{$Self} );
    $Self->{SessionObject} = Kernel::System::AuthSession->new( %{$Self} );

    # application and add on application common objects
    my %CommonObject = %{ $Self->{ConfigObject}->Get('CustomerFrontend::CommonObject') };
    for my $Key ( keys %CommonObject ) {
        if ( $Self->{MainObject}->Require( $CommonObject{$Key} ) ) {

            # workaround for bug# 977 - do not use GroupObject in Kernel::System::Ticket
            $Self->{$Key} = $CommonObject{$Key}->new( %{$Self}, GroupObject => undef );
        }
        else {

            # print error
            $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your admin' );
        }
    }

    # get common application and add on application params
    my %CommonObjectParam = %{ $Self->{ConfigObject}->Get('CustomerFrontend::CommonParam') };
    for my $Key ( keys %CommonObjectParam ) {
        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non word chars)
    $Param{Action} =~ s/\W//g;

    # check request type
    if ( $Param{Action} eq 'Login' ) {

        # get params
        my $PostUser = $Self->{ParamObject}->GetParam( Param => 'User' )     || '';
        my $PostPw   = $Self->{ParamObject}->GetParam( Param => 'Password' ) || '';

        # create AuthObject
        my $AuthObject = Kernel::System::CustomerAuth->new( %{$Self} );

        # check submited data
        my $User = $AuthObject->Auth( User => $PostUser, Pw => $PostPw );
        if ($User) {

            # get user data
            my %UserData = $Self->{UserObject}->CustomerUserDataGet( User => $User, Valid => 1 );

            # check needed data
            if ( !$UserData{UserID} || !$UserData{UserLogin} ) {
                if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                    # redirect to alternate login
                    print $Self->{LayoutObject}->Redirect(
                        ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                            . '?Reason=SystemError',
                    );
                }
                else {

                    # show login screen
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Panic!',
                            Message => 'Panic! No UserData!!!',
                            %Param,
                        ),
                    );
                    exit 0;
                }
            }

            # last login preferences update
            $Self->{UserObject}->SetPreferences(
                UserID => $UserData{UserID},
                Key    => 'UserLastLogin',
                Value  => $Self->{TimeObject}->SystemTime(),
            );

            # create new session id
            my $NewSessionID = $Self->{SessionObject}->CreateSessionID(
                _UserLogin => $PostUser,
                _UserPw    => $PostPw,
                %UserData,
                UserLastRequest => $Self->{TimeObject}->SystemTime(),
                UserType        => 'Customer',
            );

            # set time zone offset if TimeZoneFeature is active
            if (
                $Self->{ConfigObject}->Get('TimeZoneUser')
                && $Self->{ConfigObject}->Get('TimeZoneUserBrowserAutoOffset')
                && $Self->{LayoutObject}->{BrowserJavaScriptSupport}
                )
            {
                my $TimeOffset = $Self->{ParamObject}->GetParam( Param => 'TimeOffset' ) || '';
                if ( $TimeOffset > 0 ) {
                    $TimeOffset = '-' . ( $TimeOffset / 60 );
                }
                else {
                    $TimeOffset = ( $TimeOffset / 60 );
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
            my $LayoutObject = Kernel::Output::HTML::Layout->new(
                SetCookies => {
                    SessionIDCookie => $Self->{ParamObject}->SetCookie(
                        Key     => $Param{SessionName},
                        Value   => $NewSessionID,
                        Expires => $Expires,
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
        }

        # login is vailid
        else {
            if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
                print $Self->{LayoutObject}->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                        . "?Reason=LoginFailed&RequestedURL=$Param{RequestedURL}",
                );
            }
            else {

                # show normal login
                $Self->{LayoutObject}->Print(
                    Output => \$Self->{LayoutObject}->CustomerLogin(
                        Title   => 'Login',
                        Message => $Self->{LogObject}->GetLogEntry(
                            Type => 'Info',
                            What => 'Message',
                            )
                            || 'Login failed! Your username or password was entered incorrectly.',
                        User => $PostUser,
                        %Param,
                    ),
                );
            }
        }
    }

    # Logout
    elsif ( $Param{Action} eq 'Logout' ) {
        if ( $Self->{SessionObject}->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # get session data
            my %UserData
                = $Self->{SessionObject}->GetSessionIDData( SessionID => $Param{SessionID}, );

            # create new LayoutObject with new '%Param' and '%UserData'
            $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
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

            # remove session id
            if ( $Self->{SessionObject}->RemoveSessionID( SessionID => $Param{SessionID} ) ) {
                if ( $Self->{ConfigObject}->Get('CustomerPanelLogoutURL') ) {

                    # redirect to alternate login
                    print $Self->{LayoutObject}->Redirect(
                        ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLogoutURL')
                            . "?Reason=Logout",
                    );
                }
                else {

                    # show logout screen
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Logout',
                            Message => 'Logout successful. Thank you for using OTRS!',
                            %Param,
                        ),
                    );
                }
            }
            else {
                $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your admin' );
            }
        }
        else {
            if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
                print $Self->{LayoutObject}->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
            }
            else {

                # show login screen
                print $Self->{LayoutObject}->CustomerLogin(
                    Title   => 'Logout',
                    Message => 'Invalid SessionID!',
                    %Param,
                );
            }
        }
    }

    # CustomerLostPassword
    elsif ( $Param{Action} eq 'CustomerLostPassword' ) {

        # check feature
        if ( !$Self->{ConfigObject}->Get('CustomerPanelLostPassword') ) {

            # show normal login
            $Self->{LayoutObject}->Print(
                Output => \$Self->{LayoutObject}->CustomerLogin(
                    Title   => 'Login',
                    Message => 'Feature not active!',
                ),
            );
            exit 0;
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
            for my $UserID ( keys %UserList ) {
                my %UserData = $Self->{UserObject}->CustomerUserDataGet(
                    User  => $UserID,
                    Valid => 1,
                );
                if (%UserData) {
                    $User = $UserData{UserLogin};
                    last;
                }
            }
        }

        # get user data
        my %UserData = $Self->{UserObject}->CustomerUserDataGet( User => $User );
        if ( !$UserData{UserID} ) {
            $Self->{LayoutObject}->Print(
                Output => \$Self->{LayoutObject}->CustomerLogin(
                    Title   => 'Login',
                    Message => 'There is no account with that login name.',
                ),
            );
        }
        else {

            # create email object
            my $EmailObject = Kernel::System::Email->new( %{$Self} );

            # send password reset token
            if ( !$Token ) {

                # generate token
                $UserData{Token} = $Self->{UserObject}->TokenGenerate(
                    UserID => $UserData{UserID},
                );

                # send token notify email with link
                my $Body = $Self->{ConfigObject}->Get('CustomerPanelBodyLostPasswordToken')
                    || 'ERROR: CustomerPanelBodyLostPasswordToken is missing!';
                my $Subject = $Self->{ConfigObject}->Get('CustomerPanelSubjectLostPasswordToken')
                    || 'ERROR: CustomerPanelSubjectLostPasswordToken is missing!';
                for ( keys %UserData ) {
                    $Body =~ s/<OTRS_$_>/$UserData{$_}/gi;
                }
                my $Sent = $EmailObject->Send(
                    To      => $UserData{UserEmail},
                    Subject => $Subject,
                    Charset => 'iso-8859-15',
                    Type    => 'text/plain',
                    Body    => $Body
                );
                if ($Sent) {
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Login',
                            Message => "Sent password token to: \%s\", \"$UserData{UserEmail}",
                            %Param,
                        ),
                    );
                    exit 0;
                }
                $Self->{LayoutObject}->FatalError(
                    Comment => 'Please contact your admin'
                );
            }

            # reset password
            else {

                # check if token is valid
                my $TokenValid = $Self->{UserObject}->TokenCheck(
                    Token  => $Token,
                    UserID => $UserData{UserID},
                );
                if ( !$TokenValid ) {
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Login',
                            Message => "Invalid Token!",
                            %Param,
                        ),
                    );
                    exit 0;
                }

                # get new password
                $UserData{NewPW} = $Self->{UserObject}->GenerateRandomPassword();

                # update new password
                $Self->{UserObject}->SetPassword( UserLogin => $User, PW => $UserData{NewPW} );

                # send notify email
                my $Body = $Self->{ConfigObject}->Get('CustomerPanelBodyLostPassword')
                    || "New Password is: <OTRS_NEWPW>";
                my $Subject = $Self->{ConfigObject}->Get('CustomerPanelSubjectLostPassword')
                    || 'New Password!';
                for ( keys %UserData ) {
                    $Body =~ s/<OTRS_$_>/$UserData{$_}/gi;
                }
                my $Sent = $EmailObject->Send(
                    To      => $UserData{UserEmail},
                    Subject => $Subject,
                    Charset => 'iso-8859-15',
                    Type    => 'text/plain',
                    Body    => $Body
                );
                if ($Sent) {
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Login',
                            Message => "Sent new password to: \%s\", \"$UserData{UserEmail}",
                            User    => $User,
                        ),
                    );
                }
                else {
                    $Self->{LayoutObject}->CustomerFatalError(
                        Comment => 'Please contact your admin'
                    );
                }
            }
        }
    }

    # create new customer account
    elsif ( $Param{Action} eq 'CustomerCreateAccount' ) {

        # check feature
        if ( !$Self->{ConfigObject}->Get('CustomerPanelCreateAccount') ) {

            # show normal login
            $Self->{LayoutObject}->Print(
                Output => \$Self->{LayoutObject}->CustomerLogin(
                    Title   => 'Login',
                    Message => 'Feature not active!',
                ),
            );
            exit 0;
        }

        # get params
        my %GetParams = ();
        for my $Entry ( @{ $Self->{ConfigObject}->Get('CustomerUser')->{Map} } ) {
            $GetParams{ $Entry->[0] } = $Self->{ParamObject}->GetParam( Param => $Entry->[1] )
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
        $GetParams{UserPassword} = $Self->{UserObject}->GenerateRandomPassword();

        # get user data
        my %UserData = $Self->{UserObject}->CustomerUserDataGet( User => $GetParams{UserLogin} );
        if ( $UserData{UserID} || !$GetParams{UserLogin} ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Area => 'Core', Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerWarning(
                Message => 'This account exists.',
                Comment => 'Please press Back and try again.'
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            $Self->{LayoutObject}->Print( Output => \$Output );
        }
        else {
            if (
                $Self->{UserObject}->CustomerUserAdd(
                    %GetParams,
                    Comment => 'Added via Customer Panel ('
                        . $Self->{TimeObject}->SystemTime2TimeStamp(
                        SystemTime => $Self->{TimeObject}->SystemTime()
                        )
                        . ")",
                    ValidID => 1,
                    UserID  => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                )
                )
            {

                # send notify email
                my $EmailObject = Kernel::System::Email->new( %{$Self} );
                my $Body        = $Self->{ConfigObject}->Get('CustomerPanelBodyNewAccount')
                    || 'No Config Option found!';
                my $Subject = $Self->{ConfigObject}->Get('CustomerPanelSubjectNewAccount')
                    || 'New OTRS Account!';
                for ( keys %GetParams ) {
                    $Body =~ s/<OTRS_$_>/$GetParams{$_}/gi;
                }

                # send account info
                my $Sent = $EmailObject->Send(
                    To      => $GetParams{UserEmail},
                    Subject => $Subject,
                    Charset => 'iso-8859-15',
                    Type    => 'text/plain',
                    Body    => $Body
                );
                if ( !$Sent ) {

                    my $Output = $Self->{LayoutObject}->CustomerHeader(
                        Area  => 'Core',
                        Title => 'Error'
                    );
                    $Output .= $Self->{LayoutObject}->CustomerWarning(
                        Comment => 'Can\'t send account info!'
                    );
                    $Output .= $Self->{LayoutObject}->CustomerFooter();
                    $Self->{LayoutObject}->Print( Output => \$Output );
                    exit 0;
                }

                # show sent account info
                if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                    # redirect to alternate login
                    $Param{RequestedURL}
                        = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
                    print $Self->{LayoutObject}->Redirect(
                        ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                            . "?RequestedURL=$Param{RequestedURL}&User=$GetParams{UserLogin}&"
                            . "&Email=$GetParams{UserEmail}&Reason=NewAccountCreated",
                    );
                }
                else {

                    # login screen
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title => 'Login',
                            Message =>
                                "New account created. Sent Login-Account to \%s.\", \"$GetParams{UserEmail}",
                            User => $GetParams{UserLogin},
                        ),
                    );
                }
            }
            else {
                my $Output
                    = $Self->{LayoutObject}->CustomerHeader( Area => 'Core', Title => 'Error' );
                $Output .= $Self->{LayoutObject}->CustomerWarning(
                    Comment => 'Please press Back and try again.'
                );
                $Output .= $Self->{LayoutObject}->CustomerFooter();
                $Self->{LayoutObject}->Print( Output => \$Output );
            }
        }
    }

    # show login site
    elsif ( !$Param{SessionID} ) {

        # create AuthObject
        my $AuthObject = Kernel::System::CustomerAuth->new( %{$Self} );
        if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

            # automatic login
            $Param{RequestedURL} = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
            print $Self->{LayoutObject}->Redirect(
                OP => "Action=Login&RequestedURL=$Param{RequestedURL}",
            );
        }
        elsif ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
            print $Self->{LayoutObject}->Redirect(
                ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                    . "?RequestedURL=$Param{RequestedURL}",
            );
        }
        else {

            # login screen
            $Self->{LayoutObject}->Print(
                Output => \$Self->{LayoutObject}->CustomerLogin(
                    Title => 'Login',
                    %Param,
                ),
            );
        }
    }

    # run modules if exists a version value
    elsif ( $Self->{MainObject}->Require("Kernel::Modules::$Param{Action}") ) {

        # check session id
        if ( !$Self->{SessionObject}->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # create new LayoutObject with new '%Param'
            $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
                SetCookies => {
                    SessionIDCookie => $Self->{ParamObject}->SetCookie(
                        Key   => $Param{SessionName},
                        Value => '',
                    ),
                },
                %{$Self},
                %Param,
            );
            if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $Self->{LayoutObject}->LinkEncode( $Param{RequestedURL} );
                print $Self->{LayoutObject}->Redirect(
                    ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );
            }
            else {

                # show login
                $Self->{LayoutObject}->Print(
                    Output => \$Self->{LayoutObject}->CustomerLogin(
                        Title   => 'Login',
                        Message => $Self->{SessionObject}->CheckSessionIDMessage(),
                        %Param,
                    ),
                );
            }
        }

        # run module
        else {

            # get session data
            my %UserData
                = $Self->{SessionObject}->GetSessionIDData( SessionID => $Param{SessionID}, );

            # check needed data
            if ( !$UserData{UserID} || !$UserData{UserLogin} || $UserData{UserType} ne 'Customer' )
            {
                if ( $Self->{ConfigObject}->Get('CustomerPanelLoginURL') ) {

                    # redirect to alternate login
                    print $Self->{LayoutObject}->Redirect(
                        ExtURL => $Self->{ConfigObject}->Get('CustomerPanelLoginURL')
                            . "?Reason=SystemError",
                    );
                }
                else {

                    # show login screen
                    $Self->{LayoutObject}->Print(
                        Output => \$Self->{LayoutObject}->CustomerLogin(
                            Title   => 'Panic!',
                            Message => 'Panic! Invalid Session!!!',
                            %Param,
                        ),
                    );
                    exit 0;
                }
            }

            # create new LayoutObject with new '%Param' and '%UserData'
            $Self->{LayoutObject}
                = Kernel::Output::HTML::Layout->new( %{$Self}, %Param, %UserData, );

            # module registry
            my $ModuleReg
                = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Param{Action} };
            if ( !$ModuleReg ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
                );
                $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your admin' );
            }

            # updated last request time
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Param{SessionID},
                Key       => 'UserLastRequest',
                Value     => $Self->{TimeObject}->SystemTime(),
            );

            # pre application module
            my $PreModule = $Self->{ConfigObject}->Get('CustomerPanelPreApplicationModule');
            if ($PreModule) {
                my %PreModuleList = ();
                if ( ref($PreModule) eq 'HASH' ) {
                    %PreModuleList = %{$PreModule};
                }
                else {
                    $PreModuleList{Init} = $PreModule;
                }
                for my $PreModuleKey ( sort keys %PreModuleList ) {
                    my $PreModule = $PreModuleList{$PreModuleKey};
                    if ( $PreModule && $Self->{MainObject}->Require($PreModule) ) {

                        # debug info
                        if ( $Self->{Debug} ) {
                            $Self->{LogObject}->Log(
                                Priority => 'debug',
                                Message => "CustomerPanelPreApplication module $PreModule is used.",
                            );
                        }

                        # use module
                        my $PreModuleObject = $PreModule->new( %{$Self}, %Param, %UserData, );
                        my $Output = $PreModuleObject->PreRun();
                        if ($Output) {
                            $Self->{LayoutObject}->Print( Output => \$Output );
                            exit 0;
                        }
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

            # prove of concept! - create $GenericObject
            my $GenericObject
                = ( 'Kernel::Modules::' . $Param{Action} )->new( %{$Self}, %Param, %UserData, );

            # debug info
            if ( $Self->{Debug} ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => '' . 'Kernel::Modules::' . $Param{Action} . '->run',
                );
            }

            # ->Run $Action with $GenericObject
            $Self->{LayoutObject}->Print( Output => \$GenericObject->Run() );

            # log request time
            if ( $Self->{ConfigObject}->Get('PerformanceLog') ) {
                if ( ( !$QueryString && $Param{Action} ) || ( $QueryString !~ /Action=/ ) ) {
                    $QueryString = "Action=" . $Param{Action};
                }
                my $File = $Self->{ConfigObject}->Get('PerformanceLog::File');
                if ( open my $Out, '>>', $File ) {
                    print $Out time()
                        . '::Customer::'
                        . ( time() - $Self->{PerformanceLogStart} )
                        . "::$UserData{UserLogin}::$QueryString\n";
                    close $Out;
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message  => 'Response::Customer: '
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
        }
    }

    # else print an error screen
    else {

        # create new LayoutObject with '%Param'
        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $Param{SessionID}, );
        $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self}, %Param, %Data, );

        # print error
        $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your admin' );
    }

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global handle stopped.',
        );
    }

    # db disconnect && undef %Param
    $Self->{DBObject}->Disconnect();
    undef %Param;
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.30 $ $Date: 2008-05-08 09:58:21 $

=cut
