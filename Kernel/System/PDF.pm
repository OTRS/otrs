# --
# Kernel/System/PDF.pm - PDF lib
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PDF.pm,v 1.2 2006-07-31 15:22:25 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PDF;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::PDF - pdf lib

=head1 SYNOPSIS

All pdf functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject TimeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # load PDF::API2
    if (!$Self->{MainObject}->Require('PDF::API2')) {
        return;
    }

    return $Self;
}

=item DocumentNew()

Create a new PDF Document

    This fonts are available in all methods:
        Courier
        CourierBold
        CourierBoldItalic
        CourierItalic
        Georgia
        GeorgiaBold
        GeorgiaBoldItalic
        GeorgiaItalic
        Helvetica
        HelveticaBold
        HelveticaBoldItalic
        HelveticaItalic
        Times
        TimesBold
        TimesBoldItalic
        TimesItalic
        Verdana
        VerdanaBold
        VerdanaBoldItalic
        VerdanaItalic
        Webdings
        ZapfDingbats

    $True = $PDFObject->DocumentNew(
        Title => 'The Document Title',  # Title of PDF Document
        Encode => 'latin1',             # Charset of Document
    );

=cut

sub DocumentNew {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    if (!defined($Self->{PDF})) {
        # get Product and Version
        $Self->{Config}->{Project} = $Self->{ConfigObject}->Get('Product');
        $Self->{Config}->{Version} = $Self->{ConfigObject}->Get('Version');
        my $ProjectVersion = $Self->{Config}->{Project} . ' ' . $Self->{Config}->{Version};
        # set document title
        $Self->{Document}->{Title} = $Param{Title} || $ProjectVersion;
        # set document encode
        if (!defined($Param{Encode}) || ($Param{Encode} ne 'latin1' && $Param{Encode} ne 'utf8')) {
            $Param{Encode} = 'latin1';
        }
        $Self->{Document}->{Encode} = $Param{Encode};
        # set logo file
        $Self->{Document}->{LogoFile} = $Self->{ConfigObject}->Get('PDF::LogoFile');

        # create a new document
        $Self->{PDF} = PDF::API2->new();

        if ($Self->{PDF}) {
            # today
            my ($NowSec, $NowMin, $NowHour, $NowDay, $NowMonth, $NowYear) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->SystemTime(),
            );
            # set document infos
            $Self->{PDF}->info(
                'Author'       => $ProjectVersion,
                'CreationDate' => "D:" . $NowYear . $NowMonth . $NowDay . $NowHour . $NowMin . $NowSec . "+01'00'",
                'Creator'      => $ProjectVersion,
                'Producer'     => "OTRS PDF Creator",
                'Title'        => $Self->{Document}->{Title},
                'Subject'      => $Self->{Document}->{Title},
            );

            # set fonts
            $Self->{Font}->{Courier} = $Self->{PDF}->corefont(
                'Courier',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{CourierBold} = $Self->{PDF}->corefont(
                'Courier-Bold',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{CourierBoldItalic} = $Self->{PDF}->corefont(
                'Courier-BoldOblique',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{CourierItalic} = $Self->{PDF}->corefont(
                'Courier-Oblique',
                -encode => $Self->{Document}->{Encode},
            );

            $Self->{Font}->{Georgia} = $Self->{PDF}->corefont(
                'Georgia',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{GeorgiaBold} = $Self->{PDF}->corefont(
                'Georgia,Bold',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{GeorgiaBoldItalic} = $Self->{PDF}->corefont(
                'Georgia,BoldItalic',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{GeorgiaItalic} = $Self->{PDF}->corefont(
                'Georgia,Italic',
                -encode => $Self->{Document}->{Encode},
            );

            $Self->{Font}->{Helvetica} = $Self->{PDF}->corefont(
                'Helvetica',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{HelveticaBold} = $Self->{PDF}->corefont(
                'Helvetica-Bold',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{HelveticaBoldItalic} = $Self->{PDF}->corefont(
                'Helvetica-BoldOblique',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{HelveticaItalic} = $Self->{PDF}->corefont(
                'Helvetica-Oblique',
                -encode => $Self->{Document}->{Encode},
            );

            $Self->{Font}->{Times} = $Self->{PDF}->corefont(
                'Times-Roman',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{TimesBold} = $Self->{PDF}->corefont(
                'Times-Bold',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{TimesBoldItalic} = $Self->{PDF}->corefont(
                'Times-BoldItalic',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{TimesItalic} = $Self->{PDF}->corefont(
                'Times-Italic',
                -encode => $Self->{Document}->{Encode},
            );

            $Self->{Font}->{Verdana} = $Self->{PDF}->corefont(
                'Verdana',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{VerdanaBold} = $Self->{PDF}->corefont(
                'Verdana,Bold',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{VerdanaBoldItalic} = $Self->{PDF}->corefont(
                'Verdana,BoldItalic',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{VerdanaItalic} = $Self->{PDF}->corefont(
                'Verdana,Italic',
                -encode => $Self->{Document}->{Encode},
            );

            $Self->{Font}->{Webdings} = $Self->{PDF}->corefont(
                'Webdings',
                -encode => $Self->{Document}->{Encode},
            );
            $Self->{Font}->{ZapfDingbats} = $Self->{PDF}->corefont(
                'ZapfDingbats',
                -encode => $Self->{Document}->{Encode},
            );
            return 1;
        }
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message => "Can not create new Document!"
    );
    return;
}

=item PageBlankNew()

Create a new, blank Page

    $True = $PDFObject->PageBlankNew(
        Width => 200,                    # (optional) default 595 (Din A4) - _ both or nothing
        Height => 300,                   # (optional) default 842 (Din A4) -
        PageOrientation => 'landscape',  # (optional) default normal (normal|landscape)
        MarginTop => 40,                 # (optional) default 0 -
        MarginRight => 40,               # (optional) default 0  |_ all or nothing
        MarginBottom => 40,              # (optional) default 0  |
        MarginLeft => 40,                # (optional) default 0 -
        ShowPageNumber => 0,             # (optional) default 1
    );

=cut

sub PageBlankNew {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Object!");
        return;
    }
    # set PageOrientation
    if (!defined($Param{PageOrientation})) {
        $Param{PageOrientation} = 'normal';
    }

    # create a new page
    $Self->{Page} = $Self->{PDF}->page();

    # if page was created
    if ($Self->{Page}) {
        # set new page width and height
        $Self->_CurPageDimSet(
            %Param,
        );
        # get current page dimension an set mediabox
        my %Page = $Self->_CurPageDimGet();
        $Self->{Page}->mediabox(
            $Page{Width},
            $Page{Height},
        );

        # set default value of ShowPageNumber, if no value given
        my $ShowPageNumber = 1;
        if (defined($Param{ShowPageNumber}) && $Param{ShowPageNumber} eq 0) {
            $ShowPageNumber = 0;
        }
        # set the page numbers
        $Self->_CurPageNumberSet(
            ShowPageNumber => $ShowPageNumber,
        );

        if ($Param{MarginTop} && $Param{MarginRight} && $Param{MarginBottom} && $Param{MarginLeft}) {
            $Self->_CurPrintableDimSet(
                Top => $Param{MarginTop},
                Right => $Param{MarginRight},
                Bottom => $Param{MarginBottom},
                Left => $Param{MarginLeft},
            );
        }
        return 1;
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message => "Can not create new blank Page!"
    );
    return;
}

=item PageNew()

Create a new Page

    $PDFObject->PageNew(
        Width => 200,                       # (optional) default 595 (Din A4)
        Height => 300,                      # (optional) default 842 (Din A4)
        PageOrientation => 'landscape',     # (optional) default normal (normal|landscape)
        MarginTop => 40,                    # (optional) default 0
        MarginRight => 40,                  # (optional) default 0
        MarginBottom => 40,                 # (optional) default 0
        MarginLeft => 40,                   # (optional) default 0
        ShowPageNumber => 0,                # (optional) default 1
        LogoFile => '/path/to/file.jpg',    # (optional) you can use jpg, gif and png-Images
        HeaderRight => 'Header Right Text', # (optional)
        FooterLeft => 'Footer Left Text',   # (optional)
        FooterRight => 'Footer Right Text', # (optional)
    );

=cut

sub PageNew {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Object!");
        return;
    }

    my %Data = ();
    # set new page width and height, if values are given
    if ($Param{Width} && $Param{Height}) {
        $Data{Width} = $Param{Width};
        $Data{Height} = $Param{Height};
    }
    # set new margin, if values are given
    if ($Param{MarginTop} && $Param{MarginRight} && $Param{MarginBottom} && $Param{MarginLeft}) {
        $Data{MarginTop} = $Param{MarginTop};
        $Data{MarginRight} = $Param{MarginRight};
        $Data{MarginBottom} = $Param{MarginBottom};
        $Data{MarginLeft} = $Param{MarginLeft};
    }
    if ($Param{ShowPageNumber}) {
        $Data{ShowPageNumber} = $Param{ShowPageNumber};
    }
    if ($Param{PageOrientation}) {
        $Data{PageOrientation} = $Param{PageOrientation};
    }

    # create a blank page
    $Self->PageBlankNew(%Data);
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page Object!");
        return;
    }
    # set activ dimension
    $Self->DimSet(
        Dim => 'printable',
    );
    # get current printable dimension
    my %Printable = $Self->_CurPrintableDimGet();

    # get logofile
    my $LogoFile = $Self->{Document}->{LogoFile} || $Self->{ConfigObject}->Get('Home') . '/var/logo-otrs.png';
    if (defined($Param{LogoFile}) &&
        -e $Param{LogoFile} &&
        ($Param{LogoFile} =~ /^.*\.gif$/i ||
        $Param{LogoFile} =~ /^.*\.jpg$/i ||
        $Param{LogoFile} =~ /^.*\.png$/i)
    ) {
        $LogoFile = $Param{LogoFile};
    }
    # output the logo image at header left
    $Self->Image(
        File => $LogoFile,
        Width => 700,
        Height => 100,
    );

    if ($Param{HeaderRight}) {
        # set new position
        $Self->PositionSet(
            Move => 'relativ',
            X => 168,
            Y => 15,
        );
        # output page header right
        $Self->Text(
            Text => $Param{HeaderRight},
            Type => 'Cut',
            Color => '#404040',
            FontSize => 12,
            Height => 12,
            Align => 'right',
        );
    }

    # set new position
    $Self->PositionSet(
        X => 'left',
        Y => 'top',
    );
    # set new position
    $Self->PositionSet(
        Move => 'relativ',
        Y => -29,
    );
    # output the lines in top of the page
    $Self->HLine(
        Color => '#505050',
        LineWidth => 1,
    );

    if ($Param{FooterLeft}) {
        # set new position
        $Self->PositionSet(
            X => 'left',
            Y => 'bottom',
        );
        # set new position
        $Self->PositionSet(
            Move => 'relativ',
            Y => 8,
        );
        # output page footer left
        $Self->Text(
            Text => $Param{FooterLeft},
            Width => ($Printable{Width} / 2),
            Type => 'Cut',
            Color => '#404040',
            FontSize => 8,
            Height => 8,
            Align => 'left',
        );
    }

    if ($Param{FooterRight}) {
        # set new position
        $Self->PositionSet(
            X => 'left',
            Y => 'bottom',
        );
        # set new position
        $Self->PositionSet(
            Move => 'relativ',
            X => ($Printable{Width} / 2),
            Y => 8,
        );
        # output page footer right
        $Self->Text(
            Text => $Param{FooterRight},
            Type => 'Cut',
            Color => '#404040',
            FontSize => 8,
            Height => 8,
            Align => 'right',
        );
    }

    # set new position
    $Self->PositionSet(
        X => 'left',
        Y => 'bottom',
    );
    # set new position
    $Self->PositionSet(
        Move => 'relativ',
        Y => 11,
    );
    # output the lines in bottom of the page
    $Self->HLine(
        Color => '#505050',
        LineWidth => 1,
    );

    # set new content dimension
    $Self->_CurContentDimSet (
        Top => $Printable{Top} + 34,
        Right => $Printable{Right},
        Bottom => $Printable{Bottom} + 16,
        Left => $Printable{Left},
    );
    # set activ dimension
    $Self->DimSet(
        Dim => 'content',
    );

    return 1;
}

=item DocumentOutput()

Return the PDF as string

    $DocumentString = $PDFObject->DocumentOutput();

=cut

sub DocumentOutput {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Object!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    # return the document as string
    my $DocumentString = $Self->{PDF}->stringify;
    $Self->{PDF}->end();

    return $DocumentString;
}

=item Table()

Add a table

    Return
        $Return{State}
        $Return{RequiredWidth}
        $Return{RequiredHeight}
        $CellData                # (reference) complete calculated
        $ColumnData              # (reference) complete calculated

    (%Return, $CellData, $ColumnData) = $PDFObject->Table(
        CellData => $CellData,            # 2D arrayref (see example)
        ColumnData => $ColumnData,        # 2D arrayref (see example)
        Width => 300,                     # (optional) default maximal width
        Height => 400,                    # (optional) default minimal height
        Font => 'Times',                  # (optional) default Helvetica (see DocumentNew())
        FontSize => 9,                    # (optional) default 11
        FontColor => 'red',               # (optional) default black
        FontColorEven => 'blue',          # (optional) cell font color for even rows
        FontColorOdd => 'green',          # (optional) cell font color for odd rows
        Align => 'right',                 # (optional) default left (left|center|right)
        Lead => 3,                        # (optional) default 1
        Padding => 18,                    # (optional) default 3
        PaddingTop => 10,                 # (optional) top cell padding, overides Padding
        PaddingRight => 30,               # (optional) right cell padding, overides Padding
        PaddingBottom => 30,              # (optional) bottom cell padding, overides Padding
        PaddingLeft => 10,                # (optional) left cell padding, overides Padding
        BackgroundColor => '#101010',     # (optional) default white
        BackgroundColorEven => '#F0F0F0', # (optional) cell background color for even rows
        BackgroundColorOdd => '#A0A0A0',  # (optional) cell background color for odd rows
        Border => 1,                      # (optional) default 1 (values between 0 and 20)
        BorderColor => '#FF0000',         # (optional) default black
    );

    $CellData = [
        [
            {
                Content => "Cell 1 (Row 1, Column 1)",  # (optional)
                Font => 'Times',                        # (optional) (see DocumentNew())
                FontSize => 13,                         # (optional)
                FontColor => '#00FF00',                 # (optional)
                Align => 'center',                      # (optional)
                Lead => 7,                              # (optional)
                BackgroundColor => '#101010',           # (optional)
            },
            {
                Content => "Cell 2 (Row 1, Column 2)",
            },
        ],
        [
            {
                Content => "Cell 3 (Row 2, Column 1)",
            },
            {
                Content => "Cell 4 (Row 2, Column 2)",
            },
        ],
    ];

    $ColumData = [                       # this array was automaticly generated, if not given
        {
            Width => 11,                 # optional
        },
        {
            Width => 44,
        },
    ];

=cut

sub Table {
    my $Self = shift;
    my %Param = @_;
    my %Return = (
        State => 0,
        RequiredWidth => 0,
        RequiredHeight => 0,
    );
    # check needed stuff
    foreach (qw(CellData)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Dim;
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        %Dim = $Self->_CurContentDimGet();
    }
    # get current position
    my %Position = $Self->_CurPositionGet();

    # set default values
    $Param{Font} = $Param{Font} || 'Helvetica';
    if (!defined($Param{FontSize}) || $Param{FontSize} <= 0) {
        $Param{FontSize} = 10;
    }
    if (!defined($Param{Lead}) || $Param{Lead} < -($Param{FontSize})) {
        $Param{Lead} = 1;
    }
    $Param{FontColor} = $Param{FontColor} || 'black';
    $Param{FontColorOdd} = $Param{FontColorOdd} || $Param{FontColor};
    $Param{FontColorEven} = $Param{FontColorEven} || $Param{FontColor};

    $Param{BackgroundColor} = $Param{BackgroundColor} || 'NULL';
    $Param{BackgroundColorOdd} = $Param{BackgroundColorOdd} || $Param{BackgroundColor};
    $Param{BackgroundColorEven} = $Param{BackgroundColorEven} || $Param{BackgroundColor};

    $Param{Align} = $Param{Align} || 'left';

    if (!defined($Param{Border}) || $Param{Border} < 0) {
        $Param{Border} = 1;
    }
    $Param{BorderColor} = $Param{BorderColor} || 'black';
    $Param{PaddingTop} = $Param{PaddingTop} || $Param{Padding} || 3;
    $Param{PaddingRight} = $Param{PaddingRight} || $Param{Padding} || 3;
    $Param{PaddingBottom} = $Param{PaddingBottom} || $Param{Padding} || 3;
    $Param{PaddingLeft} = $Param{PaddingLeft} || $Param{Padding} || 3;

    # check given Width
    if (!defined($Param{Width}) ||
        $Param{Width} < 0
    ) {
        $Param{Width} = $Dim{Left} + $Dim{Width} - $Position{X};
    }
    # check given Height
    if (!defined($Param{Height}) ||
        $Param{Height} < 0
    ) {
        $Param{Height} = $Position{Y} - $Dim{Bottom};
    }

    $Param{ColumnData} = $Param{ColumnData} || [];

    # output the table (or a fragment of it)
    if (ref $Param{CellData} && ref $Param{ColumnData}) {
        # calculate required table attributes
        $Self->_TableCalculate(
            %Param,
        );
        # calculate, what cells can output
        my %OutputCells = $Self->_TableOutputCalculate (
            %Param,
        );

        if ($OutputCells{State}) {
            # save current position
            my $PositionX = $Position{X};
            my $PositionY = $Position{Y};

            foreach my $Row (@{$OutputCells{ReturnRows}}) {
                # calculate height of row
                my $RowHeightComplete = 0;
                my $BiggerstFontSize = 0;
                foreach my $Column (@{$OutputCells{ReturnColumns}}) {
                    my %CalculateRow = $Self->_TextCalculate (
                        Text => $Param{CellData}->[$Row]->[$Column]->{Content},
                        Type => 'ReturnLeftOver',
                        Width => $Param{ColumnData}->[$Column]->{Width} + $OutputCells{CellSpaceExtra},
                        Height => 999999999999999999,
                        Font => $Param{CellData}->[$Row]->[$Column]->{Font},
                        FontSize => $Param{CellData}->[$Row]->[$Column]->{FontSize},
                        Lead => $Param{CellData}->[$Row]->[$Column]->{Lead},
                    );
                    if ($CalculateRow{RequiredHeight} > $RowHeightComplete) {
                        $RowHeightComplete = $CalculateRow{RequiredHeight};
                    }
                    if ($Param{CellData}->[$Row]->[$Column]->{FontSize} > $BiggerstFontSize) {
                        $BiggerstFontSize = $Param{CellData}->[$Row]->[$Column]->{FontSize};
                    }
                }

                my $OutputRow = 1;
                my $RowHeight = 0;
                if (($Position{Y} - $Param{PaddingTop} - $RowHeightComplete - $Param{PaddingBottom} - $Param{Border}) >= $Dim{Bottom}) {
                    $RowHeight = $Param{Border} + $Param{PaddingTop} + $RowHeightComplete + $Param{PaddingBottom} + $Param{Border};
                }
                else {
                    if (($Position{Y} - $Param{PaddingTop} - $BiggerstFontSize - $Param{PaddingBottom} - $Param{Border}) >= $Dim{Bottom}) {
                        $RowHeight = $Position{Y} - $Dim{Bottom};
                    }
                    else {
                        $OutputRow = 0;
                    }
                    last;
                }

                if ($OutputRow) {
                    my $RowState = 1;

                    foreach my $Column (@{$OutputCells{ReturnColumns}}) {
                        my %TableCellOutputReturn = $Self->_TableCellOutput (
                            Width => $Param{ColumnData}->[$Column]->{Width} + $OutputCells{CellSpaceExtra},
                            Height => $RowHeight,
                            Text => $Param{CellData}->[$Row]->[$Column]->{Content},
                            Font => $Param{CellData}->[$Row]->[$Column]->{Font},
                            FontSize => $Param{CellData}->[$Row]->[$Column]->{FontSize},
                            FontColor => $Param{CellData}->[$Row]->[$Column]->{FontColor},
                            Align => $Param{CellData}->[$Row]->[$Column]->{Align},
                            Lead => $Param{CellData}->[$Row]->[$Column]->{Lead},
                            PaddingTop => $Param{PaddingTop},
                            PaddingRight => $Param{PaddingRight},
                            PaddingBottom => $Param{PaddingBottom},
                            PaddingLeft => $Param{PaddingLeft},
                            BackgroundColor => $Param{CellData}->[$Row]->[$Column]->{BackgroundColor},
                            Border => $Param{Border},
                            BorderColor => $Param{BorderColor},
                        );

                        # set RowSetOff
                        if (!$TableCellOutputReturn{State}) {
                            $RowState = 0;
                        }
                        # set new position
                        $Self->_CurPositionSet(
                            X => $Position{X} + $Param{ColumnData}->[$Column]->{Width} + $OutputCells{CellSpaceExtra} - $Param{Border},
                            Y => $Position{Y},
                        );
                        # get current position
                        %Position = $Self->_CurPositionGet();
                    }

                    # deaktivate row, if output ok
                    if ($RowState) {
                        foreach my $Column (@{$OutputCells{ReturnColumns}}) {
                            $Param{CellData}->[$Row]->[$Column]->{Off} = 1;
                        }
                    }
                    else {
                        last;
                    }

                    # set new position
                    $Self->_CurPositionSet(
                        X => $PositionX,
                        Y => $PositionY - $RowHeight + $Param{Border},
                    );
                    # get current position
                    %Position = $Self->_CurPositionGet();
                    $PositionY = $Position{Y};
                }
            }

            my $TableCellOnCount = $Self->_TableCellOnCount(
                CellData => $Param{CellData}
            );
            if ($TableCellOnCount eq 0) {
                $Return{State} = 1;
            }
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "No cell available for output!");
        }
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need references CellData, ColumnData");
    }

    $Return{CellData} = $Param{CellData};
    $Return{ColumnData} = $Param{ColumnData};

    return %Return;
}

=item Text()

Output a textline

    Return
        $Return{State}
        $Return{RequiredWidth}
        $Return{RequiredHeight}
        $Return{LeftOver}

    %Return = $PDFObject->Text(
        Text => 'Text',      # Text
        Width => 300,        # (optional) available width of textblock
        Height => 200,       # (optional) available height of textblock
        Type => 'Cut',       # (optional) default ReturnLeftOver (ReturnLeftOver|ReturnLeftOverHard|Cut)
        Font => 'Courier',   # (optional) default Helvetica  (see DocumentNew())
        FontSize => 15,      # (optional) default 10
        Color => '#FF0000',  # (optional) default #000000
        Align => 'center',   # (optional) default left (left|center|right)
        Lead => 20,          # (optional) default 1 distance between lines
    );

=cut

sub Text {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Text)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Dim;
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        %Dim = $Self->_CurContentDimGet();
    }
    # get current position
    my %Position = $Self->_CurPositionGet();

    $Param{Type} = $Param{Type} || 'ReturnLeftOver';
    $Param{Color} = $Param{Color} || 'black';
    $Param{Font} = $Param{Font} || 'Helvetica';
    $Param{Align} = $Param{Align} || 'left';

    if (!defined($Param{FontSize}) || $Param{FontSize} <= 0) {
        $Param{FontSize} = 10;
    }
    if (!defined($Param{Lead}) || $Param{Lead} < -($Param{FontSize})) {
        $Param{Lead} = 1;
    }
    # check Width
    if (!defined($Param{Width}) ||
        $Param{Width} < 0 ||
        ($Position{X} + $Param{Width}) >= ($Dim{Left} + $Dim{Width})
    ) {
        $Param{Width} = $Dim{Left} + $Dim{Width} - $Position{X};
    }
    # check Height
    if (!defined($Param{Height}) ||
        $Param{Height} < 0 ||
        ($Position{Y} - $Param{Height}) < $Dim{Bottom}
    ) {
        $Param{Height} = $Position{Y} - $Dim{Bottom};
    }

    # calculate the given text
    my %Return = $Self->_TextCalculate(
        Text => $Param{Text},
        Type => $Param{Type},
        Width => $Param{Width},
        Height => $Param{Height},
        Font => $Param{Font},
        FontSize => $Param{FontSize},
        Lead => $Param{Lead},
    );

    if ($Return{LeftOver} ne $Param{Text}) {
        # create a text object
        my $Text = $Self->{Page}->text;
        # set font and fontsize
        $Text->font($Self->{Font}->{$Param{Font}}, $Param{FontSize});
        # set fontcolor
        $Text->fillcolor($Param{Color});

        # save original X position
        my $PositionX = $Position{X};

        my $Counter1 = 0;
        foreach my $Row (@{$Return{PossibleRows}}) {
            # calculate width of row
            my $RowWidth = $Self->_StringWidth (
                Text => $Row,
                Font => $Param{Font},
                FontSize => $Param{FontSize},
            );

            if ($Param{Align} eq 'right') {
                # set new position
                $Self->_CurPositionSet(
                    X => $PositionX + $Param{Width} - $RowWidth,
                );
            }
            elsif ($Param{Align} eq 'center') {
                # set new position
                $Self->_CurPositionSet(
                    X => $PositionX + (($Param{Width} - $RowWidth) / 2),
                );
            }
            # set new position
            if ($Counter1 > 0) {
                $Self->_CurPositionSet(
                    Y => $Position{Y} - $Param{FontSize} - $Param{Lead},
                );
            }
            else {
                $Self->_CurPositionSet(
                    Y => $Position{Y} - $Param{FontSize},
                );
            }
            # get current position
            %Position = $Self->_CurPositionGet();
            # get to position
            $Text->translate($Position{X}, $Position{Y});
            # output text
            $Text->text($Row);

            $Counter1++;
        }
        # set new position
        $Self->_CurPositionSet(
            X => $PositionX,
        );
    }

    return %Return;
}

=item Image()

Output a image

    $True = $PDFObject->Image(
        File => '/path/image.gif',  # (gif|jpg|png)
        Type => 'ReturnFalse'       # (optional) default Reduce (ReturnFalse|Reduce)
        Width => 300,               # width of image
        Height => 150,              # height of image
    );

=cut

sub Image {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(File Width Height)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }
    if (!-e $Param{File}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "File $Param{File} not found!");
        return;
    }

    my %Dim;
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        %Dim = $Self->_CurContentDimGet();
    }

    $Param{Width} = $Param{Width} / (300/72);
    $Param{Height} = $Param{Height} / (300/72);

    my $Image = $Self->{Page}->gfx;
    my $ImageFile;

    if ($Param{File} =~ /^.*\.gif$/i) {
        $ImageFile = $Self->{PDF}->image_gif($Param{File});
    }
    elsif ($Param{File} =~ /^.*\.jpg$/i) {
        $ImageFile = $Self->{PDF}->image_jpeg($Param{File});
    }
    elsif ($Param{File} =~ /^.*\.png$/i) {
        $ImageFile = $Self->{PDF}->image_png($Param{File});
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Imagetype of File $Param{File} not supported");
        return;
    }
    # get current position
    my %Position = $Self->_CurPositionGet();

    my $Reduce = 0;

    # check values
    if (($Position{X} + $Param{Width}) >= ($Dim{Left} + $Dim{Width})) {
        $Param{Width} = $Dim{Left} + $Dim{Width} - $Position{X};
        $Reduce = 1;
    }
    if ($Param{Width} < 1) {
        $Param{Width} = 1;
    }

    if (($Position{Y} - $Param{Height}) <= $Dim{Bottom}) {
        $Param{Height} = $Position{Y} - $Dim{Bottom};
        $Reduce = 1;
    }
    if ($Param{Height} < 1) {
        $Param{Height} = 1;
    }

    my $Return = 1;

    if (defined($Param{Type}) && $Param{Type} eq 'ReturnFalse' && $Reduce) {
        $Return = 0;
    }
    else {
        # output the image
        $Image->image(
            $ImageFile,
            $Position{X},
            $Position{Y} - $Param{Height},
            $Param{Width},
            $Param{Height},
        );
        # set new position
        $Self->_CurPositionSet(
            Y => $Position{Y} - $Param{Height},
        );
    }

    return $Return;
}

=item HLine()

Output a horizontal line

    $True = $PDFObject->HLine(
        Width => 300,          # (optional) default 'end of printable dimension'
        Type => 'ReturnFalse'  # (optional) default Cut (ReturnFalse|Cut)
        Color => '#101010',    # (optional) default black
        LineWidth => 1,        # (optional) default 1
    );

=cut

sub HLine {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Dim;
    # get current position
    my %Position = $Self->_CurPositionGet();
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        %Dim = $Self->_CurContentDimGet();
    }

    # set default color
    $Param{Color} = $Param{Color} || 'black';

    # check LineWidth
    if (!defined($Param{LineWidth}) || $Param{LineWidth} <= 0 || $Param{LineWidth} > 100) {
        $Param{LineWidth} = 1;
    }

    my $Cut = 0;

    if ($Position{Y} - $Param{LineWidth} < $Dim{Bottom}) {
        $Param{LineWidth} = $Position{Y} - $Dim{Bottom};
        if ($Param{LineWidth} < 1) {
            $Param{LineWidth} = 1;
        }
        $Cut = 1;
    }
     $Param{LineWidth} =  0 - $Param{LineWidth};

    # check Width
    if (defined($Param{Width}) && $Param{Width} >= 1) {
        if ($Position{X} + $Param{Width} > $Dim{Left} + $Dim{Width}) {
            $Param{Width} = $Dim{Left} + $Dim{Width} - $Position{X};
            $Cut = 1;
        }
    }
    else {
        $Param{Width} = $Param{Width} = $Dim{Left} + $Dim{Width} - $Position{X};
    }

    # output the lines in top and bottom of the page
    my $Line = $Self->{Page}->gfx;
    $Line->fillcolor($Param{Color});
    # check values
    my $Output = 0;
    if ($Self->DimGet() eq 'printable' &&
        $Self->_CurPrintableDimCheck(
        X => $Position{X},
        Y => $Position{Y}) &&
        $Self->_CurPrintableDimCheck(
        X => $Position{X} + $Param{Width},
        Y => $Position{Y} - $Param{LineWidth})
    ) {
        $Output = 1;
    }
    elsif ($Self->_CurContentDimCheck(
        X => $Position{X},
        Y => $Position{Y}) &&
        $Self->_CurContentDimCheck(
        X => $Position{X} + $Param{Width},
        Y => $Position{Y} - $Param{LineWidth})
    ) {
        $Output = 1;
    }

    if (defined($Param{Type}) && $Param{Type} eq 'ReturnFalse' && $Cut) {
        $Output = 1;
    }

    if ($Output) {
        # output line
        $Line->rect($Position{X}, $Position{Y}, $Param{Width}, $Param{LineWidth});
        $Line->fill;
        # set new position
        $Self->_CurPositionSet(
            Y => $Position{Y} - $Param{LineWidth},
        );
    }

    return $Output;
}

=item PositionSet()

Set new position on current page

    $True = $PDFObject->PositionSet(
        Move => 'absolut',  # (optional) default absolut (absolut|relativ)
        X => 10,            # (optional) (<integer>|left|center|right)
        Y => 20,            # (optional) (<integer>|top|middle|bottom)
    );

=cut

sub PositionSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Data;
    my %Dim;
    my %Position = $Self->_CurPositionGet();
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        $Data{Dim} = 'printable';
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        $Data{Dim} = 'content';
        %Dim = $Self->_CurContentDimGet();
    }

    if (defined($Param{X})) {
        if ($Param{X} eq 'left') {
            $Data{X} = $Dim{Left};
        }
        elsif ($Param{X} eq 'center') {
            $Data{X} = ($Dim{Width} / 2) + $Dim{Left};
        }
        elsif ($Param{X} eq 'right') {
            $Data{X} = $Dim{Left} + $Dim{Width};
        }
        else {
            if (defined($Param{Move}) && $Param{Move} eq 'relativ') {
                if (($Position{X} + $Param{X}) >= $Dim{Left} && ($Position{X} + $Param{X}) < ($Dim{Left} + $Dim{Width})) {
                    $Data{X} = $Position{X} + $Param{X};
                }
                elsif (($Position{X} + $Param{X}) >= ($Dim{Left} + $Dim{Width})) {
                    $Data{X} = $Dim{Left} + $Dim{Width};
                }
                else {
                    $Data{X} = $Dim{Left};
                }
            }
            else {
                if ($Param{X} >= $Dim{Left} && $Param{X} < ($Dim{Left} + $Dim{Width})) {
                    $Data{X} = $Param{X};
                }
                elsif ($Param{X} >= ($Dim{Left} + $Dim{Width})) {
                    $Data{X} = $Dim{Left} + $Dim{Width};
                }
                else {
                    $Data{X} = $Dim{Left};
                }
            }
        }
    }

    if (defined($Param{Y})) {
        if ($Param{Y} eq 'top') {
            $Data{Y} = $Dim{Bottom} + $Dim{Height};
        }
        elsif ($Param{Y} eq 'middle') {
            $Data{Y} = ($Dim{Height} / 2) + $Dim{Bottom};
        }
        elsif ($Param{Y} eq 'bottom') {
            $Data{Y} = $Dim{Bottom};
        }
        else {
            if (defined($Param{Move}) && $Param{Move} eq 'relativ') {
                if (($Position{Y} + $Param{Y}) <= ($Dim{Bottom} + $Dim{Height}) && ($Position{Y} + $Param{Y}) > $Dim{Bottom}) {
                    $Data{Y} = $Position{Y} + $Param{Y};
                }
                elsif (($Position{Y} + $Param{Y}) <= $Dim{Bottom}) {
                    $Data{Y} = $Dim{Bottom};
                }
                else {
                    $Data{Y} = $Dim{Bottom} + $Dim{Height};
                }
            }
            else {
                if ($Param{Y} > $Dim{Bottom} && $Param{Y} <= ($Dim{Bottom} + $Dim{Height})) {
                    $Data{Y} = $Param{Y};
                }
                elsif ($Param{Y} <= $Dim{Bottom}) {
                    $Data{Y} = $Dim{Bottom};
                }
                else {
                    $Data{Y} = $Dim{Bottom} + $Dim{Height};
                }
            }
        }
    }

    $Self->_CurPositionSet(
        %Data,
    );

    return 1;
}

=item PositionGet()

Get position on current page

    Return
        $Position{X}
        $Position{Y}

    %Position = $PDFObject->PositionGet();

=cut

sub PositionGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Position = $Self->_CurPositionGet();

    return %Position;
}

=item DimSet()

Set active dimension

    $Dim = $PDFObject->DimSet(
        Dim => 'printable',  # (optional) default content (content|printable)
    );

=cut

sub DimSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if (defined($Param{Dim}) && $Param{Dim} eq 'printable') {
        $Self->{Current}->{Dim} = 'printable';
    }
    else {
        $Self->{Current}->{Dim} = 'content';
    }

    return $Self->{Current}->{Dim};
}

