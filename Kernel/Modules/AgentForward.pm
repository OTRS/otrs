# --
# Kernel/Modules/AgentForward.pm - to forward a message
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentForward.pm,v 1.19 2003-03-11 18:34:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentForward;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject 
      LogObject TicketObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    # get params
    $Self->{From} = $Self->{ParamObject}->GetParam(Param => 'From') || '';
    $Self->{To} = $Self->{ParamObject}->GetParam(Param => 'To') || '';
    $Self->{Cc} = $Self->{ParamObject}->GetParam(Param => 'Cc') || '';
    $Self->{Subject} = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
    $Self->{Body} = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
    $Self->{InReplyTo} = $Self->{ParamObject}->GetParam(Param => 'InReplyTo') || '';
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID') || '';
    $Self->{ArticleTypeID} = $Self->{ParamObject}->GetParam(Param => 'ArticleTypeID') || '';
    $Self->{NextStateID} = $Self->{ParamObject}->GetParam(Param => 'ComposeStateID') || '';
    $Self->{TimeUnits} = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        # --
        # error page
        # --
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "Can't forward ticket, no TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

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
 
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
    my $QueueObject = Kernel::System::Queue->new(
        QueueID => $QueueID,
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject => $Self->{LogObject},
    );

    # get lock state && permissions
    if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID)) {
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
        %Data = $Self->{TicketObject}->GetArticle(
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
    $Signature =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
    $Signature =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;

    # get next states
    my %NextStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'DefaultNextForward',
        Result => 'HASH',
    );

    my %ArticleTypes;
    my $ArticleTypesTmp = 
       $Self->{ConfigObject}->Get('DefaultForwardEmailType')
           || die 'No Config entry "DefaultForwardEmailType"!';
    my @ArticleTypePossible = @$ArticleTypesTmp;
    foreach (@ArticleTypePossible) {
        $ArticleTypes{$Self->{TicketObject}->ArticleTypeLookup(ArticleType => $_)} = $_;
    }

    # build view ...
    $Output .= $Self->{LayoutObject}->AgentForward(
        TicketNumber => $Tn,
        Salutation => $QueueObject->GetSalutation(),
        Signature => $Signature,
        TicketID => $TicketID,
        QueueID => $QueueID,
        NextScreen => $Self->{NextScreen},
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
    # --    
    # send email
    # --
    if (my $ArticleID = $Self->{TicketObject}->SendArticle(
        From => $Self->{From},
        To => $Self->{To},
        Cc => $Self->{Cc},
        Subject => $Self->{Subject},
        Body => $Self->{Body},
        TicketID => $TicketID,
        ArticleTypeID => $Self->{ArticleTypeID},
        SenderType => 'agent',
        UserID => $UserID,
        Charset => $Charset,
        InReplyTo => $Self->{InReplyTo},
        HistoryType => 'Forward',
        HistoryComment => "Forwarded to '$Self->{To}, $Self->{Cc}'",
    )) {
      # --
      # time accounting
      # --
      if ($Self->{TimeUnits}) {
          $Self->{TicketObject}->AccountTime(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            TimeUnit => $Self->{TimeUnits},
            UserID => $UserID,
          );
      }
      # --
      # set state
      # --
      $Self->{TicketObject}->SetState(
        TicketID => $TicketID,
        ArticleID => $ArticleID,
        State => $NextState,
        UserID => $UserID,
      );
      # --
      # should i set an unlock?
      # --
      my %StateData = $Self->{StateObject}->StateGet(ID => $NextStateID);
      if ($StateData{TypeName} =~ /^close/i) {
        $Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'unlock',
            UserID => $UserID,
        );
      }
      # --
      # redirect
      # --
      return $Self->{LayoutObject}->Redirect(
        OP => "Action=$NextScreen&QueueID=$QueueID",
      );
    }
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
