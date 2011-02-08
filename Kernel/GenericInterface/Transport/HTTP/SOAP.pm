# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.pm,v 1.2 2011-02-08 15:08:28 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Transport::SOAP

=head1 SYNOPSIS

GenericInterface network transport interface for HTTP::SOAP

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    #my $Self = {};
    #bless( $Self, $Type );

    # check needed objects
    #for (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
    #    $Self->{$_} = $Param{$_} || die "Got no $_!";
    #}

    # TODO: implement backend loading and returning

    return;
}

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
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

$Revision: 1.2 $ $Date: 2011-02-08 15:08:28 $

=cut
