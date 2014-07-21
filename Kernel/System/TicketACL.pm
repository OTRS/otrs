# --
# Kernel/System/TicketACL.pm - all ticket ACL functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TicketACL;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::TicketACL - ticket ACL lib

=head1 SYNOPSIS

All ticket ACL functions.

=over 4

=cut

=item TicketAcl()

Restricts the Data parameter sent to a subset of it, depending on a group of user defied rules
called ACLs. The reduced subset can be access from TicketACLData() if ReturnType parameter is set
to: Ticket, Process or ActivityDialog, or in TicketACLActionData(), if ReturnType Action is used.

Each ACL can contain different restrictions for different objects the ReturnType parameter defines
which object is considered for this restrictions, in the case of the Ticket object a second
parameter called ReturnSubtype is needed, to specify the ticket attribute to be restricted, like:
Queue, State, Owner, etc. While for the rest of the objects a "-" value must be set. The ReturnType
and ReturnSubType must be set according to the Data parameter sent.

The rest of the attributes define the matching options for the ACL rules.

Example to restrict ticket actions:

    my $Success = $TicketObject->TicketAcl(
        Data => {                            # Values to restrict
            1 => AgentTicketZoom,
            # ...
        },

        Action        => 'AgentTicketZoom',           # Optional
        TicketID      => 123,                         # Optional
        DynamicField  => {                            # Optional
            DynamicField_NameX => 123,
            DynamicField_NameZ => 'some value',
        },

        QueueID          => 123,                      # Optional
        Queue            => 'some queue name',        # Optional

        ServiceID        => 123,                      # Optional
        Service          => 'some service name',      # Optional

        TypeID           => 123,
        Type             => 'some ticket type name',  # Optional

        PriorityID       => 123,                      # Optional
        NewPriorityID    => 123,                      # Optional, PriorityID or NewPriorityID can be
                                                      #   used and they both refers to PriorityID
        Priority         => 'some priority name',     # Optional

        SLAID            => 123,
        SLA              => 'some SLA name',          # Optional

        StateID          => 123,                      # Optional
        NextStateID      => 123,                      # Optional, StateID or NextStateID can be
                                                      #   used and they both refers to StateID
        State            => 'some ticket state name', # Optional

        OwnerID          => 123,                      # Optional
        NewOwnerID       => 123,                      # Optional, OwnerID or NewOwnerID can be
                                                      #   used and they both refers to OwnerID
        Owner            => 'some user login'         # Optional

        ResponsibleID    => 123,                      # Optional
        NewResponsibleID => 123,                      # Optional, ResponsibleID or NewResposibleID
                                                      #   can be used and they both refers to
                                                      #     ResponsibleID
        Responsible      => 'some user login'         # Optional

        ReturnType     => 'Action',                   # To match Possible, PossibleAdd or
                                                      #   PossibleNot key in ACL
        ReturnSubType  => '-',                        # To match Possible, PossibleAdd or
                                                      #   PossibleNot sub-key in ACL

        UserID         => 123,                        # UserID => 1 is not affected by this function
        CustomerUserID => 'customer login',           # UserID or CustomerUserID are mandatory

        # Process Management Parameters
        ProcessEntityID        => 123,                # Optional
        ActivityEntityID       => 123,                # Optional
        ActivityDialogEntityID => 123,                # Optional
    );

or to restrict ticket states:

    $Success = $TicketObject->TicketAcl(
        Data => {
            1 => 'new',
            2 => 'open',
            # ...
        },
        ReturnType    => 'Ticket',
        ReturnSubType => 'State',
        UserID        => 123,
    );

returns:
    $Success = 1,                                     # if an ACL matches, or false otherwise.

If ACL modules are configured in the C<Ticket::Acl::Module> config key, they are invoked
during the call to C<TicketAcl>. The configuration of a module looks like this:

     $ConfigObject->{'Ticket::Acl::Module'}->{'TheName'} = {
         Module => 'Kernel::System::Ticket::Acl::TheAclModule',
         Checks => ['Owner', 'Queue', 'SLA', 'Ticket'],
         ReturnType => 'Ticket',
         ReturnSubType => ['State', 'Service'],
     };

Each time the C<ReturnType> and one of the C<ReturnSubType> entries is identical to the same
arguments passed to C<TicketAcl>, the module of the name in C<Module> is loaded, the C<new> method
is called on it, and then the C<Run> method is called.

The C<Checks> array reference in the configuration controls what arguments are passed. to the
C<Run> method.
Valid keys are C<CustomerUser>, C<DynamicField>, C<Frontend>, C<Owner>, C<Priority>, C<Process>,
C<Queue>, C<Responsible>, C<Service>, C<SLA>, C<State>, C<Ticket> and C<Type>. If any of those are
present, the C<Checks> argument passed to C<Run> contains an entry with the same name, and as a
value the associated data.

The C<Run> method can add entries to the C<Acl> param hash, which are then evaluated along with all
other ACL. It should only add entries whose conditionals can be checked with the data specified in
the C<Checks> configuration entry.

The return value of the C<Run> method is ignored.

=cut

