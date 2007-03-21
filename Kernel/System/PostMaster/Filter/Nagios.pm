# --
# Kernel/System/PostMaster/Filter/Nagios.pm - Basic Nagios Interface
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Nagios.pm,v 1.1 2007-03-21 15:06:58 bb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::PostMaster::Filter::Nagios;
use strict;
use vars qw($VERSION);

$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::PostMaster::Filter::Nagios - Basic Nagios Interface

=head1 SYNOPSIS

This module implemets a basic interface to the Nagios Monitoring Suite. It
works by receiving email messages sent by Nagios. New tickets are created
in case of component failures. Once a ticket has been opened messages
regarding the effected component are attached to this ticket. When the
component recovers, the ticket state can be changed or the ticket can be
closed.

Once a open ticket for a given Host/Service combination exists, all mails by
Nagios concerning this particular combination will be attached to the ticket
until it's closed.

=cut

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    #$Self->{Debug} = $Param{Debug} || 0;
    $Self->{Debug} = 1;

    # get needed objects
    foreach (qw(ConfigObject LogObject TicketObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # Default Settings
    $Self->{Config} = {
       StateRegExp       => '\s*State:\s+(\S+)',
       FromAddressRegExp => 'nagios@example.com',
       NewTicketRegExp   => 'CRITICAL|DOWN',
       CloseTicketRegExp => 'OK|UP',
       CloseActionState  => 'closed successful',
       ClosePendingTime  => 60*60*24*2, # 2 days
       HostRegExp        => '\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*',
       FreeTextHost      => '1',
       ServiceRegExp     => '\s*Service:\s+(.*)\s*',
       DefaultService    => 'Host',
       FreeTextService   => '2',
       SenderType        => 'system',
       ArticleType       => 'note-report',
    };
    return $Self;
}

# ---------------------------------------------------- #
# The actual filter...                                 #
# ---------------------------------------------------- #
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = undef;

    # get config options, use defaults unless value specified
    if ($Param{JobConfig} && ref($Param{JobConfig}) eq 'HASH') {
        foreach (keys(%{$Param{JobConfig}})) {
            $Self->{Config}{$_} && ($Self->{Config}{$_} = $Param{JobConfig}->{$_});
        }
    }

    # check if sender is of interest
    if ( $Param{GetParam}->{From} && $Param{GetParam}->{From} =~ /$Self->{Config}{FromAddressRegExp}/ ) {
        # Try to get State, Host and Service
        for my $line ( split /\n/,  $Param{GetParam}->{Body} ) {
            for ( qw ( State Host Service ) ) {
                $line =~ /$Self->{Config}{$_.'RegExp'}/ && ( $Self->{$_} = $1 );
            }
        }
        # We need State and Host to proceed
        if  ( $Self->{State} && $Self->{Host} ) {
            # Check for Service
            $Self->{Service} || ( $Self->{Service} = $Self->{Config}{DefaultService} );
	    $LogMessage = " - Host: $Self->{Host}, State: $Self->{State}, Service: $Self->{Service}";

	    # Is there a ticket for this Host/Service pair?
	    my %query = ( Result => 'ARRAY', Limit  => 1, UserID => 1, StateType => 'Open' );
	    for ( qw ( Host Service ) ) {
		$query{'TicketFreeKey'  . $Self->{Config}{'FreeText' . $_}} = $_;
		$query{'TicketFreeText' . $Self->{Config}{'FreeText' . $_}} = $Self->{$_};
	    }

	    if ( my $TicketID = ($Self->{TicketObject}->TicketSearch( %query ))[0] ) {
                # Always use first result, there should be only one...
		# OK, found ticket to deal with
		$Param{GetParam}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
		    TicketNumber => $Self->{TicketObject}->TicketNumberLookup( TicketID => $TicketID, UserID => 1 ),
		    Subject      => $Param{GetParam}->{Subject},
		);
		$Param{GetParam}->{'X-OTRS-FollowUp-SenderType'} = $Self->{Config}{SenderType};
		$Param{GetParam}->{'X-OTRS-FollowUp-ArticleType'} = $Self->{Config}{ArticleType};
		if ( $Self->{State} =~ /$Self->{Config}{CloseTicketRegExp}/ ) {
		    # Close Ticket Condition -> Take Close Action
		    if ( $Self->{Config}{CloseActionState} ne 'OLD' ) {
			$Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Self->{Config}{CloseActionState};
			$Param{GetParam}->{'X-OTRS-State-PendingTime'} = $Self->{TimeObject}->SystemTime2TimeStamp (
			    SystemTime => $Self->{TimeObject}->SystemTime() + $Self->{Config}{ClosePendingTime} );
		    }
		    $LogMessage = 'Recovered' . $LogMessage;
		} else {
		    # Attach note to existing ticket
		    $LogMessage = 'New Notice' . $LogMessage;
		}
	    } elsif ( $Self->{State} =~ /$Self->{Config}{NewTicketRegExp}/ ) {
		# Create Ticket Condition -> Create new Ticket and record Host and Service
		for ( qw ( Host Service ) ) {
		    $Param{GetParam}->{'X-OTRS-TicketKey'   . $Self->{Config}{'FreeText' . $_}} = $_;
		    $Param{GetParam}->{'X-OTRS-TicketValue' . $Self->{Config}{'FreeText' . $_}} = $Self->{$_};
		}
		$Param{GetParam}->{'X-OTRS-SenderType'} = $Self->{Config}{SenderType};
		$Param{GetParam}->{'X-OTRS-ArticleType'} = $Self->{Config}{ArticleType};
		$LogMessage = 'New Ticket' . $LogMessage;
	    } else {
		# No existing ticket and no open condition -> drop silently
		$Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
		$LogMessage = 'Mail Dropped, no matching ticket found, no open on this state' . $LogMessage;
	    }
	} else {
	    $LogMessage = 'Nagios: Could not find host address and/or state in mail => Ignoring',
	}
	if ( $LogMessage ) {
	    $Self->{LogObject}->Log(
		Priority => 'notice',
		Message  => 'Nagios Mail: ' . $LogMessage,
	    );
	}

    }
    return 1;
}

