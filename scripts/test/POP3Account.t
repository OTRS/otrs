# --
# POP3Account.t - POP3Account tests
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: POP3Account.t,v 1.2 2006-08-26 17:36:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::POP3Account;

$Self->{POP3AccountObject} = Kernel::System::POP3Account->new(%{$Self});

my $POP3AccountAdd = $Self->{POP3AccountObject}->POP3AccountAdd(
    Login => 'mail',
    Password => 'SomePassword',
    Host => 'pop3.example.com',
    ValidID => 1,
    Trusted => 0,
    DispatchingBy => 'Queue', # Queue|From
    QueueID => 1,
    UserID => 1,
);

$Self->True(
    $POP3AccountAdd,
    'POP3AccountAdd()',
);

my $POP3AccountUpdate = $Self->{POP3AccountObject}->POP3AccountUpdate(
    ID => $POP3AccountAdd,
    Login => 'mail2',
    Password => 'SomePassword2',
    Host => 'pop3.example.com',
    ValidID => 1,
    Trusted => 0,
    DispatchingBy => 'Queue', # Queue|From
    QueueID => 1,
    UserID => 1,
);

$Self->True(
    $POP3AccountUpdate,
    'POP3AccountUpdate()',
);

my %POP3Account = $Self->{POP3AccountObject}->POP3AccountGet(
    ID => $POP3AccountAdd,
);

$Self->True(
    $POP3Account{Login} eq 'mail2',
    'POP3AccountGet()',
);

my %List = $Self->{POP3AccountObject}->POP3AccountList(
    Valid => 0, # just valid/all accounts
);

$Self->True(
    $List{$POP3AccountAdd},
    'POP3AccountList()',
);

my $POP3AccountDelete = $Self->{POP3AccountObject}->POP3AccountDelete(
    ID => $POP3AccountAdd,
);

$Self->True(
    $POP3AccountDelete,
    'POP3AccountDelete()',
);

1;
