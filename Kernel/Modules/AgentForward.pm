# --
# AgentForward.pm - to forward a message
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentForward.pm,v 1.4 2002-07-12 23:01:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentForward;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
      'ArticleObject',
    ) {
        die "Got no $_" if (!$Self->{$_});
    }

    # get params
    $Self->{From} = $Self->{ParamObject}->GetParam(Param => 'From') || '';
    $Self->{To} = $Self->{ParamObject}->GetParam(Param => 'To') || '';
    $Self->{Cc} = $Self->{ParamObject}->GetParam(Param => 'Cc') || '';
    $Self->{Subject} = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
    $Self->{Body} = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
    $Self->{Email} = $Self->{ParamObject}->GetParam(Param => 'Email') || '';
    $Self->{InReplyTo} = $Self->{ParamObject}->GetParam(Param => 'InReplyTo') || '';
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID') || '';
    $Self->{ArticleTypeID} = $Self->{ParamObject}->GetParam(Param => 'ArticleTypeID') || '';
    $Self->{NextStateID} = $Self->{ParamObject}->GetParam(Param => 'ComposeStateID') || '';
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    
    if ($Self->{Subaction} eq 'SendEmail') {
        $Output = $Self->SendEmail();
    }
    else {
        $Output = $Self->Form();
    }
    return $Output;
}
# --
sub Form {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
  
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header();
 
    # check needed stuff
    if (!$TicketID) {
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Got no TicketID!",
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
 
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
    my $QueueObject = Kernel::System::Queue->new(
        QueueID => $QueueID,
        DBObject => $Self->{DBObject}
    );

    # get lock state && permissions
    my $LockState = $Self->{TicketObject}->GetLockState(TicketID => $TicketID) || 0;
    if (!$LockState) {
        # set owner
        $Self->{TicketObject}->SetOwner(
            TicketID => $TicketID,
            UserID => $UserID,
            NewUserID => $UserID,
        );
        # set lock
        if ($Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'lock',
            UserID => $UserID
        )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
        }
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
            TicketID => $TicketID,
        );
        
        if ($OwnerID != $UserID) {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Sorry, the current owner is $OwnerLogin",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    
    # get last customer article or selecte article ...
    my %Data = ();
    if ($Self->{ArticleID}) {
        %Data = $Self->{ArticleObject}->GetArticle(
            ArticleID => $Self->{ArticleID},
        );
    }
    else {
        %Data = $Self->{TicketObject}->GetLastCustomerArticle(
            TicketID => $TicketID,
        );
    }

    # prepare body ...
    my $NewLine = $Self->{ConfigObject}->Get('ComposeTicketNewLine') || 75;
    $Data{Body} =~ s/(.{$NewLine}.+?\s)/$1\n/g;
    $Data{Body} =~ s/\n/\n> /g;
    $Data{Body} = "\n> " . $Data{Body};

    # prepare subject ...
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
    $Data{Subject} =~ s/\[$TicketHook: $Tn\] //g;
    $Data{Subject} =~ s/^(.{30}).*$/$1 [...]/;
    $Data{Subject} = "[$TicketHook: $Tn-FW] " . $Data{Subject};

    # prepare from ...
    my %Address = $QueueObject->GetSystemAddress();
    $Data{SystemFrom} = "$Address{RealName} <$Address{Email}>";
    $Data{Email} = $Address{Email};
    $Data{RealName} = $Address{RealName};

    # prepare signature
    my $Signature = $QueueObject->GetSignature();
    $Signature =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
    $Signature =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;

    # get next states
    my %NextStates;
    my $NextComposeTypePossibleTmp = 
       $Self->{ConfigObject}->Get('DefaultNextForwardTypePossible')
           || die 'No Config entry "DefaultNextForwardTypePossible"!';
    my @NextComposeTypePossible = @$NextComposeTypePossibleTmp;
    foreach (@NextComposeTypePossible) {
        $NextStates{$Self->{TicketObject}->StateLookup(State => $_)} = $_;
    }

    my %ArticleTypes;
    my $ArticleTypesTmp = 
       $Self->{ConfigObject}->Get('DefaultForwardEmailType')
           || die 'No Config entry "DefaultForwardEmailType"!';
    my @ArticleTypePossible = @$ArticleTypesTmp;
    foreach (@ArticleTypePossible) {
        $ArticleTypes{$Self->{ArticleObject}->ArticleTypeLookup(ArticleType => $_)} = $_;
    }

    # build view ...
    $Output .= $Self->{LayoutObject}->AgentForward(
        TicketNumber => $Tn,
        Salutation => $QueueObject->GetSalutation(),
        Signature => $Signature,
        TicketID => $TicketID,
        QueueID => $QueueID,
        NextScreen => $Self->{NextScreen},
        LockState => $LockState,
        NextStates => \%NextStates,
        ArticleTypes => \%ArticleTypes,
        %Data,
    );
    
    $Output .= $Self->{LayoutObject}->Footer();
    
    return $Output;
}
# --
sub SendEmail {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{QueueID};
    my $TicketID = $Self->{TicketID};
    my $NextScreen = $Self->{NextScreen} || '';
    my $Charset = $Self->{UserCharset} || '';
    my $NextStateID = $Self->{NextStateID} || '??';
    my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
    my $UserID = $Self->{UserID};
    
    # save article
    my $ArticleID = $Self->{ArticleObject}->CreateArticleDB(
        TicketID => $TicketID,
        ArticleTypeID => $Self->{ArticleTypeID},
        SenderType => 'agent',
        From => $Self->{From},
        To => $Self->{To},
        Cc => $Self->{Cc},
        Subject => $Self->{Subject},
        Body => $Self->{Body},
        CreateUserID => $UserID,
    );
    # send email
    my $EmailObject = Kernel::System::EmailSend->new(
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject => $Self->{LogObject},
    );
    $EmailObject->Send(
        From => $Self->{From},
        Email => $Self->{Email},
        To => $Self->{To},
        Cc => $Self->{Cc},
        Subject => $Self->{Subject},
        Body => $Self->{Body},
        TicketID => $TicketID,
        ArticleID => $ArticleID,
        UserID => $UserID,
        Charset => $Charset,
        InReplyTo => $Self->{InReplyTo},
        DBObject => $Self->{DBObject},
        TicketObject => $Self->{TicketObject},
    );
    # set state
    if ($Self->{TicketObject}->GetState(TicketID => $TicketID)  ne $NextState) {
        $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $UserID,
        );
    }
    # should i set an unlock?
    if ($NextState =~ /^close/i) {
        $Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'unlock',
            UserID => $UserID,
        );
    }
    # make redirect
    $Output .= $Self->{LayoutObject}->Redirect(
        OP => "&Action=$NextScreen&QueueID=$QueueID",
    );
    return $Output;
}
# --

1;