=item DimGet()

Get active dimension (printable or content)

    $Dim = $PDFObject->DimGet();

=cut

sub DimGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if ($Self->{Current}->{Dim} eq 'printable' || $Self->{Current}->{Dim} eq 'content') {
        $Self->{Current}->{Dim} = 'content';
    }

    return $Self->{Current}->{Dim};
}

#
# _TableCalculate ()
#
# calculate params of table
#
#    Return  # normaly no return required, only references
#
#    (%Return, $CellData, $ColumnData) = $PDFObject->_TableCalculate(
#        CellData => $CellData,            # 2D arrayref (see example)
#        ColumnData => $ColumnData,        # 2D arrayref (see example)
#        Width => 300,                     # (optional) default default maximal width
#        Height => 400,                    # (optional) default minimal height
#        Font => 'Times',                  # (optional) default Helvetica (see DocumentNew())
#        FontSize => 9,                    # (optional) default 11
#        FontColor => 'red',               # (optional) default black
#        FontColorEven => 'blue',          # (optional) cell font color for even rows
#        FontColorOdd => 'green',          # (optional) cell font color for odd rows
#        Align => 'right',                 # (optional) default left (left|center|right)
#        Lead => 3,                        # (optional) default 1
#        PaddingTop => 10,                 # (optional) top cell padding, overides Padding
#        PaddingRight => 30,               # (optional) right cell padding, overides Padding
#        PaddingBottom => 30,              # (optional) bottom cell padding, overides Padding
#        PaddingLeft => 10,                # (optional) left cell padding, overides Padding
#        BackgroundColor => '#101010',     # (optional) default white
#        BackgroundColorEven => '#F0F0F0', # (optional) cell background color for even rows
#        BackgroundColorOdd => '#A0A0A0',  # (optional) cell background color for odd rows
#        Border => 1,                      # (optional) default 1 (values between 0 and 20)
#        BorderColor => '#FF0000',         # (optional) default black
#    );
#
#    $CellData = [
#        [
#            {
#                Content => "Cell 1 (Row 1, Column 1)",  # (optional)
#                Font => 'Times',                        # (optional)
#                FontSize => 13,                         # (optional)
#                FontColor => '#00FF00',                 # (optional)
#                Align => 'center',                      # (optional)
#                Lead => 7,                              # (optional)
#                BackgroundColor => '#101010',           # (optional)
#            },
#            {
#                Content => "Cell 2 (Row 1, Column 2)",
#            },
#        ],
#        [
#            {
#                Content => "Cell 3 (Row 2, Column 1)",
#            },
#            {
#                Content => "Cell 4 (Row 2, Column 2)",
#            },
#        ],
#    ];
#
#    $ColumData = [                       # this array was automaticly generated, if not given
#        {
#            Width => 11,                 # optional
#        },
#        {
#            Width => 44,
#        },
#    ];
#

