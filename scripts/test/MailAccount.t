# --
# MailAccount.t - MailAccount tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: MailAccount.t,v 1.1 2008-03-28 11:32:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::MailAccount;

$Self->{MailAccountObject} = Kernel::System::MailAccount->new(%{$Self});

my $MailAccountAdd = $Self->{MailAccountObject}->MailAccountAdd(
    Login         => 'mail',
    Password      => 'SomePassword',
    Host          => 'pop3.example.com',
    Type          => 'POP3',
    ValidID       => 1,
    Trusted       => 0,
    DispatchingBy => 'Queue', # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountAdd,
    'MailAccountAdd()',
);

my %MailAccount = $Self->{MailAccountObject}->MailAccountGet(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccount{Login} eq 'mail',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'pop3.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'POP3',
    'MailAccountGet() - Type',
);

my $MailAccountUpdate = $Self->{MailAccountObject}->MailAccountUpdate(
    ID            => $MailAccountAdd,
    Login         => 'mail2',
    Password      => 'SomePassword2',
    Host          => 'imap.example.com',
    Type          => 'IMAP',
    ValidID       => 1,
    Trusted       => 0,
    DispatchingBy => 'Queue', # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountUpdate,
    'MailAccountUpdate()',
);

%MailAccount = $Self->{MailAccountObject}->MailAccountGet(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccount{Login} eq 'mail2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'imap.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'IMAP',
    'MailAccountGet() - Type',
);

my %List = $Self->{MailAccountObject}->MailAccountList(
    Valid => 0, # just valid/all accounts
);

$Self->True(
    $List{$MailAccountAdd},
    'MailAccountList()',
);

my $MailAccountDelete = $Self->{MailAccountObject}->MailAccountDelete(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccountDelete,
    'MailAccountDelete()',
);

1;
