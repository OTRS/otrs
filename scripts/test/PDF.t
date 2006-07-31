# --
# PDF.t - PDF tests
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PDF.t,v 1.1 2006-07-31 12:29:01 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::PDF;

# load PDF::API2 if installed
if (!$Self->{MainObject}->Require('PDF::API2')) {
    return;
}
$Self->{PDFObject} = Kernel::System::PDF->new(%{$Self});

# create a pdf document
my $DocumentNew1 = $Self->{PDFObject}->DocumentNew(
    Title => 'The Title',
);

$Self->True(
    $DocumentNew1,
    "DocumentNew1()",
);

# create a blank page
my $PageBlankNew1 = $Self->{PDFObject}->PageBlankNew(
    Width => 842,
    Height => 595,
    MarginTop => 50,
    MarginRight => 50,
    MarginBottom => 50,
    MarginLeft => 50,
);

$Self->True(
    $PageBlankNew1,
    "PageBlankNew1()",
);

my $PageNew1 = $Self->{PDFObject}->PageNew(
    Width => 842,
    Height => 595,
    MarginTop => 50,
    MarginRight => 50,
    MarginBottom => 50,
    MarginLeft => 50,
    HeaderRight => 'Header Right Text',
    FooterLeft => 'Footer Left Text',
    FooterRight => 'Footer Right Text',
);

$Self->True(
    $PageNew1,
    "PageNew1()",
);

# test _StringWidth()
my $StringWidthText = 'Das ist der Testtext.';
my @StringWidthReturn = (120,114,108,102,96,90,84,78,72,66,60,54,48,42,36,30,24,18,12,6,0);

my $C1 = 0;
while (chop($StringWidthText)) {
    my $TestOk = 0;
    my $Width = $Self->{PDFObject}->_StringWidth(
        Text => $StringWidthText,
        Font => 'Courier',
        FontSize => 10,
    );

    if ($Width eq $StringWidthReturn[$C1]) {
        $TestOk = 1;
    }
    else {
        print "ERROR Width $C1 --> $Width\n";
    }

    $Self->True(
        $TestOk,
        "_StringWidth$C1()",
    );
    $C1++;
}

# test _TextCalculate()
my %TextCalculateData;

# test0
$TextCalculateData{0}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{0}{Type} = 'ReturnLeftOverHard';
$TextCalculateData{0}{State} = 1;
$TextCalculateData{0}{RequiredWidth} = 96.7;
$TextCalculateData{0}{RequiredHeight} = 50;
$TextCalculateData{0}{LeftOver} = '';
$TextCalculateData{0}{PossibleRows}{0} = 'Der Raumtransporter';
$TextCalculateData{0}{PossibleRows}{1} = '"Discovery" hat heute';
$TextCalculateData{0}{PossibleRows}{2} = 'Nachmittag um 16.52';
$TextCalculateData{0}{PossibleRows}{3} = 'Uhr MESZ an der ISS';
$TextCalculateData{0}{PossibleRows}{4} = 'angedockt.';

# test1
$TextCalculateData{1}{Text} = 'Der Raumtransporteri  "Discovery" hat am heutigen Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{1}{Type} = 'ReturnLeftOverHard';
$TextCalculateData{1}{State} = 1;
$TextCalculateData{1}{RequiredWidth} = 98.24;
$TextCalculateData{1}{RequiredHeight} = 50;
$TextCalculateData{1}{LeftOver} = '';
$TextCalculateData{1}{PossibleRows}{0} = 'Der Raumtransporteri';
$TextCalculateData{1}{PossibleRows}{1} = '"Discovery" hat am he';
$TextCalculateData{1}{PossibleRows}{2} = 'utigen Nachmittag um';
$TextCalculateData{1}{PossibleRows}{3} = '16.52 Uhr MESZ an d';
$TextCalculateData{1}{PossibleRows}{4} = 'er ISS angedockt.';