sub _TableCalculate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(
            CellData ColumnData
            Font FontSize Lead FontColor Align BackgroundColor Width Border BorderColor
            PaddingTop PaddingRight PaddingBottom PaddingLeft
        )
        ) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $RowCounter = 0;
    foreach my $Cell (@{$Param{CellData}}) {
        for (my $ColumnCounter = 0; $ColumnCounter < scalar(@$Cell) ; $ColumnCounter++) {
            # if row is odd
            if ($RowCounter & 1) {
                # set FontColor, if row is odd
                if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontColor}) &&
                    defined($Param{FontColorOdd})
                ) {
                    $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontColor} = $Param{FontColorOdd};
                }
                # set BackgroundColor, if row is odd
                if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{BackgroundColor}) &&
                    defined($Param{BackgroundColorOdd})
                ) {
                    $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{BackgroundColor} = $Param{BackgroundColorOdd};
                }
            }
            # if row is even
            else {
                # set FontColor, if row is even
                if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontColor}) &&
                    defined($Param{FontColorEven})
                ) {
                    $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontColor} = $Param{FontColorEven};
                }
                # set BackgroundColor, if row is even
                if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{BackgroundColor}) &&
                    defined($Param{BackgroundColorEven})
                ) {
                    $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{BackgroundColor} = $Param{BackgroundColorEven};
                }
            }

            # set cell state
            if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Off}) ||
                $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Off} ne 1
            ) {
                $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Off} = 0;
            }

            # set content blank, if not definied
            if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Content}) ||
                $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Content} eq ''
            ) {
                $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Content} = ' ';
            }

            # set default values
            foreach (qw(Font FontSize FontColor Align Lead BackgroundColor)) {
                if (!defined($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{$_})) {
                    $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{$_} = $Param{$_};
                }
            }

            # calculate width of complete column content
            if (!defined($Param{ColumnData}->[$ColumnCounter]->{MaxColWidth})) {
                $Param{ColumnData}->[$ColumnCounter]->{MaxColWidth} = 0;
            }
            my $CompleteContentWidth = $Self->_StringWidth (
                Text => $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Content},
                Font => $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Font},
                FontSize => $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontSize},
            );
            $CompleteContentWidth += $Param{PaddingLeft} + $Param{PaddingRight} + (2 * $Param{Border});

            if ($CompleteContentWidth > $Param{ColumnData}->[$ColumnCounter]->{MaxColWidth}) {
                $Param{ColumnData}->[$ColumnCounter]->{MaxColWidth} = $CompleteContentWidth;
            }

            # calculate with of the greaterst word
            if (!defined($Param{ColumnData}->[$ColumnCounter]->{MinColWidth})) {
                $Param{ColumnData}->[$ColumnCounter]->{MinColWidth} = 0;
            }
            my @Words = split(/\s+/, $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Content});
            foreach (@Words) {
                my $WordWidth = $Self->_StringWidth (
                    Text => $_,
                    Font => $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Font},
                    FontSize => $Param{CellData}->[$RowCounter]->[$ColumnCounter]->{FontSize},
                );
                if ($WordWidth > $Param{ColumnData}->[$ColumnCounter]->{MinColWidth}) {
                    $Param{ColumnData}->[$ColumnCounter]->{MinColWidth} = $WordWidth;
                }
            }

            # estimate width of column
            $Param{ColumnData}->[$ColumnCounter]->{Width} =
                ($Param{ColumnData}->[$ColumnCounter]->{MaxColWidth} + $Param{ColumnData}->[$ColumnCounter]->{MinColWidth}) / 2;
        }
        $RowCounter++;
    }

    return %Param;
}

