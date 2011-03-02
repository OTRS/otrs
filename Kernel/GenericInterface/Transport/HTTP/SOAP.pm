# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.pm,v 1.6 2011-03-02 09:29:44 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use strict;
use warnings;

use HTTP::Headers;
use HTTP::Request;
use HTTP::Response;
use HTTP::Status;
use SOAP::Lite;
use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::GenericInterface::Transport::SOAP - GenericInterface network transport interface for HTTP::SOAP

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Transport->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(
        MainObject ConfigObject LogObject EncodeObject TimeObject DBObject
        DebuggerObject TransportConfig
        )
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # prepare config
    # FIXME check if config is ok
    my $Config = $Self->{TransportConfig}->{Config};

    # check basic stuff
    my $Length = $ENV{'CONTENT_LENGTH'};

    # no length provided
    if ( !$Length ) {
        return $Self->_Error(
            Summary   => 'HTTP 411 Length Required',
            HTTPError => 411,
        );
    }

    # request bigger than allowed
    if ( $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => 'HTTP 413 Request Entity Too Large',
            HTTPError => 413,
        );
    }

    # in case client requests to continue submission
    if ( IsStringWithData( $ENV{EXPECT} ) && $ENV{EXPECT} =~ m{ \b 100-Continue \b }xmsi ) {
        $Self->_Output(
            HTTPCode => 100,
            Content  => '',
        );
    }

    # read request
    my $Content;
    binmode(STDIN);
    read STDIN, $Content, $Length;

    # parse request
    my $Request = HTTP::Request->new(
        $ENV{'REQUEST_METHOD'} || '' => $ENV{'SCRIPT_NAME'},
        HTTP::Headers->new(
            map {
                (
                    /^HTTP_(.+)/i
                    ? ( $1 =~ m/SOAPACTION/ )
                            ? ('SOAPAction')
                            : ($1)
                    : $_
                    ) => $ENV{$_}
                } keys %ENV
        ),
        $Content,
    );

    # check if we have a soap action
    if ( !$Request->header('SOAPAction') ) {
        return $Self->_Error(
            Summary     => 'No SOAPAction given',
            HTTPError   => 500,
            HTTPMessage => 'No SOAPAction given',
        );
    }

    # check soap action for matching namespace and get operation
    my $SOAPAction = $Request->header('SOAPAction');
    $SOAPAction =~ s{ \A (?: " | ' ) ( .+ ) ( ?: " | ' ) \z }{$1}xms;
    my $NameSpace;
    if ( $SOAPAction =~ m{ \A ( .+? ) ( [^/]+ ) \z }xms ) {
        $NameSpace = $1;
        $Self->{Operation} = $2;
    }
    if ( $Config->{NameSpace} ne $NameSpace ) {
        my $NameSpaceError =
            "Provided namespace '$NameSpace' does not match"
            . " configured namespace '$Config->{NameSpace}'";
        return $Self->_Error(
            Summary     => $NameSpaceError,
            HTTPError   => 500,
            HTTPMessage => $NameSpaceError,
        );
    }

    # deserialize
    my $Deserialized = eval { SOAP::Deserializer->deserialize( $Request->content() ); };
    my $DeserializerError = $@;
    if ($DeserializerError) {
        return $Self->_Error(
            Summary     => "Error deserializing message: $DeserializerError",
            HTTPError   => 500,
            HTTPMessage => "Error deserializing message: $DeserializerError",
        );
    }

    my $Body = $Deserialized->body();
    return {
        Success   => 1,
        Operation => $Self->{Operation},
        Data      => $Body->{ $Self->{Operation} },
    };
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    my $Response;

    # if we have a http error message
    if ( IsStringWithData( $Self->{HTTPError} ) ) {
        return $Self->_Output(
            HTTPCode => $Self->{HTTPError},
            Content  => $Self->{HTTPMessage},
        );
    }

    # prepare data
    my @SOAPData = $Self->_SOAPOutputRecursion(
        Data => $Param{Data},
    );

    # create return structure
    my $SOAPResult = SOAP::Data->value(@SOAPData);
    my $Content    = SOAP::Serializer
        ->autotype(0)
        ->envelope( response => $Self->{Operation} . 'Response', $SOAPResult, );

    return $Self->_Output(
        HTTPCode => 200,
        Content  => $Content,
    );
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub _Error {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(HTTPError Summary)) {
        next NEEDED if IsStringWithData( $Param{$Needed} );

        return $Self->{DebuggerObject}->Error(
            Summary => "Need $Needed!",
        );
    }

    # set error data and log error
    $Self->{DebuggerObject}->Error(
        Summary => $Param{Summary},
    );
    $Self->{HTTPError} = $Param{HTTPError};
    if ( IsString( $Param{HTTPMessage} ) ) {
        $Self->{HTTPMessage} = $Param{HTTPMessage};
    }
    return {
        Success => 0,
    };
}

sub _Output {
    my ( $Self, %Param ) = @_;

    # imitate nph- cgi for IIS
    my $Status;

    # FIXME is this correct? it seems to break things for apache
    # if ( IsStringWithData($ENV{'SERVER_SOFTWARE'}) && $ENV{'SERVER_SOFTWARE'} =~ m{ IIS }xms ) {
    $Status = $ENV{SERVER_PROTOCOL} || 'HTTP/1.0';

    # }
    # else {
    #     $Status = 'Status:';
    # }

    # prepare data
    my $ContentType;
    if ( $Param{HTTPCode} eq 200 ) {
        $ContentType = 'text/xml';
    }
    else {
        $ContentType = 'text/plain';
    }
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 200;
    my $Response = HTTP::Response->new( $Param{HTTPCode} );
    $Response->header( 'Content-Type' => $ContentType . '; charset=UTF-8' );
    $Response->content( $Param{Content} );
    {
        use bytes;
        $Response->header( 'Content-Length' => length $Param{Content} );
    }
    my $Code = $Response->code();

    # return data
    binmode(STDOUT);
    print STDOUT
        "$Status $Code ",
        HTTP::Status::status_message($Code),
        "\015\012", $Response->headers_as_string("\015\012"),
        "\015\012", $Response->content();

    return {
        Success => 1,
    };
}

sub _SOAPOutputRecursion {
    my ( $Self, %Param ) = @_;

    my @Result;
    if ( IsArrayRefWithData( $Param{Data} ) ) {
        for my $Key ( @{ $Param{Data} } ) {
            push @Result, \SOAP::Data->value(
                $Self->_SOAPOutputRecursion( Data => $Key )
            );
        }
        return @Result;
    }
    if ( IsHashRefWithData( $Param{Data} ) ) {
        for my $Key ( sort keys %{ $Param{Data} } ) {
            my $Value;
            if ( IsString( $Param{Data}->{$Key} ) ) {
                $Value = $Param{Data}->{$Key} || '';
            }
            elsif ( IsHashRefWithData( $Param{Data}->{$Key} ) ) {
                $Value = \SOAP::Data->value(
                    $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} )
                );
            }
            elsif ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {
                $Value = SOAP::Data->value(
                    $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} )
                );
            }
            push @Result, SOAP::Data->name($Key)->value($Value);
        }
        return @Result;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.6 $ $Date: 2011-03-02 09:29:44 $

=cut
