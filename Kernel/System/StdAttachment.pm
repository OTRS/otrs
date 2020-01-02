# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::StdAttachment;

use strict;
use warnings;

use MIME::Base64;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::StdAttachment - standard attachment lib

=head1 DESCRIPTION

All standard attachment functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $StdAttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'StdAttachment';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 StdAttachmentAdd()

create a new standard attachment

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # encode attachment if it's a postgresql backend!!!
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # insert attachment
    return if !$DBObject->Do(
        SQL => 'INSERT INTO standard_attachment '
            . ' (name, content_type, content, filename, valid_id, comments, '
            . ' create_time, create_by, change_time, change_by) VALUES '
            . ' (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name},    \$Param{ContentType}, \$Param{Content}, \$Param{Filename},
            \$Param{ValidID}, \$Param{Comment},     \$Param{UserID},  \$Param{UserID},
        ],
    );

    # get the id
    $DBObject->Prepare(
        SQL  => 'SELECT id FROM standard_attachment WHERE name = ? AND content_type = ?',
        Bind => [ \$Param{Name}, \$Param{ContentType}, ],
    );

    # fetch the result
    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return $ID;
}

=head2 StdAttachmentGet()

get a standard attachment

    my %Data = $StdAttachmentObject->StdAttachmentGet(
        ID => $ID,
    );

=cut

sub StdAttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => 'SELECT name, content_type, content, filename, valid_id, comments, '
            . 'create_time, create_by, change_time, change_by '
            . 'FROM standard_attachment WHERE id = ?',
        Bind   => [ \$Param{ID} ],
        Encode => [ 1, 1, 0, 1, 1, 1 ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # decode attachment if it's a postgresql backend!!!
        if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
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

=head2 StdAttachmentUpdate()

update a new standard attachment

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # reset cache
    my %Data = $Self->StdAttachmentGet(
        ID => $Param{ID},
    );

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupID::' . $Data{ID},
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupName::' . $Data{Name},
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupID::' . $Param{ID},
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupName::' . $Param{Name},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # update attachment
    return if !$DBObject->Do(
        SQL => 'UPDATE standard_attachment SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    if ( $Param{Content} ) {

        # encode attachment if it's a postgresql backend!!!
        if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Content} );
            $Param{Content} = encode_base64( $Param{Content} );
        }

        return if !$DBObject->Do(
            SQL => 'UPDATE standard_attachment SET content = ?, content_type = ?, '
                . ' filename = ? WHERE id = ?',
            Bind => [
                \$Param{Content}, \$Param{ContentType}, \$Param{Filename}, \$Param{ID},
            ],
        );
    }

    return 1;
}

=head2 StdAttachmentDelete()

delete a standard attachment

    $StdAttachmentObject->StdAttachmentDelete(
        ID => $ID,
    );

=cut

sub StdAttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # reset cache
    my %Data = $Self->StdAttachmentGet(
        ID => $Param{ID},
    );

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupID::' . $Param{ID},
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => 'StdAttachmentLookupName::' . $Data{Name},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete attachment<->std template relation
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM standard_template_attachment WHERE standard_attachment_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # sql
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM standard_attachment WHERE ID = ?',
        Bind => [ \$Param{ID} ],
    );

    return 1;
}

=head2 StdAttachmentLookup()

lookup for a standard attachment

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type           => $Self->{CacheType},
        Key            => $CacheKey,
        CacheInMemory  => 1,
        CacheInBackend => 0,
    );

    return $Cached if $Cached;

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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $DBValue;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DBValue = $Row[0];
    }

    # check if data exists
    if ( !$DBValue ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no $Key found for $Value!",
        );
        return;
    }

    # cache result
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type           => $Self->{CacheType},
        TTL            => $Self->{CacheTTL},
        Key            => $CacheKey,
        Value          => $DBValue,
        CacheInMemory  => 1,
        CacheInBackend => 0,
    );

    return $DBValue;
}

=head2 StdAttachmentList()

get list of standard attachments - return a hash (ID => Name (Filename))

    my %List = $StdAttachmentObject->StdAttachmentList(
        Valid => 0,  # optional, defaults to 1
    );

