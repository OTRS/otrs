# --
# Kernel/Modules/AgentTicketBounce.pm - to bounce articles of tickets
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketBounce.pm,v 1.4 2006-02-09 23:52:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketBounce;

use strict;
use Kernel::System::State;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      QueueObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);

    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID') || '';

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
    foreach (qw(ArticleID TicketID QueueID)) {
        if (! defined $Self->{$_}) {
            return $Self->{LayoutObject}->ErrorScreen(
              Message => "$_ is needed!",
              Comment => 'Please contact your admin',
            );
        }
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'bounce',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    $Param{TicketNumber} = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    $Param{QueueID} = $Self->{TicketObject}->TicketQueueID(TicketID => $Self->{TicketID});
    # --
    # prepare salutation
    # --
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        $Output .= $Self->{LayoutObject}->Header(Value => $Param{TicketNumber});
        # --
        # check if plain article exists
        # --
        if (!$Self->{TicketObject}->ArticlePlain(ArticleID => $Self->{ArticleID})) {
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # --
        # get lock state && permissions
        # --
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            # set lock
            if ($Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID},
            )) {
                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'TicketLocked',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
         }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );

            if ($OwnerID != $Self->{UserID}) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, the current owner is $OwnerLogin!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketBack',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }

        # --
        # get article data
        # --
        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID => $Self->{ArticleID},
        );
        # --
        # prepare subject ...
        # --
        $Article{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Param{TicketNumber},
            Subject => $Article{Subject} || '',
        );
        # --
        # prepare to (ReplyTo!) ...
        # --
        if ($Article{ReplyTo}) {
            $Article{To} = $Article{ReplyTo};
        }
        else {
            $Article{To} = $Article{From};
        }
        # --
        # prepare salutation
        # --
        $Param{Salutation} = $Self->{QueueObject}->GetSalutation(%Article);
        # prepare customer realname
        if ($Param{Salutation} =~ /<OTRS_CUSTOMER_REALNAME>/) {
            # get realname
            my $From = '';
            if ($Article{CustomerUserID}) {
                $From = $Self->{CustomerUserObject}->CustomerName(UserLogin => $Article{CustomerUserID});
            }
            if (!$From) {
                $From = $Article{From} || '';
                $From =~ s/<.*>|\(.*\)|\"|;|,//g;
                $From =~ s/( $)|(  $)//g;
            }
            # get realname
            $Param{Salutation} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
        }
        # --
        # prepare signature
        # --
        $Param{Signature} = $Self->{QueueObject}->GetSignature(%Article);
        foreach (qw(Signature Salutation)) {
            $Param{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
            $Param{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
            $Param{$_} =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
            $Param{$_} =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;
            # replace user staff
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Self->{UserID},
                Cached => 1,
            );
            foreach my $UserKey (keys %User) {
                if ($User{$UserKey}) {
                    $Param{$_} =~ s/<OTRS_Agent_$UserKey>/$User{$UserKey}/gi;
                }
            }
            # cleanup all not needed <OTRS_TICKET_ tags
            $Param{$_} =~ s/<OTRS_Agent_.+?>/-/gi;
        }
        # --
        # prepare body ...
        # --
        my $NewLine = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 75;
        $Article{Body} =~ s/(.{$NewLine}.+?\s)/$1\n/g;
        $Article{Body} =~ s/\n/\n> /g;
        $Article{Body} = "\n> " . $Article{Body};
        my @Body = split(/\n/, $Article{Body});
        $Article{Body} = '';
        foreach (1..4) {
            $Article{Body} .= $Body[$_]."\n" if ($Body[$_]);
        }
        # --
        # prepare from ...
        # --
        my %Address = $Self->{QueueObject}->GetSystemAddress(
            QueueID => $Article{QueueID},
        );
        $Article{From} = "$Address{RealName} <$Address{Email}>";
        $Article{Email} = $Address{Email};
        $Article{RealName} = $Address{RealName};

        # get next states
        my %NextStates = $Self->{TicketObject}->StateList(
            Type => 'DefaultNextBounce',
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        # print form ...
        $Output .= $Self->_Mask(
            %Param,
            %Article,
            TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            NextStates => \%NextStates,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    elsif ($Self->{Subaction} eq 'Store') {
        # --
        # get params
        # --
        foreach (qw(BounceTo To Subject Body InformSender BounceStateID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # check forward email address
        # --
        foreach my $Email (Mail::Address->parse($Param{BounceTo})) {
            my $Address = $Email->address();
            if ($Self->{SystemAddress}->SystemAddressIsLocalAddress(Address => $Address)) {
                # --
                # error page
                # --
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Can't forward ticket to $Address! It's a local ".
                      "address! You need to move it!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # --
        # prepare from ...
        # --
        # get article data
        # --
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Self->{TicketID},
        );
        my %Address = $Self->{QueueObject}->GetSystemAddress(
            QueueID => $Ticket{QueueID},
        );
        $Param{From} = "$Address{RealName} <$Address{Email}>";
        $Param{Email} = $Address{Email};
        $Param{EmailPlain} = $Self->{TicketObject}->ArticlePlain(ArticleID => $Self->{ArticleID});
        if (!$Self->{TicketObject}->ArticleBounce(
            TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            UserID => $Self->{UserID},
            To => $Param{BounceTo},
            From => $Param{Email},
            Email => $Param{EmailPlain},
            HistoryType => 'Bounce',
        )) {
           # error page
           return $Self->{LayoutObject}->ErrorScreen(
               Message => "Can't bounce email!",
               Comment => 'Please contact the admin.',
           );
        }
        # --
        # send customer info?
        # --
        if ($Param{InformSender}) {
            $Param{Body} =~ s/<OTRS_TICKET>/$Param{TicketNumber}/g;
            $Param{Body} =~ s/<OTRS_BOUNCE_TO>/$Param{BounceTo}/g;
            if (my $ArticleID = $Self->{TicketObject}->ArticleSend(
              ArticleType => 'email-external',
              SenderType => 'agent',
              TicketID => $Self->{TicketID},
              HistoryType => 'Bounce',
              HistoryComment => "Bounced info to '$Param{To}'.",
              From => $Param{From},
              Email => $Param{Email},
              To => $Param{To},
              Subject => $Param{Subject},
              UserID => $Self->{UserID},
              Body => $Param{Body},
              Charset => $Self->{LayoutObject}->{UserCharset},
              Type => 'text/plain',
            )) {
              ###
            }
            else {
                # error page
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Can't send email!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
        # set state
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $Param{BounceStateID},
        );
        my $NextState = $StateData{Name};
        $Self->{TicketObject}->StateSet(
            TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            State => $NextState,
            UserID => $Self->{UserID},
          );
        # should i set an unlock?
        if ($StateData{TypeName} =~ /^close/i) {
          $Self->{TicketObject}->LockSet(
            TicketID => $Self->{TicketID},
            Lock => 'unlock',
            UserID => $Self->{UserID},
          );
        }
        # redirect
        if ($StateData{TypeName} =~ /^close/i) {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
        }
        else {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Wrong Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'BounceStateID',
        Selected => $Self->{ConfigObject}->Get('Ticket::Frontend::BounceState'),
    );
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketBounce', Data => \%Param);
}
# --
1;
