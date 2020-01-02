# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::FormDraft;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use MIME::Base64;
use Storable;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Storable',
);

=head1 NAME

Kernel::System::FormDraft - draft lib

=head1 SYNOPSIS

All draft functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'FormDraft';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 30;

    return $Self;
}

=item FormDraftGet()

get draft attributes

    my $FormDraft = $FormDraftObject->FormDraftGet(
        FormDraftID    => 123,
        GetContent => 1,                # optional, default 1
        UserID     => 123,
    );

Returns (with GetContent = 0):

    $FormDraft = {
        FormDraftID    => 123,
        ObjectType => 'Ticket',
        ObjectID   => 12,
        Action     => 'AgentTicketCompose',
        CreateTime => '2016-04-07 15:41:15',
        CreateBy   => 1,
        ChangeTime => '2016-04-07 15:59:45',
        ChangeBy   => 2,
    };

Returns (without GetContent or GetContent = 1):

    $FormDraft = {
        FormData => {
            InformUserID => [ 123, 124, ],
            Subject      => 'Request for information',
            ...
        },
        FileData => [
            {
                'Content'     => 'Dear customer\n\nthank you!',
                'ContentType' => 'text/plain',
                'ContentID'   => undef,                                 # optional
                'Filename'    => 'thankyou.txt',
                'Filesize'    => 25,
                'FileID'      => 1,
                'Disposition' => 'attachment',
            },
            ...
        ],
        FormDraftID    => 123,
        ObjectType => 'Ticket',
        ObjectID   => 12,
        Action     => 'AgentTicketCompose',
        CreateTime => '2016-04-07 15:41:15',
        CreateBy   => 1,
        ChangeTime => '2016-04-07 15:59:45',
        ChangeBy   => 2,
        Title      => 'my draft',
    };

=cut

sub FormDraftGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FormDraftID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # determine if we should get content
    $Param{GetContent} //= 1;
    if ( $Param{GetContent} !~ m{ \A [01] \z }xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid value '$Param{GetContent}' for GetContent!",
        );
        return;
    }

    # check cache
    my $CacheKey = 'FormDraftGet::GetContent' . $Param{GetContent} . '::ID' . $Param{FormDraftID};
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare query
    my $SQL =
        'SELECT id, object_type, object_id, action, title,'
        . ' create_time, create_by, change_time, change_by';

    my @EncodeColumns = ( 1, 1, 1, 1, 1, 1, 1, 1, 1 );
    if ( $Param{GetContent} ) {
        $SQL .= ', content';
        push @EncodeColumns, 0;
    }
    $SQL .= ' FROM form_draft WHERE id = ?';

    # ask the database
    return if !$DBObject->Prepare(
        SQL    => $SQL,
        Bind   => [ \$Param{FormDraftID} ],
        Limit  => 1,
        Encode => \@EncodeColumns,
    );

    # fetch the result
    my %FormDraft;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %FormDraft = (
            FormDraftID => $Row[0],
            ObjectType  => $Row[1],
            ObjectID    => $Row[2],
            Action      => $Row[3],
            Title       => $Row[4] || '',
            CreateTime  => $Row[5],
            CreateBy    => $Row[6],
            ChangeTime  => $Row[7],
            ChangeBy    => $Row[8],
        );

        if ( $Param{GetContent} ) {

            my $RawContent      = $Row[9] // {};
            my $StorableContent = $RawContent;

            if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
                $StorableContent = MIME::Base64::decode_base64($RawContent);
            }

            # convert form and file data from yaml
            my $Content = $Kernel::OM->Get('Kernel::System::Storable')->Deserialize( Data => $StorableContent ) // {};

            $FormDraft{FormData} = $Content->{FormData};
            $FormDraft{FileData} = $Content->{FileData};
        }
    }

    # no data found
    if ( !%FormDraft ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "FormDraft with ID '$Param{FormDraftID}' not found!",
        );
        return;
    }

    # always cache version without content
    my $CacheKeyNoContent;
    my %FormDraftNoContent;
    if ( $Param{GetContent} ) {
        $CacheKeyNoContent  = 'FormDraftGet::GetContent0::ID' . $Param{FormDraftID};
        %FormDraftNoContent = %{ Storable::dclone( \%FormDraft ) };
        delete $FormDraftNoContent{FileData};
        delete $FormDraftNoContent{FormData};
    }
    else {
        $CacheKeyNoContent  = $CacheKey;
        %FormDraftNoContent = %FormDraft;
    }
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        Key   => $CacheKeyNoContent,
        Value => \%FormDraftNoContent,
    );

    return \%FormDraft if !$Param{GetContent};

    # set cache with content (shorter cache time due to potentially large content)
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => 60 * 60,
        Key   => $CacheKey,
        Value => \%FormDraft,
    );

    return \%FormDraft;
}

