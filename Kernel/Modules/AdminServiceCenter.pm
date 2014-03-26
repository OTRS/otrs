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

use Kernel::System::Registration;
use Kernel::System::SystemData;
use Kernel::System::SupportDataCollector;
use Kernel::System::SupportDataCollector::PluginBase;

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
    $Self->{SupportDataCollectorObject} = Kernel::System::SupportDataCollector->new(%Param);

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

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminServiceCenterSupportDataCollector',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
