# --
# Kernel/System/MailAccount.pm - lib for mail accounts
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MailAccount;

use strict;
use warnings;

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
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::MailAccount;

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
        IMAPFolder    => 'Some Folder', # optional, only valid for IMAP-type accounts
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

    # only set IMAP folder on IMAP type accounts
    # fallback to 'INBOX' if none given
    if ( $Param{Type} =~ m{ IMAP .* }xmsi ) {
        if ( !defined $Param{IMAPFolder} || !$Param{IMAPFolder} ) {
            $Param{IMAPFolder} = 'INBOX';
        }
    }
    else {
        $Param{IMAPFolder} = '';
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO mail_account (login, pw, host, account_type, valid_id, comments, queue_id, '
            . ' imap_folder, trusted, create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Login},   \$Param{Password}, \$Param{Host},    \$Param{Type},
            \$Param{ValidID}, \$Param{Comment},  \$Param{QueueID}, \$Param{IMAPFolder},
            \$Param{Trusted}, \$Param{UserID},   \$Param{UserID},
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

(returns: ID, Login, Password, Host, Type, QueueID, Trusted, IMAPFolder, Comment, DispatchingBy, ValidID)

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
        SQL =>
            'SELECT login, pw, host, account_type, queue_id, imap_folder, trusted, comments, valid_id, '
            . ' create_time, change_time FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Param{ID},
            Login      => $Data[0],
            Password   => $Data[1],
            Host       => $Data[2],
            Type       => $Data[3] || 'POP3',    # compat for old setups
            QueueID    => $Data[4],
            IMAPFolder => $Data[5],
            Trusted    => $Data[6],
            Comment    => $Data[7],
            ValidID    => $Data[8],
            CreateTime => $Data[9],
            ChangeTime => $Data[10],
        );
    }
    if ( $Data{QueueID} == 0 ) {
        $Data{DispatchingBy} = 'From';
    }
    else {
        $Data{DispatchingBy} = 'Queue';
    }

    # only return IMAP folder on IMAP type accounts
    # fallback to 'INBOX' if none given
    if ( $Data{Type} =~ m{ IMAP .* }xmsi ) {
        if ( defined $Data{IMAPFolder} && !$Data{IMAPFolder} ) {
            $Data{IMAPFolder} = 'INBOX';
        }
    }
    else {
        $Data{IMAPFolder} = '';
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
        IMAPFolder    => 'Some Folder', # optional, only valid for IMAP-type accounts
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

    # only set IMAP folder on IMAP type accounts
    # fallback to 'INBOX' if none given
    if ( $Param{Type} =~ m{ IMAP .* }xmsi ) {
        if ( !defined $Param{IMAPFolder} || !$Param{IMAPFolder} ) {
            $Param{IMAPFolder} = 'INBOX';
        }
    }
    else {
        $Param{IMAPFolder} = '';
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE mail_account SET login = ?, pw = ?, host = ?, account_type = ?, '
            . ' comments = ?, imap_folder = ?, trusted = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ?, queue_id = ? WHERE id = ?',
        Bind => [
            \$Param{Login},   \$Param{Password},   \$Param{Host},    \$Param{Type},
            \$Param{Comment}, \$Param{IMAPFolder}, \$Param{Trusted}, \$Param{ValidID},
            \$Param{UserID},  \$Param{QueueID},    \$Param{ID},
        ],
    );
    return 1;
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
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
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

returns a list of usable backends

    my %List = $MailAccount->MailAccountBackendList();

=cut

sub MailAccountBackendList {
    my ( $Self, %Param ) = @_;

    my %Backends;
    my $Directory = $Self->{ConfigObject}->Get('Home') . '/Kernel/System/MailAccount/';
    my @List      = $Self->{MainObject}->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.pm',
    );
    for my $File (@List) {

        # remove .pm
        $File =~ s/^.*\/(.+?)\.pm$/$1/;
        my $GenericModule = "Kernel::System::MailAccount::$File";

        # try to load module $GenericModule
        if ( eval "require $GenericModule" ) {    ## no critic
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
        Type          => 'POP3', # POP3,POP3s,IMAP,IMAPS
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

=item MailAccountCheck()

Check inbound mail configuration

    my %Check = $MailAccount->MailAccountCheck(
        Login         => 'mail',
        Password      => 'SomePassword',
        Host          => 'pop3.example.com',
        Type          => 'POP3', # POP3|POP3S|IMAP|IMAPS
        Timeout       => '60',
        Debug         => '0',
    );

=cut

sub MailAccountCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Type Timeout Debug)) {
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

    # check if connect is successful
    my $Backend = $GenericModule->new( %{$Self} );
    my %Check   = $Backend->Connect(%Param);

    if ( $Check{Successful} ) {
        return ( Successful => 1 )
    }
    else {
        return ( Successful => 0, Message => $Check{Message} );
    }
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
