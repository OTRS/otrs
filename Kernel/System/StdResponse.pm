# --
# Kernel/System/StdResponse.pm - lib for std responses
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: StdResponse.pm,v 1.29 2009-03-09 13:11:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::StdResponse;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.29 $) [1];

=head1 NAME

Kernel::System::StdResponse - auto response lib

=head1 SYNOPSIS

All std response functions. E. g. to add std response or other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::StdResponse;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $StdResponseObject = Kernel::System::StdResponse->new(
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

sub StdResponseAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Response UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO standard_response (name, valid_id, comments, text, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{Comment}, \$Param{Response},
            \$Param{UserID}, \$Param{UserID},
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

sub StdResponseGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT name, valid_id, comments, text FROM standard_response WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID       => $Param{ID},
            Name     => $Data[0],
            Comment  => $Data[2],
            Response => $Data[3],
            ValidID  => $Data[1],
        );
    }
    return %Data;
}

sub StdResponseDelete {
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
    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM standard_response WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
}

sub StdResponseUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Response UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE standard_response SET'
            . ' name = ?, text = ?, comments = ?, valid_id = ?,'
            . ' change_time = current_timestamp, change_by = ?'
            . ' WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Response}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{ID},
        ],
    );
}

sub StdResponseLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StdResponse} && !$Param{StdResponseID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Got no StdResponse or StdResponseID!"
        );
        return;
    }

    # check if we ask the same request?
    if ( $Param{StdResponseID} && $Self->{"StdResponseLookup$Param{StdResponseID}"} ) {
        return $Self->{"StdResponseLookup$Param{StdResponseID}"};
    }
    if ( $Param{StdResponse} && $Self->{"StdResponseLookup$Param{StdResponse}"} ) {
        return $Self->{"StdResponseLookup$Param{StdResponse}"};
    }

    # get data
    my $SQL;
    my $Suffix;
    my @Bind;
    if ( $Param{StdResponse} ) {
        $Suffix = 'StdResponseID';
        $SQL    = 'SELECT id FROM standard_response WHERE name = ?';
        @Bind   = ( \$Param{StdResponse} );
    }
    else {
        $Suffix = 'StdResponse';
        $SQL    = 'SELECT name FROM standard_response WHERE id = ?';
        @Bind   = ( \$Param{StdResponseID} );
    }
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => @Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"StdResponse$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"StdResponse$Suffix"} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Found no \$$Suffix!" );
        return;
    }

    return $Self->{"StdResponse$Suffix"};
}

sub GetAllStdResponses {
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

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.29 $ $Date: 2009-03-09 13:11:23 $

=cut