# test2
$TextCalculateData{2}{Text} = 'Der Raumtransporter Discovery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{2}{Type} = 'ReturnLeftOverHard';
$TextCalculateData{2}{Width} = 30,
$TextCalculateData{2}{Height} = 105,
$TextCalculateData{2}{State} = 0;
$TextCalculateData{2}{RequiredWidth} = 29.45;
$TextCalculateData{2}{RequiredHeight} = 100;
$TextCalculateData{2}{LeftOver} = '.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{2}{PossibleRows}{0} = 'Der R';
$TextCalculateData{2}{PossibleRows}{1} = 'aumtr';
$TextCalculateData{2}{PossibleRows}{2} = 'anspo';
$TextCalculateData{2}{PossibleRows}{3} = 'rter Di';
$TextCalculateData{2}{PossibleRows}{4} = 'scover';
$TextCalculateData{2}{PossibleRows}{5} = 'y hat';
$TextCalculateData{2}{PossibleRows}{6} = 'heute';
$TextCalculateData{2}{PossibleRows}{7} = 'Nach';
$TextCalculateData{2}{PossibleRows}{8} = 'mittag';
$TextCalculateData{2}{PossibleRows}{9} = 'um 16';

# test3
$TextCalculateData{3}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{3}{Type} = 'ReturnLeftOverHard';
$TextCalculateData{3}{Width} = 1,
$TextCalculateData{3}{Height} = 1,
$TextCalculateData{3}{State} = 0;
$TextCalculateData{3}{RequiredWidth} = 0;
$TextCalculateData{3}{RequiredHeight} = 0;
$TextCalculateData{3}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test4
$TextCalculateData{4}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{4}{Type} = 'ReturnLeftOverHard';
$TextCalculateData{4}{Width} = 0,
$TextCalculateData{4}{Height} = 0,
$TextCalculateData{4}{State} = 0;
$TextCalculateData{4}{RequiredWidth} = 0;
$TextCalculateData{4}{RequiredHeight} = 0;
$TextCalculateData{4}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test5
$TextCalculateData{5}{Text} = 'Der Raumtransporter Discovery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{5}{Type} = 'ReturnLeftOver';
$TextCalculateData{5}{State} = 1;
$TextCalculateData{5}{RequiredWidth} = 96.7;
$TextCalculateData{5}{RequiredHeight} = 50;
$TextCalculateData{5}{LeftOver} = '';
$TextCalculateData{5}{PossibleRows}{0} = 'Der Raumtransporter';
$TextCalculateData{5}{PossibleRows}{1} = 'Discovery hat heute';
$TextCalculateData{5}{PossibleRows}{2} = 'Nachmittag um 16.52';
$TextCalculateData{5}{PossibleRows}{3} = 'Uhr MESZ an der ISS';
$TextCalculateData{5}{PossibleRows}{4} = 'angedockt.';

# test6
$TextCalculateData{6}{Text} = 'Der Raumtransporter Discovery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{6}{Type} = 'ReturnLeftOver';
$TextCalculateData{6}{Width} = 30,
$TextCalculateData{6}{Height} = 53,
$TextCalculateData{6}{State} = 0;
$TextCalculateData{6}{RequiredWidth} = 30;
$TextCalculateData{6}{RequiredHeight} = 50;
$TextCalculateData{6}{LeftOver} = 'ery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{6}{PossibleRows}{0} = 'Der';
$TextCalculateData{6}{PossibleRows}{1} = 'Raumt';
$TextCalculateData{6}{PossibleRows}{2} = 'ransp';
$TextCalculateData{6}{PossibleRows}{3} = 'orter';
$TextCalculateData{6}{PossibleRows}{4} = 'Discov';

# test7
$TextCalculateData{7}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{7}{Type} = 'ReturnLeftOver';
$TextCalculateData{7}{Width} = 1,
$TextCalculateData{7}{Height} = 1,
$TextCalculateData{7}{State} = 0;
$TextCalculateData{7}{RequiredWidth} = 0;
$TextCalculateData{7}{RequiredHeight} = 0;
$TextCalculateData{7}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test8
$TextCalculateData{8}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{8}{Type} = 'ReturnLeftOver';
$TextCalculateData{8}{Width} = 0,
$TextCalculateData{8}{Height} = 0,
$TextCalculateData{8}{State} = 0;
$TextCalculateData{8}{RequiredWidth} = 0;
$TextCalculateData{8}{RequiredHeight} = 0;
$TextCalculateData{8}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test9
$TextCalculateData{9}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{9}{Type} = 'Cut';
$TextCalculateData{9}{State} = 1;
$TextCalculateData{9}{RequiredWidth} = 96.7;
$TextCalculateData{9}{RequiredHeight} = 50;
$TextCalculateData{9}{LeftOver} = '';
$TextCalculateData{9}{PossibleRows}{0} = 'Der Raumtransporter';
$TextCalculateData{9}{PossibleRows}{1} = '"Discovery" hat heute';
$TextCalculateData{9}{PossibleRows}{2} = 'Nachmittag um 16.52';
$TextCalculateData{9}{PossibleRows}{3} = 'Uhr MESZ an der ISS';
$TextCalculateData{9}{PossibleRows}{4} = 'angedockt.';

