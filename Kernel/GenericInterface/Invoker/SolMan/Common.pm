# --
# Kernel/GenericInterface/Invoker/SolMan/Common.pm - SolMan common invoker functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.30 2011-04-15 02:30:14 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::Common;

#QA: The naming of many functions here is pretty confusing, please improve. The names should indicate what this function does.
#QA: Internal functions should start with _.
#QA: The WebserviceID should be removed from all function signatures and put into the constructor as an argument once instead. This will not change within one object.
#QA: Same probably works with the Invoker as this should be known at instantiation already, please check.
#QA: Please check for code duplication in AddInfo, CloseIncident and ReplicateIncident.
#QA: We need to check which function stores which flags on which objects. This should be unified, if possible, also with the Operations.
#QA: see more comments below.

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::ObjectLockState;
use Kernel::Scheduler;
use MIME::Base64;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::Common - common invoker functions

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
    use Kernel::GenericInterface::Invoker::SolMan::Common;

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
    my $SolManCommonObject = Kernel::GenericInterface::Invoker::SolMan::Common->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
        Invoker            => 'ReplicateIncident'   # The invoker name
        WebserviceID       => '123'                 # The ID of the Webservice
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(
        DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject Invoker
        WebserviceID
        )
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
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
    $Self->{WebserviceObject}   = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
    $Self->{ObjectLockStateObject}
        = Kernel::System::GenericInterface::ObjectLockState->new( %{$Self} );

    # get max sync attemps
    $Self->{MaxSyncAttempts}
        = $Self->{ConfigObject}->Get('GenericInterface::Invoker::SolMan::MaxSyncAttempts') || 5;
    return $Self;
}

# handle common

=item HandleErrors()
Process errors from remote server, the result will be a string with all erros

    my $Result = $SolManCommonObject->HandleErrors(
        Errors     => {
            item => {
                ErrorCode => '01'
                Val1      =>  '[SystemErr]',
                Val2      =>  'Error Detail 1',
                Val3      =>  'Error Detail 2',
                Val4      =>  'Error Detail 3',
            }
        }
    );

    my $Result = $SolManCommonObject->HandleErrors(
        Errors     => {
            item => [
                {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',
                },
                {
                    ErrorCode => '04'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',
                },
            ],
        }
    );

    $Result = {
        Success      => 1,             # 1 or 0
        ErrorMessage => 'Error 01 System Error Details: Error Detail 1 Error Detail 2 Error Detail 1 | .',
    };

=cut

sub HandleErrors {
    my ( $Self, %Param ) = @_;

    # check for needed objects
    for my $Needed (qw(Errors)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Can't handle errors Got no $Needed!"
            };
        }
    }

    # to store the error message(s)
    my $ErrorMessage;

    # to store each error item
    my @ErrorItems;

    # check for multimple errors
    if ( IsArrayRefWithData( $Param{Errors}->{item} ) ) {

        # get all errors
        for my $Item ( @{ $Param{Errors}->{Item} } ) {
            if ( IsHashRefWithData($Item) ) {
                push @ErrorItems, $Item;
            }
        }
    }

    # only one error
    elsif ( IsHashRefWithData( $Param{Errors}->{item} ) ) {
        push @ErrorItems, $Param{Errors}->{item};
    }

    if ( scalar @ErrorItems gt 0 ) {

        # cicle trough all error items
        for my $Item (@ErrorItems) {

            # check error code
            if ( IsStringWithData( $Item->{ErrorCode} ) ) {
                $ErrorMessage .= "Error Code $Item->{ErrorCode} ";
            }
            else {
                $ErrorMessage .= 'An error message was received but no Error Code found! ';
            }

            # set the erros description
            if ( IsStringWithData( $Item->{Val1} ) ) {
                $ErrorMessage .= "$Item->{Val1} ";
            }
            $ErrorMessage .= 'Details: ';

            # cicle trough all details
            for my $Val qw(Val2 Val3 Val4) {
                if ( IsStringWithData( $Item->{"$Val"} ) ) {
                    $ErrorMessage .= "$Item->{$Val}  ";
                }
            }

            $ErrorMessage .= " | ";
        }
    }
    else {
        $ErrorMessage = "An Error was returned from remote server but can't get any data";
    }

    # write in debug log
    $Self->{DebuggerObject}->Error(
        Summary => "$Self->{Invoker} return error",
        Data    => $ErrorMessage,
    );

    return {
        Success      => 1,
        ErrorMessage => $ErrorMessage,
    };

}

=item _HandlePersonMaps()
Process person maps from the remote server, the result will always be an array ref

    my $Result = $SolManCommonObject->_HandlePersonMaps(
        PersonMaps     => {
            item => {
                PersonId    => '0001',
                PersonIdExt => '5050',
            }
        }
    );

    my $Result = $SolManCommonObject->_HandlePersonMaps(
        PersonMaps     => {
            item => [
                {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                {
                    PersonId    => '0002',
                    PersonIdExt => '5051',
                },
            ],
        }
    );

    $Result = {
        Success      => 1,                # 1 or 0
        ErrorMessage => ' ',              # optional if there is an error hadling the person maps
        PersonMap    => [
                {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                {
                    PersonId    => '0002',
                    PersonIdExt => '5051',
                },
        ],
    };
=cut

sub _HandlePersonMaps {
    my ( $Self, %Param ) = @_;

    # check for needed objects
    for my $Needed (qw(PersonMaps)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Can't handle person maps Got no $Needed!"
            };
        }
    }

    # to store each preson map item
    my @PersonMaps;

    # to store possible errors
    my $ErrorMessage;

    # check for multimple person maps
    if ( IsArrayRefWithData( $Param{PersonMaps}->{item} ) ) {

        # get all person maps
        for my $Item ( @{ $Param{PersonMaps}->{item} } ) {
            if ( IsHashRefWithData($Item) ) {

                # check for valid data
                if (
                    !IsStringWithData( $Item->{PersonId} )
                    || !IsStringWithData( $Item->{PersonIdExt} )
                    )
                {

                    $ErrorMessage = 'PersonId or PersonIdExt is empty';

                    # write in debug log
                    $Self->{DebuggerObject}->Error(
                        Summary => "$Self->{Invoker} return error",
                        Data    => $ErrorMessage,
                    );

                    return {
                        Success      => 0,
                        ErrorMessage => $ErrorMessage,
                    };
                }
                push @PersonMaps, $Item;
            }
        }
    }

    # only one person map
    elsif ( IsHashRefWithData( $Param{PersonMaps}->{item} ) ) {

        # check for valid data
        if (
            !IsStringWithData( $Param{PersonMaps}->{item}->{PersonId} )
            || !IsStringWithData( $Param{PersonMaps}->{item}->{PersonIdExt} )
            )
        {

            $ErrorMessage = 'PersonId or PersonIdExt is empty';

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "$Self->{Invoker} return error",
                Data    => $ErrorMessage,
            );

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
        push @PersonMaps, $Param{PersonMaps}->{item};
    }

    else {
        $ErrorMessage = 'PersonMaps should have at least one item';

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => "$Self->{Invoker} return error",
            Data    => $ErrorMessage,
        );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    return {
        Success    => 1,
        PersonMaps => \@PersonMaps,
    };
}

