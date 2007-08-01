# --
# XML.t - XML tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: XML.t,v 1.16 2007-08-01 00:08:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use utf8;
use Kernel::System::XML;
use Kernel::System::Ticket;

$Self->{XMLObject} = Kernel::System::XML->new(%{$Self});
$Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});

my $String = '<?xml version="1.0" encoding="iso-8859-1" ?>
    <Contact>
      <Name type="long">'."\x{00FC}".' Some Test</Name>
    </Contact>
';
my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#1 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{type} || '',
    'long',
    '#1 XMLParse2XMLHash() (Contact->Name->type)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} || '',
    "ü Some Test",
    '#1 XMLParse2XMLHash() (Contact->Name->Content)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content}) || '',
    '#1 XMLParse2XMLHash() (Contact->Name->type) Encode::is_utf8',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
      <JapanText>Japan カスタ</JapanText>
      <ChineseText>Chinese 用迎使用</ChineseText>
      <BulgarianText>Bulgarian Език</BulgarianText>
    </Contact>
';

@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#2 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{role} || '',
    'admin',
    '#2 XMLParse2XMLHash() (Contact->role)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
    'German Umlaute öäü ÄÜÖ ß',
    '#2 XMLParse2XMLHash() (Contact->GermanText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content}) || '',
    '#2 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} || '',
    'Japan カスタ',
    '#2 XMLParse2XMLHash() (Contact->JapanText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content}) || '',
    '#2 XMLParse2XMLHash() (Contact->JapanText) Encode::is_utf8',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} || '',
    'Chinese 用迎使用',
    '#2 XMLParse2XMLHash() (Contact->ChineseText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content}) || '',
    '#2 XMLParse2XMLHash() (Contact->ChineseText) Encode::is_utf8',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} || '',
    'Bulgarian Език',
    '#2 XMLParse2XMLHash() (Contact->BulgarianText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content}) || '',
    '#2 XMLParse2XMLHash() (Contact->BulgarianText) Encode::is_utf8',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
      <Telephone2></Telephone2>
      <SpecialCharacters>\'</SpecialCharacters>
      <SpecialCharacters1>\\\'</SpecialCharacters1>
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
    </Contact>
';

@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#3 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{role} || '',
    'admin',
    '#3 XMLParse2XMLHash() (Contact->role)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} || '',
    'germany',
    '#3 XMLParse2XMLHash() (Contact->Telephone->country)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content},
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone2)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters}->[1]->{Content} || '',
    '\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters1}->[1]->{Content} || '',
    '\\\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters1)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLParse2XMLHash() (Contact->GermanText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content}) || '',
    '#3 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
);

my $XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd,
    '#3 XMLHashAdd() (Key=123)',
);

$XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    Key => "Some'Key",
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd eq "Some'Key",
    '#3 XMLHashAdd() (Key=Some\'Key)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    '#3 XMLHashGet() (Telephone->country)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    '#3 XMLHashGet() (Telephone2)',
);
$Self->Is(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLHashGet() (GermanText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content}) || '',
    '#3 XMLHashGet() (GermanText) - Encode::is_utf8',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    '#3 XMLHashGet() (Telephone->country)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    '#3 XMLHashGet() (Telephone2)',
);
$Self->Is(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLHashGet() (GermanText)',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content}) || '',
    '#3 XMLHashGet() (GermanText) - Encode::is_utf8',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
    Cache => 0,
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin) - without cache',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    '#3 XMLHashGet() (Telephone->country) - without cache',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    '#3 XMLHashGet() (Telephone2) - without cache',
);
$Self->Is(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLHashGet() (GermanText) - without cache',
);

sleep 5;
my $XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashUpdateTrue,
    '#3 XMLHashUpdate() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
    Cache => 0,
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin) - without cache',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    '#3 XMLHashGet() (Telephone->country) - without cache',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    '#3 XMLHashGet() (Telephone2) - without cache',
);
$Self->Is(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLHashGet() (GermanText) - without cache',
);
$Self->True(
    Encode::is_utf8($XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content}) || '',
    '#3 XMLHashGet() (GermanText) - without cache - Encode::is_utf8',
);

my @XMLHashUpdate = ();
$XMLHashUpdate[1]->{Contact}->[1]->{role} = 'admin1';
$XMLHashUpdate[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc. 2';
$XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHashUpdate,
);
$Self->True(
    $XMLHashUpdateTrue,
    '#3 XMLHashUpdate() (admin1) # 1',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#3 XMLHashGet() (admin1) # 2',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#3 XMLHashGet() (admin1)',
);

