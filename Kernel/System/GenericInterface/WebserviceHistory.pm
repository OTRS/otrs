# --
# Kernel/System/GenericInterface/WebserviceHistory.pm - GenericInterface WebserviceHistory config backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: WebserviceHistory.pm,v 1.2 2011-02-09 10:00:09 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::WebserviceHistory;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CacheInternal;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::WebserviceHistory

=head1 SYNOPSIS

WebserviceHistory configuration history backend.
It holds older versions of web service configuration data.

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
    use Kernel::System::GenericInterface::WebserviceHistory;

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
    my $WebserviceHistoryObject = Kernel::System::GenericInterface::WebserviceHistory->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $WebserviceHistory, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $WebserviceHistory );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item WebserviceHistoryAdd()

add new WebserviceHistorys

    my $ID = $WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => 2134,
        Config  => {
            ...
        },
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceHistoryAdd {
    my ( $Self, %Param ) = @_;

}

=item WebserviceHistoryGet()

get WebserviceHistorys attributes

    my %WebserviceHistory = $WebserviceHistoryObject->WebserviceHistoryGet(
        ID => 123,
    );

Returns:

    %WebserviceHistory = (
        ...
    );

=cut

sub WebserviceHistoryGet {
    my ( $Self, %Param ) = @_;

}

=item WebserviceHistoryUpdate()

update WebserviceHistory attributes

    $WebserviceHistoryObject->WebserviceHistoryUpdate(
        ID      => 123,
        Config  => {
            ...
        },
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceHistoryUpdate {
    my ( $Self, %Param ) = @_;

}

=item WebserviceHistoryList()

get WebserviceHistory list for a GenericInterfaceven web service

    my @List = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => 1243,
    );

    or

    my @List = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => 1243,
    );

=cut

sub WebserviceHistoryList {
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

$Revision: 1.2 $ $Date: 2011-02-09 10:00:09 $

=cut
