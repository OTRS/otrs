# --
# Kernel/GenericInterface/Operation/Ticket/TicketGet.pm - GenericInterface Ticket Get operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TicketGet.pm,v 1.4 2011-12-29 00:50:43 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketGet;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::Ticket;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketGet - GenericInterface Ticket Get Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);

    # set UserID to root because in public interface there is no user
    $Self->{UserID} = 1;

    return $Self;
}

=item Run()

perform TicketGet Operation. This will return a Ticket entry.

    my $Result = $OperationObject->Run(
        Data => {
            TicketID => '32,33',
            DynamicFields     => 0, # Optional, 0 as default
            Extended          => 1, # Optional 0 as default
            AllArticles       => 1, # Optional 0 as default
            ArticleSenderType => [ $ArticleSenderType1, $ArticleSenderType2 ], # Optional, only requested article sender types
            ArticleOrder      => 'DESC', # Optional, DESC,ASC - default is ASC
            ArticleLimit      => 5, # Optional
            Attachments       => 1, # Optional, 1 as default
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {},
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage = '';

    if ( !$Param{Data}->{TicketID} ) {
        $ErrorMessage = 'Got no TicketID!';

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => "Required parameter is missing!",
            Data    => $ErrorMessage,
        );

        # return error
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # all needed vairables
    my @TicketIDs = split( /,/, $Param{Data}->{TicketID} );
    my $DynamicFields     = $Param{Data}->{DynamicFields}     || 0;
    my $Extended          = $Param{Data}->{Extended}          || 0;
    my $AllArticles       = $Param{Data}->{AllArticles}       || 0;
    my $ArticleSenderType = $Param{Data}->{ArticleSenderType} || '';
    my $ArticleOrder      = $Param{Data}->{ArticleOrder}      || 'ASC';
    my $ArticleLimit      = $Param{Data}->{ArticleLimit}      || 0;
    my $Attachments       = $Param{Data}->{Attachments}       || 0;
    my $ReturnData        = {
        Success => 1,
    };
    my @Item;

    # start ticket loop
    TICKET:
    for my $TicketID (@TicketIDs) {

        # get the Ticket entry
        my %TicketEntry = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => $DynamicFields,
            Extended      => $Extended,
            UserID        => $Self->{UserID},
        );

        if ( !IsHashRefWithData( \%TicketEntry ) ) {

            $ErrorMessage = 'Could not get Ticket data'
                . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "TicketGet return error",
                Data    => $ErrorMessage,
            );

            # return error
            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }

        # set Ticket entry data
        my $TicketBundle = {
            Ticket => \%TicketEntry,
        };

        if ( !$AllArticles ) {
            push @Item, $TicketBundle;
            next TICKET;
        }

        my @ArticleBox = $Self->{TicketObject}->ArticleGet(
            TicketID          => $TicketID,
            ArticleSenderType => $ArticleSenderType,
            DynamicFields     => $DynamicFields,
            Extended          => $Extended,
            Order             => $ArticleOrder,
            Limit             => $ArticleLimit,
            UserID            => $Self->{UserID},
        );

        # start article loop
        ARTICLE:
        for my $Article (@ArticleBox) {

            # next if not attachments required
            next ARTICLE if !$Attachments;

            # get attachment index (without attachments)
            my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
                ContentPath                => $Article->{ContentPath},
                ArticleID                  => $Article->{ArticleID},
                StripPlainBodyAsAttachment => 3,
                Article                    => $Article,
                UserID                     => $Self->{UserID},
            );

            # next if not attachments
            next ARTICLE if !IsHashRefWithData( \%AtmIndex );

            my @Attachments;
            ATTACHMENT:
            for my $FileID (%AtmIndex) {
                next ATTACHMENT if !$FileID;
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Article->{ArticleID},
                    FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                    UserID    => $Self->{UserID},
                );

                # next if not attachment
                next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                # convert content to base64
                $Attachment{Content} = encode_base64( $Attachment{Content} );
                push @Attachments, {%Attachment};
            }

            # set Attachments data
            $Article->{Atms} = \@Attachments;

        }    # finish article loop

        # set Ticket entry data
        $TicketBundle->{Articles} = \@ArticleBox;

        # add
        push @Item, $TicketBundle;
    }    # finish ticket loop

    if ( !scalar @Item ) {
        $ErrorMessage = 'Could not get Ticket data'
            . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => "TicketGet return error",
            Data    => $ErrorMessage,
        );

        # return error
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # set ticket data into return structure
    $ReturnData->{Data}->{Item} = \@Item;

    # return result
    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2011-12-29 00:50:43 $

=cut
