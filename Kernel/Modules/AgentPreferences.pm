# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentPreferences;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    # ------------------------------------------------------------ #
    # update preferences via AJAX
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'UpdateAJAX' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Key   = $ParamObject->GetParam( Param => 'Key' );
        my $Value = $ParamObject->GetParam( Param => 'Value' );

        # update preferences
        my $Success = $UserObject->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Key,
            Value  => $Value,
        );

        # update session
        if ($Success) {
            $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Key,
                Value     => $Value,
            );
        }
        my $JSON = $LayoutObject->JSONEncode(
            Data => $Success,
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # update preferences
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Message  = '';
        my $Priority = '';

        # check group param
        my @Groups = $ParamObject->GetArray( Param => 'Group' );
        if ( !@Groups ) {
            return $LayoutObject->ErrorScreen( Message => 'Param Group is required!' );
        }

        for my $Group (@Groups) {

            # check preferences setting
            my %Preferences = %{ $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups') };
            if ( !$Preferences{$Group} ) {
                return $LayoutObject->ErrorScreen( Message => "No such config for $Group" );
            }

            # get user data
            my %UserData = $UserObject->GetUserData( UserID => $Self->{UserID} );
            my $Module = $Preferences{$Group}->{Module};
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                return $LayoutObject->FatalError();
            }

            my $Object = $Module->new(
                %{$Self},
                UserObject => $UserObject,
                ConfigItem => $Preferences{$Group},
                Debug      => $Self->{Debug},
            );
            my @Params = $Object->Param( UserData => \%UserData );
            my %GetParam;
            for my $ParamItem (@Params) {
                my @Array = $ParamObject->GetArray(
                    Param => $ParamItem->{Name},
                    Raw   => $ParamItem->{Raw} || 0,
                );
                if ( defined $ParamItem->{Name} ) {
                    $GetParam{ $ParamItem->{Name} } = \@Array;
                }
            }

            if (
                $Object->Run(
                    GetParam => \%GetParam,
                    UserData => \%UserData
                )
                )
            {
                $Message .= $Object->Message();
            }
            else {
                $Priority .= 'Error';
                $Message  .= $Object->Error();
            }
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
            OP => "Action=AgentPreferences;Priority=$Priority;Message=$Message",
        );
    }

    # ------------------------------------------------------------ #
    # show preferences
    # ------------------------------------------------------------ #

    # get header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

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
            Info => $Message,
        );
    }

    # get user data
    my %UserData = $UserObject->GetUserData( UserID => $Self->{UserID} );
    $Output .= $Self->AgentPreferencesForm( UserData => \%UserData );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub AgentPreferencesForm {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Body',
        Data => { %Param, },
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my @Groups       = @{ $ConfigObject->Get('PreferencesView') };

    COLUMN:
    for my $Column (@Groups) {

        next COLUMN if !$Column;

        my %Data;
        my %Preferences = %{ $ConfigObject->Get('PreferencesGroups') };

        GROUP:
        for my $Group ( sort keys %Preferences ) {

            next GROUP if !$Group;
            next GROUP if !$Preferences{$Group};
            next GROUP if ref $Preferences{$Group} ne 'HASH';
            next GROUP if !$Preferences{$Group}->{Column};
            next GROUP if $Preferences{$Group}->{Column} ne $Column;

            # In case of a priority conflict, increase priority until a free slot is found.
            if ( $Data{ $Preferences{$Group}->{Prio} } ) {

                COUNT:
                for ( 1 .. 151 ) {

                    $Preferences{$Group}->{Prio}++;

                    next COUNT if $Data{ $Preferences{$Group}->{Prio} };

                    $Data{ $Preferences{$Group}->{Prio} } = $Group;
                    last COUNT;
                }
            }

            $Data{ $Preferences{$Group}->{Prio} } = $Group;
        }

        $LayoutObject->Block(
            Name => 'Column',
            Data => {
                Header => $Column,
                %Param,
            },
        );

        # sort
        for my $Key ( sort keys %Data ) {
            $Data{ sprintf( "%07d", $Key ) } = $Data{$Key};
            delete $Data{$Key};
        }

        # show each preferences setting
        PRIO:
        for my $Prio ( sort keys %Data ) {
            my $Group = $Data{$Prio};
            next PRIO if !$ConfigObject->{PreferencesGroups}->{$Group};

            my %Preference = %{ $ConfigObject->{PreferencesGroups}->{$Group} };
            next PRIO if !$Preference{Active};

            # load module
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::Preferences::Generic';
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                return $LayoutObject->FatalError();
            }
            my $Object = $Module->new(
                %{$Self},
                UserObject => $Kernel::OM->Get('Kernel::System::User'),
                ConfigItem => \%Preference,
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
                if ( ref $ParamItem->{Data} eq 'HASH' || ref $Preference{Data} eq 'HASH' ) {
                    $ParamItem->{Option} = $LayoutObject->BuildSelection(
                        %Preference,
                        %{$ParamItem},
                        OptionTitle => 1,
                    );
                }
                $LayoutObject->Block(
                    Name => 'Block',
                    Data => { %Preference, %{$ParamItem}, },
                );
                my $BlockName = $ParamItem->{Block} || $Preference{Block} || 'Option';

                $LayoutObject->Block(
                    Name => $BlockName,
                    Data => { %Preference, %{$ParamItem}, },
                );

                if ( scalar @Params == 1 ) {
                    $LayoutObject->Block(
                        Name => $BlockName . 'SingleBlock',
                        Data => { %Preference, %{$ParamItem}, },
                    );
                }
            }

            if ( scalar @Params > 1 ) {
                $LayoutObject->Block(
                    Name => 'MultipleBlocks',
                    Data => {%Preference},
                );
            }
        }
    }

    # create & return output
    return $LayoutObject->Output(
        TemplateFile => 'AgentPreferences',
        Data         => \%Param,
    );
}

1;
