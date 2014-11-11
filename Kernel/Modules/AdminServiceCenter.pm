# --
# Kernel/Modules/AdminServiceCenter.pm - to register the OTRS system
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminServiceCenter;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::Email;
use Kernel::System::JSON;
use Kernel::System::Registration;
use Kernel::System::SystemData;
use Kernel::System::SupportBundleGenerator;
use Kernel::System::SupportDataCollector;
use Kernel::System::SupportDataCollector::PluginBase;
use Kernel::System::User;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject LayoutObject ConfigObject LogObject SessionObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{RegistrationObject} = Kernel::System::Registration->new(%Param);
    $Self->{SystemDataObject}   = Kernel::System::SystemData->new(%Param);
    $Self->{RegistrationState}  = $Self->{SystemDataObject}->SystemDataGet(
        Key => 'Registration::State',
    ) || '';
    $Self->{SupportDataSending} = $Self->{SystemDataObject}->SystemDataGet(
        Key => 'Registration::SupportDataSending',
    ) || 'No';
    $Self->{SupportDataCollectorObject}   = Kernel::System::SupportDataCollector->new(%Param);
    $Self->{SupportBundleGeneratorObject} = Kernel::System::SupportBundleGenerator->new(%Param);
    $Self->{JSONObject}                   = Kernel::System::JSON->new(%Param);
    $Self->{UserObject}                   = Kernel::System::User->new(%Param);
    $Self->{EmailObject}                  = Kernel::System::Email->new(%Param);
    $Self->{CheckItemObject}              = Kernel::System::CheckItem->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # Send Support Data Update
    # ------------------------------------------------------------ #

    if ( $Self->{Subaction} eq 'SendUpdate' ) {

        my %Result = $Self->{RegistrationObject}->RegistrationUpdateSend();

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => $Result{Success},
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'GenerateSupportBundle' ) {
        return $Self->_GenerateSupportBundle();
    }
    elsif ( $Self->{Subaction} eq 'DownloadSupportBundle' ) {
        return $Self->_DownloadSupportBundle();
    }
    elsif ( $Self->{Subaction} eq 'SendSupportBundle' ) {
        return $Self->_SendSupportBundle();
    }
    return $Self->_SupportDataCollectorView(%Param);
}