#
# _TableCellOnCount ()
#
# count all aktive cells
#
#    Return
#        $CellCount
#
#    $Count = $PDFObject->_TableCellOnCount (
#        CellData => $CellData,  # 2D arrayref
#    );
#

sub _TableCellOnCount {
    my $Self = shift;
    my %Param = @_;
    my $Return = 0;
    # check needed stuff
    foreach (qw(CellData)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $RowCounter = 0;
    foreach my $Cell (@{$Param{CellData}}) {
        for (my $ColumnCounter = 0; $ColumnCounter < scalar(@$Cell) ; $ColumnCounter++) {
            if ($Param{CellData}->[$RowCounter]->[$ColumnCounter]->{Off} ne 1) {
                $Return++;
            }
        }
        $RowCounter++;
    }

    return $Return;
}

#
# _TableOutputCalculate ()
#
# calculate what cells can output and some attributes
#
#    Return
#        $Return{State}
#        $Return{Width}
#        $Return{CellSpaceExtra}
#        $Return{ReturnRows}     # (Array Ref)
#        $Return{ReturnColumns}  # (Array Ref)
#
#    %Return = $PDFObject->_TableOutputCalculate (
#        %Param
#    );
#

sub _TableOutputCalculate {
    my $Self = shift;
    my %Param = @_;
    my %Return = (
        State => 0,
    );
    # check needed stuff
    foreach (qw(CellData ColumnData Width Border)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $RowStart = 'NULL';
    my $ColumnStart = 'NULL';
    my $RowStop;
    my $ColumnStop;

    my $RightCompleteMode = 0;

    # calculate, what cells can output (what cells are aktive)
    my $RowCounter = 0;
    foreach my $Row (@{$Param{CellData}}) {
        my $RowCellsOff = 0;
        for (my $ColumnCounter = 0; $ColumnCounter < scalar(@$Row) ; $ColumnCounter++) {
            # if cells off
            if ($Row->[$ColumnCounter]->{Off} eq 1) {
                $RowCellsOff = 1;
            }
            # calculate RowStart and ColumnStart
            if ($Row->[$ColumnCounter]->{Off} ne 1 &&
                $RowStart eq 'NULL' &&
                $ColumnStart eq 'NULL'
            ) {
                $RowStart = $RowCounter;
                $ColumnStart = $ColumnCounter;
                $ColumnStop = $ColumnCounter;

                # enable RightComplateMode
                if ($RowCellsOff) {
                    $RightCompleteMode = 1;
                }
            }
            # calculate ColumnStop
            if ($RowStart ne 'NULL' &&
                $ColumnStart ne 'NULL' &&
                $ColumnCounter > $ColumnStart &&
                $ColumnCounter > $ColumnStop
            ) {
                $ColumnStop = $ColumnCounter;
            }
        }
        # calculate $RowStop
        if ($RightCompleteMode) {
            if ($RowCellsOff) {
                $RowStop = $RowCounter;
            }
        }
        else {
            $RowStop = $RowCounter;
        }
        $RowCounter++;
    }

    # calculate, what columns can output (giveb width)
    my $ReturnWidth = 0;
    my @ReturnColumns;
    for ($ColumnStart..$ColumnStop) {
        my $BorderAdjustmentWidth = 0;
        # if first column, add Border
        if ($_ eq $ColumnStart) {
            $BorderAdjustmentWidth = $Param{Border};
        }
        # calculate, what columns can output
        if ($ReturnWidth + $Param{ColumnData}->[$_]->{Width} - $BorderAdjustmentWidth <= $Param{Width}) {
            $ReturnWidth += $Param{ColumnData}->[$_]->{Width} - $BorderAdjustmentWidth;
            push (@ReturnColumns, $_);
        }
        else {
            last;
        }
    }
    # calculate, what rows can output
    my @ReturnRows;
    for ($RowStart..$RowStop) {
        push (@ReturnRows, $_);
    }
    # count rows and columns
    my $ReturnRowsCount = 0;
    if (@ReturnRows) {
        $ReturnRowsCount = $#ReturnRows + 1;
    }
    my $ReturnColumnsCount = 0;
    if (@ReturnColumns) {
        $ReturnColumnsCount = $#ReturnColumns  + 1;
    }
    # set returns
    if ($ReturnRowsCount > 0 && $ReturnColumnsCount > 0) {
        $Return{State} = 1;
        $Return{Width} = $ReturnWidth;
        $Return{CellSpaceExtra} = ($Param{Width} - $ReturnWidth) / $ReturnColumnsCount;
        $Return{ReturnRows} = \@ReturnRows;
        $Return{ReturnColumns} = \@ReturnColumns;
    }

    return %Return;
}

#
# _TableCellOutput ()
#
# output a cell of a table
#
#    Return
#        $Return{State}
#
#    %Return = $PDFObject->_TableCellOutput (
#        Width => 70,
#        Height => 40,
#        Text => 'Text',
#        Font => 'Courier',
#        FontSize => 15,
#        FontColor => '#FF0000',
#        Align => 'center',
#        Lead => 20,
#        PaddingTop => 10,
#        PaddingRight => 30,
#        PaddingBottom => 30,
#        PaddingLeft => 10,
#        BackgroundColor => '#101010',
#        Border => 1,
#        BorderColor => '#FF0000',
#    );
#

sub _TableCellOutput {
    my $Self = shift;
    my %Param = @_;
    my %Return = (
        State => 0,
        RequiredWidth => 0,
        RequiredHeight => 0,
        LeftOver => '',
    );
    # check needed stuff
    foreach (qw(Width Height Text Font FontSize FontColor Align Lead
        PaddingTop PaddingRight PaddingBottom PaddingLeft BackgroundColor Border BorderColor)
    ) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }
    my %Dim;
    # get dimension (printable or content)
    if ($Self->DimGet() eq 'printable') {
        %Dim = $Self->_CurPrintableDimGet();
    }
    else {
        %Dim = $Self->_CurContentDimGet();
    }
    # get current position
    my %Position = $Self->_CurPositionGet();

    # output background
    if ($Param{BackgroundColor} ne 'NULL') {
        my $Background = $Self->{Page}->gfx;
        $Background->fillcolor($Param{BackgroundColor});
        $Background->rect($Position{X}, $Position{Y}, $Param{Width}, -($Param{Height}));
        $Background->fill;
    }

    # output top border
    if ($Param{Border} > 0) {
        my $BorderTop = $Self->{Page}->gfx;
        $BorderTop->fillcolor($Param{BorderColor});
        $BorderTop->rect($Position{X}, $Position{Y}, $Param{Width}, -($Param{Border}));
        $BorderTop->fill;
    }
    # output right border
    if ($Param{Border} > 0) {
        my $BorderRight = $Self->{Page}->gfx;
        $BorderRight->fillcolor($Param{BorderColor});
        $BorderRight->rect(($Position{X} + $Param{Width} - $Param{Border}), $Position{Y}, $Param{Border}, -($Param{Height}));
        $BorderRight->fill;
    }
    # output bottom border
    if ($Param{Border} > 0) {
        my $BorderBottom = $Self->{Page}->gfx;
        $BorderBottom->fillcolor($Param{BorderColor});
        $BorderBottom->rect($Position{X}, ($Position{Y} - $Param{Height} + $Param{Border}), $Param{Width}, -($Param{Border}));
        $BorderBottom->fill;
    }
    # output left border
    if ($Param{Border} > 0) {
        my $BorderLeft = $Self->{Page}->gfx;
        $BorderLeft->fillcolor($Param{BorderColor});
        $BorderLeft->rect($Position{X}, $Position{Y}, $Param{Border}, -($Param{Height}));
        $BorderLeft->fill;
    }

    # calculate text start position
    my $TextX = $Position{X} + $Param{Border} + $Param{PaddingLeft};
    my $TextY = $Position{Y} - $Param{Border} - $Param{PaddingTop};
    # calculate width and height of text
    my $TextWidth = $Param{Width} - $Param{PaddingLeft} - $Param{PaddingRight} - (2 * $Param{Border});
    my $TextHeight = $Param{Height} - $Param{PaddingTop} - $Param{PaddingBottom} - (2 * $Param{Border});

    # set new position
    $Self->PositionSet(
        X => $TextX,
        Y => $TextY,
    );

    %Return = $Self->Text(
        Text => $Param{Text},
        Width => $TextWidth,
        Height => $TextHeight,
        Font => $Param{Font},
        FontSize => $Param{FontSize},
        Color => $Param{FontColor},
        Align => $Param{Align},
        Lead => $Param{Lead},
    );

    return %Return;
}

#
# _TextCalculate ()
#
# calculate required values of given text
#
#    Return
#        $Return{State}
#        $Return{RequiredWidth}
#        $Return{RequiredHeight}
#        $Return{LeftOver}
#        $Return{PossibleRows}  # (Array Ref)
#
#    %Return = $PDFObject->_TextCalculate (
#        Text => $Text,      # text
#        Type => 'Cut',      # (ReturnLeftOver|ReturnLeftOverHard|Cut)
#        Width => 300,       # available width
#        Height => 200,      # available height
#        Font => 'Courier',  # font of text
#        FontSize => 6,      # fontsize of text
#        Lead => 20,         # lead
#    );
#

sub _TextCalculate {
    my $Self = shift;
    my %Param = @_;
    my %Return = (
        State => 0,
        RequiredWidth => 0,
        RequiredHeight => 0,
        LeftOver => '',
    );
    my @PossibleRows;
    # check needed stuff
    foreach (qw(Text Type Width Height Font FontSize Lead)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }
    if ($Param{Width} <= 0 || $Param{Height} <= 0 ) {
        $Return{LeftOver} = $Param{Text};
        $Param{Text} = undef;
    }

    my $Counter1 = 0;
    while (defined($Param{Text})) {
        my $Row;
        my $DelPreSpace = 0;
        # get next row of given text
        if ($Param{Text} =~ s/^(.*?)\n(.*)/$2/s) {
            $Row = $1;
        }
        else {
            $Row = $Param{Text};
            $Param{Text} = undef;
        }
        # delete one space at begin of row, if exists
        $Row =~ s/^\s//;

        # calculate width of the row
        my $RowWidth = $Self->_StringWidth (
            Text => $Row,
            Font => $Param{Font},
            FontSize => $Param{FontSize},
        );
        # calculate height of the row
        my $RowHeight = $Param{FontSize};
        if ($Counter1 > 0) {
            $RowHeight += $Param{Lead};
        }

        if ($Return{RequiredHeight} + $RowHeight <= $Param{Height}) {
            # if row is greater then $Param{Width}
            if ($RowWidth > $Param{Width}) {
                # estimate point of cut
                my $Factor = $RowWidth / $Param{Width};
                my $Cut = int(length($Row) / $Factor);

                # cut the row
                my $RowFore = substr($Row, 0, $Cut);
                my $RowRear = substr($Row, $Cut);

                # calculate width of fore row
                my $RowForeWidth = $Self->_StringWidth (
                    Text => $RowFore,
                    Font => $Param{Font},
                    FontSize => $Param{FontSize},
                );

                # caculate exactly point of cut
                while ($RowForeWidth < $Param{Width}) {
                    $RowFore .= substr($RowRear, 0, 1);
                    $RowRear = substr($RowRear, 1);
                    $RowForeWidth = $Self->_StringWidth(
                        Text => $RowFore,
                        Font => $Param{Font},
                        FontSize => $Param{FontSize},
                    );
                }
                while ($RowForeWidth > $Param{Width}) {
                    $RowRear = chop($RowFore) . $RowRear;
                    $RowForeWidth = $Self->_StringWidth(
                        Text => $RowFore,
                        Font => $Param{Font},
                        FontSize => $Param{FontSize},
                    );
                }

                if ($Param{Type} eq 'ReturnLeftOver' || $Param{Type} eq 'Cut') {
                    if ($RowFore =~ /[^\s]$/ && $RowRear =~ /^[^\s]/) {
                        $RowFore =~ s/^(.*)(\s+.+?)$/$1/;
                        if ($2) {
                            $RowRear = $2 . $RowRear;
                        }
                    }
                }

                $Row = $RowFore;
                if ($Param{Text}) {
                    $Param{Text} = $RowRear . "\n" . $Param{Text};
                }
                else {
                    $Param{Text} = $RowRear;
                }
            }

            # delete spaces at end of row, if spaces exists
            $Row =~ s/^(.*)\s$/$1/;
            # add Row to PossibleRows array
            push (@PossibleRows, $Row);
            $Return{RequiredHeight} += $RowHeight;
        }
        else {
            $Return{LeftOver} = $Row;
            if ($Param{Text}) {
                $Return{LeftOver} .= "\n" . $Param{Text};
                $Param{Text} = undef;
            }
        }
        $Counter1++;
    }

    # cut text if type is Cut
    if ($Param{Type} eq 'Cut' && $Return{LeftOver}) {
        my $LastRow = $PossibleRows[$#PossibleRows];
        if ($LastRow) {
            # calculate width [..]
            my $PPWidth = $Self->_StringWidth (
                Text => '[..]',
                Font => $Param{Font},
                FontSize => $Param{FontSize},
            );
            if ($PPWidth <= $Param{Width}) {
                # calculate width of LastRow and [..]
                my $TextCutWidth = $Self->_StringWidth (
                    Text => $LastRow,
                    Font => $Param{Font},
                    FontSize => $Param{FontSize},
                );
                # calculate last line
                while ($TextCutWidth + $PPWidth > $Param{Width}) {
                    chop($LastRow);
                    # calculate width of shorted LastRow and [..]
                    $TextCutWidth = $Self->_StringWidth (
                        Text => $LastRow,
                        Font => $Param{Font},
                        FontSize => $Param{FontSize},
                    );
                }
                $PossibleRows[$#PossibleRows] = $LastRow . '[..]';

            }
            $Return{LeftOver} = '';
        }
    }

    # calculate RequiredWidth
    my $Counter2 = 0;
    foreach (@PossibleRows) {
        my $RowWidth = $Self->_StringWidth (
            Text => $_,
            Font => $Param{Font},
            FontSize => $Param{FontSize},
        );
        # set new RequiredWidth
        if ($RowWidth > $Return{RequiredWidth}) {
            $Return{RequiredWidth} = $RowWidth;
        }

        $Counter2++;
    }
    # correct RequiredHeight
    if ($Return{RequiredWidth} eq 0) {
        $Return{RequiredHeight} = 0;
    }

    # set state
    if (!$Return{LeftOver}) {
        $Return{State} = 1;
    }

    $Return{PossibleRows} = \@PossibleRows;
    return %Return;
}

#
# _StringWidth ()
#
# calculate width of given text
#
#    $Width = $PDFObject->_StringWidth (
#        Text => 'Text',     # text
#        Font => 'Courier',  # font of text
#        FontSize => 6,      # fontsize of text
#    );
#

sub _StringWidth {
    my $Self = shift;
    my %Param = @_;
    my $StringWidth;
    # check needed stuff
    foreach (qw(Text Font FontSize)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if (length($Param{Text}) > 30 ||
        !defined($Self->{Cache}->{StringWidth}->{$Param{Font}}->{$Param{FontSize}}->{$Param{Text}})
    ) {
        # create a text object
        my $Text = $Self->{Page}->text;
        # set font and fontsize
        $Text->font($Self->{Font}->{$Param{Font}}, $Param{FontSize});
        # calculate width of given text
        $StringWidth = $Text->advancewidth($Param{Text});
        # write width to cache
        $Self->{Cache}->{StringWidth}->{$Param{Font}}->{$Param{FontSize}}->{$Param{Text}} = $StringWidth;
    }
    else {
        # get width from cache
        $StringWidth = $Self->{Cache}->{StringWidth}->{$Param{Font}}->{$Param{FontSize}}->{$Param{Text}};
    }

    return $StringWidth;
}

#
# _CurPageNumberSet ()
#
# set number of current page
#
#    $PDFObject->_CurPageNumberSet (
#        ShowPageNumber => 0,  # (optional) default 1
#    );
#

sub _CurPageNumberSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    # set number of all over pages to 0, if first page
    if (!defined($Self->{Current}->{Page})) {
        $Self->{Current}->{Page} = 0;
    }
    # set number of displayed pages to 0, if first page
    if (!defined($Self->{Current}->{PageNumber})) {
        $Self->{Current}->{PageNumber} = 0;
    }
    # increment all over pages
    $Self->{Current}->{Page}++;

    # set page number of current page
    if ($Param{ShowPageNumber} eq 0) {
        $Self->{PageData}->{$Self->{Current}->{Page}}->{PageNumber} = '';
    }
    else {
        $Self->{Current}->{PageNumber}++;
        $Self->{PageData}->{$Self->{Current}->{Page}}->{PageNumber} = $Self->{Current}->{PageNumber};
    }

    return 1;
}

#
# _CurPageDimSet ()
#
# Set current Page Dimension
#
#    $PDFObject->_CurPageDimSet (
#        Width => 123,                    # (optional) default 595 (Din A4)
#        Height => 321,                   # (optional) default 842 (Din A4)
#        PageOrientation => 'landscape',  # (optional) (normal|landscape)
#    );
#

sub _CurPageDimSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $NewValue;
    # set CurPageWidth
    if (defined($Param{Width}) && $Param{Width} >= 100 && $Param{Width} <= 10000) {
        $Self->{Current}->{PageWidth} = int($Param{Width});
        $NewValue = 1;
    }
    # set CurPageHeight
    if (defined($Param{Height}) && $Param{Height} >= 100 && $Param{Height} <= 10000) {
        $Self->{Current}->{PageHeight} = int($Param{Height});
        $NewValue = 1;
    }
    # get default pagesize
    my $DefaultWidth = 595;   # DIN A4
    my $DefaultHeight = 842;  # DIN A4
    if ($Self->{ConfigObject}->Get('PDF::PageSize') eq 'letter') {
        $DefaultWidth = 612;
        $DefaultHeight = 792;
    }
    # set page orientation
    if (defined($Param{PageOrientation}) && $Param{PageOrientation} eq 'landscape') {
        my $TmpWidth = $DefaultWidth;
        $DefaultWidth = $DefaultHeight;
        $DefaultHeight = $TmpWidth;
    }

    # set default values
    if (!defined($Self->{Current}->{PageWidth})) {
        $Self->{Current}->{PageWidth} = $DefaultWidth;
        $NewValue = 1;
    }
    if (!defined($Self->{Current}->{PageHeight})) {
        $Self->{Current}->{PageHeight} = $DefaultHeight;
        $NewValue = 1;
    }

    if ($NewValue) {
        # set new printable dimension
        $Self->{Current}->{PrintableTop} = 0;
        $Self->{Current}->{PrintableRight} = 0;
        $Self->{Current}->{PrintableBottom} = 0;
        $Self->{Current}->{PrintableLeft} = 0;
        $Self->{Current}->{PrintableWidth} = $Self->{Current}->{PageWidth};
        $Self->{Current}->{PrintableHeight} = $Self->{Current}->{PageHeight};
        # set new content dimension
        $Self->{Current}->{ContentTop} = $Self->{Current}->{PrintableTop};
        $Self->{Current}->{ContentRight} = $Self->{Current}->{PrintableRight};
        $Self->{Current}->{ContentBottom} = $Self->{Current}->{PrintableBottom};
        $Self->{Current}->{ContentLeft} = $Self->{Current}->{PrintableLeft};
        $Self->{Current}->{ContentWidth} = $Self->{Current}->{PrintableWidth};
        $Self->{Current}->{ContentHeight} = $Self->{Current}->{PrintableHeight};
        # set new current position
        $Self->{Current}->{PositionX} = $Self->{Current}->{ContentLeft};
        $Self->{Current}->{PositionY} = $Self->{Current}->{PageHeight} - $Self->{Current}->{ContentTop};
    }

    return 1;
}

#
# _CurPageDimGet ()
#
# Get current Page Dimension (Width, Height)
#
#    Return
#        $CurPageDim{Width}
#        $CurPageDim{Height}
#
#    %CurPageDim = $PDFObject->_CurPageDimGet ();
#

sub _CurPageDimGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if (!$Self->{Current}->{PageWidth} || !$Self->{Current}->{PageHeight}) {
        $Self->_CurPageDimSet();
    }

    my %Data;
    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        $Data{Width} = $Self->{Current}->{PageWidth};
        $Data{Height} = $Self->{Current}->{PageHeight};
    }

    return %Data;
}

