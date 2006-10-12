# --
# XML.t - XML tests
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: XML.t,v 1.8 2006-10-12 14:47:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::XML;

$Self->{XMLObject} = Kernel::System::XML->new(%{$Self});

my $String = '
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
      <Telephone2></Telephone2>
      <SpecialCharacters>\'</SpecialCharacters>
    </Contact>
';
#       <Germantext>Alle Deutschen Umlaute öäü ÄÜÖ ß</Germantext>

my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    'XMLParse2XMLHash()',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    'XMLHashGet() (Telephone->country)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    'XMLHashGet() (Telephone2)',
);

my $XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd,
    'XMLHashAdd() (Key=123)',
);

$XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    Key => "Some'Key",
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd eq "Some'Key",
    'XMLHashAdd() (Key=Some\'Key)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    'XMLHashGet() (admin)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
    'XMLHashGet() (Telephone->country)',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
    'XMLHashGet() (Telephone2)',
);

my @XMLHashUpdate = ();
$XMLHashUpdate[1]->{Contact}->[1]->{role} = 'admin1';
$XMLHashUpdate[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc. 2';
my $XMLHashUpdateTrue = $Self->{XMLObject}->XMLHashUpdate(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHashUpdate,
);
$Self->True(
    $XMLHashUpdateTrue,
    'XMLHashUpdate() (admin1)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    'XMLHashGet() (admin1)',
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
    'XMLHashUpdate() (admin)',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    'XMLHashGet() (admin)',
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

foreach my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeType',
        Key => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "XMLHashDelete() (Key $Key)",
    );
}

$XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    KeyAutoIncrement => 1,
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd eq 1,
    'XMLHashAdd() 1 KeyAutoIncrement',
);

$XMLHashAdd = $Self->{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    KeyAutoIncrement => 1,
    XMLHash => \@XMLHash,
);
$Self->True(
    $XMLHashAdd eq 2,
    'XMLHashAdd() 2 KeyAutoIncrement',
);

@Keys = $Self->{XMLObject}->XMLHashList(
    Type => 'SomeType',
);
foreach my $Key (@Keys) {
    my $XMLHashDelete = $Self->{XMLObject}->XMLHashDelete(
        Type => 'SomeType',
        Key => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "XMLHashDelete() 2 (Key $Key)",
    );
}

1;