# test10
$TextCalculateData{10}{Text} = 'Der Raumtransporter Discovery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{10}{Type} = 'Cut';
$TextCalculateData{10}{Width} = 20,
$TextCalculateData{10}{Height} = 49,
$TextCalculateData{10}{State} = 1;
$TextCalculateData{10}{RequiredWidth} = 20;
$TextCalculateData{10}{RequiredHeight} = 40;
$TextCalculateData{10}{LeftOver} = '';
$TextCalculateData{10}{PossibleRows}{0} = 'Der';
$TextCalculateData{10}{PossibleRows}{1} = 'Rau';
$TextCalculateData{10}{PossibleRows}{2} = 'mtra';
$TextCalculateData{10}{PossibleRows}{3} = 'n[..]';

# test11
$TextCalculateData{11}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{11}{Type} = 'Cut';
$TextCalculateData{11}{Width} = 1,
$TextCalculateData{11}{Height} = 1,
$TextCalculateData{11}{State} = 0;
$TextCalculateData{11}{RequiredWidth} = 0;
$TextCalculateData{11}{RequiredHeight} = 0;
$TextCalculateData{11}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test12
$TextCalculateData{12}{Text} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{12}{Type} = 'Cut';
$TextCalculateData{12}{Width} = 0,
$TextCalculateData{12}{Height} = 0,
$TextCalculateData{12}{State} = 0;
$TextCalculateData{12}{RequiredWidth} = 0;
$TextCalculateData{12}{RequiredHeight} = 0;
$TextCalculateData{12}{LeftOver} = 'Der Raumtransporter "Discovery" hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';

# test13
$TextCalculateData{13}{Text} = 'Der Raumtransporter Discovery hat heute Nachmittag um 16.52 Uhr MESZ an der ISS angedockt.';
$TextCalculateData{13}{Type} = 'Cut';
$TextCalculateData{13}{Width} = 10,
$TextCalculateData{13}{Height} = 40,
$TextCalculateData{13}{State} = 1;
$TextCalculateData{13}{RequiredWidth} = 8.89;
$TextCalculateData{13}{RequiredHeight} = 40;
$TextCalculateData{13}{LeftOver} = '';
$TextCalculateData{13}{PossibleRows}{0} = 'D';
$TextCalculateData{13}{PossibleRows}{1} = 'er';
$TextCalculateData{13}{PossibleRows}{2} = 'R';
$TextCalculateData{13}{PossibleRows}{3} = 'a';

