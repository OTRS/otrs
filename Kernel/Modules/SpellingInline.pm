# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::SpellingInline;

use strict;
use warnings;

use URI::Escape qw();

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SpellLanguage = $ParamObject->GetParam( Param => 'SpellLanguage' )
        || $Self->{UserSpellDict}
        || $Kernel::OM->Get('Kernel::Config')->Get('SpellCheckerDictDefault');

    # inline spell checker of rich text
    my $JSData = '';
    my @Text = $ParamObject->GetArray( Param => 'textinputs[]' );

    my $TextAll      = '';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    for ( my $i = 0; $i <= $#Text; $i++ ) {
        my $Line = $LayoutObject->JSONEncode(
            Data     => $Text[$i],
            NoQuotes => 1,
        );
        $JSData .= "textinputs[$i] = decodeURIComponent('$Line')\n";

        $Text[$i] = Encode::decode( 'utf8', URI::Escape::uri_unescape( $Text[$i] ) );

        my @Lines = split( /\n/, $Text[$i] );
        for my $Line (@Lines) {
            $TextAll .= $Line;
        }
    }

    # do spell check
    my $SpellingObject = $Kernel::OM->Get('Kernel::System::Spelling');
    $TextAll = $LayoutObject->RichText2Ascii(
        String => $TextAll,
    );

    my %SpellCheck = $SpellingObject->Check(
        Text          => $TextAll,
        SpellLanguage => $SpellLanguage,
        RichText      => 1,
    );

    # check error
    if ( $SpellingObject->Error() ) {
        return $LayoutObject->ErrorScreen();
    }

    $JSData .= "words[0] = [];\n";
    $JSData .= "suggs[0] = [];\n";
    my $Count = 0;
    for ( sort { $a <=> $b } keys %SpellCheck ) {
        my $Word = $LayoutObject->Ascii2Html(
            Text => $SpellCheck{$_}->{Word},
            Type => 'JSText',
        );

        my $JS = $LayoutObject->JSONEncode(
            Data => $SpellCheck{$_}->{Replace} || [],
        );

        $JSData .= "words[0][$Count] = '$Word';\n";
        $JSData .= "suggs[0][$Count] = $JS;\n";
        $JSData .= "\n";
        $Count++;
    }

    $LayoutObject->Block(
        Name => 'SpellCheckerInline',
        Data => {
            JSData => $JSData,
        },
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'SpellingInline',
        Data         => \%Param,
    );
    return $LayoutObject->Attachment(
        ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
        Content     => $Output,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
