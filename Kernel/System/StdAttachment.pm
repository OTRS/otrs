# --
# Kernel/System/StdAttachment.pm - lib for std attachment
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::StdAttachment;

use strict;
use warnings;

use MIME::Base64;

=head1 NAME

Kernel::System::StdAttachment - std. attachment lib

=head1 SYNOPSIS

All std. attachment functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create std. attachment object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::StdAttachment;

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
    my $StdAttachmentObject = Kernel::System::StdAttachment->new(
        ConfigObject => $ConfigObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
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

    return $Self;
}

=item StdAttachmentAdd()

create a new std. attachment

    my $ID = $StdAttachmentObject->StdAttachmentAdd(
        Name        => 'Some Name',
        ValidID     => 1,
        Content     => $Content,
        ContentType => 'text/xml',
        Filename    => 'SomeFile.xml',
        UserID      => 123,
    );

=cut

sub StdAttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Content ContentType Filename UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # encode attachment if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO standard_attachment '
            . ' (name, content_type, content, filename, valid_id, comments, '
            . ' create_time, create_by, change_time, change_by) VALUES '
            . ' (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name},    \$Param{ContentType}, \$Param{Content}, \$Param{Filename},
            \$Param{ValidID}, \$Param{Comment},     \$Param{UserID},  \$Param{UserID},
        ],
    );

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM standard_attachment WHERE name = ? AND content_type = ?',
        Bind => [ \$Param{Name}, \$Param{ContentType}, ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item StdAttachmentGet()

get a std. attachment

    my %Data = $StdAttachmentObject->StdAttachmentGet(
        ID => $ID,
    );

=cut

sub StdAttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name, content_type, content, filename, valid_id, comments, '
            . 'create_time, create_by, change_time, change_by '
            . 'FROM standard_attachment WHERE id = ?',
        Bind   => [ \$Param{ID} ],
        Encode => [ 1, 1, 0, 1, 1, 1 ],
        Limit  => 1,
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # decode attachment if it's a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Row[2] = decode_base64( $Row[2] );
        }
        %Data = (
            ID          => $Param{ID},
            Name        => $Row[0],
            ContentType => $Row[1],
            Content     => $Row[2],
            Filename    => $Row[3],
            ValidID     => $Row[4],
            Comment     => $Row[5],
            CreateTime  => $Row[6],
            CreateBy    => $Row[7],
            ChangeTime  => $Row[8],
            ChangeBy    => $Row[9],
        );
    }
    return %Data;
}

=item StdAttachmentUpdate()

update a new std. attachment

    my $ID = $StdAttachmentObject->StdAttachmentUpdate(
        ID          => $ID,
        Name        => 'Some Name',
        ValidID     => 1,
        Content     => $Content,
        ContentType => 'text/xml',
        Filename    => 'SomeFile.xml',
        UserID      => 123,
    );

=cut

sub StdAttachmentUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # reset cache
    my %Data = $Self->StdAttachmentGet(
        ID => $Param{ID},
    );
    $Self->{ 'StdAttachmentLookupID::' . $Data{ID} }      = 0;
    $Self->{ 'StdAttachmentLookupName::' . $Data{Name} }  = 0;
    $Self->{ 'StdAttachmentLookupID::' . $Param{ID} }     = 0;
    $Self->{ 'StdAttachmentLookupName::' . $Param{Name} } = 0;

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE standard_attachment SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );
    if ( $Param{Content} ) {

        # encode attachment if it's a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
            $Param{Content} = encode_base64( $Param{Content} );
        }

        return if !$Self->{DBObject}->Do(
            SQL => 'UPDATE standard_attachment SET content = ?, content_type = ?, '
                . ' filename = ? WHERE id = ?',
            Bind => [
                \$Param{Content}, \$Param{ContentType}, \$Param{Filename}, \$Param{ID},
            ],
        );
    }
    return 1;
}

=item StdAttachmentDelete()

delete a std. attachment

    $StdAttachmentObject->StdAttachmentDelete(
        ID => $ID,
    );

=cut

