# --
# Kernel/Modules/AdminPriority.pm - admin frontend of ticket priority
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminPriority.pm,v 1.2 2008-07-02 08:55:12 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminPriority;

use strict;
use warnings;

use Kernel::System::Priority;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

        # generate ValidOptionStrg
        my %ValidList = $Self->{ValidObject}->ValidList();
        $PriorityData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ValidList,
            Name       => 'ValidID',
            SelectedID => $PriorityData{ValidID},
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

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        my $CssClass = '';
        for my $PriorityID ( sort { $a <=> $b } keys %PriorityList ) {

            # set output object
            $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

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
                    CssClass   => $CssClass,
                    Valid      => $ValidList{ $PriorityData{ValidID} },
                },
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
