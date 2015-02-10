# --
# Kernel/Modules/AdminServiceCenter.pm - to register the OTRS system
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminServiceCenter;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # Send Support Data Update
    # ------------------------------------------------------------ #

    if ( $Self->{Subaction} eq 'SendUpdate' ) {

        my %Result = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationUpdateSend();

        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
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

    my $SystemDataObject  = $Kernel::OM->Get('Kernel::System::SystemData');
    my $RegistrationState = $SystemDataObject->SystemDataGet(
        Key => 'Registration::State',
    ) || '';
    my $SupportDataSending = $SystemDataObject->SystemDataGet(
        Key => 'Registration::SupportDataSending',
    ) || 'No';

    my %SupportData = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect(
        UseCache => 1,
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$SupportData{Success} ) {
        $LayoutObject->Block(
            Name => 'SupportDataCollectionFailed',
            Data => \%SupportData,
        );
    }
    else {
        if (
            $RegistrationState ne 'registered'
            || $SupportDataSending ne 'Yes'
            )
        {
            $LayoutObject->Block(
                Name => 'NoteNotRegisteredNotSending',
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'NoteRegisteredSending',
            );
        }

        $LayoutObject->Block(
            Name => 'SupportData',
        );
        my ( $LastGroup, $LastSubGroup ) = ( '', '' );

        for my $Entry ( @{ $SupportData{Result} || [] } ) {

            $Entry->{StatusName} = $Kernel::System::SupportDataCollector::PluginBase::Status2Name{
                $Entry->{Status}
            };

            my ( $Group, $SubGroup ) = split( m{/}, $Entry->{DisplayPath} // '' );
            if ( $Group ne $LastGroup ) {
                $LayoutObject->Block(
                    Name => 'SupportDataGroup',
                    Data => {
                        Group => $Group,
                    },
                );
            }
            $LastGroup = $Group // '';

            if ( !$SubGroup || $SubGroup ne $LastSubGroup ) {
                $LayoutObject->Block(
                    Name => 'SupportDataRow',
                    Data => $Entry,
                );
            }

            if ( $SubGroup && $SubGroup ne $LastSubGroup ) {
                $LayoutObject->Block(
                    Name => 'SupportDataSubGroup',
                    Data => {
                        %{$Entry},
                        SubGroup => $SubGroup,
                    },
                );
            }
            $LastSubGroup = $SubGroup // '';

            if ( !$SubGroup ) {
                $LayoutObject->Block(
                    Name => 'SupportDataEntry',
                    Data => $Entry,
                );
                if ( defined $Entry->{Value} && length $Entry->{Value} ) {
                    if ( $Entry->{Value} =~ m{\n} ) {
                        $LayoutObject->Block(
                            Name => 'SupportDataEntryValueMultiLine',
                            Data => $Entry,
                        );
                    }
                    else {
                        $LayoutObject->Block(
                            Name => 'SupportDataEntryValueSingleLine',
                            Data => $Entry,
                        );
                    }
                }
            }
            else {

                $LayoutObject->Block(
                    Name => 'SupportDataSubEntry',
                    Data => $Entry,
                );

                if ( $Entry->{Message} ) {
                    $LayoutObject->Block(
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
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Self->{UserID},
        Cached => 1,
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get sender email address
    if ( $User{UserEmail} && $User{UserEmail} !~ /root\@localhost/ ) {
        $Param{SenderAddress} = $User{UserEmail};
    }
    elsif (

        $ConfigObject->Get('AdminEmail')
        && $ConfigObject->Get('AdminEmail') !~ /root\@localhost/
        && $ConfigObject->Get('AdminEmail') !~ /admin\@example.com/
        )
    {
        $Param{SenderAddress} = $ConfigObject->Get('AdminEmail');
    }
    $Param{SenderName} = $User{UserFirstname} . ' ' . $User{UserLastname};

    # verify if the email is valid, set it to empty string if not, this will be checked on client
    #    side
    if ( !$Kernel::OM->Get('Kernel::System::CheckItem')->CheckEmail( Address => $Param{SenderAddress} ) ) {
        $Param{SenderAddress} = '';
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminServiceCenterSupportDataCollector',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GenerateSupportBundle {
    my ( $Self, %Param ) = @_;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $RandomID   = $MainObject->GenerateRandomString(
        Length     => 8,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],
    );

    # remove any older file
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TempDir      = $ConfigObject->Get('TempDir') . '/SupportBundleDownloadCache';

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    $TempDir = $ConfigObject->Get('TempDir') . '/SupportBundleDownloadCache/' . $RandomID;

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    # remove all files
    my @ListOld = glob( $TempDir . '/*' );
    for my $File (@ListOld) {
        unlink $File;
    }

    # create the support bundle
    my $Result = $Kernel::OM->Get('Kernel::System::SupportBundleGenerator')->Generate();

    if ( !$Result->{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Result->{Message},
        );
    }
    else {

        # save support bundle in the FS (temporary)
        my $FileLocation = $MainObject->FileWrite(
            Location   => $TempDir . '/' . $Result->{Data}->{Filename},
            Content    => $Result->{Data}->{Filecontent},
            Mode       => 'binmode',
            Type       => 'Local',
            Permission => '644',
        );
    }

    my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            Success  => $Result->{Success},
            Message  => $Result->{Message} || '',
            Filesize => $Result->{Data}->{Filesize} || '',
            Filename => $Result->{Data}->{Filename} || '',
            RandomID => $RandomID,
        },
    );

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
        ContentType => 'text/html',
        Content     => $JSONString,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _DownloadSupportBundle {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Filename     = $ParamObject->GetParam( Param => 'Filename' ) || '';
    my $RandomID     = $ParamObject->GetParam( Param => 'RandomID' ) || '';

    if ( !$Filename ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need Filename!",
        );
    }

    my $TempDir  = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . '/SupportBundleDownloadCache/' . $RandomID;
    my $Location = $TempDir . '/' . $Filename;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Content    = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
        Result   => 'SCALAR',
    );

    if ( !$Content ) {
        return $LayoutObject->ErrorScreen(
            Message => "File $Location could not be read!",
        );
    }

    my $Success = $MainObject->FileDelete(
        Location => $Location,
        Type     => 'Local',
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "File $Location could not be deleted!",
        );
    }

    rmdir $TempDir;

    return $LayoutObject->Attachment(
        Filename    => $Filename,
        ContentType => 'application/octet-stream; charset=' . $LayoutObject->{UserCharset},
        Content     => $$Content,
    );
}

sub _SendSupportBundle {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LogObject   = $Kernel::OM->Get('Kernel::System::Log');
    my $Filename    = $ParamObject->GetParam( Param => 'Filename' ) || '';
    my $RandomID    = $ParamObject->GetParam( Param => 'RandomID' ) || '';
    my $Success;

    if ($Filename) {

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        my $TempDir = $ConfigObject->Get('TempDir')
            . '/SupportBundleDownloadCache/'
            . $RandomID;
        my $Location = $TempDir . '/' . $Filename;

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        my $Content = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        if ($Content) {

            $Success = $MainObject->FileDelete(
                Location => $Location,
                Type     => 'Local',
            );

            if ( !$Success ) {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "File $Location could not be deleted!",
                );
            }

            rmdir $TempDir;

            my %RegistrationInfo = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationDataGet(
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
            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $Self->{UserID},
                Cached => 1,
            );

            # get sender email address
            my $SenderAddress = '';
            if ( $User{UserEmail} && $User{UserEmail} !~ /root\@localhost/ ) {
                $SenderAddress = $User{UserEmail};
            }
            elsif (
                $ConfigObject->Get('AdminEmail')
                && $ConfigObject->Get('AdminEmail') !~ /root\@localhost/
                && $ConfigObject->Get('AdminEmail') !~ /admin\@example.com/
                )
            {
                $SenderAddress = $ConfigObject->Get('AdminEmail');
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

            my ( $HeadRef, $BodyRef ) = $Kernel::OM->Get('Kernel::System::Email')->Send(
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
            $LogObject->Log(
                Priority => 'error',
                Message  => "$Filename could not be read!",
            );
        }
    }
    else {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Need Filename",
        );
    }

    my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            Success => $Success || '',
        },
    );

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
        ContentType => 'text/html',
        Content     => $JSONString,
        Type        => 'inline',
        NoCache     => 1,
    );
}
1;
