# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::PDF::Statistics;

## nofilter(TidyAll::Plugin::OTRS::Perl::PodChecker)

use strict;
use warnings;

use List::Util qw( first );

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::PDF',
    'Kernel::System::User',
);

use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GeneratePDF {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Stat Title HeadArrayRef StatArray)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Title        = $Param{Title};
    my $HeadArrayRef = $Param{HeadArrayRef};
    my $Stat         = $Param{Stat};
    my @StatArray    = @{ $Param{StatArray} // [] };

    my $PDFObject    = $Kernel::OM->Get('Kernel::System::PDF');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Page = $LayoutObject->{LanguageObject}->Translate('Page');
    my $Time = $LayoutObject->{Time};

    # get maximum number of pages
    my $MaxPages = $ConfigObject->Get('PDF::MaxPages');
    if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
        $MaxPages = 100;
    }

    # create the header
    my $CellData;
    my $CounterRow  = 0;
    my $CounterHead = 0;
    for my $Content ( @{$HeadArrayRef} ) {
        $CellData->[$CounterRow]->[$CounterHead]->{Content} = $Content;
        $CellData->[$CounterRow]->[$CounterHead]->{Font}    = 'ProportionalBold';
        $CounterHead++;
    }
    if ( $CounterHead > 0 ) {
        $CounterRow++;
    }

    # create the content array
    for my $Row (@StatArray) {
        my $CounterColumn = 0;
        for my $Content ( @{$Row} ) {
            $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
            $CounterColumn++;
        }
        $CounterRow++;
    }

    # output 'No matches found', if no content was given
    if ( !$CellData->[0]->[0] ) {
        $CellData->[0]->[0]->{Content} = $LayoutObject->{LanguageObject}->Translate('No matches found.');
    }

    # page params
    my %PageParam;
    $PageParam{PageOrientation} = 'landscape';
    $PageParam{MarginTop}       = 30;
    $PageParam{MarginRight}     = 40;
    $PageParam{MarginBottom}    = 40;
    $PageParam{MarginLeft}      = 40;
    $PageParam{HeaderRight}     = $ConfigObject->Get('Stats::StatsHook') . $Stat->{StatNumber};
    $PageParam{HeadlineLeft}    = $Title;

    # table params
    my %TableParam;
    $TableParam{CellData}            = $CellData;
    $TableParam{Type}                = 'Cut';
    $TableParam{FontSize}            = 6;
    $TableParam{Border}              = 0;
    $TableParam{BackgroundColorEven} = '#DDDDDD';
    $TableParam{Padding}             = 4;

    # create new pdf document
    $PDFObject->DocumentNew(
        Title  => $ConfigObject->Get('Product') . ': ' . $Title,
        Encode => $LayoutObject->{UserCharset},
    );

    # start table output
    $PDFObject->PageNew(
        %PageParam,
        FooterRight => $Page . ' 1',
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # output title
    $PDFObject->Text(
        Text     => $Title,
        FontSize => 13,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # output "printed by"
    $PDFObject->Text(
        Text     => $Time,
        FontSize => 9,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -14,
    );

    COUNT:
    for ( 2 .. $MaxPages ) {

        # output table (or a fragment of it)
        %TableParam = $PDFObject->Table( %TableParam, );

        # stop output or output next page
        last COUNT if $TableParam{State};

        $PDFObject->PageNew(
            %PageParam,
            FooterRight => $Page . ' ' . $_,
        );
    }

    return $PDFObject->DocumentOutput();
}

1;
