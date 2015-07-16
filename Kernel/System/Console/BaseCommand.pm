# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::BaseCommand;

use strict;
use warnings;

use Getopt::Long();
use Term::ANSIColor();
use IO::Interactive();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Encode',
    'Kernel::System::Main',
);

our $SuppressANSI = 0;

=head1 NAME

Kernel::System::Console::Command - command base class

=head1 SYNOPSIS

Base class for console commands.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

constructor for new objects. You should not need to reimplement this in your command,
override L</Configure()> instead if you need to.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # for usage help
    $Self->{Name} = $Type;
    $Self->{Name} =~ s{Kernel::System::Console::Command::}{}smx;

    $Self->{ANSI} = 1;

    # Check if we are in an interactive terminal, disable colors otherwise.
    if ( !IO::Interactive::is_interactive() ) {
        $Self->{ANSI} = 0;
    }

    # Force creation of the EncodeObject as it initialzes STDOUT/STDERR for unicode output.
    $Kernel::OM->Get('Kernel::System::Encode');

    # Call object specific configure method. We use an eval to trap any exceptions
    #   that might occur here. Only if everything was ok we set the _ConfigureSuccessful
    #   flag.
    eval {
        $Self->Configure();
        $Self->{_ConfigureSuccessful} = 1;
    };

    $Self->{_GlobalOptions} = [
        {
            Name        => 'help',
            Description => 'Display help for this command.',
        },
        {
            Name        => 'no-ansi',
            Description => 'Do not perform ANSI terminal output coloring.',
        },
    ];

    return $Self;
}

=item Configure()

initializes this object. Override this method in your commands.

This method might throw exceptions.

=cut

sub Configure {
    return;
}

=item Name()

get the Name of the current Command, e. g. 'Admin::User::SetPassword'.

=cut

sub Name {
    my ($Self) = @_;

    return $Self->{Name};
}

=item Description()

get/set description for the current command. Call this in your Configure() method.

=cut

sub Description {
    my ( $Self, $Description ) = @_;

    $Self->{Description} = $Description if defined $Description;

    return $Self->{Description};
}

=item AdditionalHelp()

get/set additional help text for the current command. Call this in your Configure() method.

You can use color tags (see L</Print()>) in your help tags.

=cut

sub AdditionalHelp {
    my ( $Self, $AdditionalHelp ) = @_;

    $Self->{AdditionalHelp} = $AdditionalHelp if defined $AdditionalHelp;

    return $Self->{AdditionalHelp};
}

=item AddArgument()

adds an argument that can/must be specified on the command line.
This function must be called during Configure() by the command to
indicate which arguments it can process.

    $CommandObject->AddArgument(
        Name         => 'filename',
        Description  => 'name of the file to be loaded',
        Required     => 1,
        ValueRegex   => qr{a-zA-Z0-9]\.txt},
    );

Please note that required arguments have to be specified before any optional ones.

The information about known arguments and options (see below) will be used to generate
usage help and also to automatically verify the data provided by the user on the commandline.

=cut

sub AddArgument {
    my ( $Self, %Param ) = @_;

    for my $Key (qw(Name Description ValueRegex)) {
        if ( !$Param{$Key} ) {
            $Self->PrintError("Need $Key.");
            die;
        }
    }

    for my $Key (qw(Required)) {
        if ( !defined $Param{$Key} ) {
            $Self->PrintError("Need $Key.");
            die;
        }
    }

    if ( $Self->{_ArgumentSeen}->{ $Param{Name} }++ ) {
        $Self->PrintError("Cannot register argument '$Param{Name}' twice.");
        die;
    }

    if ( $Self->{_OptionSeen}->{ $Param{Name} } ) {
        $Self->PrintError("Cannot add argument '$Param{Name}', because it is already registered as an option.");
        die;
    }

    $Self->{_Arguments} //= [];
    push @{ $Self->{_Arguments} }, \%Param;
}

=item GetArgument()

