# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::Template::Document;
## no critic(Perl::Critic::Policy::OTRS::RequireCamelCase)

use strict;
use warnings;

use parent qw (Template::Document);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::Template::Document - Template Toolkit document extension package

=head1 PUBLIC INTERFACE

=head2 process()

process this template document. This method is inherited from
Template::Document and used to perform some up-front initialization
and processing.

=cut

sub process {
    my ( $Self, $Context ) = @_;

    $Self->_InstallOTRSExtensions($Context);
    $Self->_PrecalculateBlockStructure($Context);
    $Self->_PrecalculateBlockHookSubscriptions($Context);

    return $Self->SUPER::process($Context);
}

=begin Internal:

=head2 _InstallOTRSExtensions()

adds some OTRS specific extensions to Template::Toolkit.

=cut

sub _InstallOTRSExtensions {
    my ( $Self, $Context ) = @_;

    # Already installed, nothing to do.
    return if $Context->stash()->get('OTRS');

    #
    # Load the OTRS plugin. This will register some filters and functions.
    #
    $Context->stash()->set( 'OTRS', $Context->plugin('OTRS') );

    #
    # The RenderBlock macro makes it possible to use the old dtl:block-Style block calls
    #   that are still used by OTRS with Template::Toolkit.
    #
    # The block data is passed to the template, and this macro processes it and calls the relevant
    #   blocks.
    #
    $Context->stash()->set(
        'PerformRenderBlock',
        sub {
            my $output = '';
            my ( %_tt_args, $_tt_params );
            $_tt_args{'BlockName'} = shift;
            $_tt_params            = shift;
            $_tt_params            = {} if ref $_tt_params ne 'HASH';
            $_tt_params            = { %_tt_args, %$_tt_params };

            my $stash = $Context->localise($_tt_params);
            eval {

                my $BlockName   = $stash->get('BlockName');
                my $ParentBlock = $stash->get('ParentBlock') || $stash->{_BlockTree};

                return if !exists $ParentBlock->{Children};
                return if !exists $ParentBlock->{Children}->{$BlockName};

                my $TemplateName = $stash->get('template')->{name} // '';
                $TemplateName = substr( $TemplateName, 0, -3 );    # remove .tt extension
                my $GenerateBlockHook =
                    $Context->{LayoutObject}->{_BlockHookSubscriptions}->{$TemplateName}->{$BlockName};

                for my $TargetBlock ( @{ $ParentBlock->{Children}->{$BlockName} } ) {
                    $output .= "<!--HookStart${BlockName}-->\n" if $GenerateBlockHook;
                    $output .= $Context->process(
                        $TargetBlock->{Path},
                        {
                            'Data'        => $TargetBlock->{Data},
                            'ParentBlock' => $TargetBlock,
                        },
                    );
                    $output .= "<!--HookEnd${BlockName}-->\n" if $GenerateBlockHook;
                }
                delete $ParentBlock->{Children}->{$BlockName};

            };
            $stash = $Context->delocalise();

            die $@ if $@;
            return $output;
        }
    );

    #
    # This block is used to cut out JavaScript code from the templates and insert it in the
    #     footer of the page, all in one place.
    #
    # Usage:
    #     [% WRAPPER JSOnDocumentComplete -%]
    #         console.log();
    #     [%- END %]
    #

    $Self->{_DEFBLOCKS}->{JSOnDocumentComplete} //= sub {
        my $context = shift || die "template sub called without context\n";
        my $stash   = $context->stash();
        my $output  = '';
        my $_tt_error;

        eval {
            if ( $stash->get( [ 'global', 0, 'KeepScriptTags', 0 ] ) ) {
                $output .= $stash->get('content');
            }
            else {
                push @{ $context->{LayoutObject}->{_JSOnDocumentComplete} }, $stash->get('content');
            }

        };
        if ($@) {
            $_tt_error = $context->catch( $@, \$output );
            die $_tt_error if $_tt_error->type() ne 'return';
        }

        return $output;
    };

    #
    # This block is used to insert the collected JavaScript code in the page footer.
    #

    $Self->{_DEFBLOCKS}->{JSOnDocumentCompleteInsert} //= sub {
        my $context = shift || die "template sub called without context\n";
        my $stash   = $context->stash();
        my $output  = '';
        my $_tt_error;

        eval {

            my $Code = join "\n", @{ $context->{LayoutObject}->{_JSOnDocumentComplete} || [] };

            # remove opening script tags
            $Code =~ s{ \s* <script[^>]+> (?:\s*<!--)? (?:\s*//\s*<!\[CDATA\[)? \n? }{}smxg;

            # remove closing script tags
            $Code =~ s{ \s* (?:-->\s*)? (?://\s*\]\]>\s*)? </script> \n? }{\n\n}smxg;

            # remove additional newlines at the end of the code block
            $Code =~ s{ \n+ \z }{\n}smxg;

            $output .= $Code;
            delete $context->{LayoutObject}->{_JSOnDocumentComplete};
        };

        if ($@) {
            $_tt_error = $context->catch( $@, \$output );
            die $_tt_error if $_tt_error->type() ne 'return';
        }

        return $output;
    };

    #
    # This block is used to cut out JavaScript data that needs to be inserted to Core.Config
    #   from the templates and insert it in the footer of the page, all in one place.
    #
    # Usage:
    #     [% Process JSData
    #         Key   = 'Test.Key'
    #         Value = { ... }
    #     %]
    #
    #

    $Self->{_DEFBLOCKS}->{JSData} //= sub {
        my $context = shift || die "template sub called without context\n";
        my $stash   = $context->stash();
        my $output  = '';

        my $_tt_error;

        eval {

            my $Key   = $stash->get('Key');
            my $Value = $stash->get('Value');

            return $output if !$Key;

            $context->{LayoutObject}->{_JSData} //= {};
            $context->{LayoutObject}->{_JSData}->{$Key} = $Value;

        };
        if ($@) {
            $_tt_error = $context->catch( $@, \$output );
            die $_tt_error if $_tt_error->type() ne 'return';
        }

        return $output;
    };

    #
    # This block is used to insert the collected JavaScript data in the page footer.
    #

    $Self->{_DEFBLOCKS}->{JSDataInsert} //= sub {
        my $context = shift || die "template sub called without context\n";
        my $stash   = $context->stash();
        my $output  = '';
        my $_tt_error;

        eval {
            my %Data = %{ $context->{LayoutObject}->{_JSData} // {} };
            if (%Data) {
                my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                    Data     => \%Data,
                    SortKeys => 1,
                );

                # Escape closing script tags in the JSON content as they will confuse the
                #   browser's parser.
                $JSONString =~ s{ </(?<ScriptTag>script)}{<\\/$+{ScriptTag}}ismxg;

                $output .= "Core.Config.AddConfig($JSONString);\n";
            }
            delete $context->{LayoutObject}->{_JSData};
        };

        if ($@) {
            $_tt_error = $context->catch( $@, \$output );
            die $_tt_error if $_tt_error->type() ne 'return';
        }

        return $output;
    };

    return;
}