# start testing _TextCalculate()
foreach (sort keys %TextCalculateData) {
    my $Test = $_;
    my $TestOk = 0;
    if (!defined($TextCalculateData{$Test}{Width})) {
        $TextCalculateData{$Test}{Width} = 100;
    }
    if (!defined($TextCalculateData{$Test}{Height})) {
        $TextCalculateData{$Test}{Height} = 100;
    }
    $TextCalculateData{$Test}{Font} = $TextCalculateData{$Test}{Font} || 'Helvetica';
    $TextCalculateData{$Test}{FontSize} = $TextCalculateData{$Test}{FontSize} || 10;
    $TextCalculateData{$Test}{Lead} = $TextCalculateData{$Test}{Lead} || 0;
    $TextCalculateData{$Test}{Type} = $TextCalculateData{$Test}{Type} || 'ReturnLeftOver';

    my %Return = $Self->{PDFObject}->_TextCalculate(
        Text => $TextCalculateData{$Test}{Text},
        Width => $TextCalculateData{$Test}{Width},
        Height => $TextCalculateData{$Test}{Height},
        Font => $TextCalculateData{$Test}{Font},
        FontSize  => $TextCalculateData{$Test}{FontSize},
        Lead => $TextCalculateData{$Test}{Lead},
        Type => $TextCalculateData{$Test}{Type},
    );

    my $C1 = 0;
    my $PossibleRowsOK = 1;
    foreach (@{$Return{PossibleRows}}) {
        if (!$TextCalculateData{$Test}{PossibleRows}{$C1} || $TextCalculateData{$Test}{PossibleRows}{$C1} ne $_) {
            $PossibleRowsOK = 0;
            print "ERROR Row $C1 -->" . $_ . "<--\n";
        }
        $C1++;
    }

    if ($Return{State} eq $TextCalculateData{$Test}{State} &&
        $Return{RequiredWidth} eq $TextCalculateData{$Test}{RequiredWidth} &&
        $Return{RequiredHeight} eq $TextCalculateData{$Test}{RequiredHeight} &&
        $Return{LeftOver} eq $TextCalculateData{$Test}{LeftOver} &&
        $PossibleRowsOK
    ) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR TextCalculate$Test State -->$Return{State}\n";
        print "ERROR TextCalculate$Test RequiredWidth -->$Return{RequiredWidth}\n";
        print "ERROR TextCalculate$Test RequiredHeight -->$Return{RequiredHeight}\n";
        print "ERROR TextCalculate$Test LeftOver -->$Return{LeftOver}<--\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "_TextCalculate$Test()",
    );
}

# test Text()
my %TextData;

# test0
$TextData{0}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{0}{Type} = 'ReturnLeftOver';
$TextData{0}{Width} = 700;
$TextData{0}{State} = 1;
$TextData{0}{RequiredWidth} = 541.34;
$TextData{0}{RequiredHeight} = 10;
$TextData{0}{LeftOver} = '';

# test1
$TextData{1}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{1}{Type} = 'ReturnLeftOver';
$TextData{1}{Width} = 300;
$TextData{1}{State} = 0;
$TextData{1}{RequiredWidth} = 234.52;
$TextData{1}{RequiredHeight} = 10;
$TextData{1}{LeftOver} = 'September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test2
$TextData{2}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{2}{Type} = 'ReturnLeftOver';
$TextData{2}{Width} = 0;
$TextData{2}{State} = 0;
$TextData{2}{RequiredWidth} = 0;
$TextData{2}{RequiredHeight} = 0;
$TextData{2}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test3
$TextData{3}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{3}{Type} = 'ReturnLeftOver';
$TextData{3}{Width} = 1;
$TextData{3}{State} = 0;
$TextData{3}{RequiredWidth} = 0;
$TextData{3}{RequiredHeight} = 0;
$TextData{3}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test4
$TextData{4}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{4}{Type} = 'ReturnLeftOverHard';
$TextData{4}{Width} = 700;
$TextData{4}{State} = 1;
$TextData{4}{RequiredWidth} = 541.34;
$TextData{4}{RequiredHeight} = 10;
$TextData{4}{LeftOver} = '';

# test5
$TextData{5}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{5}{Type} = 'ReturnLeftOverHard';
$TextData{5}{Width} = 300;
$TextData{5}{State} = 0;
$TextData{5}{RequiredWidth} = 299.55;
$TextData{5}{RequiredHeight} = 10;
$TextData{5}{LeftOver} = 'ktober 2007 zur Internationalen Raumstation gebracht.';

# test6
$TextData{6}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{6}{Type} = 'ReturnLeftOverHard';
$TextData{6}{Width} = 0;
$TextData{6}{State} = 0;
$TextData{6}{RequiredWidth} = 0;
$TextData{6}{RequiredHeight} = 0;
$TextData{6}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test7
$TextData{7}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{7}{Type} = 'ReturnLeftOverHard';
$TextData{7}{Width} = 1;
$TextData{7}{State} = 0;
$TextData{7}{RequiredWidth} = 0;
$TextData{7}{RequiredHeight} = 0;
$TextData{7}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test8
$TextData{8}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{8}{Type} = 'Cut';
$TextData{8}{Width} = 700;
$TextData{8}{State} = 1;
$TextData{8}{RequiredWidth} = 541.34;
$TextData{8}{RequiredHeight} = 10;
$TextData{8}{LeftOver} = '';