# utilities

=item GetSystemGuid()
returns the System ID as MD5sum, to be used as local SystemGuid for SolMan communication

    my $Result = $SolManCommonObject->GetSystemGuid();

    $Result = 123ABC123ABC123ABC123ABC123ABC12;
=cut

sub GetSystemGuid {
    my ( $Self, %Param ) = @_;

    # get SystemID
    my $SystemID = $Self->{ConfigObject}->Get('SystemID') || 10;

    # convert SystemID to MD5 string
    my $SystemIDMD5 = $Self->{MainObject}->MD5sum(
        String => $SystemID,
    );

    # conver to upper case to match SolMan style
    $SystemIDMD5 = uc $SystemIDMD5;

    return $SystemIDMD5;
}

=item GetPersonsInfo()
returns the IctPersons array and Language for SolMan communication

    my $Result = $SolManCommonObject->GetPersonsInfo(
        UserID         => 123,
        CustomerUserID => 'JDoe'
    );

    $Result = {
        IctPersons => [
            {
                PersonId    => 123,                                # type="n0:char32"
                PersonIdExt => '',                                 # type="n0:char32"
                Sex         => '',                                 # type="n0:char1"
                FirstName   => 'Luke',                             # type="n0:char40"
                LastName    => 'Skywalker',                        # type="n0:char40"
                Telephone   => '',                                 # type="tns:IctPhone"
                MobilePhone => '',                                 # type="n0:char30"
                Fax         => '',                                 # type="tns:IctFax"
                Email       => 'Luke.Skywalker@RebelAlliance.org', # type="n0:char240"
            },
            {
                PersonId    => 'JDoe',                             # type="n0:char32"
                PersonIdExt => '',                                 # type="n0:char32"
                Sex         => '',                                 # type="n0:char1"
                FirstName   => John,                               # type="n0:char40"
                LastName    => Doe,                                # type="n0:char40"
                Telephone   => {                                   # type="tns:IctPhone" if PhoneNo
                    PhoneNo   =>  '1234 5678'
                },
                MobilePhone => '1234 5680',                        # type="n0:char30"
                Fax         => {                                   # type="tns:IctFax" if FaxNo
                    FaxNo     =>  '1234 5690',
                }
                Email       => 'John.Doe@Movies.com',              # type="n0:char240"
            },
        ],
        Language   => 'en',
    };
=cut

sub GetPersonsInfo {
    my ( $Self, %Param ) = @_;

    my @IctPersons;

    # customer
    my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $Param{CustomerUserID},
    );
    my $IctCustomerUser = {
        PersonId => $CustomerUser{UserID} || '',    # type="n0:char32"
        PersonIdExt => '',                                    # type="n0:char32"
        Sex         => '',                                    # type="n0:char1"
        FirstName   => $CustomerUser{UserFirstname} || '',    # type="n0:char40"
        LastName    => $CustomerUser{UserLastname} || '',     # type="n0:char40"
        Telephone   => $CustomerUser{UserPhone}
        ?                                                     # type="tns:IctPhone"
            { PhoneNo => $CustomerUser{UserPhone} }
        : '',
        MobilePhone => $CustomerUser{UserMobile} || '',       # type="n0:char30"
        Fax => $CustomerUser{UserFax}
        ?                                                     # type="tns:IctFax"
            { FaxNo => $CustomerUser{UserFax} }
        : '',
        Email => $CustomerUser{UserEmail} || '',              # type="n0:char240"
    };

    push @IctPersons, $IctCustomerUser;

    # use customer languge as language or english by default
    my $Language = $CustomerUser{UserLanguage} || 'en';

    # agent
    my %AgentData = $Self->{UserObject}->GetUserData(
        UserID => $Param{UserID},
    );
    my %IctAgentUser = (
        PersonId => $AgentData{UserID} || '',    # type="n0:char32"
        PersonIdExt => '',                                 # type="n0:char32"
        Sex         => '',                                 # type="n0:char1"
        FirstName   => $AgentData{UserFirstname} || '',    # type="n0:char40"
        LastName    => $AgentData{UserLastname} || '',     # type="n0:char40"
        Telephone   => '',                                 # type="tns:IctPhone"
        MobilePhone => '',                                 # type="n0:char30"
        Fax         => '',                                 # type="tns:IctFax"
        Email       => $AgentData{UserEmail} || '',        # type="n0:char240"
    );

    push @IctPersons, {%IctAgentUser};

    my $Result = {
        IctPersons => \@IctPersons,
        Language   => $Language
    };

    return $Result
}

=item GetAditionalInfo()
this function is not yet implemented, returns empty hash ref
=cut

sub GetAditionalInfo {
    my ( $Self, %Param ) = @_;

    my %IctAdditionalInfos;

    #    my %IctAdditionalInfos = (
    #        IctAdditionalInfo => {
    #            Guid             => '',    # type="n0:char32"
    #            ParentGuid       => '',    # type="n0:char32"
    #            AddInfoAttribute => '',    # type="n0:char255"
    #            AddInfoValue     => '',    # type="n0:char255"
    #        },
    #    );

    if (%IctAdditionalInfos) {
        return \%IctAdditionalInfos;
    }

    return '';
}

=item GetSapNotesInfo()
this function is not yet implemented, returns empty hash ref
=cut

sub GetSapNotesInfo {
    my ( $Self, %Param ) = @_;

    my %IctSapNotes;

    #    my %IctSapNotes = (
    #        IctSapNote => {
    #            NoteId          => '',                       # type="n0:char30"
    #            NoteDescription => '',                       # type="n0:char60"
    #            Timestamp       => '',                       # type="n0:decimal15.0"
    #            PersonId        => '',                       # type="n0:char32"
    #            Url             => '',                       # type="n0:char4096"
    #            Language        => '',                       # type="n0:char2"
    #            Delete          => '',                       # type="n0:char1"
    #        },
    #    );

    if (%IctSapNotes) {
        return \%IctSapNotes;
    }

    return '';

}

=item GetSolutionsInfo()
this function is not yet implemented, returns empty hash ref
=cut

sub GetSolutionsInfo {
    my ( $Self, %Param ) = @_;

    my %IctSolutions;

    #    my %IctSolutions = (
    #        IctSolution => {
    #            SolutionId          => '',                   # type="n0:char32"
    #            SolutionDescription => '',                   # type="n0:char60"
    #            Timestamp           => '',                   # type="n0:decimal15.0"
    #            PersonId            => '',                   # type="n0:char32"
    #            Url                 => '',                   # type="n0:char4096"
    #            Language            => '',                   # type="n0:char2"
    #            Delete              => '',                   # type="n0:char1"
    #        },
    #    );

    if (%IctSolutions) {
        return \%IctSolutions;
    }

    return '';

}

