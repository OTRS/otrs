# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminSelectBox.pm,v 1.22.2.1 2008-07-24 10:09:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Objects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # ------------------------------------------------------------ #
    # print form
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # get params
        foreach (qw(SQL Max)) {
            $Param{SQL} = $Self->{ParamObject}->GetParam(Param => 'SQL') || 'SELECT * FROM ';
            $Param{Max} = $Self->{ParamObject}->GetParam(Param => 'Max') || 40;
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSelectBoxForm',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # do select
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Select') {
        # get params
        foreach (qw(SQL Max)) {
            $Param{SQL} = $Self->{ParamObject}->GetParam(Param => 'SQL') || '';
            $Param{Max} = $Self->{ParamObject}->GetParam(Param => 'Max') || '';
        }
        # add result block
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => { %Param },
        );
        # fetch database and add row blocks
        if ($Self->{DBObject}->Prepare(SQL => $Param{SQL}, Limit => $Param{Max})) {
            while (my @Row = $Self->{DBObject}->FetchrowArray(RowNames => 1) ) {
                my $Row = '';
                foreach my $Item (@Row) {
                    my $Item1 = '';
                    my $Item2 = '';
                    if (! defined $Item) {
                        $Item1 = '<i>NULL</i>';
                        $Item2 = 'NULL';
                    }
                    else {
                        $Item1 = $Self->{LayoutObject}->Ascii2Html(
                            Text => $Item,
                            Max => 16,
                        );
                        $Item2 = $Self->{LayoutObject}->Ascii2Html(
                            Text => $Item,
                            Max => 80,
                        );
                    }
                    $Item2 =~ s/\n|\r//g;
                    $Row .= "<td class=\"small\"><div title=\"$Item2\">";
                    $Row .= $Item1;
                    $Row .= "</div></td>\n";
                }
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        Result => $Row,
                    },
                );
            }
            # generate output
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSelectBoxForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSelectBoxForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
}

1;
