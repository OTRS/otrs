# --
# Kernel/Modules/AgentTicketBounce.pm - to bounce articles of tickets
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketBounce.pm,v 1.7 2006-08-29 17:17:24 martin Exp $
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
$VERSION = '$Revision: 1.7 $';
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

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID TicketID QueueID)) {
        if (! defined $Self->{$_}) {
            return $Self->{LayoutObject}->ErrorScreen(
              Message => "$_ is needed!",
              Comment => 'Please contact your admin',
            );
        }
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # get lock state && write (lock) permissions
    if ($Self->{Config}->{RequiredLock}) {
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            );
            if ($Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
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
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID => $Self->{UserID},
            );
            if (!$AccessOk) {
                my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{Number});
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to be the owner to do this action!",
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
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
            },
        );
    }

    # prepare salutation
    if (!$Self->{Subaction}) {
        # check if plain article exists
        if (!$Self->{TicketObject}->ArticlePlain(ArticleID => $Self->{ArticleID})) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        # get article data
        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID => $Self->{ArticleID},
        );
        # prepare subject ...
        $Article{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Param{TicketNumber},
            Subject => $Article{Subject} || '',
        );
        # prepare to (ReplyTo!) ...
        if ($Article{ReplyTo}) {
            $Article{To} = $Article{ReplyTo};
        }
        else {
            $Article{To} = $Article{From};
        }
        # prepare salutation
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
        # prepare signature
        $Param{Signature} = $Self->{QueueObject}->GetSignature(%Article);
        foreach (qw(Signature Salutation)) {
            $Param{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
            $Param{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
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
            # cleanup all not needed <OTRS_Agent_tags
            $Param{$_} =~ s/<OTRS_Agent_.+?>/-/gi;
            foreach my $Key (keys %Ticket) {
                if ($Ticket{$Key}) {
                    $Param{$_} =~ s/<OTRS_TICKET_$Key>/$Ticket{$Key}/gi;
                }
            }
            # cleanup all not needed <OTRS_TICKET_ tags
            $Param{$_} =~ s/<OTRS_TICKET_.+?>/-/gi;
        }
        # prepare body ...
        my $NewLine = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 75;
        $Article{Body} =~ s/(.{$NewLine}.+?\s)/$1\n/g;
        $Article{Body} =~ s/\n/\n> /g;
        $Article{Body} = "\n> " . $Article{Body};
        my @Body = split(/\n/, $Article{Body});
        $Article{Body} = '';
        foreach (1..4) {
            $Article{Body} .= $Body[$_]."\n" if ($Body[$_]);
        }
        # prepare from ...
        my %Address = $Self->{QueueObject}->GetSystemAddress(
            QueueID => $Article{QueueID},
        );
        $Article{From} = "$Address{RealName} <$Address{Email}>";
        $Article{Email} = $Address{Email};
        $Article{RealName} = $Address{RealName};

        # get next states
        my %NextStates = $Self->{TicketObject}->StateList(
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        # build next states string
        if (!$Self->{Config}->{StateDefault}) {
            $NextStates{''} = '-';
        }
        $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NextStates,
            Name => 'BounceStateID',
            Selected => $Self->{Config}->{StateDefault},
        );
        # print form ...
        my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        # get output back
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketBounce',
            Data => {
                %Param,
                %Article,
                TicketID => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{Subaction} eq 'Store') {
        # get params
        foreach (qw(BounceTo To Subject Body InformSender BounceStateID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # check forward email address
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
        # prepare from ...
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
        # send customer info?
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
        $Self->{TicketObject}->StateSet(
            TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            StateID => $Param{BounceStateID},
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
}
1;