=item FormDraftAdd()

add a new draft

    my $Success = $FormDraftObject->FormDraftAdd(
        FormData => {
            InformUserID => [ 123, 124, ],
            Subject      => 'Request for information',
            ...
        },
        FileData => [                                           # optional
            {
                'Content'     => 'Dear customer\n\nthank you!',
                'ContentType' => 'text/plain',
                'ContentID'   => undef,                         # optional
                'Filename'    => 'thankyou.txt',
                'Filesize'    => 25,
                'FileID'      => 1,
                'Disposition' => 'attachment',
            },
            ...
        ],
        ObjectType => 'Ticket',
        ObjectID   => 12,
        Action     => 'AgentTicketCompose',
        Title      => 'my draft',                               # optional
        UserID     => 123,
    );

=cut

sub FormDraftAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FormData ObjectType Action)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(ObjectID UserID)) {
        if ( !IsInteger( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # serialize form and file data
    my $StorableContent = $Kernel::OM->Get('Kernel::System::Storable')->Serialize(
        Data => {
            FormData => $Param{FormData},
            FileData => $Param{FileData} || [],
        },
    );

    my $Content = $StorableContent;
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
        $Content = MIME::Base64::encode_base64($StorableContent);
    }

    # add to database
    return if !$DBObject->Do(
        SQL =>
            'INSERT INTO form_draft'
            . ' (object_type, object_id, action, title, content, create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ObjectType}, \$Param{ObjectID}, \$Param{Action}, \$Param{Title}, \$Content,
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # delete affected caches
    $Self->_DeleteAffectedCaches(%Param);

    return 1;
}

=item FormDraftUpdate()

update an existing draft

    my $Success = $FormDraftObject->FormDraftUpdate(
        FormData => {
            InformUserID => [ 123, 124, ],
            Subject      => 'Request for information',
            ...
        },
        FileData => [                                           # optional
            {
                'Content'     => 'Dear customer\n\nthank you!',
                'ContentType' => 'text/plain',
                'ContentID'   => undef,                         # optional
                'Filename'    => 'thankyou.txt',
                'Filesize'    => 25,
                'FileID'      => 1,
                'Disposition' => 'attachment',
            },
            ...
        ],
        ObjectType  => 'Ticket',
        ObjectID    => 12,
        Action      => 'AgentTicketCompose',
        Title       => 'my draft',
        FormDraftID => 1,
        UserID      => 123,
    );

=cut

sub FormDraftUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FormData ObjectType Action)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(ObjectID FormDraftID UserID)) {
        if ( !IsInteger( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check if specified draft already exists and do sanity checks
    my $FormDraft = $Self->FormDraftGet(
        FormDraftID => $Param{FormDraftID},
        GetContent  => 0,
        UserID      => $Param{UserID},
    );
    if ( !$FormDraft ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "FormDraft with ID '$Param{FormDraftID}' not found!",
        );
        return;
    }
    VALIDATEPARAM:
    for my $ValidateParam (qw(ObjectType ObjectID Action)) {
        next VALIDATEPARAM if $Param{$ValidateParam} eq $FormDraft->{$ValidateParam};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Param '$ValidateParam' for draft with ID '$Param{FormDraftID}'"
                . " must not be changed on update!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # serialize form and file data
    my $StorableContent = $Kernel::OM->Get('Kernel::System::Storable')->Serialize(
        Data => {
            FormData => $Param{FormData},
            FileData => $Param{FileData} || [],
        },
    );

    my $Content = $StorableContent;
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
        $Content = MIME::Base64::encode_base64($StorableContent);
    }

    # add to database
    return if !$DBObject->Do(
        SQL =>
            'UPDATE form_draft'
            . ' SET title = ?, content = ?, change_time = current_timestamp, change_by = ?'
            . ' WHERE id = ?',
        Bind => [ \$Param{Title}, \$Content, \$Param{UserID}, \$Param{FormDraftID}, ],
    );

    # delete affected caches
    $Self->_DeleteAffectedCaches(%Param);

    return 1;
}

=item FormDraftDelete()

remove draft

    my $Success = $FormDraftObject->FormDraftDelete(
        FormDraftID => 123,
        UserID  => 123,
    );

=cut

sub FormDraftDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FormDraftID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get draft data as sanity check and to determine which caches should be removed
    # use database query directly (we don't need raw content)
    my $FormDraft = $Self->FormDraftGet(
        FormDraftID => $Param{FormDraftID},
        GetContent  => 0,
        UserID      => $Param{UserID},
    );
    if ( !$FormDraft ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "FormDraft with ID '$Param{FormDraftID}' not found!",
        );
        return;
    }

    # remove from database
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM form_draft WHERE id = ?',
        Bind => [ \$Param{FormDraftID} ],
    );

    # delete affected caches
    $Self->_DeleteAffectedCaches( %{$FormDraft} );

    return 1;
}

