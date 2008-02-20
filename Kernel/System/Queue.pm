# --
# Kernel/System/Queue.pm - lib for queue functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Queue.pm,v 1.80 2008-02-20 12:14:32 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Queue;

use strict;
use warnings;

use Kernel::System::StdResponse;
use Kernel::System::Group;
use Kernel::System::CustomerGroup;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.80 $) [1];

=head1 NAME

Kernel::System::Queue - queue lib

=head1 SYNOPSIS

All queue functions. E. g. to add queue or other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Queue;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $QueueObject = Kernel::System::Queue->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{QueueID} = $Param{QueueID} || '';    #die "Got no QueueID!";

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    # lib object
    $Self->{StdResponseObject} = Kernel::System::StdResponse->new(%Param);
    if ( !$Param{GroupObject} ) {
        $Self->{GroupObject} = Kernel::System::Group->new(%Param);
    }
    else {
        $Self->{GroupObject} = $Param{GroupObject};
    }
    if ( !$Param{CustomerGroupObject} ) {
        $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new(%Param);
    }
    else {
        $Self->{CustomerGroupObject} = $Param{CustomerGroupObject};
    }

    # load generator preferences module
    my $GeneratorModule = 'Kernel::System::Queue::PreferencesDB';
    if ($Self->{MainObject}->Require($GeneratorModule)) {
        $Self->{PreferencesObject} = $GeneratorModule->new(%Param);
    }

    # --------------------------------------------------- #
    #  default queue  settings                            #
    #  these settings are used by the CLI version         #
    # --------------------------------------------------- #
    $Self->{QueueDefaults} = {
        UnlockTimeout       => 0,
        FirstResponseTime   => 0,
        FirstResponseNotify => 0,
        UpdateTime          => 0,
        UpdateNotify        => 0,
        SolutionTime        => 0,
        SolutionNotify      => 0,
        FollowUpLock        => 0,
        SystemAddressID     => 1,
        SalutationID        => 1,
        SignatureID         => 1,
        FollowUpID          => 1,
        FollowUpLock        => 0,
        MoveNotify          => 0,
        LockNotify          => 0,
        StateNotify         => 0,
    };

    return $Self;
}

=item GetSystemAddress()

get a queue system email address as hash (Email, RealName)

    my %Adresss = $QueueObject->GetSystemAddress(
        QueueID => 123,
    );

=cut

sub GetSystemAddress {
    my ( $Self, %Param ) = @_;

    my %Address;
    my $QueueID = $Param{QueueID} || $Self->{QueueID};
    my $SQL = "SELECT sa.value0, sa.value1 FROM system_address sa, queue sq "
        . " WHERE "
        . " sq.id = " . $Self->{DBObject}->Quote( $QueueID, 'Integer' ) . " AND "
        . " sa.id = sq.system_address_id";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Address{Email}    = $Row[0];
        $Address{RealName} = $Row[1];
    }

    # prepare realname quote
    if ( $Address{RealName} =~ /(,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/ ) {
        $Address{RealName} =~ s/"/\"/g;
        $Address{RealName} = '"' . $Address{RealName} . '"';
    }
    return %Address;
}

=item GetSalutation()

get a queue salutation

    my $Salutation = $QueueObject->GetSalutation(QueueID => 123);

=cut

sub GetSalutation {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $String = '';
    my $SQL = "SELECT text FROM salutation sa, queue sq "
        . " WHERE "
        . " sq.id = $Param{QueueID} " . " and "
        . " sq.salutation_id = sa.id";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $String = $Row[0];
    }
    return $String;
}

=item GetSignature()

get a queue signature

    my $Signature = $QueueObject->GetSignature(QueueID => 123);

=cut

sub GetSignature {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $String = '';
    my $SQL = "SELECT text FROM signature si, queue sq "
        . " WHERE "
        . " sq.id = $Param{QueueID} AND "
        . " sq.signature_id = si.id";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $String = $Row[0];
    }
    return $String;
}

=item GetStdResponse()

