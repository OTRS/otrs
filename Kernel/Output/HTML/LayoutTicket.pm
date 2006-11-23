# --
# Kernel/Output/HTML/LayoutTicket.pm - provides generic ticket HTML output
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: LayoutTicket.pm,v 1.5 2006-11-23 11:04:11 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::LayoutTicket;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketStdResponseString {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(StdResponsesRef TicketID ArticleID)) {
        if (!$Param{$_}) {
            return "Need $_ in TicketStdResponseString()";
        }
    }
    # get StdResponsesStrg
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::StdResponsesMode') eq 'Form') {
        # build html string
        $Param{StdResponsesStrg} .= '<form action="'.$Self->{CGIHandle}.'" method="post">'.
            '<input type="hidden" name="Action" value="AgentTicketCompose">'.
            '<input type="hidden" name="ArticleID" value="'.$Param{ArticleID}.'">'.
            '<input type="hidden" name="TicketID" value="'.$Param{TicketID}.'">'.
            $Self->OptionStrgHashRef(
                Name => 'ResponseID',
                Data => $Param{StdResponsesRef},
            ).
            '<input class="button" type="submit" value="$Text{"Compose"}"></form>';
    }
    else {
        my %StdResponses = %{$Param{StdResponsesRef}};
        foreach (sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses) {
            # build html string
            $Param{StdResponsesStrg} .= "\n<li><a href=\"$Self->{Baselink}"."Action=AgentTicketCompose&".
                "ResponseID=$_&TicketID=$Param{TicketID}&ArticleID=$Param{ArticleID}\" ".
                'onmouseover="window.status=\'$Text{"Compose"}\'; return true;" '.
                'onmouseout="window.status=\'\';">'.
            # html quote
            $Self->Ascii2Html(Text => $StdResponses{$_})."</A></li>\n";
        }
    }
    return $Param{StdResponsesStrg};
}

sub AgentCustomerView {
    my $Self = shift;
    my %Param = @_;
    $Param{Table} = $Self->AgentCustomerViewTable(%Param);
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerView', Data => \%Param);
}

sub AgentCustomerViewTable {
    my $Self = shift;
    my %Param = @_;
    my $ShownType = 1;
    if (ref($Param{Data}) ne 'HASH') {
        $Self->FatalError(Message => 'Need Hash ref in Data param');
    }
    elsif (ref($Param{Data}) eq 'HASH' && !%{$Param{Data}}) {
        return '$Text{"none"}';
    }
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Param{Type} && $Param{Type} eq 'Lite') {
        $ShownType = 2;
        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        foreach my $Field (@{$Map}) {
            if ($Field->[3] == 2) {
                $Used = 1;
            }
        }
        if (!$Used) {
            $ShownType = 1;
        }
    }
    # build html table
    foreach my $Field (@{$Map}) {
        if ($Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{$Field->[0]}) {
            my %Record = ();
            if ($Field->[6]) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\">";
                $Record{LinkStop} = "</a>";
            }
            if ($Field->[0]) {
                $Record{ValueShort} = $Self->Ascii2Html(Text => $Param{Data}->{$Field->[0]}, Max => $Param{Max});
            }
            $Self->Block(
                Name => 'CustomerRow',
                Data => {
                    %{$Param{Data}},
                    Key => $Field->[1],
                    Value => $Param{Data}->{$Field->[0]},
                    %Record,
                },
            );
        }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerTableView', Data => \%Param);
}