=item GetUrlsInfo()
this function is not yet implemented, returns empty hash ref
=cut

sub GetUrlsInfo {
    my ( $Self, %Param ) = @_;

    my %IctUrls;

    #    my %IctUrls = (
    #        IctUrl => {
    #            UrlGuid        => '',                        # type="n0:char32"
    #            Url            => '',                        # type="n0:char4096"
    #            UrlName        => '',                        # type="n0:char40"
    #            UrlDescription => '',                        # type="n0:char64"
    #            Timestamp      => '',                        # type="n0:decimal15.0"
    #            PersonId       => '',                        # type="n0:char32"
    #            Language       => '',                        # type="n0:char2"
    #            Delete         => '',                        # type="n0:char1"
    #        },
    #    );

    if (%IctUrls) {
        return %IctUrls;
    }

    return '';

}

=item GetArticlesInfo()
returns the IctAttachments array and IctStatements array for SolMan communication

    my $Result = $SolManCommonObject->GetArticlesInfo(
        UserID   => 123,
        TicketID => 67,
        LastSync => 1302724965,  # Last sync time as SystemTime fomat or 0 if none
        Language => 'en'
    );

    $Result = {
        IctAttachments => [
            {
                AttachmentGuid => 23-1,                 # type="n0:char32"
                                                        # ArticleID-AttachmentIndex

                Filename       => doc.txt,              # type="xsd:string"
                MimeType       => text/plain,           # type="n0:char128"
                Data           => ...,                  # type="xsd:base64Binary" content of the
                                                        # attachment base 64 encoded

                Timestamp      => '20110329124029',     # type="n0:decimal15.0" timestamp without
                                                        # any separators

                PersonId       => 123,                  # type="n0:char32"
                Url            => '',                   # type="n0:char4096"
                Language       => 'de',                 # type="n0:char2"
                Delete         => '',                   # type="n0:char1"
            },
        ],
        IctStatements => [
            {
                TextType  => 'SU99',                    # type="n0:char32" Internal SolMan type
                Texts     => {                          # type="tns:IctTexts"
                    item    => [                        # article content
                        'Subject',
                        "\n",
                        'Body',
                    ]
                },
                Timestamp => '20110329124029',          # type="n0:decimal15.0" timestamp without
                                                        # any separators

                PersonId  => 123,                       # type="n0:char32"
                Language  => 'de,                       # type="n0:char2"
            },
        ],
    };
=cut

sub GetArticlesInfo {
    my ( $Self, %Param ) = @_;

    my @Articles = $Self->{TicketObject}->ArticleGet(
        TicketID => $Param{TicketID},
    );

    my @IctAttachments;
    my @IctStatements;

    ARTICLE:
    for my $Article (@Articles) {

        # checkif article needs to be synced
        my $ArticleCreateTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Article->{Created},
        );
        next ARTICLE if ( int $ArticleCreateTime <= int $Param{LastSync} );

        my $CreateTime = $Article->{Created};
        $CreateTime =~ s{[:|\-|\s]}{}g;

        # IctStatements
        my %IctStatement = (
            TextType => $Article->{ArticleType},    # type="n0:char32"

            #TextType => 'SU99',                     # type="n0:char32"
            Texts => {                              # type="tns:IctTexts"
                item => [
                    $Article->{Subject} || '',
                    "\n",
                    $Article->{Body} || '',
                    ]
            },
            Timestamp => $CreateTime,               # type="n0:decimal15.0"
            PersonId  => $Param{UserID},            # type="n0:char32"
            Language  => $Param{Language},          # type="n0:char2"
        );
        push @IctStatements, {%IctStatement};

        # attachments
        my %AttachmentIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID                  => $Article->{ArticleID},
            UserID                     => $Param{UserID},
            Article                    => $Article,
            StripPlainBodyAsAttachment => 3,
        );

        for my $Index ( keys %AttachmentIndex ) {
            my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $Article->{ArticleID},
                FileID    => $Index,
                UserID    => $Param{UserID},
            );

            $Attachment{ContentType} =~ s{ [,;] [ ]* charset= .+ \z }{}xmsi;

            my %IctAttachment = (
                AttachmentGuid => $Article->{ArticleID} . '-' . $Index,    # type="n0:char32"
                Filename       => $AttachmentIndex{$Index}->{Filename},    # type="xsd:string"
                MimeType       => $Attachment{ContentType},                # type="n0:char128"
                Data           => encode_base64( $Attachment{Content} ),   # type="xsd:base64Binary"
                Timestamp      => $CreateTime,                             # type="n0:decimal15.0"
                PersonId       => $Param{UserID},                          # type="n0:char32"
                Url            => '',                                      # type="n0:char4096"
                Language       => $Param{Language},                        # type="n0:char2"
                Delete         => '',                                      # type="n0:char1"
            );
            push @IctAttachments, {%IctAttachment};
        }
    }

    my $Result = {
        IctAttachments => \@IctAttachments,
        IctStatements  => \@IctStatements
    };

    return $Result
}

=item GetRemoteSystemGuid()
reads the SystemGuid from the invoker configuration
returns the SystemGuid or empty if it is not set for the invoker

    my $RemoteSystemGuid = $SolManCommonObject->GetRemoteSystemGuid();

    $RemoteSystemGuid = '123ABC123ABC123ABC123ABC123ABC12';  # or ''
=cut

sub GetRemoteSystemGuid {
    my ( $Self, %Param ) = @_;

    # get webservice configuration
    my $Webservice = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Self->{WebserviceID},
    );

    # check if webservice configuration is valid
    if ( !IsHashRefWithData($Webservice) ) {
        $Self->{DebuggerObject}->Error(
            Summary => "GetRemoteSystemGuid: Webservice configuration is invalid",
        );
        return;
    }

    # check if invoker configuration is valid
    if (
        !IsHashRefWithData( $Webservice->{Config}->{Requester}->{Invoker}->{ $Self->{Invoker} } )
        )
    {
        $Self->{DebuggerObject}->Error(
            Summary => "GetRemoteSystemGuid: Invoker configuration for $Self->{Invoker} is invalid",
        );
        return;
    }

    # get invoker configuration
    my $Invoker = $Webservice->{Config}->{Requester}->{Invoker}->{ $Self->{Invoker} };

    my $SystemGuid;

    # check if invoker has SystemGuid defined in its configuration and return it, otherwise
    # return empty
    if ( $Invoker->{RemoteSystemGuid} ) {
        $SystemGuid = $Invoker->{RemoteSystemGuid};

        # write on the debug log
        $Self->{DebuggerObject}->Debug(
            Summary => "GetRemoteSystemGuid: SystemGuid got from Invoker configuration",
        );

    }
    return $SystemGuid;
}

