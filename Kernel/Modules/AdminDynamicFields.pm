# --
# Kernel/Modules/AdminDynamicFields.pm - provides a dynamic fields view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminDynamicFields.pm,v 1.2 2011-08-15 23:49:14 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFields;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    #    $Self->{DynamicFieldsObject} = Kernel::System::DynamicFields->new( %{$Self} );

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

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminDynamicFields',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
1;