# test9
$TextData{9}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{9}{Type} = 'Cut';
$TextData{9}{Width} = 300;
$TextData{9}{State} = 1;
$TextData{9}{RequiredWidth} = 245.64;
$TextData{9}{RequiredHeight} = 10;
$TextData{9}{LeftOver} = '';

# test10
$TextData{10}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{10}{Type} = 'Cut';
$TextData{10}{Width} = 0;
$TextData{10}{State} = 0;
$TextData{10}{RequiredWidth} = 0;
$TextData{10}{RequiredHeight} = 0;
$TextData{10}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# test11
$TextData{11}{Text} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';
$TextData{11}{Type} = 'Cut';
$TextData{11}{Width} = 1;
$TextData{11}{State} = 0;
$TextData{11}{RequiredWidth} = 0;
$TextData{11}{RequiredHeight} = 0;
$TextData{11}{LeftOver} = 'Columbus wird von ESA-Astronaut Hans Schlegel im  September/Oktober 2007 zur Internationalen Raumstation gebracht.';

# start testing Text()
foreach (sort keys %TextData) {
    my $Test = $_;
    my $TestOk = 0;

    $TextData{$Test}{Font} = $TextData{$Test}{Font} || 'Helvetica';
    $TextData{$Test}{FontSize} = $TextData{$Test}{FontSize} || 10;
    $TextData{$Test}{Type} = $TextData{$Test}{Type} || 'ReturnLeftOver';
    $TextData{$Test}{Lead} = $TextData{$Test}{Lead} || 0;

    if (!defined($TextData{$Test}{Width})) {
        $TextData{$Test}{Width} = 100;
    }
    if (!defined($TextData{$Test}{Height})) {
        $TextData{$Test}{Height} = $TextData{$Test}{FontSize};
    }

    my %Return = $Self->{PDFObject}->Text(
        Text => $TextData{$Test}{Text},
        Width => $TextData{$Test}{Width},
        Height => $TextData{$Test}{Height},
        Font => $TextData{$Test}{Font},
        FontSize  => $TextData{$Test}{FontSize},
        Type => $TextData{$Test}{Type},
        Lead => $TextData{$Test}{Lead},
    );

    if ($Return{State} eq $TextData{$Test}{State} &&
        $Return{RequiredWidth} eq $TextData{$Test}{RequiredWidth} &&
        $Return{RequiredHeight} eq $TextData{$Test}{RequiredHeight} &&
        $Return{LeftOver} eq $TextData{$Test}{LeftOver}
    ) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR Text$Test State -->$Return{State}\n";
        print "ERROR Text$Test RequiredWidth -->$Return{RequiredWidth}\n";
        print "ERROR Text$Test RequiredHeight -->$Return{RequiredHeight}\n";
        print "ERROR Text$Test LeftOver -->$Return{LeftOver}<--\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "Text$Test()",
    );
}

# special Text() tests
my $PageNew2 =     $Self->{PDFObject}->PageNew(
    Width => 842,
    Height => 595,
    MarginTop => 30,
    MarginRight => 40,
    MarginBottom => 40,
    MarginLeft => 40,
    HeaderRight => 'Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben Rechts Oben',
    FooterLeft => 'Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten Links Unten',
    FooterRight => 'Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten Rechts Unten',
);

$Self->True(
    $PageNew2,
    "PageNew2()",
);

# position Text() tests
my %TextData2;

# positiontest0
$TextData2{0}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{0}{Type} = 'ReturnLeftOver';
$TextData2{0}{Width} = 150;
$TextData2{0}{Position1X} = 'left';
$TextData2{0}{Position1Y} = 'bottom';
$TextData2{0}{State} = 0;
$TextData2{0}{RequiredWidth} = 0;
$TextData2{0}{RequiredHeight} = 0;
$TextData2{0}{LeftOver} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{0}{PositionReturnX} = 40;
$TextData2{0}{PositionReturnY} = 56;

# positiontest1
$TextData2{1}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{1}{Type} = 'ReturnLeftOver';
$TextData2{1}{Width} = 150;
$TextData2{1}{Position1X} = 'left';
$TextData2{1}{Position1Y} = 'bottom';
$TextData2{1}{Position2Y} = 9;
$TextData2{1}{State} = 0;
$TextData2{1}{RequiredWidth} = 0;
$TextData2{1}{RequiredHeight} = 0;
$TextData2{1}{LeftOver} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{1}{PositionReturnX} = 40;
$TextData2{1}{PositionReturnY} = 65;

