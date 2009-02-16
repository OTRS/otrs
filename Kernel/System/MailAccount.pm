# --
# Kernel/System/MailAccount.pm - lib for mail accounts
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: MailAccount.pm,v 1.6 2009-02-16 11:58:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MailAccount;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::MailAccount - to manage mail accounts

=head1 SYNOPSIS

All functions to manage the mail accounts.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::MailAccount;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $MailAccount = Kernel::System::MailAccount->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    return $Self;
}

=item MailAccountAdd()

adds a new mail account

    $MailAccount->MailAccountAdd(
        Login         => 'mail',
        Password      => 'SomePassword',
        Host          => 'pop3.example.com',
        Type          => 'POP3',
        ValidID       => 1,
        Trusted       => 0,
        DispatchingBy => 'Queue', # Queue|From
        QueueID       => 12,
        UserID        => 123,
    );

=cut

sub MailAccountAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host ValidID Trusted DispatchingBy QueueID UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for (qw(Login Password Host Type ValidID UserID)) {
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

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO mail_account (login, pw, host, account_type, valid_id, comments, queue_id, '
            . ' trusted, create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Login},   \$Param{Password}, \$Param{Host},    \$Param{Type},
            \$Param{ValidID}, \$Param{Comment},  \$Param{QueueID}, \$Param{Trusted},
            \$Param{UserID},  \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM mail_account WHERE login = ? AND host = ? AND account_type = ?',
        Bind => [ \$Param{Login}, \$Param{Host}, \$Param{Type} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item MailAccountGet()

returns a hash of mail account data

    my %MailAccount = $MailAccount->MailAccountGet(
        ID => 123,
    );

(returns: ID, Login, Password, Host, Type, QueueID, Trusted, Comment, DispatchingBy, ValidID)

=cut

sub MailAccountGet {
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
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT login, pw, host, account_type, queue_id, trusted, comments, valid_id'
            . ' FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID       => $Param{ID},
            Login    => $Data[0],
            Password => $Data[1],
            Host     => $Data[2],
            Type     => $Data[3] || 'POP3',    # compat for old setups
            QueueID  => $Data[4],
            Trusted  => $Data[5],
            Comment  => $Data[6],
            ValidID  => $Data[7],
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

=item MailAccountUpdate()

update a new mail account

    $MailAccount->MailAccountUpdate(
        ID            => 1,
        Login         => 'mail',
        Password      => 'SomePassword',
        Host          => 'pop3.example.com',
        Type          => 'POP3',
        ValidID       => 1,
        Trusted       => 0,
        DispatchingBy => 'Queue', # Queue|From
        QueueID       => 12,
        UserID        => 123,
    );

=cut

sub MailAccountUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Login Password Host Type ValidID Trusted DispatchingBy QueueID UserID)) {
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

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE mail_account SET login = ?, pw = ?, host = ?, account_type = ?, '
            . ' comments = ?, trusted = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ?, queue_id = ? WHERE id = ?',
        Bind => [
            \$Param{Login},   \$Param{Password}, \$Param{Host},    \$Param{Type},
            \$Param{Comment}, \$Param{Trusted},  \$Param{ValidID}, \$Param{UserID},
            \$Param{QueueID}, \$Param{ID},
        ],
    );
}

=item MailAccountDelete()

deletes a mail account

    $MailAccount->MailAccountDelete(
        ID => 123,
    );

=cut

sub MailAccountDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql

    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
}

=item MailAccountList()

returns a list (Key, Name) of all mail accounts

    my %List = $MailAccount->MailAccountList(
        Valid => 0, # just valid/all accounts
    );

=cut

sub MailAccountList {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} || 0;
    return $Self->{DBObject}->GetTableData(
        What  => 'id, host, login',
        Valid => $Valid,
        Clamp => 1,
        Table => 'mail_account',
    );
}

=item MailAccountBackendList()

returns a list usable backends

    my %List = $MailAccount->MailAccountBackendList();

=cut

sub MailAccountBackendList {
    my ( $Self, %Param ) = @_;

    my %Backends  = ();
    my $Directory = $Self->{ConfigObject}->Get('Home') . '/Kernel/System/MailAccount/*.pm';
    my @List      = glob $Directory;
    for my $File (@List) {

        # remove .pm
        $File =~ s/^.*\/(.+?)\.pm$/$1/;
        my $GenericModule = "Kernel::System::MailAccount::$File";

        # try to load module $GenericModule
        if ( eval "require $GenericModule" ) {
            if ( eval { $GenericModule->new( %{$Self} ) } ) {
                $Backends{$File} = $File;
            }
        }
    }

    return %Backends;
}

=item MailAccountFetch()

fetch emails by using backend

    my $Ok = $MailAccount->MailAccountFetch(
        Login         => 'mail',
        Password      => 'SomePassword',
        Host          => 'pop3.example.com',
        ValidID       => 1,
        Trusted       => 0,
        DispatchingBy => 'Queue', # Queue|From
        QueueID       => 12,
        UserID        => 123,
    );

=cut

sub MailAccountFetch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Type Trusted DispatchingBy QueueID UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # load backend
    my $GenericModule = "Kernel::System::MailAccount::$Param{Type}";

    # try to load module $GenericModule
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        return;
    }

    # fetch mails
    my $Backend = $GenericModule->new( %{$Self} );
    return $Backend->Fetch(%Param);
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

$Revision: 1.6 $ $Date: 2009-02-16 11:58:56 $

=cut
