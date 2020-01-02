# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::Template::Plugin::OTRS;

use strict;
use warnings;

use parent qw(Template::Plugin);

use Scalar::Util;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::Template::Plugin::OTRS - Template Toolkit extension plugin

=head1 PUBLIC INTERFACE

=head2 new()

this plugin registers a few filters and functions in Template::Toolkit.

These extensions have names starting with an uppercase letter so that
you can distinguish them from the builtins of Template::Toolkit which
are always lowercase.

Filters:

    [% Data.MyData  | Translate %]                         - Translate to user language.

    [% Data.Created | Localize("TimeLong") %]              - Format DateTime string according to user's locale.
    [% Data.Created | Localize("TimeShort") %]             - Format DateTime string according to user's locale, without seconds.
    [% Data.Created | Localize("Date") %]                  - Format DateTime string according to user's locale, only date.

    [% Data.Complex | Interpolate %]                       - Treat Data.Complex as a TT template and parse it.

    [% Data.String  | ReplacePlaceholders("one", "two") %] - Replace Data.String placeholders (i.e. %s) with supplied strings.

    [% Data.Complex | JSON %]                              - Convert Data.Complex into a JSON string.

Functions:

    [% Translate("Test string for %s", "Documentation") %]                - Translate text, with placeholders.

    [% Config("Home") %]                                                  - Get SysConfig configuration value.

    [% Env("Baselink") %]                                                 - Get environment value of LayoutObject.

    [% ReplacePlaceholders("This is %s", "<strong>bold text</strong>") %] - Replace string placeholders with supplied values.

=cut

sub new {
    my ( $Class, $Context, @Params ) = @_;

    # Produce a weak reference to the LayoutObject and use that in the filters.
    # We do this because there could be more than one LayoutObject in the process,
    #   so we don't fetch it from the ObjectManager.
    #
    # Don't use $Context in the filters as that creates a circular dependency.
    my $LayoutObject = $Context->{LayoutObject};
    Scalar::Util::weaken($LayoutObject);

    my $ConfigFunction = sub {
        return $Kernel::OM->Get('Kernel::Config')->Get(@_);
    };

    my $EnvFunction = sub {
        return $LayoutObject->{EnvRef}->{ $_[0] };
    };

    my $TranslateFunction = sub {
        return $LayoutObject->{LanguageObject}->Translate(@_);
    };

    my $TranslateFilterFactory = sub {
        my ( $FilterContext, @Parameters ) = @_;
        return sub {
            $LayoutObject->{LanguageObject}->Translate( $_[0], @Parameters );
        };
    };

    my $LocalizeFunction = sub {
        my $Format = $_[1];
        if ( $Format eq 'TimeLong' ) {
            return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormat' );
        }
        elsif ( $Format eq 'TimeShort' ) {
            return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormat', 'NoSeconds' );
        }
        elsif ( $Format eq 'Date' ) {
            return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormatShort' );
        }
        elsif ( $Format eq 'Filesize' ) {
            return $LayoutObject->HumanReadableDataSize( Size => $_[0] );
        }
        return;
    };

    my $LocalizeFilterFactory = sub {
        my ( $FilterContext, @Parameters ) = @_;
        my $Format = $Parameters[0] || 'TimeLong';

        return sub {
            if ( $Format eq 'TimeLong' ) {
                return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormat' );
            }
            elsif ( $Format eq 'TimeShort' ) {
                return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormat', 'NoSeconds' );
            }
            elsif ( $Format eq 'Date' ) {
                return $LayoutObject->{LanguageObject}->FormatTimeString( $_[0], 'DateFormatShort' );
            }
            elsif ( $Format eq 'Filesize' ) {
                return $LayoutObject->HumanReadableDataSize( Size => $_[0] );
            }
            return;
        };
    };

    # This filter processes the data as a template and replaces any contained TT tags.
    # This is expensive and potentially dangerous, use with caution!
    my $InterpolateFunction = sub {

        # Don't parse if there are no TT tags present!
        if ( index( $_[0], '[%' ) == -1 ) {
            return $_[0];
        }
        return $Context->include( \$_[0] );
    };

    my $InterpolateFilterFactory = sub {
        my ( $FilterContext, @Parameters ) = @_;
        return sub {

            # Don't parse if there are no TT tags present!
            if ( index( $_[0], '[%' ) == -1 ) {
                return $_[0];
            }
            return $FilterContext->include( \$_[0] );
        };
    };

    # This filter replaces any placeholder occurrences in first parameter (i.e. %s or %d), with following parameters.
    my $ReplacePlaceholdersFunction = sub {
        my ( $Text, @Parameters ) = @_;

        $Text //= '';

        return $Text if !@Parameters;

        for ( 0 .. $#Parameters ) {
            return $Text if !defined $Parameters[$_];
            $Text =~ s/%(s|d)/$Parameters[$_]/;
        }

        return $Text;
    };

    my $ReplacePlaceholdersFilter = sub {
        my ( $FilterContext, @Parameters ) = @_;
        return sub {
            return $ReplacePlaceholdersFunction->( $_[0], @Parameters );
        };
    };

    my $JSONFunction = sub {
        return $LayoutObject->JSONEncode( Data => $_[0] );
    };

    my $JSONFilter = sub {
        return $LayoutObject->JSONEncode( Data => $_[0] );
    };

    $Context->stash()->set( 'Config',              $ConfigFunction );
    $Context->stash()->set( 'Env',                 $EnvFunction );
    $Context->stash()->set( 'Translate',           $TranslateFunction );
    $Context->stash()->set( 'Localize',            $LocalizeFunction );
    $Context->stash()->set( 'Interpolate',         $InterpolateFunction );
    $Context->stash()->set( 'ReplacePlaceholders', $ReplacePlaceholdersFunction );
    $Context->stash()->set( 'JSON',                $JSONFunction );

    $Context->define_filter( 'Translate',           [ $TranslateFilterFactory,    1 ] );
    $Context->define_filter( 'Localize',            [ $LocalizeFilterFactory,     1 ] );
    $Context->define_filter( 'Interpolate',         [ $InterpolateFilterFactory,  1 ] );
    $Context->define_filter( 'ReplacePlaceholders', [ $ReplacePlaceholdersFilter, 1 ] );
    $Context->define_filter( 'JSON', $JSONFilter );

    return bless {
        _CONTEXT => $Context,
        _PARAMS  => \@Params,
    }, $Class;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
