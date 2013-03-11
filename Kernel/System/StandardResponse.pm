# --
# Kernel/System/StandardResponse.pm - lib for std responses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::StandardResponse;

use strict;
use warnings;

use vars qw($VERSION);

=head1 NAME

Kernel::System::StandardResponse - auto response lib

=head1 SYNOPSIS

All std response functions. E. g. to add std response or other functions.

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
    use Kernel::System::StandardResponse;

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
    my $StandardResponseObject = Kernel::System::StandardResponse->new(
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
    for (qw(ConfigObject LogObject DBObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    return $Self;
}

=item StandardResponseAdd()

add new std response

    my $ID = $StandardResponseObject->StandardResponseAdd(
        Name        => 'New Standard Response',
        Response    => 'Thank you for your email.',
        ContentType => 'text/plain; charset=utf-8',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub StandardResponseAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Response ContentType UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO standard_response (name, valid_id, comments, text, '
            . ' content_type, create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{Comment}, \$Param{Response},
            \$Param{ContentType}, \$Param{UserID}, \$Param{UserID},
        ],
    );
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM standard_response WHERE name = ? AND change_by = ?',
        Bind => [ \$Param{Name}, \$Param{UserID}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item StandardResponseGet()

get std response attributes

    my %StandardResponse = $StandardResponseObject->StandardResponseGet(
        ID => 123,
    );

Returns:

    %StandardResponse = (
        ID                  => '123',
        Name                => 'Simple response',
        Comment             => 'Some comment',
        Response            => 'Response content',
        ContentType         => 'text/plain',
        ValidID             => '1',
        CreateTime          => '2010-04-07 15:41:15',
        CreateBy            => '321',
        ChangeTime          => '2010-04-07 15:59:45',
        ChangeBy            => '223',
    );

=cut

sub StandardResponseGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name, valid_id, comments, text, content_type, '
            . 'create_time, create_by, change_time, change_by '
            . 'FROM standard_response WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID          => $Param{ID},
            Name        => $Data[0],
            Comment     => $Data[2],
            Response    => $Data[3],
            ContentType => $Data[4] || 'text/plain',
            ValidID     => $Data[1],
            CreateTime  => $Data[5],
            CreateBy    => $Data[6],
            ChangeTime  => $Data[7],
            ChangeBy    => $Data[8],
        );
    }
    return %Data;
}

=item StandardResponseDelete()

delete a standard response

    $StandardResponseObject->StandardResponseDelete(
        ID => 123,
    );

=cut

sub StandardResponseDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # delete queue<->std response relation
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM queue_standard_response WHERE standard_response_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete attachment<->std response relation
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_response_attachment WHERE standard_response_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_response WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

=item StandardResponseUpdate()

update std response attributes

    $StandardResponseObject->StandardResponseUpdate(
        ID          => 123,
        Name        => 'New Standard Response',
        Response    => 'Thank you for your email.',
        ContentType => 'text/plain; charset=utf-8',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub StandardResponseUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Response ContentType UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE standard_response SET'
            . ' name = ?, text = ?, content_type = ?, comments = ?,'
            . ' valid_id = ?, change_time = current_timestamp, change_by = ?'
            . ' WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Response}, \$Param{ContentType}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );
    return 1;
}

=item StandardResponseLookup()

return the name or the std response id

    my $StandardResponseName = $StandardResponseObject->StandardResponseLookup(
        StandardResponseID => 123,
    );

    or

    my $StandardResponseID = $StandardResponseObject->StandardResponseLookup(
        StandardResponse => 'Std Response Name',
    );

=cut

sub StandardResponseLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StandardResponse} && !$Param{StandardResponseID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no StandardResponse or StandardResponseID!'
        );
        return;
    }

    # check if we ask the same request?
    if ( $Param{StandardResponseID} && $Self->{"StandardResponseLookup$Param{StandardResponseID}"} )
    {
        return $Self->{"StandardResponseLookup$Param{StandardResponseID}"};
    }
    if ( $Param{StandardResponse} && $Self->{"StandardResponseLookup$Param{StandardResponse}"} ) {
        return $Self->{"StandardResponseLookup$Param{StandardResponse}"};
    }

    # get data
    my $SQL;
    my $Suffix;
    my @Bind;
    if ( $Param{StandardResponse} ) {
        $Suffix = 'StandardResponseID';
        $SQL    = 'SELECT id FROM standard_response WHERE name = ?';
        @Bind   = ( \$Param{StandardResponse} );
    }
    else {
        $Suffix = 'StandardResponse';
        $SQL    = 'SELECT name FROM standard_response WHERE id = ?';
        @Bind   = ( \$Param{StandardResponseID} );
    }
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"StandardResponse$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"StandardResponse$Suffix"} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Found no \$$Suffix!" );
        return;
    }

    return $Self->{"StandardResponse$Suffix"};
}

=item StandardResponseList()

get all valid std responses

    my %StandardResponses = $StandardResponseObject->StandardResponseList();

get all std responses

    my %StandardResponses = $StandardResponseObject->StandardResponseList(
        Valid => 0,
    );

=cut

sub StandardResponseList {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # return data
    return $Self->{DBObject}->GetTableData(
        Table => 'standard_response',
        What  => 'id, name',
        Valid => $Param{Valid},
    );
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
