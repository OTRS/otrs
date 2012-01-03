# --
# Kernel/GenericInterface/Operation/Ticket/SessionIDGet.pm - GenericInterface Ticket Get operation backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: SessionIDGet.pm,v 1.1 2012-01-03 04:22:08 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::SessionIDGet;

use strict;
use warnings;

use Kernel::GenericInterface::Operation::Ticket::Common;
use Kernel::System::VariableCheck qw(IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::SessionIDGet - GenericInterface Ticket Get Operation backend

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
    $Self->{TicketCommonObject}
        = Kernel::GenericInterface::Operation::Ticket::Common->new( %{$Self} );

    return $Self;
}

=item Run()

Retrieve a new session id value.

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

    # check needed stuff
    for my $Needed (qw( UserLogin Password )) {
        if ( !$Param{Data}->{$Needed} ) {
            return $Self->{TicketCommonObject}->ReturnError(
                ErrorCode    => 'SessionIDGet.MissingParameter',
                ErrorMessage => "SessionIDGet: $Needed parameter is missing!",
            );
        }
    }

    my $SessionID = $Self->{TicketCommonObject}->GetSessionID(
        %Param
    );

    return $Self->{TicketCommonObject}->ReturnError(
        ErrorCode    => 'SessionIDGet.AuthFail',
        ErrorMessage => "SessionIDGet: Authorization failing!",
    ) if !$SessionID;

    my $ReturnData = {
        Success => 1,
        Data    => {
            SessionID => $SessionID,
        },
    };

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

$Revision: 1.1 $ $Date: 2012-01-03 04:22:08 $

=cut
