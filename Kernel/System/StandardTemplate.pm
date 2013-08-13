# --
# Kernel/System/StandardTemplate.pm - lib for std templates
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::StandardTemplate;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CacheInternal;

=head1 NAME

Kernel::System::StandardTemplate - std template lib

=head1 SYNOPSIS

All std template functions. E. g. to add std template or other functions.

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
    use Kernel::System::StandardTemplate;

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
    my $StandardTemplateObject = Kernel::System::StandardTemplate->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject EncodeObject MainObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'StandardTemplate',
        TTL  => 60 * 60 * 24 * 20,
    );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item StandardTemplateAdd()

add new std template

    my $ID = $StandardTemplateObject->StandardTemplateAdd(
        Name         => 'New Standard Template',
        Template     => 'Thank you for your email.',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',                     # or 'Forward' or 'Create'
        ValidID      => 1,
        UserID       => 123,
    );

=cut

sub StandardTemplateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Template ContentType UserID TemplateType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO standard_template (name, valid_id, comments, text,
                content_type, create_time, create_by, change_time, change_by, template_type)
            VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?, ?)',
        Bind => [
            \$Param{Name},        \$Param{ValidID}, \$Param{Comment}, \$Param{Template},
            \$Param{ContentType}, \$Param{UserID},  \$Param{UserID},  \$Param{TemplateType},
        ],
    );
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM standard_template WHERE name = ? AND change_by = ?',
        Bind => [ \$Param{Name}, \$Param{UserID}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # clear queue cache, due to Queue <-> Template relations
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Queue' );

    return $ID;
}

=item StandardTemplateGet()

get std template attributes

    my %StandardTemplate = $StandardTemplateObject->StandardTemplateGet(
        ID => 123,
    );

Returns:

    %StandardTemplate = (
        ID                  => '123',
        Name                => 'Simple remplate',
        Comment             => 'Some comment',
        Template            => 'Template content',
        ContentType         => 'text/plain',
        TemplateType        => 'Answer',
        ValidID             => '1',
        CreateTime          => '2010-04-07 15:41:15',
        CreateBy            => '321',
        ChangeTime          => '2010-04-07 15:59:45',
        ChangeBy            => '223',
    );

=cut

sub StandardTemplateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT name, valid_id, comments, text, content_type, create_time, create_by,
                change_time, change_by ,template_type
            FROM standard_template
            WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID           => $Param{ID},
            Name         => $Data[0],
            Comment      => $Data[2],
            Template     => $Data[3],
            ContentType  => $Data[4] || 'text/plain',
            ValidID      => $Data[1],
            CreateTime   => $Data[5],
            CreateBy     => $Data[6],
            ChangeTime   => $Data[7],
            ChangeBy     => $Data[8],
            TemplateType => $Data[9],
        );
    }
    return %Data;
}

=item StandardTemplateDelete()

delete a standard template

    $StandardTemplateObject->StandardTemplateDelete(
        ID => 123,
    );

=cut

sub StandardTemplateDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # delete queue<->std template relation
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM queue_standard_template WHERE standard_template_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete attachment<->std template relation
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_template_attachment WHERE standard_template_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_template WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # clear queue cache, due to Queue <-> Template relations
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Queue' );

    return 1;
}

=item StandardTemplateUpdate()

update std template attributes

    $StandardTemplateObject->StandardTemplateUpdate(
        ID           => 123,
        Name         => 'New Standard Template',
        Template     => 'Thank you for your email.',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        ValidID      => 1,
        UserID       => 123,
    );

=cut

sub StandardTemplateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID TemplateType ContentType UserID TemplateType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE standard_template
            SET name = ?, text = ?, content_type = ?, comments = ?, valid_id = ?,
                change_time = current_timestamp, change_by = ? ,template_type = ?
            WHERE id = ?',
        Bind => [
            \$Param{Name},    \$Param{Template}, \$Param{ContentType},  \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID},   \$Param{TemplateType}, \$Param{ID},
        ],
    );

    # clear queue cache, due to Queue <-> Template relations
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Queue' );

    return 1;
}

=item StandardTemplateLookup()

return the name or the std template id

    my $StandardTemplateName = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplateID => 123,
    );

    or

    my $StandardTemplateID = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplate => 'Std Template Name',
    );

=cut

sub StandardTemplateLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StandardTemplate} && !$Param{StandardTemplateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no StandardTemplate or StandardTemplateID!'
        );
        return;
    }

    # check if we ask the same request?
    if ( $Param{StandardTemplateID} && $Self->{"StandardTemplateLookup$Param{StandardTemplateID}"} )
    {
        return $Self->{"StandardTemplateLookup$Param{StandardTemplateID}"};
    }
    if ( $Param{StandardTemplate} && $Self->{"StandardTemplateLookup$Param{StandardTemplate}"} ) {
        return $Self->{"StandardTemplateLookup$Param{StandardTemplate}"};
    }

    # get data
    my $SQL;
    my $Suffix;
    my @Bind;
    if ( $Param{StandardTemplate} ) {
        $Suffix = 'StandardTemplateID';
        $SQL    = 'SELECT id FROM standard_template WHERE name = ?';
        @Bind   = ( \$Param{StandardTemplate} );
    }
    else {
        $Suffix = 'StandardTemplate';
        $SQL    = 'SELECT name FROM standard_template WHERE id = ?';
        @Bind   = ( \$Param{StandardTemplateID} );
    }
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"StandardTemplate$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"StandardTemplate$Suffix"} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Found no \$$Suffix!" );
        return;
    }

    return $Self->{"StandardTemplate$Suffix"};
}

=item StandardTemplateList()

get all valid std templatess

    my %StandardTemplates = $StandardTemplatesObject->StandardTemplatesList();

Returns:
    %StandardTemplates = (
        1 => 'Some Name',
        2 => 'Some Name2',
        3 => 'Some Name3',
    );

get all std templates

    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList(
        Valid => 0,
    );

Returns:
    %StandardTemplates = (
        1 => 'Some Name',
        2 => 'Some Name2',
    );

get std templates from a certain type
    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList(
        Valid => 0,
        Type  => 'Answer',
    );

Returns:
    %StandardTemplates = (
        1 => 'Answer - Some Name',
    );

=cut

sub StandardTemplateList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;
    if ( defined $Param{Valid} && $Param{Valid} eq '0' ) {
        $Valid = 0;
    }

    my $SQL = '
        SELECT id, name
        FROM standard_template';

    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';
    }

    my @Bind;
    if ( defined $Param{Type} && $Param{Type} ne '' ) {
        $SQL .= ' AND template_type = ?';
        push @Bind, \$Param{Type};
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }
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