1;

# ---------------------------------------------------- #
# More documentation...                                #
# ---------------------------------------------------- #

=head1 CONFIGURATION OPTIONS

To allow flexible integration between OTRS and Nagios the following
configuration options are available. The default values (as shown below)
should be suitable for a standard Nagios installation.

=over

=item * C<FromAddressRegExp>

Only mails matching this C<From:> address will be considered for Nagios Filter.
You need to adjust this setting to the from address your Nagios installation
uses for outgoing mails.

Default: C<'nagios@mysystem.com'>

=item * C<StateRegExp>

Regular Expression to extract C<State>

Default: C<'\s*State:\s+(\S+)'>

=item * C<NewTicketRegExp>

Regular expression for extracted C<State> to trigger new ticket

Default: C<'CRITICAL|DOWN'>

=item * C<CloseTicketRegExp>

Regular expression for extracted C<State> to trigger ticket transition
to C<CloseActionState>

Default: C<'OK|UP'>

=item * C<CloseActionState>

New status for ticket when service recoveres. This can be either C<OLD> in
which case the old status stays, or the name of the new status. Please note,
that this state needs to be configured in your OTRS installation as valid
state. If the state you set here does not exist, the ticket state will not be
altered.

Default: C<'closed successful'>

=item * C<ClosePendingTime>

Pending time in seconds for 'Pending...' status time. (Ignored for other status
types). Please note that this setting will be ignored by OTRS versions older than
2.2. On these systems the pending time already associated with the ticket will be
used, which may have in surprising effects. It's recommended not to use 'Pending...'
states with OTRS prior to 2.2.

Default: C<60*60*24*2>  (2 days)

=item * C<HostRegExp>

Regular expression to extract C<Host>

Default: C<'\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*'>

=item * C<FreeTextHost>

Free text field index to store C<Host>

Default: C<'1'>

=item * C<ServiceRegExp>

Regular expression to extract C<Service>

Default: C<'\s*Service:\s+(.*)\s*'>

=item * C<DefaultService>

Default for C<Service>; used if no service can be extracted, i.e. if host
goes DOWN/UP

Default: C<'Host'>

=item * C<FreeTexyService>

Free text field index to store service

Default: C<'2'>

=item * C<SenderType>

Sender type used for creating tickets and attaching notes

Default: C<system>

=item * C<ArticleType>

Article type used to attach follow up emails to existing tickets

Default: C<note-report>

=back

=head1 CONTROL FLOW

The following diagram illustrates how mails are handled by this module
and in which cases they trigger which action. Pretty much all checks are
configable using the regular expressions given by the parameters listed
above.

 Mail matches 'FromAddress'?
 |
 +-> NO  -> Continue with regular mail processing
 |
 +-> YES -> Does a ticket with matching Host/Service combination
            already exist in OTRS?
            |
            +-> NO  -> Does 'State:' match 'NewTicketRegExp'?
            |          |
            |          +-> NO  -> Stop processing this mail
            |          |          (silent drop)
            |          |
            |          +-> YES -> Create new ticket, record Host
            |                     and Service, attach mail
            |
            +-> YES -> Attach mail to ticket
                    -> Does 'State:' match 'CloseTicketRegExp'?
                       |
                       +-> NO  -> Continue with regular mail processing
                       |
                       +-> YES -> Change ticket type as configured in
                                  'CloseActionState'

Besides of a few additional sanity checks this is how the Nagios interface
treats incoming mails. By changing the regular expressions it should be
possible to adopt it to other monitoring systems or highy customized versions
of Nagios as well.
=cut
