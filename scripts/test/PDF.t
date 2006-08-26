# --
# PDF.t - PDF tests
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: PDF.t,v 1.6 2006-08-26 17:36:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::PDF;

$Self->{PDFObject} = Kernel::System::PDF->new(%{$Self});
if (!$Self->{PDFObject}) {
    return;
}

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

# test14
$TextCalculateData{14}{Text} = 'ISS - International Space Station';
$TextCalculateData{14}{Type} = 'ReturnLeftOver';
$TextCalculateData{14}{Width} = 1,
$TextCalculateData{14}{Height} = 10000,
$TextCalculateData{14}{State} = 0;
$TextCalculateData{14}{RequiredWidth} = 0;
$TextCalculateData{14}{RequiredHeight} = 0;
$TextCalculateData{14}{LeftOver} = 'ISS - International Space Station';

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
$TableCalculate{0}{Type} = 'Cut';
$TableCalculate{0}{Border} = 1;

$TableCalculate{0}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableCalculate{0}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableCalculate{0}{CellData}[0][1]{BackgroundColor} = 'blue';
$TableCalculate{0}{CellData}[0][1]{Type} = 'ReturnLeftOverHard';
$TableCalculate{0}{CellData}[0][1]{Lead} = 3;
$TableCalculate{0}{CellData}[1][0]{Content} = 'Zelle 2-1 (Reihe 2)';
$TableCalculate{0}{CellData}[1][1]{Content} = '';
$TableCalculate{0}{CellData}[1][1]{Align} = 'center';

$TableCalculate{0}{ReturnCellData}[0][0]{Content} = 'Zelle 1-1';
$TableCalculate{0}{ReturnCellData}[0][0]{Type} = 'Cut';
$TableCalculate{0}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[0][0]{FontColor} = '#101010';
$TableCalculate{0}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[0][0]{BackgroundColor} = 'red';
$TableCalculate{0}{ReturnCellData}[0][1]{Content} = 'Zelle 1-2';
$TableCalculate{0}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOverHard';
$TableCalculate{0}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[0][1]{FontColor} = '#101010';
$TableCalculate{0}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[0][1]{Lead} = 3;
$TableCalculate{0}{ReturnCellData}[0][1]{BackgroundColor} = 'blue';
$TableCalculate{0}{ReturnCellData}[1][0]{Content} = 'Zelle 2-1 (Reihe 2)';
$TableCalculate{0}{ReturnCellData}[1][0]{Type} = 'Cut';
$TableCalculate{0}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{0}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{0}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[1][0]{BackgroundColor} = 'red';
$TableCalculate{0}{ReturnCellData}[1][1]{Content} = ' ';
$TableCalculate{0}{ReturnCellData}[1][1]{Type} = 'Cut';
$TableCalculate{0}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{0}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{0}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{0}{ReturnCellData}[1][1]{Align} = 'center';
$TableCalculate{0}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{0}{ReturnCellData}[1][1]{BackgroundColor} = 'red';

$TableCalculate{0}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{0}{ReturnColumnData}[0]{EstimateWidth} = 56.125;
$TableCalculate{0}{ReturnColumnData}[0]{TextWidth} = 261.42;
$TableCalculate{0}{ReturnColumnData}[0]{OutputWidth} = 263.42;
$TableCalculate{0}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{0}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{0}{ReturnColumnData}[1]{EstimateWidth} = 30.285;
$TableCalculate{0}{ReturnColumnData}[1]{TextWidth} = 235.58;
$TableCalculate{0}{ReturnColumnData}[1]{OutputWidth} = 237.58;
$TableCalculate{0}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{0}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{0}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest1
$TableCalculate{1}{Width} = 300;
$TableCalculate{1}{Border} = 1;

$TableCalculate{1}{CellData}[0][0]{Content} = "Welcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n    Manage your communication!";
$TableCalculate{1}{CellData}[0][1]{Content} = "\nWelcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n\tManage your communication!\n";
$TableCalculate{1}{CellData}[1][0]{Content} = "\tWelcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n    Manage your communication!\n\t";
$TableCalculate{1}{CellData}[1][1]{Content} = "\r\r\nWelcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\rYour OTRS Team\n\n    Manage your communication!\r\n";

$TableCalculate{1}{ReturnCellData}[0][0]{Content} = "Welcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n    Manage your communication!";
$TableCalculate{1}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{1}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{1}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{1}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{1}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{1}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{1}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{1}{ReturnCellData}[0][1]{Content} = "\nWelcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n  Manage your communication!\n";
$TableCalculate{1}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{1}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{1}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{1}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{1}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{1}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{1}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{1}{ReturnCellData}[1][0]{Content} = "  Welcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\n\n\nYour OTRS Team\n\n    Manage your communication!\n  ";
$TableCalculate{1}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{1}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{1}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{1}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{1}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{1}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{1}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{1}{ReturnCellData}[1][1]{Content} = "\nWelcome to OTRS!\n\nthank you for installing OTRS.\n\nYou will find updates and patches at http://otrs.org/. Online\ndocumentation is available at http://doc.otrs.org/. You can also\ntake advantage of our mailing lists http://lists.otrs.org/.\nYour OTRS Team\n\n    Manage your communication!\n";
$TableCalculate{1}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{1}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{1}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{1}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{1}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{1}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{1}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{1}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{1}{ReturnColumnData}[0]{EstimateWidth} = 298;
$TableCalculate{1}{ReturnColumnData}[0]{TextWidth} = 298;
$TableCalculate{1}{ReturnColumnData}[0]{OutputWidth} = 300;
$TableCalculate{1}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{1}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{1}{ReturnColumnData}[1]{EstimateWidth} = 298;
$TableCalculate{1}{ReturnColumnData}[1]{TextWidth} = 298;
$TableCalculate{1}{ReturnColumnData}[1]{OutputWidth} = 300;
$TableCalculate{1}{ReturnColumnData}[1]{Block} = 1;

$TableCalculate{1}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{1}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest2
$TableCalculate{2}{Width} = 300;
$TableCalculate{2}{Border} = 1;

$TableCalculate{2}{CellData}[0][0]{Content} = "\n";
$TableCalculate{2}{CellData}[0][1]{Content} = "\t ";
$TableCalculate{2}{CellData}[1][0]{Content} = "\t\f";
$TableCalculate{2}{CellData}[1][1]{Content} = "\t\n\r\f\r\r\n";

$TableCalculate{2}{ReturnCellData}[0][0]{Content} = "\n";
$TableCalculate{2}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{2}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{2}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{2}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{2}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{2}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{2}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{2}{ReturnCellData}[0][1]{Content} = "   ";
$TableCalculate{2}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{2}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{2}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{2}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{2}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{2}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{2}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{2}{ReturnCellData}[1][0]{Content} = "  \n\n";
$TableCalculate{2}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{2}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{2}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{2}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{2}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{2}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{2}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{2}{ReturnCellData}[1][1]{Content} = "  \n\n\n\n";
$TableCalculate{2}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{2}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{2}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{2}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{2}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{2}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{2}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{2}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{2}{ReturnColumnData}[0]{EstimateWidth} = 6.11;
$TableCalculate{2}{ReturnColumnData}[0]{TextWidth} = 146.835;
$TableCalculate{2}{ReturnColumnData}[0]{OutputWidth} = 148.835;
$TableCalculate{2}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{2}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{2}{ReturnColumnData}[1]{EstimateWidth} = 9.44;
$TableCalculate{2}{ReturnColumnData}[1]{TextWidth} = 150.165;
$TableCalculate{2}{ReturnColumnData}[1]{OutputWidth} = 152.165;
$TableCalculate{2}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{2}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{2}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest3
$TableCalculate{3}{Width} = 300;
$TableCalculate{3}{Border} = 1;

