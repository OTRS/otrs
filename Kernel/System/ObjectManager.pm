# --
# Kernel/System/ObjectManager.pm - central object and dependency manager
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ObjectManager;
## nofilter(TidyAll::Plugin::OTRS::Perl::PodSpelling)
## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)

use strict;
use warnings;

use Carp qw(carp confess);
use Scalar::Util qw(weaken);

# use the "standard" modules directly, so that persistent environments
# like mod_perl and FastCGI pre-load them at startup

use Kernel::Config;
use Kernel::Output::HTML::Layout;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::Cache;
use Kernel::System::DB;
use Kernel::System::Encode;
use Kernel::System::Group;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::User;

# Contains the top-level object being retrieved;
# used to generate better error messages.
our $CurrentObject;

=head1 NAME

Kernel::System::ObjectManager - object and dependency manager

=head1 SYNOPSIS

The ObjectManager is the central place to create and access singleton OTRS objects.

=head2 How does it work?

It creates objects as late as possible and keeps references to them. Upon destruction the objects
are destroyed in the correct order, based on their dependencies (see below).

=head2 How to use it?

The ObjectManager must always be provided to OTRS by the toplevel script like this:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        # options for module constructors here
        LogObject {
            LogPrefix => 'OTRS-MyTestScript',
        },
    );

Then in the code any object can be retrieved that the ObjectManager can handle,
like Kernel::System::DB:

    return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare('SELECT 1');


=head2 Which objects can be loaded?

The ObjectManager can load every object that declares its dependencies like this in the Perl package:

    package Kernel::System::Valid;

    use strict;
    use warnings;

    our @ObjectDependencies = (
        'Kernel::System::Cache',
        'Kernel::System::DB',
        'Kernel::System::Log',
    );

The C<@ObjectDependencies> is the list of objects that the current object will depend on. They will
be destroyed only after this object is destroyed.

If you want to signal that a package can NOT be loaded by the ObjectManager, you can use the
C<$ObjectManagerDisabled> flag:

    package Kernel::System::MyBaseClass;

    use strict;
    use warnings;

    $ObjectManagerDisabled = 1;

=head1 PUBLIC INTERFACE

=over 4

=item new()

Creates a new instance of Kernel::System::ObjectManager.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

Sometimes objects need parameters to be sent to their constructors,
these can also be passed to the ObjectManager's constructor like in the following example.
The hash reference will be flattened and passed to the constructor of the object(s).

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        Kernel::System::Log => {
            LogPrefix => 'OTRS-MyTestScript',
        },
    );

Alternatively, C<ObjectParamAdd()> can be used to set these parameters at runtime (but this
must happen before the object was created).

If the C<< Debug => 1 >> option is present, destruction of objects
is checked, and a warning is emitted if objects persist after the
attempt to destroy them.

=cut

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = bless {}, $Type;

    $Self->{Debug} = delete $Param{Debug};

    for my $Parameter ( sort keys %Param ) {
        $Self->{Param}->{$Parameter} = $Param{$Parameter};
    }

    # Kernel::System::Encode->new() initializes the environment, so we need to
    #   already create an instance here to make sure it is always done and done
    #   at the beginning of things.
    $Self->Get('Kernel::System::Encode');

    return $Self;
}

=item Get()

Retrieves a singleton object, and if it not yet exists, implicitly creates one for you.

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

DEPRECATED: For backwards compatibility reasons, object aliases can be defined in L<Kernel::Config::Defaults>.
For example C<< ->Get('TicketObject') >> retrieves a L<Kernel::System::Ticket> object.

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config'); # returns the same ConfigObject as above

=cut

sub Get {

    # No param unpacking for increased performance
    if ( $_[1] && $_[0]->{Objects}->{ $_[1] } ) {
        return $_[0]->{Objects}->{ $_[1] };
    }

    if ( !$_[1] ) {
        $_[0]->_DieWithError(
            Error => "Error: Missing parameter (object name)",
        );
    }

    # record the object we are about to retrieve to potentially
    # build better error messages
    # needs to be a statement-modifying 'if', otherwise 'local'
    # is local to the scope of the 'if'-block
    local $CurrentObject = $_[1] if !$CurrentObject;

    return $_[0]->_ObjectBuild( Package => $_[1] );
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
            $Self->_DieWithError(
                Error => "$CurrentObject depends on $Package, but $Package could not be loaded: $@",
            );
        }
        else {
            $Self->_DieWithError(
                Error => "$Package could not be loaded: $@",
            );
        }
    }

    # Kernel::Config does not declare its dependencies (they would have to be in
    #   Kernel::Config::Defaults), so assume [] in this case.
    my $Dependencies = [];

    if ( $Package ne 'Kernel::Config' ) {
        no strict 'refs';    ## no critic
        if ( !exists ${ $Package . '::' }{ObjectDependencies} ) {
            $Self->_DieWithError( Error => "$Package does not declare its object dependencies!" );
        }
        $Dependencies = \@{ $Package . '::ObjectDependencies' };

        if ( ${ $Package . '::ObjectManagerDisabled' } ) {
            $Self->_DieWithError( Error => "$Package cannot be loaded via ObjectManager!" );
        }

        use strict 'refs';
    }
    $Self->{ObjectDependencies}->{$Package} = $Dependencies;

    my $NewObject = $Package->new(
        %{ $Self->{Param}->{$Package} // {} }
    );

    if ( !defined $NewObject ) {
        if ( $CurrentObject && $CurrentObject ne $Package ) {
            $Self->_DieWithError(
                Error =>
                    "$CurrentObject depends on $Package, but the constructor of $Package returned undef.",
            );
        }
        else {
            $Self->_DieWithError(
                Error => "The constructor of $Package returned undef.",
            );
        }
    }

    $Self->{Objects}->{$Package} = $NewObject;

    return $NewObject;
}