get std response of a queue

    my $String = $QueueObject->GetStdResponse(ID => 123);

=cut

sub GetStdResponse {
    my ( $Self, %Param ) = @_;

    my $String = '';

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "SELECT text FROM standard_response WHERE id = $Param{ID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $String = $Row[0];
    }
    return $String;
}

# for comapt!
sub SetQueueStdResponse {
    my ( $Self, %Param ) = @_;

    unless ( $Param{ResponseID} && $Param{QueueID} && $Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ResponseID, QueueID and UserID!" );
        return;
    }
    if ( $Self->QueueHasStdResponse(%Param) ) {
        return;
    }

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL = sprintf(
        qq|INSERT INTO queue_standard_response (queue_id, standard_response_id, create_time, create_by, change_time, change_by)
    VALUES ( %s, %s, current_timestamp, %s, current_timestamp, %s)|, $Param{QueueID},
        $Param{ResponseID}, $Param{UserID}, $Param{UserID}
    );

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return 0;
    }
}

# for comapt!
sub QueueHasStdResponse {
    my ( $Self, %Param ) = @_;

    unless ( $Param{ResponseID} && $Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ResponseID and QueueID!" );
        return;
    }

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL = sprintf(
        "select count(*) from  queue_standard_response  where queue_id=%s and standard_response_id=%s",
        $Param{QueueID}, $Param{ResponseID} );

    $Self->{DBObject}->Prepare( SQL => $SQL );
    my $Count;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Count = $Row[0];
    }
    return $Count;
}

=item GetStdResponses()

get std responses of a queue

    my %Responses = $QueueObject->GetStdResponses(QueueID => 123);

=cut

sub GetStdResponses {
    my ( $Self, %Param ) = @_;

    my %StdResponses;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # check if this result is present
    if ( $Self->{"StdResponses::$Param{QueueID}"} ) {
        return %{ $Self->{"StdResponses::$Param{QueueID}"} };
    }

    # get std. responses
    my $SQL = "SELECT sr.id, sr.name "
        . " FROM "
        . " standard_response sr, queue_standard_response qsr"
        . " WHERE "
        . " qsr.queue_id IN (" . $Self->{DBObject}->Quote( $Param{QueueID}, 'Integer' ) . ") AND "
        . " qsr.standard_response_id = sr.id AND "
        . " sr.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )"
        . " ORDER BY sr.name";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $StdResponses{ $Row[0] } = $Row[1];
    }

    # store std responses
    $Self->{"StdResponses::$Param{QueueID}"} = \%StdResponses;

    # return responses
    return %StdResponses;
}

=item GetAllQueues()

get all system queues

    my %Queues = $QueueObject->GetAllQueues();

get all system queues of a user with permission type (e. g. ro, move_into, rw, ...)

    my %Queues = $QueueObject->GetAllQueues(UserID => 123, Type => 'ro');

=cut

