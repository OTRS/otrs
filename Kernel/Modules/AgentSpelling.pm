# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSpelling;

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
                    Data => \%ReplaceWords,
                    Name => "SpellCheckOption::$Param{SpellCounter}",
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
