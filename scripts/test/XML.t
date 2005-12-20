# --
# XML.t - XML tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: XML.t,v 1.1 2005-12-20 22:53:43 martin Exp $
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
    </Contact>
';

my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $String);

$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    'XMLParse2XMLHash',
);

$Self->True(
    $Self->{XMLObject}->XMLHashAdd(
        Type => 'SomeType',
        Key => '123',
        XMLHash => \@XMLHash,
    ),
    'XMLHashAdd',
);

@XMLHash = $Self->{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    'XMLHashGet',
);

my $XML = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
@XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $XML);
my $XML2 = $Self->{XMLObject}->XMLHash2XML(@XMLHash);

$Self->True(
    $XML eq $XML2,
    'XMLHash2XML -> XMLParse2XMLHash -> XMLHash2XML',
);

1;