sub GetAllQueues {
    my ( $Self, %Param ) = @_;

    my $UserID = $Param{UserID} || '';
    my $Type   = $Param{Type}   || 'ro';

    # fetch all queues
    my %MoveQueues;
    if ( $Param{UserID} ) {
        if ( $Self->{"QG::GetAllQueues::UserID::$Param{UserID}"} ) {
            return %{ $Self->{"QG::GetAllQueues::UserID::$Param{UserID}"} };
        }
        my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
            UserID => $Param{UserID},
            Type   => $Type,
            Result => 'ID',
            Cached => 1,
        );
        if (@GroupIDs) {
            my $SQL = "SELECT id, name FROM queue"
                . " WHERE "
                . " group_id IN ( ${\(join ', ', @GroupIDs)} ) AND "
                . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
            $Self->{DBObject}->Prepare( SQL => $SQL );
        }
        else {
            return;
        }
    }
    elsif ( $Param{CustomerUserID} ) {
        if ( $Self->{"QG::GetAllQueues::CustomerUserID::$Param{CustomerUserID}"} ) {
            return %{ $Self->{"QG::GetAllQueues::CustomerUserID::$Param{CustomerUserID}"} };
        }
        my @GroupIDs = $Self->{CustomerGroupObject}->GroupMemberList(
            UserID => $Param{CustomerUserID},
            Type   => $Type,
            Result => 'ID',
            Cached => 1,
        );
        if (@GroupIDs) {
            my $SQL
                = "SELECT id, name FROM queue"
                . " WHERE "
                . " group_id IN ( ${\(join ', ', @GroupIDs)} ) AND "
                . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
            $Self->{DBObject}->Prepare( SQL => $SQL );
        }
        else {
            return;
        }
    }
    else {
        if ( $Self->{"QG::GetAllQueues"} ) {
            return %{ $Self->{"QG::GetAllQueues"} };
        }
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id, name FROM queue WHERE valid_id IN "
                . "( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )",
        );
    }
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $MoveQueues{ $Row[0] } = $Row[1];
    }

    if ( $Param{UserID} ) {
        $Self->{"QG::GetAllQueues::UserID::$Param{UserID}"} = \%MoveQueues;
    }
    elsif ( $Param{CustomerUserID} ) {
        $Self->{"QG::GetAllQueues::CustomerUserID::$Param{CustomerUserID}"} = \%MoveQueues;
    }
    else {
        $Self->{"QG::GetAllQueues"} = \%MoveQueues;
    }

    return %MoveQueues;
}

=item GetAllCustomQueues()

get all custom queues of one user

    my @Queues = $QueueObject->GetAllCustomQueues(UserID => 123);

=cut

sub GetAllCustomQueues {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID!" );
        return;
    }

    # db quote
    for (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # fetch all queues
    my @QueueIDs;
    my $SQL = "SELECT queue_id FROM personal_queues WHERE user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @QueueIDs, $Row[0] );
    }
    return @QueueIDs;
}

=item QueueLookup()

get id or name for queue

    my $Queue = $QueueObject->QueueLookup(QueueID => $QueueID);

    my $QueueID = $QueueObject->QueueLookup(Queue => $Queue);

=cut

sub QueueLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Queue} && !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no Queue or QueueID!" );
        return;
    }

    # check if we ask the same request (cache)?
    if ( $Param{QueueID} && $Self->{"QL::Queue$Param{QueueID}"} ) {
        return $Self->{"QL::Queue$Param{QueueID}"};
    }
    if ( $Param{Queue} && $Self->{"QL::QueueID$Param{Queue}"} ) {
        return $Self->{"QL::QueueID$Param{Queue}"};
    }

    # get data
    my $SQL    = '';
    my $Suffix = '';
    if ( $Param{Queue} ) {
        $Param{What} = $Param{Queue};
        $Suffix      = 'QueueID';
        $SQL         = "SELECT id FROM queue WHERE name = '"
            . $Self->{DBObject}->Quote( $Param{Queue} ) . "'";
    }
    else {
        $Param{What} = $Param{QueueID};
        $Suffix      = 'Queue';
        $SQL         = "SELECT name FROM queue WHERE id = "
            . $Self->{DBObject}->Quote( $Param{QueueID}, 'Integer' ) . "";
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"QL::$Suffix$Param{What}"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"QL::$Suffix$Param{What}"} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # return result
    return $Self->{"QL::$Suffix$Param{What}"};
}

=item GetFollowUpOption()

...

    ...

=cut

sub GetFollowUpOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # fetch queues data
    my $Return = '';
    my $SQL = "SELECT sf.name "
        . " FROM "
        . " follow_up_possible sf, queue sq "
        . " WHERE "
        . " sq.follow_up_id = sf.id AND "
        . " sq.id = $Param{QueueID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Return = $Row[0];
    }
    return $Return;
}

=item GetFollowUpLockOption()

...

    ...

=cut

sub GetFollowUpLockOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # fetch queues data
    my $Return = 0;
    my $SQL = "SELECT sq.follow_up_lock "
        . " FROM "
        . " queue sq "
        . " WHERE "
        . " sq.id = $Param{QueueID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Return = $Row[0];
    }
    return $Return;
}

