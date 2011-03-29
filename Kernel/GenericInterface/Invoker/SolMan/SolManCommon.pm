# --
# Kernel/GenericInterface/Operation/SolManCommon.pm - SolMan common invoker functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SolManCommon.pm,v 1.8 2011-03-29 18:59:28 cr Exp $
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

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Common - common operation functions

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
        UserID => $Param{OwnerID},
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
this functions is not yet implemente, returns an empty hash
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

    return \%IctAdditionalInfos;
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

$Revision: 1.8 $ $Date: 2011-03-29 18:59:28 $

=cut
