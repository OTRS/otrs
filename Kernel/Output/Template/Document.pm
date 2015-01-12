# --
# Kernel/Output/Template/Document.pm - Template Toolkit document
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::Template::Document;
## no critic(Perl::Critic::Policy::OTRS::RequireCamelCase)

use strict;
use warnings;

use base qw (Template::Document);

=head1 NAME

Kernel::Output::Template::Document - Template Toolkit document extension package

=head1 PUBLIC INTERFACE

=over 4

=cut

=item process()

process this template document. This method is inherited from
Template::Document and used to perform some up-front initialization
and processing.

=cut

sub process {
    my ( $Self, $Context ) = @_;

    $Self->_InstallOTRSExtensions($Context);
    $Self->_PrecalculateBlockStructure($Context);

    return $Self->SUPER::process($Context);
}

=item _InstallOTRSExtensions()

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
            $_tt_params = shift;
            $_tt_params = {} if ref $_tt_params ne 'HASH';
            $_tt_params = { %_tt_args, %$_tt_params };

            my $stash = $Context->localise($_tt_params);
            eval {

                my $BlockName = $stash->get('BlockName');
                my $ParentBlock = $stash->get('ParentBlock') || $stash->{_BlockTree};

                return if !exists $ParentBlock->{Children};
                return if !exists $ParentBlock->{Children}->{$BlockName};

                for my $TargetBlock ( @{ $ParentBlock->{Children}->{$BlockName} } ) {
                    $output .= $Context->process(
                        $TargetBlock->{Path},
                        {
                            'Data'        => $TargetBlock->{Data},
                            'ParentBlock' => $TargetBlock,
                        },
                    );
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
    #     [% WRAPPER JSOnDocumentComplete -% ]
    #         console.log();
    #     [%- END % ]
    # %]
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
            $Code =~ s{ \s* <script[^>]+> (?:\s*<!--)? (?:\s*//\s*<!\[CDATA\[)? \n? }{}smxg;
            $Code =~ s{ \s* (?:-->\s*)? (?://\s*\]\]>\s*)? </script> \n? }{}smxg;
            $output .= $Code;
            delete $context->{LayoutObject}->{_JSOnDocumentComplete};

        };

        if ($@) {
            $_tt_error = $context->catch( $@, \$output );
            die $_tt_error if $_tt_error->type() ne 'return';
        }

        return $output;
    };

    return;
}

=item _PrecalculateBlockStructure()

pre-calculates the tree structure of the blocks so that it
can be used by PerformRenderBlock in an efficient way.

=cut

sub _PrecalculateBlockStructure {
    my ( $Self, $Context ) = @_;

    #
    # TODO cache result in current object?
    #
    my $Defblocks = $Self->{_DEFBLOCKS} || {};

    my $BlockData = $Context->stash()->get( [ 'global', 0, 'BlockData', 0 ] ) || [];

    return if !@{$BlockData};

    my $BlockParents = {};
    my $BlockPaths   = {};

    BLOCKPATHIDENTIFIER:
    for my $BlockIdentifier ( sort keys %{$Defblocks} ) {
        my @BlockPath = split( m{/}, $BlockIdentifier );
        my $BlockPathLength = scalar @BlockPath;
        next BLOCKPATHIDENTIFIER if !$BlockPathLength;
        $BlockPaths->{ $BlockPath[-1] } = $BlockIdentifier;
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
