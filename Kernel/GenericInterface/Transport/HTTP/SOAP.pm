# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.pm,v 1.10 2011-03-09 12:37:17 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use strict;
use warnings;

use HTTP::Status;
use SOAP::Lite;
use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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
    for my $Needed (qw(MainObject EncodeObject DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

#TODO QA: add perldoc to all functions!

# FIXME perldoc for all functions
sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return $Self->_Error(
            Summary   => 'Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace config
    if ( !IsStringWithData( $Config->{NameSpace} ) ) {
        return $Self->_Error(
            Summary   => 'Have no NameSpace in config',
            HTTPError => 500,
        );
    }

    # check basic stuff
    my $Length = $ENV{'CONTENT_LENGTH'};

    # no length provided
    if ( !$Length ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(411),
            HTTPError => 411,
        );
    }

    # request bigger than allowed
    if ( IsInteger( $Config->{MaxLength} ) && $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(413),
            HTTPError => 413,
        );
    }

    # in case client requests to continue submission, tell it to continue
    if ( IsStringWithData( $ENV{EXPECT} ) && $ENV{EXPECT} =~ m{ \b 100-Continue \b }xmsi ) {
        $Self->_Output(
            HTTPCode => 100,
            Content  => '',
        );
    }

    # check if we have a soap action and assign operation and namespace
    #TODO QA: next line not needed
    my $OrgSOAPAction = $ENV{'HTTP_SOAPACTION'};

    #TODO QA: don't use $1, $2 etc. Use list context instead, like
    #    my ($SOAPAction) = $ENV{'HTTP_SOAPACTION'} =~ m{ \A ["'] ( .+ ) ["'] \z }xms;
    my $SOAPAction = $1 if $OrgSOAPAction =~ m{ \A ["'] ( .+ ) ["'] \z }xms;
    my $NameSpace;
    my $Operation;

    #TODO QA: consider to improve capturing, see above
    if ( $SOAPAction && $SOAPAction =~ m{ \A ( .+? ) ( [^/]+ ) \z }xms ) {
        $NameSpace = $1;
        $Operation = $2;
        $Operation =~ s{ \A [#] }{}xms;

        #TODO QA: NEVER store data in %ENV! If you really need a member, store in $Self!
        # remember for response
        $ENV{Operation} = $Operation;
    }

    # do we have a soap action
    if ( !$OrgSOAPAction ) {
        return $Self->_Error(
            Summary   => 'No SOAPAction given',
            HTTPError => 500,
        );
    }

    # does soap action resolve to namespace and operation
    if ( !$SOAPAction || !$NameSpace || !$Operation ) {
        return $Self->_Error(
            Summary   => "Invalid SOAPAction '$SOAPAction'",
            HTTPError => 500,
        );
    }

    # check namespace for match to configuration
    if ( $Config->{NameSpace} ne $NameSpace ) {
        my $NameSpaceError =
            "Provided namespace '$NameSpace' does not match"
            . " configured namespace '$Config->{NameSpace}'";
        return $Self->_Error(
            Summary   => $NameSpaceError,
            HTTPError => 500,
        );
    }

    # read request
    my $Content;
    binmode(STDIN);
    read STDIN, $Content, $Length;

    # convert charset if necessary
    my $ContentCharset = $1
        if $ENV{'CONTENT_TYPE'} =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi;
    if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
        $Content = $Self->{EncodeObject}->Convert2CharsetInternal(
            Text => $Content,
            From => $ContentCharset,
        );
    }

    # check if we have a content
    if ( !IsStringWithData($Content) ) {
        return $Self->_Error(
            Summary   => 'Could not read input data',
            HTTPError => 500,
        );
    }

    # deserialize
    my $Deserialized = eval { SOAP::Deserializer->deserialize($Content); };
    my $DeserializedFault = $@ || '';
    if ($DeserializedFault) {
        return $Self->_Error(
            Summary   => 'Error deserializing message:' . $DeserializedFault,
            HTTPError => 500,
        );
    }

    # check if the deserialized result is there
    if ( !defined $Deserialized || !$Deserialized->body() ) {
        return $Self->_Error(
            Summary   => 'Got no result body from deserialized content',
            HTTPError => 500,
        );
    }

    # check if we have data for the specified operation in the result
    my $Body = $Deserialized->body();
    if ( !defined $Body->{$Operation} ) {
        return $Self->_Error(
            Summary =>
                "No data found for specified operation '$Operation' in deserialized content",
            HTTPError => 500,
        );
    }

    # all ok - return data
    return {
        Success   => 1,
        Operation => $Operation,
        Data      => $Body->{$Operation},
    };
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    #TODO QA: don't use %ENV to store data!
    # do we have a http error message to return
    if ( IsStringWithData( $ENV{HTTPError} ) && IsStringWithData( $ENV{HTTPMessage} ) ) {
        return $Self->_Output(
            HTTPCode => $ENV{HTTPError},
            Content  => $ENV{HTTPMessage},
        );
    }

    # check data param
    if ( defined $Param{Data} && !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Invalid Data',
        );
    }

    # prepare data
    my $SOAPResult;
    if ( defined $Param{Data} ) {
        my $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
        );

        # check output of recursion
        if ( !$SOAPData->{Success} ) {
            return $Self->_Output(
                HTTPCode => 500,
                Content  => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            );
        }
        $SOAPResult = SOAP::Data->value( @{ $SOAPData->{Data} } );
    }
    else {
        $SOAPResult = SOAP::Data->value('');
    }

    # check soap result
    if ( ref $SOAPResult ne 'SOAP::Data' ) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Error in SOAP result',
        );
    }

    # create return structure
    my $Serialized = SOAP::Serializer
        ->autotype(0)

        #TODO QA: don't use %ENV to store local data!
        ->envelope( response => $ENV{Operation} . 'Response', $SOAPResult );
    my $SerializedFault = $@ || '';
    if ($SerializedFault) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Error serializing message:' . $SerializedFault,
        );
    }

    # no error - return output
    return $Self->_Output(
        HTTPCode => 200,
        Content  => $Serialized,
    );
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Have no TransportConfig',
        };
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace and endpoint config
    NEEDED:
    for my $Needed (qw(Endpoint NameSpace)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "Have no $Needed in config",
        };
    }

    # check data param
    if ( defined $Param{Data} && !IsHashRefWithData( $Param{Data} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Invalid Data',
        };
    }

    # check operation param
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Need Operation',
        };
    }

    # prepare data
    my $SOAPData;
    if ( defined $Param{Data} ) {
        $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
        );

        # check output of recursion
        if ( !$SOAPData->{Success} ) {
            return {
                Success      => 0,
                ErrorMessage => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            };
        }
    }
    else {
        $SOAPData->{Data} = [''];
    }

    # prepare method
    my $SOAPMethod = SOAP::Data
        ->name( $Param{Operation} )
        ->uri( $Config->{NameSpace} );
    if ( ref $SOAPMethod ne 'SOAP::Data' ) {
        return {
            Success      => 0,
            ErrorMessage => 'Error preparing used method',
        };
    }

    # prepare connect
    my $SOAPHandle = eval {
        SOAP::Lite
            ->autotype(0)
            ->default_ns( $Config->{NameSpace} )
            ->proxy(
            $Config->{Endpoint},
            timeout => 60,
            );
    };
    my $SOAPHandleFault = $@ || '';
    if ($SOAPHandleFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error creating SOAPHandle: ' . $SOAPHandleFault,
        };
    }

    # send request to server
    my $SOAPResult = eval {
        $SOAPHandle->call(
            $SOAPMethod => $SOAPData->{Data},
        );
    };
    my $SOAPResultFault = $@ || '';
    if ($SOAPResultFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error in SOAP call: ' . $SOAPResultFault,
        };
    }

    # check if the soap result is there
    if ( !defined $SOAPResult || !$SOAPResult->body() ) {
        return {
            Success      => 0,
            ErrorMessage => 'Got no result body from soap call',
        };
    }

    # check if we have response data for the specified operation in the soap result
    my $Body = $SOAPResult->body();
    if ( !defined $Body->{ $Param{Operation} . 'Response' } ) {
        return {
            Success => 0,
            ErrorMessage =>
                "No response data found for specified operation '$Param{Operation}'"
                . " in soap response",
        };
    }

    # all ok - return result
    return {
        Success => 1,
        Data    => $Body->{ $Param{Operation} . 'Response' },
    };
}

