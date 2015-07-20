# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::Language;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $DefaultUsedLanguages = $ConfigObject->Get('DefaultUsedLanguages');
    my %Languages;
    LANGUAGE_ID:
    for my $LanguageID ( sort keys %{ $DefaultUsedLanguages // {} } ) {
        my $Text           = $DefaultUsedLanguages->{$LanguageID};
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $LanguageID,
        );
        next LANGUAGE_ID if !$LanguageObject;
        my $Completeness = $LanguageObject->{Completeness};

        # Mark all languages with < 25% coverage as "in process" (not for en_ variants).
        if ( defined $Completeness && $Completeness < 0.25 && $LanguageID !~ m{^en_}smx ) {
            $Text
                .= ' ' . $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate('(in process)');
        }
        $Languages{$LanguageID} = $Text;
    }

    my @Params;
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%Languages,
            HTMLQuote  => 0,
            SelectedID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'UserLanguage' )
                || $Param{UserData}->{UserLanguage}
                || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage}
                || $ConfigObject->Get('DefaultLanguage'),
            Block => 'Option',
            Class => 'Modernize',
            Max   => 200,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for (@Array) {

            # pref update db
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $_,
                );
            }
        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
