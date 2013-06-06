# --
# Kernel/Output/HTML/TicketOverviewMenuSort.pm
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: TicketOverviewMenuSort.pm,v 1.26 2012/11/20 15:04:18 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketOverviewMenuSort;

use strict;
use warnings;

use Kernel::Language;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Action UserID ConfigObject LogObject LayoutObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{LanguageObject} = $Self->{LayoutObject}->{LanguageObject}
        || Kernel::Language->new(
                %{$Self},
                UserLanguage => $Self->{LayoutObject}->{UserLanguage},
            );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SortConfiguration = $Self->{ConfigObject}->Get('TicketOverviewMenuSort')->{SortAttributes} || {
        Age   => 1,
        Title => 1,
    };

    if ( !IsHashRefWithData($SortConfiguration) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Wrong configuration 'TicketOverviewMenuSort###SortAttributes' for ticket overview sort options.",
        );
        return;
    }

    my @SortData;
    my $SelectedSortByOption;
    for my $CurrentSortByOption ( keys %{ $SortConfiguration } ) {

        # add separator
        if (@SortData) {
            push @SortData, {
                Key      => '-',
                Value    => '---',
                Disabled => 1,
            };
        }

        my $TranslatedValue =
            $Self->{LanguageObject}->Get( 'Order by' ) . ' "' .
            $Self->{LanguageObject}->Get( $CurrentSortByOption ) . '"';

        for my $CurrentOrderBy ( qw(Down Up) ) {

            my $Selected = 0;
            if (
                $CurrentSortByOption eq $Param{SortBy}
                && $CurrentOrderBy eq $Param{OrderBy}
            ) {
                $Selected = 1;
                $SelectedSortByOption = 1;
            }

            my $OrderByTranslation = $CurrentOrderBy eq 'Down' ? 'ascending' : 'descending';
            $OrderByTranslation = $Self->{LanguageObject}->Get($OrderByTranslation);

            push @SortData, {
                Key      => "$CurrentSortByOption|$CurrentOrderBy",
                Value    => "$TranslatedValue ($OrderByTranslation)",
                Selected => $Selected,
            };
        }

    }

    return if !@SortData;

    my %ReturnData;
    $ReturnData{HTML} = $Self->{LayoutObject}->BuildSelection(
        Data       => \@SortData,
        Name       => 'SortBy',
        Title      => $Self->{LanguageObject}->Get('Order by') ,
    );

    return if !$ReturnData{HTML};

    # build redirect param hash for Core.App.InternalRedirect
    my $RedirectParams = "Action: '$Self->{Action}',\n";
    for my $PossibleParam ( qw(Filter) ) {
        if ( $Param{ $PossibleParam } ) {
            $RedirectParams .= "$PossibleParam: '$Param{ $PossibleParam }',\n";
        }
    }

    if ( $Param{LinkFilter} ) {
        my @SplittedLinkFilters = split(/[;&]/, $Param{LinkFilter});
        for my $CurrentLinkFilter ( sort @SplittedLinkFilters ) {
            my @KeyValue = split(/=/, $CurrentLinkFilter);
            $RedirectParams .= "$KeyValue[0]: '$KeyValue[1]',\n";
        }
    }

    $ReturnData{HTML} .= <<"JS";
<!-- dtl:js_on_document_complete -->
<script type="text/javascript">//<![CDATA[
\$("#SortBy").change(function(){
    var Selection = \$(this).val().split('|');
    if ( Selection.length === 2 ) {
        Core.App.InternalRedirect({
            ${RedirectParams}
            SortBy: Selection[0],
            OrderBy: Selection[1],
        });
    }
});
//]]></script>
<!-- dtl:js_on_document_complete -->
JS

    $ReturnData{HTML} = '<li class="AlwaysPresent SortBy">'
        . $ReturnData{HTML}
        . '</li>';

    $ReturnData{Block} = 'DocumentActionRowHTML';

    return \%ReturnData;
}

1;
