# --
# Kernel/Modules/AgentTicketMerge.pm - to merge tickets
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketMerge.pm,v 1.22 2008-10-29 19:49:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketMerge;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

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

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access =  $Self->{TicketObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );
    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

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
                    Name => 'PropertiesLock',
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

    # merge action
    if ( $Self->{Subaction} eq 'Merge' ) {
        my $MainTicketNumber = $Self->{ParamObject}->GetParam( Param => 'MainTicketNumber' );
        my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $MainTicketNumber,
        );

        # check permissions
        my $Access = $Self->{TicketObject}->Permission(
            Type     => $Self->{Config}->{Permission},
            TicketID => $MainTicketID,
            UserID   => $Self->{UserID}
        );

        # error screen, don't show ticket
        if ( !$Access ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check errors
        if (
            $Self->{TicketID} == $MainTicketID
            || !$Self->{TicketObject}->TicketMerge(
                MainTicketID  => $MainTicketID,
                MergeTicketID => $Self->{TicketID},
                UserID        => $Self->{UserID},
            )
            )
        {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketMerge',
                Data => { %Param, %Ticket },
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {

            # get params
            for (qw(From To Subject Body InformSender)) {
                $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
            }

            # check forward email address
            for my $Email ( Mail::Address->parse( $Param{BounceTo} ) ) {
                my $Address = $Email->address();
                if ( $Self->{SystemAddress}->SystemAddressIsLocalAddress( Address => $Address ) ) {

                    # error page
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Can't forward ticket to $Address! It's a local "
                            . "address! You need to move it!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }

            # send customer info?
            if ( $Param{InformSender} ) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
                $Param{Body} =~ s/<OTRS_TICKET>/$Ticket{TicketNumber}/g;
                $Param{Body} =~ s/<OTRS_MERGE_TO_TICKET>/$MainTicketNumber/g;
                my $ArticleID = $Self->{TicketObject}->ArticleSend(
                    ArticleType    => 'email-external',
                    SenderType     => 'agent',
                    TicketID       => $Self->{TicketID},
                    HistoryType    => 'SendAnswer',
                    HistoryComment => "Merge info to '$Param{To}'.",
                    From           => $Param{From},
                    Email          => $Param{Email},
                    To             => $Param{To},
                    Subject        => $Param{Subject},
                    UserID         => $Self->{UserID},
                    Body           => $Param{Body},
                    Type           => 'text/plain',
                    Charset        => $Self->{LayoutObject}->{UserCharset},
                );
                if ( !$ArticleID ) {

                    # error page
                    return $Self->{LayoutObject}->ErrorScreen();
                }
            }

            # redirect to merged ticket
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTicketZoom&TicketID=$MainTicketID"
            );
        }
    }
    else {

        # get last article
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
            TicketID => $Self->{TicketID},
        );

        # merge box
        my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get customer data
        my %Customer = ();
        if ( $Ticket{CustomerUserID} ) {
            %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }

        # prepare subject ...
        $Article{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Ticket{TicketNumber},
            Subject => $Article{Subject} || '',
        );

        # prepare from ...
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
        $Article{QueueFrom} = "$Address{RealName} <$Address{Email}>";
        $Article{Email}     = $Address{Email};
        $Article{RealName}  = $Address{RealName};

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
            for my $TicketKey ( keys %Ticket ) {
                if ( $Ticket{$TicketKey} ) {
                    $Param{$_} =~ s/<OTRS_TICKET_$TicketKey>/$Ticket{$TicketKey}/gi;
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
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketMerge',
            Data => { %Param, %Ticket, %Article },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