$TableCalculate{3}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{3}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{3}{CellData}[1][0]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{3}{CellData}[1][1]{Content} = "ISS";

$TableCalculate{3}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{3}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{3}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{3}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{3}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{3}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{3}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{3}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{3}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{3}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{3}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{3}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{3}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{3}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{3}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{3}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{3}{ReturnCellData}[1][0]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{3}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{3}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{3}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{3}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{3}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{3}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{3}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{3}{ReturnCellData}[1][1]{Content} = "ISS";
$TableCalculate{3}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{3}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{3}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{3}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{3}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{3}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{3}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{3}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{3}{ReturnColumnData}[0]{EstimateWidth} = 298;
$TableCalculate{3}{ReturnColumnData}[0]{TextWidth} = 298;
$TableCalculate{3}{ReturnColumnData}[0]{OutputWidth} = 300;
$TableCalculate{3}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{3}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{3}{ReturnColumnData}[1]{EstimateWidth} = 298;
$TableCalculate{3}{ReturnColumnData}[1]{TextWidth} = 298;
$TableCalculate{3}{ReturnColumnData}[1]{OutputWidth} = 300;
$TableCalculate{3}{ReturnColumnData}[1]{Block} = 1;

$TableCalculate{3}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{3}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest4
$TableCalculate{4}{Width} = 1;
$TableCalculate{4}{PaddingLeft} = 5;
$TableCalculate{4}{PaddingRight} = 5;
$TableCalculate{4}{Border} = 2;

$TableCalculate{4}{CellData}[0][0]{Content} = "ISS - International Space Station";

$TableCalculate{4}{ReturnCellData}[0][0]{Content} = "ISS - International Space Station";
$TableCalculate{4}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{4}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{4}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{4}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{4}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{4}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{4}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';

$TableCalculate{4}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{4}{ReturnColumnData}[0]{EstimateWidth} = 1;
$TableCalculate{4}{ReturnColumnData}[0]{TextWidth} = 1;
$TableCalculate{4}{ReturnColumnData}[0]{OutputWidth} = 1;
$TableCalculate{4}{ReturnColumnData}[0]{Block} = 0;

$TableCalculate{4}{ReturnRowData}[0]{MinFontSize} = 10;

# tablecalculatetest5
$TableCalculate{5}{Width} = 300;
$TableCalculate{5}{Border} = 1;

