# --
# Kernel/Modules/AdminDynamicField.pm - provides a dynamic fields view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminDynamicField.pm,v 1.1 2011-08-17 16:14:23 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicField;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::DynamicField;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create addtional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );

    # get configured ticket modules
    $Self->{DFTicketModuleConfig} = $Self->{ConfigObject}->Get('DynamicFields::Ticket::Module');

    # get configured article modules
    $Self->{DFArticleModuleConfig} = $Self->{ConfigObject}->Get('DynamicFields::Article::Module');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # TODO Implement

    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # TODO Implement

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );

    my @TicketFieldBackends;

    TICKETFIELDBACKEND:
    for my $FieldBackend ( keys %{ $Self->{DFTicketModuleConfig} } ) {
        next TICKETFIELDBACKEND if !$FieldBackend;
        push @TicketFieldBackends, $FieldBackend;
    }

    # create the Add Ticket Dynamic Field select
    my $AddTicketDynamicFieldStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \@TicketFieldBackends,
        Name         => 'TicketDynamicField',
        PossibleNone => 0,
        Translate    => 1,
        Sort         => 'AlphanumericValue',
    );

    # call ActionAddTicketDynamicField block
    $Self->{LayoutObject}->Block(
        Name => 'ActionAddTicketDynamicField',
        Data => {
            %Param,
            AddTicketDynamicFieldStrg => $AddTicketDynamicFieldStrg,
        },
    );

    my @ArticleFieldBackends;

    ARTICLEFIELDBACKEND:
    for my $FieldBackend ( keys %{ $Self->{DFArticleModuleConfig} } ) {
        next ARTICLEFIELDBACKEND if !$FieldBackend;
        push @ArticleFieldBackends, $FieldBackend;
    }

    # create the Add Article Dynamic Field select
    my $AddArticleDynamicFieldStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \@ArticleFieldBackends,
        Name         => 'ArticleDynamicField',
        PossibleNone => 0,
        Translate    => 1,
        Sort         => 'AlphanumericValue',
    );

    # call ActionAddArticleDynamicField block
    $Self->{LayoutObject}->Block(
        Name => 'ActionAddArticleDynamicField',
        Data => {
            %Param,
            AddArticleDynamicFieldStrg => $AddArticleDynamicFieldStrg,
        },
    );

    # call hint block
    $Self->{LayoutObject}->Block(
        Name => 'Hint',
        Data => \%Param,
    );

    my $DynamicFieldsList;

    # TODO Replace with calls to the real object
    #---
    for my $i ( 1 .. 100 ) {
        $DynamicFieldsList->{ 'Field_' . $i } = 1;
    }

    #---

    # print the list of dynamic fields
    $Self->_DynamicFieldsListShow(
        DynamicFields => $DynamicFieldsList,
        Total         => scalar keys %{$DynamicFieldsList},
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminDynamicField',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _DynamicFieldsListShow {
    my ( $Self, %Param ) = @_;

    # check start option, if higher than fields available, set
    # it to the last field page
    my $StartHit = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'AdminDynamicFieldsOverviewPageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'DynamicFieldsOverviewPageShown';

    # get data selection
    my %Data;
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # calculate max. shown per page
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # build nav bar
    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Self->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
        IDPrefix  => $Self->{LayoutObject}->{Action},
    );

    # build shown ticket per page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $Self->{LayoutObject}->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
    );

    if (%PageNav) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContextSettings',
            Data => { %PageNav, %Param, },
        );
    }

    # check if at least 1 dynamic field is registered in the system
    if ( $Param{Total} ) {

        # get dynamic fields details
        my $Counter = 0;
        for my $DynamicFieldID ( keys %{ $Param{DynamicFields} } ) {
            $Counter++;
            if ( $Counter >= $StartHit && $Counter < ( $PageShown + $StartHit ) ) {

                my $DynamicFieldData;

                # TODO Replace with a real call to the core object
                #---
                $DynamicFieldData = {
                    ID             => 'FieldID' . $Counter,
                    Name           => 'NameForField' . $Counter,
                    Type           => 'Text',
                    Config         => '$ConfigHashRef',
                    BelongsArticle => '1',
                    ValidID        => 12,
                    CreateTime     => '2011-02-08 15:08:00',
                    ChangeTime     => '2011-02-08 15:08:00',
                };

                #---

                # print each dinamic field row
                $Self->{LayoutObject}->Block(
                    Name => 'DynamicFieldsRow',
                    Data => $DynamicFieldData,
                );
            }
        }
    }

    # otherwise show a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFound',
            Data => \%Param,
        );
    }
    return;
}

1;
