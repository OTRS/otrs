# --
# Kernel/GenericInterface/Event/Handler.pm - event handler module for the GenericInterface
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Event::Handler;

use strict;
use warnings;

use Kernel::GenericInterface::Requester;
use Kernel::Scheduler;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

=head1 NAME

Kernel::GenericInterface::Event::Handler - GenericInterface event handler

=head1 SYNOPSIS

This event handler intercepts all system events and fires connected GenericInterface
invokers.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject MainObject EncodeObject TimeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new(%$Self);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %WebserviceList = %{
        $Self->{WebserviceObject}->WebserviceList(
            Valid => 1,
        ),
        };

    # loop over webservices
    WEBSERVICE:
    for my $WebserviceID ( sort keys %WebserviceList ) {

        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet(
            ID => $WebserviceID,
        );

        next WEBSERVICE if ( !IsHashRefWithData( $WebserviceData->{Config} ) );
        next WEBSERVICE if ( !IsHashRefWithData( $WebserviceData->{Config}->{Requester} ) );
        next WEBSERVICE
            if ( !IsHashRefWithData( $WebserviceData->{Config}->{Requester}->{Invoker} ) );

        # check invokers of the webservice, to see if some might be connected to this event
        INVOKER:
        for my $Invoker ( sort keys %{ $WebserviceData->{Config}->{Requester}->{Invoker} } ) {
            my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker};

            next INVOKER if ( ref $InvokerConfig->{Events} ne 'ARRAY' );

            EVENT:
            for my $Event ( @{ $InvokerConfig->{Events} } ) {

                next EVENT if ref $Event ne 'HASH';

                # check if the invoker is connected to this event
                if ( $Event->{Event} eq $Param{Event} ) {

                    # create a scheduler task for later execution
                    if ( $Event->{Asynchronous} ) {
                        my $SchedulerObject = Kernel::Scheduler->new( %{$Self} );

                        my $TaskID = $SchedulerObject->TaskRegister(
                            Type => 'GenericInterface',
                            Data => {
                                WebserviceID => $WebserviceID,
                                Invoker      => $Invoker,
                                Data         => $Param{Data},
                            },
                        );

                    }
                    else {    # or execute Event directly
                        my $RequesterObject = Kernel::GenericInterface::Requester->new( %{$Self} );

                        $RequesterObject->Run(
                            WebserviceID => $WebserviceID,
                            Invoker      => $Invoker,
                            Data         => $Param{Data},
                        );
                    }
                }
            }
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