@XMLHashUpdate = ();
$XMLHashUpdate[1]->{Contact}->[1]->{role} = 'admin';
$XMLHashUpdate[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc.';
$XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHashUpdate,
);
$Self->True(
    $XMLHashUpdateTrue,
    '#3 XMLHashUpdate() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
    Cache => 0,
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#3 XMLHashGet() (admin) - without cache',
);

my $XML = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $XML);
my $XML2 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
$Self->True(
    $XML eq $XML2,
    'XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my $XML3 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $XML);
my $XML4 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
$Self->True(
    ($XML2 eq $XML3 && $XML3 eq $XML4),
    'XMLHash2XML() -> XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my @Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
$Self->True(
    ($Keys[0] == 123),
    'XMLHashList() ([0] == 123)',
);

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
foreach my $Key (@Keys) {
    my $XMLHashMove = $Self->{XMLObject}->XMLHashMove(
        OldType => 'SomeType',
        OldKey => $Key,
        NewType => 'SomeTypeNew',
        NewKey => $Key,
    );
    $Self->True(
        $XMLHashMove,
        "XMLHashMove() (Key=$Key)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeTypeNew',
);
foreach my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "XMLHashDelete() (Key=$Key)",
    );
}

foreach my $KeyShould (1..12) {
    $XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
        Type => 'SomeType',
        KeyAutoIncrement => 1,
        XMLHash => \@XMLHash,
    );
    $Self->Is(
        $XMLHashAdd || '',
        $KeyShould,
        "XMLHashAdd() ($KeyShould KeyAutoIncrement)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
foreach my $Key (@Keys) {
    my $XMLHashMove = $Self->{XMLObject}->XMLHashMove(
        OldType => 'SomeType',
        OldKey => $Key,
        NewType => 'SomeTypeNew',
        NewKey => $Key . 'New',
    );
    $Self->True(
        $XMLHashMove,
        "XMLHashMove() 2 (Key=$Key)",
    );
}

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeTypeNew',
);
foreach my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "XMLHashDelete() 2 (Key=$Key)",
    );
}
#------------------------------------------------#
# a test to find charset problems with xml files
#------------------------------------------------#

# get the example xml
my $Path = $Self->{ConfigObject}->Get('Home');
$Path .= "/scripts/test";
my $File = 'XML-Test-file.xml';
$String = '';
if (open (DATA, "< $Path/$File")) {
    while (<DATA>) {
        $String .= $_;
    }
    close (DATA);

    # charset test - use file form the filesystem and parse it
    @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);
    $Self->True(
       $#XMLHash == 1 && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
       'XMLParse2XMLHash() - charset test - use file form the filesystem and parse it',
    );

    # charset test - use file form the articleattachement and parse it
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        Title => 'Some Ticket Title',
        Queue => 'Raw',
        Lock => 'unlock',
        Priority => '3 normal',
        State => 'closed successful',
        CustomerNo => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID => 1,
        UserID => 1,
    );
    $Self->True(
        $TicketID,
        'XMLParse2XMLHash() - charset test - create ticket',
    );

    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID => $TicketID,
        ArticleType => 'note-internal',
        SenderType => 'agent',
        From => 'Some Agent <email@example.com>',
        To => 'Some Customer <customer-a@example.com>',
        Cc => 'Some Customer <customer-b@example.com>',
        ReplyTo => 'Some Customer <customer-b@example.com>',
        Subject => 'some short description',
        Body => 'the message text Perl modules provide a range of featurheel, and can be downloaded',
        ContentType => 'text/plain; charset=ISO-8859-15',
        HistoryType => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID => 1,
        NoAgentNotify => 1,            # if you don't want to send agent notifications
    );

    $Self->True(
        $ArticleID,
        'XMLParse2XMLHash() - charset test - create article',
    );

    my $Feedback = $Self->{TicketObject}->ArticleWriteAttachment(
        Content => $String,
        ContentType => 'text/html; charset="iso-8859-15"',
        Filename => $File,
        ArticleID => $ArticleID,
        UserID => 1,
    );
    $Self->True(
        $Feedback,
        'XMLParse2XMLHash() - charset test - write an article attachemnt to storage',
    );

    my %Attachment = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID => 1,
        UserID => 1,
    );

    @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $Attachment{Content});
    $Self->True(
       $#XMLHash == 1 && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
       'XMLParse2XMLHash() - charset test - use file form the articleattachement and parse it',
    );

}
else {
    $Self->True(
        0,
        "XMLParse2XMLHash() - charset test - failed because example file not found",
    );
}

1;
