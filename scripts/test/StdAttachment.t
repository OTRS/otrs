# --
# StdAttachment.t - StdAttachment tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: StdAttachment.t,v 1.9 2010-10-29 22:16:59 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::StdAttachment;

my $StdAttachmentObject = Kernel::System::StdAttachment->new( %{$Self} );

# file checks
for my $File (qw(xls txt doc png pdf)) {
    my $Content = '';
    open( IN,
        "< "
            . $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File"
        )
        || die $!;
    binmode(IN);
    while (<IN>) {
        $Content .= $_;
    }
    close(IN);

    my $MD5 = $Self->{MainObject}->MD5sum( String => \$Content );

    my $Add = $StdAttachmentObject->StdAttachmentAdd(
        Name        => 'Some Name 123456798',
        ValidID     => 1,
        Content     => $Content,
        ContentType => 'text/xml',
        Filename    => 'StdAttachment Test1äöüß.' . $File,
        Comment     => 'Some Comment',
        UserID      => 1,
    );

    $Self->True(
        $Add || '',
        "StdAttachmentAdd() - ." . $File,
    );

    my %Data = $StdAttachmentObject->StdAttachmentGet( ID => $Add );
    my $MD5Add = $Self->{MainObject}->MD5sum( String => \$Data{Content} );

    $Self->Is(
        $MD5    || '',
        $MD5Add || '',
        "StdAttachmentGet() - MD5 ." . $File,
    );
    $Self->Is(
        $Data{Name} || '',
        'Some Name 123456798',
        "StdAttachmentGet() - Name ." . $File,
    );
    $Self->Is(
        $Data{ContentType} || '',
        'text/xml',
        "StdAttachmentGet() - ContentType ." . $File,
    );
    $Self->Is(
        $Data{Comment} || '',
        'Some Comment',
        "StdAttachmentGet() - Comment ." . $File,
    );
    $Self->Is(
        $Data{Filename} || '',
        'StdAttachment Test1äöüß.' . $File,
        "StdAttachmentGet() - Filename ." . $File,
    );

    my $ID = $StdAttachmentObject->StdAttachmentLookup( StdAttachment => 'Some Name 123456798' );
    $Self->Is(
        $ID || '',
        $Add,
        "StdAttachmentLookup() - ID ." . $File,
    );

    my $Name = $StdAttachmentObject->StdAttachmentLookup( StdAttachmentID => $ID );
    $Self->Is(
        $Name || '',
        $Data{Name} || '',
        "StdAttachmentLookup() - Name ." . $File,
    );

    my $Update = $StdAttachmentObject->StdAttachmentUpdate(
        ID          => $ID,
        Name        => 'Some Name',
        ValidID     => 1,
        Content     => $Data{Content},
        ContentType => 'text/html',
        Filename    => 'SomeFile.' . $File,
        Comment     => 'Lala123öäüß',
        UserID      => 1,
    );
    $Self->True(
        $Update || '',
        "StdAttachmentUpdate() - ." . $File,
    );

    %Data = $StdAttachmentObject->StdAttachmentGet( ID => $ID );
    my $MD5Update = $Self->{MainObject}->MD5sum( String => \$Data{Content} );

    $Self->Is(
        $MD5       || '',
        $MD5Update || '',
        "StdAttachmentGet() - MD5 ." . $File,
    );
    $Self->Is(
        $Data{Name} || '',
        'Some Name',
        "StdAttachmentGet() - Name ." . $File,
    );
    $Self->Is(
        $Data{ContentType} || '',
        'text/html',
        "StdAttachmentGet() - ContentType ." . $File,
    );
    $Self->Is(
        $Data{Comment} || '',
        'Lala123öäüß',
        "StdAttachmentGet() - Comment ." . $File,
    );
    $Self->Is(
        $Data{Filename} || '',
        'SomeFile.' . $File,
        "StdAttachmentGet() - Filename ." . $File,
    );

    $ID = $StdAttachmentObject->StdAttachmentLookup( StdAttachment => 'Some Name' );
    $Self->Is(
        $ID || '',
        $Add,
        "StdAttachmentLookup() - ID ." . $File,
    );

    $Name = $StdAttachmentObject->StdAttachmentLookup( StdAttachmentID => $ID );
    $Self->Is(
        $Name || '',
        $Data{Name} || '',
        "StdAttachmentLookup() - Name ." . $File,
    );

    my $Delete = $StdAttachmentObject->StdAttachmentDelete( ID => $Add );
    $Self->True(
        $Delete || '',
        "StdAttachmentDelete() - ." . $File,
    );
}

1;