fetch an argument value as provided by the user on the commandline.

    my $Filename = $CommandObject->GetArgument('filename');

=cut

sub GetArgument {
    my ( $Self, $Argument ) = @_;

    if ( !$Self->{_ArgumentSeen}->{$Argument} ) {
        $Self->PrintError("Argument '$Argument' was not configured and cannot be accessed.");
        return;
    }

    return $Self->{_ParsedARGV}->{Arguments}->{$Argument};
}

=item AddOption()

adds an option that can/must be specified on the command line.
This function must be called during L</Configure()> by the command to
indicate which arguments it can process.

    $CommandObject->AddOption(
        Name         => 'iterations',
        Description  => 'number of script iterations to perform',
        Required     => 1,
        HasValue     => 0,
        ValueRegex   => qr{\d+},
        Multiple     => 0,  # optional, allow more than one occurrence (only possible if HasValue is true)
    );

=head4 Option Naming Conventions

If there is a source and a target involved in the command, the related options should start
with C<--source> and C<--target>, for example C<--source-path>.

For specifying filesystem locations, C<--*-path> should be used for directory/filename
combinations (e.g. C<mydirectory/myfile.pl>), C<--*-filename> for filenames without directories,
and C<--*-directory> for directories.

Example: C<--target-path /tmp/test.out --source-filename test.txt --source-directory /tmp>

=cut

sub AddOption {
    my ( $Self, %Param ) = @_;

    for my $Key (qw(Name Description)) {
        if ( !$Param{$Key} ) {
            $Self->PrintError("Need $Key.");
            die;
        }
    }

    for my $Key (qw(Required HasValue)) {
        if ( !defined $Param{$Key} ) {
            $Self->PrintError("Need $Key.");
            die;
        }
    }

    if ( $Param{HasValue} ) {
        if ( !$Param{ValueRegex} ) {
            $Self->PrintError("Need ValueRegex.");
            die;
        }
    }

    if ( $Param{Multiple} && !$Param{HasValue} ) {
        $Self->PrintError("Multiple can only be specified if HasValue is true.");
        die;
    }

    if ( $Self->{_OptionSeen}->{ $Param{Name} }++ ) {
        $Self->PrintError("Cannot register option '$Param{Name}' twice.");
        die;
    }

    if ( $Self->{_ArgumentSeen}->{ $Param{Name} } ) {
        $Self->PrintError("Cannot add option '$Param{Name}', because it is already registered as an argument.");
        die;
    }

    $Self->{_Options} //= [];
    push @{ $Self->{_Options} }, \%Param;

}

=item GetOption()

fetch an option as provided by the user on the commandline.

    my $Iterations = $CommandObject->GetOption('iterations');

If the option was specified with HasValue => 1, the user provided value will be
returned. Otherwise 1 will be returned if the option was present.

In case of an option with C<Multiple => 1>, an array reference will be returned
if the option was specified, and undef otherwise.

=cut

sub GetOption {
    my ( $Self, $Option ) = @_;

    if ( !$Self->{_OptionSeen}->{$Option} ) {
        $Self->PrintError("Option '--$Option' was not configured and cannot be accessed.");
        return;
    }

    return $Self->{_ParsedARGV}->{Options}->{$Option};

}

=item PreRun()

perform additional validations/preparations before Run(). Override this method in your commands.

If this method returns, execution will be continued. If it throws an exception with die(), the program aborts at this point, and Run() will not be called.

=cut

sub PreRun {
    return 1;
}

=item Run()

runs the command. Override this method in your commands.

This method needs to return the exit code to be used for the whole program.
For this, the convenience methods ExitCodeOk() and ExitCodeError() can be used.

In case of an exception, the error code will be set to 1 (error).

=cut

sub Run {
    my $Self = shift;

    return $Self->ExitCodeOk();
}

=item PostRun()

perform additional cleanups after Run(). Override this method in your commands.

The return value of this method will be ignored. It will be called after Run(), even
if Run() caused an exception or returned an error exit code.

