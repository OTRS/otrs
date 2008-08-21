# --
# Kernel/System/PostMaster.pm - the global PostMaster module for OTRS
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PostMaster.pm,v 1.75 2008-08-21 18:56:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster;

use strict;
use warnings;

use Kernel::System::EmailParser;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::State;
use Kernel::System::PostMaster::Reject;
use Kernel::System::PostMaster::FollowUp;
use Kernel::System::PostMaster::NewTicket;
use Kernel::System::PostMaster::DestQueue;

use vars qw(@ISA $VERSION);

$VERSION = qw($Revision: 1.75 $) [1];

=head1 NAME

Kernel::System::PostMaster - postmaster lib

=head1 SYNOPSIS

All postmaster functions. E. g. to process emails.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Postmaster;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject   = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        MainObject   => $MainObject,
        LogObject    => $LogObject,
    );
    my $PostMasterObject = Kernel::System::PostMaster->new(
        DBObject     => DBObject,
        TimeObject   => TimeObject,
        ConfigObject => $ConfigObject,
        MainObject   => $MainObject,
        LogObject    => $LogObject,
        Email        => \@ArrayOfEmailContent,
        Trusted      => 1, # 1|0 ignore X-OTRS header if false
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject LogObject ConfigObject TimeObject MainObject Email)) {
        die "Got no $_" if ( !$Param{$_} );
    }

    # check needed config objects
    for (qw(PostmasterUserID PostmasterX-Header)) {
        $Self->{$_} = $Param{ConfigObject}->Get($_) || die "Found no '$_' option in Config.pm!";
    }

    # for debug 0=off; 1=info; 2=on; 3=with GetHeaderParam;
    $Self->{Debug} = $Param{Debug} || 0;

    # create common objects
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{ParserObject} = Kernel::System::EmailParser->new(
        Email => $Param{Email},
        %Param,
    );
    $Self->{QueueObject}     = Kernel::System::Queue->new(%Param);
    $Self->{StateObject}     = Kernel::System::State->new(%Param);
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new(
        %Param,
        QueueObject  => $Self->{QueueObject},
        ParserObject => $Self->{ParserObject},
    );
    $Self->{NewTicket} = Kernel::System::PostMaster::NewTicket->new(
        %Param,
        Debug                => $Self->{Debug},
        ParserObject         => $Self->{ParserObject},
        TicketObject         => $Self->{TicketObject},
        QueueObject          => $Self->{QueueObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
    );
    $Self->{FollowUp} = Kernel::System::PostMaster::FollowUp->new(
        %Param,
        Debug                => $Self->{Debug},
        TicketObject         => $Self->{TicketObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
        ParserObject         => $Self->{ParserObject},
    );
    $Self->{Reject} = Kernel::System::PostMaster::Reject->new(
        %Param,
        Debug                => $Self->{Debug},
        TicketObject         => $Self->{TicketObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
        ParserObject         => $Self->{ParserObject},
    );

    # should i use the x-otrs header?
    $Self->{Trusted} = defined $Param{Trusted} ? $Param{Trusted} : 1;

    return $Self;
}

=item Run()

to execute the run process

    $PostMasterObject->Run();

return params

    0 = error (also false)
    1 = new ticket created
    2 = follow up / open/reopen
    3 = follow up / close -> new ticket
    4 = follow up / close -> reject
    5 = ignored (because of X-OTRS-Ignore header)

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my @Return = ();

    # ConfigObject section / get params
    my $GetParam = $Self->GetEmailParams();

    # check if follow up
    my ( $Tn, $TicketID ) = $Self->CheckFollowUp( %{$GetParam} );

    # run all PreFilterModules (modify email params)
    if ( ref $Self->{ConfigObject}->Get('PostMaster::PreFilterModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('PostMaster::PreFilterModule') };
        for my $Job ( sort keys %Jobs ) {
            return if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );

            my $FilterObject = $Jobs{$Job}->{Module}->new(
                ConfigObject => $Self->{ConfigObject},
                MainObject   => $Self->{MainObject},
                LogObject    => $Self->{LogObject},
                DBObject     => $Self->{DBObject},
                ParserObject => $Self->{ParserObject},
                TicketObject => $Self->{TicketObject},
                TimeObject   => $Self->{TimeObject},
                Debug        => $Self->{Debug},
            );

            # modify params
            my $Run = $FilterObject->Run(
                GetParam  => $GetParam,
                JobConfig => $Jobs{$Job},
                TicketID  => $TicketID,
            );
            if ( !$Run ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Execute Run() of PreFilterModule $Jobs{$Job}->{Module} not successfully!",
                );
            }
        }
    }

    # should I ignore the incoming mail?
    if ( $GetParam->{'X-OTRS-Ignore'} && $GetParam->{'X-OTRS-Ignore'} =~ /yes/i ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "Ignored Email (From: $GetParam->{'From'}, Message-ID: $GetParam->{'Message-ID'}) "
                . "because the X-OTRS-Ignore is set (X-OTRS-Ignore: $GetParam->{'X-OTRS-Ignore'})."
        );
        return (5);
    }

    # ----------------------
    # ticket section
    # ----------------------

    # check if follow up (again, with new GetParam)
    ( $Tn, $TicketID ) = $Self->CheckFollowUp( %{$GetParam} );

    # check if it's a follow up ...
    if ( $Tn && $TicketID ) {

        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );

        # check if it is possible to do the follow up
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );

        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $Self->{QueueObject}->GetFollowUpLockOption(
            QueueID => $Ticket{QueueID},
        );

        # get state details
        my %State = $Self->{StateObject}->StateGet( ID => $Ticket{StateID} );

        # create a new ticket
        if ( $FollowUpPossible =~ /new ticket/i && $State{TypeName} =~ /^close/i ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Follow up for [$Tn] but follow up not possible ($Ticket{State})."
                    . " Create new ticket."
            );

            # send mail && create new article
            # get queue if of From: and To:
            if ( !$Param{QueueID} ) {
                $Param{QueueID} = $Self->{DestQueueObject}->GetQueueID( Params => $GetParam, );
            }

            # check if trusted returns a new queue id
            my $TQueueID = $Self->{DestQueueObject}->GetTrustedQueueID( Params => $GetParam, );
            if ($TQueueID) {
                $Param{QueueID} = $TQueueID;
            }
            $TicketID = $Self->{NewTicket}->Run(
                InmailUserID     => $Self->{PostmasterUserID},
                GetParam         => $GetParam,
                QueueID          => $Param{QueueID},
                Comment          => "Because the old ticket [$Tn] is '$State{Name}'",
                AutoResponseType => 'auto reply/new ticket',
            );
            if ( !$TicketID ) {
                return;
            }
            @Return = ( 3, $TicketID );
        }

        # reject follow up
        elsif ( $FollowUpPossible =~ /reject/i && $State{TypeName} =~ /^close/i ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Follow up for [$Tn] but follow up not possible. Follow up rejected."
            );

            # send reject mail && and add article to ticket
            my $Run = $Self->{Reject}->Run(
                TicketID         => $TicketID,
                InmailUserID     => $Self->{PostmasterUserID},
                GetParam         => $GetParam,
                Lock             => $Lock,
                Tn               => $Tn,
                Comment          => 'Follow up rejected.',
                AutoResponseType => 'auto reject',
            );
            if ( !$Run ) {
                return;
            }
            @Return = ( 4, $TicketID );
        }

        # create normal follow up
        else {
            my $Run = $Self->{FollowUp}->Run(
                TicketID         => $TicketID,
                InmailUserID     => $Self->{PostmasterUserID},
                GetParam         => $GetParam,
                Lock             => $Lock,
                Tn               => $Tn,
                AutoResponseType => 'auto follow up',
            );
            if ( !$Run ) {
                return;
            }
            @Return = ( 2, $TicketID );
        }
    }

    # create new ticket
    else {
        if ( $Param{Queue} && !$Param{QueueID} ) {

            # queue lookup if queue name is given
            $Param{QueueID} = $Self->{QueueObject}->QueueLookup( Queue => $Param{Queue} );
        }

        # get queue if of From: and To:
        if ( !$Param{QueueID} ) {
            $Param{QueueID} = $Self->{DestQueueObject}->GetQueueID( Params => $GetParam );
        }

        # check if trusted returns a new queue id
        my $TQueueID = $Self->{DestQueueObject}->GetTrustedQueueID( Params => $GetParam, );
        if ($TQueueID) {
            $Param{QueueID} = $TQueueID;
        }
        $TicketID = $Self->{NewTicket}->Run(
            InmailUserID     => $Self->{PostmasterUserID},
            GetParam         => $GetParam,
            QueueID          => $Param{QueueID},
            AutoResponseType => 'auto reply',
        );
        if ( !$TicketID ) {
            return;
        }
        @Return = ( 1, $TicketID );
    }

    # run all PostFilterModules (modify email params)
    if ( ref $Self->{ConfigObject}->Get('PostMaster::PostFilterModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('PostMaster::PostFilterModule') };
        for my $Job ( sort keys %Jobs ) {
            return if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );

            my $FilterObject = $Jobs{$Job}->{Module}->new(
                ConfigObject => $Self->{ConfigObject},
                MainObject   => $Self->{MainObject},
                LogObject    => $Self->{LogObject},
                DBObject     => $Self->{DBObject},
                ParserObject => $Self->{ParserObject},
                TicketObject => $Self->{TicketObject},
                TimeObject   => $Self->{TimeObject},
                Debug        => $Self->{Debug},
            );

            # modify params
            my $Run = $FilterObject->Run(
                TicketID  => $TicketID,
                GetParam  => $GetParam,
                JobConfig => $Jobs{$Job},
            );
            if ( !$Run ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Execute Run() of PostFilterModule $Jobs{$Job}->{Module} not successfully!",
                );
            }
        }
    }
    return @Return;
}

