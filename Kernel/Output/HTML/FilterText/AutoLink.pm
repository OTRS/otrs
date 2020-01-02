# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::FilterText::AutoLink;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Pre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!'
        );
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalDie();
    }

    return $Param{Data};
}

sub Post {
    my ( $Self, %Param ) = @_;

    #  get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!'
        );
        $LayoutObject->FatalDie();
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check whether auto article links should be used
    return $Param{Data}
        if !$ConfigObject->Get('Frontend::Output::OutputFilterTextAutoLink');

    # find words to replace
    my %Config = %{ $ConfigObject->Get("Frontend::Output::OutputFilterTextAutoLink") };

    LINK:
    for my $Link ( values %Config ) {

        next LINK if !$Link->{RegExp};

        # iterage through regular expressions and create a hash with found keywords
        my %Keywords = ();
        for my $RegExp ( @{ $Link->{RegExp} } ) {
            my @Count    = $RegExp =~ m{\(}gx;
            my $Elements = scalar @Count;

            if ( my @MatchData = ${ $Param{Data} } =~ m{((?<!\w)$RegExp)}gxi ) {
                my $Counter = 0;
                KEYWORD:
                while ( $MatchData[$Counter] ) {

                    my $HoleMatchString = $MatchData[$Counter];
                    $HoleMatchString =~ s/^\s+|\s+$//g;
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
        for my $Keyword ( sort keys %Keywords ) {
            my %KW      = %{ $Keywords{$Keyword} };
            my $URLLink = '';

            DATA:
            for my $URLRef ( values %{$Link} ) {
                next DATA if !$URLRef || ref($URLRef) ne 'HASH';

                # check URL configuration sanity
                next DATA if !$URLRef->{URL} || !$URLRef->{Image} || !$URLRef->{Target};

                my $KeywordQuote = $LayoutObject->Ascii2Html( Text => $Keyword );
                my $URL          = $URLRef->{URL};

                # replace the whole keyword
                my $KeywordLinkEncode = $LayoutObject->LinkEncode($Keyword);
                $URL =~ s/<MATCH>/$KeywordLinkEncode/g;

                # replace the keyword components
                for ( sort keys %KW ) {
                    $KeywordLinkEncode = $LayoutObject->LinkEncode( $KW{$_} );
                    $URL =~ s/<MATCH$_>/$KeywordLinkEncode/g;
                }

                # find out if it is an internal image or an external image
                my $Image = $URLRef->{Image};
                if ( $Image !~ m{^ http }smx ) {
                    $Image = $LayoutObject->{Images} . $URLRef->{Image};
                }

                # create the url string
                $URL = "<a href=\"$URL\" target=\"$URLRef->{Target}\">";
                $URL     .= "<img border=\"0\" src=\"$Image\" ";
                $URL     .= " alt=\"$URLRef->{Description}: $KeywordQuote\"";
                $URL     .= " title=\"$URLRef->{Description}: $KeywordQuote\"/></a>";
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
