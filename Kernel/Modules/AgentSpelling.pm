# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentSpelling.pm,v 1.26 2009-12-31 10:47:25 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use warnings;

use Kernel::System::Spelling;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

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

    # inline spell checker of richt text
    if ( $Self->{Subaction} eq 'Inline' ) {

        my $JSData = '';
        my @Text = $Self->{ParamObject}->GetArray( Param => 'textinputs[]' );

        my $TextAll = '';
        for ( my $i = 0; $i <= $#Text; $i++ ) {
            my $Line = $Self->{LayoutObject}->JSONEncode(
                Data     => $Text[$i],
                NoQuotes => 1,
            );
            $JSData .= "textinputs[$i] = decodeURIComponent('$Line')\n";

            # change hex escapes to the proper characters
            $Text[$i] =~ s/%([a-fA-F0-9]{2})/pack "H2", $1/eg;

            my @Lines = split( /\n/, $Text[$i] );
            for my $Line (@Lines) {
                $TextAll .= $Line;
            }
        }

        # do spell check
        my $SpellingObject = Kernel::System::Spelling->new( %{$Self} );
        $TextAll = $Self->{LayoutObject}->RichText2Ascii(
            String => $TextAll,
        );

        my %SpellCheck = $SpellingObject->Check(
            Text          => $TextAll,
            SpellLanguage => $SpellLanguage,
        );

        $JSData .= "words[0] = [];\n";
        $JSData .= "suggs[0] = [];\n";
        my $Count = 0;
        for ( sort { $a <=> $b } keys %SpellCheck ) {
            my $Word = $Self->{LayoutObject}->Ascii2Html(
                Text => $SpellCheck{$_}->{Word},
                Type => 'JSText',
            );
            my $JS = $Self->{LayoutObject}->JSONEncode(
                Data => $SpellCheck{$_}->{Replace},
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
            TemplateFile => 'AgentSpelling',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $Output,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # get params
    $Param{Body} = $Self->{ParamObject}->GetParam( Param => 'Body' );
    $Param{Field} = $Self->{ParamObject}->GetParam( Param => 'Field' ) || 'Body';

    # get and replace all wrong words
    my %Words = ();
    for ( 0 .. 300 ) {
        my $Replace = $Self->{ParamObject}->GetParam( Param => "SpellCheck::Replace::$_" );
        next if !$Replace;
        my $Old = $Self->{ParamObject}->GetParam( Param => "SpellCheckOld::$_" );
        my $New = $Self->{ParamObject}->GetParam( Param => "SpellCheckOrReplace::$_" )
            || $Self->{ParamObject}->GetParam( Param => "SpellCheckOption::$_" );
        if ( $Old && $New ) {
            $Param{Body} =~ s/^$Old$/$New/g;
            $Param{Body} =~ s/^$Old( |\n|\r|\s)/$New$1/g;
            $Param{Body} =~ s/ $Old$/ $New/g;
            $Param{Body} =~ s/(\s)$Old(\n|\r)/$1$New$2/g;
            $Param{Body} =~ s/(\s)$Old(\s|:|;|<|>|\/|\\|\.|\!|%|&|\?)/$1$New$2/gs;
            $Param{Body} =~ s/(\W)$Old(\W)/$1$New$2/g;
        }
    }

    # do spell check
    my $SpellingObject = Kernel::System::Spelling->new( %{$Self} );
    my %SpellCheck     = $SpellingObject->Check(
        Text          => $Param{Body},
        SpellLanguage => $SpellLanguage,
    );

    # check error
    if ( $SpellingObject->Error() ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # start with page ...
    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->_Mask(
        SpellCheck    => \%SpellCheck,
        SpellLanguage => $SpellLanguage,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # dict language selection
    $Param{SpellLanguageString} .= $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('PreferencesGroups')->{SpellDict}->{Data},
        Name       => 'SpellLanguage',
        SelectedID => $Param{SpellLanguage},
    );

    $Self->{LayoutObject}->Block(
        Name => 'SpellCheckerExtern',
        Data => \%Param,
    );

    # spellcheck
    if ( $Param{SpellCheck} ) {
        $Param{SpellCounter} = 0;
        for ( sort { $a <=> $b } keys %{ $Param{SpellCheck} } ) {
            if ( $Param{SpellCheck}->{$_}->{Word} && $Param{SpellCounter} <= 300 ) {
                $Param{SpellCounter}++;
                my %ReplaceWords = ();
                if ( $Param{SpellCheck}->{$_}->{Replace} ) {
                    for my $ReplaceWord ( @{ $Param{SpellCheck}->{$_}->{Replace} } ) {
                        $ReplaceWords{$ReplaceWord} = $ReplaceWord;
                    }
                }
                else {
                    $ReplaceWords{''} = 'No suggestions';
                }
                $Param{SpellCheckString} = $Self->{LayoutObject}->BuildSelection(
                    Data     => \%ReplaceWords,
                    Name     => "SpellCheckOption::$Param{SpellCounter}",
                    OnChange => "change_selected($Param{SpellCounter})"
                );
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        %{ $Param{SpellCheck}->{$_} },
                        OptionList => $Param{SpellCheckString},
                        Count      => $Param{SpellCounter},
                    },
                );
            }
        }
    }

    # create & return output
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentSpelling', Data => \%Param );
}

1;
