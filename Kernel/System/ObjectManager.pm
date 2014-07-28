# --
# Kernel/System/ObjectManager.pm - central object and dependency manager
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## nofilter(TidyAll::Plugin::OTRS::Perl::PodSpelling)
## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)

package Kernel::System::ObjectManager;

use strict;
use warnings;

use Scalar::Util qw(weaken);

# use the "standard" modules directly, so that persistent environments
# like mod_perl and FastCGI preload them at startup

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::Cache;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::Output::HTML::Layout;

use Carp qw(carp confess);

# Contains the top-level object being retrieved;
# used to generate better error messages.
our $CurrentObject;

our @DefaultObjectDependencies = (
    'ConfigObject',
    'DBObject',
    'EncodeObject',
    'LogObject',
    'MainObject',
    'TimeObject',
);

=head1 NAME

Kernel::System::ObjectManager - object and dependency manager

=head1 SYNOPSIS

    use Kernel::System::ObjectManager;

    # it's important to store the object in this variable,
    # since many modules expect it that way.
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        # options for module constructors here
        LogObject {
            LogPrefix => 'OTRS-MyTestScript',
        },
    );

    # now you can retrieve any configured object:

    if ( !$Kernel::OM->Get('DBObject')->Prepare('SELECT 1') ) {
        die "Houston, we have a problem!";
    }

=head1 PUBLIC INTERFACE

=over 4

=item new()

Creates a new instance of Kernel::System::ObjectManager.

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new(%Options)

Options to this constructor should have object names as keys, and hash
references as values. The hash reference will be flattened and passed
to the constructor of the object with the same name as option key.

If the C<< Debug => 1 >> option is present, destruction of objects
is checked, and a warning is emitted if objects persist after the
attempt to destroy them.

=cut

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = bless {}, $Type;

    $Self->{Debug} = delete $Param{Debug};

    # Pre-load ConfigObject to get the ObjectAliases
    my $ConfigObject = Kernel::Config->new();
    $Self->{Objects} = {
        'Kernel::Config' => $ConfigObject,
    };
    $Self->{ObjectAliases} = $ConfigObject->Get('ObjectAliases');

    for my $Parameter ( sort keys %Param ) {
        $Self->{Param}->{ $Self->{ObjectAliases}->{$Parameter} // $Parameter } = $Param{$Parameter};
    }

    return $Self;
}

=item Get()

Retrieves a singleton object, and if it not yet exists, implicitly creates one for you.

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

For backwards compatibility reasons, object aliases can be defined in L<Kernel::Config::Defaults>.
For example C<< ->Get('TicketObject') >> retrieves a L<Kernel::System::Ticket> object.

    my $ConfigObject = $Kernel::OM->Get('ConfigObject'); # returns the same ConfigObject as above

=cut

sub Get {

    # No param unpacking for increased performance
    my $Package = $_[0]->{ObjectAliases}->{ $_[1] } // $_[1];

    if ( $Package && $_[0]->{Objects}->{$Package} ) {
        return $_[0]->{Objects}->{$Package};
    }

    if ( !$Package ) {
        carp "Error: Missing parameter (object name)";
        confess "Error: Missing parameter (object name)";
    }

    # record the object we are about to retrieve to potentially
    # build better error messages
    # needs to be a statement-modifying 'if', otherwise 'local'
    # is local to the scope of the 'if'-block
    local $CurrentObject = $Package if !$CurrentObject;

    return $_[0]->_ObjectBuild( Package => $Package );
}

