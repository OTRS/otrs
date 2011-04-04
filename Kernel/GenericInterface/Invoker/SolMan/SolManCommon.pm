# --
# Kernel/GenericInterface/Invoker/SolMan/SolManCommon.pm - SolMan common invoker functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SolManCommon.pm,v 1.17 2011-04-04 19:26:18 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::SolManCommon;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::System::GenericInterface::Webservice;
use MIME::Base64;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::SolManCommon - common invoker functions

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
    use Kernel::GenericInterface::Invoker::SolMan::SolManCommon;

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
    my $SolManCommonObject = Kernel::GenericInterface::Invoker::SolMan::SolManCommon->new(
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
        qw(
        DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject
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
    for my $Needed (qw(Errors Invoker)) {
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
        Summary => "$Param{Invoker} return error",
        Data    => $ErrorMessage,
    );

    return {
        Success      => 1,
        ErrorMessage => $ErrorMessage,
    };

}

=item HandlePersonMaps()
Process person maps from the remote server, the result will always be an array ref

    my $Result = $SolManCommonObject->HandlePersonMaps(
        PersonMaps     => {
            item => {
                PersonId    => '0001',
                PersonIdExt => '5050',
            }
        }
    );

    my $Result = $SolManCommonObject->HandlePersonMaps(
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

sub HandlePersonMaps {
    my ( $Self, %Param ) = @_;

    # check for needed objects
    for my $Needed (qw(PersonMaps Invoker)) {
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
                        Summary => "$Param{Invoker} return error",
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
                Summary => "$Param{Invoker} return error",
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
            Summary => "$Param{Invoker} return error",
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

    #TODO Implement if needed

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

    #TODO Implement if needed

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

    #TODO Implement if needed

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

    #TODO Implement if needed

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
        TicketID => 67
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

    my $ArticleID = $Param{ArticleID} || '';
    my @Articles = $Self->{TicketObject}->ArticleGet(
        TicketID => $Param{TicketID},
    );

    my @IctAttachments;
    my @IctStatements;
    for my $Article (@Articles) {
        next
            if (
            $ArticleID ne '' &&
            $Article->{ArticleID} ne $ArticleID
            );
        my $CreateTime = $Article->{Created};
        $CreateTime =~ s{[:|\-|\s]}{}g;

        # IctStatements
        my %IctStatement = (
            TextType => 'SU99',    # type="n0:char32"
            Texts    => {          # type="tns:IctTexts"
                item => [
                    $Article->{Subject} || '',
                    "\n",
                    $Article->{Body} || '',
                    ]
            },
            Timestamp => $CreateTime,         # type="n0:decimal15.0"
            PersonId  => $Param{UserID},      # type="n0:char32"
            Language  => $Param{Language},    # type="n0:char2"
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

    my $RemoteSystemGuid = $SolManCommonObject->GetRemoteSystemGuid(
        WebserviceID => 123,
        Invoker      => 'RepliateIncident',
    );

    $RemoteSystemGuid = '123ABC123ABC123ABC123ABC123ABC12';  # or ''
=cut

sub GetRemoteSystemGuid {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(WebserviceID Invoker)) {
        if ( !$Param{$Needed} ) {

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "GetRemoteSystemGuid: Got no $Param{$Needed}",
            );
            return;
        }
    }

    # get webservice configuration
    my $Webservice = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Param{WebserviceID},
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
        !IsHashRefWithData( $Webservice->{Config}->{Requester}->{Invoker}->{ $Param{Invoker} } )
        )
    {
        $Self->{DebuggerObject}->Error(
            Summary => "GetRemoteSystemGuid: Invoker configuration for $Param{Invoker} is invalid",
        );
        return;
    }

    # get invoker configuration
    my $Invoker = $Webservice->{Config}->{Requester}->{Invoker}->{ $Param{Invoker} };

    my $SystemGuid;

    # check if invoker has SystemGuid defined in its configuration and return it, otherwise
    # return empty
    if ( $Invoker->{SystemGuid} ) {
        $SystemGuid = $Invoker->{SystemGuid};

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
            $Config->{Requester}->{Invoker}->{$Invoker}->{SystemGuid} = $Param{SystemGuid};
        }
    }

    # otherwise set SystemGuid to especific invoker
    else {
        $Config->{Requester}->{Invoker}->{ $Param{Invoker} }->{SystemGuid} = $Param{SystemGuid};
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
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.17 $ $Date: 2011-04-04 19:26:18 $

=cut