In case of an exception in this method, the exit code will be set to 1 (error) if
Run() returned 0 (ok).

=cut

sub PostRun {
    return;
}

=item Execute()

this method will parse/validate the commandline arguments supplied by the user.
If that was ok, the Run() method of the command will be called.

=cut

sub Execute {
    my ( $Self, @CommandlineArguments ) = @_;

    # Normally, nothing was logged until this point, so the LogObject does not exist yet.
    #   Change the LogPrefix so that it indicates which command causes the log entry.
    #   In future we might need to check if it was created and update it on the fly.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => 'OTRS-otrs.Console.pl-' . $Self->Name(),
        },
    );

    # Don't allow to run these scripts as root.
    if ( $> == 0 ) {    # $EFFECTIVE_USER_ID
        $Self->PrintError(
            "You cannot run otrs.Console.pl as root. Please run it as the 'otrs' user or with the help of su:"
        );
        $Self->Print("  <yellow>su -c \"bin/otrs.Console.pl MyCommand\" -s /bin/bash otrs</yellow>\n");
        return $Self->ExitCodeError();
    }

    # Disable in-memory cache to avoid problems with long running scripts.
    $Kernel::OM->Get('Kernel::System::Cache')->Configure(
        CacheInMemory => 0,
    );

    # Only run if the command was setup ok.
    if ( !$Self->{_ConfigureSuccessful} ) {
        $Self->PrintError("Aborting because the command was not successfully configured.");
        return $Self->ExitCodeError();
    }

    # First handle the optional global options.
    my $ParsedGlobalOptions = $Self->_ParseGlobalOptions( \@CommandlineArguments );
    if ( $ParsedGlobalOptions->{'no-ansi'} ) {
        $Self->ANSI(0);
    }
    if ( $ParsedGlobalOptions->{help} ) {
        print "\n" . $Self->GetUsageHelp();
        return $Self->ExitCodeOk();
    }

    # Parse command line arguments and bail out in case of error,
    # of course with a helpful usage screen.
    $Self->{_ParsedARGV} = $Self->_ParseCommandlineArguments( \@CommandlineArguments );
    if ( !%{ $Self->{_ParsedARGV} // {} } ) {
        print STDERR "\n" . $Self->GetUsageHelp();
        return $Self->ExitCodeError();
    }

    eval { $Self->PreRun(); };
    if ($@) {
        $Self->PrintError($@);
        return $Self->ExitCodeError();
    }

    # Make sure we get a proper exit code to return to the shell.
    my $ExitCode;
    eval {
        # Make sure that PostRun() works even if a user presses ^C.
        local $SIG{INT} = sub {
            $Self->PostRun();
            exit $Self->ExitCodeError();
        };
        $ExitCode = $Self->Run();
    };
    if ($@) {
        $Self->PrintError($@);
        $ExitCode = $Self->ExitCodeError();
    }

    eval { $Self->PostRun(); };
    if ($@) {
        $Self->PrintError($@);
        $ExitCode ||= $Self->ExitCodeError();    # switch from 0 (ok) to error
    }

    if ( !defined $ExitCode ) {
        $Self->PrintError("Command $Self->{Name} did not return a proper exit code.");
        $ExitCode = $Self->ExitCodeError();
    }

    return $ExitCode;
}

=item ExitCodeError()

returns an exit code to signal something went wrong (mostly for better
code readabiliby).

    return $CommandObject->ExitCodeError();

You can also provide a custom error code for special use cases:

    return $CommandObject->ExitCodeError(255);

=cut

sub ExitCodeError {
    my ( $Self, $CustomExitCode ) = @_;

    return $CustomExitCode // 1;
}

=item ExitCodeOk()

returns 0 as exit code to indicate everything went fine in the command
(mostly for better code readability).

=cut

sub ExitCodeOk {
    return 0;
}

=item GetUsageHelp()

generates usage / help screen for this command.

    my $UsageHelp = $CommandObject->GetUsageHelp();

=cut