=item GetQueueGroupID()

...

    ...

=cut

sub GetQueueGroupID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need QueueID!" );
        return;
    }

    # check, if value is cached
    if ( $Self->{"QG::GetQueueGroupID::$Param{QueueID}"} ) {
        return $Self->{"QG::GetQueueGroupID::$Param{QueueID}"};
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # get group id from database
    my $GroupID = '';
    $Self->{DBObject}->Prepare(
        SQL => "SELECT group_id FROM queue WHERE id = $Param{QueueID}",
        Limit => 1
    );

    # fetch the result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GroupID = $Row[0];
    }

    # write cache
    $Self->{"QG::GetQueueGroupID::$Param{QueueID}"} = $GroupID;

    return $GroupID;
}

=item QueueAdd()

add queue with attributes

    $QueueObject->QueueAdd(
        Name => 'Some::Queue',
        ValidID => 1,
        GroupID => 1,
        Calendar => 'Calendar1',   # (optional)
        FirstResponseTime => 120,  # (optional)
        FirstResponseNotify => 60, # (optional, notify agent if first response escalation is 60% reached)
        UpdateTime => 180,         # (optional)
        UpdateNotify => 80,        # (optional, notify agent if update escalation is 80% reached)
        SolutionTime => 580,       # (optional)
        SolutionNotify => 80,      # (optional, notify agent if solution escalation is 80% reached)
        SystemAddressID => 1,
        SalutationID => 1,
        SignatureID => 1,
        UserID => 123,
        MoveNotify => 0,
        StateNotify => 0,
        LockNotify => 0,
        OwnerNotify => 0,
    );

=cut