$TableCalculate{5}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{5}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{5}{CellData}[1][0]{Content} = "ISS";
$TableCalculate{5}{CellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";

$TableCalculate{5}{ColumnData}[1]{Width} = 103;

$TableCalculate{5}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{5}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{5}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{5}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{5}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{5}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{5}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{5}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{5}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{5}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{5}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{5}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{5}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{5}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{5}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{5}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{5}{ReturnCellData}[1][0]{Content} = "ISS";
$TableCalculate{5}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{5}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{5}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{5}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{5}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{5}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{5}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{5}{ReturnCellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{5}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{5}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{5}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{5}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{5}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{5}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{5}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{5}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{5}{ReturnColumnData}[0]{EstimateWidth} = 16.12;
$TableCalculate{5}{ReturnColumnData}[0]{TextWidth} = 194;
$TableCalculate{5}{ReturnColumnData}[0]{OutputWidth} = 196;
$TableCalculate{5}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{5}{ReturnColumnData}[1]{Width} = 103;
$TableCalculate{5}{ReturnColumnData}[1]{EstimateWidth} = 103;
$TableCalculate{5}{ReturnColumnData}[1]{TextWidth} = 103;
$TableCalculate{5}{ReturnColumnData}[1]{OutputWidth} = 105;
$TableCalculate{5}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{5}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{5}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest6
$TableCalculate{6}{Width} = 1;
$TableCalculate{6}{Border} = 0;

$TableCalculate{6}{CellData}[0][0]{Content} = "ISS";

$TableCalculate{6}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{6}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{6}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{6}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{6}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{6}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{6}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{6}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';

$TableCalculate{6}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{6}{ReturnColumnData}[0]{EstimateWidth} = 1;
$TableCalculate{6}{ReturnColumnData}[0]{TextWidth} = 1;
$TableCalculate{6}{ReturnColumnData}[0]{OutputWidth} = 1;
$TableCalculate{6}{ReturnColumnData}[0]{Block} = 0;

$TableCalculate{6}{ReturnRowData}[0]{MinFontSize} = 10;

# tablecalculatetest7
$TableCalculate{7}{Width} = 300;
$TableCalculate{7}{Border} = 1;

$TableCalculate{7}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{7}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{7}{CellData}[1][0]{Content} = "ISS";
$TableCalculate{7}{CellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";

$TableCalculate{7}{ColumnData}[1]{Width} = 100;

$TableCalculate{7}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{7}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{7}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{7}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{7}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{7}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{7}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{7}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{7}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{7}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{7}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{7}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{7}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{7}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{7}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{7}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{7}{ReturnCellData}[1][0]{Content} = "ISS";
$TableCalculate{7}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{7}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{7}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{7}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{7}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{7}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{7}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{7}{ReturnCellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{7}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{7}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{7}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{7}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{7}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{7}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{7}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{7}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{7}{ReturnColumnData}[0]{EstimateWidth} = 16.12;
$TableCalculate{7}{ReturnColumnData}[0]{TextWidth} = 197;
$TableCalculate{7}{ReturnColumnData}[0]{OutputWidth} = 199;
$TableCalculate{7}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{7}{ReturnColumnData}[1]{Width} = 100;
$TableCalculate{7}{ReturnColumnData}[1]{EstimateWidth} = 100;
$TableCalculate{7}{ReturnColumnData}[1]{TextWidth} = 100;
$TableCalculate{7}{ReturnColumnData}[1]{OutputWidth} = 102;
$TableCalculate{7}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{7}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{7}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest8
$TableCalculate{8}{Width} = 300;
$TableCalculate{8}{Border} = 1;

$TableCalculate{8}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{8}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{8}{CellData}[1][0]{Content} = "ISS";
$TableCalculate{8}{CellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";

$TableCalculate{8}{ColumnData}[0]{Width} = 70;
$TableCalculate{8}{ColumnData}[1]{Width} = 130;

$TableCalculate{8}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{8}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{8}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{8}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{8}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{8}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{8}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{8}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{8}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{8}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{8}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{8}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{8}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{8}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{8}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{8}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{8}{ReturnCellData}[1][0]{Content} = "ISS";
$TableCalculate{8}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{8}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{8}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{8}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{8}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{8}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{8}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{8}{ReturnCellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{8}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{8}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{8}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{8}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{8}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{8}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{8}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{8}{ReturnColumnData}[0]{Width} = 70;
$TableCalculate{8}{ReturnColumnData}[0]{EstimateWidth} = 70;
$TableCalculate{8}{ReturnColumnData}[0]{TextWidth} = 118.5;
$TableCalculate{8}{ReturnColumnData}[0]{OutputWidth} = 120.5;
$TableCalculate{8}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{8}{ReturnColumnData}[1]{Width} = 130;
$TableCalculate{8}{ReturnColumnData}[1]{EstimateWidth} = 130;
$TableCalculate{8}{ReturnColumnData}[1]{TextWidth} = 178.5;
$TableCalculate{8}{ReturnColumnData}[1]{OutputWidth} = 180.5;
$TableCalculate{8}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{8}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{8}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest9
$TableCalculate{9}{Width} = 300;
$TableCalculate{9}{Border} = 1;

$TableCalculate{9}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{9}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{9}{CellData}[1][0]{Content} = "ISS";
$TableCalculate{9}{CellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";

$TableCalculate{9}{ColumnData}[0]{Width} = 330;
$TableCalculate{9}{ColumnData}[1]{Width} = 105;

$TableCalculate{9}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{9}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{9}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{9}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{9}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{9}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{9}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{9}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{9}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{9}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{9}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{9}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{9}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{9}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{9}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{9}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{9}{ReturnCellData}[1][0]{Content} = "ISS";
$TableCalculate{9}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{9}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{9}{ReturnCellData}[1][0]{FontSize} = 10;
$TableCalculate{9}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{9}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{9}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{9}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{9}{ReturnCellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{9}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{9}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{9}{ReturnCellData}[1][1]{FontSize} = 10;
$TableCalculate{9}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{9}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{9}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{9}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{9}{ReturnColumnData}[0]{Width} = 298;
$TableCalculate{9}{ReturnColumnData}[0]{EstimateWidth} = 298;
$TableCalculate{9}{ReturnColumnData}[0]{TextWidth} = 298;
$TableCalculate{9}{ReturnColumnData}[0]{OutputWidth} = 300;
$TableCalculate{9}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{9}{ReturnColumnData}[1]{Width} = 105;
$TableCalculate{9}{ReturnColumnData}[1]{EstimateWidth} = 105;
$TableCalculate{9}{ReturnColumnData}[1]{TextWidth} = 105;
$TableCalculate{9}{ReturnColumnData}[1]{OutputWidth} = 107;
$TableCalculate{9}{ReturnColumnData}[1]{Block} = 1;

$TableCalculate{9}{ReturnRowData}[0]{MinFontSize} = 10;
$TableCalculate{9}{ReturnRowData}[1]{MinFontSize} = 10;

# tablecalculatetest10
$TableCalculate{10}{Width} = 300;
$TableCalculate{10}{Border} = 1;

$TableCalculate{10}{CellData}[0][0]{Content} = "Columbia";
$TableCalculate{10}{CellData}[0][1]{Content} = "Challenger";
$TableCalculate{10}{CellData}[0][2]{Content} = "Discovery";
$TableCalculate{10}{CellData}[0][3]{Content} = "Atlantis";
$TableCalculate{10}{CellData}[0][4]{Content} = "Endeavour";

$TableCalculate{10}{ReturnCellData}[0][0]{Content} = "Columbia";
$TableCalculate{10}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{10}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{10}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{10}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{10}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{10}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{10}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{10}{ReturnCellData}[0][1]{Content} = "Challenger";
$TableCalculate{10}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{10}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{10}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{10}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{10}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{10}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{10}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{10}{ReturnCellData}[0][2]{Content} = "Discovery";
$TableCalculate{10}{ReturnCellData}[0][2]{Type} = 'ReturnLeftOver';
$TableCalculate{10}{ReturnCellData}[0][2]{Font} = 'Helvetica';
$TableCalculate{10}{ReturnCellData}[0][2]{FontSize} = 10;
$TableCalculate{10}{ReturnCellData}[0][2]{FontColor} = 'black';
$TableCalculate{10}{ReturnCellData}[0][2]{Align} = 'left';
$TableCalculate{10}{ReturnCellData}[0][2]{Lead} = 0;
$TableCalculate{10}{ReturnCellData}[0][2]{BackgroundColor} = 'NULL';
$TableCalculate{10}{ReturnCellData}[0][3]{Content} = "Atlantis";
$TableCalculate{10}{ReturnCellData}[0][3]{Type} = 'ReturnLeftOver';
$TableCalculate{10}{ReturnCellData}[0][3]{Font} = 'Helvetica';
$TableCalculate{10}{ReturnCellData}[0][3]{FontSize} = 10;
$TableCalculate{10}{ReturnCellData}[0][3]{FontColor} = 'black';
$TableCalculate{10}{ReturnCellData}[0][3]{Align} = 'left';
$TableCalculate{10}{ReturnCellData}[0][3]{Lead} = 0;
$TableCalculate{10}{ReturnCellData}[0][3]{BackgroundColor} = 'NULL';
$TableCalculate{10}{ReturnCellData}[0][4]{Content} = "Endeavour";
$TableCalculate{10}{ReturnCellData}[0][4]{Type} = 'ReturnLeftOver';
$TableCalculate{10}{ReturnCellData}[0][4]{Font} = 'Helvetica';
$TableCalculate{10}{ReturnCellData}[0][4]{FontSize} = 10;
$TableCalculate{10}{ReturnCellData}[0][4]{FontColor} = 'black';
$TableCalculate{10}{ReturnCellData}[0][4]{Align} = 'left';
$TableCalculate{10}{ReturnCellData}[0][4]{Lead} = 0;
$TableCalculate{10}{ReturnCellData}[0][4]{BackgroundColor} = 'NULL';

$TableCalculate{10}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{10}{ReturnColumnData}[0]{EstimateWidth} = 42.23;
$TableCalculate{10}{ReturnColumnData}[0]{TextWidth} = 57.906;
$TableCalculate{10}{ReturnColumnData}[0]{OutputWidth} = 59.906;
$TableCalculate{10}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{10}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{10}{ReturnColumnData}[1]{EstimateWidth} = 48.35;
$TableCalculate{10}{ReturnColumnData}[1]{TextWidth} = 64.026;
$TableCalculate{10}{ReturnColumnData}[1]{OutputWidth} = 66.026;
$TableCalculate{10}{ReturnColumnData}[1]{Block} = 0;
$TableCalculate{10}{ReturnColumnData}[2]{Width} = 0;
$TableCalculate{10}{ReturnColumnData}[2]{EstimateWidth} = 43.89;
$TableCalculate{10}{ReturnColumnData}[2]{TextWidth} = 59.566;
$TableCalculate{10}{ReturnColumnData}[2]{OutputWidth} = 61.566;
$TableCalculate{10}{ReturnColumnData}[2]{Block} = 0;
$TableCalculate{10}{ReturnColumnData}[3]{Width} = 0;
$TableCalculate{10}{ReturnColumnData}[3]{EstimateWidth} = 32.79;
$TableCalculate{10}{ReturnColumnData}[3]{TextWidth} = 48.466;
$TableCalculate{10}{ReturnColumnData}[3]{OutputWidth} = 50.466;
$TableCalculate{10}{ReturnColumnData}[3]{Block} = 0;
$TableCalculate{10}{ReturnColumnData}[4]{Width} = 0;
$TableCalculate{10}{ReturnColumnData}[4]{EstimateWidth} = 48.36;
$TableCalculate{10}{ReturnColumnData}[4]{TextWidth} = 64.036;
$TableCalculate{10}{ReturnColumnData}[4]{OutputWidth} = 66.036;
$TableCalculate{10}{ReturnColumnData}[4]{Block} = 0;

$TableCalculate{10}{ReturnRowData}[0]{MinFontSize} = 10;

# tablecalculatetest11
$TableCalculate{11}{Width} = 300;
$TableCalculate{11}{Border} = 5;
$TableCalculate{11}{PaddingRight} = 10;
$TableCalculate{11}{PaddingLeft} = 10;

$TableCalculate{11}{CellData}[0][0]{Content} = "Columbus";
$TableCalculate{11}{CellData}[0][1]{Content} = "Destiny";

$TableCalculate{11}{ReturnCellData}[0][0]{Content} = "Columbus";
$TableCalculate{11}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{11}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{11}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{11}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{11}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{11}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{11}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{11}{ReturnCellData}[0][1]{Content} = "Destiny";
$TableCalculate{11}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{11}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{11}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{11}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{11}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{11}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{11}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';

$TableCalculate{11}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{11}{ReturnColumnData}[0]{EstimateWidth} = 45.01;
$TableCalculate{11}{ReturnColumnData}[0]{TextWidth} = 128.335;
$TableCalculate{11}{ReturnColumnData}[0]{OutputWidth} = 158.335;
$TableCalculate{11}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{11}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{11}{ReturnColumnData}[1]{EstimateWidth} = 33.34;
$TableCalculate{11}{ReturnColumnData}[1]{TextWidth} = 116.665;
$TableCalculate{11}{ReturnColumnData}[1]{OutputWidth} = 146.665;
$TableCalculate{11}{ReturnColumnData}[1]{Block} = 0;

$TableCalculate{11}{ReturnRowData}[0]{MinFontSize} = 10;

# tablecalculatetest12
$TableCalculate{12}{CellData}[0][0]{Content} = "ISS";
$TableCalculate{12}{CellData}[0][0]{FontSize} = 4;
$TableCalculate{12}{CellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{12}{CellData}[0][1]{FontSize} = 9;
$TableCalculate{12}{CellData}[1][0]{Content} = "ISS";
$TableCalculate{12}{CellData}[1][0]{FontSize} = 18;
$TableCalculate{12}{CellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{12}{CellData}[1][1]{FontSize} = 12;

$TableCalculate{12}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{12}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{12}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{12}{ReturnCellData}[0][0]{FontSize} = 4;
$TableCalculate{12}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{12}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{12}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{12}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{12}{ReturnCellData}[0][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{12}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{12}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{12}{ReturnCellData}[0][1]{FontSize} = 9;
$TableCalculate{12}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{12}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{12}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{12}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{12}{ReturnCellData}[1][0]{Content} = "ISS";
$TableCalculate{12}{ReturnCellData}[1][0]{Type} = 'ReturnLeftOver';
$TableCalculate{12}{ReturnCellData}[1][0]{Font} = 'Helvetica';
$TableCalculate{12}{ReturnCellData}[1][0]{FontSize} = 18;
$TableCalculate{12}{ReturnCellData}[1][0]{FontColor} = 'black';
$TableCalculate{12}{ReturnCellData}[1][0]{Align} = 'left';
$TableCalculate{12}{ReturnCellData}[1][0]{Lead} = 0;
$TableCalculate{12}{ReturnCellData}[1][0]{BackgroundColor} = 'NULL';
$TableCalculate{12}{ReturnCellData}[1][1]{Content} = "Der deutsche ESA-Astronaut und Mitglied der Expedition 13 auf der Internationalen Raumstation ISS Thomas Reiter ist seit letzter Woche der europäische Astronaut mit der längsten Aufenthaltszeit im Weltraum.";
$TableCalculate{12}{ReturnCellData}[1][1]{Type} = 'ReturnLeftOver';
$TableCalculate{12}{ReturnCellData}[1][1]{Font} = 'Helvetica';
$TableCalculate{12}{ReturnCellData}[1][1]{FontSize} = 12;
$TableCalculate{12}{ReturnCellData}[1][1]{FontColor} = 'black';
$TableCalculate{12}{ReturnCellData}[1][1]{Align} = 'left';
$TableCalculate{12}{ReturnCellData}[1][1]{Lead} = 0;
$TableCalculate{12}{ReturnCellData}[1][1]{BackgroundColor} = 'NULL';

$TableCalculate{12}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{12}{ReturnColumnData}[0]{EstimateWidth} = 29.016;
$TableCalculate{12}{ReturnColumnData}[0]{TextWidth} = 500;
$TableCalculate{12}{ReturnColumnData}[0]{OutputWidth} = 500;
$TableCalculate{12}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{12}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{12}{ReturnColumnData}[1]{EstimateWidth} = 500;
$TableCalculate{12}{ReturnColumnData}[1]{TextWidth} = 500;
$TableCalculate{12}{ReturnColumnData}[1]{OutputWidth} = 500;
$TableCalculate{12}{ReturnColumnData}[1]{Block} = 1;

$TableCalculate{12}{ReturnRowData}[0]{MinFontSize} = 4;
$TableCalculate{12}{ReturnRowData}[1]{MinFontSize} = 12;

# tablecalculatetest13
$TableCalculate{13}{Width} = 100;
$TableCalculate{13}{Border} = 1;

$TableCalculate{13}{CellData}[0][0]{Content} = "Columbia";
$TableCalculate{13}{CellData}[0][1]{Content} = "Challenger";
$TableCalculate{13}{CellData}[0][2]{Content} = "Discovery";
$TableCalculate{13}{CellData}[0][3]{Content} = "Atlantis";
$TableCalculate{13}{CellData}[0][4]{Content} = "Endeavour";

$TableCalculate{13}{ReturnCellData}[0][0]{Content} = "Columbia";
$TableCalculate{13}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{13}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{13}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{13}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{13}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{13}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{13}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';
$TableCalculate{13}{ReturnCellData}[0][1]{Content} = "Challenger";
$TableCalculate{13}{ReturnCellData}[0][1]{Type} = 'ReturnLeftOver';
$TableCalculate{13}{ReturnCellData}[0][1]{Font} = 'Helvetica';
$TableCalculate{13}{ReturnCellData}[0][1]{FontSize} = 10;
$TableCalculate{13}{ReturnCellData}[0][1]{FontColor} = 'black';
$TableCalculate{13}{ReturnCellData}[0][1]{Align} = 'left';
$TableCalculate{13}{ReturnCellData}[0][1]{Lead} = 0;
$TableCalculate{13}{ReturnCellData}[0][1]{BackgroundColor} = 'NULL';
$TableCalculate{13}{ReturnCellData}[0][2]{Content} = "Discovery";
$TableCalculate{13}{ReturnCellData}[0][2]{Type} = 'ReturnLeftOver';
$TableCalculate{13}{ReturnCellData}[0][2]{Font} = 'Helvetica';
$TableCalculate{13}{ReturnCellData}[0][2]{FontSize} = 10;
$TableCalculate{13}{ReturnCellData}[0][2]{FontColor} = 'black';
$TableCalculate{13}{ReturnCellData}[0][2]{Align} = 'left';
$TableCalculate{13}{ReturnCellData}[0][2]{Lead} = 0;
$TableCalculate{13}{ReturnCellData}[0][2]{BackgroundColor} = 'NULL';
$TableCalculate{13}{ReturnCellData}[0][3]{Content} = "Atlantis";
$TableCalculate{13}{ReturnCellData}[0][3]{Type} = 'ReturnLeftOver';
$TableCalculate{13}{ReturnCellData}[0][3]{Font} = 'Helvetica';
$TableCalculate{13}{ReturnCellData}[0][3]{FontSize} = 10;
$TableCalculate{13}{ReturnCellData}[0][3]{FontColor} = 'black';
$TableCalculate{13}{ReturnCellData}[0][3]{Align} = 'left';
$TableCalculate{13}{ReturnCellData}[0][3]{Lead} = 0;
$TableCalculate{13}{ReturnCellData}[0][3]{BackgroundColor} = 'NULL';
$TableCalculate{13}{ReturnCellData}[0][4]{Content} = "Endeavour";
$TableCalculate{13}{ReturnCellData}[0][4]{Type} = 'ReturnLeftOver';
$TableCalculate{13}{ReturnCellData}[0][4]{Font} = 'Helvetica';
$TableCalculate{13}{ReturnCellData}[0][4]{FontSize} = 10;
$TableCalculate{13}{ReturnCellData}[0][4]{FontColor} = 'black';
$TableCalculate{13}{ReturnCellData}[0][4]{Align} = 'left';
$TableCalculate{13}{ReturnCellData}[0][4]{Lead} = 0;
$TableCalculate{13}{ReturnCellData}[0][4]{BackgroundColor} = 'NULL';

$TableCalculate{13}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{13}{ReturnColumnData}[0]{EstimateWidth} = 42.23;
$TableCalculate{13}{ReturnColumnData}[0]{TextWidth} = 45.44;
$TableCalculate{13}{ReturnColumnData}[0]{OutputWidth} = 47.44;
$TableCalculate{13}{ReturnColumnData}[0]{Block} = 0;
$TableCalculate{13}{ReturnColumnData}[1]{Width} = 0;
$TableCalculate{13}{ReturnColumnData}[1]{EstimateWidth} = 48.35;
$TableCalculate{13}{ReturnColumnData}[1]{TextWidth} = 51.56;
$TableCalculate{13}{ReturnColumnData}[1]{OutputWidth} = 53.56;
$TableCalculate{13}{ReturnColumnData}[1]{Block} = 0;
$TableCalculate{13}{ReturnColumnData}[2]{Width} = 0;
$TableCalculate{13}{ReturnColumnData}[2]{EstimateWidth} = 43.89;
$TableCalculate{13}{ReturnColumnData}[2]{TextWidth} = 54.05;
$TableCalculate{13}{ReturnColumnData}[2]{OutputWidth} = 56.05;
$TableCalculate{13}{ReturnColumnData}[2]{Block} = 1;
$TableCalculate{13}{ReturnColumnData}[3]{Width} = 0;
$TableCalculate{13}{ReturnColumnData}[3]{EstimateWidth} = 32.79;
$TableCalculate{13}{ReturnColumnData}[3]{TextWidth} = 42.95;
$TableCalculate{13}{ReturnColumnData}[3]{OutputWidth} = 44.95;
$TableCalculate{13}{ReturnColumnData}[3]{Block} = 1;
$TableCalculate{13}{ReturnColumnData}[4]{Width} = 0;
$TableCalculate{13}{ReturnColumnData}[4]{EstimateWidth} = 48.36;
$TableCalculate{13}{ReturnColumnData}[4]{TextWidth} = 48.36;
$TableCalculate{13}{ReturnColumnData}[4]{OutputWidth} = 50.36;
$TableCalculate{13}{ReturnColumnData}[4]{Block} = 2;

$TableCalculate{13}{ReturnRowData}[0]{MinFontSize} = 10;

# tablecalculatetest14
$TableCalculate{14}{Width} = 400;
$TableCalculate{14}{Border} = 0;

$TableCalculate{14}{CellData}[0][0]{Content} = "ISS";

$TableCalculate{14}{ReturnCellData}[0][0]{Content} = "ISS";
$TableCalculate{14}{ReturnCellData}[0][0]{Type} = 'ReturnLeftOver';
$TableCalculate{14}{ReturnCellData}[0][0]{Font} = 'Helvetica';
$TableCalculate{14}{ReturnCellData}[0][0]{FontSize} = 10;
$TableCalculate{14}{ReturnCellData}[0][0]{FontColor} = 'black';
$TableCalculate{14}{ReturnCellData}[0][0]{Align} = 'left';
$TableCalculate{14}{ReturnCellData}[0][0]{Lead} = 0;
$TableCalculate{14}{ReturnCellData}[0][0]{BackgroundColor} = 'NULL';

$TableCalculate{14}{ReturnColumnData}[0]{Width} = 0;
$TableCalculate{14}{ReturnColumnData}[0]{EstimateWidth} = 16.12;
$TableCalculate{14}{ReturnColumnData}[0]{TextWidth} = 400;
$TableCalculate{14}{ReturnColumnData}[0]{OutputWidth} = 400;
$TableCalculate{14}{ReturnColumnData}[0]{Block} = 0;

$TableCalculate{14}{ReturnRowData}[0]{MinFontSize} = 10;

# start testing TableCalculate()
foreach (sort keys %TableCalculate) {
    my $Test = $_;
    my $TestOk = 0;

    my %TableCalculateParams;
    $TableCalculateParams{CellData} = $TableCalculate{$Test}{CellData};
    $TableCalculateParams{ColumnData} = $TableCalculate{$Test}{ColumnData} || [];
    $TableCalculateParams{RowData} = $TableCalculate{$Test}{RowData} || [];
    $TableCalculateParams{Type} = $TableCalculate{$Test}{Type} || 'ReturnLeftOver';
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
    $TableCalculateParams{Border} = $TableCalculate{$Test}{Border} || 0;
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

    # check returned ColumnData
    my $TestColumnOk = 0;
    my $CounterColumn = 0;
    foreach my $Column (@{$TableCalculate{$Test}{ReturnColumnData}}) {
        if ($Return{ColumnData}->[$CounterColumn]->{Width} eq $Column->{Width} &&
            $Return{ColumnData}->[$CounterColumn]->{EstimateWidth} eq $Column->{EstimateWidth} &&
            $Return{ColumnData}->[$CounterColumn]->{TextWidth} eq $Column->{TextWidth} &&
            $Return{ColumnData}->[$CounterColumn]->{OutputWidth} eq $Column->{OutputWidth} &&
            $Return{ColumnData}->[$CounterColumn]->{Block} eq $Column->{Block}
        ) {
            $TestColumnOk = 1;
        }
        else {
            print "\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn Width -->$Return{ColumnData}->[$CounterColumn]->{Width}\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn EstimateWidth -->$Return{ColumnData}->[$CounterColumn]->{EstimateWidth}\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn TextWidth -->$Return{ColumnData}->[$CounterColumn]->{TextWidth}\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn OutputWidth -->$Return{ColumnData}->[$CounterColumn]->{OutputWidth}\n";
            print "ERROR _TableCalculate$Test Column$CounterColumn Block -->$Return{ColumnData}->[$CounterColumn]->{Block}\n";
            print "\n";

            $TestColumnOk = 0;
            last;
        }

        $CounterColumn++;
    }
    # check returned RowData
    my $TestRowOk = 0;
    my $CounterRow = 0;
    if ($TestColumnOk) {
        foreach my $Row (@{$TableCalculate{$Test}{ReturnRowData}}) {
            if ($Return{RowData}->[$CounterRow]->{MinFontSize} eq $Row->{MinFontSize}) {
                $TestRowOk = 1;
            }
            else {
                print "\n";
                print "ERROR _TableCalculate$Test Row$CounterRow MinFontSize -->$Return{RowData}->[$CounterRow]->{MinFontSize}\n";
                print "\n";

                $TestRowOk = 0;
                last;
            }

            $CounterRow++;
        }
    }

    # check returned CellData
    if ($TestRowOk) {
        my $CounterCellRow = 0;
        foreach my $Row (@{$TableCalculate{$Test}{ReturnCellData}}) {
            my $CounterCellColumn = 0;
            foreach my $Cell (@{$TableCalculate{$Test}{ReturnCellData}[$CounterCellRow]}) {
                if ($Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Content} eq $Cell->{Content} &&
                    $Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Type} eq $Cell->{Type} &&
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
                    print "ERROR _TableCalculate$Test Cell$CounterCellRow-$CounterCellColumn Type -->$Return{CellData}->[$CounterCellRow]->[$CounterCellColumn]->{Type}\n";
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

# _TableBlockNextCalculate() tests
my %TableBlockNextCalculate;

# tableblocknextcalculatetest0
$TableBlockNextCalculate{0}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{0}{CellData}[0][0]{TmpOff} = 0;

$TableBlockNextCalculate{0}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{0}{State} = 1;
$TableBlockNextCalculate{0}{ReturnBlock} = 0;
$TableBlockNextCalculate{0}{ReturnRowStart} = 0;
$TableBlockNextCalculate{0}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{0}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest1
$TableBlockNextCalculate{1}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{1}{CellData}[0][0]{TmpOff} = 0;

$TableBlockNextCalculate{1}{ColumnData}[0][0]{Block} = 0;

$TableBlockNextCalculate{1}{State} = 0;
$TableBlockNextCalculate{1}{ReturnBlock} = 0;
$TableBlockNextCalculate{1}{ReturnRowStart} = 0;
$TableBlockNextCalculate{1}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{1}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest2
$TableBlockNextCalculate{2}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{2}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{2}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{2}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{2}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{2}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{2}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{2}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{2}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{2}{State} = 1;
$TableBlockNextCalculate{2}{ReturnBlock} = 0;
$TableBlockNextCalculate{2}{ReturnRowStart} = 0;
$TableBlockNextCalculate{2}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{2}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest3
$TableBlockNextCalculate{3}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{3}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{3}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{3}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{3}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{3}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{3}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{3}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{3}{ColumnData}[1]{Block} = 1;

$TableBlockNextCalculate{3}{State} = 1;
$TableBlockNextCalculate{3}{ReturnBlock} = 1;
$TableBlockNextCalculate{3}{ReturnRowStart} = 0;
$TableBlockNextCalculate{3}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{3}{ReturnColumnStop} = 1;

# tableblocknextcalculatetest4
$TableBlockNextCalculate{4}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{4}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{4}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{4}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{4}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{4}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{4}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{4}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{4}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{4}{State} = 1;
$TableBlockNextCalculate{4}{ReturnBlock} = 0;
$TableBlockNextCalculate{4}{ReturnRowStart} = 1;
$TableBlockNextCalculate{4}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{4}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest5
$TableBlockNextCalculate{5}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{5}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{5}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{5}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{5}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{5}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{5}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{5}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{5}{ColumnData}[1]{Block} = 1;

$TableBlockNextCalculate{5}{State} = 1;
$TableBlockNextCalculate{5}{ReturnBlock} = 1;
$TableBlockNextCalculate{5}{ReturnRowStart} = 1;
$TableBlockNextCalculate{5}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{5}{ReturnColumnStop} = 1;

# tableblocknextcalculatetest6
$TableBlockNextCalculate{6}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{6}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{6}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{6}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{6}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{6}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{6}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{6}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{6}{ColumnData}[1]{Block} = 1;

$TableBlockNextCalculate{6}{State} = 0;
$TableBlockNextCalculate{6}{ReturnBlock} = 0;
$TableBlockNextCalculate{6}{ReturnRowStart} = 0;
$TableBlockNextCalculate{6}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{6}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest7
$TableBlockNextCalculate{7}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[0][2]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[2][0]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{7}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{7}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{7}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{7}{State} = 1;
$TableBlockNextCalculate{7}{ReturnBlock} = 0;
$TableBlockNextCalculate{7}{ReturnRowStart} = 0;
$TableBlockNextCalculate{7}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{7}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest8
$TableBlockNextCalculate{8}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{8}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[0][2]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[2][0]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{8}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{8}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{8}{ColumnData}[1]{Block} = 1;
$TableBlockNextCalculate{8}{ColumnData}[2]{Block} = 1;

$TableBlockNextCalculate{8}{State} = 1;
$TableBlockNextCalculate{8}{ReturnBlock} = 1;
$TableBlockNextCalculate{8}{ReturnRowStart} = 0;
$TableBlockNextCalculate{8}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{8}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest9
$TableBlockNextCalculate{9}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{9}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{9}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[0][2]{Off} = 1;
$TableBlockNextCalculate{9}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{9}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{9}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{9}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[2][0]{Off} = 0;
$TableBlockNextCalculate{9}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{9}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{9}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{9}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{9}{ColumnData}[2]{Block} = 2;

$TableBlockNextCalculate{9}{State} = 1;
$TableBlockNextCalculate{9}{ReturnBlock} = 2;
$TableBlockNextCalculate{9}{ReturnRowStart} = 1;
$TableBlockNextCalculate{9}{ReturnColumnStart} = 2;
$TableBlockNextCalculate{9}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest10
$TableBlockNextCalculate{10}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[0][2]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[1][2]{Off} = 1;
$TableBlockNextCalculate{10}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[2][0]{Off} = 0;
$TableBlockNextCalculate{10}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{10}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{10}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{10}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{10}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{10}{State} = 1;
$TableBlockNextCalculate{10}{ReturnBlock} = 0;
$TableBlockNextCalculate{10}{ReturnRowStart} = 2;
$TableBlockNextCalculate{10}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{10}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest11
$TableBlockNextCalculate{11}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{11}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[0][2]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{11}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[2][0]{Off} = 1;
$TableBlockNextCalculate{11}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{11}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{11}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{11}{ColumnData}[1]{Block} = 1;
$TableBlockNextCalculate{11}{ColumnData}[2]{Block} = 1;

$TableBlockNextCalculate{11}{State} = 1;
$TableBlockNextCalculate{11}{ReturnBlock} = 1;
$TableBlockNextCalculate{11}{ReturnRowStart} = 0;
$TableBlockNextCalculate{11}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{11}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest12
$TableBlockNextCalculate{12}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[0][2]{Off} = 0;
$TableBlockNextCalculate{12}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{12}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[2][0]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[2][1]{Off} = 1;
$TableBlockNextCalculate{12}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{12}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{12}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{12}{ColumnData}[2]{Block} = 2;

$TableBlockNextCalculate{12}{State} = 1;
$TableBlockNextCalculate{12}{ReturnBlock} = 2;
$TableBlockNextCalculate{12}{ReturnRowStart} = 0;
$TableBlockNextCalculate{12}{ReturnColumnStart} = 2;
$TableBlockNextCalculate{12}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest13
$TableBlockNextCalculate{13}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{13}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{13}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[0][2]{Off} = 0;
$TableBlockNextCalculate{13}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{13}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{13}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{13}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[2][0]{Off} = 0;
$TableBlockNextCalculate{13}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{13}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{13}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{13}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{13}{ColumnData}[2]{Block} = 1;

$TableBlockNextCalculate{13}{State} = 1;
$TableBlockNextCalculate{13}{ReturnBlock} = 1;
$TableBlockNextCalculate{13}{ReturnRowStart} = 0;
$TableBlockNextCalculate{13}{ReturnColumnStart} = 2;
$TableBlockNextCalculate{13}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest14
$TableBlockNextCalculate{14}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{14}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{14}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[0][2]{Off} = 1;
$TableBlockNextCalculate{14}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{14}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{14}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[1][2]{Off} = 0;
$TableBlockNextCalculate{14}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[2][0]{Off} = 1;
$TableBlockNextCalculate{14}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[2][1]{Off} = 0;
$TableBlockNextCalculate{14}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{14}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{14}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{14}{ColumnData}[1]{Block} = 1;
$TableBlockNextCalculate{14}{ColumnData}[2]{Block} = 1;

$TableBlockNextCalculate{14}{State} = 1;
$TableBlockNextCalculate{14}{ReturnBlock} = 1;
$TableBlockNextCalculate{14}{ReturnRowStart} = 1;
$TableBlockNextCalculate{14}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{14}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest15
$TableBlockNextCalculate{15}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[0][2]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[1][2]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[2][0]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[2][1]{Off} = 1;
$TableBlockNextCalculate{15}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{15}{CellData}[2][2]{Off} = 0;
$TableBlockNextCalculate{15}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{15}{ColumnData}[2]{Block} = 2;

$TableBlockNextCalculate{15}{State} = 1;
$TableBlockNextCalculate{15}{ReturnBlock} = 2;
$TableBlockNextCalculate{15}{ReturnRowStart} = 2;
$TableBlockNextCalculate{15}{ReturnColumnStart} = 2;
$TableBlockNextCalculate{15}{ReturnColumnStop} = 2;

# tableblocknextcalculatetest16
$TableBlockNextCalculate{16}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[0][2]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[0][2]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[1][0]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[1][1]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[1][1]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[1][2]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[1][2]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[2][0]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[2][0]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[2][1]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[2][1]{TmpOff} = 0;
$TableBlockNextCalculate{16}{CellData}[2][2]{Off} = 1;
$TableBlockNextCalculate{16}{CellData}[2][2]{TmpOff} = 0;

$TableBlockNextCalculate{16}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{16}{State} = 0;
$TableBlockNextCalculate{16}{ReturnBlock} = 0;
$TableBlockNextCalculate{16}{ReturnRowStart} = 0;
$TableBlockNextCalculate{16}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{16}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest17
$TableBlockNextCalculate{17}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{17}{CellData}[0][0]{TmpOff} = 1;

$TableBlockNextCalculate{17}{ColumnData}[0]{Block} = 0;

$TableBlockNextCalculate{17}{State} = 1;
$TableBlockNextCalculate{17}{ReturnBlock} = 0;
$TableBlockNextCalculate{17}{ReturnRowStart} = 0;
$TableBlockNextCalculate{17}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{17}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest18
$TableBlockNextCalculate{18}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{18}{CellData}[0][0]{TmpOff} = 1;

$TableBlockNextCalculate{18}{ColumnData}[0][0]{Block} = 0;

$TableBlockNextCalculate{18}{State} = 0;
$TableBlockNextCalculate{18}{ReturnBlock} = 0;
$TableBlockNextCalculate{18}{ReturnRowStart} = 0;
$TableBlockNextCalculate{18}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{18}{ReturnColumnStop} = 0;

# tableblocknextcalculatetest19
$TableBlockNextCalculate{19}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{19}{CellData}[0][0]{TmpOff} = 1;
$TableBlockNextCalculate{19}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{19}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{19}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{19}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{19}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{19}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{19}{ColumnData}[0]{Block} = 0;
$TableBlockNextCalculate{19}{ColumnData}[1]{Block} = 1;

$TableBlockNextCalculate{19}{State} = 1;
$TableBlockNextCalculate{19}{ReturnBlock} = 1;
$TableBlockNextCalculate{19}{ReturnRowStart} = 0;
$TableBlockNextCalculate{19}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{19}{ReturnColumnStop} = 1;

# tableblocknextcalculatetest20
$TableBlockNextCalculate{20}{CellData}[0][0]{Off} = 0;
$TableBlockNextCalculate{20}{CellData}[0][0]{TmpOff} = 1;
$TableBlockNextCalculate{20}{CellData}[0][1]{Off} = 0;
$TableBlockNextCalculate{20}{CellData}[0][1]{TmpOff} = 1;
$TableBlockNextCalculate{20}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{20}{CellData}[1][0]{TmpOff} = 0;
$TableBlockNextCalculate{20}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{20}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{20}{ColumnData}[0]{Block} = 0;
$TableBlockNextCalculate{20}{ColumnData}[1]{Block} = 0;

$TableBlockNextCalculate{20}{State} = 1;
$TableBlockNextCalculate{20}{ReturnBlock} = 0;
$TableBlockNextCalculate{20}{ReturnRowStart} = 0;
$TableBlockNextCalculate{20}{ReturnColumnStart} = 0;
$TableBlockNextCalculate{20}{ReturnColumnStop} = 1;

# tableblocknextcalculatetest21
$TableBlockNextCalculate{21}{CellData}[0][0]{Off} = 1;
$TableBlockNextCalculate{21}{CellData}[0][0]{TmpOff} = 0;
$TableBlockNextCalculate{21}{CellData}[0][1]{Off} = 1;
$TableBlockNextCalculate{21}{CellData}[0][1]{TmpOff} = 0;
$TableBlockNextCalculate{21}{CellData}[1][0]{Off} = 0;
$TableBlockNextCalculate{21}{CellData}[1][0]{TmpOff} = 1;
$TableBlockNextCalculate{21}{CellData}[1][1]{Off} = 0;
$TableBlockNextCalculate{21}{CellData}[1][1]{TmpOff} = 0;

$TableBlockNextCalculate{21}{ColumnData}[0]{Block} = 0;
$TableBlockNextCalculate{21}{ColumnData}[1]{Block} = 1;

$TableBlockNextCalculate{21}{State} = 1;
$TableBlockNextCalculate{21}{ReturnBlock} = 1;
$TableBlockNextCalculate{21}{ReturnRowStart} = 1;
$TableBlockNextCalculate{21}{ReturnColumnStart} = 1;
$TableBlockNextCalculate{21}{ReturnColumnStop} = 1;

# start testing _TableBlockNextCalculate()
foreach (sort keys %TableBlockNextCalculate) {
    my $Test = $_;
    my $TestOk = 0;

    my %Return = $Self->{PDFObject}->_TableBlockNextCalculate(
        CellData => $TableBlockNextCalculate{$Test}{CellData},
        ColumnData => $TableBlockNextCalculate{$Test}{ColumnData},
    );

    if ($Return{State} eq $TableBlockNextCalculate{$Test}{State} &&
        $Return{ReturnBlock} eq $TableBlockNextCalculate{$Test}{ReturnBlock} &&
        $Return{ReturnRowStart} eq $TableBlockNextCalculate{$Test}{ReturnRowStart} &&
        $Return{ReturnColumnStart} eq $TableBlockNextCalculate{$Test}{ReturnColumnStart} &&
        $Return{ReturnColumnStop} eq $TableBlockNextCalculate{$Test}{ReturnColumnStop}
    ) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR _TableBlockNextCalculate$Test State -->$Return{State}\n";
        print "ERROR _TableBlockNextCalculate$Test ReturnBlock -->$Return{ReturnBlock}\n";
        print "ERROR _TableBlockNextCalculate$Test ReturnRowStart -->$Return{ReturnRowStart}\n";
        print "ERROR _TableBlockNextCalculate$Test ReturnColumnStart -->$Return{ReturnColumnStart}\n";
        print "ERROR _TableBlockNextCalculate$Test ReturnColumnStop -->$Return{ReturnColumnStop}\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "_TableBlockNextCalculate$Test()",
    );
}

# _TableRowCalculate() tests
my %TableRowCalculate;

# tablerowcalculatetest0
$TableRowCalculate{0}{Border} = 1;

$TableRowCalculate{0}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{0}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{0}{CellData}[0][0]{FontSize} = 14;
$TableRowCalculate{0}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{0}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{0}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{0}{CellData}[0][1]{FontSize} = 10;
$TableRowCalculate{0}{CellData}[0][1]{Lead} = 2;

$TableRowCalculate{0}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{0}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{0}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{0}{ReturnRowData}[0]{TextHeight} = 14;
$TableRowCalculate{0}{ReturnRowData}[0]{OutputHeight} = 16;

# tablerowcalculatetest1
$TableRowCalculate{1}{Border} = 0;
$TableRowCalculate{1}{PaddingTop} = 2;
$TableRowCalculate{1}{PaddingBottom} = 3;

$TableRowCalculate{1}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{1}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{1}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{1}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{1}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{1}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{1}{CellData}[0][1]{FontSize} = 14;
$TableRowCalculate{1}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{1}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{1}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{1}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{1}{ReturnRowData}[0]{TextHeight} = 14;
$TableRowCalculate{1}{ReturnRowData}[0]{OutputHeight} = 19;

# tablerowcalculatetest2
$TableRowCalculate{2}{Border} = 0;

$TableRowCalculate{2}{CellData}[0][0]{Content} = '';
$TableRowCalculate{2}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{2}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{2}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{2}{CellData}[0][1]{Content} = '';
$TableRowCalculate{2}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{2}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{2}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{2}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{2}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{2}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{2}{ReturnRowData}[0]{TextHeight} = 11;
$TableRowCalculate{2}{ReturnRowData}[0]{OutputHeight} = 11;

# tablerowcalculatetest3
$TableRowCalculate{3}{Border} = 2;

$TableRowCalculate{3}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{3}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{3}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{3}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{3}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{3}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{3}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{3}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{3}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{3}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{3}{RowData}[0]{Height} = 99;

$TableRowCalculate{3}{ReturnRowData}[0]{Height} = 99;
$TableRowCalculate{3}{ReturnRowData}[0]{TextHeight} = 99;
$TableRowCalculate{3}{ReturnRowData}[0]{OutputHeight} = 103;

# tablerowcalculatetest4
$TableRowCalculate{4}{Border} = 2;

$TableRowCalculate{4}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{4}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{4}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{4}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{4}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{4}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{4}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{4}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{4}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{4}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{4}{RowData}[0]{Height} = 0;

$TableRowCalculate{4}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{4}{ReturnRowData}[0]{TextHeight} = 11;
$TableRowCalculate{4}{ReturnRowData}[0]{OutputHeight} = 15;

# tablerowcalculatetest5
$TableRowCalculate{5}{Border} = 2;

$TableRowCalculate{5}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{5}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{5}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{5}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{5}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{5}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{5}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{5}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{5}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{5}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{5}{RowData}[0]{Height} = 1;

$TableRowCalculate{5}{ReturnRowData}[0]{Height} = 1;
$TableRowCalculate{5}{ReturnRowData}[0]{TextHeight} = 1;
$TableRowCalculate{5}{ReturnRowData}[0]{OutputHeight} = 5;

# tablerowcalculatetest6
$TableRowCalculate{6}{Border} = 2;

$TableRowCalculate{6}{CellData}[0][0]{Content} = 'Zelle 1-1';
$TableRowCalculate{6}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{6}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{6}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{6}{CellData}[0][1]{Content} = 'Zelle 1-2';
$TableRowCalculate{6}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{6}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{6}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{6}{ColumnData}[0]{TextWidth} = 1;
$TableRowCalculate{6}{ColumnData}[1]{TextWidth} = 1;

$TableRowCalculate{6}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{6}{ReturnRowData}[0]{TextHeight} = 11;
$TableRowCalculate{6}{ReturnRowData}[0]{OutputHeight} = 15;

# tablerowcalculatetest7
$TableRowCalculate{7}{Border} = 2;

$TableRowCalculate{7}{CellData}[0][0]{Content} = 'ISS';
$TableRowCalculate{7}{CellData}[0][0]{Font} = 'Helvetica';
$TableRowCalculate{7}{CellData}[0][0]{FontSize} = 10;
$TableRowCalculate{7}{CellData}[0][0]{Lead} = 0;
$TableRowCalculate{7}{CellData}[0][1]{Content} = 'Letzten Samstag wurde die Nutzlast, das backbordseitige Tragwerksegment P3/4 mit seinen beiden Solarzellenflächen, die ein Viertel der Gesamtstromversorgung der ISS bereitstellen sollen, in den Frachtraum der ATLANTIS verladen.';
$TableRowCalculate{7}{CellData}[0][1]{Font} = 'Helvetica';
$TableRowCalculate{7}{CellData}[0][1]{FontSize} = 11;
$TableRowCalculate{7}{CellData}[0][1]{Lead} = 5;

$TableRowCalculate{7}{ColumnData}[0]{TextWidth} = 100;
$TableRowCalculate{7}{ColumnData}[1]{TextWidth} = 100;

$TableRowCalculate{7}{ReturnRowData}[0]{Height} = 0;
$TableRowCalculate{7}{ReturnRowData}[0]{TextHeight} = 219;
$TableRowCalculate{7}{ReturnRowData}[0]{OutputHeight} = 223;

# start testing TableCalculate()
foreach (sort keys %TableRowCalculate) {
    my $Test = $_;
    my $TestOk = 0;

    my %TableRowCalculateParams;
    $TableRowCalculateParams{CellData} = $TableRowCalculate{$Test}{CellData};
    $TableRowCalculateParams{ColumnData} = $TableRowCalculate{$Test}{ColumnData} || [];
    $TableRowCalculateParams{RowData} = $TableRowCalculate{$Test}{RowData} || [];
    $TableRowCalculateParams{PaddingTop} = $TableRowCalculate{$Test}{PaddingTop} || 0;
    $TableRowCalculateParams{PaddingBottom} = $TableRowCalculate{$Test}{PaddingBottom} || 0;
    $TableRowCalculateParams{Border} = $TableRowCalculate{$Test}{Border} || 0;

    my %Return = $Self->{PDFObject}->_TableRowCalculate(
        Row => 0,
        %TableRowCalculateParams,
    );

    if ($Return{RowData}->[0]->{Height} eq $TableRowCalculate{$Test}{ReturnRowData}[0]{Height} &&
        $Return{RowData}->[0]->{TextHeight} eq $TableRowCalculate{$Test}{ReturnRowData}[0]{TextHeight} &&
        $Return{RowData}->[0]->{OutputHeight} eq $TableRowCalculate{$Test}{ReturnRowData}[0]{OutputHeight}
    ) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR _TableRowCalculate$Test Height -->$Return{RowData}->[0]->{Height}\n";
        print "ERROR _TableRowCalculate$Test TextHeight -->$Return{RowData}->[0]->{TextHeight}\n";
        print "ERROR _TableRowCalculate$Test OutputHeight -->$Return{RowData}->[0]->{OutputHeight}\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "_TableRowCalculate$Test()",
    );
}

# _TableCellOnCount() tests
my %TableCellOnCount;

# tablecelloncounttest0
$TableCellOnCount{0}{CellData}[0][0]{Off} = 0;
$TableCellOnCount{0}{Return} = 1;

# tablecelloncounttest1
$TableCellOnCount{1}{CellData}[0][0]{Off} = 1;
$TableCellOnCount{1}{Return} = 0;

# tablecelloncounttest2
$TableCellOnCount{2}{CellData}[0][0]{Off} = 0;
$TableCellOnCount{2}{CellData}[0][1]{Off} = 0;
$TableCellOnCount{2}{CellData}[1][0]{Off} = 0;
$TableCellOnCount{2}{CellData}[1][1]{Off} = 0;
$TableCellOnCount{2}{Return} = 4;

# tablecelloncounttest3
$TableCellOnCount{3}{CellData}[0][0]{Off} = 1;
$TableCellOnCount{3}{CellData}[0][1]{Off} = 0;
$TableCellOnCount{3}{CellData}[1][0]{Off} = 0;
$TableCellOnCount{3}{CellData}[1][1]{Off} = 0;
$TableCellOnCount{3}{Return} = 3;

# tablecelloncounttest4
$TableCellOnCount{4}{CellData}[0][0]{Off} = 1;
$TableCellOnCount{4}{CellData}[0][1]{Off} = 1;
$TableCellOnCount{4}{CellData}[1][0]{Off} = 0;
$TableCellOnCount{4}{CellData}[1][1]{Off} = 0;
$TableCellOnCount{4}{Return} = 2;

# tablecelloncounttest5
$TableCellOnCount{5}{CellData}[0][0]{Off} = 1;
$TableCellOnCount{5}{CellData}[0][1]{Off} = 1;
$TableCellOnCount{5}{CellData}[1][0]{Off} = 1;
$TableCellOnCount{5}{CellData}[1][1]{Off} = 0;
$TableCellOnCount{5}{Return} = 1;

# tablecelloncounttest6
$TableCellOnCount{6}{CellData}[0][0]{Off} = 1;
$TableCellOnCount{6}{CellData}[0][1]{Off} = 1;
$TableCellOnCount{6}{CellData}[1][0]{Off} = 1;
$TableCellOnCount{6}{CellData}[1][1]{Off} = 1;
$TableCellOnCount{6}{Return} = 0;

# start testing TableCellOnCount()
foreach (sort keys %TableCellOnCount) {
    my $Test = $_;
    my $TestOk = 0;

    my $Return = $Self->{PDFObject}->_TableCellOnCount(
        CellData => $TableCellOnCount{$Test}{CellData},
    );

    if ($Return eq $TableCellOnCount{$Test}{Return}) {
        $TestOk = 1;
    }
    else {
        print "\n";
        print "ERROR _TableCellOnCount$Test Count -->$Return\n";
        print "\n";
    }

    $Self->True(
        $TestOk,
        "_TableCellOnCount$Test()",
    );
}

1;
