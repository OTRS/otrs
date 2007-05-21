# --
# Kernel/Modules/AdminSLA.pm - admin frontend to manage slas
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminSLA.pm,v 1.5 2007-05-21 18:48:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSLA;

use strict;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);
    $Self->{SLAObject} = Kernel::System::SLA->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # ------------------------------------------------------------ #
    # sla edit
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'SLAEdit') {
        my %SLAData;
        # get params
        $SLAData{SLAID} = $Self->{ParamObject}->GetParam(Param => "SLAID");
        if ($SLAData{SLAID}) {
            %SLAData = $Self->{SLAObject}->SLAGet(
                SLAID => $SLAData{SLAID},
                UserID => $Self->{UserID},
            );
        }
        else {
            $SLAData{ServiceID} = $Self->{ParamObject}->GetParam(Param => "ServiceID");
        }
        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
            Valid => 0,
            UserID => $Self->{UserID},
        );
        # generate ServiceOptionStrg
        my $TreeView = 0;
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree') {
            $TreeView = 1;
        }
        $Param{ServiceOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%ServiceList,
            Name => 'ServiceID',
            PossibleNone => 1,
            TreeView => $TreeView,
            Sort => 'TreeView',
            Translation => 0,
            SelectedID => $SLAData{ServiceID},
        );
        # generate CalendarOptionStrg
        my %CalendarList;
        foreach (1..20) {
            if ($Self->{ConfigObject}->Get("TimeVacationDays::Calendar$_")) {
                $CalendarList{$_} = "Calendar $_ - ". $Self->{ConfigObject}->Get("TimeZone::Calendar".$_."Name");
            }
        }
        $SLAData{CalendarOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%CalendarList,
            Name => 'Calendar',
            SelectedID => $SLAData{Calendar},
            PossibleNone => 1,
        );
        $Param{ServiceOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%ServiceList,
            Name => 'ServiceID',
            SelectedID => $SLAData{ServiceID} || '',
            PossibleNone => 1,
            TreeView => $TreeView,
            Sort => 'TreeView',
            Translation => 0,
        );
        # generate ValidOptionStrg
        my %ValidList = $Self->{ValidObject}->ValidList();
        $SLAData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%ValidList,
            Name => 'ValidID',
            SelectedID => $SLAData{ValidID},
        );
        # output sla edit
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'SLAEdit',
            Data => {
                %Param,
                %SLAData,
            },
        );
        # output overview
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSLA',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # sla save
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'SLASave') {
        my %SLAData;
        # get params
        foreach (qw(SLAID ServiceID Name Calendar FirstResponseTime SolutionTime UpdateTime ValidID Comment)) {
            $SLAData{$_} = $Self->{ParamObject}->GetParam(Param => "$_") || '';
        }
        # save to database
        if (!$SLAData{SLAID}) {
            my $Success = $Self->{SLAObject}->SLAAdd(
                %SLAData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            my $Success = $Self->{SLAObject}->SLAUpdate(
                %SLAData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        # redirect to overview
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
    }

    # ------------------------------------------------------------ #
    # sla overview
    # ------------------------------------------------------------ #
    else {
        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
            Valid => 0,
            UserID => $Self->{UserID},
        );
        # generate ServiceOptionStrg
        my $TreeView = 0;
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree') {
            $TreeView = 1;
        }
        my $ServiceOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data => \%ServiceList,
            Name => 'ServiceID',
            PossibleNone => 1,
            TreeView => $TreeView,
            Sort => 'TreeView',
            Translation => 0,
        );
        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ServiceOptionStrg => $ServiceOptionStrg,
            },
        );
        # output overview result
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
            Data => {
                %Param,
            },
        );
        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();
        # add suffix for correct sorting
        foreach (keys %ServiceList) {
            $ServiceList{$_} .= '::';
        }
        my $CssClass;
        foreach my $ServiceID (sort {$ServiceList{$a} cmp $ServiceList{$b}} keys %ServiceList) {
            my $ServiceName = $ServiceList{$ServiceID};
            $/ = '::';
            chomp($ServiceName);
            # get sla list
            my %SLAList = $Self->{SLAObject}->SLAList(
                ServiceID => $ServiceID,
                Valid => 0,
                UserID => $Self->{UserID},
            );
            foreach my $SLAID (sort {$SLAList{$a} cmp $SLAList{$b}} keys %SLAList) {
                # set output class
                if ($CssClass && $CssClass eq 'searchactive') {
                    $CssClass = 'searchpassive';
                }
                else {
                    $CssClass = 'searchactive';
                }
                # get service data
                my %SLAData = $Self->{SLAObject}->SLAGet(
                    SLAID => $SLAID,
                    UserID => $Self->{UserID},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %SLAData,
                        Service => $ServiceName,
                        CssClass => $CssClass,
                        Valid => $ValidList{$SLAData{ValidID}},
                    },
                );
            }
        }
        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSLA',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
