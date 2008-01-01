# --
# Kernel/Modules/AgentTicketCustomer.pm - to set the ticket customer and show the customer history
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketCustomer.pm,v 1.14 2008-01-01 22:05:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketCustomer;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Search}     = $Self->{ParamObject}->GetParam( Param => 'Search' )     || 0;
    $Self->{CustomerID} = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';

    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    if (!$Self->{TicketObject}->Permission(
            Type     => $Self->{Config}->{Permission},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # check permissions
    if ( $Self->{TicketID} ) {
        if (!$Self->{TicketObject}->Permission(
                Type     => 'customer',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            )
            )
        {

            # no permission screen, don't show ticket
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    if ( $Self->{Subaction} eq 'Update' ) {

        # set customer id
        my $ExpandCustomerName1 = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName1' )
            || 0;
        my $ExpandCustomerName2 = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName2' )
            || 0;
        my $CustomerUserOption = $Self->{ParamObject}->GetParam( Param => 'CustomerUserOption' )
            || '';
        $Param{CustomerUserID} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserID' ) || '';
        $Param{CustomerID}     = $Self->{ParamObject}->GetParam( Param => 'CustomerID' )     || '';

        # Expand Customer Name
        if ($ExpandCustomerName1) {

            # search customer
            my %CustomerUserList = ();
            %CustomerUserList
                = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserID}, );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $Param{CustomerUserID} = $Param{CustomerUserListLastUser};
                my %CustomerUserData = $Self->{CustomerUserObject}
                    ->CustomerUserDataGet( User => $Param{CustomerUserListLastUser}, );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $Param{CustomerID} = $CustomerUserData{UserCustomerID};
                }

            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                #                $Param{CustomerUserID} = '';
                $Param{CustomerID} = '';
                $Param{"CustomerUserOptions"} = \%CustomerUserList;
            }
            return $Self->Form(%Param);
        }

        # get customer user and customer id
        elsif ($ExpandCustomerName2) {
            my %CustomerUserData
                = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $CustomerUserOption, );
            my %CustomerUserList
                = $Self->{CustomerUserObject}->CustomerSearch( UserLogin => $CustomerUserOption, );
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserID} = $_;
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $Param{CustomerID} = $CustomerUserData{UserCustomerID};
            }
            return $Self->Form(%Param);
        }

        # update customer user data
        if ($Self->{TicketObject}->SetCustomerData(
                TicketID => $Self->{TicketID},
                No       => $Param{CustomerID},
                User     => $Param{CustomerUserID},
                UserID   => $Self->{UserID},
            )
            )
        {

            # redirect
            return $Self->{LayoutObject}
                ->Redirect( OP => "Action=AgentTicketZoom&TicketID=$Self->{TicketID}" );
        }
        else {

            # error?!
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # show form
    else {
        return $Self->Form(%Param);
    }
}

sub Form {
    my ( $Self, %Param ) = @_;

    my $Output;

    # print header
    $Output .= $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    my $TicketCustomerID = $Self->{CustomerID};

    # print change form if ticket id is given
    my %CustomerUserData = ();
    if ( $Self->{TicketID} ) {

        # get ticket data
        my %TicketData = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
        if ( $TicketData{CustomerUserID} || $Param{CustomerUserID} ) {
            %CustomerUserData
                = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $Param{CustomerUserID}
                    || $TicketData{CustomerUserID}, );
        }
        $TicketCustomerID = $TicketData{CustomerID};
        $Param{Table} = $Self->{LayoutObject}->AgentCustomerViewTable( Data => \%CustomerUserData );
        $Self->{LayoutObject}->Block(
            Name => 'Customer',
            Data => { %TicketData, %Param, },
        );

        # build from string
        if ( $Param{CustomerUserOptions} && %{ $Param{CustomerUserOptions} } ) {
            $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => $Param{CustomerUserOptions},
                Name => 'CustomerUserOption',
                Max  => 70,
            );
            $Self->{LayoutObject}->Block(
                Name => 'CustomerTakeOver',
                Data => { %Param, },
            );
        }
    }

    # get ticket ids with customer id
    my @TicketIDs = ();
    if ( $CustomerUserData{UserID} ) {

        # get secondary customer ids
        my @CustomerIDs
            = $Self->{CustomerUserObject}->CustomerIDs( User => $CustomerUserData{UserID} );

        # get own customer id
        if ( $CustomerUserData{UserCustomerID} ) {
            push( @CustomerIDs, $CustomerUserData{UserCustomerID} );
        }
        @TicketIDs = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            CustomerID => \@CustomerIDs,
            UserID     => $Self->{UserID},
            Permission => 'ro',
            Limit => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerShownTickets') || '40',
        );
    }
    elsif ($TicketCustomerID) {
        @TicketIDs = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            CustomerID => $TicketCustomerID,
            UserID     => $Self->{UserID},
            Permission => 'ro',
            Limit => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerShownTickets') || '40',
        );
    }
    if (@TicketIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'CustomerHistory',
            Data => {},
        );
    }
    my $OutputTables = '';
    for my $TicketID (@TicketIDs) {

        # get ack actions
        $Self->{TicketObject}->TicketAcl(
            Data          => '-',
            Action        => $Self->{Action},
            TicketID      => $TicketID,
            ReturnType    => 'Action',
            ReturnSubType => '-',
            UserID        => $Self->{UserID},
        );
        my %AclAction = $Self->{TicketObject}->TicketAclActionData();
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle( TicketID => $TicketID );

        # ticket title
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
            $Self->{LayoutObject}->Block(
                Name => 'Title',
                Data => { %Param, %Article },
            );
        }

        # run ticket menu modules
        if ( ref( $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') ) eq 'HASH' ) {
            my %Menus   = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
            my $Counter = 0;
            for my $Menu ( sort keys %Menus ) {

                # load module
                if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                    my $Object
                        = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Self->{TicketID}, );

                    # run module
                    $Counter = $Object->Run(
                        %Param,
                        TicketID => $TicketID,
                        Ticket   => \%Article,
                        Counter  => $Counter,
                        ACL      => \%AclAction,
                        Config   => $Menus{$Menu},
                    );
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }
        for (qw(From To Cc Subject)) {
            if ( $Article{$_} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        Key   => $_,
                        Value => $Article{$_},
                    },
                );
            }
        }
        $OutputTables .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketQueueTicketViewLite',
            Data         => {
                %AclAction, %Article,
                Age => $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' ),
            }
        );

    }
    $Output
        .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketCustomer', Data => \%Param );
    $Output .= $OutputTables . $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