=item SetRemoteSystemGuid()
writes the SystemGuid in the specified invoker configuration or in all invokers if param AllInvokers
is present. Only one, Invoker or AllInvokers parameter should be passed.
returns 1 if the operation was successfull.

    my $Success = $SolManCommonObject->SetRemoteSystemGuid(
        WebserviceID => 123,
        SystemGuid   => '123ABC123ABC123ABC123ABC123ABC12'
        Invoker      => 'RepliateIncident',
    );

    my $Success = $SolManCommonObject->SetRemoteSystemGuid(
        WebserviceID => 123,
        SystemGuid   => '123ABC123ABC123ABC123ABC123ABC12'
        AllInvokers  =>1,
    );

    $Success = 1;      # or ''
=cut

sub SetRemoteSystemGuid {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(WebserviceID SystemGuid)) {
        if ( !$Param{$Needed} ) {

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "SetRemoteSystemGuid: Got no $Param{$Needed}",
            );
            return;
        }
    }

    # exit if no param Invoker and AllInvokers
    if ( !$Param{Invoker} && !$Param{AllInvokers} ) {

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => "SetRemoteSystemGuid: Param AllInvokers or Invoker is needed",
        );
        return;
    }

    # exit if both param Invoker and AllInvokers exists
    if ( $Param{Invoker} && $Param{AllInvokers} ) {

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => "SetRemoteSystemGuid: Only parameter Invoker or AllInvokers"
                . "should be used, not both",
        );
        return;
    }

    # get webservice configuration
    my $Webservice = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    # check if webservice configuration is valid
    if ( !IsHashRefWithData($Webservice) ) {
        $Self->{DebuggerObject}->Error(
            Summary => "SetRemoteSystemGuid: Webservice configuration is invalid",
        );
        return;
    }

    my $Config = $Webservice->{Config};

    # set SystemGuid to all invokers
    if ( $Param{AllInvokers} ) {
        for my $Invoker ( sort keys %{ $Config->{Requester}->{Invoker} } ) {
            $Config->{Requester}->{Invoker}->{$Invoker}->{RemoteSystemGuid} = $Param{SystemGuid};
        }
    }

    # otherwise set SystemGuid to especific invoker
    else {
        $Config->{Requester}->{Invoker}->{ $Param{Invoker} }->{RemoteSystemGuid}
            = $Param{SystemGuid};
    }

    # update config
    my $Success = $Self->{WebserviceObject}->WebserviceUpdate(
        ID      => $Webservice->{ID},
        Name    => $Webservice->{Name},
        Config  => $Config,
        ValidID => $Webservice->{ValidID},
        UserID  => 1,
    );

    # if can't update config, write in the debug log
    if ( !$Success ) {
        $Self->{DebuggerObject}->Error(
            Summary => "SetRemoteSystemGuid: can't update Webservice configuration",
        );
    }

    # otherwise just send notification
    else {
        $Self->{DebuggerObject}->Error(
            Summary => "SetRemoteSystemGuid: Webservice configuration updated",
        );
    }

    return $Success;
}

#QA: what int the world does this function do? Improve naming and pod. What do the parameters do?

=item GetArticleLockStatus()

returns 1 if the operation was successfull.

    my $Success = $SolManCommonObject->GetArticleLockStatus(
        WebserviceID    => $Self->{WebserviceID},
        TicketID        => $Self->{TicketID},
        ArticleID       => $Self->{ArticleID},
        LockState      => 'InvokerName',
        UserID          => $Ticket{OwnerID},
    );

    $Success = 1;      # or ''
=cut

sub GetArticleLockStatus {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(WebserviceID TicketID ArticleID LockState UserID)) {
        if ( !$Param{$Needed} ) {

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "GetArticleLockStatus: Got no $Needed",
            );
            return;
        }
    }

  #QA: this function is supposed to 'get' a status, but here all of a sudden it schedules something!

    # if not $TicketAttemptFlagPresent and $TicketReplicateFlagPresent
    # are set yet, file a task in the scheduler for this ticket

    # if $TicketAttemptFlagPresent is present and it value
    # is less that max allowed, file a task in the scheduler
    # for this ticket
    my $IsPossibleToSyncTicket = $Self->IsPossibleToSyncObject(
        WebserviceID => $Param{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Param{TicketID},
    );
    if ( $IsPossibleToSyncTicket->{Possible} ) {
        my $Success = $Self->ScheduleTask(
            Type         => 'GenericInterface',
            Invoker      => 'ReplicateIncident',
            WebserviceID => $Param{WebserviceID},
            Data         => {                       # data for invoker
                WebserviceID => $Param{WebserviceID},
                TicketID     => $Param{TicketID},
            },
        );
        $Self->{DebuggerObject}->Info(
            Summary =>
                "GetArticleLockStatus: Ticket replication has been file as a new task",
        );
        return;
    }

    # if $ArticleAttempts is present and it value
    # is less that max allowed
    my $IsPossibleToSyncArticle = $Self->IsPossibleToSyncObject(
        WebserviceID => $Param{WebserviceID},
        ObjectType   => 'Article',
        ObjectID     => $Param{ArticleID},
    );
    if ( $IsPossibleToSyncArticle->{Possible} ) {
        my $SuccessArticleLock = $Self->{ObjectLockStateObject}->ObjectLockStateSet(
            WebserviceID     => $Param{WebserviceID},
            ObjectType       => 'Article',
            ObjectID         => $Param{ArticleID},
            LockState        => $Param{LockState},
            LockStateCounter => ++$IsPossibleToSyncArticle->{LockStateCounter},
        );
        $Self->{DebuggerObject}->Info(
            Summary =>
                "GetArticleLockStatus: Article lock state has been set with a new value",
        );
        return $SuccessArticleLock;
    }

    $Self->{DebuggerObject}->Error(
        Summary => "GetArticleLockStatus: AddInfo is not allowed.",
    );
    return;
}

#QA: what int the world does this function do? Improve naming and pod. What do the parameters do?
#QA: parameter SyncKey seems obsolete, as it can be computed from WebserviceID
# TODO this is probable not needed anymore
#=item GetTicketLockStatus()
#
#returns 1 if the operation was successfull.
#
#    my $Success = $SolManCommonObject->GetTicketLockStatus(
#        WebserviceID    => $Self->{WebserviceID},
#        TicketID        => $Self->{TicketID},
#        UserID          => $Ticket{OwnerID},
#        SyncKey         => GI_123_SolMan_IncidentGuid
#    );
#
#    $Success = 1;      # or ''
#=cut
#
#sub GetTicketLockStatus {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(WebserviceID TicketID LockState UserID SyncKey)) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "GetTicketReplicateStatus: Got no $Needed",
#            );
#            return;
#        }
#    }
#    my $IsPossibleToSyncTicket = $Self->IsPossibleToSyncObject(
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => 'Ticket',
#        ObjectID     => $Param{TicketID},
#        SyncKey      => $Param{SyncKey},
#    );
#    if ( $IsPossibleToSyncTicket->{Possible} ) {
#        my $SuccessTicketLock = $Self->{ObjectLockStateObject}->ObjectLockStateSet(
#            WebserviceID     => $Param{WebserviceID},
#            ObjectType       => 'Ticket',
#            ObjectID         => $Param{TicketID},
#            LockState        => $Param{LockState},
#            LockStateCounter => ++$IsPossibleToSyncTicket->{LockStateCounter},
#        );
#        $Self->{DebuggerObject}->Info(
#            Summary =>
#                "GetTicketReplicateStatus: Attemp Ticket flag has been set with a new value",
#        );
#        return $SuccessTicketLock;
#    }
#
#    $Self->{DebuggerObject}->Error(
#        Summary => "GetTicketReplicateStatus: Replicate Incident is not allowed.",
#    );
#    return;
#}

