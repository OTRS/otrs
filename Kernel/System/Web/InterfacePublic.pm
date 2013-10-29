# --
# Kernel/System/Web/InterfacePublic.pm - the public interface file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfacePublic;

use strict;
use warnings;

# all framework needed  modules
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::CustomerUser;
use Kernel::Output::HTML::Layout;

=head1 NAME

Kernel::System::Web::InterfacePublic - the public web interface

=head1 SYNOPSIS

the global public web interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create public web interface object

    use Kernel::System::Web::InterfacePublic;

    my $Debug = 0;
    my $Interface = Kernel::System::Web::InterfacePublic->new(
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

    # create common framework objects 1/3
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

    $Interface->Run();

=cut

sub Run {
    my $Self = shift;

    # get common framework params
    my %Param;

    # get session id
    $Param{SessionName} = $Self->{ConfigObject}->Get('CustomerPanelSessionName') || 'CSID';
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

    # Check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $Self->{ParamObject}->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    # get common application and add-on application params
    # Important!
    # This must be done before creating the layout object,
    # because otherwise the action parameter is not passed and then
    # the loader can not load module specific JavaScript and CSS
    # For details see bug: http://bugs.otrs.org/show_bug.cgi?id=6471
    my %CommonObjectParam = %{ $Self->{ConfigObject}->Get('PublicFrontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non-word chars)
    $Param{Action} =~ s/\W//g;

    # create common framework objects 2/3
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
        %Param,
        SessionIDCookie => 1,
        %{$Self},
        Lang => $Param{Lang},
    );

    # check common objects
    $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
    if ( !$Self->{DBObject} ) {
        $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your administrator' );
    }
    if ( $Self->{ParamObject}->Error() ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => $Self->{ParamObject}->Error(),
            Comment => 'Please contact your administrator'
        );
    }

    # create common framework objects 3/3
    $Self->{UserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # application and add-on application common objects
    my %CommonObject = %{ $Self->{ConfigObject}->Get('PublicFrontend::CommonObject') };
    for my $Key ( sort keys %CommonObject ) {
        if ( $Self->{MainObject}->Require( $CommonObject{$Key} ) ) {
            $Self->{$Key} = $CommonObject{$Key}->new( %{$Self} );
        }
        else {

            # print error
            $Self->{LayoutObject}->CustomerFatalError(
                Comment => 'Please contact your administrator',
            );
        }
    }

    # run modules if a version value exists
    if ( !$Self->{MainObject}->Require("Kernel::Modules::$Param{Action}") ) {
        $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your administrator' );
        return 1;
    }

    # module registry
    my $ModuleReg = $Self->{ConfigObject}->Get('PublicFrontend::Module')->{ $Param{Action} };
    if ( !$ModuleReg ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
        );
        $Self->{LayoutObject}->CustomerFatalError( Comment => 'Please contact your administrator' );
        return;
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
        UserID => 1,
        %{$Self},
        %Param,
    );

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
        );
    }

    # ->Run $Action with $GenericObject
    $Self->{LayoutObject}->Print( Output => \$GenericObject->Run() );

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
                . '::Public::'
                . ( time() - $Self->{PerformanceLogStart} )
                . "::-::$QueryString\n";
            close $Out;
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => 'Response::Public: '
                    . ( time() - $Self->{PerformanceLogStart} )
                    . "s taken (URL:$QueryString)",
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