sub _SupportDataCollectorView {
    my ( $Self, %Param ) = @_;

    my %SupportData = $Self->{SupportDataCollectorObject}->Collect(
        UseCache => 1,
    );

    if ( !$SupportData{Success} ) {
        $Self->{LayoutObject}->Block(
            Name => 'SupportDataCollectionFailed',
            Data => \%SupportData,
        );
    }
    else {
        if (
            $Self->{RegistrationState} ne 'registered'
            || $Self->{SupportDataSending} ne 'Yes'
            )
        {

            $Self->{LayoutObject}->Block(
                Name => 'NoteNotRegisteredNotSending',
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoteRegisteredSending',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'SupportData',
        );
        my ( $LastGroup, $LastSubGroup ) = ( '', '' );

        for my $Entry ( @{ $SupportData{Result} || [] } ) {

            $Entry->{StatusName} = $Kernel::System::SupportDataCollector::PluginBase::Status2Name{
                $Entry->{Status}
            };

            my ( $Group, $SubGroup ) = split( m{/}, $Entry->{DisplayPath} // '' );
            if ( $Group ne $LastGroup ) {
                $Self->{LayoutObject}->Block(
                    Name => 'SupportDataGroup',
                    Data => {
                        Group => $Group,
                    },
                );
            }
            $LastGroup = $Group // '';

            if ( !$SubGroup || $SubGroup ne $LastSubGroup ) {
                $Self->{LayoutObject}->Block(
                    Name => 'SupportDataRow',
                    Data => $Entry,
                );
            }

            if ( $SubGroup && $SubGroup ne $LastSubGroup ) {
                $Self->{LayoutObject}->Block(
                    Name => 'SupportDataSubGroup',
                    Data => {
                        %{$Entry},
                        SubGroup => $SubGroup,
                    },
                );
            }
            $LastSubGroup = $SubGroup // '';

            if ( !$SubGroup ) {
                $Self->{LayoutObject}->Block(
                    Name => 'SupportDataEntry',
                    Data => $Entry,
                );
                if ( defined $Entry->{Value} && length $Entry->{Value} ) {
                    if ( $Entry->{Value} =~ m{\n} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'SupportDataEntryValueMultiLine',
                            Data => $Entry,
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'SupportDataEntryValueSingleLine',
                            Data => $Entry,
                        );
                    }
                }
            }
            else {

                $Self->{LayoutObject}->Block(
                    Name => 'SupportDataSubEntry',
                    Data => $Entry,
                );

                if ( $Entry->{Message} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'SupportDataSubEntryMessage',
                        Data => {
                            Message => $Entry->{Message},
                        },
                    );
                }
            }
        }
    }

    # get user data
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Self->{UserID},
        Cached => 1,
    );

    # get sender email address
    if ( $User{UserEmail} && $User{UserEmail} !~ /root\@localhost/ ) {
        $Param{SenderAddress} = $User{UserEmail};
    }
    elsif (
        $Self->{ConfigObject}->Get('AdminEmail')
        && $Self->{ConfigObject}->Get('AdminEmail') !~ /root\@localhost/
        && $Self->{ConfigObject}->Get('AdminEmail') !~ /admin\@example.com/
        )
    {
        $Param{SenderAddress} = $Self->{ConfigObject}->Get('AdminEmail');
    }
    $Param{SenderName} = $User{UserFirstname} . ' ' . $User{UserLastname};

    # verify if the email is valid, set it to empty string if not, this will be checked on client
    #    side
    if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Param{SenderAddress} ) ) {
        $Param{SenderAddress} = '';
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminServiceCenterSupportDataCollector',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GenerateSupportBundle {
    my ( $Self, %Param ) = @_;

    my $RandomID = $Self->{MainObject}->GenerateRandomString(
        Length     => 8,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],
    );

    # remove any older file
    my $TempDir = $Self->{ConfigObject}->Get('TempDir') . '/SupportBundleDownloadCache';

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    $TempDir = $Self->{ConfigObject}->Get('TempDir') . '/SupportBundleDownloadCache/' . $RandomID;

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    # remove all files
    my @ListOld = glob( $TempDir . '/*' );
    for my $File (@ListOld) {
        unlink $File;
    }

    # create the support bundle
    my $Result = $Self->{SupportBundleGeneratorObject}->Generate();

    if ( !$Result->{Success} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->{Message},
        );
    }
    else {

        # save support bundle in the FS (temporary)
        my $FileLocation = $Self->{MainObject}->FileWrite(
            Location   => $TempDir . '/' . $Result->{Data}->{Filename},
            Content    => $Result->{Data}->{Filecontent},
            Mode       => 'binmode',
            Type       => 'Local',
            Permission => '644',
        );
    }

    my $JSONString = $Self->{JSONObject}->Encode(
        Data => {
            Success  => $Result->{Success},
            Message  => $Result->{Message} || '',
            Filesize => $Result->{Data}->{Filesize} || '',
            Filename => $Result->{Data}->{Filename} || '',
            RandomID => $RandomID,
        },
    );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html',
        Content     => $JSONString,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _DownloadSupportBundle {
    my ( $Self, %Param ) = @_;

    my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';
    my $RandomID = $Self->{ParamObject}->GetParam( Param => 'RandomID' ) || '';

    if ( !$Filename ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need Filename!",
        );
    }

    my $TempDir  = $Self->{ConfigObject}->Get('TempDir') . '/SupportBundleDownloadCache/' . $RandomID;
    my $Location = $TempDir . '/' . $Filename;

    my $Content = $Self->{MainObject}->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
        Result   => 'SCALAR',
    );

    if ( !$Content ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "File $Location could not be read!",
        );
    }

    my $Success = $Self->{MainObject}->FileDelete(
        Location => $Location,
        Type     => 'Local',
    );

    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "File $Location could not be deleted!",
        );
    }

    rmdir $TempDir;

    return $Self->{LayoutObject}->Attachment(
        Filename    => $Filename,
        ContentType => 'application/octet-stream; charset=' . $Self->{LayoutObject}->{UserCharset},
        Content     => $$Content,
    );
}