#QA: SyncKey seems obsolete, see comment above
#QA: From the name, this function returns 0 or 1 (IsPossible), but it does return a structure! Fix.
# this is proble not needed anymore

#=item IsPossibleToSyncObject()
#
#check if ticket or article is sychronized with a remote system depending on the WerbserviceID.
#
#    my $SyncInfo = $SolManCommonObject->IsPossibleToSyncObject(
#        WebserviceID   => 123,
#        ObjectType     => 'Ticket',    # or 'Article'
#        ObjectID       => 1234,
#        SyncKey        => GI_123_SolMan_IncidentGuid
#    );
#
#    $SyncInfo = {
#        Success          => 1     # or '' if error
#        RemoteTicketID   => 1234  # or '' if not synchronized
#        LockStateCounter => 5,
#    };
#=cut
#
#sub IsPossibleToSyncObject {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(WebserviceID ObjectType ObjectID SyncKey)) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "IsPossibleToSyncObject: Got no $Needed",
#            );
#            return;
#        }
#    }
#
#    # get Sync information
#    my $ObjectSyncInfo = $Self->GetSyncInfo(
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => $Param{ObjectType},
#        ObjectID     => $Param{ObjectID},
#        Key          => $Param{SyncKey},
#    );
#
#    # exit if cant get the sync info
#    if ( !$ObjectSyncInfo->{Success} ) {
#        $Self->{DebuggerObject}->Error(
#            Summary =>
#                "IsPossibleToSyncObject: Was not possible to get Object:$Param{ObjectType} "
#                . "sync info",
#        );
#        return {
#            Possible => 0,
#        };
#    }
#
#    # check if object is not sync
#    if ( $ObjectSyncInfo->{Success} && !$ObjectSyncInfo->{Value} ) {
#
#        # get the lock state
#        my $ObjectLockState = $Self->{ObjectLockStateObject}->ObjectLockStateGet(
#            WebserviceID => $Param{WebserviceID},
#            ObjectType   => $Param{ObjectType},
#            ObjectID     => $Param{ObjectID},
#        );
#
#        # check if attempts to sync are less than the maximum
#        # return that is possible and the sync attempts
#        if ( $ObjectLockState->{LockStateCounter} < $Self->{MaxSyncAttempts} ) {
#            return {
#                Possible         => 1,
#                LockStateCounter => $ObjectLockState->{LockStateCounter},
#            };
#        }
#
#        # otherwise return error
#        else {
#            $Self->{DebuggerObject}->Error(
#                Summary =>
#                    "IsPossibleToSyncObject: The Object:$Param{ObjectType} $Param{ObjectID} "
#                    . "reach the maximum number of attempts to synchronize current value is"
#                    . "$ObjectLockState->{LockStateCounter}/$Self->{MaxSyncAttempts}",
#            );
#            return {
#                Possible => 0,
#            };
#        }
#    }
#
#    # otherwise, the object is synced and return the remote value
#    $Self->{DebuggerObject}->Debug(
#        Summary =>
#            "IsPossibleToSyncObject: the Object:$Param{ObjectType} is already synchronized",
#    );
#    return {
#        Possible       => 0,
#        RemoteObjectID => $ObjectSyncInfo->{Value},
#    };
#}

#QA: SyncKey seems obsolete. What does 'Value' mean? Does it have to be passed?
# TODO This is probable not needed
#=item MarkArticleAsSynced()
#
#returns 1 if the operation was successfull.
#
#    my $Success = $SolManCommonObject->MarkArticleAsSynced(
#        WebserviceID    => 12,
#        ArticleID       => 4567,
#        SyncKey         => "GI_12_SolMan_IncidentGuid",
#        Value           => 1234,
#        UserID          => 1,
#    );
#
#    $Success = 1;      # or ''
#=cut
#
#sub MarkArticleAsSynced {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(WebserviceID ArticleID Key Value UserID)) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "GetArticleLockStatus: Got no $Needed",
#            );
#            return;
#        }
#    }
#
#    # set replicate flag
#    my $SuccessArticleFlagSet = $Self->{TicketObject}->ArticleFlagSet(
#        ArticleID => $Param{ArticleID},
#        Key       => $Param{SyncKey},
#        Value     => $Param{Value},
#        UserID    => $Param{UserID},      # apply to this user
#    );
#
#    # delete lock state
#    my $SuccessArticleLock = $Self->{ObjectLockStateObject}->ObjectLockStateDelete(
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => 'Article',
#        ObjectID     => $Param{ArticleID},
#    );
#    $Self->{DebuggerObject}->Info(
#        Summary =>
#            "MarkArticleAsSynced: Replicate Article state has been set",
#    );
#
#    return $SuccessArticleLock;
#}

#QA: improve POD. Do you mean 'replicated' or 'replicate' (='still to replicate')?
#QA: in the function name you use the term 'Synced' instead. Unify.
#QA: Key seems obsolete
#QA: What about Value?
# TODO This is probable not needed anymore

#=item MarkTicketAsSynced()
#writes the Replicate flag and delete the Attempt flag.
#returns 1 if the operation was successfull.
#
#    my $Success = $SolManCommonObject->MarkTicketAsSynced(
#        WebserviceID    => 12,
#        TicketID        => $Self->{TicketID},
#        Key             => "GI_12_SolMan_IncidentGuid",
#        Value           => 1234,
#        UserID          => 1,
#    );
#
#    $Success = 1;      # or ''
#=cut
#
#sub MarkTicketAsSynced {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(WebserviceID TicketID Key Value UserID)) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "MarkTicketAsSynced: Got no $Needed",
#            );
#            return;
#        }
#    }
#
#    my @Articles = $Self->{TicketObject}->ArticleGet(
#        TicketID => $Param{TicketID},
#    );
#
#    for my $Article (@Articles) {
#
#        # set replicate flag
#        my $ReplicateArticleStatus = $Self->MarkArticleAsSynced(
#            WebserviceID => $Param{WebserviceID},
#            ArticleID    => $Article->{ArticleID},
#            Key          => $Param{Key},
#            Value        => $Param{Value},
#            UserID       => $Param{UserID},
#        );
#    }
#
#    # set replicate flag
#    my $SuccessTicketFlagSet = $Self->{TicketObject}->TicketFlagSet(
#        TicketID => $Param{TicketID},
#        Key      => $Param{Key},
#        Value    => $Param{Value},
#        UserID   => $Param{UserID},     # apply to this user
#    );
#
#    # delete lock state
#    my $SuccessTicketLock = $Self->{ObjectLockStateObject}->ObjectLockStateDelete(
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => 'Ticket',
#        ObjectID     => $Param{TicketID},
#    );
#
#    $Self->{DebuggerObject}->Info(
#        Summary =>
#            "MarkTicketAsSynced: Replicate Ticket flag has been set",
#    );
#
#    return 1;
#}

