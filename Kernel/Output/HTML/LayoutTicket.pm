# --
# Kernel/Output/HTML/LayoutTicket.pm - provides generic ticket HTML output
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LayoutTicket.pm,v 1.23 2008-07-03 13:50:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutTicket;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

sub TicketStdResponseString {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(StdResponsesRef TicketID ArticleID)) {
        if ( !$Param{$_} ) {
            return "Need $_ in TicketStdResponseString()";
        }
    }

    # get StdResponsesStrg
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::StdResponsesMode') eq 'Form' ) {

        # build html string
        $Param{StdResponsesStrg}
            .= '<form action="'
            . $Self->{CGIHandle}
            . '" method="post">'
            . '<input type="hidden" name="Action" value="AgentTicketCompose"/>'
            . '<input type="hidden" name="ArticleID" value="'
            . $Param{ArticleID} . '"/>'
            . '<input type="hidden" name="TicketID" value="'
            . $Param{TicketID} . '"/>'
            . $Self->OptionStrgHashRef(
            Name => 'ResponseID',
            Data => $Param{StdResponsesRef},
            ) . '<input class="button" type="submit" value="$Text{"Compose"}"/></form>';
    }
    else {
        my %StdResponses = %{ $Param{StdResponsesRef} };
        for ( sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses ) {

            # build html string
            $Param{StdResponsesStrg}
                .= "\n<li><a href=\"$Self->{Baselink}"
                . "Action=AgentTicketCompose&"
                . "ResponseID=$_&TicketID=$Param{TicketID}&ArticleID=$Param{ArticleID}\" "
                . 'onmouseover="window.status=\'$Text{"Compose"}\'; return true;" '
                . 'onmouseout="window.status=\'\';">'
                .

                # html quote
                $Self->Ascii2Html( Text => $StdResponses{$_} ) . "</A></li>\n";
        }
    }
    return $Param{StdResponsesStrg};
}

sub AgentCustomerView {
    my ( $Self, %Param ) = @_;

    $Param{Table} = $Self->AgentCustomerViewTable(%Param);

    # create & return output
    return $Self->Output( TemplateFile => 'AgentCustomerView', Data => \%Param );
}

sub AgentCustomerViewTable {
    my ( $Self, %Param ) = @_;

    my $ShownType = 1;
    my @MapNew    = ();
    if ( ref( $Param{Data} ) ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Data param' );
    }
    elsif ( ref( $Param{Data} ) eq 'HASH' && !%{ $Param{Data} } ) {
        return '$Text{"none"}';
    }
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Map) {
        @MapNew = ( @{$Map} );
    }

    # check if customer company support is enabled
    if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
        if ($Map2) {
            push( @MapNew, @{$Map2} );
        }
    }
    if ( $Param{Type} && $Param{Type} eq 'Lite' ) {
        $ShownType = 2;

        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        for my $Field (@MapNew) {
            if ( $Field->[3] == 2 ) {
                $Used = 1;
            }
        }
        if ( !$Used ) {
            $ShownType = 1;
        }
    }

    # build html table
    for my $Field (@MapNew) {
        if ( $Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{ $Field->[0] } ) {
            my %Record = ();
            if ( $Field->[6] ) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\">";
                $Record{LinkStop}  = "</a>";
            }
            if ( $Field->[0] ) {
                $Record{ValueShort} = $Self->Ascii2Html(
                    Text => $Param{Data}->{ $Field->[0] },
                    Max  => $Param{Max}
                );
            }
            $Self->Block(
                Name => 'CustomerRow',
                Data => {
                    %{ $Param{Data} },
                    Key   => $Field->[1],
                    Value => $Param{Data}->{ $Field->[0] },
                    %Record,
                },
            );
        }
    }

    # create & return output
    return $Self->Output( TemplateFile => 'AgentCustomerTableView', Data => \%Param );
}

# AgentQueueListOption()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.

