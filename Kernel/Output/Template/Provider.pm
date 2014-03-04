# --
# Kernel/Output/Template/Provider.pm - Template Toolkit provider
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::Template::Provider;
## no critic(Perl::Critic::Policy::OTRS::RequireCamelCase)
## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck) # bails on TT Constants

use strict;
use warnings;

use base qw (Template::Provider);

use Scalar::Util qw();
use Template::Constants;

use Kernel::Output::Template::Document;
use Kernel::System::Cache;

# Force the use of our own document class.
$Template::Provider::DOCUMENT = 'Kernel::Output::Template::Document';

=head1 NAME

Kernel::Output::Template::Provider - Template Toolkit custom provider

=head1 PUBLIC INTERFACE

=over 4

=cut

=item OTRSInit()

performs some post-initialization and creates a bridget between Template::Toolkit
and OTRS by adding the OTRS objects to the Provider object. This method must be
called after instantiating the Provider object.

Please note that we only store a weak reference to the LayoutObject to avoid ring
references.

=cut

sub OTRSInit {
    my ( $Self, %Param ) = @_;

    for my $Needed (
        qw(ConfigObject LogObject TimeObject MainObject EncodeObject LayoutObject ParamObject)
        )
    {
        if ( $Param{$Needed} ) {
            $Self->{$Needed} = $Param{$Needed};
        }
        else {
            die "Got no $Needed!";
        }
    }

    #
    # Store a weak reference to the LayoutObject to avoid ring references.
    #   We need it for the filters.
    #
    Scalar::Util::weaken( $Self->{LayoutObject} );

    # CacheObject is needed for caching of the compiled templates.
    $Self->{CacheObject} = $Kernel::OM->Get('CacheObject');
    $Self->{CacheType}   = 'TemplateProvider';

    #
    # Pre-compute the list of not cacheable Templates. If a pre-output filter is
    #   registered for a particular or for all templates, the template cannot be
    #   cached any more.
    #
    $Self->{FilterElementPre} = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre');

    my %UncacheableTemplates;

    my %FilterList = %{ $Self->{FilterElementPre} || {} };

    FILTER:
    for my $Filter ( sort keys %FilterList ) {

        # extract filter config
        my $FilterConfig = $FilterList{$Filter};

        next FILTER if !$FilterConfig;
        next FILTER if ref $FilterConfig ne 'HASH';

        # extract template list
        my %TemplateList = %{ $FilterConfig->{Templates} || {} };

        if ( !%TemplateList ) {

            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Please add a template list to output filter $FilterConfig->{Module} "
                    . "to improve performance. Use ALL if OutputFilter should modify all "
                    . "templates of the system (deprecated).",
            );

            next FILTER;
        }

        @UncacheableTemplates{ keys %TemplateList } = values %TemplateList;
    }

    $Self->{UncacheableTemplates} = \%UncacheableTemplates;
}

=item _fetch()

try to get a compiled version of a template from the CacheObject,
otherwise compile the template and return it.

Copied and slightly adapted from Template::Provider.

A note about caching: we have three levels of caching.

    1. For cacheable templates, we have an in-memory cache that stores the compiled Document objects (fastest).
    2. For cacheable templates, we store the parsed data in the CacheObject to be re-used in another request.
    3. For non-cacheable templates and string templates, we have an in-memory cache in the parsing method _compile().
        It will return the already parsed object if it sees the same template content again.

=cut

