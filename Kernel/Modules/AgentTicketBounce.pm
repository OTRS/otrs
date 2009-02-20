# --
# Kernel/Modules/AgentTicketBounce.pm - to bounce articles of tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketBounce.pm,v 1.21 2009-02-20 12:04:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketBounce;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # needed objects
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{ArticleID}          = $Self->{ParamObject}->GetParam( Param => 'ArticleID' ) || '';
    $Self->{Config}             = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID TicketID QueueID)) {
        if ( !defined $Self->{$_} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "$_ is needed!",
                Comment => 'Please contact your admin',
            );
        }
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get lock state && write (lock) permissions
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            if (
                $Self->{TicketObject}->OwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                )
                )
            {

                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'TicketLocked',
                    Data => { %Param, TicketID => $Self->{TicketID}, },
                );
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{Number} );
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
                    Data => { %Param, TicketID => $Self->{TicketID}, },
                );
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => { %Param, %Ticket, },
        );
    }

    # ------------------------------------------------------------ #
    # show screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # check if plain article exists
        if ( !$Self->{TicketObject}->ArticlePlain( ArticleID => $Self->{ArticleID} ) ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get article data
        my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID}, );

        # prepare subject ...
        $Article{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Article{TicketNumber},
            Subject => $Article{Subject} || '',
        );

        # prepare to (ReplyTo!) ...
        if ( $Article{ReplyTo} ) {
            $Article{To} = $Article{ReplyTo};
        }
        else {
            $Article{To} = $Article{From};
        }

        # get customer data
        my %Customer = ();
        if ( $Ticket{CustomerUserID} ) {
            %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }

        # prepare salutation
        $Param{Salutation} = $Self->{QueueObject}->GetSalutation(%Article);

        # prepare signature
        $Param{Signature} = $Self->{QueueObject}->GetSignature(%Article);
        for (qw(Signature Salutation)) {

            # get and prepare realname
            if ( $Param{$_} =~ /<OTRS_CUSTOMER_REALNAME>/ ) {
                my $From = '';
                if ( $Ticket{CustomerUserID} ) {
                    $From = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $Ticket{CustomerUserID},
                    );
                }
                if ( !$From ) {
                    $From = $Article{From} || '';
                    $From =~ s/<.*>|\(.*\)|\"|;|,//g;
                    $From =~ s/( $)|(  $)//g;
                }
                $Param{$_} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
            }

            # current user
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Self->{UserID},
                Cached => 1,
            );
            for my $UserKey ( keys %User ) {
                if ( $User{$UserKey} ) {
                    $Param{$_} =~ s/<OTRS_Agent_$UserKey>/$User{$UserKey}/gi;
                    $Param{$_} =~ s/<OTRS_CURRENT_$UserKey>/$User{$UserKey}/gi;
                }
            }

            # replace other needed stuff
            $Param{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
            $Param{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;

            # cleanup
            $Param{$_} =~ s/<OTRS_Agent_.+?>/-/gi;
            $Param{$_} =~ s/<OTRS_CURRENT_.+?>/-/gi;

            # owner user
            my %OwnerUser = $Self->{UserObject}->GetUserData(
                UserID => $Ticket{OwnerID},
                Cached => 1,
            );
            for my $UserKey ( keys %OwnerUser ) {
                if ( $OwnerUser{$UserKey} ) {
                    $Param{$_} =~ s/<OTRS_OWNER_$UserKey>/$OwnerUser{$UserKey}/gi;
                }
            }

            # cleanup
            $Param{$_} =~ s/<OTRS_OWNER_.+?>/-/gi;

            # responsible user
            my %ResponsibleUser = $Self->{UserObject}->GetUserData(
                UserID => $Ticket{ResponsibleID},
                Cached => 1,
            );
            for my $UserKey ( keys %ResponsibleUser ) {
                if ( $ResponsibleUser{$UserKey} ) {
                    $Param{$_} =~ s/<OTRS_RESPONSIBLE_$UserKey>/$ResponsibleUser{$UserKey}/gi;
                }
            }

            # cleanup
            $Param{$_} =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;

            # replace ticket data
            for my $Key ( keys %Ticket ) {
                if ( $Ticket{$Key} ) {
                    $Param{$_} =~ s/<OTRS_TICKET_$Key>/$Ticket{$Key}/gi;
                }
            }

            # cleanup all not needed <OTRS_TICKET_ tags
            $Param{$_} =~ s/<OTRS_TICKET_.+?>/-/gi;

            # replace customer data
            for my $CustomerKey ( keys %Customer ) {
                if ( $Customer{$CustomerKey} ) {
                    $Param{$_} =~ s/<OTRS_CUSTOMER_$CustomerKey>/$Customer{$CustomerKey}/gi;
                    $Param{$_} =~ s/<OTRS_CUSTOMER_DATA_$CustomerKey>/$Customer{$CustomerKey}/gi;
                }
            }

            # cleanup all not needed <OTRS_CUSTOMER_ tags
            $Param{$_} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
            $Param{$_} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

            # replace config options
            $Param{$_} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
            $Param{$_} =~ s/<OTRS_CONFIG_.+?>/-/gi;
        }

        # prepare body ...
        $Article{Body} =~ s/\n/\n> /g;
        $Article{Body} = "\n> " . $Article{Body};
        my @Body = split( /\n/, $Article{Body} );
        $Article{Body} = '';
        for ( 1 .. 4 ) {
            $Article{Body} .= $Body[$_] . "\n" if ( $Body[$_] );
        }

        # prepare from ...
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Article{QueueID}, );
        $Article{From}     = "$Address{RealName} <$Address{Email}>";
        $Article{Email}    = $Address{Email};
        $Article{RealName} = $Address{RealName};

        # get next states
        my %NextStates = $Self->{TicketObject}->StateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );

        # build next states string
        if ( !$Self->{Config}->{StateDefault} ) {
            $NextStates{''} = '-';
        }
        $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data     => \%NextStates,
            Name     => 'BounceStateID',
            Selected => $Self->{Config}->{StateDefault},
        );

        # print form ...
        my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );

        # get output back
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketBounce',
            Data         => {
                %Param,
                %Article,
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # bounce
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        for (qw(BounceTo To Subject Body InformSender BounceStateID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # check forward email address
        for my $Email ( Mail::Address->parse( $Param{BounceTo} ) ) {
            my $Address = $Email->address();
            if ( $Self->{SystemAddress}->SystemAddressIsLocalAddress( Address => $Address ) ) {

                # error page
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Can't forward ticket to $Address! It's a local address! You need to move it!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # prepare from ...
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID}, );
        $Param{From}  = "$Address{RealName} <$Address{Email}>";
        $Param{Email} = $Address{Email};
        my $Bounce = $Self->{TicketObject}->ArticleBounce(
            TicketID    => $Self->{TicketID},
            ArticleID   => $Self->{ArticleID},
            UserID      => $Self->{UserID},
            To          => $Param{BounceTo},
            From        => $Param{Email},
            HistoryType => 'Bounce',
        );

        # error page
        if ( !$Bounce ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Can't bounce email!",
                Comment => 'Please contact the admin.',
            );
        }

        # send customer info?
        if ( $Param{InformSender} ) {
            $Param{Body} =~ s/<OTRS_TICKET>/$Ticket{TicketNumber}/g;
            $Param{Body} =~ s/<OTRS_BOUNCE_TO>/$Param{BounceTo}/g;
            my $ArticleID = $Self->{TicketObject}->ArticleSend(
                ArticleType    => 'email-external',
                SenderType     => 'agent',
                TicketID       => $Self->{TicketID},
                HistoryType    => 'Bounce',
                HistoryComment => "Bounced info to '$Param{To}'.",
                From           => $Param{From},
                Email          => $Param{Email},
                To             => $Param{To},
                Subject        => $Param{Subject},
                UserID         => $Self->{UserID},
                Body           => $Param{Body},
                Charset        => $Self->{LayoutObject}->{UserCharset},
                Type           => 'text/plain',
            );

            # error page
            if ( !$ArticleID ) {
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
            TicketID  => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            StateID   => $Param{BounceStateID},
            UserID    => $Self->{UserID},
        );

        # should i set an unlock?
        if ( $StateData{TypeName} =~ /^close/i ) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # redirect
        if ( $StateData{TypeName} =~ /^close/i ) {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenOverview} );
        }
        else {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
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