sub GetUsageHelp {
    my $Self = shift;

    my $UsageText = "<green>$Self->{Description}</green>\n";
    $UsageText .= "\n<yellow>Usage:</yellow>\n";
    $UsageText .= " otrs.Console.pl $Self->{Name}";

    my $OptionsText   = "<yellow>Options:</yellow>\n";
    my $ArgumentsText = "<yellow>Arguments:</yellow>\n";

    OPTION:
    for my $Option ( @{ $Self->{_Options} // [] } ) {
        my $OptionShort = "--$Option->{Name}";
        if ( $Option->{HasValue} ) {
            $OptionShort .= " ...";
            if ( $Option->{Multiple} ) {
                $OptionShort .= "(+)";
            }
        }
        if ( !$Option->{Required} ) {
            $OptionShort = "[$OptionShort]";
        }
        $UsageText .= " $OptionShort";
        $OptionsText .= sprintf " <green>%-30s</green> - %s", $OptionShort, $Option->{Description} . "\n";
    }

    # Global options only show up at the end of the options section, but not in the command line string as
    #   they don't actually belong to the current command (only).
    GLOBALOPTION:
    for my $Option ( @{ $Self->{_GlobalOptions} // [] } ) {
        my $OptionShort = "[--$Option->{Name}]";
        $OptionsText .= sprintf " <green>%-30s</green> - %s", $OptionShort, $Option->{Description} . "\n";
    }

    ARGUMENT:
    for my $Argument ( @{ $Self->{_Arguments} // [] } ) {
        my $ArgumentShort = $Argument->{Name};
        if ( !$Argument->{Required} ) {
            $ArgumentShort = "[$ArgumentShort]";
        }
        $UsageText .= " $ArgumentShort";
        $ArgumentsText .= sprintf " <green>%-30s</green> - %s", $ArgumentShort,
            $Argument->{Description} . "\n";
    }

    $UsageText .= "\n";

    $UsageText .= "\n$OptionsText";    # Always present because of global options

    if ( @{ $Self->{_Arguments} // [] } ) {
        $UsageText .= "\n$ArgumentsText";
    }

    if ( $Self->AdditionalHelp() ) {
        $UsageText .= "\n<yellow>Help:</yellow>\n";
        $UsageText .= $Self->AdditionalHelp();
    }

    $UsageText .= "\n";

    return $Self->_ReplaceColorTags($UsageText);
}

=item ANSI()

get/set support for colored text.

=cut

sub ANSI {
    my ( $Self, $ANSI ) = @_;

    $Self->{ANSI} = $ANSI if defined $ANSI;
    return $Self->{ANSI};
}

=item PrintError()

shorthand method to print an error message to STDERR.

It will be prefixed with 'Error: ' and colored in red,
if the terminal supports it (see L</ANSI()>).

=cut

sub PrintError {
    my ( $Self, $Text ) = @_;

    chomp $Text;
    print STDERR $Self->_Color( 'red', "Error: $Text\n" );
    return;
}

=item Print()

this method will print the given text to STDOUT.

You can add color tags (C<< <green>...</green>, <yellow>...</yellow>, <red>...</red> >>)
to your text, and they will be replaced with the corresponding terminal escape sequences
if the terminal supports it (see L</ANSI()>).

=cut

sub Print {
    my ( $Self, $Text ) = @_;

    print $Self->_ReplaceColorTags($Text);
    return;
}

=item _ParseGlobalOptions()

parses any global options possibly provided by the user.

Returns a hash with the option values.

=cut

sub _ParseGlobalOptions {
    my ( $Self, $Arguments ) = @_;

    Getopt::Long::Configure('pass_through');
    Getopt::Long::Configure('no_auto_abbrev');

    my %OptionValues;

    OPTION:
    for my $Option ( @{ $Self->{_GlobalOptions} } ) {
        my $Value;
        my $Lookup = $Option->{Name};

        Getopt::Long::GetOptionsFromArray(
            $Arguments,
            $Lookup => \$Value,
        );

        $OptionValues{ $Option->{Name} } = $Value;
    }

    return \%OptionValues;
}

=item _ParseCommandlineArguments()

parses and validates the commandline arguments provided by the user according to
the configured arguments and options of the command.

Returns a hash with argument and option values if all needed values were supplied
and correct, or undef otherwise.

=cut

sub _ParseCommandlineArguments {
    my ( $Self, $Arguments ) = @_;

    Getopt::Long::Configure('pass_through');
    Getopt::Long::Configure('no_auto_abbrev');

    my %OptionValues;

    OPTION:
    for my $Option ( @{ $Self->{_Options} // [] }, @{ $Self->{_GlobalOptions} } ) {
        my $Lookup = $Option->{Name};
        if ( $Option->{HasValue} ) {
            $Lookup .= '=s';
            if ( $Option->{Multiple} ) {
                $Lookup .= '@';
            }
        }

        # Option with multiple values
        if ( $Option->{HasValue} && $Option->{Multiple} ) {

            my @Values;

            Getopt::Long::GetOptionsFromArray(
                $Arguments,
                $Lookup => \@Values,
            );

            if ( !@Values ) {
                if ( !$Option->{Required} ) {
                    next OPTION;
                }

                $Self->PrintError("please provide option '--$Option->{Name}'.");
                return;
            }

            for my $Value (@Values) {
                if ( $Option->{HasValue} && $Value !~ $Option->{ValueRegex} ) {
                    $Self->PrintError("please provide a valid value for option '--$Option->{Name}'.");
                    return;
                }
            }

            $OptionValues{ $Option->{Name} } = \@Values;
        }

        # Option with no or a single value
        else {

            my $Value;

            Getopt::Long::GetOptionsFromArray(
                $Arguments,
                $Lookup => \$Value,
            );

            if ( !defined $Value ) {
                if ( !$Option->{Required} ) {
                    next OPTION;
                }

                $Self->PrintError("please provide option '--$Option->{Name}'.");
                return;
            }

            if ( $Option->{HasValue} && $Value !~ $Option->{ValueRegex} ) {
                $Self->PrintError("please provide a valid value for option '--$Option->{Name}'.");
                return;
            }

            $OptionValues{ $Option->{Name} } = $Value;
        }
    }

    my %ArgumentValues;

    ARGUMENT:
    for my $Argument ( @{ $Self->{_Arguments} // [] } ) {
        if ( !@{$Arguments} ) {
            if ( !$Argument->{Required} ) {
                next ARGUMENT;
            }

            $Self->PrintError("please provide a value for argument '$Argument->{Name}'.");
            return;
        }

        my $Value = shift @{$Arguments};

        if ( $Value !~ $Argument->{ValueRegex} ) {
            $Self->PrintError("please provide a valid value for argument '$Argument->{Name}'.");
            return;
        }

        $ArgumentValues{ $Argument->{Name} } = $Value;
    }

    # check for superfluous arguments
    if ( @{$Arguments} ) {
        my $Error = "found unknown arguments on the command line ('";
        $Error .= join "', '", @{$Arguments};
        $Error .= "').\n";
        $Self->PrintError($Error);
        return;
    }

    return {
        Options   => \%OptionValues,
        Arguments => \%ArgumentValues,
    };
}

=item _Color()

this will color the given text (see Term::ANSIColor::color()) if
ANSI output is available and active, otherwise the text stays unchanged.

    my $PossiblyColoredText = $CommandObject->_Color('green', $Text);

=cut

sub _Color {
    my ( $Self, $Color, $Text ) = @_;

    return $Text if !$Self->{ANSI};
    return $Text if $SuppressANSI;
    return Term::ANSIColor::color($Color) . $Text . Term::ANSIColor::color('reset');
}

sub _ReplaceColorTags {
    my ( $Self, $Text ) = @_;
    $Text =~ s{<(green|yellow|red)>(.*?)</\1>}{$Self->_Color($1, $2)}gsmxe;
    return $Text;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