sub _ObjectBuild {
    my ( $Self, %Param ) = @_;

    my $Package  = $Param{Package};
    my $FileName = $Package;
    $FileName =~ s{::}{/}g;
    $FileName .= '.pm';
    eval {
        require $FileName;
    };
    if ($@) {
        if ( $CurrentObject && $CurrentObject ne $Package ) {
            my $Error = "$CurrentObject depends on $Package, but $Package could not be loaded: $@";
            carp $Error;
            confess $Error;
        }
        else {
            my $Error = "$Package could not be loaded: $@";
            carp $Error;
            confess $Error;
        }
    }

# Kernel::Config does not declare its dependencies (they would have to be in Kernel::Config::Defaults),
#   so assume [] in this case.
    my $Dependencies       = [];
    my $ObjectManagerAware = 0;

    if ( $Package ne 'Kernel::Config' ) {
        no strict 'refs';    ## no critic
        if ( exists ${ $Package . '::' }{ObjectDependencies} ) {
            $Dependencies = \@{ $Package . '::ObjectDependencies' };
        }
        else {
            $Dependencies = \@DefaultObjectDependencies;
        }
        my $ObjectManagerAware = ${ $Package . '::ObjectManagerAware' } // 0;
        use strict 'refs';
    }
    $Self->{ObjectDependencies}->{$Package} = $Dependencies;

    my %Args = (
        %{ $Self->{Param}->{$Package} // {} },
    );

    if ( !$ObjectManagerAware && @{$Dependencies} ) {
        for my $Dependency ( @{$Dependencies} ) {
            $Self->Get($Dependency);
        }
        %Args = (
            $Self->ObjectHash( Objects => $Dependencies, ),
            %Args,
        );
    }

    my $NewObject = $Package->new(%Args);

    if ( !defined $NewObject ) {
        if ( $CurrentObject && $CurrentObject ne $Package ) {
            my $Error
                = "$CurrentObject depends on $Package, but the constructor of $Package returned undef.";
            carp $Error;
            confess $Error;
        }
        else {
            my $Error = "The contrustructor of $Package returned undef.";
            carp $Error;
            confess $Error;
        }
    }

    $Self->{Objects}->{$Package} = $NewObject;

    return $NewObject;
}

=item ObjectHash()

Returns a hash of already instantiated objects.
The keys are the object names, and the values are the objects themselves.

This method is useful for creating objects of classes that are
not aware of the object manager yet.

    $SomeModule->new(
        $Kernel::OM->ObjectHash(
            Objects => ['TicketObject', 'DynamicFieldObject'],
        ),
    );

=cut

sub ObjectHash {
    my ( $Self, %Param ) = @_;

    my %Result;
    for my $Object ( @{ $Param{Objects} // [] } ) {
        $Result{$Object} = $Self->Get($Object);
    }

    return %Result;
}

=item ObjectParamAdd()

Adds arguments that will be passed to constructors of classes
when they are created, in the same format as the C<new()> method
receives them.

    $Kernel::OM->ObjectParamAdd(
        TicketObject => {
            Key => 'Value',
        },
    );

=cut

sub ObjectParamAdd {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %Param ) {
        my $Package = $Self->{ObjectAliases}->{$Key} // $Key;
        if ( ref( $Param{$Key} ) eq 'HASH' ) {
            for my $K ( sort keys %{ $Param{$Key} } ) {
                $Self->{Param}->{$Package}->{$K} = $Param{$Key}->{$K};
            }
        }
        else {
            $Self->{Param}->{$Package} = $Param{$Key};
        }
    }
    return;
}

=item ObjectsDiscard()

Discards internally stored objects, so that the next access to objects
creates them newly. If a list of object names is passed, only
the supplied objects and their recursive dependencies are destroyed.
If no list of object names is passed, all stored objects are detroyed.

    $Kernel::OM->ObjectsDiscard();

    $Kernel::OM->ObjectsDiscard(
        Objects => ['TicketObject', 'QueueObject'],

    );

Mostly used for tests that rely on fresh objects, or to avoid large
memory consumption in long-running processes.

Note that if you pass a list of objects to be destroyed, they are destroyed
in in the order they were passed; otherwise they are passed in reverse
dependency order.

=cut

sub ObjectsDiscard {
    my ( $Self, %Param ) = @_;

    # fire outstanding events before destroying anything
    my $HasQueuedTransactions;
    EVENTS:
    for my $Counter ( 1 .. 10 ) {
        $HasQueuedTransactions = 0;
        EVENTHANDLERS:
        for my $EventHandler ( @{ $Self->{EventHandlers} } ) {

            # since the event handlers are weak references,
            # they might be undef by now.
            next EVENTHANDLERS if !defined $EventHandler;
            if ( $EventHandler->EventHandlerHasQueuedTransactions() ) {
                $HasQueuedTransactions = 1;
                $EventHandler->EventHandlerTransaction();
            }
        }
        if ( !$HasQueuedTransactions ) {
            last EVENTS;
        }
    }
    if ($HasQueuedTransactions) {
        warn "Unable to handle all pending events in 10 iterations";
    }
    delete $Self->{EventHandlers};

    # destroy objects before their dependencies are destroyed

    # first step: get the dependencies into a single hash,
    # so that the topological sorting goes faster
    my %ReverseDependencies;
    my @AllObjects;
    for my $Object ( sort keys %{ $Self->{Objects} } ) {
        my $Dependencies = $Self->{ObjectDependencies}->{$Object};

        for my $Dependency (@$Dependencies) {

            # undef happens to be the value that uses the least amount
            # of memory in perl, and we are only interested in the keys
            $ReverseDependencies{ $Self->{ObjectAliases}->{$Dependency} // $Dependency }->{$Object}
                = undef;
        }
        push @AllObjects, $Object;
    }

    # second step: post-order recursive traversal
    my %Seen;
    my @OrderedObjects;
    my $Traverser;
    $Traverser = sub {
        my ($Object) = @_;
        return if $Seen{$Object}++;
        for my $ReverseDependency ( sort keys %{ $ReverseDependencies{$Object} } ) {
            $Traverser->($ReverseDependency);
        }
        push @OrderedObjects, $Object;
    };

    if ( $Param{Objects} ) {
        for my $Object ( @{ $Param{Objects} } ) {
            $Traverser->( $Self->{ObjectAliases}->{$Object} // $Object );
        }
    }
    else {
        for my $Object (@AllObjects) {
            $Traverser->($Object);
        }
    }
    undef $Traverser;

    # third step: destruction
    if ( $Self->{Debug} ) {

        # If there are undeclared dependencies between objects, destruction
        # might not work in the order that we calculated, but might still work
        # out in the end.
        my %DestructionFailed;
        for my $Object (@OrderedObjects) {
            my $Checker = $Self->{Objects}->{$Object};
            weaken($Checker);
            delete $Self->{Objects}->{$Object};

            if ( defined $Checker ) {
                $DestructionFailed{$Object} = $Checker;
                weaken( $DestructionFailed{$Object} );
            }
        }
        for my $Object ( sort keys %DestructionFailed ) {
            if ( defined $DestructionFailed{$Object} ) {
                warn "DESTRUCTION OF $Object FAILED!\n";
                if ( eval { require Devel::Cycle; 1 } ) {
                    Devel::Cycle::find_cycle( $DestructionFailed{$Object} );
                }
                else {
                    warn "To get more debugging information, please install Devel::Cycle.";
                }
            }
        }
    }
    else {
        for my $Object (@OrderedObjects) {
            delete $Self->{Objects}{$Object};
        }
    }

    # if an object requests an already destroyed object
    # in its DESTROY method, we might hold it again, and must try again
    # (but not infinitely)
    if ( !$Param{Objects} && keys %{ $Self->{Objects} } ) {
        if ( $Self->{DestroyAttempts} && $Self->{DestroyAttempts} > 3 ) {
            carp "Loop while destroying objects!";
            confess "Loop while destroying objects!";
        }

        $Self->{DestroyAttempts}++;
        $Self->ObjectsDiscard();
        $Self->{DestroyAttempts}--;
    }

    return 1;
}

=item ObjectRegisterEventHandler()

Registers an object that can handle asynchronous events.

    $Kernel::OM->ObjectRegisterEventHandler(
        EventHandler => $EventHandlerObject,
    );

The C<EventHandler> object should inherit from L<Kernel::System::EventHandler>.
The object manager will call that object's C<EventHandlerHasQueuedTransactions>
method, and if that returns a true value, calls its C<EventHandlerTransaction> method.

=cut

sub ObjectRegisterEventHandler {
    my ( $Self, %Param ) = @_;
    if ( !$Param{EventHandler} ) {
        die "Missing parameter EventHandler";
    }
    push @{ $Self->{EventHandlers} }, $Param{EventHandler};
    weaken( $Self->{EventHandlers}[-1] );
    return 1;
}

=back

=cut

sub DESTROY {
    my ($Self) = @_;

    # Make sure $Kernel::OM is still available in the destructor
    local $Kernel::OM = $Self;
    $Self->ObjectsDiscard();
}

1;
