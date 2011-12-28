# --
# Kernel/GenericInterface/Operation/Ticket/TicketGet.pm - GenericInterface Ticket Get operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TicketGet.pm,v 1.3 2011-12-28 18:44:35 cg Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

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

perform TicketGet Operation. This will return a Public Ticket entry.

    my $Result = $OperationObject->Run(
        Data => {
            TicketID = 32,33;
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

    my $ReturnData = {
        Success => 1,
    };
    my @TicketIDs = split( /,/, $Param{Data}->{TicketID} );
    my $DynamicFields = $Param{Data}->{DynamicFields} || 1;
    my @Item;

    # start main loop
    for my $TicketID (@TicketIDs) {

        # get the Ticket entry
        my %TicketEntry = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => $DynamicFields,
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

        # get content
        my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
            TicketID                   => $TicketID,
            StripPlainBodyAsAttachment => 3,
            UserID                     => $Self->{UserID},
            DynamicFields              => $DynamicFields,
        );

        ARTICLE:
        for my $Article (@ArticleBox) {
            if ( !IsHashRefWithData( $Article->{Atms} ) ) {
                $Article->{Atms} = undef;
                next ARTICLE;
            }

            my @Attachments;
            for my $FileID ( %{ $Article->{Atms} } ) {
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Article->{ArticleID},
                    FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                    UserID    => $Self->{UserID},
                );

                # convert content to base64
                $Attachment{Content} = encode_base64( $Attachment{Content} );
                push @Attachments, {%Attachment};
            }

            # set Attachments data
            $Article->{Atms} = \@Attachments;

        }

        # set Ticket entry data
        $TicketBundle->{Articles} = \@ArticleBox;

        # add
        push @Item, $TicketBundle;
    }    # finish main loop

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

$Revision: 1.3 $ $Date: 2011-12-28 18:44:35 $

=cut