sub TicketAcl {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} && !$Param{CustomerUserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID or CustomerUserID!',
        );
        return;
    }

    # check needed stuff
    for my $Needed (qw(ReturnSubType ReturnType Data)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # do not execute ACLs if UserID 1 is used
    return if $Param{UserID} && $Param{UserID} == 1;

    my $ACLs       = $Self->{ConfigObject}->Get('TicketAcl');
    my $AclModules = $Self->{ConfigObject}->Get('Ticket::Acl::Module');

    # only execute ACLs if ACL or ACL module is configured
    if ( !$ACLs && !$AclModules ) {
        return;
    }

    # find out which data we actually need
    my %ApplicableAclModules;
    my %RequiredChecks;
    my $CheckAll = 0;

    MODULENAME:
    for my $ModuleName ( sort keys %{ $AclModules // {} } ) {
        my $Module = $AclModules->{$ModuleName};
        if ( $Module->{ReturnType} && $Module->{ReturnType} ne $Param{ReturnType} ) {
            next MODULENAME;
        }
        if ( $Module->{ReturnSubType} ) {
            if ( ref( $Module->{ReturnSubType} ) eq 'HASH' ) {
                next MODULENAME if !grep { $Param{ReturnSubType} eq $_ }
                    @{ $Module->{ReturnSubType} };
            }
            else {

                # a scalar, we hope
                next MODULENAME if !$Module->{ReturnSubType} eq $Param{ReturnSubType};
            }
        }

        # here only modules applicable to this ACL invocation remain
        $ApplicableAclModules{$ModuleName} = $Module;

        if ( $Module->{Checks} && ref( $Module->{Checks} ) eq 'ARRAY' ) {
            $RequiredChecks{$_} = 1 for @{ $Module->{Checks} };
        }
        elsif ( $Module->{Checks} ) {
            $RequiredChecks{ $Module->{Checks} } = 1;
        }
        else {
            $CheckAll = 1;
        }
    }

    return if !%ApplicableAclModules && !$ACLs && !$CheckAll;

    for my $ACL ( values %{ $ACLs // {} } ) {
        for my $Source (qw/ Properties PropertiesDatabase/) {
            for my $Check ( sort keys %{ $ACL->{$Source} } ) {
                my $CleanedUp = $Check;
                $CleanedUp =~ s/(?:ID|Name|Login)$//;
                $CleanedUp =~ s/^(?:Next|New|Old)//;
                $RequiredChecks{$CleanedUp} = 1;
                if ( $Check eq 'Ticket' ) {
                    if ( ref( $ACL->{Properties}{$Check} ) eq 'HASH' ) {
                        for my $InnerCheck ( sort keys %{ $ACL->{$Source}{$Check} } ) {
                            $InnerCheck =~ s/(?:ID|Name|Login)$//;
                            $InnerCheck =~ s/^(?:Next|New|Old)//;
                            $RequiredChecks{$InnerCheck} = 1;
                        }
                    }
                }
            }
        }
    }

    # gather all required data to be compared against the ACLs
    my $CheckResult = $Self->_GetChecks(
        %Param,
        CheckAll       => $CheckAll,
        RequiredChecks => \%RequiredChecks,
    );
    my %Checks         = %{ $CheckResult->{Checks}         || {} };
    my %ChecksDatabase = %{ $CheckResult->{ChecksDatabase} || {} };

    # check ACL configuration
    my %Acls;
    if ( $Self->{ConfigObject}->Get('TicketAcl') ) {
        %Acls = %{ $Self->{ConfigObject}->Get('TicketAcl') };
    }

    # check ACL module
    MODULE:
    for my $ModuleName ( sort keys %ApplicableAclModules ) {
        my $Module = $ApplicableAclModules{$ModuleName};

        next MODULE if !$Self->{MainObject}->Require( $Module->{Module} );

        my $Generic = $Module->{Module}->new(
            %{$Self},
            TicketObject => $Self,
        );
        $Generic->Run(
            %Param,
            Acl    => \%Acls,
            Checks => \%Checks,
            Config => $Module,
        );
    }

    # get used data
    my %Data;
    if ( ref $Param{Data} ) {
        %Data = %{ $Param{Data} };
    }

    my %NewData;
    my $UseNewMasterParams = 0;

    my %NewDefaultActionData;

    if ( $Param{ReturnType} eq 'Action' ) {

        if ( !IsHashRefWithData( $Param{Data} ) ) {

            # use Data if is a string and it is not '-'
            if ( IsStringWithData( $Param{Data} ) && $Param{Data} ne '-' ) {
                %Data = ( 1 => $Param{Data} );
            }

            # otherwise use the param Action
            elsif ( IsStringWithData( $Param{Action} ) ) {
                %Data = ( 1 => $Param{Action} );
            }
        }

        my %NewActionData = %Data;

        # calculate default ticket action ACL data
        my @ActionsToDelete;
        my $DefaultActionData = $Self->{ConfigObject}->Get('TicketACL::Default::Action') || {};

        if ( IsHashRefWithData($DefaultActionData) ) {

            for my $Index ( sort keys %NewActionData ) {

                my $Action = $NewActionData{$Index};
                if ( !$DefaultActionData->{$Index} ) {
                    push @ActionsToDelete, $Action;
                }
            }
        }

        $Self->{DefaultTicketAclActionData} = \%NewActionData;

        for my $Action (@ActionsToDelete) {
            delete $Self->{DefaultTicketAclActionData}->{$Action};
        }
    }

    # set NewTmpData after Possible Data recalculation on ReturnType Action
    my %NewTmpData = %Data;

    # get the debug parameters
    $Self->{ACLDebug} = $Self->{ConfigObject}->Get('TicketACL::Debug::Enabled') || 0;
    $Self->{ACLDebugLogPriority}
        = $Self->{ConfigObject}->Get('TicketACL::Debug::LogPriority') || 'debug';

    my $ACLDebugConfigFilters = $Self->{ConfigObject}->Get('TicketACL::Debug::Filter') || {};
    for my $FilterName ( sort keys %{$ACLDebugConfigFilters} ) {
        my %Filter = %{ $ACLDebugConfigFilters->{$FilterName} };
        for my $FilterItem ( sort keys %Filter ) {
            $Self->{ACLDebugFilters}->{$FilterItem} = $Filter{$FilterItem};
        }
    }

    # check if debug filters apply (ticket)
    if ( $Self->{ACLDebug} ) {

        DEBUGFILTER:
        for my $DebugFilter ( sort keys %{ $Self->{ACLDebugFilters} } ) {
            next DEBUGFILTER if $DebugFilter eq 'ACLName';
            next DEBUGFILTER if !$Self->{ACLDebugFilters}->{$DebugFilter};

            if ( $DebugFilter =~ m{<OTRS_TICKET_([^>]+)>}msx ) {
                my $TicketParam = $1;

                if (
                    defined $ChecksDatabase{Ticket}->{$TicketParam}
                    && $ChecksDatabase{Ticket}->{$TicketParam}
                    && $Self->{ACLDebugFilters}->{$DebugFilter} ne
                    $ChecksDatabase{Ticket}->{$TicketParam}
                    )
                {
                    $Self->{ACLDebug} = 0;
                    last DEBUGFILTER;
                }
            }
        }
    }

    # remember last ACLDebug state (before ACLs loop)
    $Self->{ACLDebugRecovery} = $Self->{ACLDebug};

    ACLRULES:
    for my $Acl ( sort keys %Acls ) {

        # check if debug filters apply (ACL) (only if ACLDebug is active)
        if (
            $Self->{ACLDebugRecovery}
            && defined $Self->{ACLDebugFilters}->{'ACLName'}
            && $Self->{ACLDebugFilters}->{'ACLName'}
            )
        {
            # if not match current ACL disable ACLDebug
            if ( $Self->{ACLDebugFilters}->{'ACLName'} ne $Acl ) {
                $Self->{ACLDebug} = 0;
            }

            # reenable otherwise (we are sure it was enabled before)
            else {
                $Self->{ACLDebug} = 1;
            }
        }

        my %Step = %{ $Acls{$Acl} };

        # check force match
        my $ForceMatch;
        if (
            !IsHashRefWithData( $Step{Properties} )
            && !IsHashRefWithData( $Step{PropertiesDatabase} )
            )
        {
            $ForceMatch = 1;
        }

        my $PropertiesMatch;
        my $PropertiesMatchTry;
        my $PropertiesDatabaseMatch;
        my $PropertiesDatabaseMatchTry;
        my $UseNewParams = 0;

        for my $PropertiesHash (qw(Properties PropertiesDatabase)) {

            my %UsedChecks = %Checks;
            if ( $PropertiesHash eq 'PropertiesDatabase' ) {
                %UsedChecks = %ChecksDatabase;
            }

            # set match params
            my $Match    = 1;
            my $MatchTry = 0;
            for my $Key ( sort keys %{ $Step{$PropertiesHash} } ) {
                for my $Data ( sort keys %{ $Step{$PropertiesHash}->{$Key} } ) {
                    my $MatchProperty = 0;
                    for my $Item ( @{ $Step{$PropertiesHash}->{$Key}->{$Data} } ) {
                        if ( ref $UsedChecks{$Key}->{$Data} eq 'ARRAY' ) {
                            my $MatchItem = 0;
                            my $MatchedArrayDataItem;
                            ARRAYDATAITEM:
                            for my $ArrayDataItem ( @{ $UsedChecks{$Key}->{$Data} } ) {
                                $MatchedArrayDataItem = $ArrayDataItem;
                                my $LoopMatchResult = $Self->_CompareMatchWithData(
                                    Match      => $Item,
                                    Data       => $ArrayDataItem,
                                    SingleItem => 0,
                                );
                                if ( !$LoopMatchResult->{Skip} )
                                {
                                    $MatchItem = $LoopMatchResult->{Match};
                                    last ARRAYDATAITEM;
                                }
                            }
                            if ($MatchItem) {
                                $MatchProperty = 1;

                                # debug log
                                if ( $Self->{ACLDebug} ) {
                                    $Self->{LogObject}->Log(
                                        Priority => $Self->{ACLDebugLogPriority},
                                        Message =>
                                            "TicketACL '$Acl' $PropertiesHash:'$Key->$Data' MatchedARRAY ($Item eq $MatchedArrayDataItem)",
                                    );
                                }
                            }
                        }
                        elsif ( defined $UsedChecks{$Key}->{$Data} ) {

                            my $DataItem    = $UsedChecks{$Key}->{$Data};
                            my $MatchResult = $Self->_CompareMatchWithData(
                                Match      => $Item,
                                Data       => $DataItem,
                                SingleItem => 1
                            );

                            if ( $MatchResult->{Match} ) {
                                $MatchProperty = 1;

                                # debug
                                if ( $Self->{ACLDebug} ) {
                                    $Self->{LogObject}->Log(
                                        Priority => $Self->{ACLDebugLogPriority},
                                        Message =>
                                            "TicketACL '$Acl' $PropertiesHash:'$Key->$Data' Matched ($Item eq $UsedChecks{$Key}->{$Data})",
                                    );
                                }
                            }
                        }
                    }
                    if ( !$MatchProperty ) {
                        $Match = 0;
                    }
                    $MatchTry = 1;
                }
            }

            # check force option
            if ($ForceMatch) {
                $Match    = 1;
                $MatchTry = 1;
            }

            if ( $PropertiesHash eq 'Properties' ) {
                $PropertiesMatch    = $Match;
                $PropertiesMatchTry = $MatchTry;
            }
            else {
                $PropertiesDatabaseMatch    = $Match;
                $PropertiesDatabaseMatchTry = $MatchTry;
            }

            # check if properties is missing
            if ( !IsHashRefWithData( $Step{Properties} ) ) {
                $PropertiesMatch    = $PropertiesDatabaseMatch;
                $PropertiesMatchTry = $PropertiesDatabaseMatchTry;
            }

            # check if properties database is missing
            if ( !IsHashRefWithData( $Step{PropertiesDatabase} ) ) {
                $PropertiesDatabaseMatch    = $PropertiesMatch;
                $PropertiesDatabaseMatchTry = $PropertiesMatchTry;
            }
        }

        # the following logic should be applied to calculate if an ACL matches:
        # if both Properties and PropertiesDatabase match => match
        # if Properties matches, and PropertiesDatabase does not match => no match
        # if PropertiesDatabase matches, but Properties does not match => no match
        # if PropertiesDatabase matches, and Properties is missing => match
        # if Properties matches, and PropertiesDatabase is missing => match.
        my $Match;
        if ( $PropertiesMatch && $PropertiesDatabaseMatch ) {
            $Match = 1;
        }

        my $MatchTry;
        if ( $PropertiesMatchTry && $PropertiesDatabaseMatchTry ) {
            $MatchTry = 1;
        }

        # debug log
        if ( $Match && $MatchTry ) {
            if ( $Self->{ACLDebug} ) {
                $Self->{LogObject}->Log(
                    Priority => $Self->{ACLDebugLogPriority},
                    Message =>
                        "TicketACL '$Acl' Matched for return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                );
            }
        }

        my %SpecialReturnTypes = (
            Action         => 1,
            Process        => 1,
            ActivityDialog => 1,
        );

        if ( $SpecialReturnTypes{ $Param{ReturnType} } ) {

            # build new Special ReturnType data hash (ProcessManagement)
            # for Special ReturnType Step{Possible}
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{Possible}->{ $Param{ReturnType} }
                && IsArrayRefWithData( $Step{Possible}->{ $Param{ReturnType} } )
                )
            {
                $UseNewParams = 1;

                # reset return data as it will be filled with just the Possible Items excluded the
                #    ones that are not in the possible section, this is the same as remove all
                #    missing items from the original data
                %NewTmpData = ();

                # debug log
                if ( $Self->{ADLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with Possible:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Reset return data:'$Param{ReturnType}:$Param{ReturnSubType}''",
                    );
                }

                # possible list
                for my $ID ( sort keys %Data ) {

                    for my $New ( @{ $Step{Possible}->{ $Param{ReturnType} } } ) {
                        my $MatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $MatchResult->{Match} ) {
                            $NewTmpData{$ID} = $Data{$ID};
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' Possible param '$Data{$ID}' added to return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                        else {
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' Possible param '$Data{$ID}' skipped from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                    }
                }
            }

            # for Special ReturnType Step{PossibleAdd}
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{PossibleAdd}->{ $Param{ReturnType} }
                && IsArrayRefWithData( $Step{PossibleAdd}->{ $Param{ReturnType} } )
                )
            {

                $UseNewParams = 1;

                # debug log
                if ( $Self->{ACLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with PossibleAdd:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                }

                # possible add list
                for my $ID ( sort keys %Data ) {

                    for my $New ( @{ $Step{PossibleAdd}->{ $Param{ReturnType} } } ) {
                        my $MatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $MatchResult->{Match} ) {
                            $NewTmpData{$ID} = $Data{$ID};
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' PossibleAdd param '$Data{$ID}' added to return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                        else {
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' PossibleAdd param '$Data{$ID}' skipped from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                    }
                }
            }

            # for Special Step{PossibleNot}
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{PossibleNot}->{ $Param{ReturnType} }
                && IsArrayRefWithData( $Step{PossibleNot}->{ $Param{ReturnType} } )
                )
            {

                $UseNewParams = 1;

                # debug log
                if ( $Self->{ACLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with PossibleNot:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                }

                # not possible list
                for my $ID ( sort keys %Data ) {
                    my $Match = 1;
                    for my $New ( @{ $Step{PossibleNot}->{ $Param{ReturnType} } } ) {
                        my $LoopMatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $LoopMatchResult->{Match} ) {
                            $Match = 0;
                        }
                    }
                    if ( !$Match ) {
                        if ( $Self->{ACLDebug} ) {
                            $Self->{LogObject}->Log(
                                Priority => $Self->{ACLDebugLogPriority},
                                Message =>
                                    "TicketACL '$Acl' PossibleNot param '$Data{$ID}' removed from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                            );
                        }
                        if ( $NewTmpData{$ID} ) {
                            delete $NewTmpData{$ID};
                        }
                    }
                    else {
                        if ( $Self->{ACLDebug} ) {
                            $Self->{LogObject}->Log(
                                Priority => $Self->{ACLDebugLogPriority},
                                Message =>
                                    "TicketACL '$Acl' PossibleNot param '$Data{$ID}' leaved for return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                            );
                        }
                    }
                }
            }
        }

        elsif ( $Param{ReturnType} eq 'Ticket' ) {

            # build new ticket data hash
            # Step Ticket Possible (Resets White list)
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{Possible}->{Ticket}->{ $Param{ReturnSubType} }
                )
            {
                $UseNewParams = 1;

           # reset return data as it will be filled with just the Possible Items excluded the ones
           # that are not in the possible section, this is the same as remove all missing items from
           # the original data
                %NewTmpData = ();

                # debug log
                if ( $Self->{ACLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with Possible:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Reset return data:'$Param{ReturnType}:$Param{ReturnSubType}''",
                    );
                }

                # possible list
                for my $ID ( sort keys %Data ) {

                    for my $New ( @{ $Step{Possible}->{Ticket}->{ $Param{ReturnSubType} } } ) {
                        my $MatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $MatchResult->{Match} ) {
                            $NewTmpData{$ID} = $Data{$ID};
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' Possible param '$Data{$ID}' added to return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                        else {
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' Possible param '$Data{$ID}' skipped from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                    }
                }
            }

            # Step Ticket PossibleAdd (Add new options to the white list)
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{PossibleAdd}->{Ticket}->{ $Param{ReturnSubType} }
                )
            {
                $UseNewParams = 1;

                # debug log
                if ( $Self->{ACLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with PossibleAdd:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                }

                # possible add list
                for my $ID ( sort keys %Data ) {

                    for my $New ( @{ $Step{PossibleAdd}->{Ticket}->{ $Param{ReturnSubType} } } ) {
                        my $MatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $MatchResult->{Match} ) {
                            $NewTmpData{$ID} = $Data{$ID};
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' PossibleAdd param '$Data{$ID}' added to return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                        else {
                            if ( $Self->{ACLDebug} ) {
                                $Self->{LogObject}->Log(
                                    Priority => $Self->{ACLDebugLogPriority},
                                    Message =>
                                        "TicketACL '$Acl' PossibleAdd param '$Data{$ID}' skipped from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                                );
                            }
                        }
                    }
                }
            }

            # Step Ticket PossibleNot (removes options from white list)
            if (
                ( %Checks || %ChecksDatabase )
                && $Match
                && $MatchTry
                && $Step{PossibleNot}->{Ticket}->{ $Param{ReturnSubType} }
                )
            {
                $UseNewParams = 1;

                # debug log
                if ( $Self->{ACLDebug} ) {
                    $Self->{LogObject}->Log(
                        Priority => $Self->{ACLDebugLogPriority},
                        Message =>
                            "TicketACL '$Acl' Used with PossibleNot:'$Param{ReturnType}:$Param{ReturnSubType}'",
                    );
                }

                # not possible list
                for my $ID ( sort keys %Data ) {
                    my $Match = 1;
                    for my $New ( @{ $Step{PossibleNot}->{Ticket}->{ $Param{ReturnSubType} } } ) {
                        my $LoopMatchResult = $Self->_CompareMatchWithData(
                            Match      => $New,
                            Data       => $Data{$ID},
                            SingleItem => 1
                        );
                        if ( $LoopMatchResult->{Match} ) {
                            $Match = 0;
                        }
                    }
                    if ( !$Match ) {
                        if ( $Self->{ACLDebug} ) {
                            $Self->{LogObject}->Log(
                                Priority => $Self->{ACLDebugLogPriority},
                                Message =>
                                    "TicketACL '$Acl' PossibleNot param '$Data{$ID}' removed from return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                            );
                        }
                        if ( $NewTmpData{$ID} ) {
                            delete $NewTmpData{$ID};
                        }
                    }
                    else {
                        if ( $Self->{ACLDebug} ) {
                            $Self->{LogObject}->Log(
                                Priority => $Self->{ACLDebugLogPriority},
                                Message =>
                                    "TicketACL '$Acl' PossibleNot param '$Data{$ID}' leaved for return data:'$Param{ReturnType}:$Param{ReturnSubType}'",
                            );
                        }
                    }
                }
            }
        }

        # remember to new params if given
        if ($UseNewParams) {
            %NewData            = %NewTmpData;
            $UseNewMasterParams = 1;
        }

        # return new params if stop after this step
        if ( $UseNewParams && $Step{StopAfterMatch} ) {
            $Self->{TicketAclData} = \%NewData;

            # if we stop after the first match
            # exit the ACLRULES loop
            last ACLRULES;
        }
    }

    # return if no new param exists
    return if !$UseNewMasterParams;

    $Self->{TicketAclData} = \%NewData;

    return 1;
}

=item TicketAclData()

return the current ACL data hash after TicketAcl()

    my %Acl = $TicketObject->TicketAclData();

=cut

sub TicketAclData {
    my ( $Self, %Param ) = @_;

    return %{ $Self->{TicketAclData} || {} };
}

=item TicketAclActionData()

return the current ACL action data hash after TicketAcl()

    my %AclAction = $TicketObject->TicketAclActionData();

=cut

sub TicketAclActionData {
    my ( $Self, %Param ) = @_;

    if ( $Self->{TicketAclData} ) {
        return %{ $Self->{TicketAclData} };
    }
    return %{ $Self->{DefaultTicketActionData} || {} };
}

=begin Internal:

=cut

=item _GetChecks()

creates two check hashes (one for current data updatable via AJAX refreshes and another for
static ticket data stored in the DB) with the required data to use as a basis to match the ACLs

    my $ChecskResult = $TicketObject->_GetChecks(
        CheckAll => '1',                              # Optional
        RequiredChecks => $RequiredCheckHashRef,      # Optional a hash reference with the
                                                      #    attributes to gather:
                                                      #    e. g. User => 1, will fetch all user
                                                      #    information from the database, this data
                                                      #    will be tried to match with current ACLs
        Action        => 'AgentTicketZoom',           # Optional
        TicketID      => 123,                         # Optional
        DynamicField  => {                            # Optional
            DynamicField_NameX => 123,
            DynamicField_NameZ => 'some value',
        },

        QueueID          => 123,                      # Optional
        Queue            => 'some queue name',        # Optional

        ServiceID        => 123,                      # Optional
        Service          => 'some service name',      # Optional

        TypeID           => 123,
        Type             => 'some ticket type name',  # Optional

        PriorityID       => 123,                      # Optional
        NewPriorityID    => 123,                      # Optional, PriorityID or NewPriorityID can be
                                                      #   used and they both refers to PriorityID
        Priority         => 'some priority name',     # Optional

        SLAID            => 123,
        SLA              => 'some SLA name',          # Optional

        StateID          => 123,                      # Optional
        NextStateID      => 123,                      # Optional, StateID or NextStateID can be
                                                      #   used and they both refers to StateID
        State            => 'some ticket state name', # Optional

        OwnerID          => 123,                      # Optional
        NewOwnerID       => 123,                      # Optional, OwnerID or NewOwnerID can be
                                                      #   used and they both refers to OwnerID
        Owner            => 'some user login'         # Optional

        ResponsibleID    => 123,                      # Optional
        NewResponsibleID => 123,                      # Optional, ResponsibleID or NewResposibleID
                                                      #   can be used and they both refers to
                                                      #     ResponsibleID
        Responsible      => 'some user login'         # Optional

        UserID         => 123,                        # UserID => 1 is not affected by this function
        CustomerUserID => 'customer login',           # UserID or CustomerUserID are mandatory

        # Process Management Parameters
        ProcessEntityID        => 123,                # Optional
        ActivityEntityID       => 123,                # Optional
        ActivityDialogEntityID => 123,                # Optional
    );

returns:
    $ChecksResult = {
        Checks => {
            # ...
            Ticket => {
                TicketID => 123,
                # ...
                Queue   => 'some queue name',
                QueueID => '123',
                # ...
            },
            Queue => {
                Name => 'some queue name',
                # ...
            },
            # ...
        },
        ChecksDatabase =>
            # ...
            Ticket => {
                TicketID => 123,
                # ...
                Queue   => 'original queue name',
                QueueID => '456',
                # ...
            },
            Queue => {
                Name => 'original queue name',
                # ...
            },
            # ...
        },
    };

=cut

sub _GetChecks {
    my ( $Self, %Param ) = @_;

    my $CheckAll       = $Param{CheckAll};
    my %RequiredChecks = %{ $Param{RequiredChecks} };

    # get used interface for process management checks
    my $Interface = 'AgentInterface';
    if ( !$Param{UserID} ) {
        $Interface = 'CustomerInterface';
    }

    my %Checks;
    my %ChecksDatabase;

    if ( $Param{Action} ) {
        $Checks{Frontend}         = { Action => $Param{Action}, };
        $ChecksDatabase{Frontend} = { Action => $Param{Action}, };
    }

    # use ticket data if ticket id is given
    # do that always, even if $RequiredChecks{Ticket} is not that
    # (because too much stuff depends on it)
    if ( $Param{TicketID} ) {
        my %Ticket = $Self->TicketGet(
            %Param,
            DynamicFields => 1,
        );
        $Checks{Ticket} = \%Ticket;

        # keep database ticket data separated since the reference is affected below
        my %TicketDatabase = %Ticket;
        $ChecksDatabase{Ticket} = \%TicketDatabase;

        # get used dynamic fields where Activity and Process Entities IDs are Stored
        # (ProcessManagement)
        my $ActivityEntityIDField
            = $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementActivityID");
        my $ProcessEntityIDField
            = $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementProcessID");

        # check for ActivityEntityID
        if ( $Ticket{ 'DynamicField_' . $ActivityEntityIDField } ) {
            $ChecksDatabase{Process}->{ActivityEntityID}
                = $Ticket{ 'DynamicField_' . $ActivityEntityIDField };
        }

        # check for ProcessEntityID
        if ( $Ticket{ 'DynamicField_' . $ProcessEntityIDField } ) {
            $ChecksDatabase{Process}->{ProcessEntityID}
                = $Ticket{ 'DynamicField_' . $ProcessEntityIDField };
        }

        # take over the ChecksDatabase to the Checks hash as basis
        if ( $ChecksDatabase{Process} && %{ $ChecksDatabase{Process} } ) {
            my %ProcessDatabase = %{ $ChecksDatabase{Process} };
            $Checks{Process} = \%ProcessDatabase;
        }
    }

    # check for ProcessEntityID if set as parameter (ProcessManagement)
    if ( ( $CheckAll || $RequiredChecks{Process} ) && $Param{ProcessEntityID} ) {
        $Checks{Process}->{ProcessEntityID} = $Param{ProcessEntityID};
    }

    # check for ActivityDialogEntityID if set as parameter (ProcessManagement)
    if ( ( $CheckAll || $RequiredChecks{Process} ) && $Param{ActivityDialogEntityID} ) {
        my $ActivityDialog = $Self->{ActivityDialogObject}->ActivityDialogGet(
            ActivityDialogEntityID => $Param{ActivityDialogEntityID},
            Interface              => $Interface,
        );
        if ( IsHashRefWithData($ActivityDialog) ) {
            $Checks{Process}->{ActivityDialogEntityID} = $Param{ActivityDialogEntityID};
        }
    }

    # check for dynamic fields
    if ( IsHashRefWithData( $Param{DynamicField} ) ) {
        $Checks{DynamicField} = $Param{DynamicField};

        # update or add dynamic fields information to the ticket check
        for my $DynamicFieldName ( sort keys %{ $Param{DynamicField} } ) {
            $Checks{Ticket}->{$DynamicFieldName} = $Param{DynamicField}->{$DynamicFieldName};
        }
    }

    # always get info from ticket too and set it to the Dynamic Field check hash if the info is
    # different. this can be done because in the previous step ticket info was updated. but maybe
    # ticket has more information stored than in the DynamicField parameter.
    TICKETATTRIBUTE:
    for my $TicketAttribute ( sort keys %{ $Checks{Ticket} // {} } ) {
        next TICKETATTRIBUTE if !$TicketAttribute;

        # check if is a dynamic field with data
        next TICKETATTRIBUTE if $TicketAttribute !~ m{ \A DynamicField_ }smx;
        next TICKETATTRIBUTE if !$Checks{Ticket}->{$TicketAttribute};
        next TICKETATTRIBUTE if
            ref $Checks{Ticket}->{$TicketAttribute} eq 'ARRAY'
            && !IsArrayRefWithData( $Checks{Ticket}->{$TicketAttribute} );

        # compare if data is different and skip on same data
        if ( $Checks{DynamicField}->{$TicketAttribute} ) {
            next TICKETATTRIBUTE if !DataIsDifferent(
                Data1 => $Checks{Ticket}->{$TicketAttribute},
                Data2 => $Checks{DynamicField}->{$TicketAttribute},
            );
        }

        $Checks{DynamicField}->{$TicketAttribute} = $Checks{Ticket}->{$TicketAttribute};
    }

    # also copy the database information to the appropriate hash
    TICKETATTRIBUTE:
    for my $TicketAttribute ( sort keys %{ $ChecksDatabase{Ticket} } ) {
        next TICKETATTRIBUTE if !$TicketAttribute;

        # check if is a dynamic field with data
        next TICKETATTRIBUTE if $TicketAttribute !~ m{ \A DynamicField_ }smx;
        next TICKETATTRIBUTE if !$ChecksDatabase{Ticket}->{$TicketAttribute};
        next TICKETATTRIBUTE if
            ref $ChecksDatabase{Ticket}->{$TicketAttribute} eq 'ARRAY'
            && !IsArrayRefWithData( $ChecksDatabase{Ticket}->{$TicketAttribute} );

        $ChecksDatabase{DynamicField}->{$TicketAttribute}
            = $ChecksDatabase{Ticket}->{$TicketAttribute};
    }

    # use user data
    if ( ( $CheckAll || $RequiredChecks{User} ) && $Param{UserID} ) {
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{UserID},
        );
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my @Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Param{UserID},
                Result => 'Name',
                Type   => $Type,
            );
            $User{"Group_$Type"} = \@Groups;
        }

        my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
            UserID => $Param{UserID},
            Result => 'ID',
        );
        my @Roles;
        ROLEID:
        for my $RoleID (@RoleIDs) {
            my $RoleName = $Self->{GroupObject}->RoleLookup(
                RoleID => $RoleID,
            );
            next ROLEID if !$RoleName;
            push @Roles, $RoleName;
        }
        $User{Role} = \@Roles;

        $Checks{User}         = \%User;
        $ChecksDatabase{User} = \%User;
    }

    # use customer user data
    if ( ( $CheckAll || $RequiredChecks{CustomerUser} ) && $Param{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Param{CustomerUserID},
        );
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my @Groups = $Self->{CustomerGroupObject}->GroupMemberList(
                UserID => $Param{CustomerUserID},
                Result => 'Name',
                Type   => $Type,
            );
            $CustomerUser{"Group_$Type"} = \@Groups;
        }
        $Checks{CustomerUser} = \%CustomerUser;

        # update or add customer information to the ticket check
        $Checks{Ticket}->{CustomerUserID} = $Checks{CustomerUser}->{UserLogin};
        $Checks{Ticket}->{CustomerID}     = $Checks{CustomerUser}->{UserCustomerID};
    }
    else {
        if ( IsStringWithData( $Checks{Ticket}->{CustomerUserID} ) ) {

            # get customer data from the ticket
            my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Checks{Ticket}->{CustomerUserID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
                my @Groups = $Self->{CustomerGroupObject}->GroupMemberList(
                    UserID => $Checks{Ticket}->{CustomerUserID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $CustomerUser{"Group_$Type"} = \@Groups;
            }
            $Checks{CustomerUser} = \%CustomerUser;
        }
    }

    # create hash with the ticket information stored in the database
    if (
        ( $CheckAll || $RequiredChecks{CustomerUser} )
        && IsStringWithData( $ChecksDatabase{Ticket}->{CustomerUserID} )
        )
    {

        # check if database data matches current data (performance)
        if (
            defined $Checks{CustomerUser}->{UserLogin}
            && $ChecksDatabase{Ticket}->{CustomerUserID} eq $Checks{CustomerUser}->{UserLogin}
            )
        {
            $ChecksDatabase{CustomerUser} = $Checks{CustomerUser};
        }

        # otherwise complete the data querying the database again
        else {
            my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $ChecksDatabase{Ticket}->{CustomerUserID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
                my @Groups = $Self->{CustomerGroupObject}->GroupMemberList(
                    UserID => $ChecksDatabase{Ticket}->{CustomerUserID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $CustomerUser{"Group_$Type"} = \@Groups;
            }
            $ChecksDatabase{CustomerUser} = \%CustomerUser;
        }
    }

    # use queue data (if given)
    if ( $CheckAll || $RequiredChecks{Queue} ) {
        if ( $Param{QueueID} ) {
            my %Queue = $Self->{QueueObject}->QueueGet( ID => $Param{QueueID} );
            $Checks{Queue} = \%Queue;

            # update or add queue information to the ticket check
            $Checks{Ticket}->{Queue}   = $Checks{Queue}->{Name};
            $Checks{Ticket}->{QueueID} = $Checks{Queue}->{QueueID};
        }
        elsif ( $Param{Queue} ) {
            my %Queue = $Self->{QueueObject}->QueueGet( Name => $Param{Queue} );
            $Checks{Queue} = \%Queue;

            # update or add queue information to the ticket check
            $Checks{Ticket}->{Queue}   = $Checks{Queue}->{Name};
            $Checks{Ticket}->{QueueID} = $Checks{Queue}->{QueueID};
        }
        elsif ( !$Param{QueueID} && !$Param{Queue} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{QueueID} ) ) {

                # get queue data from the ticket
                my %Queue = $Self->{QueueObject}->QueueGet( ID => $Checks{Ticket}->{QueueID} );
                $Checks{Queue} = \%Queue;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if (
        ( $CheckAll || $RequiredChecks{Queue} )
        && IsPositiveInteger( $ChecksDatabase{Ticket}->{QueueID} )
        )
    {

        # check if database data matches current data (performance)
        if (
            defined $Checks{Queue}->{QueueID}
            && $ChecksDatabase{Ticket}->{QueueID} eq $Checks{Queue}->{QueueID}
            )
        {
            $ChecksDatabase{Queue} = $Checks{Queue};
        }

        # otherwise complete the data querying the database again
        else {
            my %Queue = $Self->{QueueObject}->QueueGet( ID => $ChecksDatabase{Ticket}->{QueueID} );
            $ChecksDatabase{Queue} = \%Queue;
        }
    }

    # use service data (if given)
    if ( $CheckAll || $RequiredChecks{Service} ) {
        if ( $Param{ServiceID} ) {
            my %Service = $Self->{ServiceObject}->ServiceGet(
                ServiceID => $Param{ServiceID},
                UserID    => 1,
            );
            $Checks{Service} = \%Service;

            # update or add service information to the ticket check
            $Checks{Ticket}->{Service}   = $Checks{Service}->{Name};
            $Checks{Ticket}->{ServiceID} = $Checks{Service}->{ServiceID};
        }
        elsif ( $Param{Service} ) {
            my %Service = $Self->{ServiceObject}->ServiceGet(
                Name   => $Param{Service},
                UserID => 1,
            );
            $Checks{Service} = \%Service;

            # update or add service information to the ticket check
            $Checks{Ticket}->{Service}   = $Checks{Service}->{Name};
            $Checks{Ticket}->{ServiceID} = $Checks{Service}->{ServiceID};
        }
        elsif ( !$Param{ServiceID} && !$Param{Service} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{ServiceID} ) ) {

                # get service data from the ticket
                my %Service = $Self->{ServiceObject}->ServiceGet(
                    ServiceID => $Checks{Ticket}->{ServiceID},
                    UserID    => 1,
                );
                $Checks{Service} = \%Service;
            }
        }

        # create hash with the ticket information stored in the database
        if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{ServiceID} ) ) {

            # check if database data matches current data (performance)
            if (
                defined $Checks{Queue}->{QueueID}
                && $ChecksDatabase{Ticket}->{ServiceID} eq $Checks{Service}->{ServiceID}
                )
            {
                $ChecksDatabase{Service} = $Checks{Service};
            }

            # otherwise complete the data querying the database again
            else {
                my %Service = $Self->{ServiceObject}->ServiceGet(
                    ServiceID => $ChecksDatabase{Ticket}->{ServiceID},
                    UserID    => 1,
                );
                $ChecksDatabase{Service} = \%Service;
            }
        }
    }

    # use type data (if given)
    if ( $CheckAll || $RequiredChecks{Type} ) {
        if ( $Param{TypeID} ) {
            my %Type = $Self->{TypeObject}->TypeGet(
                ID     => $Param{TypeID},
                UserID => 1,
            );
            $Checks{Type} = \%Type;

            # update or add ticket type information to the ticket check
            $Checks{Ticket}->{Type}   = $Checks{Type}->{Name};
            $Checks{Ticket}->{TypeID} = $Checks{Type}->{ID};
        }
        elsif ( $Param{Type} ) {

       # TODO Attention!
       #
       # The parameter type can contain not only the wanted ticket type, because also
       # some other functions in Kernel/System/Ticket.pm use a type parameter, for example
       # MoveList() etc... These functions could be rewritten to not
       # use a Type parameter, or the functions that call TicketAcl() could be modified to
       # not just pass the complete Param-Hash, but instead a new parameter, like FrontEndParameter.
       #
       # As a workaround we lookup the TypeList first, and compare if the type parameter
       # is found in the list, so we can be more sure that it is the type that we want here.

            # lookup the type list (workaround for described problem)
            my %TypeList = reverse $Self->{TypeObject}->TypeList();

            # check if type is in the type list (workaround for described problem)
            if ( $TypeList{ $Param{Type} } ) {
                my %Type = $Self->{TypeObject}->TypeGet(
                    Name   => $Param{Type},
                    UserID => 1,
                );
                $Checks{Type} = \%Type;

                # update or add ticket type information to the ticket check
                $Checks{Ticket}->{Type}   = $Checks{Type}->{Name};
                $Checks{Ticket}->{TypeID} = $Checks{Type}->{ID};
            }
        }
        elsif ( !$Param{TypeID} && !$Param{Type} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{TypeID} ) ) {

                # get type data from the ticket
                my %Type = $Self->{TypeObject}->TypeGet(
                    ID     => $Checks{Ticket}->{TypeID},
                    UserID => 1,
                );
                $Checks{Type} = \%Type;
            }
        }

        # create hash with the ticket information stored in the database
        if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{TypeID} ) ) {

            # check if database data matches current data (performance)
            if (
                defined $Checks{Type}->{ID}
                && $ChecksDatabase{Ticket}->{TypeID} eq $Checks{Type}->{ID}
                )
            {
                $ChecksDatabase{Type} = $Checks{Type};
            }

            # otherwise complete the data querying the database again
            else {
                my %Type = $Self->{TypeObject}->TypeGet(
                    ID     => $ChecksDatabase{Ticket}->{TypeID},
                    UserID => 1,
                );
                $ChecksDatabase{Type} = \%Type;
            }
        }
    }

    if ( $CheckAll || $RequiredChecks{Priority} ) {

        # use priority data (if given)
        if ( $Param{NewPriorityID} && !$Param{PriorityID} ) {
            $Param{PriorityID} = $Param{NewPriorityID}
        }
        if ( $Param{PriorityID} ) {
            my %Priority = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $Param{PriorityID},
                UserID     => 1,
            );
            $Checks{Priority} = \%Priority;

            # update or add priority information to the ticket check
            $Checks{Ticket}->{Priority}   = $Checks{Priority}->{Name};
            $Checks{Ticket}->{PriorityID} = $Checks{Priority}->{ID};
        }
        elsif ( $Param{Priority} ) {
            my $PriorityID = $Self->{PriorityObject}->PriorityLookup(
                Priority => $Param{Priority},
            );
            my %Priority = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $PriorityID,
                UserID     => 1,
            );
            $Checks{Priority} = \%Priority;

            # update or add priority information to the ticket check
            $Checks{Ticket}->{Priority}   = $Checks{Priority}->{Name};
            $Checks{Ticket}->{PriorityID} = $Checks{Priority}->{ID};
        }
        elsif ( !$Param{PriorityID} && !$Param{Priority} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{PriorityID} ) ) {

                # get priority data from the ticket
                my %Priority = $Self->{PriorityObject}->PriorityGet(
                    PriorityID => $Checks{Ticket}->{PriorityID},
                    UserID     => 1,
                );
                $Checks{Priority} = \%Priority;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{PriorityID} ) ) {

        # check if database data matches current data (performance)
        if (
            defined $Checks{Priority}->{ID}
            && $ChecksDatabase{Ticket}->{PriorityID} eq $Checks{Priority}->{ID}
            )
        {
            $ChecksDatabase{Priority} = $Checks{Priority};
        }

        # otherwise complete the data querying the database again
        else {

            # get priority data from the ticket
            my %Priority = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $ChecksDatabase{Ticket}->{PriorityID},
                UserID     => 1,
            );
            $ChecksDatabase{Priority} = \%Priority;
        }
    }

    # use SLA data (if given)
    if ( $CheckAll || $RequiredChecks{SLA} ) {
        if ( $Param{SLAID} ) {
            my %SLA = $Self->{SLAObject}->SLAGet(
                SLAID  => $Param{SLAID},
                UserID => 1,
            );
            $Checks{SLA} = \%SLA;

            # update or add SLA information to the ticket check
            $Checks{Ticket}->{SLA}   = $Checks{SLA}->{Name};
            $Checks{Ticket}->{SLAID} = $Checks{SLA}->{SLAID};
        }
        elsif ( $Param{SLA} ) {
            my $SLAID = $Self->{SLAObject}->SLALookup(
                Name => $Param{SLA},
            );
            my %SLA = $Self->{SLAObject}->SLAGet(
                SLAID  => $SLAID,
                UserID => 1,
            );
            $Checks{SLA} = \%SLA;

            # update or add SLA information to the ticket check
            $Checks{Ticket}->{SLA}   = $Checks{SLA}->{Name};
            $Checks{Ticket}->{SLAID} = $Checks{SLA}->{SLAID};
        }
        elsif ( !$Param{SLAID} && !$Param{SLA} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{SLAID} ) ) {

                # get SLA data from the ticket
                my %SLA = $Self->{SLAObject}->SLAGet(
                    SLAID  => $Checks{Ticket}->{SLAID},
                    UserID => 1,
                );
                $Checks{SLA} = \%SLA;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{SLAID} ) ) {

        # check if database data matches current data (performance)
        if (
            defined $Checks{SLA}->{SLAID}
            && $ChecksDatabase{Ticket}->{SLAID} eq $Checks{SLA}->{SLAID}
            )
        {
            $ChecksDatabase{SLA} = $Checks{SLA};
        }

        # otherwise complete the data querying the database again
        else {
            my %SLA = $Self->{SLAObject}->SLAGet(
                SLAID  => $ChecksDatabase{Ticket}->{SLAID},
                UserID => 1,
            );
            $ChecksDatabase{SLA} = \%SLA;
        }
    }

    # use state data (if given)
    if ( $CheckAll || $RequiredChecks{State} ) {
        if ( $Param{NextStateID} && !$Param{StateID} ) {
            $Param{StateID} = $Param{NextStateID}
        }
        if ( $Param{StateID} ) {
            my %State = $Self->{StateObject}->StateGet(
                ID     => $Param{StateID},
                UserID => 1,
            );
            $Checks{State} = \%State;

            # update or add state information to the ticket check
            $Checks{Ticket}->{State}     = $Checks{State}->{Name};
            $Checks{Ticket}->{StateID}   = $Checks{State}->{ID};
            $Checks{Ticket}->{StateType} = $Checks{State}->{TypeName};
        }
        elsif ( $Param{State} ) {
            my %State = $Self->{StateObject}->StateGet(
                Name   => $Param{State},
                UserID => 1,
            );
            $Checks{State} = \%State;

            # update or add state information to the ticket check
            $Checks{Ticket}->{State}     = $Checks{State}->{Name};
            $Checks{Ticket}->{StateID}   = $Checks{State}->{ID};
            $Checks{Ticket}->{StateType} = $Checks{State}->{TypeName};
        }
        elsif ( !$Param{StateID} && !$Param{State} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{StateID} ) ) {

                # get state data from the ticket
                my %State = $Self->{StateObject}->StateGet(
                    ID     => $Checks{Ticket}->{StateID},
                    UserID => 1,
                );
                $Checks{State} = \%State;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{StateID} ) ) {

        # check if database data matches current data (performance)
        if (
            defined $Checks{State}->{ID}
            && $ChecksDatabase{Ticket}->{StateID} eq $Checks{State}->{ID}
            )
        {
            $ChecksDatabase{State} = $Checks{State};
        }

        # otherwise complete the data querying the database again
        else {
            my %State = $Self->{StateObject}->StateGet(
                ID     => $ChecksDatabase{Ticket}->{StateID},
                UserID => 1,
            );
            $ChecksDatabase{State} = \%State;
        }
    }

    # use owner data (if given)
    if ( $CheckAll || $RequiredChecks{Owner} ) {
        if (
            $Param{NewOwnerID}
            && !$Param{OwnerID}
            && defined $Param{NewOwnerType}
            && $Param{NewOwnerType} eq 'New'
            )
        {
            $Param{OwnerID} = $Param{NewOwnerID};
        }
        elsif (
            $Param{OldOwnerID}
            && !$Param{OwnerID}
            && defined $Param{NewOwnerType}
            && $Param{NewOwnerType} eq 'Old'
            )
        {
            $Param{OwnerID} = $Param{OldOwnerID};
        }

        if ( $Param{OwnerID} ) {
            my %Owner = $Self->{UserObject}->GetUserData(
                UserID => $Param{OwnerID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $Param{OwnerID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $Owner{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $Param{OwnerID},
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Owner{Role} = \@Roles;

            $Checks{Owner} = \%Owner;

            # update or add owner information to the ticket check
            $Checks{Ticket}->{Owner}   = $Checks{Owner}->{UserLogin};
            $Checks{Ticket}->{OwnerID} = $Checks{Owner}->{UserID};
        }
        elsif ( $Param{Owner} ) {
            my $OwnerID = $Self->{UserObject}->UserLookup(
                UserLogin => $Param{Owner},
            );
            my %Owner = $Self->{UserObject}->GetUserData(
                UserID => $OwnerID,
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $OwnerID,
                    Result => 'Name',
                    Type   => $Type,
                );
                $Owner{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $OwnerID,
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Owner{Role} = \@Roles;

            $Checks{Owner} = \%Owner;

            # update or add owner information to the ticket check
            $Checks{Ticket}->{Owner}   = $Checks{Owner}->{UserLogin};
            $Checks{Ticket}->{OwnerID} = $Checks{Owner}->{UserID};
        }
        elsif ( !$Param{OwnerID} && !$Param{Owner} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{OwnerID} ) ) {

                # get responsible data from the ticket
                my %Owner = $Self->{UserObject}->GetUserData(
                    UserID => $Checks{Ticket}->{OwnerID},
                );
                for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                    my @Groups = $Self->{GroupObject}->GroupMemberList(
                        UserID => $Checks{Ticket}->{OwnerID},
                        Result => 'Name',
                        Type   => $Type,
                    );
                    $Owner{"Group_$Type"} = \@Groups;
                }

                my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                    UserID => $Checks{Ticket}->{OwnerID},
                    Result => 'ID',
                );
                my @Roles;
                ROLEID:
                for my $RoleID (@RoleIDs) {
                    my $RoleName = $Self->{GroupObject}->RoleLookup(
                        RoleID => $RoleID,
                    );
                    next ROLEID if !$RoleName;
                    push @Roles, $RoleName;
                }
                $Owner{Role} = \@Roles;

                $Checks{Owner} = \%Owner;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{OwnerID} ) ) {

        # check if database data matches current data (performance)
        if (
            defined $Checks{Owner}->{UserID}
            && $ChecksDatabase{Ticket}->{OwnerID} eq $Checks{Owner}->{UserID}
            )
        {
            $ChecksDatabase{Owner} = $Checks{Owner};
        }

        # otherwise complete the data querying the database again
        else {
            my %Owner = $Self->{UserObject}->GetUserData(
                UserID => $ChecksDatabase{Ticket}->{OwnerID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $ChecksDatabase{Ticket}->{OwnerID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $Owner{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $ChecksDatabase{Ticket}->{OwnerID},
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Owner{Role} = \@Roles;

            $ChecksDatabase{Owner} = \%Owner;
        }
    }

    # use responsible data (if given)
    $Param{ResponsibleID} ||= $Param{NewResponsibleID};

    if ( $CheckAll || $RequiredChecks{Responsible} ) {
        if ( $Param{ResponsibleID} ) {
            my %Responsible = $Self->{UserObject}->GetUserData(
                UserID => $Param{ResponsibleID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $Param{ResponsibleID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $Responsible{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $Param{ResponsibleID},
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Responsible{Role} = \@Roles;

            $Checks{Responsible} = \%Responsible;

            # update or add responsible information to the ticket check
            $Checks{Ticket}->{Responsible}   = $Checks{Responsible}->{UserLogin};
            $Checks{Ticket}->{ResponsibleID} = $Checks{Responsible}->{UserID};
        }
        elsif ( $Param{Responsible} ) {
            my $ResponsibleID = $Self->{UserObject}->UserLookup(
                UserLogin => $Param{Responsible},
            );
            my %Responsible = $Self->{UserObject}->GetUserData(
                UserID => $ResponsibleID,
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $ResponsibleID,
                    Result => 'Name',
                    Type   => $Type,
                );
                $Responsible{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $ResponsibleID,
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Responsible{Role} = \@Roles;

            $Checks{Responsible} = \%Responsible;

            # update or add responsible information to the ticket check
            $Checks{Ticket}->{Responsible}   = $Checks{Responsible}->{UserLogin};
            $Checks{Ticket}->{ResponsibleID} = $Checks{Responsible}->{UserID};
        }
        elsif ( !$Param{ResponsibleID} && !$Param{Responsible} ) {
            if ( IsPositiveInteger( $Checks{Ticket}->{ResponsibleID} ) ) {

                # get responsible data from the ticket
                my %Responsible = $Self->{UserObject}->GetUserData(
                    UserID => $Checks{Ticket}->{ResponsibleID},
                );
                for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                    my @Groups = $Self->{GroupObject}->GroupMemberList(
                        UserID => $Checks{Ticket}->{ResponsibleID},
                        Result => 'Name',
                        Type   => $Type,
                    );
                    $Responsible{"Group_$Type"} = \@Groups;
                }

                my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                    UserID => $Checks{Ticket}->{ResponsibleID},
                    Result => 'ID',
                );
                my @Roles;
                ROLEID:
                for my $RoleID (@RoleIDs) {
                    my $RoleName = $Self->{GroupObject}->RoleLookup(
                        RoleID => $RoleID,
                    );
                    next ROLEID if !$RoleName;
                    push @Roles, $RoleName;
                }
                $Responsible{Role} = \@Roles;

                $Checks{Responsible} = \%Responsible;
            }
        }
    }

    # create hash with the ticket information stored in the database
    if ( IsPositiveInteger( $ChecksDatabase{Ticket}->{ResponsibleID} ) ) {

        # check if database data matches current data (performance)
        if (
            defined $Checks{Owner}->{UserID}
            && defined $Checks{Responsible}->{UserID}
            && $ChecksDatabase{Ticket}->{ResponsibleID} eq $Checks{Responsible}->{UserID}
            )
        {
            $ChecksDatabase{Responsible} = $Checks{Responsible};
        }

        # otherwise complete the data querying the database again
        else {
            my %Responsible = $Self->{UserObject}->GetUserData(
                UserID => $ChecksDatabase{Ticket}->{ResponsibleID},
            );
            for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
                my @Groups = $Self->{GroupObject}->GroupMemberList(
                    UserID => $ChecksDatabase{Ticket}->{ResponsibleID},
                    Result => 'Name',
                    Type   => $Type,
                );
                $Responsible{"Group_$Type"} = \@Groups;
            }

            my @RoleIDs = $Self->{GroupObject}->GroupUserRoleMemberList(
                UserID => $ChecksDatabase{Ticket}->{ResponsibleID},
                Result => 'ID',
            );
            my @Roles;
            ROLEID:
            for my $RoleID (@RoleIDs) {
                my $RoleName = $Self->{GroupObject}->RoleLookup(
                    RoleID => $RoleID,
                );
                next ROLEID if !$RoleName;
                push @Roles, $RoleName;
            }
            $Responsible{Role} = \@Roles;

            $ChecksDatabase{Responsible} = \%Responsible;
        }
    }

    # within this function %Param is modified by replacements like:
    #    $Param{PriorityID} = $Param{NewPriorityID}
    #    apparently this changes are not longer needed outside this function and it is not necessary
    #    to return such replacements

    return {
        Checks         => \%Checks,
        ChecksDatabase => \%ChecksDatabase,
    };
}

=item _CompareMatchWithData()

Compares a properties element with the data sent to the ACL, the compare results varies on how the
ACL properties where defined including normal, negated, regular expression and negated regular
expression comparisons.

    my $Result = $TicketObject->_CompareMatchWithData(
        Match => 'a value',         # or '[Not]a value', or '[RegExp]val' or '[NotRegExp]val'
                                    #    or '[Notregexp]val' or '[Notregexp]'
        Data => 'a value',
        SingleItem => 1,            # or 0, optional, default 0
    );

Returns:

    $Result = {
        Success => 1,               # or false
        Match   => 1,               # or false
        Skip    => 1,               # or false (in certain cases where SingleItem is set)
    };

=cut

sub _CompareMatchWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Match Data)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return {
                Success => 0,
            };
        }
    }

    my $Match = $Param{Match};
    my $Data  = $Param{Data};

    # Not equal match, this case requires a reverse logic than the rest
    if ( substr( $Match, 0, length '[Not]' ) eq '[Not]' ) {
        my $NotValue = substr $Match, length '[Not]';
        if ( $NotValue eq $Data ) {
            return {
                Success => 1,
                Match   => 0,
            };
        }
        if ( $Param{SingleItem} ) {
            return {
                Success => 1,
                Match   => 1,
                Skip    => 0,
            };
        }
        else {
            return {
                Success => 1,
                Match   => 1,
                Skip    => 1,
            };
        }
    }

    # equal match
    elsif ( $Match eq $Data ) {
        return {
            Success => 1,
            Match   => 1,
        };
    }

    # reg-exp match case-sensitive
    elsif ( substr( $Match, 0, length '[RegExp]' ) eq '[RegExp]' ) {
        my $RegExp = substr $Match, length '[RegExp]';
        if ( $Data =~ /$RegExp/ ) {
            return {
                Success => 1,
                Match   => 1,
            };
        }
    }

    # reg-exp match case-insensitive
    elsif ( substr( $Match, 0, length '[regexp]' ) eq '[regexp]' ) {
        my $RegExp = substr $Match, length '[regexp]';
        if ( $Data =~ /$RegExp/i ) {
            return {
                Success => 1,
                Match   => 1,
            };
        }
    }

    # not reg-exp match case-sensitive
    elsif ( substr( $Match, 0, length '[NotRegExp]' ) eq '[NotRegExp]' ) {
        my $RegExp = substr $Match, length '[NotRegExp]';
        if ( $Data !~ /$RegExp/ ) {
            return {
                Success => 1,
                Match   => 1,
            };
        }
    }

    # not reg-exp match case-insensitive
    elsif ( substr( $Match, 0, length '[Notregexp]' ) eq '[Notregexp]' ) {
        my $RegExp = substr $Match, length '[Notregexp]';
        if ( $Data !~ /$RegExp/i ) {
            return {
                Success => 1,
                Match   => 1,
            };
        }
    }

    if ( $Param{SingleItem} ) {
        return {
            Success => 1,
            Match   => 0,
            Skip    => 0,
        };
    }
    else {
        return {
            Success => 1,
            Match   => 0,
            Skip    => 1,
        };
    }
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
