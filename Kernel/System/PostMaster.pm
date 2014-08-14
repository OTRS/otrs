# --
# Kernel/System/PostMaster.pm - the global PostMaster module for OTRS
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster;

use strict;
use warnings;

use Kernel::System::EmailParser;
use Kernel::System::PostMaster::DestQueue;
use Kernel::System::PostMaster::NewTicket;
use Kernel::System::PostMaster::FollowUp;
use Kernel::System::PostMaster::Reject;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::State',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::PostMaster - postmaster lib

=head1 SYNOPSIS

All postmaster functions. E. g. to process emails.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::PostMaster' => {
            Email        => \@ArrayOfEmailContent,
            Trusted      => 1, # 1|0 ignore X-OTRS header if false
        },
    );
    my $PostMasterObject = $Kernel::OM->Get('Kernel::System::PostMaster');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    $Self->{Email} = $Param{Email} || die "Got no Email!";

    # for debug 0=off; 1=info; 2=on; 3=with GetHeaderParam;
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{ParserObject} = Kernel::System::EmailParser->new(
        Email => $Param{Email},
    );

    # create needed objects
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new( %{$Self} );
    $Self->{NewTicketObject} = Kernel::System::PostMaster::NewTicket->new( %{$Self} );
    $Self->{FollowUpObject}  = Kernel::System::PostMaster::FollowUp->new( %{$Self} );
    $Self->{RejectObject}    = Kernel::System::PostMaster::Reject->new( %{$Self} );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check needed config options
    for my $Option (qw(PostmasterUserID PostmasterX-Header)) {
        $Self->{$Option} = $ConfigObject->Get($Option)
            || die "Found no '$Option' option in configuration!";
    }

    # should I use x-otrs headers?
    $Self->{Trusted} = defined $Param{Trusted} ? $Param{Trusted} : 1;

    if ( $Self->{Trusted} ) {

        # get dynamic field objects
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # add Dynamic Field headers
        my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ObjectType => [ 'Ticket', 'Article' ],
            ResultType => 'HASH',
        );

        # create a lookup table
        my %HeaderLookup = map { $_ => 1 } @{ $Self->{'PostmasterX-Header'} };

        for my $DynamicField ( values %$DynamicFields ) {
            for my $Header (
                'X-OTRS-DynamicField-' . $DynamicField,
                'X-OTRS-FollowUp-DynamicField-' . $DynamicField,
                )
            {

                # only add the header if is not alreday in the conifg
                if ( !$HeaderLookup{$Header} ) {
                    push @{ $Self->{'PostmasterX-Header'} }, $Header;
                }
            }
        }
    }

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

    my @Return;

    # ConfigObject section / get params
    my $GetParam = $Self->GetEmailParams();

    # check if follow up
    my ( $Tn, $TicketID ) = $Self->CheckFollowUp( %{$GetParam} );

    # get config objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # run all PreFilterModules (modify email params)
    if ( ref $ConfigObject->Get('PostMaster::PreFilterModule') eq 'HASH' ) {

        my %Jobs = %{ $ConfigObject->Get('PostMaster::PreFilterModule') };

        # get main objects
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        JOB:
        for my $Job ( sort keys %Jobs ) {

            return if !$MainObject->Require( $Jobs{$Job}->{Module} );

            my $FilterObject = $Jobs{$Job}->{Module}->new(
                %{$Self},
            );

            if ( !$FilterObject ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "new() of PreFilterModule $Jobs{$Job}->{Module} not successfully!",
                );
                next JOB;
            }

            # modify params
            my $Run = $FilterObject->Run(
                GetParam  => $GetParam,
                JobConfig => $Jobs{$Job},
                TicketID  => $TicketID,
            );
            if ( !$Run ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "Execute Run() of PreFilterModule $Jobs{$Job}->{Module} not successfully!",
                );
            }
        }
    }

    # should I ignore the incoming mail?
    if ( $GetParam->{'X-OTRS-Ignore'} && $GetParam->{'X-OTRS-Ignore'} =~ /(yes|true)/i ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # check if it is possible to do the follow up
        # get follow up option (possible or not)
        my $FollowUpPossible = $QueueObject->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );

        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $QueueObject->GetFollowUpLockOption(
            QueueID => $Ticket{QueueID},
        );

        # get state details
        my %State = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            ID => $Ticket{StateID},
        );

        # create a new ticket
        if ( $FollowUpPossible =~ /new ticket/i && $State{TypeName} =~ /^close/i ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
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

            # Clean out the old TicketNumber from the subject (see bug#9108).
            # This avoids false ticket number detection on customer replies.
            if ( $GetParam->{Subject} ) {
                $GetParam->{Subject} = $TicketObject->TicketSubjectClean(
                    TicketNumber => $Tn,
                    Subject      => $GetParam->{Subject},
                );
            }

            $TicketID = $Self->{NewTicketObject}->Run(
                InmailUserID     => $Self->{PostmasterUserID},
                GetParam         => $GetParam,
                QueueID          => $Param{QueueID},
                Comment          => "Because the old ticket [$Tn] is '$State{Name}'",
                AutoResponseType => 'auto reply/new ticket',
                LinkToTicketID   => $TicketID,
            );

            if ( !$TicketID ) {
                return;
            }

            @Return = ( 3, $TicketID );
        }

        # reject follow up
        elsif ( $FollowUpPossible =~ /reject/i && $State{TypeName} =~ /^close/i ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Follow up for [$Tn] but follow up not possible. Follow up rejected."
            );

            # send reject mail && and add article to ticket
            my $Run = $Self->{RejectObject}->Run(
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

            my $Run = $Self->{FollowUpObject}->Run(
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
            $Param{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
                Queue => $Param{Queue},
            );
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
        $TicketID = $Self->{NewTicketObject}->Run(
            InmailUserID     => $Self->{PostmasterUserID},
            GetParam         => $GetParam,
            QueueID          => $Param{QueueID},
            AutoResponseType => 'auto reply',
        );

        return if !$TicketID;

        @Return = ( 1, $TicketID );
    }

    # run all PostFilterModules (modify email params)
    if ( ref $ConfigObject->Get('PostMaster::PostFilterModule') eq 'HASH' ) {

        my %Jobs = %{ $ConfigObject->Get('PostMaster::PostFilterModule') };

        # get main objects
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        JOB:
        for my $Job ( sort keys %Jobs ) {

            return if !$MainObject->Require( $Jobs{$Job}->{Module} );

            my $FilterObject = $Jobs{$Job}->{Module}->new(
                %{$Self},
            );

            if ( !$FilterObject ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "new() of PostFilterModule $Jobs{$Job}->{Module} not successfully!",
                );
                next JOB;
            }

            # modify params
            my $Run = $FilterObject->Run(
                TicketID  => $TicketID,
                GetParam  => $GetParam,
                JobConfig => $Jobs{$Job},
            );

            if ( !$Run ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Subject = $Param{Subject} || '';
    my $Tn = $TicketObject->GetTNByString($Subject);

    if ($Tn) {

        my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

        return if !$TicketID;

        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        if ( $Self->{Debug} > 1 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "CheckFollowUp: ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
            );
        }

        return ( $Ticket{TicketNumber}, $TicketID );
    }

    # get config objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # There is no valid ticket number in the subject.
    # Try to find ticket number in References and In-Reply-To header.
    if ( $ConfigObject->Get('PostmasterFollowUpSearchInReferences') ) {

        my @References = $Self->{ParserObject}->GetReferences();

        REFERENCE:
        for my $Reference (@References) {

            # get ticket id of message id
            my $TicketID = $TicketObject->ArticleGetTicketIDOfMessageID(
                MessageID => "<$Reference>",
            );

            next REFERENCE if !$TicketID;

            my $Tn = $TicketObject->TicketNumberLookup( TicketID => $TicketID, );

            if ( $TicketID && $Tn ) {
                return ( $Tn, $TicketID );
            }
        }
    }

    # do body ticket number lookup
    if ( $ConfigObject->Get('PostmasterFollowUpSearchInBody') ) {

        my $Tn = $TicketObject->GetTNByString( $Self->{ParserObject}->GetMessageBody() );

        if ($Tn) {

            my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

            if ($TicketID) {

                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );

                if ( $Self->{Debug} > 1 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    if ( $ConfigObject->Get('PostmasterFollowUpSearchInAttachment') ) {

        for my $Attachment ( $Self->{ParserObject}->GetAttachments() ) {

            my $Tn = $TicketObject->GetTNByString( $Attachment->{Content} );

            if ($Tn) {

                my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

                if ($TicketID) {

                    my %Ticket = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                    );

                    if ( $Self->{Debug} > 1 ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    if ( $ConfigObject->Get('PostmasterFollowUpSearchInRaw') ) {

        my $Tn = $TicketObject->GetTNByString( $Self->{ParserObject}->GetPlainEmail() );

        if ($Tn) {

            my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

            if ($TicketID) {

                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );

                if ( $Self->{Debug} > 1 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    HEADER:
    for my $Param ( @{ $Self->{'PostmasterX-Header'} } ) {

        # do not scan x-otrs headers if mailbox is not marked as trusted
        next HEADER if ( !$Self->{Trusted} && $Param =~ /^x-otrs/i );
        if ( $Self->{Debug} > 2 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message => "$Param: " . $Self->{ParserObject}->GetParam( WHAT => $Param ),
            );
        }
        $GetParam{$Param} = $Self->{ParserObject}->GetParam( WHAT => $Param );
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
        || (
            $GetParam{'Auto-Submitted'}
            && substr( $GetParam{'Auto-Submitted'}, 0, 5 ) eq 'auto-'
        )
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

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # set sender type if not given
    for my $Key (qw(X-OTRS-SenderType X-OTRS-FollowUp-SenderType)) {

        if ( !$GetParam{$Key} ) {
            $GetParam{$Key} = 'customer';
        }

        # check if X-OTRS-SenderType exists, if not, set customer
        if ( !$TicketObject->ArticleSenderTypeLookup( SenderType => $GetParam{$Key} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        if ( !$TicketObject->ArticleTypeLookup( ArticleType => $GetParam{$Key} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    return \%GetParam;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
