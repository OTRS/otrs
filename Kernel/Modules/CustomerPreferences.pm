# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::CustomerPreferences;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # ------------------------------------------------------------ #
    # update preferences
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck( Type => 'Customer' );

        # check group param
        my $Group = $ParamObject->GetParam( Param => 'Group' ) || '';
        if ( !$Group ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Param Group is required!'),
            );
        }

        # check preferences setting
        my %Preferences = %{ $Kernel::OM->Get('Kernel::Config')->Get('CustomerPreferencesGroups') };
        if ( !$Preferences{$Group} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No such config for %s', $Group ),
            );
        }

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet( User => $Self->{UserLogin} );
        my $Module   = $Preferences{$Group}->{Module};
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            UserObject => $UserObject,
            ConfigItem => $Preferences{$Group},
            Debug      => $Self->{Debug},
        );

        # log loaded module
        if ( $Self->{Debug} > 1 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        my @Params = $Object->Param( UserData => \%UserData );
        my %GetParam;
        for my $ParamItem (@Params) {
            my @Array = $ParamObject->GetArray(
                Param => $ParamItem->{Name},
                Raw   => $ParamItem->{Raw} || 0,
            );
            $GetParam{ $ParamItem->{Name} } = \@Array;
        }
        my $Message  = '';
        my $Priority = '';
        if (
            $Object->Run(
                GetParam => \%GetParam,
                UserData => \%UserData
            )
            )
        {
            $Message = $Object->Message();
        }
        else {
            $Priority = 'Error';
            $Message  = $Object->Error();
        }

        # check redirect
        my $RedirectURL = $ParamObject->GetParam( Param => 'RedirectURL' );
        if ($RedirectURL) {
            return $LayoutObject->Redirect(
                OP => $RedirectURL,
            );
        }

        # redirect
        return $LayoutObject->Redirect(
            OP => "Action=CustomerPreferences;Priority=$Priority;Message=$Message",
        );
    }

    # ------------------------------------------------------------ #
    # show preferences
    # ------------------------------------------------------------ #
    else {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Preferences'),
        );
        $Output .= $LayoutObject->CustomerNavigationBar();

        # get param
        my $Message  = $ParamObject->GetParam( Param => 'Message' )  || '';
        my $Priority = $ParamObject->GetParam( Param => 'Priority' ) || '';

        # add notification
        if ( $Message && $Priority eq 'Error' ) {
            $Output .= $LayoutObject->Notify(
                Priority => $Priority,
                Info     => $Message,
            );
        }
        elsif ($Message) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Success',
                Info     => $Message,
            );
        }

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet( User => $Self->{UserLogin} );
        $Output .= $Self->CustomerPreferencesForm( UserData => \%UserData );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
}

sub CustomerPreferencesForm {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Body',
        Data => \%Param,
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my %Data;
    my %Preferences = %{ $ConfigObject->Get('CustomerPreferencesGroups') };

    GROUP:
    for my $Group ( sort keys %Preferences ) {

        next GROUP if !$Group;

        my $PreferencesGroup = $Preferences{$Group};

        next GROUP if !$PreferencesGroup;
        next GROUP if ref $PreferencesGroup ne 'HASH';

        $PreferencesGroup->{Prio} ||= 9999;

        if ( $Data{ $PreferencesGroup->{Prio} } ) {

            COUNT:
            for ( 1 .. 151 ) {

                $PreferencesGroup->{Prio}++;

                if ( !$Data{ $PreferencesGroup->{Prio} } ) {
                    $Data{ $PreferencesGroup->{Prio} } = $Group;
                    last COUNT;
                }
            }
        }

        $Data{ $PreferencesGroup->{Prio} } = $Group;
    }

    # sort
    for my $Key ( sort keys %Data ) {
        $Data{ sprintf( "%07d", $Key ) } = $Data{$Key};
        delete $Data{$Key};
    }

    # show each preferences setting
    PRIO:
    for my $Prio ( sort keys %Data ) {
        my $Group = $Data{$Prio};
        next PRIO if !$ConfigObject->{CustomerPreferencesGroups}->{$Group};

        my %Preference = %{ $ConfigObject->{CustomerPreferencesGroups}->{$Group} };
        next PRIO if !$Preference{Active};

        # load module
        my $Module = $Preference{Module} || 'Kernel::Output::HTML::CustomerPreferencesGeneric';
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            UserObject => $Kernel::OM->Get('Kernel::System::CustomerUser'),
            ConfigItem => $Preferences{$Group},
            Debug      => $Self->{Debug},
        );
        my @Params = $Object->Param( UserData => $Param{UserData} );
        next PRIO if !@Params;

        # show item
        $LayoutObject->Block(
            Name => 'Item',
            Data => {
                Group => $Group,
                %Preference,
            },
        );
        for my $ParamItem (@Params) {
            my %BuildSelectionParams = (
                %Preference,
                %{$ParamItem},
            );
            $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );

            if ( ref $ParamItem->{Data} eq 'HASH' || ref $Preference{Data} eq 'HASH' ) {
                $ParamItem->{Option} = $LayoutObject->BuildSelection(
                    %BuildSelectionParams
                );
            }
            $LayoutObject->Block(
                Name => 'Block',
                Data => { %Preference, %{$ParamItem}, },
            );
            $LayoutObject->Block(
                Name => $ParamItem->{Block} || $Preference{Block} || 'Option',
                Data => { %Preference, %{$ParamItem}, },
            );
        }
    }

    # create & return output
    return $LayoutObject->Output(
        TemplateFile => 'CustomerPreferences',
        Data         => \%Param
    );
}

1;
