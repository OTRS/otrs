# --
# Kernel/Output/HTML/LinkObjectTicket.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObjectTicket.pm,v 1.2 2008-06-13 08:14:50 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LinkObjectTicket;

use strict;
use warnings;

use Kernel::System::Priority;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::Output::HTML::LinkObjectTicket - layout backend module

=head1 SYNOPSIS

All layout functions of link object (ticket)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectTicket->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject MainObject LayoutObject DBObject UserObject QueueObject GroupObject ParamObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{PriorityObject} = Kernel::System::Priority->new( %{$Self} );
    $Self->{StateObject}    = Kernel::System::State->new( %{$Self} );

    return $Self;
}

=item OutputParamsFillUp()

fill up output params

    $Backend->OutputParamsFillUp(
        ColumnData => $Hashref,
    );

=cut

sub OutputParamsFillUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SourceObject TargetObject TargetItemDescription ColumnData)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # extract output params and ticket id
    my $OutputParams = $Param{ColumnData}->{Output};
    my $TicketID     = $Param{TargetItemDescription}->{ItemData}->{TicketID};

    # edit options of the link column
    if ( $Param{ColumnData}->{Type} eq 'Checkbox' && $Param{ColumnData}->{Key} eq 'LinkTargetKeys' )
    {

        $OutputParams->{Name}    = $Param{ColumnData}->{Key};
        $OutputParams->{Content} = $TicketID;

        return 1;
    }

    # edit options of the link column
    if (
        $Param{ColumnData}->{Type}   eq 'Checkbox'
        && $Param{ColumnData}->{Key} eq 'LinkDeleteIdentifier'
        )
    {

        $OutputParams->{TemplateBlock} = 'Plain';
        $OutputParams->{Content}       = '';

        return 1 if !$Param{TargetItemDescription}->{LinkData};

        # extract the link data and object id
        my $LinkData = $Param{TargetItemDescription}->{LinkData};
        my $Object = $Param{TargetObject}->{Object} || '';

        return 1 if ref $LinkData            ne 'HASH';
        return 1 if !%{$LinkData};
        return 1 if !$LinkData->{$Object};
        return 1 if ref $LinkData->{$Object} ne 'HASH';
        return 1 if !%{ $LinkData->{$Object} };

        # create the type list
        my %AlreadyLinkedTypeList;
        LINKTYPEID:
        for my $Type ( keys %{ $LinkData->{$Object} } ) {

            DIRECTION:
            for my $Direction (qw(Source Target)) {

                # extract data
                my $Data = $LinkData->{$Object}->{$Type}->{$Direction} || [];

                # investigate matched keys
                my $MatchedKeys = scalar grep { $_ == $Param{SourceObject}->{Key} } @{$Data};

                next DIRECTION if !$MatchedKeys;

                my $Name = $Direction eq 'Source' ? 'TargetName' : 'SourceName';

                $AlreadyLinkedTypeList{ $Param{TypeList}->{$Type}->{$Name} } = $Type;
            }
        }

        # sort link name list
        my @CheckboxeStrings;
        for my $LinkName ( sort { lc $a cmp lc $b } keys %AlreadyLinkedTypeList ) {

            # translate
            my $LinkNameTranslated = $Self->{LayoutObject}->{LanguageObject}->Get($LinkName);

            # output block
            $Self->{LayoutObject}->Block(
                Name => 'Checkbox',
                Data => {
                    Name    => $Param{ColumnData}->{Key},
                    Content => $TicketID . '::' . $AlreadyLinkedTypeList{$LinkName},
                    Title   => $LinkNameTranslated,
                },
            );

            # create output content
            my $CheckboxString = $Self->{LayoutObject}->Output(
                TemplateFile => $Param{ColumnData}->{Output}->{TemplateFile},
            );

            push @CheckboxeStrings, $CheckboxString;
        }

        return 1 if !@CheckboxeStrings;

        # create the content string
        $OutputParams->{Content} = join '<br>', @CheckboxeStrings;

        return 1;
    }

    # edit options of the link column
    if ( $Param{ColumnData}->{Type} eq 'Link' && $Param{ColumnData}->{Key} eq 'TicketNumber' ) {

        $OutputParams->{Link} = '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID;
        $OutputParams->{Title} = $Param{TargetItemDescription}->{Description}->{Long} || '';

        return 1 if !$Param{ColumnData}->{Subtype};
        return 1 if $Param{ColumnData}->{Subtype} ne 'Compact';
        return 1 if !$Param{TargetItemDescription}->{Description}->{Short};

        $OutputParams->{Content} = $Param{TargetItemDescription}->{Description}->{Short};

        return 1;
    }

    # edit options of the title column
    if ( $Param{ColumnData}->{Type} eq 'Text' && $Param{ColumnData}->{Key} eq 'Title' ) {

        $OutputParams->{MaxLength} = 40;

        return 1;
    }

    # edit options of the state column
    if ( $Param{ColumnData}->{Type} eq 'Text' && $Param{ColumnData}->{Key} eq 'State' ) {

        $OutputParams->{TemplateBlock} = 'TextTranslate';
        $OutputParams->{MaxLength}     = 20;

        return 1;
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2008-06-13 08:14:50 $

=cut
