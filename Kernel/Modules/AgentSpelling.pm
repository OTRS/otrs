# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use warnings;

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get params
    my $SpellLanguage = $ParamObject->GetParam( Param => 'SpellLanguage' )
        || $Self->{UserSpellDict}
        || $Kernel::OM->Get('Kernel::Config')->Get('SpellCheckerDictDefault');

    # get params
    $Param{Body} = $ParamObject->GetParam( Param => 'Body' );
    $Param{Field} = $ParamObject->GetParam( Param => 'Field' ) || 'Body';

    # get and replace all wrong words
    my %Words = ();
    COUNT:
    for ( 0 .. 300 ) {
        my $Replace = $ParamObject->GetParam( Param => "SpellCheck::Replace::$_" );
        next COUNT if !$Replace;
        my $Old = $ParamObject->GetParam( Param => "SpellCheckOld::$_" );
        my $New = $ParamObject->GetParam( Param => "SpellCheckOrReplace::$_" )
            || $ParamObject->GetParam( Param => "SpellCheckOption::$_" );
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
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SpellingObject = $Kernel::OM->Get('Kernel::System::Spelling');
    my %SpellCheck     = $SpellingObject->Check(
        Text          => $Param{Body},
        SpellLanguage => $SpellLanguage,
    );

    # check error
    if ( $SpellingObject->Error() ) {
        return $LayoutObject->ErrorScreen();
    }

    # start with page ...
    my $Output = $LayoutObject->Header( Type => 'Small' );
    $Output .= $Self->_Mask(
        SpellCheck    => \%SpellCheck,
        SpellLanguage => $SpellLanguage,
        %Param,
    );
    $Output .= $LayoutObject->Footer( Type => 'Small' );
    return $Output;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # dict language selection
    $Param{SpellLanguageString} .= $LayoutObject->BuildSelection(
        Data       => $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups')->{SpellDict}->{Data},
        Name       => 'SpellLanguage',
        SelectedID => $Param{SpellLanguage},
    );

    $LayoutObject->Block(
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
                $Param{SpellCheckString} = $LayoutObject->BuildSelection(
                    Data => \%ReplaceWords,
                    Name => "SpellCheckOption::$Param{SpellCounter}",
                );
                $LayoutObject->Block(
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
    return $LayoutObject->Output(
        TemplateFile => 'AgentSpelling',
        Data         => \%Param
    );
}

1;