=item CheckFollowUp()

to detect the ticket number in processing email

    my ($TicketNumber, $TicketID) = $PostMasterObject->CheckFollowUp(
        Subject => 'Re: [Ticket:#123456] Some Subject',
    );

=cut

sub CheckFollowUp {
    my ( $Self, %Param ) = @_;

    my $Subject = $Param{Subject} || '';
    my $Tn = $Self->{TicketObject}->GetTNByString($Subject);

    if ($Tn) {
        my $TicketID = $Self->{TicketObject}->TicketCheckNumber( Tn => $Tn );
        return if !$TicketID;

        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
        if ( $Self->{Debug} > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "CheckFollowUp: ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
            );
        }
        return ( $Ticket{TicketNumber}, $TicketID );
    }

    # There is no valid ticket number in the subject.
    # Try to find ticket number in References and In-Reply-To header.
    if ( $Self->{ConfigObject}->Get('PostmasterFollowUpSearchInReferences') ) {
        my @References = $Self->{ParserObject}->GetReferences();
        for my $Reference (@References) {

            # get ticket id of message id
            my $TicketID = $Self->{TicketObject}->ArticleGetTicketIDOfMessageID(
                MessageID => "<$Reference>",
            );
            if ($TicketID) {
                my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $TicketID, );
                if ( $TicketID && $Tn ) {
                    return ( $Tn, $TicketID );
                }
            }
        }
    }

    # do body ticket number lookup
    if ( $Self->{ConfigObject}->Get('PostmasterFollowUpSearchInBody') ) {
        my $Tn = $Self->{TicketObject}->GetTNByString( $Self->{ParserObject}->GetMessageBody() );
        if ($Tn) {
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber( Tn => $Tn );
            if ($TicketID) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message =>
                            "CheckFollowUp (in body): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                    );
                }
                return ( $Ticket{TicketNumber}, $TicketID );
            }
        }
    }

    # do attachment ticket number lookup
    if ( $Self->{ConfigObject}->Get('PostmasterFollowUpSearchInAttachment') ) {
        for my $Attachment ( $Self->{ParserObject}->GetAttachments() ) {
            my $Tn = $Self->{TicketObject}->GetTNByString( $Attachment->{Content} );
            if ($Tn) {
                my $TicketID = $Self->{TicketObject}->TicketCheckNumber( Tn => $Tn );
                if ($TicketID) {
                    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
                    if ( $Self->{Debug} > 1 ) {
                        $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message =>
                                "CheckFollowUp (in attachment): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                        );
                    }
                    return ( $Ticket{TicketNumber}, $TicketID );
                }
            }
        }
    }

    # do plain/raw ticket number lookup
    if ( $Self->{ConfigObject}->Get('PostmasterFollowUpSearchInRaw') ) {
        my $Tn = $Self->{TicketObject}->GetTNByString( $Self->{ParserObject}->GetPlainEmail() );
        if ($Tn) {
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber( Tn => $Tn );
            if ($TicketID) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message =>
                            "CheckFollowUp (in plain/raw): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                    );
                }
                return ( $Ticket{TicketNumber}, $TicketID );
            }
        }
    }
    return;
}

