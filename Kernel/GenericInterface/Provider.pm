# --
# Kernel/GenericInterface/Provider.pm - GenericInterface provider handler
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Provider.pm,v 1.2 2011-02-08 09:10:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Provider;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

# all framework needed modules
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::DB;

=head1 NAME

Kernel::GenericInterface::Provider

=head1 SYNOPSIS

GenericInterface handler for incoming web service requests.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::GenericInterface::Provider;

    my $Debug = 0;
    my $Provider = Kernel::GenericInterface::Provider->new( Debug => $Debug );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # create common framework objects 1/2
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'GenericInterfaceProvider',
        %{$Self},
    );
    $Self->{EncodeObject} = Kernel::System::Encode->new( %{$Self} );
    $Self->{MainObject}   = Kernel::System::Main->new( %{$Self} );
    $Self->{TimeObject}   = Kernel::System::Time->new( %{$Self} );
    $Self->{DBObject}     = Kernel::System::DB->new( %{$Self} );

    return $Self;
}

=item Run()

receives the current incoming web service request, handles it,
and returns an appropriate answer based on the configured requested
web service.

    # put this in the handler script
    $ProviderObject->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    #TODO: implement

    # determine webservice ID with $ENV{QUERY_STRING}
    # get webservice config
    # get request data

    # call $Self->_HandleRequest()

    # print out response

}

=item _HandleRequest()

handles the request data and returns the response data.

    my $Response = $ProviderObject->_HandleRequest(
        WebserviceConfig => {
            ...
        },
        Request          => $Request,   # complete request data
    );

=cut

sub _HandleRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement

    #return response
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

$Revision: 1.2 $ $Date: 2011-02-08 09:10:02 $

=cut
