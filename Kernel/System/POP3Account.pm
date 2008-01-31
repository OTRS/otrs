# --
# Kernel/System/POP3Account.pm - lib for POP3 accounts
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: POP3Account.pm,v 1.17 2008-01-31 06:20:20 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::POP3Account;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

=head1 NAME

Kernel::System::POP3Account - to manage pop3 accounts

=head1 SYNOPSIS

All functions to manage the pop3 accounts.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::POP3Account;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $POP3Object = Kernel::System::POP3Account->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    return $Self;
}

=item POP3AccountAdd()

adds a new pop3 account

    $POP3Object->POP3AccountAdd(
        Login => 'mail',
        Password => 'SomePassword',
        Host => 'pop3.example.com',
        ValidID => 1,
        Trusted => 0,
        DispatchingBy => 'Queue', # Queue|From
        QueueID => 12,
        UserID => 123,
    );

=cut

sub POP3AccountAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host ValidID Trusted DispatchingBy QueueID UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for (qw(Login Password Host ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if dispatching is by From
    if ( $Param{DispatchingBy} eq 'From' ) {
        $Param{QueueID} = 0;
    }
    elsif ( $Param{DispatchingBy} eq 'Queue' && !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID for dispatching!" );
        return;
    }

    # db quote
    for (qw(Login Password Host Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ValidID QueueID Trusted UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "INSERT INTO pop3_account (login, pw, host, valid_id, comments, queue_id, "
        . " trusted, create_time, create_by, change_time, change_by)"
        . " VALUES "
        . " ('$Param{Login}', '$Param{Password}', '$Param{Host}', $Param{ValidID}, "
        . " '$Param{Comment}', $Param{QueueID}, $Param{Trusted}, "
        . " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        my $Id = 0;
        $Self->{DBObject}->Prepare( SQL => "SELECT id FROM pop3_account WHERE "
                . "login = '$Param{Login}' AND host = '$Param{Host}'", );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Id = $Row[0];
        }
        return $Id;
    }
    else {
        return;
    }
}

=item POP3AccountGet()

returns a hash of pop4 account data

    my %POP3Account = $POP3Object->POP3AccountGet(
        ID => 123,
    );

(returns: ID, Login, Password, Host, QueueID, Trusted, Comment, DispatchingBy, ValidID)

=cut

sub POP3AccountGet {
    my ( $Self, %Param ) = @_;

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
        = "SELECT login, pw, host, queue_id, trusted, comments, valid_id "
        . " FROM "
        . " pop3_account "
        . " WHERE "
        . " id = $Param{ID}";

    if ( !$Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        return;
    }
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID       => $Param{ID},
            Login    => $Data[0],
            Password => $Data[1],
            Host     => $Data[2],
            QueueID  => $Data[3],
            Trusted  => $Data[4],
            Comment  => $Data[5],
            ValidID  => $Data[6],
        );
    }
    if ( $Data{QueueID} == 0 ) {
        $Data{DispatchingBy} = 'From';
    }
    else {
        $Data{DispatchingBy} = 'Queue';
    }
    return %Data;
}

=item POP3AccountUpdate()

update a new pop3 account

    $POP3Object->POP3AccountUpdate(
        ID => 1,
        Login => 'mail',
        Password => 'SomePassword',
        Host => 'pop3.example.com',
        ValidID => 1,
        Trusted => 0,
        DispatchingBy => 'Queue', # Queue|From
        QueueID => 12,
        UserID => 123,
    );

=cut

sub POP3AccountUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Login Password Host ValidID Trusted DispatchingBy QueueID UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if dispatching is by From
    if ( $Param{DispatchingBy} eq 'From' ) {
        $Param{QueueID} = 0;
    }
    elsif ( $Param{DispatchingBy} eq 'Queue' && !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID for dispatching!" );
        return;
    }

    # db quote
    for (qw(Login Password Host Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID ValidID QueueID Trusted UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "UPDATE pop3_account SET login = '$Param{Login}', pw = '$Param{Password}', "
        . " host = '$Param{Host}', comments = '$Param{Comment}', "
        . " trusted = $Param{Trusted}, valid_id = $Param{ValidID}, "
        . " change_time = current_timestamp, change_by = $Param{UserID}, queue_id = $Param{QueueID} "
        . " WHERE id = $Param{ID}";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item POP3AccountDelete()

deletes a pop3 account

    $POP3Object->POP3AccountDelete(
        ID => 123,
    );

=cut

sub POP3AccountDelete {
    my ( $Self, %Param ) = @_;

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
    my $SQL = "DELETE FROM pop3_account WHERE id = $Param{ID}";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item POP3AccountList()

returns a list (Key, Name) of all pop3 accounts

    my %List = $POP3Object->POP3AccountList(
        Valid => 0, # just valid/all accounts
    );

=cut

sub POP3AccountList {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} || 0;
    return $Self->{DBObject}->GetTableData(
        What  => 'id, login, host',
        Valid => $Valid,
        Clamp => 1,
        Table => 'pop3_account',
    );
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

$Revision: 1.17 $ $Date: 2008-01-31 06:20:20 $

=cut