#QA: see comments above.
#QA: Name? Reschedule or Replicate?
# TODO this is propably not needed anymore
#=item RescheduleReplicateTask()
#writes the Replicate flag and delete the Attempt flag.
#returns 1 if the operation was successfull.
#
#        Type         => 'GenericInterface',
#        Invoker      => 'ReplicateIncident',
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => 'Ticket',
#        ObjectID     => 123,
#        Data         => {                       # data for invoker
#            WebserviceID => $Param{WebserviceID},
#            TicketID     => $Param{TicketID},
#        },
#
#    $Success = 1;      # or ''
#=cut
#
#sub RescheduleReplicateTask {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(Type Invoker WebserviceID Data ObjectType LockState ObjectID )) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "RescheduleReplicateTask: Got no $Needed",
#            );
#            return;
#        }
#    }
#    my $IsPossibleToSyncObject = $Self->IsPossibleToSyncObject(
#        WebserviceID => $Param{WebserviceID},
#        ObjectType   => 'Object',
#        ObjectID     => $Param{ObjectID},
#    );
#    if ( $IsPossibleToSyncObject->{Possible} ) {
#        my $Success = $Self->ScheduleTask(
#            Type         => 'GenericInterface',
#            Invoker      => $Param{Invoker},
#            WebserviceID => $Param{WebserviceID},
#            Data         => $Param{Data},
#        );
#        $Self->{DebuggerObject}->Info(
#            Summary =>
#                "RescheduleReplicateTask: Reschedule $Param{Invoker}:$Param{ObjectType}:$Param{ObjectID}:$Success",
#        );
#        return $Success;
#    }
#
#    return;
#}

=item ScheduleTask()
schedule a new task.

    my $Success = $SolManCommonObject->ScheduleTask(
        Type         => 'GenericInterface',
        Invoker      => 'ReplicateIncident',
        WebserviceID => $Param{WebserviceID},
        Data         => {                       # data for invoker
            WebserviceID => $Param{WebserviceID},
            TicketID     => $Param{TicketID},
        },
    );

    $Success = 1;      # or ''
=cut

sub ScheduleTask {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Type Invoker WebserviceID Data)) {
        if ( !$Param{$Needed} ) {

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "ScheduleTask: Got no $Param{$Needed}",
            );
            return;
        }
    }

    my $TaskDelay = $Self->{ConfigObject}->Get('GenericInterface::Invoker::SolMan::TaskDelay') || 3;

    my $DueSystemTime = $Self->{TimeObject}->SystemTime() + $TaskDelay;
    my $DueTimeStamp  = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $DueSystemTime,
    );

    my $SchedulerObject = Kernel::Scheduler->new( %{$Self} );
    my $TaskID          = $SchedulerObject->TaskRegister(
        Type => $Param{Type},
        Data => {               # data for task register
            WebserviceID => $Param{WebserviceID},
            Invoker      => $Param{Invoker},

            Data => $Param{Data},
        },
        DueTime => $DueTimeStamp,
    );

    return $TaskID || 0;
}