sub _fetch {
    my ( $self, $name, $t_name ) = @_;
    my $stat_ttl = $self->{STAT_TTL};

    $self->debug("_fetch($name)") if $self->{DEBUG};

    my $TemplateIsCacheable
        = !$self->{UncacheableTemplates}->{ALL} && !$self->{UncacheableTemplates}->{$t_name};

    # Check in-memory template cache if we already had this template.
    $self->{_TemplateCache} //= {};

    if ( $TemplateIsCacheable && $self->{_TemplateCache}->{$name} ) {
        return $self->{_TemplateCache}->{$name};
    }

    # See if we already know the template is not found
    if ( $self->{NOTFOUND}->{$name} ) {
        return ( undef, Template::Constants::STATUS_DECLINED );
    }

    # Check if the template exists, is cacheable and if a cached version exists.
    if ( -e $name && $TemplateIsCacheable ) {

        my $template_mtime = $self->_template_modified($name);
        my $CacheKey       = $self->_compiled_filename($name) . '::' . $template_mtime;

        # Is there an up-to-date compiled version in the cache?
        my $Cache = $self->{CacheObject}->Get(
            Type => $self->{CacheType},
            Key  => $CacheKey,
        );

        if ( ref $Cache ) {

            #print STDERR "Using cache $CacheKey\n";

            my $compiled_template = $Template::Provider::DOCUMENT->new($Cache);

            # Store in-memory and return the compiled template
            if ($compiled_template) {

                # Make sure template cache does not get too big
                if ( keys %{ $self->{_TemplateCache} } > 1000 ) {
                    $self->{_TemplateCache} = {};
                }

                $self->{_TemplateCache}->{$name} = $compiled_template;

                return $compiled_template;
            }

            # Problem loading compiled template: warn and continue to fetch source template
            warn( $self->error(), "\n" );
        }
    }

    # load template from source
    my ( $template, $error ) = $self->_load( $name, $t_name );

    if ($error) {

        # Template could not be fetched.  Add to the negative/notfound cache.
        $self->{NOTFOUND}->{$name} = time;
        return ( $template, $error );
    }

    # compile template source
    ( $template, $error ) = $self->_compile( $template, $self->_compiled_filename($name) );

    if ($error) {

        # return any compile time error
        return ( $template, $error );
    }

    if ($TemplateIsCacheable) {

        # Make sure template cache does not get too big
        if ( keys %{ $self->{_TemplateCache} } > 1000 ) {
            $self->{_TemplateCache} = {};
        }

        $self->{_TemplateCache}->{$name} = $template->{data};
    }

    # If we cannot cache the template, just return it.
    return $template->{data};

}

=item _load()

calls our pre processor when loading a template.

Inherited from Template::Provider.

=cut

sub _load {
    my ( $Self, $Name, $Alias ) = @_;

    my @Result = $Self->SUPER::_load( $Name, $Alias );

    # If there was no error, pre-process our template
    if ( ref $Result[0] ) {
        $Result[0]->{text} = $Self->_PreProcessTemplateContent(
            Content      => $Result[0]->{text},
            TemplateFile => $Result[0]->{name},
        );
    }

    return @Result;
}

=item _compile()

compiles a .tt template into a Perl package and uses the CacheObject
to cache it.

Copied and slightly adapted from Template::Provider.

=cut

sub _compile {
    my ( $self, $data, $compfile ) = @_;
    my $text = $data->{text};
    my ( $parsedoc, $error );

    if ( $self->{DEBUG} ) {
        $self->debug(
            "_compile($data, ",
            defined $compfile ? $compfile : '<no compfile>', ')'
        );
    }

    # Check in-memory parser cache if we already had this template content
    $self->{_ParserCache} //= {};

    if ( $self->{_ParserCache}->{$text} ) {
        return $self->{_ParserCache}->{$text};
    }

    my $parser = $self->{PARSER}
        ||= Template::Config->parser( $self->{PARAMS} )
        || return ( Template::Config->error(), Template::Constants::STATUS_ERROR );

    # discard the template text - we don't need it any more
    delete $data->{text};

    # call parser to compile template into Perl code
    if ( $parsedoc = $parser->parse( $text, $data ) ) {

        $parsedoc->{METADATA} = {
            'name'    => $data->{name},
            'modtime' => $data->{time},
            %{ $parsedoc->{METADATA} },
        };

        # write the Perl code to the file $compfile, if defined
        if ($compfile) {

            my $TemplateIsCacheable = !$self->{UncacheableTemplates}->{ALL}
                && !$self->{UncacheableTemplates}->{ $data->{name} };

            if ($TemplateIsCacheable) {
                my $CacheKey = $compfile . '::' . $data->{time};

                #print STDERR "Writing cache $CacheKey\n";
                $self->{CacheObject}->Set(
                    Type  => $self->{CacheType},
                    TTL   => 60 * 60 * 24,
                    Key   => $CacheKey,
                    Value => $parsedoc,
                );
            }
        }

        if ( $data->{data} = $Template::Provider::DOCUMENT->new($parsedoc) ) {

            # Make sure parser cache does not get too big
            if ( keys %{ $self->{_ParserCache} } > 1000 ) {
                $self->{_ParserCache} = {};
            }

            $self->{_ParserCache}->{$text} = $data;

            return $data;
        }
        $error = $Template::Document::ERROR;
    }
    else {
        $error = Template::Exception->new( 'parse', "$data->{ name } " . $parser->error() );
    }

    # return STATUS_ERROR, or STATUS_DECLINED if we're being tolerant
    return $self->{TOLERANT}
        ? ( undef, Template::Constants::STATUS_DECLINED )
        : ( $error, Template::Constants::STATUS_ERROR )
}