sub QueueAdd {
    my ( $Self, %Param ) = @_;

    # Add Queue to the Database

    # Requires
    # Params{GroupID}   : ID of the group responsible for this quese
    # Param{QueueName}  : Duh! Name of the Queue
    # Param{ValidID}    : Is the queue invalid, valid, suspended etc
    # Param{UserID}     : ID of the person creating the Queue

    # Returns
    # new Queue ID on success
    # null/false on failure

    # ' and , are for modems. Line noise
    # A less noisy way to defining @Params is
    my @Params = qw(
        Name
        GroupID
        UnlockTimeout
        SystemAddressID
        Calendar
        DefaultSignKey
        SalutationID
        SignatureID
        FollowUpID
        FollowUpLock
        FirstResponseTime
        FirstResponseNotify
        UpdateTime
        UpdateNotify
        SolutionTime
        SolutionNotify
        MoveNotify
        StateNotify
        Comment
        ValidID
    );

    for ( qw(UnlockTimeout FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify
        FollowUpLock SystemAddressID SalutationID SignatureID
        FollowUpID FollowUpLock MoveNotify StateNotify LockNotify OwnerNotify DefaultSignKey Calendar)
        ) {

        # these are coming from Config.pm
        # I added default values in the Load Routine
        $Param{$_} = $Self->{QueueDefaults}{$_} || 0 unless ( $Param{$_} );
    }

    # check needed stuff
    for (
        qw(Name GroupID SystemAddressID SalutationID SignatureID MoveNotify StateNotify
        LockNotify OwnerNotify ValidID UserID)
        )
    {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(Name GroupID SystemAddressID SalutationID SignatureID ValidID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # cleanup queue name
    $Param{Name} =~ s/(\n|\r)//g;
    $Param{Name} =~ s/\s$//g;

    # check queue name
    if ( $Param{Name} =~ /::$/i ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid Queue name '$Param{Name}'!",
        );
        return;
    }

    # quote db
    for (qw(Name DefaultSignKey Calendar Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(GroupID UnlockTimeout SystemAddressID SalutationID SignatureID FollowUpID FollowUpLock
        FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify
        MoveNotify StateNotify ValidID)
        ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my $SQL
        = "INSERT INTO queue "
        . "(name, "
        . " group_id, "
        . " unlock_timeout, "
        . " system_address_id, "
        . " calendar_name, "
        . " default_sign_key, "
        . " salutation_id, "
        . " signature_id, "
        . " first_response_time, "
        . " first_response_notify, "
        . " update_time, "
        . " update_notify, "
        . " solution_time, "
        . " solution_notify, "
        . " follow_up_id, "
        . " follow_up_lock, "
        . " state_notify, "
        . " move_notify, "
        . " lock_notify, "
        . " owner_notify, "
        . " valid_id, "
        . " comments, "
        . " create_time, "
        . " create_by, "
        . " change_time, "
        . " change_by)"
        . " VALUES "
        . " ('$Param{Name}', "
        . " $Param{GroupID}, "
        . " $Param{UnlockTimeout}, "
        . " $Param{SystemAddressID}, "
        . " '$Param{Calendar}', "
        . " '$Param{DefaultSignKey}', "
        . " $Param{SalutationID}, "
        . " $Param{SignatureID}, "
        . " $Param{FirstResponseTime}, "
        . " $Param{FirstResponseNotify}, "
        . " $Param{UpdateTime}, "
        . " $Param{UpdateNotify}, "
        . " $Param{SolutionTime}, "
        . " $Param{SolutionNotify}, "
        . " $Param{FollowUpID}, "
        . " $Param{FollowUpLock}, "
        . " $Param{StateNotify}, "
        . " $Param{MoveNotify}, "
        . " $Param{LockNotify}, "
        . " $Param{OwnerNotify}, "
        . " $Param{ValidID}, "
        . " '$Param{Comment}', "
        . " current_timestamp, "
        . " $Param{UserID}, "
        . " current_timestamp, "
        . " $Param{UserID})";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # get new queue id
        $SQL = "SELECT id FROM queue WHERE name = '$Param{Name}'";
        my $QueueID = '';
        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $QueueID = $Row[0];
        }

        # add default responses (if needed), add response by name
        if ( $Self->{ConfigObject}->Get('StdResponse2QueueByCreating') ) {
            for ( @{ $Self->{ConfigObject}->{StdResponse2QueueByCreating} } ) {
                my $StdResponseID
                    = $Self->{StdResponseObject}->StdResponseLookup( StdResponse => $_ );
                if ($StdResponseID) {
                    $Self->SetQueueStdResponse(
                        QueueID    => $QueueID,
                        ResponseID => $StdResponseID,
                        UserID     => $Param{UserID},
                    );
                }
            }
        }

        # add response by id
        if ( $Self->{ConfigObject}->Get('StdResponseID2QueueByCreating') ) {
            for ( @{ $Self->{ConfigObject}->{StdResponseID2QueueByCreating} } ) {
                $Self->SetQueueStdResponse(
                    QueueID    => $QueueID,
                    ResponseID => $_,
                    UserID     => $Param{UserID},
                );
            }
        }
        return $QueueID;
    }
    else {
        return;
    }
}

=item QueueGet()

get queue attributes

    my %Queue = $QueueObject->QueueGet(
        ID => 123,
        Cache => 1, # optional
    );

    my %Queue = $QueueObject->QueueGet(
        Name => 'Some::Queue',
        Cache => 1, # optional
    );

=cut

sub QueueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID or Name!" );
        return;
    }

    # check if we ask the same request (cache)?
    if ( $Param{Cache} && $Param{ID} && $Self->{"QG::ID$Param{ID}"} ) {
        return %{ $Self->{"QG::ID$Param{ID}"} };
    }
    if ( $Param{Cache} && $Param{Queue} && $Self->{"QL::Name$Param{Name}"} ) {
        return %{ $Self->{"QG::Name$Param{Name}"} };
    }

    # sql
    my $SQL
        = "SELECT q.name, q.group_id, q.unlock_timeout, "
        . " q.system_address_id, q.salutation_id, q.signature_id, q.comments, q.valid_id, "
        . " q.first_response_time, q.first_response_notify, "
        . " q.update_time, q.update_notify, q.solution_time, q.solution_notify, "
        . " q.follow_up_id, q.follow_up_lock, sa.value0, sa.value1, q.id, "
        . " q.move_notify, q.state_notify, q.lock_notify, q.owner_notify, q.default_sign_key, "
        . " q.calendar_name "
        . " FROM "
        . " queue q, system_address sa"
        . " WHERE "
        . " q.system_address_id = sa.id AND ";
    my $Suffix = '';
    if ( $Param{ID} ) {
        $Param{What} = $Param{ID};
        $Suffix = 'ID';
        $SQL .= " q.id = " . $Self->{DBObject}->Quote( $Param{ID}, 'Integer' ) . "";
    }
    else {
        $Param{What} = $Param{Name};
        $Suffix = 'Name';
        $SQL .= " q.name = '" . $Self->{DBObject}->Quote( $Param{Name} ) . "'";
    }
    my %Data = ();
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            QueueID             => $Data[18],
            Name                => $Data[0],
            GroupID             => $Data[1],
            UnlockTimeout       => $Data[2],
            FirstResponseTime   => $Data[8],
            FirstResponseNotify => $Data[9],
            UpdateTime          => $Data[10],
            UpdateNotify        => $Data[11],
            SolutionTime        => $Data[12],
            SolutionNotify      => $Data[13],
            FollowUpID          => $Data[14],
            FollowUpLock        => $Data[15],
            SystemAddressID     => $Data[3],
            SalutationID        => $Data[4],
            SignatureID         => $Data[5],
            Comment             => $Data[6],
            ValidID             => $Data[7],
            Email               => $Data[16],
            RealName            => $Data[17],
            StateNotify         => $Data[20],
            MoveNotify          => $Data[19],
            LockNotify          => $Data[21],
            OwnerNotify         => $Data[22],
            DefaultSignKey      => $Data[23],
            Calendar            => $Data[24],
        );
    }

    # check if data exists
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # get queue preferences
    my %Preferences = $Self->QueuePreferencesGet( QueueID => $Data{QueueID} );

    # merge hash
    if ( %Preferences ) {
        %Data = ( %Data, %Preferences );
    }

    # cache result
    $Self->{"QG::$Suffix$Param{What}"} = \%Data;

    # return result
    return %Data;
}

