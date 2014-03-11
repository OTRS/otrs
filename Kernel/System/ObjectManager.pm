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

use Carp qw(confess);

# Contains the top-level object being retrieved;
# used to generate better error messages.
our $CurrentObject;

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

    $Self->{Debug}   = delete $Param{Debug};
    $Self->{Param}   = \%Param;
    $Self->{Objects} = {};
    $Self->{Config}  = {};

    return $Self;
}

=item Get()

Retrieves an object, and if it not yet exists, implicitly creating one for you.
Note that objects must be configured before they can be retrieved. The standard objects are configured in L<Kernel::Config::Defaults>.

The name of an object is usually what the code base used so far, including
the C<Object> suffix. For example C<< ->Get('TicketObject') >> retrieves a
L<Kernel::System::Ticket> object.

    my $ConfigObject = $Kernel::OM->Get('ConfigObject');

=cut

sub Get {

    # Optimize the heck out of the common case:
    return $_[0]->{Objects}{ $_[1] } if $_[1] && $_[0]->{Objects}{ $_[1] };

    # OK, not so easy
    my ( $Self, $ObjectName ) = @_;

    die "Error: Missing parameter (object name)\n" if !$ObjectName;

    # record the object we are about to retrieve to potentially
    # build better error messages
    # needs to be a statement-modifying 'if', otherwise 'local'
    # is local to the scope of the 'if'-block
    local $CurrentObject = $ObjectName if !$CurrentObject;

    $Self->_ObjectBuild( Object => $ObjectName );

    return $Self->{Objects}{$ObjectName};
}