# positiontest2
$TextData2{2}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{2}{Type} = 'ReturnLeftOver';
$TextData2{2}{Width} = 150;
$TextData2{2}{Position1X} = 'left';
$TextData2{2}{Position1Y} = 'bottom';
$TextData2{2}{Position2Y} = 10;
$TextData2{2}{State} = 0;
$TextData2{2}{RequiredWidth} = 147.83;
$TextData2{2}{RequiredHeight} = 10;
$TextData2{2}{LeftOver} = 'STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{2}{PositionReturnX} = 40;
$TextData2{2}{PositionReturnY} = 56;

# positiontest3
$TextData2{3}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{3}{Type} = 'ReturnLeftOver';
$TextData2{3}{Width} = 150;
$TextData2{3}{Position1X} = 'left';
$TextData2{3}{Position1Y} = 'bottom';
$TextData2{3}{Position2Y} = 11;
$TextData2{3}{State} = 0;
$TextData2{3}{RequiredWidth} = 147.83;
$TextData2{3}{RequiredHeight} = 10;
$TextData2{3}{LeftOver} = 'STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{3}{PositionReturnX} = 40;
$TextData2{3}{PositionReturnY} = 57;

# positiontest4
$TextData2{4}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{4}{Type} = 'ReturnLeftOver';
$TextData2{4}{Width} = 30;
$TextData2{4}{Position1X} = 'left';
$TextData2{4}{Position1Y} = 'bottom';
$TextData2{4}{Position2Y} = 39;
$TextData2{4}{State} = 0;
$TextData2{4}{RequiredWidth} = 28.89;
$TextData2{4}{RequiredHeight} = 30;
$TextData2{4}{LeftOver} = 'Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{4}{PositionReturnX} = 40;
$TextData2{4}{PositionReturnY} = 65;

# positiontest5
$TextData2{5}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{5}{Type} = 'ReturnLeftOver';
$TextData2{5}{Width} = 100;
$TextData2{5}{Lead} = 7;
$TextData2{5}{Position1X} = 'left';
$TextData2{5}{Position1Y} = 'bottom';
$TextData2{5}{Position2Y} = 25;
$TextData2{5}{State} = 0;
$TextData2{5}{RequiredWidth} = 76.7;
$TextData2{5}{RequiredHeight} = 10;
$TextData2{5}{LeftOver} = 'Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{5}{PositionReturnX} = 40;
$TextData2{5}{PositionReturnY} = 71;

# positiontest6
$TextData2{6}{Text} = 'Kommandant der Shuttle-Mission STS-122 wird ein Veteran der NASA, Navy Commander Stephen Frick, sein.';
$TextData2{6}{Type} = 'ReturnLeftOver';
$TextData2{6}{Width} = 105;
$TextData2{6}{Lead} = 9;
$TextData2{6}{State} = 1;
$TextData2{6}{RequiredWidth} = 88.37;
$TextData2{6}{RequiredHeight} = 105;
$TextData2{6}{LeftOver} = '';
$TextData2{6}{PositionReturnX} = 421;
$TextData2{6}{PositionReturnY} = 188.5;