#QA: name?
# TODO this is probable not needed anymore
#=item GetSyncInfo()
#check if ticket or article is sycrhonized with a remote system depending on the WerbserviceID.
#
#    my $SyncInfo = $SolManCommonObject->GetSyncInfo(
#        WebserviceID   => 123,
#        ObjectType     => 'Ticket',    # or 'Article'
#        Key            => "GI_123_SolMan_IncidentGuid",
#        ObjectID       => 1234,
#    );
#
#    $SyncInfo = {
#        Success  => 1                 # or '' if error
#        Value    => 1234              # or '' if not synchronized
#    };
#=cut
#
#sub GetSyncInfo {
#    my ( $Self, %Param ) = @_;
#
#    # check needed params
#    for my $Needed (qw(WebserviceID ObjectType ObjectID Key)) {
#        if ( !$Param{$Needed} ) {
#
#            # write in debug log
#            $Self->{DebuggerObject}->Error(
#                Summary => "GetSyncInfo: Got no $Needed",
#            );
#            return {
#                Success => 0
#            };
#        }
#    }
#
#    my %Flags;
#
#    # get ticket flags
#    if ( $Param{ObjectType} eq 'Ticket' ) {
#        %Flags = $Self->{TicketObject}->TicketFlagGet(
#            TicketID => $Param{ObjectID},
#            UserID   => 1,
#        );
#    }
#
#    # get article flags
#    elsif ( $Param{ObjectType} eq 'Article' ) {
#        %Flags = $Self->{TicketObject}->ArticleFlagGet(
#            ArticleID => $Param{ObjectID},
#            UserID    => 1,
#        );
#    }
#
#    # invalid ObjectType
#    else {
#
#        # write in debug log
#        $Self->{DebuggerObject}->Error(
#            Summary => "GetSyncInfo: Invalid ObjectType $Param{ObjectType}",
#        );
#        return {
#            Success => 0,
#        };
#    }
#
#    # return flag key if any
#    if ( $Flags{ $Param{Key} } ) {
#        return {
#            Success => 1,
#            Value   => $Flags{ $Param{Key} }
#        };
#    }
#
#    # otherwise since no erros found just return success
#    return {
#        Success => 1,
#    };
#}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload depending on the invoker
            TicketID => 123,                    # Mandatory
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '...',               # in case of error or undef
        Data            => {                    # data payload after Invoker or undef
            IctAdditionalInfos  => {},
            IctAttachments      => {},
            IctHead             => {},
            IctId               => '',  # type="n0:char32"
            IctPersons          => {},
            IctSapNotes         => {},
            IctSolutions        => {},
            IctStatements       => {},
            IctTimestamp        => '',  # type="n0:decimal15.0"
            IctUrls             => {},
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # to store any error messages
    my $ErrorMessage;

    # check needed params
    for my $Needed (qw( TicketID )) {
        if ( !IsStringWithData( $Param{Data}->{$Needed} ) ) {
            $ErrorMessage = "Self->{Invoker} PrepareRequest: Got no $Needed!";
            $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }

        $Self->{$Needed} = $Param{Data}->{$Needed};
    }

    # create Ticket Object
    $Self->{TicketID} = $Param{Data}->{TicketID};

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # compare TicketNumber from Param and from DB
    if ( $Self->{TicketID} ne $Ticket{TicketID} ) {
        $ErrorMessage = "$Self->{Invoker} PrepareRequest: Error getting Ticket Data";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # additional checks for CloseIncident Invoker
    if ( $Self->{Invoker} eq 'CloseIncident' ) {

        # we need the old ticket info
        if ( !IsHashRefWithData( $Param{Data}->{OldTicketData} ) ) {
            $ErrorMessage = "$Self->{Invoker} PrerareRequest: Invalid old ticket data";
            $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }

        my $OldTicketData = $Param{Data}->{OldTicketData};

        # return if this is not ticket close
        if ( $Ticket{StateType} ne 'closed' ) {
            $ErrorMessage = "$Self->{Invoker} PreprareRequest: This is ticket is not on a closed "
                . "state but on an \"$Ticket{StateType}\" state, CloseIncident Invoker Cancelled";
            $Self->{DebuggerObject}->Debug( Summary => $ErrorMessage );
            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }

        # return if ticket was already closed
        elsif ( $OldTicketData->{StateType} eq 'closed' ) {
            $ErrorMessage = "$Self->{Invoker} Prerpare Request: This is ticket was already in "
                . "closed state, CloseIncident Invoker Cancelled";
            $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    # get the lock state
    my $ObjectLockState = $Self->{ObjectLockStateObject}->ObjectLockStateGet(
        WebserviceID => $Self->{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Self->{TicketID},
    );

    # get current sync attempts
    my $SyncAttempts = $ObjectLockState->{LockStateCounter} || 0;

    # check current sync attempts and return if maximum has been reached
    if ( int($SyncAttempts) >= int( $Self->{MaxSyncAttempts} ) ) {
        $ErrorMessage = "$Self->{Invoker} PrepareRequest: The attempts to syncrhonize ticket "
            . "$Self->{TicketID} has reached or overpassed the maximum allowed "
            . "( $ObjectLockState->{LockStateCounter} / $Self->{MaxSyncAttempts} ), can't continue!";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # get ticket flags
    my %TicketFlags = $Self->{TicketObject}->TicketFlagGet(
        TicketID => $Self->{TicketID},
        UserID   => 1,
    );

    # get last sync timestamp
    my $LastSync = $TicketFlags{"GI_$Self->{WebserviceID}_SolMan_SyncTimestamp"} || 0;

    # check for sync information errors
    if ( !defined $LastSync ) {
        $ErrorMessage = "$Self->{Invoker} PrepareRequest: There was an error while trying to get "
            . "sync information for ticket $Self->{TicketID}, can't continue!";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # LastSync check for ReplicateIncident Invoker
    if ( $Self->{Invoker} eq 'ReplicateIncident' && $LastSync ne 0 ) {

        # get LastSync as human readeble timestamp
        my $LastSyncTimestamp = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $LastSync,
        );

        $ErrorMessage = "Self->{Invoker} PrepareRequest: The ticket $Self->{TicketID}, is already "
            . "replicated can't continue! " . $LastSyncTimestamp;

        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # LastSync check for CloseIncident Invoker
    if (
        ( $Self->{Invoker} eq 'CloseIncident' || $Self->{Invoker} eq 'AddInfo' )
        && $LastSync eq 0
        )
    {

        # schedule a new task to replicate insident and exit
        my $Success = $Self->ScheduleTask(
            Type         => 'GenericInterface',
            Invoker      => 'ReplicateIncident',
            WebserviceID => $Self->{WebserviceID},
            Data         => {
                WebserviceID => $Self->{WebserviceID},
                TicketID     => $Self->{TicketID},
            },
        );

        $ErrorMessage
            = "$Self->{Invoker} PrepareRequest: The ticket $Self->{TicketID}, needs to be "
            . "replicated on the remote system can't continue! ReplicateIncident Will be fired";

        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # set OwnerID
    $Self->{OwnerID} = $Ticket{OwnerID};

    #    # check all needed stuff about ticket
    #    # ( permissions, locked, etc . . . )

    # request Systems Guids

    # remote SystemGuid
    # get it from invoker config
    my $RemoteSystemGuid = $Self->GetRemoteSystemGuid();

    # otherwise trigger a request to get it from the remote system
    if ( !$RemoteSystemGuid ) {
        my $RequesterSystemGuid     = Kernel::GenericInterface::Requester->new( %{$Self} );
        my $RequestSolManSystemGuid = $RequesterSystemGuid->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'RequestSystemGuid',
            Data         => {},
        );

        # forward error message from Requestsystemguid if any and exit
        if ( !$RequestSolManSystemGuid->{Success} || $RequestSolManSystemGuid->{ErrorMessage} ) {
            return {
                Success      => 0,
                ErrorMessage => $RequestSolManSystemGuid->{ErrorMessage},
            };
        }

        # check SystemGuid data otherwise exit
        if ( !$RequestSolManSystemGuid->{Data}->{SystemGuid} ) {
            return {
                Success => 0,
                Data    => 'Can\'t get SystemGuid',
            };
        }

        $RemoteSystemGuid = $RequestSolManSystemGuid->{Data}->{SystemGuid};
    }

    # local SystemGuid
    my $LocalSystemGuid = $Self->GetSystemGuid();

    # IctAdditionalInfos
    my $IctAdditionalInfos = $Self->GetAditionalInfo();

    # IctPersons
    my $PersonsInfo = $Self->GetPersonsInfo(
        UserID         => $Ticket{OwnerID},
        CustomerUserID => $Ticket{CustomerUserID},
    );
    my $IctPersons;
    if ( IsArrayRefWithData( $PersonsInfo->{IctPersons} ) ) {
        $IctPersons = $PersonsInfo->{IctPersons};
    }

    # set Language from customer
    my $Language = $PersonsInfo->{Language} || 'en';

    # get ticket article IDs
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
        TicketID => $Self->{TicketID},
    );

    # IctAttachments
    my $IctAttachments;

    # IctStatements
    my $IctStatements;

    # check if ticket has articles
    if ( scalar @ArticleIDs ) {

        # get articles and attachments information in SolMan format
        my $ArticleInfo = $Self->GetArticlesInfo(
            TicketID => $Self->{TicketID},
            UserID   => $Ticket{OwnerID},
            LastSync => $LastSync,
            Language => $Language,
        );

        # set IctAttachments
        if ( IsArrayRefWithData( $ArticleInfo->{IctAttachments} ) ) {
            $IctAttachments = $ArticleInfo->{IctAttachments};
        }

        # set IctStatements
        if ( IsArrayRefWithData( $ArticleInfo->{IctStatements} ) ) {
            $IctStatements = $ArticleInfo->{IctStatements};
        }
    }

    # IctSapNotes
    my $IctSapNotes = $Self->GetSapNotesInfo();

    # IctSolutions
    my $IctSolutions = $Self->GetSolutionsInfo();

    # IctUrls
    my $IctUrls = $Self->GetUrlsInfo();

    # IctTimestamp
    my $IctTimestamp = $Self->{TimeObject}->CurrentTimestamp();
    $IctTimestamp =~ s{[:|\-|\s]}{}g;

    my $IctTimestampEnd = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime() + 1,
    );
    $IctTimestampEnd =~ s{[:|\-|\s]}{}g;

    my %RequestData = (
        IctAdditionalInfos => IsHashRefWithData($IctAdditionalInfos)
        ?
            $IctAdditionalInfos
        : '',
        IctAttachments => IsArrayRefWithData($IctAttachments)
        ?
            { item => $IctAttachments }
        : '',
        IctHead => {
            IncidentGuid     => $Ticket{TicketNumber},              # type="n0:char32"
            RequesterGuid    => $LocalSystemGuid,                   # type="n0:char32"
            ProviderGuid     => $RemoteSystemGuid,                  # type="n0:char32"
            AgentId          => $Ticket{OwnerID},                   # type="n0:char32"
            ReporterId       => $Ticket{CustomerUserID},            # type="n0:char32"
            ShortDescription => substr( $Ticket{Title}, 0, 40 ),    # type="n0:char40"
            Priority         => $Ticket{Priority},                  # type="n0:char32"
            Language         => $Language,                          # type="n0:char2"
            RequestedBegin   => $IctTimestamp,                      # type="n0:decimal15.0"
            RequestedEnd     => $IctTimestampEnd,                   # type="n0:decimal15.0"
            IctId            => $Ticket{TicketNumber},              # type="n0:char32"
        },
        IctId      => $Ticket{TicketNumber},                        # type="n0:char32"
        IctPersons => IsArrayRefWithData($IctPersons)
        ?
            { item => $IctPersons }
        : '',
        IctSapNotes => IsHashRefWithData($IctSapNotes)
        ?
            $IctSapNotes
        : '',
        IctSolutions => IsHashRefWithData($IctSolutions)
        ?
            $IctSolutions
        : '',
        IctStatements => IsArrayRefWithData($IctStatements)
        ?
            { item => $IctStatements }
        : '',
        IctTimestamp => $IctTimestamp,                # type="n0:decimal15.0"
        IctUrls      => IsHashRefWithData($IctUrls)
        ?
            $IctUrls
        : '',
    );

    return {
        Success => 1,
        Data    => \%RequestData,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            PersonMaps => {
                Item => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                }
            },
            PrdIctId => '0000000000001',
            Errors     => {
                item => {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',

                }
            }
        },
    );

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            PersonMaps => {
                Item => [
                    {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                    {
                        PersonId    => '0002',
                        PersonIdExt => '5051',
                    },
                ],
            }
            PrdIctId => '0000000000001',
            Errors     => {
                item => [
                    {
                        ErrorCode => '01'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                    {
                        ErrorCode => '04'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                ],
            }
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            PersonMaps => [
                {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                {
                    PersonId    => '0002',
                    PersonIdExt => '5051',
                },
            ],
            PrdIctId   => '0000000000001',
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage;

    # add sync attemp
    $Self->_AddSyncAttempt();

    # break early if response was not successfull
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => "Invoker $Self->{Invoker}: Response failure!",
        };
    }

    # to store data
    my $Data = $Param{Data};

    if ( !defined $Data->{Errors} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Invoker $Self->{Invoker}: Response failure!"
                . "An Error parameter was expected",
        );
    }

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        my $HandleErrorsResult = $Self->HandleErrors(
            Errors => $Data->{Errors},
        );

        return {
            Success => $HandleErrorsResult->{Success},
            Data    => \$HandleErrorsResult->{ErrorMessage},
        };
    }

    # we need a Incident Identifier from the remote system
    if ( !IsStringWithData( $Param{Data}->{PrdIctId} ) ) {
        $ErrorMessage = 'Got no PrdIctId!';

        # write in the debug log
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # response should have a person maps and it sould be empty
    if ( !defined $Param{Data}->{PersonMaps} ) {

        $ErrorMessage = 'Got no PersonMaps!';

        # write in the debug log
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # handle the person maps
    my $HandlePersonMaps = $Self->_HandlePersonMaps(
        PersonMaps => $Param{Data}->{PersonMaps},
    );

    # forward error if any
    if ( !$HandlePersonMaps->{Success} ) {
        return {
            Success      => 0,
            ErrorMessage => $HandlePersonMaps->{ErrorMessage},
        };
    }

    # create return data
    my %ReturnData = (
        PrdIctId   => $Param{Data}->{PrdIctId},
        PersonMaps => $HandlePersonMaps->{PersonMaps},
    );

    # set sync timestamp
    my $SyncFlag = $Self->_SetSyncTimestamp();

    # write in debug log
    $Self->{DebuggerObject}->Info(
        Summary => "$Self->{Invoker} return success",
        Data    => \%ReturnData,
    );

    return {
        Success => 1,
        Data    => \%ReturnData,
    };

}

sub _SetSyncTimestamp {
    my ( $Self, %Param ) = @_;

    my $TimeStamp = $Self->{TimeObject}->SystemTime();

    # set replicate flag
    my $SuccessTicketFlagSet = $Self->{TicketObject}->TicketFlagSet(
        TicketID => $Self->{TicketID},
        Key      => "GI_$Self->{WebserviceID}_SolMan_SyncTimestamp",
        Value    => $TimeStamp,
        UserID   => 1,
    );

    # delete lock state
    my $SuccessTicketLock = $Self->{ObjectLockStateObject}->ObjectLockStateDelete(
        WebserviceID => $Self->{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Self->{TicketID},
    );

    $Self->{DebuggerObject}->Info(
        Summary =>
            "SetSyncTimestamp: Replicate Ticket flag has been set",
    );

    # return succesful or not
    if ( !$SuccessTicketFlagSet || !$SuccessTicketLock ) {
        return 0;
    }
    return 1;
}

sub _AddSyncAttempt {
    my ( $Self, %Param ) = @_;

    # get lock state info
    my $TicketLockState = $Self->{ObjectLockStateObject}->ObjectLockStateGet(
        WebserviceID => $Self->{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Self->{TicketID},
    );

    # set new state counter
    my $SuccessTicketLock = $Self->{ObjectLockStateObject}->ObjectLockStateSet(
        WebserviceID     => $Self->{WebserviceID},
        ObjectType       => 'Ticket',
        ObjectID         => $Self->{TicketID},
        LockState        => $Self->{Invoker},
        LockStateCounter => ++$TicketLockState->{LockStateCounter},
    );

    $Self->{DebuggerObject}->Info(
        Summary =>
            "AddSyncAttempt: New lock state counter for ticket " .
            $Self->{TicketID} . " is " . $TicketLockState->{LockStateCounter},
    );

    return $SuccessTicketLock;

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.30 $ $Date: 2011-04-15 02:30:14 $

=cut