#
# _CurPageDimCheck ()
#
# Check given X an/or Y if inside the page dimension
#
#    $True = $PDFObject->_CurPageDimCheck (
#        X => 200,  # (optional)
#        Y => 100,  # (optional)
#    );
#

sub _CurPageDimCheck {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $Return = 0;
    my %Page = $Self->_CurPageDimGet();

    if (defined($Param{X})) {
        if ($Param{X} >= 0 && $Param{X} <= $Page{Width}) {
            $Return = 1;
        }
    }

    if (defined($Param{Y})) {
        if ($Param{Y} >= 0 && $Param{Y} <= $Page{Height}) {
            $Return = 1;
        }
    }

    return $Return;
}

#
# _CurPrintableDimSet ()
#
# Set current Printable Dimension
#
#    $True = $PDFObject->_CurPrintableDimSet (
#        Top => 20,     # (optional)
#        Right => 20,   # (optional)
#        Bottom => 20,  # (optional)
#        Left => 20,    # (optional)
#    );
#

sub _CurPrintableDimSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        my $NewValue;
        # set CurPrintableTop
        if (defined($Param{Top}) &&
            $Param{Top} > 0 &&
            $Param{Top} < $Self->{Current}->{PageHeight} / 2
        ) {
            $Self->{Current}->{PrintableTop} = $Param{Top};
            $NewValue = 1;
        }
        # set CurPrintableRight
        if (defined($Param{Right}) &&
            $Param{Right} > 0 &&
            $Param{Right} < $Self->{Current}->{PageWidth} / 2
        ) {
            $Self->{Current}->{PrintableRight} = $Param{Right};
            $NewValue = 1;
        }
        # set CurPrintableBottom
        if (defined($Param{Bottom}) &&
            $Param{Bottom} > 0 &&
            $Param{Bottom} < $Self->{Current}->{PageHeight} / 2
        ) {
            $Self->{Current}->{PrintableBottom} = $Param{Bottom};
            $NewValue = 1;
        }
        # set CurPrintableLeft
        if (defined($Param{Left}) &&
            $Param{Left} > 0 &&
            $Param{Left} < $Self->{Current}->{PageWidth} / 2
        ) {
            $Self->{Current}->{PrintableLeft} = $Param{Left};
            $NewValue = 1;
        }

        if ($NewValue) {
            # calculate new printable width and height
            $Self->{Current}->{PrintableWidth} =
                $Self->{Current}->{PageWidth} -
                $Self->{Current}->{PrintableLeft} -
                $Self->{Current}->{PrintableRight};
            $Self->{Current}->{PrintableHeight} =
                $Self->{Current}->{PageHeight} -
                $Self->{Current}->{PrintableTop} -
                $Self->{Current}->{PrintableBottom};
            # set new content dimension
            $Self->{Current}->{ContentTop} = $Self->{Current}->{PrintableTop};
            $Self->{Current}->{ContentRight} = $Self->{Current}->{PrintableRight};
            $Self->{Current}->{ContentBottom} = $Self->{Current}->{PrintableBottom};
            $Self->{Current}->{ContentLeft} = $Self->{Current}->{PrintableLeft};
            $Self->{Current}->{ContentWidth} = $Self->{Current}->{PrintableWidth};
            $Self->{Current}->{ContentHeight} = $Self->{Current}->{PrintableHeight};
            # set new current position
            $Self->{Current}->{PositionX} = $Self->{Current}->{ContentLeft};
            $Self->{Current}->{PositionY} = $Self->{Current}->{PageHeight} - $Self->{Current}->{ContentTop};
        }
    }

    return 1;
}