=item FormDraftListGet()

get list of drafts, optionally filtered by object type, object id and action

    my $FormDraftList = $FormDraftObject->FormDraftListGet(
        ObjectType => 'Ticket',             # optional
        ObjectID   => 123,                  # optional
        Action     => 'AgentTicketCompose', # optional
        UserID     => 123,
    );

Returns:

    $FormDraftList = [
        {
            FormDraftID => 123,
            ObjectType  => 'Ticket',
            ObjectID    => 12,
            Action      => 'AgentTicketCompose',
            Title       => 'my draft',
            CreateTime  => '2016-04-07 15:41:15',
            CreateBy    => 1,
            ChangeTime  => '2016-04-07 15:59:45',
            ChangeBy    => 2,
        },
        ...
    ];

=cut

sub FormDraftListGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # check cache
    my $CacheKey = 'FormDraftListGet';
    RESTRICTION:
    for my $Restriction (qw(ObjectType Action ObjectID)) {
        next RESTRICTION if !IsStringWithData( $Param{$Restriction} );
        $CacheKey .= '::' . $Restriction . $Param{$Restriction};
    }
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # prepare database restrictions by given parameters
    my %ParamToField = (
        ObjectType => 'object_type',
        Action     => 'action',
        ObjectID   => 'object_id',
    );
    my $SQLExt = '';
    my @Bind;
    RESTRICTION:
    for my $Restriction (qw(ObjectType Action ObjectID)) {
        next RESTRICTION if !IsStringWithData( $Param{$Restriction} );
        $SQLExt .= $SQLExt ? ' AND ' : ' WHERE ';
        $SQLExt .= $ParamToField{$Restriction} . ' = ?';
        push @Bind, \$Param{$Restriction};
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT id, object_type, object_id, action, title,'
            . ' create_time, create_by, change_time, change_by'
            . ' FROM form_draft' . $SQLExt
            . ' ORDER BY id ASC',
        Bind => \@Bind,
    );

    # fetch the results
    my @FormDrafts;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @FormDrafts, {
            FormDraftID => $Row[0],
            ObjectType  => $Row[1],
            ObjectID    => $Row[2],
            Action      => $Row[3],
            Title       => $Row[4] || '',
            CreateTime  => $Row[5],
            CreateBy    => $Row[6],
            ChangeTime  => $Row[7],
            ChangeBy    => $Row[8],
        };
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        Key   => $CacheKey,
        Value => \@FormDrafts,
    );

    return \@FormDrafts;
}

=item _DeleteAffectedCaches()

remove all potentially affected caches

    my $Success = $FormDraftObject->_DeleteAffectedCaches(
        FormDraftID    => 1,                               # optional
        ObjectType => 'Ticket',
        ObjectID   => 12,
        Action     => 'AgentTicketCompose',
    );

=cut

sub _DeleteAffectedCaches {
    my ( $Self, %Param ) = @_;

    # prepare affected cache keys
    my @CacheKeys = (
        'FormDraftListGet',
        'FormDraftListGet::ObjectType' . $Param{ObjectType},
        'FormDraftListGet::Action' . $Param{Action},
        'FormDraftListGet::ObjectID' . $Param{ObjectID},
        'FormDraftListGet::ObjectType' . $Param{ObjectType}
            . '::Action' . $Param{Action},
        'FormDraftListGet::ObjectType' . $Param{ObjectType}
            . '::ObjectID' . $Param{ObjectID},
        'FormDraftListGet::Action' . $Param{Action}
            . '::ObjectID' . $Param{ObjectID},
        'FormDraftListGet::ObjectType' . $Param{ObjectType}
            . '::Action' . $Param{Action}
            . '::ObjectID' . $Param{ObjectID},
    );
    if ( $Param{FormDraftID} ) {
        push @CacheKeys,
            'FormDraftGet::GetContent0::ID' . $Param{FormDraftID},
            'FormDraftGet::GetContent1::ID' . $Param{FormDraftID};
    }

    # delete affected caches
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    for my $CacheKey (@CacheKeys) {
        $CacheObject->Delete(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
