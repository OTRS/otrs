# --
# Kernel/System/Salutation.pm - All salutation related function should be here eventually
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Salutation;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);

=head1 NAME

Kernel::System::Salutation - salutation lib

=head1 SYNOPSIS

All salutation functions.

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
    use Kernel::System::Salutation;

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
    my $SalutationObject = Kernel::System::Salutation->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'Salutation',
        TTL  => 60 * 60 * 24 * 20,
    );

    return $Self;
}

=item SalutationAdd()

add new salutations

    my $ID = $SalutationObject->SalutationAdd(
        Name        => 'New Salutation',
        Text        => "--\nSome Salutation Infos",
        ContentType => 'text/plain; charset=utf-8',
        Comment     => 'some comment',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub SalutationAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Text ValidID UserID ContentType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO salutation (name, text, content_type, comments, valid_id, '
            . ' create_time, create_by, change_time, change_by) VALUES '
            . ' (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{ContentType}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new salutation id
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM salutation WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return if !$ID;

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return $ID;
}

=item SalutationGet()

get salutations attributes

    my %Salutation = $SalutationObject->SalutationGet(
        ID => 123,
    );

=cut

sub SalutationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => 'SalutationGet' . $Param{ID},
    );
    return %{$Cache} if $Cache;

    # get the salutation
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, text, content_type, comments, valid_id, change_time, create_time '
            . 'FROM salutation WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # fetch the result
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID          => $Data[0],
            Name        => $Data[1],
            Text        => $Data[2],
            ContentType => $Data[3] || 'text/plain',
            Comment     => $Data[4],
            ValidID     => $Data[5],
            ChangeTime  => $Data[6],
            CreateTime  => $Data[7],
        );
    }

    # no data found
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "SalutationID '$Param{ID}' not found!",
        );
        return;
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => 'SalutationGet' . $Param{ID},
        Value => \%Data,
    );

    return %Data;
}

=item SalutationUpdate()

update salutation attributes

    $SalutationObject->SalutationUpdate(
        ID          => 123,
        Name        => 'New Salutation',
        Text        => "--\nSome Salutation Infos",
        ContentType => 'text/plain; charset=utf-8',
        Comment     => 'some comment',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub SalutationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name Text ContentType ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE salutation SET name = ?, text = ?, content_type = ?, comments = ?, '
            . 'valid_id = ?, change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{ContentType}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item SalutationList()

get salutation list

    my %List = $SalutationObject->SalutationList();

    my %List = $SalutationObject->SalutationList(
        Valid => 0,
    );

=cut

sub SalutationList {
    my ( $Self, %Param ) = @_;

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # create cachekey
    my $CacheKey;
    if ( $Param{Valid} ) {
        $CacheKey = 'SalutationList::Valid';
    }
    else {
        $CacheKey = 'SalutationList::All';
    }

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # create sql
    my $SQL = 'SELECT id, name FROM salutation ';
    if ( $Param{Valid} ) {
        $SQL .= "WHERE valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