sub _ObjectBuild {
    my ( $Self, %Param ) = @_;
    my $Config    = $Self->ObjectConfigGet(%Param);
    my $ClassName = $Config->{ClassName};
    my $FileName  = $ClassName;
    $FileName =~ s{::}{/}g;
    $FileName .= '.pm';
    require $FileName;

    my %Args = (
        %{ $Config->{Param} // {} },
        %{ $Self->{Param}{ $Param{Object} } // {} },
    );

    if ( !$Config->{OmAware} && $Config->{Dependencies} ) {
        for my $Dependency ( @{ $Config->{Dependencies} } ) {
            $Self->Get($Dependency);
        }
        %Args = ( $Self->ObjectHash(), %Args );
    }

    my $NewObject = $ClassName->new(%Args);

    if ( !defined $NewObject ) {
        if ( $CurrentObject && $CurrentObject ne $Param{Object} ) {
            confess "$CurrentObject depends on $Param{Object}, but the"
                . " constructor of $Param{Object} (class $ClassName) returned undef.";
        }
        else {
            confess "The contrustructor of $Param{Object} (class $ClassName) returned undef.";
        }
    }

    $Self->{Objects}{ $Param{Object} } = $NewObject;

    return $NewObject;
}

=item ObjectConfigGet()

Returns the configuration for a given object

    my $Config = $Kernel::OM->ObjectConfigGet(
        Object  => 'TicketObject',      # Mandatory
    );

=cut

sub ObjectConfigGet {
    my ( $Self, %Param ) = @_;
    my $ObjectName = $Param{Object};
    if ( $ObjectName eq 'ConfigObject' ) {

        # hardcoded to facilitate bootstrapping
        return {
            ClassName    => 'Kernel::Config',
            Dependencies => [],
            OmAware      => 1,
        };
    }

    my $ObjConfig = $Self->{Config}{$ObjectName};
    $ObjConfig ||= $Self->Get('ConfigObject')->Get('Objects')->{$ObjectName};

    if (!$ObjConfig) {
        if ( $CurrentObject && $CurrentObject ne $ObjectName ) {
            confess "$CurrentObject depends on $ObjectName, but $ObjectName is not configured";
        }
        else {
            confess "Object '$ObjectName' is not configured\n";
        }
    }

    $ObjConfig->{Dependencies}
        ||= $Self->Get('ConfigObject')->Get('ObjectManager')->{DefaultDependencies};

    return $ObjConfig;
}

=item ObjectRegister()

Registers an object with the object manager.

    $Kernel::OM->ObjectRegister(
        Name            => 'MyNewObject',       # Mandatory
        Dependencies    => ['ConfigObject'],    # Optional; falls back to default dependencies
        Object          => $TheNewObject,       # Optional
        Param           => {                    # Optional
            YourArgsHere    => 1,
        }
    );

=cut

sub ObjectRegister {
    my ( $Self, %Param ) = @_;

    for my $Param ( 'Name', 'ClassName' ) {
        die "Missing parameter $Param" if !$Param{$Param};
    }

    my $Object = delete $Param{Object};
    $Self->{Objects}{ $Param{Name} } = $Object if $Object;

    my $Name = delete $Param{Name};
    $Self->{Config}{$Name} = \%Param;
}

=item ObjectHash()

Returns a hash of all the already instantiated objects.
The keys are the object names, and the values are the objects themselves.

This method is useful for creating objects of classes that are
not aware of the object manager yet.

    $SomeModule->new($Kernel::OM->ObjectHash());

If the C<Objects> parameter is present, it is interpreted as a list of
object names that must be part of the returned hash.

    $SomeModule->new(
        $Kernel::OM->ObjectHash(
            Objects => ['TicketObject', 'DynamicFieldObject'],
        ),
    );

=cut

sub ObjectHash {
    my ( $Self, %Param ) = @_;

    if ( $Param{Objects} ) {
        for my $Object ( @{ $Param{Objects} } ) {
            $Self->Get($Object);
        }
    }

    return %{ $Self->{Objects} };
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
        if ( ref( $Param{$Key} ) eq 'HASH' ) {
            for my $K ( sort keys %{ $Param{$Key} } ) {
                $Self->{Param}{$Key}{$K} = $Param{$Key}{$K};
            }
        }
        else {
            $Self->{Param}{$Key} = $Param{$Key};
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

    # destroy objects before their dependencies are destroyed

    # first step: get the dependencies into a single hash,
    # so that the topological sorting goes faster
    my %ReverseDeps;
    my @AllObjects;
    for my $Object ( sort keys %{ $Self->{Objects} } ) {
        my $Deps = $Self->ObjectConfigGet(
            Object => $Object,
        )->{Dependencies};

        for my $D (@$Deps) {

            # undef happens to be the value that uses the least amount
            # of memory in perl, and we are only interested in the keys
            $ReverseDeps{$D}{$Object} = undef;
        }
        push @AllObjects, $Object;
    }

    # second step: post-order recursive traversal
    my %Seen;
    my @OrderedObjects;
    my $Traverser;
    $Traverser = sub {
        my ($Obj) = @_;
        return if $Seen{$Obj}++;
        for my $Object (sort keys %{ $ReverseDeps{$Obj} } ) {
            $Traverser->($Object);
        }
        push @OrderedObjects, $Obj;
    };

    if ( $Param{Objects} ) {
        for my $Object ( @{ $Param{Objects} } ) {
            $Traverser->($Object);
        }
    }
    else {
        for my $Object ( @AllObjects ) {
            $Traverser->($Object);
        }
    }
    undef $Traverser;

    # third step: destruction
    if ( $Self->{Debug} ) {
        for my $Object ( @OrderedObjects ) {
            my $Checker = $Self->{Objects}{$Object};
            weaken($Checker);
            delete $Self->{Objects}{$Object};
            if ( defined $Checker ) {
                warn "DESTRUCTION OF $Object FAILED!\n";
                if ( eval { require Devel::Cycle; 1 } ) {
                    Devel::Cycle::find_cycle($Checker);
                }
                else {
                    warn "To get more debugging information, please install Devel::Cycle.";
                }
            }
        }
    }
    else {
        for my $Object ( @OrderedObjects ) {
            delete $Self->{Objects}{$Object};
        }
    }

    # if an object requests an already destroyed object
    # in its DESTROY method, we might hold it again, and must try again
    # (but not infinitely)
    if ( !$Param{Objects} && keys %{ $Self->{Objects } } ) {
        if ( $Self->{DestroyAttempts} && $Self->{DestroyAttempts} > 3 ) {
            Carp::confess("Loop while destroying objects!");
        }

        $Self->{DestroyAttempts}++;
        $Self->ObjectsDiscard();
        $Self->{DestroyAttempts}--;
    }

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