sub StdAttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # reset cache
    my %Data = $Self->StdAttachmentGet(
        ID => $Param{ID},
    );
    $Self->{ 'StdAttachmentLookupID::' . $Param{ID} }    = 0;
    $Self->{ 'StdAttachmentLookupName::' . $Data{Name} } = 0;

    # delete attachment<->std response relation
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_response_attachment WHERE standard_attachment_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_attachment WHERE ID = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

=item StdAttachmentLookup()

lookup for a std. attachment

    my $ID = $StdAttachmentObject->StdAttachmentLookup(
        StdAttachment => 'Some Name',
    );

    my $Name = $StdAttachmentObject->StdAttachmentLookup(
        StdAttachmentID => $ID,
    );

=cut

sub StdAttachmentLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StdAttachment} && !$Param{StdAttachmentID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no StdAttachment or StdAttachment!',
        );
        return;
    }

    # check if we ask the same request?
    my $CacheKey;
    my $Key;
    my $Value;
    if ( $Param{StdAttachmentID} ) {
        $CacheKey = 'StdAttachmentLookupID::' . $Param{StdAttachmentID};
        $Key      = 'StdAttachmentID';
        $Value    = $Param{StdAttachmentID};
    }
    else {
        $CacheKey = 'StdAttachmentLookupName::' . $Param{StdAttachment};
        $Key      = 'StdAttachment';
        $Value    = $Param{StdAttachment};
    }
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # get data
    my $SQL;
    my @Bind;
    if ( $Param{StdAttachment} ) {
        $SQL = 'SELECT id FROM standard_attachment WHERE name = ?';
        push @Bind, \$Param{StdAttachment};
    }
    else {
        $SQL = 'SELECT name FROM standard_attachment WHERE id = ?';
        push @Bind, \$Param{StdAttachmentID};
    }
    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # check if data exists
    if ( !$Self->{$CacheKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no $Key found for $Value!",
        );
        return;
    }

    return $Self->{$CacheKey};
}

=item StdAttachmentsByResponseID()

return a hash (ID => Name) of std. attachment by response id

    my %StdAttachment = $StdAttachmentObject->StdAttachmentsByResponseID(
        ID => 4711,
    );

=cut

sub StdAttachmentsByResponseID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no ID!' );
        return;
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # return data
    my %Relation = $Self->{DBObject}->GetTableData(
        Table => 'standard_response_attachment',
        What  => 'standard_attachment_id, standard_response_id',
        Where => "standard_response_id = $Param{ID}",
    );
    my %AllStdAttachments = $Self->StdAttachmentList( Valid => 1 );
    my %Data;
    for ( sort keys %Relation ) {
        if ( $AllStdAttachments{$_} ) {
            $Data{$_} = $AllStdAttachments{$_};
        }
        else {
            delete $Data{$_};
        }
    }
    return %Data;
}

=item StdAttachmentList()

return a hash (ID => Name) of std. attachment

    my %List = $StdAttachmentObject->StdAttachmentList();

    my %List = $StdAttachmentObject->StdAttachmentList( Valid => 1 );

=cut

sub StdAttachmentList {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # return data
    return $Self->{DBObject}->GetTableData(
        Table => 'standard_attachment',
        What  => 'id, name, filename',
        Clamp => 1,
        Valid => $Param{Valid},
    );
}

=item StdAttachmentSetResponses()

set std responses of response id

    $StdAttachmentObject->StdAttachmentSetResponses(
        ID               => 123,
        AttachmentIDsRef => [1, 2, 3],
        UserID           => 1,
    );

=cut

sub StdAttachmentSetResponses {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID AttachmentIDsRef UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # add attachments to response
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_response_attachment WHERE standard_response_id = ?',
        Bind => [ \$Param{ID} ],
    );
    for my $ID ( @{ $Param{AttachmentIDsRef} } ) {
        next if !$ID;
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO standard_response_attachment (standard_attachment_id, '
                . 'standard_response_id, create_time, create_by, change_time, change_by)'
                . ' VALUES ( ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$ID, \$Param{ID}, \$Param{UserID}, \$Param{UserID},
            ],
        );
    }
    return 1;
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