=head2 _PrecalculateBlockStructure()

pre-calculates the tree structure of the blocks so that it
can be used by PerformRenderBlock in an efficient way.

=cut

sub _PrecalculateBlockStructure {
    my ( $Self, $Context ) = @_;

    my $Defblocks = $Self->{_DEFBLOCKS} || {};

    my $BlockData = $Context->stash()->get( [ 'global', 0, 'BlockData', 0 ] ) || [];

    return if !@{$BlockData};

    my $BlockParents = {};
    my $BlockPaths   = {};

    BLOCKPATHIDENTIFIER:
    for my $BlockIdentifier ( sort keys %{$Defblocks} ) {
        my @BlockPath       = split( m{/}, $BlockIdentifier );
        my $BlockPathLength = scalar @BlockPath;
        next BLOCKPATHIDENTIFIER if !$BlockPathLength;
        $BlockPaths->{ $BlockPath[-1] }   = $BlockIdentifier;
        $BlockParents->{ $BlockPath[-1] } = [ splice( @BlockPath, 0, $BlockPathLength - 1 ) ];
    }

    $Context->stash()->{_BlockTree} = {};

    my $BlockIndex = 0;

    BLOCK:
    while ( $BlockIndex < @{$BlockData} ) {
        my $Block     = $BlockData->[$BlockIndex];
        my $BlockName = $Block->{Name};

        if ( !exists $BlockPaths->{$BlockName} ) {
            $BlockIndex++;
            next BLOCK;
        }

        my $BlockPointer = $Context->stash()->{_BlockTree};

        PARENTBLOCK:
        for my $ParentBlock ( @{ $BlockParents->{$BlockName} // [] } ) {

            # Check if a parent node can be found
            if (
                !exists $BlockPointer->{Children}
                || !exists $BlockPointer->{Children}->{$ParentBlock}
                )
            {
                # Parent node was not found. That means we dan discard this block.
                splice @{$BlockData}, $BlockIndex, 1;
                next BLOCK;
            }

            # Ok, parent block found, update block pointer to last element
            $BlockPointer = $BlockPointer->{Children}->{$ParentBlock}->[-1];
        }

        $Block->{Path} = $BlockPaths->{$BlockName};

        # Ok, the parent block pointer was apparently set correctly.
        # Now append the data of our current block.
        push @{ $BlockPointer->{Children}->{$BlockName} }, $Block;

        # Remove block data
        splice @{$BlockData}, $BlockIndex, 1;
    }

    return;
}

=head2 _PrecalculateBlockHookSubscriptions()

=cut

sub _PrecalculateBlockHookSubscriptions {
    my ( $Self, $Context ) = @_;

    # Only calculate once per LayoutObject
    return if defined $Context->{LayoutObject}->{_BlockHookSubscriptions};

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Template::GenerateBlockHooks') // {};

    my %BlockHooks;

    for my $Key ( sort keys %{ $Config // {} } ) {
        for my $Template ( sort keys %{ $Config->{$Key} // {} } ) {
            for my $Block ( @{ $Config->{$Key}->{$Template} // [] } ) {
                $BlockHooks{$Template}->{$Block} = 1;
            }
        }
    }

    $Context->{LayoutObject}->{_BlockHookSubscriptions} = \%BlockHooks;

    return;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
