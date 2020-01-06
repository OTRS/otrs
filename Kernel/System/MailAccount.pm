# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::MailAccount;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
    'Kernel::System::Cache',
);

=head1 NAME

Kernel::System::MailAccount - to manage mail accounts

=head1 DESCRIPTION

All functions to manage the mail accounts.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MailAccountObject = $Kernel::OM->Get('Kernel::System::MailAccount');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'MailAccount';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;    # 20 days

    return $Self;
}

=head2 MailAccountAdd()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!"
            );
            return;
        }
    }
    for (qw(Login Password Host Type ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if dispatching is by From
    if ( $Param{DispatchingBy} eq 'From' ) {
        $Param{QueueID} = 0;
    }
    elsif ( $Param{DispatchingBy} eq 'Queue' && !$Param{QueueID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need QueueID for dispatching!"
        );
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
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

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM mail_account WHERE login = ? AND host = ? AND account_type = ?',
        Bind => [ \$Param{Login}, \$Param{Host}, \$Param{Type} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return $ID;
}

=head2 MailAccountGetAll()

returns an array of all mail account data

    my @MailAccounts = $MailAccount->MailAccountGetAll();

(returns list of the fields for each account: ID, Login, Password, Host, Type, QueueID, Trusted, IMAPFolder, Comment, DispatchingBy, ValidID)


=cut

sub MailAccountGetAll {
    my ( $Self, %Param ) = @_;

    # check cache
    my $CacheKey = 'MailAccountGetAll';
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return @{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT id, login, pw, host, account_type, queue_id, imap_folder, trusted, comments, valid_id, '
            . ' create_time, change_time FROM mail_account',
    );

    my @Accounts;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        my %Data = (
            ID         => $Data[0],
            Login      => $Data[1],
            Password   => $Data[2],
            Host       => $Data[3],
            Type       => $Data[4] || 'POP3',    # compat for old setups
            QueueID    => $Data[5],
            IMAPFolder => $Data[6],
            Trusted    => $Data[7],
            Comment    => $Data[8],
            ValidID    => $Data[9],
            CreateTime => $Data[10],
            ChangeTime => $Data[11],
        );

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

        push @Accounts, \%Data;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \@Accounts,
    );

    return @Accounts;
}

=head2 MailAccountGet()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ID!"
        );
        return;
    }

    # check cache
    my $CacheKey = join '::', 'MailAccountGet', 'ID', $Param{ID};
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT login, pw, host, account_type, queue_id, imap_folder, trusted, comments, valid_id, '
            . ' create_time, change_time FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {
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

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

=head2 MailAccountUpdate()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if dispatching is by From
    if ( $Param{DispatchingBy} eq 'From' ) {
        $Param{QueueID} = 0;
    }
    elsif ( $Param{DispatchingBy} eq 'Queue' && !$Param{QueueID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need QueueID for dispatching!"
        );
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
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE mail_account SET login = ?, pw = ?, host = ?, account_type = ?, '
            . ' comments = ?, imap_folder = ?, trusted = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ?, queue_id = ? WHERE id = ?',
        Bind => [
            \$Param{Login},   \$Param{Password},   \$Param{Host},    \$Param{Type},
            \$Param{Comment}, \$Param{IMAPFolder}, \$Param{Trusted}, \$Param{ValidID},
            \$Param{UserID},  \$Param{QueueID},    \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 MailAccountDelete()

deletes a mail account

    $MailAccount->MailAccountDelete(
        ID => 123,
    );

=cut

sub MailAccountDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ID!"
        );
        return;
    }

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM mail_account WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 MailAccountList()

returns a list (Key, Name) of all mail accounts

    my %List = $MailAccount->MailAccountList(
        Valid => 0, # just valid/all accounts
    );

=cut

sub MailAccountList {
    my ( $Self, %Param ) = @_;

    # check cache
    my $CacheKey = join '::', 'MailAccountList', ( $Param{Valid} ? 'Valid::1' : '' );
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get valid object
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    my $Where = $Param{Valid}
        ? 'WHERE valid_id IN ( ' . join ', ', $ValidObject->ValidIDsGet() . ' )'
        : '';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "SELECT id, host, login FROM mail_account $Where",
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = "$Row[1] ($Row[2])";
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

=head2 MailAccountBackendList()

returns a list of usable backends

    my %List = $MailAccount->MailAccountBackendList();

=cut

sub MailAccountBackendList {
    my ( $Self, %Param ) = @_;

    my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/System/MailAccount/';

    my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.pm',
    );

    my %Backends;
    for my $File (@List) {

        # remove .pm
        $File =~ s/^.*\/(.+?)\.pm$/$1/;
        my $GenericModule = "Kernel::System::MailAccount::$File";

        # try to load module $GenericModule
        if ( eval "require $GenericModule" ) {    ## no critic
            if ( eval { $GenericModule->new() } ) {
                $Backends{$File} = $File;
            }
        }
    }

    return %Backends;
}

=head2 MailAccountFetch()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # load backend
    my $GenericModule = "Kernel::System::MailAccount::$Param{Type}";

    # try to load module $GenericModule
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {
        return;
    }

    # fetch mails
    my $Backend = $GenericModule->new();

    return $Backend->Fetch(%Param);
}

=head2 MailAccountCheck()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # load backend
    my $GenericModule = "Kernel::System::MailAccount::$Param{Type}";

    # try to load module $GenericModule
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {
        return;
    }

    # check if connect is successful
    my $Backend = $GenericModule->new();
    my %Check   = $Backend->Connect(%Param);

    if ( $Check{Successful} ) {
        return ( Successful => 1 );
    }
    else {
        return (
            Successful => 0,
            Message    => $Check{Message}
        );
    }
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