=item ObjectInstanceRegister()

Adds an existing object instance to the ObjectManager so that it can be accessed by other objects.

This should only be used on special circumstances, e. g. in the unit tests to pass $Self to the
ObjectManager so that it is also available from there as 'Kernel::System::UnitTest'.

    $Kernel::OM->ObjectInstanceRegister(
        Package      => 'Kernel::System::UnitTest',
        Object       => $UnitTestObject,
        Dependencies => [],         # optional, specify OM-managed packages that the object might depend on
    );

=cut

sub ObjectInstanceRegister {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Package} || !$Param{Object} ) {
        $Self->_DieWithError( Error => 'Need Package and Object.' );
    }

    if ( defined $Self->{Objects}->{ $Param{Package} } ) {
        $Self->_DieWithError( Error => 'Need $Param{Package} is already registered.' );
    }

    $Self->{Objects}->{ $Param{Package} } = $Param{Object};
    $Self->{ObjectDependencies}->{ $Param{Package} } = $Param{Dependencies} // [];

    return 1;
}

=item ObjectParamAdd()

Adds arguments that will be passed to constructors of classes
when they are created, in the same format as the C<new()> method
receives them.

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Ticket' => {
            Key => 'Value',
        },
    );

To remove a key again, send undef as a value:

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Ticket' => {
            Key => undef,               # this will remove the key from the hash
        },
    );

=cut

sub ObjectParamAdd {
    my ( $Self, %Param ) = @_;

    for my $Package ( sort keys %Param ) {
        if ( ref( $Param{$Package} ) eq 'HASH' ) {
            for my $Key ( sort keys %{ $Param{$Package} } ) {
                if ( defined $Key ) {
                    $Self->{Param}->{$Package}->{$Key} = $Param{$Package}->{$Key};
                }
                else {
                    delete $Self->{Param}->{$Package}->{$Key};
                }
            }
        }
        else {
            $Self->{Param}->{$Package} = $Param{$Package};
        }
    }
    return;
}

=item ObjectsDiscard()

Discards internally stored objects, so that the next access to objects
creates them newly. If a list of object names is passed, only
the supplied objects and their recursive dependencies are destroyed.
If no list of object names is passed, all stored objects are destroyed.

    $Kernel::OM->ObjectsDiscard();

    $Kernel::OM->ObjectsDiscard(
        Objects            => ['Kernel::System::Ticket', 'Kernel::System::Queue'],

        # optional
        # forces the packages to be reloaded from the file system
        # sometimes necessary with mod_perl when running CodeUpgrade during a package upgrade
        # if no list of object names is passed, all stored objects are destroyed
        # and forced to be reloaded
        ForcePackageReload => 1,
    );

Mostly used for tests that rely on fresh objects, or to avoid large
memory consumption in long-running processes.

Note that if you pass a list of objects to be destroyed, they are destroyed
in in the order they were passed; otherwise they are destroyed in reverse
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
            # of memory in Perl, and we are only interested in the keys
            $ReverseDependencies{$Dependency}->{$Object} = undef;
        }
        push @AllObjects, $Object;
    }

    # During an OTRS package upgrade the packagesetup code module has just
    # recently been copied to it's location in the file system.
    # In a persistent Perl environment an old version of the module might still be loaded,
    # as watchdogs like Apache2::Reload haven't had a chance to reload it.
    # So we need to make sure that the new version is being loaded.
    # Kernel::System::Main::Require() checks the relative file path, so we need to remove that from %INC.
    # This is only needed in persistent Perl environment, but does no harm in a CGI environment.
    if ( $Param{ForcePackageReload} ) {

        my @Objects;
        if ( $Param{Objects} && @{ $Param{Objects} } ) {
            @Objects = @{ $Param{Objects} };
        }
        else {
            @Objects = @AllObjects;
        }

        for my $Object (@Objects) {

            # convert :: to / in order to build a file system path name
            my $ObjectPath = $Object;
            $ObjectPath =~ s/::/\//g;

            # attach .pm as file extension
            $ObjectPath .= '.pm';

            # delete from global %INC hash
            delete $INC{$ObjectPath};
        }
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
            $Traverser->($Object);
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
            $Self->_DieWithError( Error => "Loop while destroying objects!" );
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

sub _DieWithError {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Objects}->{'Kernel::System::Log'} ) {
        $Self->{Objects}->{'Kernel::System::Log'}->Log(
            Priority => 'Error',
            Message  => $Param{Error},
        );
        confess $Param{Error};    # this will die()
    }

    carp $Param{Error};
    confess $Param{Error};
}

sub DESTROY {
    my ($Self) = @_;

    # Make sure $Kernel::OM is still available in the destructor
    local $Kernel::OM = $Self;
    $Self->ObjectsDiscard();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
