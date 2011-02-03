# --
# Kernel/System/GI/Webservice.pm - GI webservice config backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Webservice.pm,v 1.2 2011-02-03 09:54:43 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GI::Webservice;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CacheInternal;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::Webservice

=head1 SYNOPSIS

Webservice configuration backend.

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
    use Kernel::System::GI::Webservice;

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
    my $WebserviceObject = Kernel::System::GI::Webservice->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Webservice, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Webservice );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item WebserviceAdd()

add new Webservices

    my $ID = $WebserviceObject->WebserviceAdd(
        Config  => {
            ...
        },
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceAdd {
    my ( $Self, %Param ) = @_;

}

=item WebserviceGet()

get Webservices attributes

    my %Webservice = $WebserviceObject->WebserviceGet(
        ID => 123,
    );

Returns:

    %Webservice = (
        ...
    );

=cut

sub WebserviceGet {
    my ( $Self, %Param ) = @_;

}

=item WebserviceUpdate()

update Webservice attributes

    $WebserviceObject->WebserviceUpdate(
        ID      => 123,
        Config  => {
            ...
        },
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceUpdate {
    my ( $Self, %Param ) = @_;

}

=item WebserviceList()

get Webservice list

    my @List = $WebserviceObject->WebserviceList();

    or

    my @List = $WebserviceObject->WebserviceList(
        Valid => 0, # optional, defaults to 1
    );

=cut

sub WebserviceList {
    my ( $Self, %Param ) = @_;

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

$Revision: 1.2 $ $Date: 2011-02-03 09:54:43 $

=cut