=item QueueUpdate()

update queue attributes

    $QueueObject->QueueUpdate(
        QueueID => 123,
        Name => 'Some::Queue',
        ValidID => 1,
        GroupID => 1,
        Calendar => 'Calendar1',   # (optional)
        FirstResponseTime => 120,  # (optional)
        FirstResponseNotify => 60, # (optional, notify agent if first response escalation is 60% reached)
        UpdateTime => 180,         # (optional)
        UpdateNotify => 80,        # (optional, notify agent if update escalation is 80% reached)
        SolutionTime => 580,       # (optional)
        SolutionNotify => 80,      # (optional, notify agent if solution escalation is 80% reached)
        SystemAddressID => 1,
        SalutationID => 1,
        SignatureID => 1,
        UserID => 123,
        MoveNotify => 0,
        StateNotify => 0,
        LockNotify => 0,
        OwnerNotify => 0,
    );

=cut

sub QueueUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (
        qw(QueueID Name ValidID GroupID SystemAddressID SalutationID SignatureID FollowUpID UserID
        MoveNotify StateNotify LockNotify OwnerNotify)
        )
    {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(QueueID Name ValidID GroupID SystemAddressID SalutationID SignatureID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    my %DB = ();

    # check !!!
    for (
        qw(UnlockTimeout FollowUpLock MoveNotify StateNotify LockNotify OwnerNotify
        FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify
        FollowUpID FollowUpLock DefaultSignKey Calendar)
        )
    {
        $Param{$_} = 0 if ( !$Param{$_} );
    }
    for (qw(Name DefaultSignKey Calendar Comment)) {
        $DB{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (
        qw(QueueID GroupID UnlockTimeout SystemAddressID SalutationID SignatureID FollowUpID
        FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify
        FollowUpLock StateNotify LockNotify OwnerNotify MoveNotify StateNotify ValidID UserID)
        )
    {
        $DB{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # cleanup queue name
    $Param{Name} =~ s/(\n|\r)//g;
    $Param{Name} =~ s/\s$//g;

    # check queue name
    if ( $Param{Name} =~ /::$/i ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid Queue name '$Param{Name}'!",
        );
        return;
    }

    # check if queue name exists
    my %AllQueue = $Self->{DBObject}->GetTableData(
        Table => 'queue',
        What  => 'id, name',
    );
    my %OldQueue = $Self->QueueGet( ID => $Param{QueueID} );
    for ( keys %AllQueue ) {
        if ( $AllQueue{$_} =~ /^$Param{Name}$/i && $_ != $Param{QueueID} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Queue '$Param{Name}' exists! Can't updated queue '$OldQueue{Name}'.",
            );
            return;
        }
    }

    # sql
    my $SQL
        = "UPDATE queue SET name = '$DB{Name}', "
        . " comments = '$DB{Comment}', "
        . " group_id = $DB{GroupID}, "
        . " unlock_timeout = $DB{UnlockTimeout}, "
        . " first_response_time = $DB{FirstResponseTime}, "
        . " first_response_notify = $DB{FirstResponseNotify}, "
        . " update_time = $DB{UpdateTime}, "
        . " update_notify = $DB{UpdateNotify}, "
        . " solution_time = $DB{SolutionTime}, "
        . " solution_notify = $DB{SolutionNotify}, "
        . " follow_up_id = $DB{FollowUpID}, "
        . " follow_up_lock = $DB{FollowUpLock}, "
        . " system_address_id = $DB{SystemAddressID}, "
        . " calendar_name = '$DB{Calendar}', "
        . " default_sign_key = '$DB{DefaultSignKey}', "
        . " salutation_id = $DB{SalutationID}, "
        . " signature_id = $DB{SignatureID}, "
        . " move_notify = $DB{MoveNotify}, "
        . " state_notify = $DB{StateNotify}, "
        . " lock_notify = $DB{LockNotify}, "
        . " owner_notify = $DB{OwnerNotify}, "
        . " valid_id = $DB{ValidID}, "
        . " change_time = current_timestamp, "
        . " change_by = $DB{UserID} "
        . " WHERE id = $DB{QueueID}";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # updated all sub queue names
        my @ParentQueue = split( /::/, $OldQueue{Name} );
        my %AllQueue = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What  => 'id, name',
        );
        for ( keys %AllQueue ) {
            my @SubQueue = split( /::/, $AllQueue{$_} );
            if ( $#SubQueue > $#ParentQueue ) {
                if ( $AllQueue{$_} =~ /^\Q$OldQueue{Name}::\E/i ) {
                    my $NewQueueName = $AllQueue{$_};
                    $NewQueueName =~ s/\Q$OldQueue{Name}\E/$Param{Name}/;
                    $NewQueueName = $Self->{DBObject}->Quote($NewQueueName);
                    my $SQL
                        = "UPDATE queue SET "
                        . " name = '$NewQueueName', "
                        . " change_time = current_timestamp, "
                        . " change_by = $DB{UserID} "
                        . " WHERE id = $_";
                    $Self->{DBObject}->Do( SQL => $SQL );
                }
            }
        }
        return 1;
    }
    else {
        return;
    }
}

=item QueuePreferencesSet()

set queue preferences

    $QueueObject->QueuePreferencesSet(
        QueueID => 123,
        Key     => 'UserComment',
        Value   => 'some comment',
        UserID  => 123,
    );

=cut

sub QueuePreferencesSet {
    my $Self = shift;
    return $Self->{PreferencesObject}->QueuePreferencesSet(@_);
}

=item QueuePreferencesGet()

get queue preferences

    my %Preferences = $QueueObject->QueuePreferencesGet(
        QueueID => 123,
        UserID  => 123,
    );

=cut

sub QueuePreferencesGet {
    my $Self = shift;
    return $Self->{PreferencesObject}->QueuePreferencesGet(@_);
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.80 $ $Date: 2008-02-20 12:14:32 $

=cut
