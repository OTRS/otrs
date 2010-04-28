# --
# Kernel/Modules/AdminPriority.pm - admin frontend of ticket priority
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminPriority.pm,v 1.8 2010-04-28 21:39:07 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPriority;

use strict;
use warnings;

use Kernel::System::Priority;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject LogObject LayoutObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{ValidObject}    = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # priority edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'PriorityEdit' ) {
        my %PriorityData;
        $PriorityData{Action} = 'Add';

        # get params
        $PriorityData{PriorityID} = $Self->{ParamObject}->GetParam( Param => "PriorityID" );
        if ( $PriorityData{PriorityID} ne 'NEW' ) {

            # get priority
            %PriorityData = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $PriorityData{PriorityID},
                UserID     => $Self->{UserID},
            );
            $PriorityData{PriorityID} = $PriorityData{ID};
            $PriorityData{Action}     = 'Change';
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # get valid list
        my %ValidList        = $Self->{ValidObject}->ValidList();
        my %ValidListReverse = reverse %ValidList;

        $PriorityData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ValidList,
            Name       => 'ValidID',
            SelectedID => $PriorityData{ValidID} || $ValidListReverse{valid},
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdate',
            Data => \%Param,
        );

        # output service edit
        $Self->{LayoutObject}->Block(
            Name => 'PriorityEdit',
            Data => {
                %Param,
                %PriorityData,
            },
        );

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPriority',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # priority save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'PrioritySave' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %PriorityData;

        # get params
        for my $FormParam (qw(PriorityID Name ValidID)) {
            $PriorityData{$FormParam} = $Self->{ParamObject}->GetParam( Param => $FormParam ) || '';
        }
        $PriorityData{ID} = $PriorityData{PriorityID};

        # save to database
        my $Success;
        if ( $PriorityData{PriorityID} eq 'NEW' ) {
            $Success = $Self->{PriorityObject}->PriorityAdd(
                %PriorityData,
                UserID => $Self->{UserID},
            );
        }
        else {
            $Success = $Self->{PriorityObject}->PriorityUpdate(
                %PriorityData,
                UserID => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->ErrorScreen() if !$Success;
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

        # output overview result
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
            Data => {
                %Param,
            },
        );

        # get priority list
        my %PriorityList = $Self->{PriorityObject}->PriorityList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # if there are any priorities defined, they are shown
        if (%PriorityList) {

            # get valid list
            my %ValidList = $Self->{ValidObject}->ValidList();

            for my $PriorityID ( sort { $a <=> $b } keys %PriorityList ) {

                # get priority data
                my %PriorityData = $Self->{PriorityObject}->PriorityGet(
                    PriorityID => $PriorityID,
                    UserID     => $Self->{UserID},
                );

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %PriorityData,
                        PriorityID => $PriorityID,
                        Valid      => $ValidList{ $PriorityData{ValidID} },
                    },
                );
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPriority',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
