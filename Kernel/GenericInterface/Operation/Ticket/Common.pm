# --
# Kernel/GenericInterface/Operation/Ticket/Common.pm - Ticket common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.15 2011-12-28 02:31:18 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::Common;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Lock;
use Kernel::System::Type;
use Kernel::System::CustomerUser;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::System::Valid;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Operation::Ticket::Common;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SolManCommonObject = Kernel::GenericInterface::Operation::Ticket::Common->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw( DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject WebserviceID)
        )
    {

        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{QueueObject}        = Kernel::System::Queue->new( %{$Self} );
    $Self->{LockObject}         = Kernel::System::Lock->new( %{$Self} );
    $Self->{TypeObject}         = Kernel::System::Type->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}      = Kernel::System::Service->new( %{$Self} );
    $Self->{SLAObject}          = Kernel::System::SLA->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
    $Self->{PriorityObject}     = Kernel::System::Priority->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );
    $Self->{WebserviceObject}   = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    # get webservice configuration
    $Self->{Webservice} = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    if ( !IsHashRefWithData( $Self->{Webservice} ) ) {
        return $Self->_ReturnError(
            ErrorCode => 'Webservice.InvalidConfiguration',
            ErrorMessage =>
                'Could not determine Web service configuration'
                . ' in Kernel::GenericInterface::Operation::Ticket::Common::new()',
        );
    }

    return $Self;
}

=item AuthUser()

performs user authenrication

    my $Success = $CommonObject->AuthUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
        CrypPaswd => '50/\/\3 p455\/\/0rd',     # cripted password with the current crypt algorithm
    );

    returns

    $Success = 1;                               # || 0

=cut

sub AuthUser {
    my ( $Self, %Param ) = @_;

    #TODO Implement
    return 1;
}

=item ReturnError()

helper function to return an error message.

    my $Return = $CommonObject->ReturnError(
        ErrorCode    => Ticket.AccessDenied,
        ErrorMessage => 'You dont have rights to access this ticket',
    );

=cut

sub ReturnError {
    my ( $Self, %Param ) = @_;

    $Self->{DebuggerObject}->Error(
        Summary => $Param{ErrorCode},
        Data    => $Param{ErrorMessage},
    );

    # return structure
    return {
        Success      => 1,
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
        Data         => {
            Error => {
                ErrorCode    => $Param{ErrorCode},
                ErrorMessage => $Param{ErrorMessage},
            },
        },
    };
}

=item ValidateQueue()

