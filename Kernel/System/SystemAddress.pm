# --
# Kernel/System/SystemAddress.pm - lib for system addresses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: SystemAddress.pm,v 1.34 2011-01-31 07:49:47 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SystemAddress;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.34 $) [1];

=head1 NAME

Kernel::System::SystemAddress - all system address functions

=head1 SYNOPSIS

Global module to add/edit/update system addresses.

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
    use Kernel::System::SystemAddress;

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
    my $SystemAddressObject = Kernel::System::SystemAddress->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject EncodeObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item SystemAddressAdd()

add system address with attributes

    my $ID = $SystemAddressObject->SystemAddressAdd(
        Name     => 'info@example.com',
        Realname => 'Hotline',
        ValidID  => 1,
        QueueID  => 123,
        Comment  => 'some comment',
        UserID   => 123,
    );

=cut

sub SystemAddressAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO system_address (value0, value1, valid_id, comments, queue_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Realname}, \$Param{ValidID}, \$Param{Comment},
            \$Param{QueueID}, \$Param{UserID}, \$Param{UserID},
        ],
    );
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM system_address WHERE value0 = ? AND value1 = ?',
        Bind => [ \$Param{Name}, \$Param{Realname}, ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item SystemAddressGet()

get system address with attributes

    my %SystemAddress = $SystemAddressObject->SystemAddressGet(
        ID => 1,
    );

returns:

    %SystemAddress = (
        'ID'         => 1,
        'Name'       => 'info@example.com'
        'Realname'   => 'Hotline',
        'QueueID'    => 123,
        'Comment'    => 'some comment',
        'ValidID'    => 1,
        'CreateTime' => '2010-11-29 11:04:04',
        'ChangeTime' => '2010-12-07 12:33:56',
    )

=cut

sub SystemAddressGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT value0, value1, comments, valid_id, queue_id, change_time, create_time '
            . ' FROM system_address WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Realname   => $Data[1],
            Comment    => $Data[2],
            ValidID    => $Data[3],
            QueueID    => $Data[4],
            ChangeTime => $Data[5],
            CreateTime => $Data[6],
        );
    }
    return %Data;
}

=item SystemAddressUpdate()

update system address with attributes

    $SystemAddressObject->SystemAddressUpdate(
        ID       => 1,
        Name     => 'info@example.com',
        Realname => 'Hotline',
        ValidID  => 1,
        QueueID  => 123,
        Comment  => 'some comment',
        UserID   => 123,
    );

=cut

sub SystemAddressUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE system_address SET value0 = ?, value1 = ?, comments = ?, valid_id = ?, '
            . ' change_time = current_timestamp, change_by = ?, queue_id = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Realname}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{QueueID}, \$Param{ID},
        ],
    );
    return 1;
}

=item SystemAddressList()

get a list of system addresses

    my %List = $SystemAddressObject->SystemAddressList();

    my %List = $SystemAddressObject->SystemAddressList( Valid => 1 );

returns:

    %List = (
        '1' => 'Acme Sales ( sales@example.com )',
        '2' => 'Acme Purchasing ( purchasing@example.com )',
        '3' => 'Acme Support ( support@example.com )',
    )

=cut

sub SystemAddressList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;
    if ( !$Param{Valid} && defined $Param{Valid} ) {
        $Valid = 0;
    }
    return $Self->{DBObject}->GetTableData(
        What  => 'id, value1, value0',
        Valid => $Valid,
        Clamp => 1,
        Table => 'system_address',
    );
}

=item SystemAddressIsLocalAddress()

Checks if the given address is a local (system) address. Returns true
for local addresses.

    if ( $SystemAddressObject->SystemAddressIsLocalAddress( Address => 'info@example.com' ) ) {
        # is local
    }
    else {
        # is not local
    }

=cut

sub SystemAddressIsLocalAddress {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Address)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return $Self->SystemAddressQueueID(%Param);
}

=item SystemAddressQueueID()

find dispatching queue id of email address

    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => 'info@example.com' );

=cut

sub SystemAddressQueueID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Address)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # remove empty spaces
    $Param{Address} =~ s/\s+//g;

    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT queue_id FROM system_address WHERE "
            . "valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) "
            . "AND LOWER(value0) = LOWER(?)",
        Bind => [
            \$Param{Address}
        ],
    );
    my $QueueID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $QueueID = $Row[0];
    }
    return $QueueID;
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

$Revision: 1.34 $ $Date: 2011-01-31 07:49:47 $

=cut
