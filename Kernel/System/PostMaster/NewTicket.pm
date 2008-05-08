# --
# Kernel/System/PostMaster/NewTicket.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: NewTicket.pm,v 1.68 2008-05-08 09:36:21 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use warnings;

use Kernel::System::AutoResponse;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.68 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get all objects
    for (qw(DBObject ConfigObject TicketObject LogObject ParseObject TimeObject QueueObject)) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(InmailUserID GetParam)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %GetParam         = %{ $Param{GetParam} };
    my $Comment          = $Param{Comment} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # get queue id and name
    my $QueueID = $Param{QueueID} || die "need QueueID!";
    my $Queue = $Self->{QueueObject}->QueueLookup( QueueID => $QueueID );

    # get state
    my $State = $Self->{ConfigObject}->Get('PostmasterDefaultState') || 'new';
    if ( $GetParam{'X-OTRS-State'} ) {
        $State = $GetParam{'X-OTRS-State'};
    }

    # get priority
    my $Priority = $Self->{ConfigObject}->Get('PostmasterDefaultPriority') || '3 normal';
    if ( $GetParam{'X-OTRS-Priority'} ) {
        $Priority = $GetParam{'X-OTRS-Priority'};
    }

    # get sender email
    my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine( Line => $GetParam{From}, );
    for (@EmailAddresses) {
        $GetParam{'SenderEmailAddress'} = $Self->{ParseObject}->GetEmailAddress( Email => $_, );
    }

    # get customer id (sender email) if there is no customer id given
    if ( !$GetParam{'X-OTRS-CustomerNo'} && $GetParam{'X-OTRS-CustomerUser'} ) {

        # get customer user data form X-OTRS-CustomerUser
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $GetParam{'X-OTRS-CustomerUser'},
        );
        if (%CustomerData) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};
        }
    }

    # get customer user data form From: (sender address)
    if ( !$GetParam{'X-OTRS-CustomerUser'} ) {
        my %CustomerData = ();
        if ( $GetParam{'From'} ) {
            my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine( Line => $GetParam{From}, );
            for (@EmailAddresses) {
                $GetParam{'EmailForm'} = $Self->{ParseObject}->GetEmailAddress( Email => $_, );
            }
            my %List = $Self->{CustomerUserObject}->CustomerSearch(
                PostMasterSearch => lc( $GetParam{'EmailForm'} ),
            );
            for ( keys %List ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $_, );
            }
        }

        # take CustomerID from customer backend lookup or from from field
        if ( $CustomerData{UserLogin} && !$GetParam{'X-OTRS-CustomerUser'} ) {
            $GetParam{'X-OTRS-CustomerUser'} = $CustomerData{UserLogin};

            # notice that UserLogin is form customer source backend
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Take UserLogin ($CustomerData{UserLogin}) from "
                    . "customer source backend based on ($GetParam{'EmailForm'}).",
            );
        }
        if ( $CustomerData{UserCustomerID} && !$GetParam{'X-OTRS-CustomerNo'} ) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};

            # notice that UserCustomerID is form customer source backend
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Take UserCustomerID ($CustomerData{UserCustomerID})"
                    . " from customer source backend based on ($GetParam{'EmailForm'}).",
            );
        }
    }

    # if there is no customer id found!
    if ( !$GetParam{'X-OTRS-CustomerNo'} ) {
        $GetParam{'X-OTRS-CustomerNo'} = $GetParam{'SenderEmailAddress'};
    }

    # if there is no customer user found!
    if ( !$GetParam{'X-OTRS-CustomerUser'} ) {
        $GetParam{'X-OTRS-CustomerUser'} = $GetParam{'SenderEmailAddress'};
    }

    # create new ticket
    my $NewTn    = $Self->{TicketObject}->TicketCreateNumber();
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        TN           => $NewTn,
        Title        => $GetParam{Subject},
        QueueID      => $QueueID,
        Lock         => $GetParam{'X-OTRS-Lock'} || 'unlock',
        Priority     => $Priority,
        State        => $State,
        Type         => $GetParam{'X-OTRS-Type'} || '',
        Service      => $GetParam{'X-OTRS-Service'} || '',
        SLA          => $GetParam{'X-OTRS-SLA'} || '',
        CustomerID   => $GetParam{'X-OTRS-CustomerNo'},
        CustomerUser => $GetParam{'X-OTRS-CustomerUser'},
        OwnerID      => $Param{InmailUserID},
        UserID       => $Param{InmailUserID},
    );
    if ( !$TicketID ) {
        return;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "New Ticket created!\n";
        print "TicketNumber: $NewTn\n";
        print "TicketID: $TicketID\n";
        print "Priority: $Priority\n";
        print "State: $State\n";
        print "CustomerID: $GetParam{'X-OTRS-CustomerNo'}\n";
        print "CustomerUser: $GetParam{'X-OTRS-CustomerUser'}\n";
        for (qw(Type Service SLA Lock)) {

            if ( $GetParam{ 'X-OTRS-' . $_ } ) {
                print "Type: " . $GetParam{ 'X-OTRS-' . $_ } . "\n";
            }
        }
    }

    # set pending time
    if ( $GetParam{'X-OTRS-State-PendingTime'} ) {
        my $Set = $Self->{TicketObject}->TicketPendingTimeSet(
            String   => $GetParam{'X-OTRS-State-PendingTime'},
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );

        # debug
        if ( $Set && $Self->{Debug} > 0 ) {
            print "State-PendingTime: $GetParam{'X-OTRS-State-PendingTime'}\n";
        }
    }

    # set ticket free text
    my @Values = ( 'X-OTRS-TicketKey', 'X-OTRS-TicketValue' );
    for my $Count ( 1 .. 16 ) {
        if ( $GetParam{ $Values[0] . $Count } ) {
            $Self->{TicketObject}->TicketFreeTextSet(
                TicketID => $TicketID,
                Key      => $GetParam{ $Values[0] . $Count },
                Value    => $GetParam{ $Values[1] . $Count },
                Counter  => $Count,
                UserID   => $Param{InmailUserID},
            );
            if ( $Self->{Debug} > 0 ) {
                print "TicketKey$Count: " . $GetParam{ $Values[0] . $Count } . "\n";
                print "TicketValue$Count: " . $GetParam{ $Values[1] . $Count } . "\n";
            }
        }
    }

    # set ticket free time
    for my $Count ( 1 .. 6 ) {
        my $Key = 'X-OTRS-TicketTime' . $Count;
        if ( $GetParam{$Key} ) {
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{$Key},
            );
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $SystemTime,
            );
            if ( $Year && $Month && $Day && $Hour && $Min ) {
                $Self->{TicketObject}->TicketFreeTimeSet(
                    'TicketFreeTime' . $Count . 'Year'   => $Year,
                    'TicketFreeTime' . $Count . 'Month'  => $Month,
                    'TicketFreeTime' . $Count . 'Day'    => $Day,
                    'TicketFreeTime' . $Count . 'Hour'   => $Hour,
                    'TicketFreeTime' . $Count . 'Minute' => $Min,
                    Prefix                               => 'TicketFreeTime',
                    TicketID                             => $TicketID,
                    Counter                              => $Count,
                    UserID                               => $Param{InmailUserID},
                );
                if ( $Self->{Debug} > 0 ) {
                    print "TicketTime$Count: " . $GetParam{$Key} . "\n";
                }
            }
        }
    }

    # do article db insert
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID         => $TicketID,
        ArticleType      => $GetParam{'X-OTRS-ArticleType'},
        SenderType       => $GetParam{'X-OTRS-SenderType'},
        From             => $GetParam{From},
        ReplyTo          => $GetParam{ReplyTo},
        To               => $GetParam{To},
        Cc               => $GetParam{Cc},
        Subject          => $GetParam{Subject},
        MessageID        => $GetParam{'Message-ID'},
        ContentType      => $GetParam{'Content-Type'},
        Body             => $GetParam{Body},
        UserID           => $Param{InmailUserID},
        HistoryType      => 'EmailCustomer',
        HistoryComment   => "\%\%$Comment",
        OrigHeader       => \%GetParam,
        AutoResponseType => $AutoResponseType,
        Queue            => $Queue,
    );

    # close ticket if article create failed!
    if ( !$ArticleID ) {
        $Self->{TicketObject}->TicketDelete(
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't process email with MessageID <$GetParam{'Message-ID'}>! "
                . "Please create a bug report with this email (var/spool/) on http://bugs.otrs.org/!",
        );
        return;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "From: $GetParam{From}\n";
        print "ReplyTo: $GetParam{ReplyTo}\n" if ( $GetParam{ReplyTo} );
        print "To: $GetParam{To}\n";
        print "Cc: $GetParam{Cc}\n" if ( $GetParam{Cc} );
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "Queue: $Queue\n";
        print "SenderType: $GetParam{'X-OTRS-SenderType'}\n";
        print "ArticleType: $GetParam{'X-OTRS-ArticleType'}\n";
    }

    # set free article text
    @Values = ( 'X-OTRS-ArticleKey', 'X-OTRS-ArticleValue' );
    for my $Count ( 1 .. 3 ) {
        if ( $GetParam{ $Values[0] . $Count } ) {
            $Self->{TicketObject}->ArticleFreeTextSet(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                Key       => $GetParam{ $Values[0] . $Count },
                Value     => $GetParam{ $Values[1] . $Count },
                Counter   => $Count,
                UserID    => $Param{InmailUserID},
            );
            if ( $Self->{Debug} > 0 ) {
                print "ArticleKey$Count: " . $GetParam{ $Values[0] . $Count } . "\n";
                print "ArticleValue$Count: " . $GetParam{ $Values[1] . $Count } . "\n";
            }
        }
    }

    # write plain email to the storage
    $Self->{TicketObject}->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => $Self->{ParseObject}->GetPlainEmail(),
        UserID    => $Param{InmailUserID},
    );

    # write attachments to the storage
    for my $Attachment ( $Self->{ParseObject}->GetAttachments() ) {
        $Self->{TicketObject}->ArticleWriteAttachment(
            Content     => $Attachment->{Content},
            Filename    => $Attachment->{Filename},
            ContentType => $Attachment->{ContentType},
            ArticleID   => $ArticleID,
            UserID      => $Param{InmailUserID},
        );
    }

    return $TicketID;
}

1;
