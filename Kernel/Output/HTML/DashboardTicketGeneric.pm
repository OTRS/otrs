# --
# Kernel/Output/HTML/DashboardTicketGeneric.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketGeneric;

use strict;
use warnings;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardTicketGenericFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    }

    # remember filter
    if ( $Self->{Filter} ) {

        # update session
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $PreferencesKey,
            Value     => $Self->{Filter},
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $PreferencesKey,
                Value  => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'All';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown Tickets',
            Name  => $Self->{PrefKey},
            Block => 'Option',

            #            Block => 'Input',
            Data => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    # check if frontend module of link is used
    if ( $Self->{Config}->{Link} && $Self->{Config}->{Link} =~ /Action=(.+?)([&;].+?|)$/ ) {
        my $Action = $1;
        if ( !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action} ) {
            $Self->{Config}->{Link} = '';
        }
    }

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CacheKey = $Self->{Name} . '-'
        . $Self->{PageShown} . '-'
        . $Self->{StartHit} . '-'
        . $Self->{UserID};

    # get all search base attributes
    my %TicketSearch;
    my %DynamicFieldsParameters;
    my @Params = split /;/, $Self->{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        # push ARRAYREF attributes directly in an ARRAYREF
        if (
            $Key
            =~ /^(StateType|StateTypeIDs|Queues|QueueIDs|Types|TypeIDs|States|StateIDs|Priorities|PriorityIDs|Services|ServiceIDs|SLAs|SLAIDs|Locks|LockIDs|OwnerIDs|ResponsibleIDs|WatchUserIDs|ArchiveFlags)$/
            )
        {
            push @{ $TicketSearch{$Key} }, $Value;
        }

        # check if parameter is a dynamic field and capture dynamic field name (with DynamicField_)
        # in $1 and the Operator in $2
        # possible Dynamic Fields options include:
        #   DynamicField_NameX_Equals=123;
        #   DynamicField_NameX_Like=value*;
        #   DynamicField_NameX_GreaterThan=2001-01-01 01:01:01;
        #   DynamicField_NameX_GreaterThanEquals=2001-01-01 01:01:01;
        #   DynamicField_NameX_SmallerThan=2002-02-02 02:02:02;
        #   DynamicField_NameX_SmallerThanEquals=2002-02-02 02:02:02;
        elsif ( $Key =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {
            $DynamicFieldsParameters{$1}->{$2} = $Value;
        }

        elsif ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
            push @{ $TicketSearch{$Key} }, $Value;
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }
    %TicketSearch = (
        %TicketSearch,
        %DynamicFieldsParameters,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID => $Self->{UserID},
    );

    # CustomerInformationCenter shows data per CustomerID
    if ( $Param{CustomerID} ) {
        $TicketSearch{CustomerID} = $Param{CustomerID};
        $CacheKey .= '-' . $Param{CustomerID};
    }

    # define filter attributes
    my @MyQueues = $Self->{QueueObject}->GetAllCustomQueues(
        UserID => $Self->{UserID},
    );
    if ( !@MyQueues ) {
        @MyQueues = (999_999);
    }
    my %TicketSearchSummary = (
        Locked => {
            OwnerIDs => [ $Self->{UserID}, ],
            Locks => [ 'lock', 'tmp_lock' ],
        },
        Watcher => {
            WatchUserIDs => [ $Self->{UserID}, ],
            Locks        => undef,
        },
        Responsible => {
            ResponsibleIDs => [ $Self->{UserID}, ],
            Locks          => undef,
        },
        MyQueues => {
            QueueIDs => \@MyQueues,
            Locks    => undef,
        },
        All => {
            OwnerIDs => undef,
            Locks    => undef,
        },
    );

    if ( defined $TicketSearch{QueueIDs} || defined $TicketSearch{Queues} ) {
        delete $TicketSearchSummary{MyQueues};
    }

    # check cache
    my $TicketIDs = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $CacheKey . '-' . $Self->{Filter} . '-List',
    );

    # find and show ticket list
    my $CacheUsed = 1;
    if ( !$TicketIDs ) {
        $CacheUsed = 0;
        my @TicketIDsArray = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            %TicketSearch,
            %{ $TicketSearchSummary{ $Self->{Filter} } },
            Limit => $Self->{PageShown} + $Self->{StartHit} - 1,
        );
        $TicketIDs = \@TicketIDsArray;
    }

    # check cache
    my $Summary = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $CacheKey . '-Summary',
    );

    # if no cache or new list result, do count lookup
    if ( !$Summary || !$CacheUsed ) {
        for my $Type ( sort keys %TicketSearchSummary ) {
            next if !$TicketSearchSummary{$Type};
            $Summary->{$Type} = $Self->{TicketObject}->TicketSearch(
                Result => 'COUNT',
                %TicketSearch,
                %{ $TicketSearchSummary{$Type} },
            );
        }
    }

    # set cache
    if ( !$CacheUsed && $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey . '-Summary',
            Value => $Summary,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey . '-' . $Self->{Filter} . '-List',
            Value => $TicketIDs,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # set css class
    $Summary->{ $Self->{Filter} . '::Selected' } = 'Selected';

    # get filter ticket counts
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilter',
        Data => {
            %Param,
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
        },
    );

    # show also watcher if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterWatcher',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # show also responsible if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterResponsible',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # show only myqueues if we have the filter
    if ( $TicketSearchSummary{MyQueues} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterMyQueues',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # add page nav bar
    my $Total = $Summary->{ $Self->{Filter} } || 0;
    my $LinkPage = 'Subaction=Element;Name=' . $Self->{Name} . ';Filter=' . $Self->{Filter} . ';';
    if ( $Param{CustomerID} ) {
        $LinkPage .= "CustomerID=$Param{CustomerID};";
    }
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $Self->{LayoutObject}->{Action},
        Link           => $LinkPage,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # show tickets
    my $Count = 0;
    for my $TicketID ( @{$TicketIDs} ) {
        $Count++;
        next if $Count < $Self->{StartHit};
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            UserID        => $Self->{UserID},
            DynamicFields => 0,
        );

        # set a default title if ticket has no title
        if ( !$Ticket{Title} ) {
            $Ticket{Title} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'This ticket has no title or subject'
            );
        }

        # create human age
        if ( $Self->{Config}->{Time} ne 'Age' ) {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }
        else {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }

        # show ticket
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRow',
            Data => \%Ticket,
        );

        # show ticket flags
        my @TicketMetaItems = $Self->{LayoutObject}->TicketMetaItems(
            Ticket => \%Ticket,
        );
        for my $Item (@TicketMetaItems) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericRowMeta',
                Data => {},
            );
            if ($Item) {
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericRowMetaImage',
                    Data => $Item,
                );
            }
        }
    }

    # show "none" if no ticket is available
    if ( !$TicketIDs || !@{$TicketIDs} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketGeneric',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
