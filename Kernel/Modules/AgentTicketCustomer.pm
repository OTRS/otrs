# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketCustomer;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # check permissions
    if (
        !$TicketObject->TicketPermission(
            Type     => $Config->{Permission},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $LayoutObject->NoPermission(
            Message => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    if ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # set customer id
        my $ExpandCustomerName1 = $ParamObject->GetParam( Param => 'ExpandCustomerName1' )
            || 0;
        my $ExpandCustomerName2 = $ParamObject->GetParam( Param => 'ExpandCustomerName2' )
            || 0;
        my $CustomerUserOption = $ParamObject->GetParam( Param => 'CustomerUserOption' )
            || '';
        $Param{CustomerUserID}       = $ParamObject->GetParam( Param => 'CustomerUserID' )       || '';
        $Param{CustomerID}           = $ParamObject->GetParam( Param => 'CustomerID' )           || '';
        $Param{SelectedCustomerUser} = $ParamObject->GetParam( Param => 'SelectedCustomerUser' ) || '';

        # use customer login instead of email address if applicable
        if ( $Param{SelectedCustomerUser} ne '' ) {
            $Param{CustomerUserID} = $Param{SelectedCustomerUser};
        }

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Expand Customer Name
        if ($ExpandCustomerName1) {

            # search customer
            my %CustomerUserList = ();
            %CustomerUserList = $CustomerUserObject->CustomerSearch(
                Search => $Param{CustomerUserID},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$KeyCustomerUser};
                $Param{CustomerUserListLastUser} = $KeyCustomerUser;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $Param{CustomerUserID} = $Param{CustomerUserListLastUser};
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $Param{CustomerID} = $CustomerUserData{UserCustomerID};
                }

            }

            # if more the one customer user exists, show list
            # and clean CustomerID
            else {
                $Param{CustomerID}            = '';
                $Param{"CustomerUserOptions"} = \%CustomerUserList;
            }
            return $Self->Form(%Param);
        }

        # get customer user and customer id
        elsif ($ExpandCustomerName2) {
            my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserOption,
            );
            my %CustomerUserList = $CustomerUserObject->CustomerSearch(
                UserLogin => $CustomerUserOption,
            );
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $Param{CustomerUserID} = $KeyCustomerUser;
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $Param{CustomerID} = $CustomerUserData{UserCustomerID};
            }
            return $Self->Form(%Param);
        }

        my %Error;

        # check needed data
        if ( !$Param{CustomerUserID} ) {
            $Error{'CustomerUserIDInvalid'} = 'ServerError';
        }

        if (%Error) {
            return $Self->Form( %Param, %Error );
        }

        # update customer user data
        if (
            $TicketObject->TicketCustomerSet(
                TicketID => $Self->{TicketID},
                No       => $Param{CustomerID},
                User     => $Param{CustomerUserID},
                UserID   => $Self->{UserID},
            )
            )
        {

            # redirect
            return $LayoutObject->PopupClose(
                URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID}",
            );
        }
        else {

            # error?!
            return $LayoutObject->ErrorScreen();
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

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # print header
    $Output .= $LayoutObject->Header(
        Type => 'Small',
    );
    my $TicketCustomerID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'CustomerID' ) || '';

    # print change form if ticket id is given
    my %CustomerUserData = ();
    if ( $Self->{TicketID} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # set JS data
        $LayoutObject->AddJSData(
            Key   => 'CustomerSearch',
            Value => {
                ShowCustomerTickets => $ConfigObject->Get('Ticket::Frontend::ShowCustomerTickets'),
            },
        );

        # get ticket data
        my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet( TicketID => $Self->{TicketID} );
        if ( $TicketData{CustomerUserID} || $Param{CustomerUserID} ) {
            %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $Param{CustomerUserID} || $TicketData{CustomerUserID},
            );
        }

        if ( $CustomerUserData{UserTitle} ) {
            $CustomerUserData{UserTitle} = $LayoutObject->{LanguageObject}->Translate( $CustomerUserData{UserTitle} );
        }

        $TicketCustomerID = $TicketData{CustomerID};
        $Param{SelectedCustomerUser} = $TicketData{CustomerUserID};

        $Param{Table} = $LayoutObject->AgentCustomerViewTable(
            Data   => \%CustomerUserData,
            Ticket => \%TicketData,
            Max    => $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );

        # show customer field as "FirstName Lastname" <MailAddress>
        if (%CustomerUserData) {
            $TicketData{CustomerUserID} = "\"$CustomerUserData{UserFullname} " . " <$CustomerUserData{UserEmail}>";
        }
        $LayoutObject->Block(
            Name => 'Customer',
            Data => { %TicketData, %Param, },
        );
    }

    $Output
        .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketCustomer',
        Data         => \%Param
        );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );
    return $Output;
}

1;
