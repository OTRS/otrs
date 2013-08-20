# --
# Kernel/Modules/AgentUserSearch.pm - a module used for the autocomplete feature
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentUserSearch;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $JSON = '';

    # search users
    if ( !$Self->{Subaction} ) {

        # get needed params
        my $Search = $Self->{ParamObject}->GetParam( Param => 'Term' )   || '';
        my $Groups = $Self->{ParamObject}->GetParam( Param => 'Groups' ) || '';
        my $MaxResults = int( $Self->{ParamObject}->GetParam( Param => 'MaxResults' ) || 20 );

        # get all members of the groups
        my %GroupUsers;
        if ($Groups) {
            my @GroupNames = split /,\s+/, $Groups;

            GROUPNAME:
            for my $GroupName (@GroupNames) {

                # allow trailing comma
                next GROUPNAME if !$GroupName;

                my $GroupID = $Self->{GroupObject}->GroupLookup(
                    Group => $GroupName,
                );

                next GROUPNAME if !$GroupID;

                # get users in group
                my %Users = $Self->{GroupObject}->GroupMemberList(
                    GroupID => $GroupID,
                    Type    => 'ro',
                    Result  => 'HASH',
                    Cached  => 1,
                );

                my @UserIDs = keys %Users;
                @GroupUsers{@UserIDs} = @UserIDs;
            }
        }

        # workaround, all auto completion requests get posted by utf8 anyway
        # convert any to 8bit string if application is not running in utf8
        if ( !$Self->{EncodeObject}->EncodeInternalUsed() ) {
            $Search = $Self->{EncodeObject}->Convert(
                Text => $Search,
                From => 'utf-8',
                To   => $Self->{LayoutObject}->{UserCharset},
            );
        }

        # get user list
        my %UserList = $Self->{UserObject}->UserSearch(
            Search => $Search,
            Valid  => 1,
        );

        my $MaxResultCount = $MaxResults;

        # the data that will be sent as response
        my @Data;

        USERID:
        for my $UserID ( sort { $UserList{$a} cmp $UserList{$b} } keys %UserList ) {

            # if groups are required and user is not member of one of the groups
            # then skip the user
            if ( $Groups && !$GroupUsers{$UserID} ) {
                next USERID;
            }

            # The values in %UserList are in the form: 'mm Max Mustermann'.
            # So assemble a neater string for display.
            # (Actually UserSearch() contains code for formating, but that is usually not called.)
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
                Valid  => $Param{Valid},
            );

            my $UserValue = sprintf '"%s %s" <%s>',
                $User{UserFirstname},
                $User{UserLastname},
                $User{UserEmail};

            push @Data, {
                UserKey   => $UserID,
                UserValue => $UserValue,
            };

            $MaxResultCount--;
            last USERID if $MaxResultCount <= 0;
        }

        # build JSON output
        $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => \@Data,
        );
    }

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