returns:

        %List = (
          '1' => 'Some Name' ( Filname ),
          '2' => 'Some Name' ( Filname ),
          '3' => 'Some Name' ( Filname ),
    );

=cut

sub StdAttachmentList {
    my ( $Self, %Param ) = @_;

    # set default value
    my $Valid = $Param{Valid} // 1;

    # create the valid list
    my $ValidIDs = join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # build SQL
    my $SQL = 'SELECT id, name, filename FROM standard_attachment';

    # add WHERE statement in case Valid param is set to '1', for valid StdAttachment
    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . $ValidIDs . ')';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get data from database
    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my %StdAttachmentList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $StdAttachmentList{ $Row[0] } = "$Row[1] ( $Row[2] )";
    }

    return %StdAttachmentList;
}

=head2 StdAttachmentStandardTemplateMemberAdd()

to add an attachment to a template

    my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
        AttachmentID       => 123,
        StandardTemplateID => 123,
        Active             => 1,        # optional
        UserID             => 123,
    );

=cut

sub StdAttachmentStandardTemplateMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(AttachmentID StandardTemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete existing relation
    return if !$DBObject->Do(
        SQL => 'DELETE FROM standard_template_attachment
            WHERE standard_attachment_id = ?
            AND standard_template_id = ?',
        Bind => [ \$Param{AttachmentID}, \$Param{StandardTemplateID} ],
    );

    # return if relation is not active
    if ( !$Param{Active} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => $Self->{CacheType},
        );
        return 1;
    }

    # insert new relation
    my $Success = $DBObject->Do(
        SQL => '
            INSERT INTO standard_template_attachment (standard_attachment_id, standard_template_id,
                create_time, create_by, change_time, change_by)
            VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{AttachmentID}, \$Param{StandardTemplateID}, \$Param{UserID},
            \$Param{UserID},
        ],
    );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return $Success;
}

=head2 StdAttachmentStandardTemplateMemberList()

returns a list of Standard Attachment / Standard Template members

    my %List = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
        AttachmentID => 123,
    );

    or
    my %List = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
        StandardTemplateID => 123,
    );

Returns:
    %List = (
        1 => 'Some Name',
        2 => 'Some Name',
    );

=cut

sub StdAttachmentStandardTemplateMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{AttachmentID} && !$Param{StandardTemplateID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need AttachmentID or StandardTemplateID!',
        );
        return;
    }

    if ( $Param{AttachmentID} && $Param{StandardTemplateID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need AttachmentID or StandardTemplateID, but not both!',
        );
        return;
    }

    # create cache key
    my $CacheKey = 'StdAttachmentStandardTemplateMemberList::';
    if ( $Param{AttachmentID} ) {
        $CacheKey .= 'AttachmentID::' . $Param{AttachmentID};
    }
    elsif ( $Param{StandardTemplateID} ) {
        $CacheKey .= 'StandardTemplateID::' . $Param{StandardTemplateID};
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if ref $Cache eq 'HASH';

    # sql
    my %Data;
    my @Bind;
    my $SQL = '
        SELECT sta.standard_attachment_id, sa.name, sta.standard_template_id, st.name
        FROM standard_template_attachment sta, standard_attachment sa, standard_template st
        WHERE';

    if ( $Param{AttachmentID} ) {
        $SQL .= ' st.valid_id IN (' . join ', ',
            $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() . ')';
    }
    elsif ( $Param{StandardTemplateID} ) {
        $SQL .= ' sa.valid_id IN (' . join ', ',
            $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() . ')';
    }

    $SQL .= '
            AND sta.standard_attachment_id = sa.id
            AND sta.standard_template_id = st.id';

    if ( $Param{AttachmentID} ) {
        $SQL .= ' AND sta.standard_attachment_id = ?';
        push @Bind, \$Param{AttachmentID};
    }
    elsif ( $Param{StandardTemplateID} ) {
        $SQL .= ' AND sta.standard_template_id = ?';
        push @Bind, \$Param{StandardTemplateID};
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Param{StandardTemplateID} ) {
            $Data{ $Row[0] } = $Row[1];
        }
        else {
            $Data{ $Row[2] } = $Row[3];
        }
    }

    # return result
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