sub _Error {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !defined $Param{Summary} || !IsString( $Param{Summary} ) ) {
        return $Self->_Error(
            Summary   => 'Need Summary!',
            HTTPError => 500,
        );
    }

    # log to debugger
    $Self->{DebuggerObject}->Error(
        Summary => $Param{Summary},
    );

    #TODO QA: Never store data in %ENV!
    # remember for response
    if ( IsStringWithData( $Param{HTTPError} ) ) {
        $ENV{HTTPError}   = $Param{HTTPError};
        $ENV{HTTPMessage} = $Param{Summary};
    }

    # return to provider/requester
    return {
        Success      => 0,
        ErrorMessage => $Param{Summary},
    };
}

sub _Output {
    my ( $Self, %Param ) = @_;

    # check params
    my $Success = 1;
    my $ErrorMessage;
    if ( defined $Param{HTTPCode} && !IsInteger( $Param{HTTPCode} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid internal HTTPCode';
        $Success         = 0;
        $ErrorMessage    = 'Invalid internal HTTPCode';
    }
    elsif ( defined $Param{Content} && !IsString( $Param{Content} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid Content';
        $Success         = 0;
        $ErrorMessage    = 'Invalid Content';
    }

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
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 500;
    my $ContentType;
    if ( $Param{HTTPCode} eq 200 ) {
        $ContentType = 'text/xml';
    }
    else {
        $ContentType = 'text/plain';
    }
    my $ContentLength;
    {
        use bytes;
        $ContentLength = length $Param{Content};
    };

    #TODO QA: if code is not 200, no debugger entry is written? Please check.
    # log to debugger
    if ( $Param{HTTPCode} eq 200 ) {
        $Self->{DebuggerObject}->Debug(
            Summary => 'Successfully return data to remote system',
            Data    => $Param{Content},
        );
    }

    my $StatusMessage = HTTP::Status::status_message( $Param{HTTPCode} );

    # print data to http
    print STDOUT <<"EOF";
$Status $Param{HTTPCode} $StatusMessage
Content-Type: $ContentType; charset=UTF-8
Content-Length: $ContentLength

$Param{Content}
EOF

    return {
        Success      => $Success,
        ErrorMessage => $ErrorMessage,
    };
}

sub _SOAPOutputRecursion {
    my ( $Self, %Param ) = @_;

    my @Result;
    if ( !defined $Param{Data} ) {
        return {
            Success      => 0,
            ErrorMessage => 'Undefined param found',
        };
    }
    if ( IsString( $Param{Data} ) ) {
        return {
            Success => 1,
            Data    => [ $Param{Data} ],
        };
    }
    if ( IsArrayRefWithData( $Param{Data} ) ) {
        KEY:
        for my $Key ( @{ $Param{Data} } ) {
            if ( IsString($Key) ) {
                push @Result, $Key;
                next KEY;
            }
            my $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Key );
            if ( !$RecurseResult->{Success} ) {
                return $RecurseResult;
            }
            push @Result, \SOAP::Data->value(
                @{ $RecurseResult->{Data} },
            );
        }
        return {
            Success => 1,
            Data    => \@Result,
        };
    }
    if ( IsHashRefWithData( $Param{Data} ) ) {
        for my $Key ( sort keys %{ $Param{Data} } ) {
            my $RecurseResult;
            my $Value;
            if ( IsString( $Param{Data}->{$Key} ) ) {
                $Value = $Param{Data}->{$Key} || '';
            }
            elsif ( IsHashRefWithData( $Param{Data}->{$Key} ) ) {
                $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} );
                if ( !$RecurseResult->{Success} ) {
                    return $RecurseResult;
                }
                $Value = \SOAP::Data->value(
                    @{ $RecurseResult->{Data} },
                );
            }
            elsif ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {
                $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} );
                if ( !$RecurseResult->{Success} ) {
                    return $RecurseResult;
                }
                $Value = SOAP::Data->value(
                    @{ $RecurseResult->{Data} },
                );
            }
            push @Result, SOAP::Data->name($Key)->value($Value);
        }
        return {
            Success => 1,
            Data    => \@Result,
        };
    }
    return {
        Success      => 0,
        ErrorMessage => 'Param is not a string an array reference or a hash reference',
    };
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

$Revision: 1.10 $ $Date: 2011-03-09 12:37:17 $

=cut