# start testing Text()
foreach (sort keys %TextData2) {
    my $Test = $_;
    my $TestOk = 0;

    $TextData2{$Test}{Position1X} = $TextData2{$Test}{Position1X} || 'center';
    $TextData2{$Test}{Position1Y} = $TextData2{$Test}{Position1Y} || 'middle';
    $TextData2{$Test}{Position2X} = $TextData2{$Test}{Position2X} || 0;
    $TextData2{$Test}{Position2Y} = $TextData2{$Test}{Position2Y} || 0;
    $TextData2{$Test}{Font} = $TextData2{$Test}{Font} || 'Helvetica';
    $TextData2{$Test}{FontSize} = $TextData2{$Test}{FontSize} || 10;
    $TextData2{$Test}{Type} = $TextData2{$Test}{Type} || 'ReturnLeftOver';
    $TextData2{$Test}{Lead} = $TextData2{$Test}{Lead} || 0;
    $TextData2{$Test}{PositionReturnX} = $TextData2{$Test}{PositionReturnX} || 0;
    $TextData2{$Test}{PositionReturnY} = $TextData2{$Test}{PositionReturnY} || 0;

    if (!defined($TextData2{$Test}{Width})) {
        $TextData2{$Test}{Width} = 100;
    }

    $Self->{PDFObject}->PositionSet(
        X => $TextData2{$Test}{Position1X},
        Y => $TextData2{$Test}{Position1Y},
    );
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        X => $TextData2{$Test}{Position2X},
        Y => $TextData2{$Test}{Position2Y},
    );

    my %Return = $Self->{PDFObject}->Text(
        Text => $TextData2{$Test}{Text},
        Width => $TextData2{$Test}{Width},
        Font => $TextData2{$Test}{Font},
        FontSize  => $TextData2{$Test}{FontSize},
        Type => $TextData2{$Test}{Type},
        Lead => $TextData2{$Test}{Lead},
    );

    my %Position = $Self->{PDFObject}->PositionGet();

    if ($Return{State} eq $TextData2{$Test}{State} &&
        $Return{RequiredWidth} eq $TextData2{$Test}{RequiredWidth} &&
        $Return{RequiredHeight} eq $TextData2{$Test}{RequiredHeight} &&
        $Return{LeftOver} eq $TextData2{$Test}{LeftOver} &&
        $Position{X} eq $TextData2{$Test}{PositionReturnX} &&
        $Position{Y} eq $TextData2{$Test}{PositionReturnY}
    ) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR Text$Test (Position) State -->$Return{State}\n";
        print "ERROR Text$Test (Position) RequiredWidth -->$Return{RequiredWidth}\n";
        print "ERROR Text$Test (Position) RequiredHeight -->$Return{RequiredHeight}\n";
        print "ERROR Text$Test (Position) LeftOver -->$Return{LeftOver}<--\n";
        print "ERROR Text$Test (Position) Position X -->$Position{X}<--\n";
        print "ERROR Text$Test (Position) Position Y -->$Position{Y}<--\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "Text$Test() (Position)",
    );
}

# _TableCalculate() tests
my %TableCalculate;

# tablecalculatetest0
$TableCalculate{0}{FontColorEven} = '#101010';
$TableCalculate{0}{BackgroundColor} = 'red';

$TableCalculate{0}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableCalculate{0}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableCalculate{0}{CellData}[0][1]{BackgroundColor} = 'blue';
$TableCalculate{0}{CellData}[0][1]{Lead} = 3;
$TableCalculate{0}{CellData}[1][0]{Content} = 'Zelle 2-1 (Reihe 2)';
$TableCalculate{0}{CellData}[1][1]{Content} = '';
$TableCalculate{0}{CellData}[1][1]{Align} = 'center';

$TableCalculate{0}{ReturnCellData}[0][0]{Content} = 'Zelle 1-1';
$TableCalculate{0}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[0][0]{FontColor} = '#101010';
$TableCalculate{0}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[0][0]{BackgroundColor} = 'red';
$TableCalculate{0}{ReturnCellData}[0][1]{Content} = 'Zelle 1-2';
$TableCalculate{0}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[0][1]{FontColor} = '#101010';
$TableCalculate{0}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[0][1]{Lead} = 3;
$TableCalculate{0}{ReturnCellData}[0][1]{BackgroundColor} = 'blue';
$TableCalculate{0}{ReturnCellData}[1][0]{Content} = 'Zelle 2-1 (Reihe 2)';
$TableCalculate{0}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{0}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[1][0]{BackgroundColor} = 'red';
$TableCalculate{0}{ReturnCellData}[1][1]{Content} = ' ';
$TableCalculate{0}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{0}{ReturnCellData}[1][1]{Align} = 'center';
$TableCalculate{0}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[1][1]{BackgroundColor} = 'red';

$TableCalculate{0}{ReturnColumnData}[0]{Width} = 57.125;
$TableCalculate{0}{ReturnColumnData}[1]{Width} = 31.285;

