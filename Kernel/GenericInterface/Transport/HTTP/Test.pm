# --
# Kernel/GenericInterface/Transport/HTTP/Test.pm - GenericInterface network transport interface for testing
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.2 2011-02-08 15:26:29 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::Test;

use strict;
use warnings;

use LWP::UserAgent;
use LWP::Protocol;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Transport::Test

=head1 SYNOPSIS

GenericInterface network transport interface for testing purposes.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Transport::HTTP::Test;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        ConfigObject   => $ConfigObject,
        EncodeObject   => $EncodeObject,
        LogObject      => $LogObject,
        MainObject     => $MainObject,
        DebuggerObject => $DebuggerObject,
    );
    my $TransportObject = Kernel::GenericInterface::Transport::HTTP::Test->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        TransportConfig => {
            Type => 'HTTP::Test',
            Config => {
                Fail => 0,  # 0 or 1
            },
        },
    );

In the config parameter 'Fail' you can tell the transport to simulate
failed network requests. If 'Fail' is set to 0, the transport will return
the query string of the requests as return data (see L<RequesterPerformRequest>
for an example);

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (
        qw(DebuggerObject TransportConfig)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || return { ErrorMessage => "Got no $Needed!" };
    }

    return $Self;
}

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

=item RequesterPerformRequest()

in Fail mode, returns error status. Otherwise, returns the
query string generated out of the data for the HTTP response.

    my $Result = $TransportObject->RequesterPerformRequest(
        Data => {
            A => 'A',
            b => 'b',
        },
    );

Returns

    $Result = {
        Success => 1,
        Data => {
            ResponseData => 'A=A&b=b',
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    if ( $Self->{TransportConfig}->{Config}->{Fail} ) {
        return {
            Success      => 0,
            ErrorMessage => "HTTP status code: 500",
            Data         => {},
        };
    }

    LWP::Protocol::implementor(
        testhttp => 'Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol'
    );
    my $UserAgent = LWP::UserAgent->new();
    my $Response = $UserAgent->post( 'testhttp://testhost.local/', Content => $Param{Data} );

    return {
        Success => 1,
        Data    => {
            ResponseContent => $Response->content,
        },
    };
}

=back

=begin Internal:

=cut

=head1 NAME

Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol

=head1 SYNOPSIS

This package is used to handle the custom HTTP requests of
Kernel::GenericInterface::Transport::HTTP::Test.
The requests are immediately answered with a response, without
sending them out to the network.

=cut

package Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol;

use base qw(LWP::Protocol);

sub new {
    my $Class = shift;
    return $Class->SUPER::new(@_);
}

sub request {
    my $Self = shift;
    my ( $Request, $Proxy, $Arg, $Size, $Timeout ) = @_;

    my $Response = HTTP::Response->new( 200 => "OK" );
    $Response->content( $Request->content );
    $Response->content_type("text/plain");
    $Response->date(time);

    #print $Request->as_string;
    #print $Response->as_string;

    return $Response;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2011-02-08 15:26:29 $

=cut
