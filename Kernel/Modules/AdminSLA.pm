# --
# Kernel/Modules/AdminSLA.pm - admin frontend to manage slas
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminSLA.pm,v 1.2 2007-02-24 11:14:02 mh Exp $
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
$VERSION = '$Revision: 1.2 $';
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
        if ($SLAData{SLAID} eq 'NEW') {
            $SLAData{Name} = $Self->{ParamObject}->GetParam(Param => "Name");
            $SLAData{ServiceID} = $Self->{ParamObject}->GetParam(Param => "ServiceID");
            $SLAData{ResponseTime} = 0;
            $SLAData{MaxTimeToRepair} = 0;
            $SLAData{MinTimeBetweenIncidents} = 0;

            if (!$SLAData{ServiceID}) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
        }
        else {
            %SLAData = $Self->{SLAObject}->SLAGet(
                SLAID => $SLAData{SLAID},
                UserID => $Self->{UserID},
            );
        }
        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
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
            SelectedID => $SLAData{ServiceID},
        );
        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ServiceOptionStrg => $ServiceOptionStrg,
            },
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
            Name => 'CalendarName',
            SelectedID => $SLAData{CalendarName},
            PossibleNone => 1,
        );
        # get service
        my %ServiceData = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $SLAData{ServiceID},
            UserID => $Self->{UserID},
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
            Name => 'SLAEdit',
            Data => {
                %Param,
                %SLAData,
                Service => $ServiceData{Name},
                ServiceID => $ServiceData{ServiceID},
            },
        );
        # generate output
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
        my $ErrorNotify = '';
        my %SLAData;
        # get params
        foreach (qw(SLAID ServiceID Name CalendarName ResponseTime MaxTimeToRepair MinTimeBetweenIncidents ValidID Comment)) {
            $SLAData{$_} = $Self->{ParamObject}->GetParam(Param => "$_") || '';
        }
        # save to database
        if ($SLAData{SLAID} eq 'NEW') {
            my $Success = $Self->{SLAObject}->SLAAdd(
                %SLAData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                $ErrorNotify .= "&ErrorAdd=1"
            }
        }
        else {
            my $Success = $Self->{SLAObject}->SLAUpdate(
                %SLAData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                $ErrorNotify .= "&ErrorUpdate=1"
            }
        }
        # redirect to overview
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}$ErrorNotify");
    }

    # ------------------------------------------------------------ #
    # sla overview
    # ------------------------------------------------------------ #
    else {
        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # output error notify
        if ($Self->{ParamObject}->GetParam(Param => "ErrorAdd")) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"Add new SLA failed! See System Log for details."}',
            );
        }
        elsif ($Self->{ParamObject}->GetParam(Param => "ErrorUpdate")) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"Update SLA faild! See System Log for details."}',
            );
        }
        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
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
