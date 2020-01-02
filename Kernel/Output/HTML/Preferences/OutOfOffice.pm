# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::OutOfOffice;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub Param {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @Params;
    if ( $Param{UserData}->{OutOfOffice} ) {
        $Param{OutOfOfficeOn} = 'checked="checked"';
    }
    else {
        $Param{OutOfOfficeOff} = 'checked="checked"';
    }
    $Param{OptionStart} = $LayoutObject->BuildDateSelection(
        Format                 => 'DateInputFormat',
        Area                   => 'no',
        Prefix                 => 'OutOfOfficeStart',
        OutOfOfficeStartYear   => $Param{UserData}->{OutOfOfficeStartYear},
        OutOfOfficeStartMonth  => $Param{UserData}->{OutOfOfficeStartMonth},
        OutOfOfficeStartDay    => $Param{UserData}->{OutOfOfficeStartDay},
        OutOfOfficeStartHour   => 0,
        OutOfOfficeStartMinute => 0,
        YearPeriodPast         => 1,
        YearPeriodFuture       => 5,
        Validate               => 1,

        # Do not convert to local time zone, show stored date as-is
        #   (please see bug#12471 for more information).
        OverrideTimeZone => 1,
    );
    $Param{OptionEnd} = $LayoutObject->BuildDateSelection(
        Format               => 'DateInputFormat',
        Area                 => 'no',
        DiffTime             => 60 * 60 * 24 * 1,
        Prefix               => 'OutOfOfficeEnd',
        OutOfOfficeEndYear   => $Param{UserData}->{OutOfOfficeEndYear},
        OutOfOfficeEndMonth  => $Param{UserData}->{OutOfOfficeEndMonth},
        OutOfOfficeEndDay    => $Param{UserData}->{OutOfOfficeEndDay},
        OutOfOfficeEndHour   => 0,
        OutOfOfficeEndMinute => 0,
        YearPeriodPast       => 1,
        YearPeriodFuture     => 5,
        Validate             => 1,

        # Do not convert to local time zone, show stored date as-is
        #   (please see bug#12471 for more information).
        OverrideTimeZone => 1,
    );

    push(
        @Params,
        {
            %Param,
            Block => 'OutOfOffice',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    #  get needed objects
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $SessionObject  = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    for my $Key (
        qw(OutOfOffice OutOfOfficeStartYear OutOfOfficeStartMonth OutOfOfficeStartDay OutOfOfficeEndYear OutOfOfficeEndMonth OutOfOfficeEndDay)
        )
    {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || '';
    }

    my $OOOStartDTObject = $Self->_GetOutOfOfficeDateTimeObject(
        Type => 'Start',
        Data => \%Param
    );
    my $OOOEndDTObject = $Self->_GetOutOfOfficeDateTimeObject(
        Type => 'End',
        Data => \%Param
    );

    if ( !$OOOStartDTObject || !$OOOEndDTObject ) {
        return 1;
    }
    elsif ( $OOOStartDTObject <= $OOOEndDTObject ) {
        my $SessionID = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{SessionID};
        for my $Key (
            qw(OutOfOffice OutOfOfficeStartYear OutOfOfficeStartMonth OutOfOfficeStartDay OutOfOfficeEndYear OutOfOfficeEndMonth OutOfOfficeEndDay)
            )
        {
            if ( defined $Param{$Key} ) {

                # pref update db
                if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                    $UserObject->SetPreferences(
                        UserID => $Param{UserData}->{UserID},
                        Key    => $Key,
                        Value  => $Param{$Key},
                    );
                }

                # update SessionID
                if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                    $SessionObject->UpdateSessionID(
                        SessionID => $SessionID,
                        Key       => $Key,
                        Value     => $Param{$Key},
                    );
                }
            }
        }

        # also update the lastname to remove out of office message
        if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
            my %User = $UserObject->GetUserData( UserID => $Self->{UserID} );

            $SessionObject->UpdateSessionID(
                SessionID => $SessionID,
                Key       => 'UserLastname',
                Value     => $User{UserLastname},
            );
        }

        $Self->{Message} = Translatable('Preferences updated successfully!');
    }
    else {
        $Self->{Error} = $LanguageObject->Translate('Please specify an end date that is after the start date.');
        return;
    }

    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

sub _GetOutOfOfficeDateTimeObject {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type};
    my $Data = $Param{Data};

    my $Year  = $Data->{"OutOfOffice${Type}Year"};
    my $Month = $Data->{"OutOfOffice${Type}Month"};
    my $Day   = $Data->{"OutOfOffice${Type}Day"};

    if ( $Year && $Month && $Day ) {
        my $DTString = sprintf(
            '%s-%s-%s %s',
            $Year,
            $Month,
            $Day,
            ( $Type eq 'End' ? '23:59:59' : '00:00:00' ),
        );

        return $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $DTString,
            },
        );
    }

    return;
}

1;
