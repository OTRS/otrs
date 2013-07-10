# --
# Kernel/Modules/SpellingInline.pm - spelling module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::SpellingInline;

use strict;
use warnings;

use Kernel::System::Spelling;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $SpellLanguage = $Self->{ParamObject}->GetParam( Param => 'SpellLanguage' )
        || $Self->{UserSpellDict}
        || $Self->{ConfigObject}->Get('SpellCheckerDictDefault');

    # inline spell checker of rich text

    my $JSData = '';
    my @Text = $Self->{ParamObject}->GetArray( Param => 'textinputs[]' );

    my $TextAll = '';
    for ( my $i = 0; $i <= $#Text; $i++ ) {

        # change hex escapes to the proper characters
        $Text[$i] =~ s/%([a-fA-F0-9]{2})/pack "H2", $1/eg;
        $Text[$i] = $Self->{LayoutObject}->RichText2Ascii(
            String => $Text[$i],
        );

        my $Line = $Self->{LayoutObject}->JSONEncode(
            Data     => $Text[$i],
            NoQuotes => 1,
        );

        $JSData .= "textinputs[$i] = '$Line';\n";

        my @Lines = split( /\n/, $Text[$i] );
        for my $Line (@Lines) {
            $TextAll .= $Line;
        }
    }

    # do spell check
    my $SpellingObject = Kernel::System::Spelling->new( %{$Self} );
    my %SpellCheck     = $SpellingObject->Check(
        Text          => $TextAll,
        SpellLanguage => $SpellLanguage,
    );

    # check error
    if ( $SpellingObject->Error() ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    $JSData .= "words[0] = [];\n";
    $JSData .= "suggs[0] = [];\n";
    my $Count = 0;
    for ( sort { $a <=> $b } keys %SpellCheck ) {
        my $Word = $Self->{LayoutObject}->Ascii2Html(
            Text => $SpellCheck{$_}->{Word},
            Type => 'JSText',
        );

        my $JS = $Self->{LayoutObject}->JSONEncode(
            Data => $SpellCheck{$_}->{Replace} || [],
        );

        $JSData .= "words[0][$Count] = '$Word';\n";
        $JSData .= "suggs[0][$Count] = $JS;\n";
        $JSData .= "\n";
        $Count++;
    }

    $Self->{LayoutObject}->Block(
        Name => 'SpellCheckerInline',
        Data => {
            JSData => $JSData,
        },
    );

    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'SpellingInline',
        Data         => \%Param,
    );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $Output,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