sub AgentQueueListOption {
    my $Self = shift;
    my %Param = @_;
    my $Size = defined($Param{Size}) ? "size='$Param{Size}'" : '';
    my $MaxLevel = defined($Param{MaxLevel}) ? $Param{MaxLevel} : 10;
    my $SelectedID = defined($Param{SelectedID}) ? $Param{SelectedID} : '';
    my $Selected = defined($Param{Selected}) ? $Param{Selected} : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined($Param{OnChangeSubmit}) ? $Param{OnChangeSubmit} : 0;
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    else {
        $OnChangeSubmit = '';
    }
    if ($Param{OnChange}) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::QueueListType') eq 'list') {
        $Param{'MoveQueuesStrg'} = $Self->OptionStrgHashRef(
            %Param,
            HTMLQuote => 0,
#            OnChangeSubmit => 1,
        );
        return $Param{MoveQueuesStrg};
    }
    # build tree list
    $Param{MoveQueuesStrg} = '<select name="'.$Param{Name}."\" $Size $Multiple $OnChangeSubmit>\n";
    my %UsedData = ();
    my %Data = ();
    if ($Param{Data} && ref($Param{Data}) eq 'HASH') {
        %Data = %{$Param{Data}};
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }
    # add suffix for correct sorting
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        $Data{$_} .= '::';
    }
    # build selection string
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        my @Queue = split(/::/, $Param{Data}->{$_});
        $UsedData{$Param{Data}->{$_}} = 1;
        my $UpQueue = $Param{Data}->{$_};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        if (! $Queue[$MaxLevel] && $Queue[$#Queue] ne '') {
            $Queue[$#Queue] = $Self->Ascii2Html(Text => $Queue[$#Queue], Max => 50-$#Queue);
            my $Space = '';
            for (my $i = 0; $i < $#Queue; $i++) {
                $Space .= '&nbsp;&nbsp;';
            }
            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                foreach my $ID (@{$SelectedIDRefArray}) {
                    if ($ID eq $_) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }
            # build select string
            if ($UsedData{$UpQueue}) {
                if ($SelectedID eq $_ || $Selected eq $Param{Data}->{$_} || $Param{SelectedIDRefArrayOK}->{$_}) {
                    $Param{MoveQueuesStrg} .= '<option selected value="'.$_.'">'.
                        $Space.$Queue[$#Queue]."</option>\n";
                }
                else {
                    $Param{MoveQueuesStrg} .= '<option value="'.$_.'">'.
                        $Space.$Queue[$#Queue]."</option>\n";
                }
            }
        }
    }
    $Param{MoveQueuesStrg} .= "</select>\n";

    return $Param{MoveQueuesStrg};
}

sub AgentFreeText {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    my %SelectData = ();
    my %Ticket = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Ticket}) {
        %Ticket = %{$Param{Ticket}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach (1..16) {
        # key
        if (ref($Config{"TicketFreeKey$_"}) eq 'HASH' && %{$Config{"TicketFreeKey$_"}}) {
            my $Counter = 0;
            my $LastKey = '';
            foreach (keys %{$Config{"TicketFreeKey$_"}}) {
                $Counter++;
                $LastKey = $_;
            }
            if ($Counter == 1 && $Param{NullOption}) {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey};
                }
            }
            elsif ($Counter > 1) {
                $Data{"TicketFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => {
                        %NullOption,
                        %{$Config{"TicketFreeKey$_"}},
                    },
                    Name => "TicketFreeKey$_",
                    SelectedID => $Ticket{"TicketFreeKey$_"},
                    SelectedIDRefArray => $Ticket{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey}.
                        '<input type="hidden" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $LastKey).'">';
                }
            }
        }
        else {
            if (defined($Ticket{"TicketFreeKey$_"})) {
                if (ref($Ticket{"TicketFreeKey$_"}) eq 'ARRAY') {
                    if ($Ticket{"TicketFreeKey$_"}->[0]) {
                        $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
                    }
                    else {
                       $Ticket{"TicketFreeKey$_"} = '';
                    }
                }
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Ticket{"TicketFreeKey$_"}).'" size="20">';
            }
            else {
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="" size="20">';
            }
        }
        # value
        if (ref($Config{"TicketFreeText$_"}) eq 'HASH') {
            $Data{"TicketFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => {
                    %NullOption,
                    %{$Config{"TicketFreeText$_"}},
                },
                Name => "TicketFreeText$_",
                SelectedID => $Ticket{"TicketFreeText$_"},
                SelectedIDRefArray => $Ticket{"TicketFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote => 1,
                %SelectData,
            );
        }
        else {
            if (defined($Ticket{"TicketFreeText$_"})) {
                if (ref($Ticket{"TicketFreeText$_"}) eq 'ARRAY') {
                    if ($Ticket{"TicketFreeText$_"}->[0]) {
                        $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeText$_"} = '';
                    }
                }
                $Data{"TicketFreeTextField$_"} = '<input type="text" name="TicketFreeText'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Ticket{"TicketFreeText$_"}).'" size="30">';
            }
            else {
                $Data{"TicketFreeTextField$_"} = '<input type="text" name="TicketFreeText'.$_.'" value="" size="30">';
            }
        }
    }
    return %Data;
}