sub AgentQueueListOption {
    my ( $Self, %Param ) = @_;

    my $Size       = $Param{Size}                  ? "size='$Param{Size}'" : '';
    my $MaxLevel   = defined( $Param{MaxLevel} )   ? $Param{MaxLevel}      : 10;
    my $SelectedID = defined( $Param{SelectedID} ) ? $Param{SelectedID}    : '';
    my $Selected   = defined( $Param{Selected} )   ? $Param{Selected}      : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit} : '';
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    else {
        $OnChangeSubmit = '';
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need Depend Param Ajax option!",
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need Update Param Ajax option()!",
            );
            $Self->FatalError();
        }
        $Param{OnChange} = "AJAXUpdate('" . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Depend} } ) . "'], ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    if ( $Param{OnChange} ) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'list' ) {
        $Param{'MoveQueuesStrg'} = $Self->OptionStrgHashRef( %Param, HTMLQuote => 0, );
        return $Param{MoveQueuesStrg};
    }

    # build tree list
    $Param{MoveQueuesStrg}
        = '<select name="' . $Param{Name} . "\" $Size $Multiple $OnChangeSubmit>\n";
    my %UsedData = ();
    my %Data     = ();
    if ( $Param{Data} && ref( $Param{Data} ) eq 'HASH' ) {
        %Data = %{ $Param{Data} };
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }

    # add suffix for correct sorting
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        $Data{$_} .= '::';
    }

    # build selection string
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        my @Queue = split( /::/, $Param{Data}->{$_} );
        $UsedData{ $Param{Data}->{$_} } = 1;
        my $UpQueue = $Param{Data}->{$_};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        if ( !$Queue[$MaxLevel] && $Queue[-1] ne '' ) {
            $Queue[-1] = $Self->Ascii2Html( Text => $Queue[-1], Max => 50 - $#Queue );
            my $Space = '';
            for ( my $i = 0; $i < $#Queue; $i++ ) {
                $Space .= '&nbsp;&nbsp;';
            }

            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                for my $ID ( @{$SelectedIDRefArray} ) {
                    if ( $ID eq $_ ) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }

            # build select string
            if ( $UsedData{$UpQueue} ) {
                if (
                    $SelectedID  eq $_
                    || $Selected eq $Param{Data}->{$_}
                    || $Param{SelectedIDRefArrayOK}->{$_}
                    )
                {
                    $Param{MoveQueuesStrg}
                        .= '<option selected value="'
                        . $_ . '">'
                        . $Space
                        . $Queue[-1]
                        . "</option>\n";
                }
                else {
                    $Param{MoveQueuesStrg}
                        .= '<option value="' . $_ . '">' . $Space . $Queue[-1] . "</option>\n";
                }
            }
        }
    }
    $Param{MoveQueuesStrg} .= "</select>\n";
    $Param{MoveQueuesStrg} .= "<a id=\"AJAXImage$Param{Name}\"></a>\n";

    return $Param{MoveQueuesStrg};
}

sub AgentFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {

        #        $NullOption{''} = '-';
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for ( 1 .. 16 ) {

        # key
        if ( ref( $Config{"TicketFreeKey$_"} ) eq 'HASH' && %{ $Config{"TicketFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"TicketFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"TicketFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => { %NullOption, %{ $Config{"TicketFreeKey$_"} }, },
                    Name => "TicketFreeKey$_",
                    SelectedID          => $Ticket{"TicketFreeKey$_"},
                    SelectedIDRefArray  => $Ticket{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"}
                        = $Config{"TicketFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="TicketFreeKey'
                        . $_
                        . '" value="'
                        . $Self->{LayoutObject}->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined( $Ticket{"TicketFreeKey$_"} ) ) {
                if ( ref( $Ticket{"TicketFreeKey$_"} ) eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeKey$_"}->[0] ) {
                        $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeKey$_"} = '';
                    }
                }
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" name="TicketFreeKey'
                    . $_
                    . '" value="'
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Ticket{"TicketFreeKey$_"} )
                    . '" size="18"/>';
            }
            else {
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" name="TicketFreeKey' . $_ . '" value="" size="18"/>';
            }
        }

        # value
        if ( ref( $Config{"TicketFreeText$_"} ) eq 'HASH' ) {
            $Data{"TicketFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => { %NullOption, %{ $Config{"TicketFreeText$_"} }, },
                Name => "TicketFreeText$_",
                SelectedID          => $Ticket{"TicketFreeText$_"},
                SelectedIDRefArray  => $Ticket{"TicketFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                %SelectData,
            );
        }
        else {
            if ( defined( $Ticket{"TicketFreeText$_"} ) ) {
                if ( ref( $Ticket{"TicketFreeText$_"} ) eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeText$_"}->[0] ) {
                        $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeText$_"} = '';
                    }
                }
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" name="TicketFreeText'
                    . $_
                    . '" value="'
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Ticket{"TicketFreeText$_"} )
                    . '" size="30"/>';
            }
            else {
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" name="TicketFreeText' . $_ . '" value="" size="30"/>';
            }
        }
        $Data{"TicketFreeTextField$_"}
            .= '<font color="red" size="-2">$Text{"$Data{"TicketFreeTextField'
            . $_
            . ' invalid"}"}</font>';
    }
    return %Data;
}

