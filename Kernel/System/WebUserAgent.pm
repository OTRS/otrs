# --
# Kernel/System/WebUserAgent.pm - a web user agent
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::WebUserAgent;

use strict;
use warnings;

use LWP::UserAgent;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA);

=head1 NAME

Kernel::System::WebUserAgent - a web user agent lib

=head1 SYNOPSIS

All web user agent functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::WebUserAgent;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
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
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
        Timeout      => 15,                  # optional, timeout
        Proxy        => 'proxy.example.com', # optional, proxy
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{Timeout} = $Param{Timeout} || $Self->{ConfigObject}->Get('WebUserAgent::Timeout') || 15;
    $Self->{Proxy} = $Param{Proxy} || $Self->{ConfigObject}->Get('WebUserAgent::Proxy');

    return $Self;
}

=item Request()

return the content of requested URL.

Simple GET request:

    my %Response = $WebUserAgentObject->Request(
        URL => 'http://example.com/somedata.xml',
    );

Or a POST request; attributes can be a hashref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => { Attribute1 => 'Value', Attribute2 => 'Value2' },
    );

alternatively, you can use an arrayref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => [ Attribute => 'Value', Attribute => 'OtherValue' ],
    );

returns

    %Response = (
        Status  => '200 OK',    # http status
        Content => $ContentRef, # content of requested URL
    );

=cut

sub Request {
    my ( $Self, %Param ) = @_;

    # define method - default to GET
    $Param{Type} = 'GET' if !defined $Param{Type};
    $Param{Type} = 'GET' if $Param{Type} ne 'POST';

    # init agent
    my $UserAgent = LWP::UserAgent->new();

    # set timeout
    $UserAgent->timeout( $Self->{Timeout} );

    # set user agent
    $UserAgent->agent(
        $Self->{ConfigObject}->Get('Product') . ' ' . $Self->{ConfigObject}->Get('Version')
    );

    # set proxy
    if ( $Self->{Proxy} ) {
        $UserAgent->proxy( [ 'http', 'https', 'ftp' ], $Self->{Proxy} );
    }

    my $Response;

    if ( $Param{Type} eq 'GET' ) {

        # perform get request on URL
        $Response = $UserAgent->get( $Param{URL} );
    }
    elsif ( $Param{Type} eq 'POST' ) {

        # check for Data param
        if ( !IsArrayRefWithData( $Param{Data} ) && !IsHashRefWithData( $Param{Data} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    'WebUserAgent POST: Need Data param containing a hashref or arrayref with data.',
            );
            return ( Status => 0 );
        }

        # perform post request plus data
        $Response = $UserAgent->post( $Param{URL}, $Param{Data} );
    }

    if ( !$Response->is_success() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't do $Param{Type} on $Param{URL}: " . $Response->status_line(),
        );
        return (
            Status => $Response->status_line(),
        );
    }

    # return request
    return (
        Status  => $Response->status_line(),
        Content => \$Response->content(),
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