#
# _CurPrintableDimGet ()
#
# Get current Printable Dimension
#
#    Return
#        $CurPrintableDim{Top}
#        $CurPrintableDim{Right}
#        $CurPrintableDim{Bottom}
#        $CurPrintableDim{Left}
#        $CurPrintableDim{Width}
#        $CurPrintableDim{Height}
#
#    %CurPrintableDim = $PDFObject->_CurPrintableDimGet ();
#

sub _CurPrintableDimGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Data;
    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        $Data{Top} = $Self->{Current}->{PrintableTop};
        $Data{Right} = $Self->{Current}->{PrintableRight};
        $Data{Bottom} = $Self->{Current}->{PrintableBottom};
        $Data{Left} = $Self->{Current}->{PrintableLeft};
        $Data{Width} = $Self->{Current}->{PrintableWidth};
        $Data{Height} = $Self->{Current}->{PrintableHeight};
    }

    return %Data;
}

#
# _CurPrintableDimCheck ()
#
# Check given X an/or Y if inside the printable dimension
#
#    $True = $PDFObject->_CurPrintableDimCheck (
#        X => 200,  # (optional)
#        Y => 100,  # (optional)
#    );
#

sub _CurPrintableDimCheck {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $Return = 0;
    my %Printable = $Self->_CurPrintableDimGet();

    if (defined($Param{X})) {
        if ($Param{X} >= $Printable{Left} && $Param{X} <= ($Printable{Left} + $Printable{Width})) {
            $Return = 1;
        }
    }

    if (defined($Param{Y})) {
        if ($Param{Y} >= $Printable{Bottom} && $Param{Y} <= ($Printable{Bottom} + $Printable{Height})) {
            $Return = 1;
        }
    }

    return $Return;
}