=item store()

inherited from Template::Provider. This function override just makes sure that the original
in-memory cache cannot be used.

=cut

sub store {
    my ( $Self, $Name, $Data ) = @_;

    return $Data;    # no-op
}

=item _PreProcessTemplateContent()

this is our template pre processor.

It handles pre output filters, some OTRS specific tags like [% InsertTemplate("TemplateName.tt") %]
and also performs compile-time code injection (ChallengeToken element into forms).

This is run at compile time. If a template is cached, this method does not have to be executed on it
any more.

=cut

sub _PreProcessTemplateContent {
    my ( $Self, %Param ) = @_;

    my $Content = $Param{Content};

    #
    # pre putput filter handling
    #
    if ( $Self->{FilterElementPre} && ref $Self->{FilterElementPre} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterElementPre} };

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            next FILTER if !$FilterConfig;
            next FILTER if ref $FilterConfig ne 'HASH';

            # extract template list
            my %TemplateList = %{ $FilterConfig->{Templates} || {} };

            if ( !%TemplateList ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && !$TemplateList{ALL} ) {
                next FILTER if !$TemplateList{ $Param{TemplateFile} };
            }

            next FILTER if !$Param{TemplateFile} && !$TemplateList{ALL};
            next FILTER if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self->{LayoutObject},
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data => \$Content,
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    #
    # Include other templates into this one before parsing.
    # [% IncludeTemplate("DatePicker.tt") %]
    #
    my ( $ReplaceCounter, $Replaced );
    do {
        $Replaced = $Content =~ s{
            \[% -? \s* InsertTemplate \( \s* ['"]? (.*?) ['"]? \s* \) \s* -? %\]\n?
            }{
                # Load the template via the provider.
                # We'll use SUPER::load here because we don't need the preprocessing twice.
                ($Self->SUPER::load($1))[0];
            }esmxg;

    } until ( !$Replaced || ++$ReplaceCounter > 100 );

    #
    # Remove DTL-style comments (lines starting with #)
    #
    $Content =~ s/^#.*\n//gm;

    #
    # Insert a BLOCK call into the template.
    # [% RenderBlock('b1') %]...[% END %]
    # becomes
    # [% PerformRenderBlock('b1') %][% BLOCK 'b1' %]...[% END %]
    # This is what we need: define the block and call it from the RenderBlock macro
    # to render it based on available block data from the frontend modules.
    #
    $Content =~ s{
        \[% -? \s* RenderBlockStart \( \s* ['"]? (.*?) ['"]? \s* \) \s* -? %\]
        }{[% PerformRenderBlock("$1") %][% BLOCK "$1" -%]}smxg;

    $Content =~ s{
        \[% -? \s* RenderBlockEnd \( \s* ['"]? (.*?) ['"]? \s* \) \s* -? %\]
        }{[% END -%]}smxg;

    #
    # Add challenge token field to all internal forms
    #
    # (?!...) is a negative look-ahead, so "not followed by https?:"
    # \K is a new feature in perl 5.10 which excludes anything prior
    # to it from being included in the match, which means the string
    # matched before it is not being replaced away.
    # performs better than including $1 in the substitution.
    #
    $Content =~ s{
            <form[^<>]+action="(?!https?:)[^"]*"[^<>]*>\K
        }{[% IF Env("UserChallengeToken") %]<input type="hidden" name="ChallengeToken" value="[% Env("UserChallengeToken") | html %]"/>[% END %][% IF Env("SessionID") && !Env("SessionIDCookie") %]<input type="hidden" name="[% Env("SessionName") %]" value="[% Env("SessionID") | html %]"/>[% END %]}smxig;

    return $Content;

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
