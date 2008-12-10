# --
# Kernel/Output/HTML/OutputFilterTextAutoLink.pm - Auto article links filter
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: OutputFilterTextAutoLink.pm,v 1.1 2008-12-10 08:26:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::OutputFilterTextAutoLink;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject MainObject LogObject LayoutObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Pre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Data!' );
        $Self->{LayoutObject}->FatalDie();
    }

    return $Param{Data};
}

sub Post {
    my ( $Self, %Param ) = @_;

    # check parameters
    die 'Got no Data!' if !$Param{Data};

    # check whether auto article links should be used
    return $Param{Data}
        if !$Self->{ConfigObject}->Get('Frontend::Output::OutputFilterTextAutoLink');

    # find words to replace
    my %Config = %{ $Self->{ConfigObject}->Get("Frontend::Output::OutputFilterTextAutoLink") };

    LINK:
    for my $Link ( values %Config ) {

        next LINK if !$Link->{RegExp};

        # iterage through regular expressions and create a hash with found keywords
        my %Keywords = ();
        for my $RegExp ( @{ $Link->{RegExp} } ) {
            my @Count = $RegExp =~ m{\(}gx;
            my $Elements = scalar @Count;
            if ( my @MatchData = ${ $Param{Data} } =~ m{([\s:]$RegExp)}gxi ) {
                my $Counter = 0;
                KEYWORD:
                while ( $MatchData[$Counter] ) {

                    my $HoleMatchString = $MatchData[$Counter];
                    if ( $Keywords{$HoleMatchString} ) {
                        $Counter += $Elements + 1;
                        next KEYWORD;
                    }

                    for ( 1 .. $Elements ) {
                        $Keywords{$HoleMatchString}{$_} = $MatchData[ $Counter + $_ ];
                    }
                    $Counter += $Elements + 1;
                }
            }
        }

        # iterate trough keywords and replace them with URLs from the configuration
        for my $Keyword ( keys %Keywords ) {
            my %KW      = %{ $Keywords{$Keyword} };
            my $URLLink = '';

            DATA:
            for my $URLRef ( values %{ $Link } ) {
                next DATA if !$URLRef || ref( $URLRef ) ne 'HASH';

                # check URL configuration sanity
                next DATA if !$URLRef->{URL} || !$URLRef->{Image} || !$URLRef->{Target};

                my $KeywordQuote = $Self->{LayoutObject}->Ascii2Html( Text => $Keyword );
                my $URL = $URLRef->{URL};

                # replace the whole keyword
                my $KeywordLinkEncode = $Self->{LayoutObject}->LinkEncode($Keyword);
                $URL =~ s/<MATCH>/$KeywordLinkEncode/g;

                # replace the keyword components
                for ( keys %KW ) {
                    $KeywordLinkEncode = $Self->{LayoutObject}->LinkEncode( $KW{$_} );
                    $URL =~ s/<MATCH$_>/$KeywordLinkEncode/g;
                }

                # find out if it is an internal image or an external image
                my $Image = $URLRef->{Image};
                if ( $Image !~ m{^ http }smx ) {
                    $Image = $Self->{LayoutObject}->{Images} . $URLRef->{Image};
                }

                # create the url string
                $URL  = "<a href=\"$URL\" target=\"$URLRef->{Target}\">";
                $URL .= "<img border=\"0\" src=\"$Image\" ";
                $URL .= " alt=\"$URLRef->{Description}: $KeywordQuote\"";
                $URL .= " title=\"$URLRef->{Description}: $KeywordQuote\"></img></a>";
                $URLLink .= ' ' if ($URLLink);
                $URLLink .= $URL;
            }

            # Replace the built URLs in the original text
            if ($URLLink) {
                ${ $Param{Data} } =~ s/($Keyword)/$1 $URLLink/gi;
            }
        }
    }

    return $Param{Data};
}

1;
