# --
# Kernel/Modules/AgentDashboard.pm - a global dashbard
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentDashboard;

use strict;
use warnings;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

    $Self->{SlaveDBObject}     = $Self->{DBObject};
    $Self->{SlaveTicketObject} = $Self->{TicketObject};

    # use a slave db to search dashboard date
    if ( $Self->{ConfigObject}->Get('Core::MirrorDB::DSN') ) {

        $Self->{SlaveDBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            EncodeObject => $Param{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );

        if ( $Self->{SlaveDBObject} ) {

            $Self->{SlaveTicketObject} = Kernel::System::Ticket->new(
                %Param,
                DBObject => $Self->{SlaveDBObject},
            );
        }
    }

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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

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

    # update preferences
    elsif ( $Self->{Subaction} eq 'UpdatePreferences' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' );

        # get preferences settings
        my @PreferencesOnly = $Self->_Element(
            Name            => $Name,
            Configs         => $Config,
            PreferencesOnly => 1,
        );
        if ( !@PreferencesOnly ) {
            $Self->{LayoutObject}->FatalError(
                Message => "No preferences for $Name!",
            );
        }

        # remember preferences
        for my $Param (@PreferencesOnly) {

            # get params
            my $Value = $Self->{ParamObject}->GetParam( Param => $Param->{Name} );

            # update runtime vars
            $Self->{LayoutObject}->{ $Param->{Name} } = $Value;

            # update ssession
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Param->{Name},
                Value     => $Value,
            );

            # update preferences
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Self->{UserID},
                    Key    => $Param->{Name},
                    Value  => $Value,
                );
            }
        }

        # deliver new content page
        my %ElementReload = $Self->_Element( Name => $Name, Configs => $Config, AJAX => 1 );
        if ( !%ElementReload ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get element data of $Name!",
            );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => ${ $ElementReload{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # update settings
    elsif ( $Self->{Subaction} eq 'UpdateSettings' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

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

    # update position
    elsif ( $Self->{Subaction} eq 'UpdatePosition' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @Backends = $Self->{ParamObject}->GetArray( Param => 'Backend' );

        # get new order
        my $Key  = 'UserDashboardPosition';
        my $Data = '';
        for my $Backend (@Backends) {
            $Backend =~ s/^Dashboard(.+?)-box$/$1/g;
            $Data .= $Backend . ';';
        }

        # update ssession
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Key,
            Value     => $Data,
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Key,
                Value  => $Data,
            );
        }

        # redirect
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => '',
        );
    }

    # deliver element
    elsif ( $Self->{Subaction} eq 'Element' ) {

        my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' );

        my %Element = $Self->_Element( Name => $Name, Configs => $Config, AJAX => 1 );
        if ( !%Element ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get element data of $Name!",
            );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => ${ $Element{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # show dashboard
    $Self->{LayoutObject}->Block(
        Name => 'Content',
        Data => {},
    );

    # get shown backends
    my %Backends;
    BACKEND:
    for my $Name ( sort keys %{$Config} ) {

        # check permissions
        if ( $Config->{$Name}->{Group} ) {
            my $PermissionOK = 0;
            my @Groups = split /;/, $Config->{$Name}->{Group};
            GROUP:
            for my $Group (@Groups) {
                my $Permission = 'UserIsGroup[' . $Group . ']';
                if ( defined $Self->{$Permission} && $Self->{$Permission} eq 'Yes' ) {
                    $PermissionOK = 1;
                    last GROUP;
                }
            }
            next BACKEND if !$PermissionOK;
        }

        my $Key = 'UserDashboard' . $Name;
        if ( defined $Self->{$Key} ) {
            $Backends{$Name} = $Self->{$Key};
        }
        else {
            $Backends{$Name} = $Config->{$Name}->{Default};
        }
    }

    # set order of plugins
    my $Key = 'UserDashboardPosition';
    my @Order;
    my $Value = $Self->{$Key};

    if ($Value) {
        @Order = split /;/, $Value;

        # only use active backends
        @Order = grep { $Config->{$_} } @Order;
    }
    if ( !@Order ) {
        for my $Name ( sort keys %Backends ) {
            push @Order, $Name;
        }
    }

    # add not ordered plugins (e. g. new active)
    for my $Name ( sort keys %Backends ) {
        my $Included = 0;
        for my $Item (@Order) {
            next if $Item ne $Name;
            $Included = 1;
        }
        next if $Included;
        push @Order, $Name;
    }

    # try every backend to load and execute it
    for my $Name (@Order) {

        # get element data
        my %Element = $Self->_Element(
            Name     => $Name,
            Configs  => $Config,
            Backends => \%Backends,
        );
        next if !%Element;

        # NameForm (to support IE, is not working with "-" in form names)
        my $NameForm = $Name;
        $NameForm =~ s/-//g;

        # rendering
        $Self->{LayoutObject}->Block(
            Name => $Element{Config}->{Block},
            Data => {
                %{ $Element{Config} },
                Name     => $Name,
                NameForm => $NameForm,
                Content  => ${ $Element{Content} },
            },
        );

        # show settings link if preferences are available
        if ( $Element{Preferences} && @{ $Element{Preferences} } ) {
            $Self->{LayoutObject}->Block(
                Name => $Element{Config}->{Block} . 'Preferences',
                Data => {
                    %{ $Element{Config} },
                    Name     => $Name,
                    NameForm => $NameForm,
                },
            );
            for my $Param ( @{ $Element{Preferences} } ) {
                $Self->{LayoutObject}->Block(
                    Name => $Element{Config}->{Block} . 'PreferencesItem',
                    Data => {
                        %{ $Element{Config} },
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
                if ( $Param->{Block} eq 'Option' ) {
                    $Param->{Option} = $Self->{LayoutObject}->BuildSelection(
                        Data        => $Param->{Data},
                        Name        => $Param->{Name},
                        SelectedID  => $Param->{SelectedID},
                        Translation => $Param->{Translation},
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => $Element{Config}->{Block} . 'PreferencesItem' . $Param->{Block},
                    Data => {
                        %{ $Element{Config} },
                        %{$Param},
                        Data     => $Self->{ $Param->{Name} },
                        NamePref => $Param->{Name},
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
            }
        }

        # more link
        if ( $Element{Config}->{Link} ) {
            $Self->{LayoutObject}->Block(
                Name => $Element{Config}->{Block} . 'More',
                Data => {
                    %{ $Element{Config} },
                },
            );
        }
    }

    # get output back
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }

    # build main menu
    my $MainMenuConfig = $Self->{ConfigObject}->Get('AgentDashboard::MainMenu');
    if ( IsHashRefWithData($MainMenuConfig) ) {
        $Self->{LayoutObject}->Block( Name => 'MainMenu' );

        for my $MainMenuItem ( sort keys %{$MainMenuConfig} ) {

            $Self->{LayoutObject}->Block(
                Name => 'MainMenuItem',
                Data => {
                    %{ $MainMenuConfig->{$MainMenuItem} },
                },
            );
        }
    }

    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
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
    my $Configs  = $Param{Configs};
    my $Backends = $Param{Backends};

    # check permissions
    if ( $Configs->{$Name}->{Group} ) {
        my $PermissionOK = 0;
        my @Groups = split /;/, $Configs->{$Name}->{Group};
        GROUP:
        for my $Group (@Groups) {
            my $Permission = 'UserIsGroup[' . $Group . ']';
            if ( defined $Self->{$Permission} && $Self->{$Permission} eq 'Yes' ) {
                $PermissionOK = 1;
                last GROUP;
            }
        }
        return if !$PermissionOK;
    }

    # load backends
    my $Module = $Configs->{$Name}->{Module};
    return if !$Self->{MainObject}->Require($Module);
    my $Object = $Module->new(
        %{$Self},
        DBObject     => $Self->{SlaveDBObject},
        TicketObject => $Self->{SlaveTicketObject},
        Config       => $Configs->{$Name},
        Name         => $Name,
    );

    # get module config
    my %Config = $Object->Config();

    # get module preferences
    my @Preferences = $Object->Preferences();
    return @Preferences if $Param{PreferencesOnly};

    # add backend to settings selection
    if ($Backends) {
        my $Checked = '';
        if ( $Backends->{$Name} ) {
            $Checked = 'checked="checked"';
        }
        $Self->{LayoutObject}->Block(
            Name => 'ContentSettings',
            Data => {
                %Config,
                Name    => $Name,
                Checked => $Checked,
            },
        );
        return if !$Backends->{$Name};
    }

    # check backends cache (html page cache)
    my $Content;
    my $CacheKey = $Config{CacheKey};
    if ( !$CacheKey ) {
        $CacheKey = $Name . '-' . $Self->{LayoutObject}->{UserLanguage};
    }
    if ( $Config{CacheTTL} ) {
        $Content = $Self->{CacheObject}->Get(
            Type => 'Dashboard',
            Key  => $CacheKey,
        );
    }

    # execute backends
    my $CacheUsed = 1;
    if ( !defined $Content ) {
        $CacheUsed = 0;
        $Content = $Object->Run( AJAX => $Param{AJAX} );
    }

    # check if content should be shown
    return if !$Content;

    # set cache (html page cache)
    if ( !$CacheUsed && $Config{CacheTTL} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey,
            Value => $Content,
            TTL   => $Config{CacheTTL} * 60,
        );
    }

    # return result
    return (
        Content     => \$Content,
        Config      => \%Config,
        Preferences => \@Preferences,
    );
}

1;