=item GetEmailParams()

to get all configured PostmasterX-Header email headers

    my %Header = $PostMasterObject->GetEmailParams();

=cut

sub GetEmailParams {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    # parse section
    my $WantParamTmp = $Self->{'PostmasterX-Header'} || die 'Got no @WantParam ref';
    my @WantParam = @$WantParamTmp;
    for my $Param (@WantParam) {
        if ( !$Self->{Trusted} && $Param =~ /^x-otrs/i ) {

            # scan not x-otrs header if it's not trusted
        }
        else {
            if ( $Self->{Debug} > 2 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "$Param: " . $Self->{ParserObject}->GetParam( WHAT => $Param ),
                );
            }
            $GetParam{$Param} = $Self->{ParserObject}->GetParam( WHAT => $Param );
        }
    }

    # set compat. headers
    if ( $GetParam{'Message-Id'} ) {
        $GetParam{'Message-ID'} = $GetParam{'Message-Id'};
    }
    if ( $GetParam{'Reply-To'} ) {
        $GetParam{'ReplyTo'} = $GetParam{'Reply-To'};
    }
    if (
        $GetParam{'Mailing-List'}
        || $GetParam{'Precedence'}
        || $GetParam{'X-Loop'}
        || $GetParam{'X-No-Loop'}
        || $GetParam{'X-OTRS-Loop'}
        )
    {
        $GetParam{'X-OTRS-Loop'} = 'yes';
    }
    if ( !$GetParam{'X-Sender'} ) {

        # get sender email
        my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
            Line => $GetParam{From},
        );
        for my $Email (@EmailAddresses) {
            $GetParam{'X-Sender'} = $Self->{ParserObject}->GetEmailAddress(
                Email => $Email,
            );
        }
    }

    # set sender type if not given
    for my $Key (qw(X-OTRS-SenderType X-OTRS-FollowUp-SenderType)) {
        if ( !$GetParam{$Key} ) {
            $GetParam{$Key} = 'customer';
        }

        # check if X-OTRS-SenderType exists, if not, set customer
        if ( !$Self->{TicketObject}->ArticleSenderTypeLookup( SenderType => $GetParam{$Key} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't find sender type '$GetParam{$Key}' in db, take 'customer'",
            );
            $GetParam{$Key} = 'customer';
        }
    }

    # set article type if not given
    for my $Key (qw(X-OTRS-ArticleType X-OTRS-FollowUp-ArticleType)) {
        if ( !$GetParam{$Key} ) {
            $GetParam{$Key} = 'email-external';
        }

        # check if X-OTRS-ArticleType exists, if not, set 'email'
        if ( !$Self->{TicketObject}->ArticleTypeLookup( ArticleType => $GetParam{$Key} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't find article type '$GetParam{$Key}' in db, take 'email-external'",
            );
            $GetParam{$Key} = 'email-external';
        }
    }

    # get body
    $GetParam{Body} = $Self->{ParserObject}->GetMessageBody();

    # get content type
    $GetParam{'Content-Type'} = $Self->{ParserObject}->GetReturnContentType();
    $GetParam{Charset} = $Self->{ParserObject}->GetReturnCharset();

    # get attachments
    my @Attachments = $Self->{ParserObject}->GetAttachments();
    $GetParam{Attachment} = \@Attachments;

    # return params
    return \%GetParam;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.75 $ $Date: 2008-08-21 18:56:11 $

=cut