# start testing Text()
foreach (sort keys %TableCalculate) {
    my $Test = $_;
    my $TestOk = 0;

    my %TableCalculateParams;
    $TableCalculateParams{CellData} = $TableCalculate{$Test}{CellData};
    $TableCalculateParams{ColumnData} = $TableCalculate{$Test}{ColumnData} || [];
    $TableCalculateParams{Width} = $TableCalculate{$Test}{Width} || 500;
    $TableCalculateParams{Height} = $TableCalculate{$Test}{Height} || 500;
    $TableCalculateParams{Font} = $TableCalculate{$Test}{Font} || 'Helvetica';
    $TableCalculateParams{FontSize} = $TableCalculate{$Test}{FontSize} || 10;
    $TableCalculateParams{FontColor} = $TableCalculate{$Test}{FontColor} || 'black';
    $TableCalculateParams{Align} = $TableCalculate{$Test}{Align} || 'left';
    $TableCalculateParams{Lead} = $TableCalculate{$Test}{Lead} || 0;
    $TableCalculateParams{BackgroundColor} = $TableCalculate{$Test}{BackgroundColor} || 'NULL';
    $TableCalculateParams{PaddingLeft} = $TableCalculate{$Test}{PaddingLeft} || 0;
    $TableCalculateParams{PaddingRight} = $TableCalculate{$Test}{PaddingRight} || 0;
    $TableCalculateParams{PaddingTop} = $TableCalculate{$Test}{PaddingTop} || 0;
    $TableCalculateParams{PaddingBottom} = $TableCalculate{$Test}{PaddingBottom} || 0;
    $TableCalculateParams{Border} = $TableCalculate{$Test}{Border} || 1;
    $TableCalculateParams{BorderColor} = $TableCalculate{$Test}{BorderColor} || 'black';
    if (defined($TableCalculate{$Test}{FontColorOdd})) {
        $TableCalculateParams{FontColorOdd} = $TableCalculate{$Test}{FontColorOdd};
    }
    if (defined($TableCalculate{$Test}{FontColorEven})) {
        $TableCalculateParams{FontColorEven} = $TableCalculate{$Test}{FontColorEven};
    }
    if (defined($TableCalculate{$Test}{BackgroundColorOdd})) {
        $TableCalculateParams{BackgroundColorOdd} = $TableCalculate{$Test}{BackgroundColorOdd};
    }
    if (defined($TableCalculate{$Test}{BackgroundColorEven})) {
        $TableCalculateParams{BackgroundColorEven} = $TableCalculate{$Test}{BackgroundColorEven};
    }

    my %Return = $Self->{PDFObject}->_TableCalculate(
        %TableCalculateParams,
    );

    my $TestColumnOk = 0;
    my $CounterRow = 0;
    my $CounterColumn = 0;
    my $CounterCellRow = 0;
    my $CounterCellColumn = 0;

    # ceck returned ColumnData
    foreach my $Column (@{$TableCalculate{$Test}{ReturnColumnData}}) {
        if ($Return{ColumnData}->[$CounterColumn]->{Width} eq $Column->{Width}) {
            $TestColumnOk = 1;
        }
        else {
            print "\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn Width -->$Return{ColumnData}->[$CounterColumn]->{Width}\n";
            print "\n";

            $TestColumnOk = 0;
            last;
        }

        $CounterColumn++;
    }
    # check returned CellData
    if ($TestColumnOk) {
        my $CounterCellRow = 0;
        foreach my $Row (@{$TableCalculate{$Test}{ReturnCellData}}) {
            my $CounterCellColumn = 0;
            foreach my $Cell (@{$TableCalculate{$Test}{ReturnCellData}[$CounterCellRow]}) {
                if ($Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Content} eq $Cell->{Content} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Font} eq $Cell->{Font} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{FontSize} eq $Cell->{FontSize} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{FontColor} eq $Cell->{FontColor} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Align} eq $Cell->{Align} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Lead} eq $Cell->{Lead} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{BackgroundColor} eq $Cell->{BackgroundColor}
                ) {
                    $TestOk = 1;
                }
                else {
                    print "\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn Content -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Content}<--\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn Font -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Font}\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn FontSize -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{FontSize}\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn FontColor -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{FontColor}\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn Align -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Align}\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn Lead -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Lead}\n";
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn BackgroundColor -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{BackgroundColor}\n";
                    print "\n";

                    $TestOk = 0;
                    last;
                }
                $CounterCellColumn++;
            }
            $CounterCellRow++;
            if (!$TestOk) {
                last;
            }
        }
    }

    $Self->True(
        $TestOk,
        "_TableCalculate$Test()",
    );
}

1;