checks if the given queue or queue ID is valid.

    my $Sucess = $CommonObject->ValidateQueue(
        QueueID => 123,
    );

    my $Sucess = $CommonObject->ValidateQueue(
        Queue   => 'some queue',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateQueue {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{QueueID} && !$Param{Queue};

    my %QueueData;

    # check for Queue name sent
    if (
        $Param{Queue}
        && $Param{Queue} ne ''
        && !$Param{QueueID}
        )
    {
        %QueueData = $Self->{QueueObject}->QueueGet(
            Name => $Param{Queue},
        );

    }

    # otherwise use QueueID
    elsif ( $Param{QueueID} ) {
        %QueueData = $Self->{QueueObject}->QueueGet(
            ID => $Param{QueueID},
        );
    }
    else {
        return;
    }

    # return false if queue data is empty
    return if !IsHashRefWithData( \%QueueData );

    # return false if queue is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $QueueData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateLock()

checks if the given lock or lock ID is valid.

    my $Sucess = $CommonObject->ValidateLock(
        LockID => 123,
    );

    my $Sucess = $CommonObject->ValidateLock(
        Lock   => 'some lock',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{LockID} && !$Param{Lock};

    # check for Lock name sent
    if (
        $Param{Lock}
        && $Param{Lock} ne ''
        && !$Param{LockID}
        )
    {
        my $LockID = $Self->{LockObject}->LockLookup(
            Lock => $Param{Lock},
        );
        return if !$LockID;
    }

    # otherwise use LockID
    elsif ( $Param{LockID} ) {
        my $Lock = $Self->{LockObject}->LockLookup(
            LockID => $Param{LockID},
        );
        use Data::Dumper;
        return if !$Lock;
    }
    else {
        return;
    }

    return 1;
}

=item ValidateType()

checks if the given type or type ID is valid.

    my $Sucess = $CommonObject->ValidateType(
        TypeID => 123,
    );

    my $Sucess = $CommonObject->ValidateType(
        Type   => 'some type',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{TypeID} && !$Param{Type};

    my %TypeData;

    # check for Type name sent
    if (
        $Param{Type}
        && $Param{Type} ne ''
        && !$Param{TypeID}
        )
    {
        %TypeData = $Self->{TypeObject}->TypeGet(
            Name => $Param{Type},
        );
    }

    # otherwise use TypeID
    elsif ( $Param{TypeID} ) {
        %TypeData = $Self->{TypeObject}->TypeGet(
            ID => $Param{TypeID},
        );
    }
    else {
        return;
    }

    # return false if type data is empty
    return if !IsHashRefWithData( \%TypeData );

    # return false if type is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $TypeData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateCustomer()

checks if the given customer user or customer ID is valid.

    my $Sucess = $CommonObject->ValidateCustomer(
        CustomerID => 123,
    );

    my $Sucess = $CommonObject->ValidateCustomer(
        CustomerUser   => 'some type',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateCustomer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{CustomerUser};

    my %CustomerData;

    # check for customer user sent
    if (
        $Param{CustomerUser}
        && $Param{CustomerUser} ne ''
        )
    {
        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Param{CustomerUser},
        );
    }

    else {
        return;
    }

    # return false if customer data is empty
    return if !IsHashRefWithData( \%CustomerData );

    # return false if type is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $CustomerData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateService()

checks if the given service or service ID is valid.

    my $Sucess = $CommonObject->ValidateService(
        ServiceID    => 123,
        CustomerUser => 'Test',
    );

    my $Sucess = $CommonObject->ValidateService(
        Service      => 'some service',
        CustomerUser => 'Test',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateService {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{ServiceID} && !$Param{Service};
    return if !$Param{CustomerUser};

    my %ServiceData;

    # check for Service name sent
    if (
        $Param{Service}
        && $Param{Service} ne ''
        && !$Param{ServiceID}
        )
    {
        %ServiceData = $Self->{ServiceObject}->ServiceGet(
            Name   => $Param{Service},
            UserID => 1,
        );
    }

    # otherwise use ServiceID
    elsif ( $Param{ServiceID} ) {
        %ServiceData = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $Param{ServiceID},
            UserID    => 1,
        );
    }
    else {
        return;
    }

    # return false if service data is empty
    return if !IsHashRefWithData( \%ServiceData );

    # return false if service is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $ServiceData{ValidID} ) ne 'valid';

    # get customer services
    my %CustomerServices = $Self->{ServiceObject}->CustomerUserServiceMemberList(
        CustomerUserLogin => $Param{CustomerUser},
        Result            => 'HASH',
        DefaultServices   => 1,
    );

    # return if user does not have pemission to use the service
    return if !$CustomerServices{ $ServiceData{ServiceID} };

    return 1;
}

=item ValidateSLA()

checks if the given service or service ID is valid.

    my $Sucess = $CommonObject->ValidateSLA(
        SLAID     => 12,
        ServiceID => 123,       # || Service => 'some service'
    );

    my $Sucess = $CommonObject->ValidateService(
        SLA       => 'some SLA',
        ServiceID => 123,       # || Service => 'some service'
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateSLA {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{SLAID}     && !$Param{SLA};
    return if !$Param{ServiceID} && !$Param{Service};

    my %SLAData;

    # check for SLA name sent
    if (
        $Param{SLA}
        && $Param{SLA} ne ''
        && !$Param{SLAID}
        )
    {
        my $SLAID = $Self->{SLAObject}->SLALookup(
            Name => $Param{SLA},
        );
        %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $SLAID,
            UserID => 1,
        );
    }

    # otherwise use SLAID
    elsif ( $Param{SLAID} ) {
        %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $Param{SLAID},
            UserID => 1,
        );
    }
    else {
        return;
    }

    # return false if SLA data is empty
    return if !IsHashRefWithData( \%SLAData );

    # return false if SLA is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $SLAData{ValidID} ) ne 'valid';

    # get Sservice ID
    my $ServiceID;
    if (
        $Param{Service}
        && $Param{Service} ne ''
        && !$Param{ServiceID}
        )
    {
        $ServiceID = $Self->{ServiceObject}->ServiceLookup( Name => $Param{Service} ) || 0;
    }
    else {
        $ServiceID = $Param{ServiceID} || 0;
    }

    return if !$ServiceID;

    # check if SLA belogns to service
    my $SLABelongsToService;

    SERVICEID:
    for my $SLAServiceID ( @{ $SLAData{ServiceIDs} } ) {
        next SERVICEID if !$SLAServiceID;
        if ( $SLAServiceID eq $ServiceID ) {
            $SLABelongsToService = 1;
            last SERVICEID;
        }
    }

    # return if SLA does not beong to the service
    return if !$SLABelongsToService;

    return 1;
}

=item ValidateState()

checks if the given state or state ID is valid.

    my $Sucess = $CommonObject->ValidateState(
        StateID => 123,
    );

    my $Sucess = $CommonObject->ValidateState(
        State   => 'some state',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateState {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{StateID} && !$Param{State};

    my %StateData;

    # check for State name sent
    if (
        $Param{State}
        && $Param{State} ne ''
        && !$Param{StateID}
        )
    {
        %StateData = $Self->{StateObject}->StateGet(
            Name => $Param{State},
        );

    }

    # otherwise use StateID
    elsif ( $Param{StateID} ) {
        %StateData = $Self->{StateObject}->StateGet(
            ID => $Param{StateID},
        );
    }
    else {
        return;
    }

    # return false if state data is empty
    return if !IsHashRefWithData( \%StateData );

    # return false if queue is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $StateData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidatePriority()

checks if the given priority or priority ID is valid.

    my $Sucess = $CommonObject->ValidatePriority(
        PriorityID => 123,
    );

    my $Sucess = $CommonObject->ValidatePriority(
        Priority   => 'some priority',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidatePriority {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{PriorityID} && !$Param{Priority};

    my %PriorityData;

    # check for Priority name sent
    if (
        $Param{Priority}
        && $Param{Priority} ne ''
        && !$Param{PriorityID}
        )
    {
        my $PriorityID = $Self->{PriorityObject}->PriorityLookup(
            Priority => $Param{Priority},
        );
        %PriorityData = $Self->{PriorityObject}->PriorityGet(
            PriorityID => $PriorityID,
            UserID     => 1,
        );
    }

    # otherwise use PriorityID
    elsif ( $Param{PriorityID} ) {
        %PriorityData = $Self->{PriorityObject}->PriorityGet(
            PriorityID => $Param{PriorityID},
            UserID     => 1,
        );
    }
    else {
        return;
    }

    # return false if priority data is empty
    return if !IsHashRefWithData( \%PriorityData );

    # return false if priority is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $PriorityData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateOwner()

checks if the given owner or owner ID is valid.

    my $Sucess = $CommonObject->ValidateOwner(
        OwnerID => 123,
    );

    my $Sucess = $CommonObject->ValidateOwner(
        Owner   => 'some user',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateOwner {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{OwnerID} && !$Param{Owner};

    return $Self->_ValidateUser(
        UserID => $Param{OwnerID} || '',
        User   => $Param{Owner}   || '',
    );
}

=item ValidateResponsible()

checks if the given responsible or responsible ID is valid.

    my $Sucess = $CommonObject->ValidateResponsible(
        ResponsibleID => 123,
    );

    my $Sucess = $CommonObject->ValidateResponsible(
        Responsible   => 'some user',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateResponsible {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{ResponsibleID} && !$Param{Responsible};

    return $Self->_ValidateUser(
        UserID => $Param{ResponsibleID} || '',
        User   => $Param{Responsible}   || '',
    );
}

=item ValidatePendingTime()

checks if the given pending time is valid.

    my $Sucess = $CommonObject->ValidatePendingTime(
        PendingTime => {
            Year   => 2011,
            Month  => 12,
            Day    => 23,
            Hour   => 15,
            Minute => 0,
        },
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidatePendingTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{PendingTime};
    return if !IsHashRefWithData( $Param{PendingTime} );

    # check that no time attibute is empty or negative
    for my $TimeAttribute ( keys %{ $Param{PendingTime} } ) {
        return if $Param{PendingTime}->{$TimeAttribute} eq '';
        return if int $Param{PendingTime}->{$TimeAttribute} < 0,
    }

    # try to convert pending time to a SystemTime
    my $SystemTime = $Self->{TimeObject}->Date2SystemTime(
        %{ $Param{PendingTime} },
        Second => 0,
    );
    return if !$SystemTime;

    return 1;
}

=item ValidateArticleType()

checks if the given ArticleType or ArticleType ID is valid.

    my $Sucess = $CommonObject->ValidateArticleType(
        ArticleTypeID => 123,
    );

    my $Sucess = $CommonObject->ValidateArticleType(
        ArticleType => 'some ArticleType',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateArticleType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{ArticleTypeID} && !$Param{ArticleType};

    my %ArticleTypeList = $Self->{TicketObject}->ArticleTypeList(
        Result => 'HASH',

        # add type parameter for customer interface
        # Type   => 'Customer',
    );

    # check for ArticleType name sent
    if (
        $Param{ArticleType}
        && $Param{ArticleType} ne ''
        && !$Param{ArticleTypeID}
        )
    {
        my $ArticleTypeID = $Self->{TicketObject}->ArticleTypeLookup(
            ArticleType => $Param{ArticleType},
        );

        return if !$ArticleTypeID;

        # check if $ArticleType is valid
        return if !$ArticleTypeList{$ArticleTypeID};
    }

    # otherwise use ArticleTypeID
    elsif ( $Param{ArticleTypeID} ) {
        my $ArticleType = $Self->{TicketObject}->ArticleTypeLookup(
            ArticleTypeID => $Param{ArticleTypeID},
        );

        return if !$ArticleType;

        # check if $ArticleType is valid
        return if !$ArticleTypeList{ $Param{ArticleTypeID} };
    }
    else {
        return;
    }

    return 1;
}

=item ValidateSenderType()

checks if the given SenderType or SenderType ID is valid.

    my $Sucess = $CommonObject->ValidateSenderType(
        SenderTypeID => 123,
    );

    my $Sucess = $CommonObject->ValidateenderType(
        SenderType => 'some SenderType',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateSenderType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{SenderTypeID} && !$Param{SenderType};

    my %SenderTypeList = $Self->{TicketObject}->ArticleSenderTypeList(
        Result => 'HASH',
    );

    # check for SenderType name sent
    if (
        $Param{SenderType}
        && $Param{SenderType} ne ''
        && !$Param{SenderTypeID}
        )
    {
        my $SenderTypeID = $Self->{TicketObject}->ArticleSenderTypeLookup(
            SenderType => $Param{SenderType},
        );

        return if !$SenderTypeID;

        # check if $SenderType is valid
        return if !$SenderTypeList{$SenderTypeID};
    }

    # otherwise use SenderTypeID
    elsif ( $Param{SenderTypeID} ) {
        my $SenderType = $Self->{TicketObject}->ArticleSenderTypeLookup(
            SenderTypeID => $Param{SenderTypeID},
        );

        return if !$SenderType;

        # check if $SenderType is valid
        return if !$SenderTypeList{ $Param{SenderTypeID} };
    }
    else {
        return;
    }

    return 1;
}

=item ValidateMimeType()

checks if the given MimeType is valid.

    my $Sucess = $CommonObject->ValidateMimeType(
        MimeTypeID => 'some MimeType',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateMimeType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{MimeType};

    return if $Param{MimeType} !~ m{\A\w+\/\w+\z};

    return 1;
}

=item ValidateCharset()

checks if the given Charset is valid.

    my $Sucess = $CommonObject->ValidateCharset(
        Charset => 'some charset',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateCharset {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{Charset};

    my $CharsetList = $Self->_CharsetList();

    return if !$CharsetList->{ $Param{Charset} };

    return 1;
}

=item ValidateHistoryType()

checks if the given HistoryType is valid.

    my $Sucess = $CommonObject->ValidateHistoryType(
        HistoryType => 'some HostoryType',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateHistoryType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{HistoryType};

    # check for HistoryType name sent
    if (
        $Param{HistoryType}
        && $Param{HistoryType} ne ''
        )
    {
        my $HistoryTypeID = $Self->{TicketObject}->HistoryTypeLookup(
            Type => $Param{HistoryType},
        );

        return if !$HistoryTypeID;
    }
    else {
        return;
    }
    return 1;
}

=begin Internal:

=item _ValidateUser()

checks if the given user or user ID is valid.

    my $Sucess = $CommonObject->_ValidateUser(
        UserID => 123,
    );

    my $Sucess = $CommonObject->_ValidateUser(
        User   => 'some user',
    );

    returns
    $Success = 1            # or 0

=cut

sub _ValidateUser {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{UserID} && !$Param{User};

    my %UserData;

    # check for User name sent
    if (
        $Param{User}
        && $Param{User} ne ''
        && !$Param{UserID}
        )
    {
        %UserData = $Self->{UserObject}->GetUserData(
            User  => $Param{User},
            Valid => 1,
        );
    }

    # otherwise use UserID
    elsif ( $Param{UserID} ) {
        %UserData = $Self->{UserObject}->GetUserData(
            UserID => $Param{UserID},
            Valid  => 1,
        );
    }
    else {
        return;
    }

    # return false if priority data is empty
    return if !IsHashRefWithData( \%UserData );

    return 1;
}

=item _CharsetList()

returns a list of all available charsets.

    my $CharsetList = $CommonObject->_CharsetList(
        UserID => 123,
    );

    returns
    $Success = {
        #...
        iso-8859-1  => 1,
        iso-8859-15 => 1,
        MacRoman    => 1,
        utf8        => 1,
        #...
    }

=cut

sub _CharsetList {
    my ( $Self, %Param ) = @_;

    # get charset array
    use Encode;
    my @CharsetList = Encode->encodings(":all");

    my %CharsetHash;

    # create a charset lookup table
    for my $Charset (@CharsetList) {
        $CharsetHash{$Charset} = 1;
    }

    return \%CharsetHash;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.15 $ $Date: 2011-12-28 02:31:18 $

=cut