sub _SendSupportBundle {
    my ( $Self, %Param ) = @_;

    my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';
    my $RandomID = $Self->{ParamObject}->GetParam( Param => 'RandomID' ) || '';

    my $Success;
    if ($Filename) {

        my $TempDir = $Self->{ConfigObject}->Get('TempDir')
            . '/SupportBundleDownloadCache/'
            . $RandomID;
        my $Location = $TempDir . '/' . $Filename;

        my $Content = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        if ($Content) {

            $Success = $Self->{MainObject}->FileDelete(
                Location => $Location,
                Type     => 'Local',
            );

            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "File $Location could not be deleted!",
                );
            }

            rmdir $TempDir;

            my %RegistrationInfo = $Self->{RegistrationObject}->RegistrationDataGet(
                Extended => 1,
            );

            my %Data;

            if (%RegistrationInfo) {
                my $State = $RegistrationInfo{State} || '';
                if ( $State && lc $State eq 'registered' ) {
                    $State = 'active';
                }

                %Data = (
                    %{ $RegistrationInfo{System} },
                    State              => $State,
                    APIVersion         => $RegistrationInfo{APIVersion},
                    APIKey             => $RegistrationInfo{APIKey},
                    LastUpdateID       => $RegistrationInfo{LastUpdateID},
                    RegistrationKey    => $RegistrationInfo{UniqueID},
                    SupportDataSending => $RegistrationInfo{SupportDataSending},
                    Type               => $RegistrationInfo{Type},
                    Description        => $RegistrationInfo{Description},
                );
            }

            # get user data
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Self->{UserID},
                Cached => 1,
            );

            # get sender email address
            my $SenderAddress = '';
            if ( $User{UserEmail} && $User{UserEmail} !~ /root\@localhost/ ) {
                $SenderAddress = $User{UserEmail};
            }
            elsif (
                $Self->{ConfigObject}->Get('AdminEmail')
                && $Self->{ConfigObject}->Get('AdminEmail') !~ /root\@localhost/
                && $Self->{ConfigObject}->Get('AdminEmail') !~ /admin\@example.com/
                )
            {
                $SenderAddress = $Self->{ConfigObject}->Get('AdminEmail');
            }

            my $SenderName = $User{UserFirstname} . ' ' . $User{UserLastname};

            my $Body;

            $Body = "Sender:$SenderName\n";
            $Body .= "Email:$SenderAddress\n";

            if (%Data) {
                for my $Key ( sort keys %Data ) {
                    my $ItemValue = $Data{$Key} || '';
                    $Body .= "$Key:$ItemValue\n";
                }
            }
            else {
                $Body .= "Not registered\n";
            }

            my ( $HeadRef, $BodyRef ) = $Self->{EmailObject}->Send(
                From          => $SenderAddress,
                To            => 'SupportBundle@otrs.com',
                Subject       => 'Support::Bundle::Email',
                Type          => 'text/plain',
                Charset       => 'utf-8',
                Body          => $Body,
                CustomHeaders => {
                    'X-OTRS-RegistrationKey' => $Data{'RegistrationKey'} || 'Not registered',
                },
                Attachment => [
                    {
                        Filename    => $Filename,
                        Content     => $Content,
                        ContentType => 'application/octet-stream',
                        Disposition => 'attachment',
                    },
                ],
            );

            if ( $HeadRef && $BodyRef ) {
                $Success = 1;
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Filename could not be read!",
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Filename",
        );
    }

    my $JSONString = $Self->{JSONObject}->Encode(
        Data => {
            Success => $Success || '',
        },
    );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html',
        Content     => $JSONString,
        Type        => 'inline',
        NoCache     => 1,
    );
}
1;