#
# _CurContentDimSet ()
#
# Set current Content Dimension
#
#    $True = $PDFObject->_CurContentDimSet (
#        Top => 20,     # (optional)
#        Right => 20,   # (optional)
#        Bottom => 20,  # (optional)
#        Left => 20,    # (optional)
#    );
#

sub _CurContentDimSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        my $NewValue;
        # set CurContentTop
        if (defined($Param{Top}) &&
            $Param{Top} >= $Self->{Current}->{PrintableTop} &&
            $Param{Top} < $Self->{Current}->{PageHeight} / 2
        ) {
            $Self->{Current}->{ContentTop} = $Param{Top};
            $NewValue = 1;
        }
        # set CurContentRight
        if (defined($Param{Right}) &&
            $Param{Right} >= $Self->{Current}->{PrintableRight} &&
            $Param{Right} < $Self->{Current}->{PageWidth} / 2
        ) {
            $Self->{Current}->{ContentRight} = $Param{Right};
            $NewValue = 1;
        }
        # set CurContentBottom
        if (defined($Param{Bottom}) &&
            $Param{Bottom} >= $Self->{Current}->{PrintableBottom} &&
            $Param{Bottom} < $Self->{Current}->{PageHeight} / 2
        ) {
            $Self->{Current}->{ContentBottom} = $Param{Bottom};
            $NewValue = 1;
        }
        # set CurContentLeft
        if (defined($Param{Left}) &&
            $Param{Left} >= $Self->{Current}->{PrintableLeft} &&
            $Param{Left} < $Self->{Current}->{PageWidth} / 2
        ) {
            $Self->{Current}->{ContentLeft} = $Param{Left};
            $NewValue = 1;
        }

        if ($NewValue) {
            # calculate new content width and height
            $Self->{Current}->{ContentWidth} =
                $Self->{Current}->{PageWidth} -
                $Self->{Current}->{ContentLeft} -
                $Self->{Current}->{ContentRight};
            $Self->{Current}->{ContentHeight} =
                $Self->{Current}->{PageHeight} -
                $Self->{Current}->{ContentTop} -
                $Self->{Current}->{ContentBottom};
            # set new current position
            $Self->{Current}->{PositionX} = $Self->{Current}->{ContentLeft};
            $Self->{Current}->{PositionY} = $Self->{Current}->{PageHeight} - $Self->{Current}->{ContentTop};
        }
    }

    return 1;
}

