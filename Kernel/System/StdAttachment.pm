# --
# Kernel/System/StdAttachment.pm - lib for std attachemnt
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: StdAttachment.pm,v 1.21 2008-01-31 06:20:20 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::StdAttachment;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

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
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::StdAttachment;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        MainObject => $MainObject,
        LogObject => $LogObject,
    );
    my $StdAttachmentObject = Kernel::System::StdAttachment->new(
        ConfigObject => $ConfigObject,
        DBObject => $DBObject,
        LogObject => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    return $Self;
}

=item StdAttachmentAdd()

create a new std. attachment

    my $ID = $StdAttachmentObject->StdAttachmentAdd(
        Name => 'Some Name',
        ValidID => 1,
        Content => $Content,
        ContentType => 'text/xml',
        Filename => 'SomeFile.xml',
        UserID => 123,
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

    # encode attachemnt if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # db quote
    for (qw(Name ContentType Filename Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "INSERT INTO standard_attachment "
        . " (name, content_type, content, filename, valid_id, comments, "
        . " create_time, create_by, change_time, change_by)"
        . " VALUES "
        . " ('$Param{Name}', '$Param{ContentType}', ?, '$Param{Filename}', "
        . " $Param{ValidID}, '$Param{Comment}', "
        . " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL, Bind => [ \$Param{Content} ] ) ) {
        my $ID = 0;
        $Self->{DBObject}->Prepare( SQL => "SELECT id FROM standard_attachment WHERE "
                . "name = '$Param{Name}' AND content_type = '$Param{ContentType}'", );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }
        return $ID;
    }
    else {
        return;
    }
}

=item StdAttachmentGet()

get a std. attachment

    my %Data = $StdAttachmentObject->StdAttachmentGet(
        ID => $ID,
    );

=cut

sub StdAttachmentGet {
    my ( $Self, %Param ) = @_;

    my %Data = ();

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "SELECT name, content_type, content, filename, valid_id, comments "
        . " FROM "
        . " standard_attachment "
        . " WHERE "
        . " id = $Param{ID}";
    if ( !$Self->{DBObject}->Prepare( SQL => $SQL, Encode => [ 1, 1, 0, 1, 1, 1 ], Limit => 1 ) ) {
        return;
    }
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        # decode attachemnt if it's a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Data[2] = decode_base64( $Data[2] );
        }
        %Data = (
            ID          => $Param{ID},
            Name        => $Data[0],
            ContentType => $Data[1],
            Content     => $Data[2],
            Filename    => $Data[3],
            ValidID     => $Data[4],
            Comment     => $Data[5],
        );
    }
    return %Data;
}

=item StdAttachmentUpdate()

update a new std. attachment

    my $ID = $StdAttachmentObject->StdAttachmentUpdate(
        ID => $ID,
        Name => 'Some Name',
        ValidID => 1,
        Content => $Content,
        ContentType => 'text/xml',
        Filename => 'SomeFile.xml',
        UserID => 123,
    );

=cut

sub StdAttachmentUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Content ContentType Filename UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # encode attachemnt if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # db quote
    for (qw(Name ContentType Filename Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "UPDATE standard_attachment SET "
        . " name = '$Param{Name}', "
        . " content = ?, "
        . " content_type = '$Param{ContentType}', "
        . " comments = '$Param{Comment}', "
        . " filename = '$Param{Filename}', "
        . " valid_id = $Param{ValidID}, "
        . " change_time = current_timestamp, "
        . " change_by = $Param{UserID} "
        . " WHERE "
        . " id = $Param{ID}";
    if ( $Self->{DBObject}->Do( SQL => $SQL, Bind => [ \$Param{Content} ] ) ) {
        return 1;
    }
    else {
        return;
    }
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

    # sql
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    if ( $Self->{DBObject}->Do( SQL => "DELETE FROM standard_attachment WHERE ID = $Param{ID}" ) ) {
        return 1;
    }
    else {
        return;
    }
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
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Got no StdAttachment or StdAttachment!" );
        return;
    }

    # check if we ask the same request?
    if ( $Param{StdAttachmentID} && $Self->{"StdAttachmentLookup$Param{StdAttachmentID}"} ) {
        return $Self->{"StdAttachmentLookup$Param{StdAttachmentID}"};
    }
    if ( $Param{StdAttachment} && $Self->{"StdResponseLookup$Param{StdAttachment}"} ) {
        return $Self->{"StdAttachmentLookup$Param{StdAttachment}"};
    }

    # get data
    my $SQL    = '';
    my $Suffix = '';
    if ( $Param{StdAttachment} ) {
        $Suffix = 'StdAttachmentID';
        $SQL    = "SELECT id FROM standard_attachment WHERE name = '"
            . $Self->{DBObject}->Quote( $Param{StdAttachment} ) . "'";
    }
    else {
        $Suffix = 'StdAttachment';
        $SQL    = "SELECT name FROM standard_attachment WHERE id = "
            . $Self->{DBObject}->Quote( $Param{StdAttachmentID}, 'Integer' ) . "";
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"StdAttachment$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"StdAttachment$Suffix"} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Found no \$$Suffix!" );
        return;
    }

    return $Self->{"StdAttachment$Suffix"};
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no ID!" );
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
    my %AllStdAttachments = $Self->GetAllStdAttachments( Valid => 1 );
    my %Data = ();
    for ( keys %Relation ) {
        if ( $AllStdAttachments{$_} ) {
            $Data{$_} = $AllStdAttachments{$_};
        }
        else {
            delete $Data{$_};
        }
    }
    return %Data;
}

=item GetAllStdAttachments()

return a hash (ID => Name) of std. attachment

    my %List = $StdAttachmentObject->GetAllStdAttachments();

    my %List = $StdAttachmentObject->GetAllStdAttachments(Valid => 1);

=cut

sub GetAllStdAttachments {
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

=item SetStdAttachmentsOfResponseID()

set std responses of response id

    $StdAttachmentObject->SetStdAttachmentsOfResponseID(
        ID => 123,
        AttachmentIDsRef => [1, 2, 3],
        UserID => 1,
    );

=cut

sub SetStdAttachmentsOfResponseID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID AttachmentIDsRef UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(ID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # add attachments to response
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM standard_response_attachment WHERE standard_response_id = $Param{ID}",
    );
    for ( @{ $Param{AttachmentIDsRef} } ) {
        my $SQL
            = "INSERT INTO standard_response_attachment (standard_attachment_id, "
            . "standard_response_id, create_time, create_by, change_time, change_by)"
            . " VALUES "
            . " ( $_, $Param{ID}, current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
        $Self->{DBObject}->Do( SQL => $SQL );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.21 $ $Date: 2008-01-31 06:20:20 $

=cut
