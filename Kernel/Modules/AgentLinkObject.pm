# --
# Kernel/Modules/AgentLinkObject.pm - to link objects
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentLinkObject.pm,v 1.12 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentLinkObject;

use strict;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # load generic backend link object module
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    $Self->{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    $Self->{PreviewID} = $Self->{ParamObject}->GetParam(Param => 'PreviewID') || '';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 1;

    foreach my $Key (qw(SourceID SourceObject DestinationObject)) {
        my $Value = $Self->{ParamObject}->GetParam(Param => $Key) || '';
        if ($Value) {
            $Self->{$Key} = $Value;
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => $Key,
                Value => $Value,
            );
        }
    }
    if ($Self->{DestinationObject}) {
        $Param{Module} = $Self->{DestinationObject};
        $Param{ID} = $Self->{ID};
        $Self->{LinkObject}->LoadBackend(%Param);
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # start application page
    my $Output .= $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # check needed stuff
    foreach (qw(SourceID SourceObject)) {
        if (!$Self->{$_}) {
            # error page
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need $_ Param!",
            );
        }
    }

    # update action
    if ($Self->{Subaction} eq 'LinkParent') {
        $Self->{LinkObject}->LinkObject(
            LinkType => 'Parent',
            LinkID1 => $Self->{ID},
            LinkObject1 => $Self->{DestinationObject},
            LinkID2 => $Self->{SourceID},
            LinkObject2 => $Self->{SourceObject},
            UserID => $Self->{UserID},
        );
    }
    elsif ($Self->{Subaction} eq 'LinkChild') {
        $Self->{LinkObject}->LinkObject(
            LinkType => 'Child',
            LinkID1 => $Self->{SourceID},
            LinkObject1 => $Self->{SourceObject},
            LinkID2 => $Self->{ID},
            LinkObject2 => $Self->{DestinationObject},
            UserID => $Self->{UserID},
        );
    }
    elsif ($Self->{Subaction} eq 'LinkNormal') {
        $Self->{LinkObject}->LinkObject(
            LinkType => 'Normal',
            LinkID1 => $Self->{SourceID},
            LinkObject1 => $Self->{SourceObject},
            LinkID2 => $Self->{ID},
            LinkObject2 => $Self->{DestinationObject},
            UserID => $Self->{UserID},
        );
    }
    elsif ($Self->{Subaction} eq 'UnlinkParent') {
        $Self->{LinkObject}->UnlinkObject(
            LinkType => 'Parent',
            LinkID1 => $Self->{ID},
            LinkObject1 => $Self->{DestinationObject},
            LinkID2 => $Self->{SourceID},
            LinkObject2 => $Self->{SourceObject},
            UserID => $Self->{UserID},
        );
    }
    elsif ($Self->{Subaction} eq 'UnlinkChild') {
        $Self->{LinkObject}->UnlinkObject(
            LinkType => 'Child',
            LinkID1 => $Self->{SourceID},
            LinkObject1 => $Self->{SourceObject},
            LinkID2 => $Self->{ID},
            LinkObject2 => $Self->{DestinationObject},
            UserID => $Self->{UserID},
        );
    }
    elsif ($Self->{Subaction} eq 'UnlinkNormal') {
        $Self->{LinkObject}->UnlinkObject(
            LinkType => 'Normal',
            LinkID1 => $Self->{SourceID},
            LinkObject1 => $Self->{SourceObject},
            LinkID2 => $Self->{ID},
            LinkObject2 => $Self->{DestinationObject},
            UserID => $Self->{UserID},
        );
    }

    # show link objects
    $Param{'LinkToObject'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {$Self->{LinkObject}->LinkObjects(SourceObject => $Self->{SourceObject})},
        Name => 'DestinationObject',
        SelectedID => $Self->{DestinationObject},
    );
    $Self->{LayoutObject}->Block(
        Name => 'LinkOption',
        Data => {
            %Param,
            SourceObject => $Self->{SourceObject},
        },
    );
    # search mask

    if ($Self->{DestinationObject}) {
        # get backend module params
        my %GetParams = ();
        foreach my $Param ($Self->{LinkObject}->LinkSearchParams()) {
            if (defined($Self->{ParamObject}->GetParam(Param => $Param->{Name}))) {
                $GetParams{$Param->{Name}} = $Self->{ParamObject}->GetParam(Param => $Param->{Name});
            }
            else {
                $GetParams{$Param->{Name}} = $Self->{"ObjectLink_$Self->{DestinationObject}_$Param->{Name}"} || '';
            }
        }
        if ($Self->{Subaction} eq 'Search') {
            foreach (keys %GetParams) {
#                    $GetParams{$_} = $Self->{ParamObject}->GetParam(Param => $_);
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key => "ObjectLink_$Self->{DestinationObject}_$_",
                    Value => $GetParams{$_},
                );
            }
        }
        # get search mask
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => {
                %Param,
            },
        );
        # get search item
        foreach my $Data ($Self->{LinkObject}->LinkSearchParams()) {
            if (defined($Data->{Select})) {
                $Data->{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    SelectedID => $GetParams{$Data->{Name}},
                    Data       => $Data->{Select},
                    Name       => $Data->{Name},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'SearchItemSelect',
                    Data => {
                        %Param,
                        Value => $GetParams{$Data->{Name}},
                        %{$Data},
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'SearchItem',
                    Data => {
                        %Param,
                        Value => $GetParams{$Data->{Name}},
                        %{$Data},
                    },
                );
            }
        }
        # result
        my $SearchPageShown = 15;
        my $Limit = 100;

        my @DataResultRaw = $Self->{LinkObject}->LinkSearch(
            %GetParams,
            Limit => $Limit,
            UserID => $Self->{UserID},
        );
        # show no own ticket
        my @DataResult = ();
        foreach my $Data (@DataResultRaw) {
            if ($Self->{SourceObject} eq $Self->{DestinationObject} && $Self->{SourceID} eq $Data->{ID}) {
            }
            else {
                push(@DataResult, $Data);
            }
        }
        if (@DataResult) {
            my %PageNav = $Self->{LayoutObject}->PageNavBar(
                Limit => $Limit,
                StartHit => $Self->{StartHit},
                PageShown => $SearchPageShown,
                AllHits => $#DataResult+1,
                Action => "Action=AgentLinkObject&Subaction=Search",
                Link => "",
            );
            $Self->{LayoutObject}->Block(
                Name => 'SearchResult',
                Data => {
                    %Param, %PageNav
                },
            );
            my $Counter = 0;
            my %LinkedParent = $Self->{LinkObject}->LinkedObjects(
                LinkType => 'Parent',
                LinkObject1 => $Self->{DestinationObject},
                LinkID2 => $Self->{SourceID},
                LinkObject2 => $Self->{SourceObject},
                UserID => $Self->{UserID},
            );
            my %LinkedChild = $Self->{LinkObject}->LinkedObjects(
                LinkType => 'Child',
                LinkID1 => $Self->{SourceID},
                LinkObject1 => $Self->{SourceObject},
                LinkObject2 => $Self->{DestinationObject},
                UserID => $Self->{UserID},
            );
            my %LinkedNormal = $Self->{LinkObject}->LinkedObjects(
                LinkType => 'Normal',
                LinkID1 => $Self->{SourceID},
                LinkObject1 => $Self->{SourceObject},
                LinkObject2 => $Self->{DestinationObject},
                UserID => $Self->{UserID},
            );

            foreach my $Data (@DataResult) {
                $Counter++;
                if ($Counter >= $Self->{StartHit} && $Counter < ($SearchPageShown+$Self->{StartHit}) ) {
                    if ($LinkedParent{$Data->{ID}}) {
                        $Param{LinkedParent} = 1;
                    }
                    else {
                        $Param{LinkedParent} = 0;
                    }
                    if ($LinkedChild{$Data->{ID}}) {
                        $Param{LinkedChild} = 1;
                    }
                    else {
                        $Param{LinkedChild} = 0;
                    }
                    if ($LinkedNormal{$Data->{ID}}) {
                        $Param{LinkedNormal} = 1;
                    }
                    else {
                        $Param{LinkedNormal} = 0;
                    }

                    if ($Param{LinkedNormal} == 1) {
                        $Param{LinkedParent} = 2;
                        $Param{LinkedChild} = 2;
                    }
                    if ($Param{LinkedParent} == 1) {
                        $Param{LinkedNormal} = 2;
                        $Param{LinkedChild} = 2;
                    }
                    if ($Param{LinkedChild} == 1) {
                        $Param{LinkedParent} = 2;
                        $Param{LinkedNormal} = 2;
                    }

                    if ($LinkedParent{$Data->{ID}}) {
                        $Param{LinkedParent} = 1;
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'SearchResultItem',
                        Data => {
                            %Param, %{$Data}, StartHit => $Self->{StartHit},
                        },
                    );
                }
            }
        }

        if ($Self->{PreviewID}) {
            $Self->{LayoutObject}->Block(
                Name => 'Preview',
                Data => {
                    %Param, $Self->{LinkObject}->LinkItemData(ID => $Self->{PreviewID}, UserID => $Self->{UserID}),
                },
            );
        }
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentLinkObject',
        Data => {
            %Param,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