#
# _CurContentDimGet ()
#
# Get current Content Dimension
#
#    Return
#        $CurContentDim{Top}
#        $CurContentDim{Right}
#        $CurContentDim{Bottom}
#        $CurContentDim{Left}
#        $CurContentDim{Width}
#        $CurContentDim{Height}
#
#    %CurContentDim = $PDFObject->_CurContentDimGet ();
#

sub _CurContentDimGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Data;
    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        $Data{Top} = $Self->{Current}->{ContentTop};
        $Data{Right} = $Self->{Current}->{ContentRight};
        $Data{Bottom} = $Self->{Current}->{ContentBottom};
        $Data{Left} = $Self->{Current}->{ContentLeft};
        $Data{Width} = $Self->{Current}->{ContentWidth};
        $Data{Height} = $Self->{Current}->{ContentHeight};
    }

    return %Data;
}

#
# _CurContentDimCheck ()
#
# Check given X an/or Y if inside the content dimension
#
#    $True = $PDFObject->_CurContentDimCheck (
#        X => 200,  # (optional)
#        Y => 100,  # (optional)
#    );
#

sub _CurContentDimCheck {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my $Return = 0;
    my %Content = $Self->_CurContentDimGet();

    if (defined($Param{X})) {
        if ($Param{X} >= $Content{Left} && $Param{X} <= ($Content{Left} + $Content{Width})) {
            $Return = 1;
        }
    }

    if (defined($Param{Y})) {
        if ($Param{Y} >= $Content{Bottom} && $Param{Y} <= ($Content{Bottom} + $Content{Height})) {
            $Return = 1;
        }
    }

    return $Return;
}

#
# _CurPositionSet ()
#
# Set current Position
#
#    $True = $PDFObject->_CurPositionSet (
#        X => 20,  # (optional)
#        Y => 20,  # (optional)
#    );
#

sub _CurPositionSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        if ($Self->DimGet() eq 'printable') {
            if (defined($Param{X}) &&
                $Param{X} >= $Self->{Current}->{PrintableLeft} &&
                $Param{X} <= $Self->{Current}->{PageWidth} - $Self->{Current}->{PrintableRight}
            ) {
                $Self->{Current}->{PositionX} = $Param{X};
            }
            if (defined($Param{Y}) &&
                $Param{Y} <= $Self->{Current}->{PageHeight} - $Self->{Current}->{PrintableTop} &&
                $Param{Y} >= $Self->{Current}->{PrintableBottom}
            ) {
                $Self->{Current}->{PositionY} = $Param{Y};
            }
        }
        else {
            if (defined($Param{X}) &&
                $Param{X} >= $Self->{Current}->{ContentLeft} &&
                $Param{X} <= $Self->{Current}->{PageWidth} - $Self->{Current}->{ContentRight}
            ) {
                $Self->{Current}->{PositionX} = $Param{X};
            }
            if (defined($Param{Y}) &&
                $Param{Y} <= $Self->{Current}->{PageHeight} - $Self->{Current}->{ContentTop} &&
                $Param{Y} >= $Self->{Current}->{ContentBottom}
            ) {
                $Self->{Current}->{PositionY} = $Param{Y};
            }
        }
    }

    return 1;
}

#
# _CurPositionGet ()
#
# Get current Position
#
#    Return
#        $CurPosition{X}
#        $CurPosition{Y}
#
#    %CurPosition = $PDFObject->_CurPositionGet ();
#

sub _CurPositionGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Self->{PDF}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a PDF Document!");
        return;
    }
    if (!$Self->{Page}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need a Page!");
        return;
    }

    my %Data;
    if ($Self->{Current}->{PageWidth} && $Self->{Current}->{PageHeight}) {
        $Data{X} = $Self->{Current}->{PositionX};
        $Data{Y} = $Self->{Current}->{PositionY};
    }

    return %Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.2 $ $Date: 2006-07-31 15:22:25 $

=cut
