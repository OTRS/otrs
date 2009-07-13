# --
# Kernel/Modules/AgentDashboard.pm - a global dashbard
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentDashboard.pm,v 1.10 2009-07-13 05:09:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentDashboard;

use strict;
use warnings;

use Kernel::System::Cache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # load backends
    my $Config = $Self->{ConfigObject}->Get('DashboardBackend');
    if ( !$Config ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No such config for Dashboard',
        );
    }

    # update/close item
    if ( $Self->{Subaction} eq 'UpdateRemove' ) {
        my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' );
        my $Key = 'UserDashboard' . $Name;

        # update ssession
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Key,
            Value     => 0,
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Key,
                Value  => 0,
            );
        }

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}"
        );

    }

    # update settings
    elsif ( $Self->{Subaction} eq 'Update' ) {

        my @Backends = $Self->{ParamObject}->GetArray( Param => 'Backend' );
        for my $Name ( sort keys %{$Config} ) {
            my $Active = 0;
            for my $Backend (@Backends) {
                next if $Backend ne $Name;
                $Active = 1;
                last;
            }
            my $Key = 'UserDashboard' . $Name;

            # update ssession
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Key,
                Value     => $Active,
            );

            # update preferences
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Self->{UserID},
                    Key    => $Key,
                    Value  => $Active,
                );
            }
        }

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}"
        );
    }

    # deliver element
    elsif ( $Self->{Subaction} eq 'Element' ) {

        my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' );

        my %Element = $Self->_Element( Name => $Name, Config => $Config );
        if ( !%Element ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get element data of $Name!",
            );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => ${ $Element{Content} },
            Type        => 'inline'
        );
    }

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # show dashboard
    $Self->{LayoutObject}->Block(
        Name => 'Content',
        Data => {},
    );

    # load settings
    my %Backends;
    BACKEND:
    for my $Name ( sort keys %{$Config} ) {

        # check permissions
        if ( $Config->{$Name}->{Group} ) {
            my @Groups = split /;/, $Config->{$Name}->{Group};
            for my $Group (@Groups) {
                my $Name = 'UserIsGroup[' . $Group . ']';
                next BACKEND if !$Self->{$Name};
                next BACKEND if $Self->{$Name} ne 'Yes';
            }
        }

        my $Key = 'UserDashboard' . $Name;
        if ( defined $Self->{$Key} ) {
            $Backends{$Name} = $Self->{$Key};
        }
        else {
            $Backends{$Name} = $Config->{$Name}->{Default};
        }
    }

    # try every backend
    for my $Name ( sort keys %{$Config} ) {

        # get element data
        my %Element = $Self->_Element(
            Name     => $Name,
            Config   => $Config,
            Backends => \%Backends,
        );
        next if !%Element;

        # rendering
        $Self->{LayoutObject}->Block(
            Name => $Element{Preferences}->{Block},
            Data => {
                %{ $Config->{$Name} },
                %{ $Element{Preferences} },
                Name    => $Name,
                Content => ${ $Element{Content} },
            },
        );

        # more link
        if ( $Element{Preferences}->{Link} ) {
            $Self->{LayoutObject}->Block(
                Name => $Element{Preferences}->{Block} . 'More',
                Data => {
                    %{ $Config->{$Name} },
                    %{ $Element{Preferences} },
                },
            );
        }

    }

    # get output back
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboard',
        Data         => \%Param
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Element {
    my ( $Self, %Param ) = @_;

    my $Name     = $Param{Name};
    my $Config   = $Param{Config};
    my $Backends = $Param{Backends};

    # check permissions
    if ( $Config->{$Name}->{Group} ) {
        my @Groups = split /;/, $Config->{$Name}->{Group};
        for my $Group (@Groups) {
            my $Name = 'UserIsGroup[' . $Group . ']';
            return if !$Self->{$Name};
            return if $Self->{$Name} ne 'Yes';
        }
    }

    # load backends
    my $Module = $Config->{$Name}->{Module};
    return if !$Self->{MainObject}->Require($Module);
    my $Object = $Module->new(
        %{$Self},
        Config => $Config->{$Name},
        Name   => $Name,
    );

    # get module preferences
    my %Preferences = $Object->Preferences();

    # add backend to settings selection
    if ( $Backends ) {
        my $Checked = '';
        if ( $Backends->{$Name} ) {
            $Checked = 'checked';
        }
        $Self->{LayoutObject}->Block(
            Name => 'ContentSettings',
            Data => {
                %{ $Config->{$Name} },
                %Preferences,
                Name    => $Name,
                Checked => $Checked,
            },
        );
        return if !$Backends->{$Name};
    }

    # check backends cache
    my $Content;
    my $CacheKey = $Preferences{CacheKey};
    if (!$CacheKey) {
        $CacheKey = $Name . '-' . $Self->{LayoutObject}->{UserLanguage};
    }
    if ( $Preferences{CacheTTL} ) {
        $Content = $Self->{CacheObject}->Get(
            Type => 'Dashboard',
            Key  => $CacheKey,
        );
    }

    # execute backends
    if ( !defined $Content ) {
        $Content = $Object->Run();
    }

    # check if content should be shown
    return if !$Content;

    # set cache
    if ( $Preferences{CacheTTL} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey,
            Value => $Content,
            TTL   => $Preferences{CacheTTL} * 60,
        );
    }

    # return result
    return (
        Content     => \$Content,
        Preferences => \%Preferences,
    );
}

1;
