# --
# Kernel/GI/Transport/HTTP/REST.pm - GenericInterface network transport interface for HTTP::REST
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: REST.pm,v 1.1 2011-02-02 14:41:38 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GI::Transport::HTTP::REST;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

sub RequesterGenerateRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub RequesterProcessResponse {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

1;