sub AgentFreeDate {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    my %SelectData = ();
    my %Ticket = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Ticket}) {
        %Ticket = %{$Param{Ticket}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach my $Count (1..2) {
        $Data{'TicketFreeTime'.$Count} = $Self->BuildDateSelection(
            %Param,
            %Ticket,
            Prefix => 'TicketFreeTime'.$Count,
            Format => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get('TicketFreeTimeDiff'.$Count) || 0,
        );
    }
    return %Data;
}

sub TicketArticleFreeText {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    my %SelectData = ();
    my %Article = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Article}) {
        %Article = %{$Param{Article}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach (1..3) {
        # key
        if (ref($Config{"ArticleFreeKey$_"}) eq 'HASH' && %{$Config{"ArticleFreeKey$_"}}) {
            my $Counter = 0;
            my $LastKey = '';
            foreach (keys %{$Config{"ArticleFreeKey$_"}}) {
                $Counter++;
                $LastKey = $_;
            }
            if ($Counter == 1 && $Param{NullOption}) {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"} = $Config{"ArticleFreeKey$_"}->{$LastKey};
                }
            }
            elsif ($Counter > 1) {
                $Data{"ArticleFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => {
                        %NullOption,
                        %{$Config{"ArticleFreeKey$_"}},
                    },
                    Name => "ArticleFreeKey$_",
                    SelectedID => $Article{"ArticleFreeKey$_"},
                    SelectedIDRefArray => $Article{"ArticleFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"} = $Config{"ArticleFreeKey$_"}->{$LastKey}.
                        '<input type="hidden" name="ArticleFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $LastKey).'">';
                }
            }
        }
        else {
            if (defined($Article{"ArticleFreeKey$_"})) {
                if (ref($Article{"ArticleFreeKey$_"}) eq 'ARRAY') {
                    if ($Article{"ArticleFreeKey$_"}->[0]) {
                        $Article{"ArticleFreeKey$_"} = $Article{"ArticleFreeKey$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeKey$_"} = '';
                    }
                }
                $Data{"ArticleFreeKeyField$_"} = '<input type="text" name="ArticleFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Article{"ArticleFreeKey$_"}).'" size="20">';
            }
            else {
                $Data{"ArticleFreeKeyField$_"} = '<input type="text" name="ArticleFreeKey'.$_.'" value="" size="20">';
            }
        }
        # value
        if (ref($Config{"ArticleFreeText$_"}) eq 'HASH') {
            $Data{"ArticleFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => {
                    %NullOption,
                    %{$Config{"ArticleFreeText$_"}},
                },
                Name => "ArticleFreeText$_",
                SelectedID => $Article{"ArticleFreeText$_"},
                SelectedIDRefArray => $Article{"ArticleFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote => 1,
                %SelectData,
            );
        }
        else {
            if (defined($Article{"ArticleFreeText$_"})) {
                if (ref($Article{"ArticleFreeText$_"}) eq 'ARRAY') {
                    if ($Article{"ArticleFreeText$_"}->[0]) {
                        $Article{"ArticleFreeText$_"} = $Article{"ArticleFreeText$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeText$_"} = '';
                    }
                }
                $Data{"ArticleFreeTextField$_"} = '<input type="text" name="ArticleFreeText'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Article{"ArticleFreeText$_"}).'" size="30">';
            }
            else {
                $Data{"ArticleFreeTextField$_"} = '<input type="text" name="ArticleFreeText'.$_.'" value="" size="30">';
            }
        }
    }
    return %Data;
}

sub CustomerFreeDate {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    my %SelectData = ();
    my %Ticket = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Ticket}) {
        %Ticket = %{$Param{Ticket}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach my $Count (1..2) {
        $Data{'TicketFreeTime'.$Count} = $Self->BuildDateSelection(
            Area => 'Customer',
            %Param,
            %Ticket,
            Prefix => 'TicketFreeTime'.$Count,
            Format => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get('TicketFreeTimeDiff'.$Count) || 0,
        );
    }
    return %Data;
}

1;
