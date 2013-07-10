# --
# Kernel/Modules/AgentPreferences.pm - provides agent preferences
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentPreferences;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (
        qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject SessionObject UserObject)
        )
    {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # update preferences via AJAX
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'UpdateAJAX' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Key   = $Self->{ParamObject}->GetParam( Param => 'Key' );
        my $Value = $Self->{ParamObject}->GetParam( Param => 'Value' );

        # update preferences
        my $Success = $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Key,
            Value  => $Value,
        );

        # update session
        if ($Success) {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Key,
                Value     => $Value,
            );
        }
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => $Success,
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check group param
        my $Group = $Self->{ParamObject}->GetParam( Param => 'Group' );
        if ( !$Group ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Param Group is required!' );
        }

        # check preferences setting
        my %Preferences = %{ $Self->{ConfigObject}->Get('PreferencesGroups') };
        if ( !$Preferences{$Group} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => "No such config for $Group" );
        }

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
        my $Module = $Preferences{$Group}->{Module};
        if ( !$Self->{MainObject}->Require($Module) ) {
            return $Self->{LayoutObject}->FatalError();
        }

        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Group},
            Debug      => $Self->{Debug},
        );
        my @Params = $Object->Param( UserData => \%UserData );
        my %GetParam;
        for my $ParamItem (@Params) {
            my @Array = $Self->{ParamObject}->GetArray(
                Param => $ParamItem->{Name},
                Raw => $ParamItem->{Raw} || 0,
            );
            if ( defined $ParamItem->{Name} ) {
                $GetParam{ $ParamItem->{Name} } = \@Array;
            }
        }
        my $Message  = '';
        my $Priority = '';
        if ( $Object->Run( GetParam => \%GetParam, UserData => \%UserData ) ) {
            $Message = $Object->Message();
        }
        else {
            $Priority = 'Error';
            $Message  = $Object->Error();
        }

        # check redirect
        my $RedirectURL = $Self->{ParamObject}->GetParam( Param => 'RedirectURL' );
        if ($RedirectURL) {
            return $Self->{LayoutObject}->Redirect(
                OP => $RedirectURL,
            );
        }

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentPreferences;Priority=$Priority;Message=$Message",
        );
    }

    # ------------------------------------------------------------ #
    # show preferences
    # ------------------------------------------------------------ #

    # get header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get param
    my $Message  = $Self->{ParamObject}->GetParam( Param => 'Message' )  || '';
    my $Priority = $Self->{ParamObject}->GetParam( Param => 'Priority' ) || '';

    # add notification
    if ( $Message && $Priority eq 'Error' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => $Priority,
            Info     => $Message,
        );
    }
    elsif ($Message) {
        $Output .= $Self->{LayoutObject}->Notify( Info => $Message, );
    }

    # get user data
    my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
    $Output .= $Self->AgentPreferencesForm( UserData => \%UserData );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub AgentPreferencesForm {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Body',
        Data => { %Param, },
    );

    my @Groups = @{ $Self->{ConfigObject}->Get('PreferencesView') };

    COLUMN:
    for my $Column (@Groups) {

        next COLUMN if !$Column;

        my %Data;
        my %Preferences = %{ $Self->{ConfigObject}->Get('PreferencesGroups') };

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

        $Self->{LayoutObject}->Block(
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
        for my $Prio ( sort keys %Data ) {
            my $Group = $Data{$Prio};
            next if !$Self->{ConfigObject}->{PreferencesGroups}->{$Group};

            my %Preference = %{ $Self->{ConfigObject}->{PreferencesGroups}->{$Group} };
            next if !$Preference{Active};

            # load module
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::PreferencesGeneric';
            if ( !$Self->{MainObject}->Require($Module) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Module->new(
                %{$Self},
                ConfigItem => \%Preference,
                Debug      => $Self->{Debug},
            );
            my @Params = $Object->Param( UserData => $Param{UserData} );
            next if !@Params;

            # show item
            $Self->{LayoutObject}->Block(
                Name => 'Item',
                Data => {
                    Group => $Group,
                    %Preference,
                },
            );
            for my $ParamItem (@Params) {
                if ( ref $ParamItem->{Data} eq 'HASH' || ref $Preference{Data} eq 'HASH' ) {
                    $ParamItem->{Option} = $Self->{LayoutObject}->BuildSelection(
                        %Preference,
                        %{$ParamItem},
                        OptionTitle => 1,
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'Block',
                    Data => { %Preference, %{$ParamItem}, },
                );
                my $BlockName = $ParamItem->{Block} || $Preference{Block} || 'Option';

                $Self->{LayoutObject}->Block(
                    Name => $BlockName,
                    Data => { %Preference, %{$ParamItem}, },
                );

                if ( scalar @Params == 1 ) {
                    $Self->{LayoutObject}->Block(
                        Name => $BlockName . 'SingleBlock',
                        Data => { %Preference, %{$ParamItem}, },
                    );
                }
            }

            if ( scalar @Params > 1 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'MultipleBlocks',
                    Data => {%Preference},
                );
            }
        }
    }

    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentPreferences',
        Data         => \%Param,
    );
}

1;
