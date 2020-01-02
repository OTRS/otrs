# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::HeaderMeta::AgentTicketSearch;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Session = '';
    if ( !$LayoutObject->{SessionIDCookie} ) {
        $Session = ';' . $LayoutObject->{SessionName} . '='
            . $LayoutObject->{SessionID};
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Title = $ConfigObject->Get('ProductName');
    $Title .= ' (' . $ConfigObject->Get('Ticket::Hook') . ')';
    $LayoutObject->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => $LayoutObject->{Baselink} . 'Action=' . $Param{Config}->{Action}
                . ';Subaction=OpenSearchDescriptionTicketNumber' . $Session,
        },
    );

    my $Fulltext = $LayoutObject->{LanguageObject}->Translate('Fulltext');
    $Title = $ConfigObject->Get('ProductName');
    $Title .= ' (' . $Fulltext . ')';
    $LayoutObject->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => $LayoutObject->{Baselink} . 'Action=' . $Param{Config}->{Action}
                . ';Subaction=OpenSearchDescriptionFulltext' . $Session,
        },
    );
    return 1;
}

1;
