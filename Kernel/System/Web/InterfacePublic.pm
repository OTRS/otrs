# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfacePublic;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Web::Request',
);

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

    $Interface->Run();

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

    # Check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $ConfigObject->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $ParamObject->GetCookie( Key => $Param{SessionName} );
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
    my %CommonObjectParam = %{ $ConfigObject->Get('PublicFrontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non-word chars)
    $Param{Action} =~ s/\W//g;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            SessionIDCookie => 1,
            Debug           => $Self->{Debug},
        },
    );

    my $DBCanConnect = $Kernel::OM->Get('Kernel::System::DB')->Connect();

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$DBCanConnect ) {
        $LayoutObject->CustomerFatalError( Comment => 'Please contact your administrator' );
    }
    if ( $ParamObject->Error() ) {
        $LayoutObject->CustomerFatalError(
            Message => $ParamObject->Error(),
            Comment => 'Please contact your administrator'
        );
    }

    # run modules if a version value exists
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {
        $LayoutObject->CustomerFatalError( Comment => 'Please contact your administrator' );
        return 1;
    }

    # module registry
    my $ModuleReg = $ConfigObject->Get('PublicFrontend::Module')->{ $Param{Action} };
    if ( !$ModuleReg ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
        );
        $LayoutObject->CustomerFatalError( Comment => 'Please contact your administrator' );
        return;
    }

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
        );
    }

    my $FrontendObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
        UserID => 1,
        %Param,
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
            $QueryString = 'Action=' . $Param{Action} . '&Subaction=' . $Param{Subaction};
        }
        my $File = $ConfigObject->Get('PerformanceLog::File');
        ## no critic
        if ( open my $Out, '>>', $File ) {
            ## use critic
            print $Out time()
                . '::Public::'
                . ( time() - $Self->{PerformanceLogStart} )
                . "::-::$QueryString\n";
            close $Out;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => 'Response::Public: '
                    . ( time() - $Self->{PerformanceLogStart} )
                    . "s taken (URL:$QueryString)",
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