sub AgentFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();

    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod = ();
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            %Param,
            %Ticket,
            Prefix   => 'TicketFreeTime' . $Count,
            Format   => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            %TimePeriod,
        );
    }
    return %Data;
}

sub TicketArticleFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Article    = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Article} ) {
        %Article = %{ $Param{Article} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for ( 1 .. 3 ) {

        # key
        if ( ref( $Config{"ArticleFreeKey$_"} ) eq 'HASH' && %{ $Config{"ArticleFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"ArticleFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"} = $Config{"ArticleFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"ArticleFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => { %NullOption, %{ $Config{"ArticleFreeKey$_"} }, },
                    Name => "ArticleFreeKey$_",
                    SelectedID          => $Article{"ArticleFreeKey$_"},
                    SelectedIDRefArray  => $Article{"ArticleFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"}
                        = $Config{"ArticleFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="ArticleFreeKey'
                        . $_
                        . '" value="'
                        . $Self->{LayoutObject}->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined( $Article{"ArticleFreeKey$_"} ) ) {
                if ( ref( $Article{"ArticleFreeKey$_"} ) eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeKey$_"}->[0] ) {
                        $Article{"ArticleFreeKey$_"} = $Article{"ArticleFreeKey$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeKey$_"} = '';
                    }
                }
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" name="ArticleFreeKey'
                    . $_
                    . '" value="'
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Article{"ArticleFreeKey$_"} )
                    . '" size="18"/>';
            }
            else {
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" name="ArticleFreeKey' . $_ . '" value="" size="18"/>';
            }
        }

        # value
        if ( ref( $Config{"ArticleFreeText$_"} ) eq 'HASH' ) {
            $Data{"ArticleFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => { %NullOption, %{ $Config{"ArticleFreeText$_"} }, },
                Name => "ArticleFreeText$_",
                SelectedID          => $Article{"ArticleFreeText$_"},
                SelectedIDRefArray  => $Article{"ArticleFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                %SelectData,
            );
        }
        else {
            if ( defined( $Article{"ArticleFreeText$_"} ) ) {
                if ( ref( $Article{"ArticleFreeText$_"} ) eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeText$_"}->[0] ) {
                        $Article{"ArticleFreeText$_"} = $Article{"ArticleFreeText$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeText$_"} = '';
                    }
                }
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" name="ArticleFreeText'
                    . $_
                    . '" value="'
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Article{"ArticleFreeText$_"} )
                    . '" size="30"/>';
            }
            else {
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" name="ArticleFreeText' . $_ . '" value="" size="30"/>';
            }
        }
    }
    return %Data;
}

sub CustomerFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption = ();
    my %SelectData = ();
    my %Ticket     = ();
    my %Config     = ();
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data = ();
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod = ();
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            Area => 'Customer',
            %Param,
            %Ticket,
            Prefix   => 'TicketFreeTime' . $Count,
            Format   => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            %TimePeriod,
        );
    }
    return %Data;
}

1;
