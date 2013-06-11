# --
# Kernel/Output/HTML/Layout.pm - provides generic HTML output
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout;

use strict;
use warnings;

use Kernel::Language;
use Kernel::System::HTMLUtils;
use Kernel::System::JSON;

use Mail::Address;
use URI::Escape qw();

use vars qw(@ISA);

=head1 NAME

Kernel::Output::HTML::Layout - all generic html functions

=head1 SYNOPSIS

All generic html functions. E. g. to get options fields, template processing, ...

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a new object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::Web::Request;
    use Kernel::Output::HTML::Layout;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $RequestObject = Kernel::System::Web::Request->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,
    );
    my $LayoutObject = Kernel::Output::HTML::Layout->new(
        ConfigObject  => $ConfigObject,
        LogObject     => $LogObject,
        MainObject    => $MainObject,
        TimeObject    => $TimeObject,
        ParamObject   => $RequestObject,
        EncodeObject  => $EncodeObject,
        Lang          => 'de',
    );

    in addition for NavigationBar() you need
        DBObject
        SessionObject
        UserID
        TicketObject
        GroupObject

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    # check needed objects
    # Attention: NavigationBar() needs also SessionObject and some other objects
    for my $Object (qw(ConfigObject LogObject TimeObject MainObject EncodeObject ParamObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $Object!",
            );
            $Self->FatalError();
        }
    }

    # create additional objects
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{JSONObject}      = Kernel::System::JSON->new( %{$Self} );

    # reset block data
    delete $Self->{BlockData};

    # get/set some common params
    if ( !$Self->{UserTheme} ) {
        $Self->{UserTheme} = $Self->{ConfigObject}->Get('DefaultTheme');
    }

    if ( $Self->{ConfigObject}->Get('TimeZoneUser') && $Self->{UserTimeZone} ) {
        $Self->{UserTimeObject} = Kernel::System::Time->new(%Param);
    }
    else {
        $Self->{UserTimeObject} = $Self->{TimeObject};
        $Self->{UserTimeZone}   = '';
    }

    # Determine the language to use based on the browser setting, if there
    #   is none yet.
    if ( !$Self->{UserLanguage} ) {
        my @BrowserLanguages = split /\s*,\s*/, $Self->{Lang} || $ENV{HTTP_ACCEPT_LANGUAGE} || '';
        my %Data = %{ $Self->{ConfigObject}->Get('DefaultUsedLanguages') };
        LANGUAGE:
        for my $BrowserLang (@BrowserLanguages) {
            for my $Language ( reverse sort keys %Data ) {

                # check xx_XX and xx-XX type
                my $LanguageOtherType = $Language;
                $LanguageOtherType =~ s/_/-/;
                if ( $BrowserLang =~ /^($Language|$LanguageOtherType)/i ) {
                    $Self->{UserLanguage} = $Language;
                    last LANGUAGE;
                }
            }
        }
        $Self->{UserLanguage} ||= $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
    }

    # create language object
    if ( !$Self->{LanguageObject} ) {
        $Self->{LanguageObject} = Kernel::Language->new(
            UserTimeZone => $Self->{UserTimeZone},
            UserLanguage => $Self->{UserLanguage},
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            EncodeObject => $Self->{EncodeObject},
            MainObject   => $Self->{MainObject},
            Action       => $Self->{Action},
        );
    }

    # set charset if there is no charset given
    $Self->{UserCharset} = 'utf-8';
    $Self->{Charset}     = $Self->{UserCharset};                            # just for compat.
    $Self->{SessionID}   = $Param{SessionID} || '';
    $Self->{SessionName} = $Param{SessionName} || 'SessionID';
    $Self->{CGIHandle}   = $ENV{SCRIPT_NAME} || 'No-$ENV{"SCRIPT_NAME"}';

    # baselink
    $Self->{Baselink} = $Self->{CGIHandle} . '?';
    $Self->{Time}     = $Self->{LanguageObject}->Time(
        Action => 'GET',
        Format => 'DateFormat',
    );
    $Self->{TimeLong} = $Self->{LanguageObject}->Time(
        Action => 'GET',
        Format => 'DateFormatLong',
    );

    # set text direction
    $Self->{TextDirection} = $Self->{LanguageObject}->{TextDirection};

    # check Frontend::Output::FilterElementPre
    $Self->{FilterElementPre} = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre');

    # check Frontend::Output::FilterElementPost
    $Self->{FilterElementPost} = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPost');

    # check Frontend::Output::FilterContent
    $Self->{FilterContent} = $Self->{ConfigObject}->Get('Frontend::Output::FilterContent');

    # check Frontend::Output::FilterText
    $Self->{FilterText} = $Self->{ConfigObject}->Get('Frontend::Output::FilterText');

    # check browser (default is IE because I don't have IE)
    $Self->{Browser} = 'Unknown';

    $Self->{BrowserJavaScriptSupport} = 1;
    $Self->{BrowserRichText}          = 1;

    my $HttpUserAgent = ( defined $ENV{HTTP_USER_AGENT} ? lc $ENV{HTTP_USER_AGENT} : '' );
    if ( !$HttpUserAgent ) {
        $Self->{Browser} = 'Unknown - no $ENV{"HTTP_USER_AGENT"}';
    }
    elsif ($HttpUserAgent) {

        # msie
        if (
            $HttpUserAgent =~ /msie\s([0-9.]+)/
            || $HttpUserAgent =~ /internet\sexplorer\/([0-9.]+)/
            )
        {
            $Self->{Browser} = 'MSIE';

            # For IE 5.5 - 8.0, we break the header in a special way that makes
            # things work. I don't really want to know.
            if ( $1 =~ /(\d)\.(\d)/ ) {
                $Self->{BrowserMajorVersion} = $1;
                $Self->{BrowserMinorVersion} = $2;
                if (
                    $1 == 5
                    && $2 == 5
                    || $1 == 6 && $2 == 0
                    || $1 == 7 && $2 == 0
                    || $1 == 8 && $2 == 0
                    )
                {
                    $Self->{BrowserBreakDispositionHeader} = 1;
                }

#
# In IE up to version 8, there is a technical limitation for < 32
#   CSS file links. Subsequent links will be ignored. Therefore
#   the loader must be activated for delivering CSS to this browser.
#   The loader will concatenate and minify the files, resulting in
#   very few CSS file links.
#   See also http://social.msdn.microsoft.com/Forums/en-US/iewebdevelopment/thread/ad1b6e88-bbfa-4cc4-9e95-3889b82a7c1d.
#
                if ( $1 <= 8 ) {
                    $Self->{ConfigObject}->Set(
                        Key   => 'Loader::Enabled::CSS',
                        Value => 1,
                    );
                }
            }
        }

        # safari
        elsif ( $HttpUserAgent =~ /safari/ ) {
            $Self->{Browser} = 'Safari';

            # if it's an iPad/iPhone with iOS5 the rte can be enabled
            if ( $HttpUserAgent =~ /(ipad|iphone);.*cpu.*os 5_/ ) {
                $Self->{BrowserRichText} = 1;
            }

            # on iphone (with older iOS) disable rich text editor
            elsif ( $HttpUserAgent =~ /iphone\sos/ ) {
                $Self->{BrowserRichText} = 0;
            }

            # on ipad (with older iOS) disable rich text editor
            elsif ( $HttpUserAgent =~ /ipad;\s/ ) {
                $Self->{BrowserRichText} = 0;
            }

            # on android disable rich text editor
            elsif ( $HttpUserAgent =~ /android/ ) {
                $Self->{BrowserRichText} = 0;
            }

            # chrome
            elsif ( $HttpUserAgent =~ /chrome/ ) {
                $Self->{Browser} = 'Chrome';
            }
        }

        # konqueror
        elsif ( $HttpUserAgent =~ /konqueror/ ) {
            $Self->{Browser} = 'Konqueror';

            # on konquerer disable rich text editor
            $Self->{BrowserRichText} = 0;
        }

        # mozilla
        elsif ( $HttpUserAgent =~ /^mozilla/ ) {
            $Self->{Browser} = 'Mozilla';
        }

        # opera
        elsif ( $HttpUserAgent =~ /^opera.*/ ) {
            $Self->{Browser} = 'Opera';
        }

        # netscape
        elsif ( $HttpUserAgent =~ /netscape/ ) {
            $Self->{Browser} = 'Netscape';
        }

        # w3m
        elsif ( $HttpUserAgent =~ /^w3m.*/ ) {
            $Self->{Browser}                  = 'w3m';
            $Self->{BrowserJavaScriptSupport} = 0;
        }

        # lynx
        elsif ( $HttpUserAgent =~ /^lynx.*/ ) {
            $Self->{Browser}                  = 'Lynx';
            $Self->{BrowserJavaScriptSupport} = 0;
        }

        # links
        elsif ( $HttpUserAgent =~ /^links.*/ ) {
            $Self->{Browser} = 'Links';
        }
        else {
            $Self->{Browser} = 'Unknown - ' . $HttpUserAgent;
        }
    }

    # check if rich text can be active
    if ( !$Self->{BrowserJavaScriptSupport} || !$Self->{BrowserRichText} ) {
        $Self->{ConfigObject}->Set(
            Key   => 'Frontend::RichText',
            Value => 0,
        );
    }

    # check if rich text is active
    if ( !$Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{BrowserRichText} = 0;
    }

    # check if spell check should be active
    if ( $Self->{BrowserJavaScriptSupport} && $Self->{ConfigObject}->Get('SpellChecker') ) {
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $Self->{BrowserSpellCheckerInline} = 1;
        }
        else {
            $Self->{BrowserSpellChecker} = 1;
        }
    }

    # load theme
    my $Theme = $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme') || 'Standard';

    # force a theme based on host name
    my $DefaultThemeHostBased = $Self->{ConfigObject}->Get('DefaultTheme::HostBased');
    if ( $DefaultThemeHostBased && $ENV{HTTP_HOST} ) {
        for my $RegExp ( sort keys %{$DefaultThemeHostBased} ) {

            # do not use empty regexp or theme directories
            next if !$RegExp;
            next if $RegExp eq '';
            next if !$DefaultThemeHostBased->{$RegExp};

            # check if regexp is matching
            if ( $ENV{HTTP_HOST} =~ /$RegExp/i ) {
                $Theme = $DefaultThemeHostBased->{$RegExp};
            }
        }
    }

    # locate template files
    $Self->{TemplateDir} = $Self->{ConfigObject}->Get('TemplateDir') . '/HTML/' . $Theme;
    if ( !-e $Self->{TemplateDir} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "No existing template directory found ('$Self->{TemplateDir}')!.
                Default theme used instead.",
        );

        # Set TemplateDir to 'Standard' as a fallback and check if it exists.
        $Theme = 'Standard';
        $Self->{TemplateDir} = $Self->{ConfigObject}->Get('TemplateDir') . '/HTML/' . $Theme;
        if ( !-e $Self->{TemplateDir} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "No existing template directory found ('$Self->{TemplateDir}')! Check your Home in Kernel/Config.pm",
            );
            $Self->FatalDie();
        }
    }

    $Self->{CustomTemplateDir}
        = $Self->{ConfigObject}->Get('CustomTemplateDir') . '/HTML/' . $Theme;

    # load sub layout files
    my $Dir = $Self->{ConfigObject}->Get('TemplateDir') . '/HTML';
    if ( -e $Dir ) {
        my @Files = $Self->{MainObject}->DirectoryRead(
            Directory => $Dir,
            Filter    => 'Layout*.pm',
        );
        for my $File (@Files) {
            if ( $File !~ /Layout.pm$/ ) {
                $File =~ s{\A.*\/(.+?).pm\z}{$1}xms;
                if ( !$Self->{MainObject}->Require("Kernel::Output::HTML::$File") ) {
                    $Self->FatalError();
                }
                push @ISA, "Kernel::Output::HTML::$File";
            }
        }
    }

    if ( $Self->{SessionID} && $Self->{UserChallengeToken} ) {
        $Self->{ChallengeTokenParam} = "ChallengeToken=$Self->{UserChallengeToken};";
    }

    return $Self;
}

sub SetEnv {
    my ( $Self, %Param ) = @_;

    for (qw(Key Value)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            $Self->FatalError();
        }
    }
    $Self->{EnvNewRef}->{ $Param{Key} } = $Param{Value};
    return 1;
}

=item Block()

use a dtl block

    $LayoutObject->Block(
        Name => 'Row',
        Data => {
            Time     => $Row[0],
            Priority => $Row[1],
            Facility => $Row[2],
            Message  => $Row[3],
        },
    );

=cut

sub Block {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name!' );
        return;
    }
    push @{ $Self->{BlockData} }, { Name => $Param{Name}, Data => $Param{Data} };
}

=item Output()

generates HTML output based on a template file.

Using a template file:

    my $HTML = $LayoutObject->Output(
        TemplateFile => 'AdminLog',
        Data         => \%Param,
    );

Using a template string:

    my $HTML = $LayoutObject->Output(
        Template => '<b>$QData{"SomeKey"}</b>',
        Data     => \%Param,
    );

Additional parameters:

KeepScriptTags - this causes <!-- dtl:js_on_document_complete --> blocks NOT
to be replaced. This is important to be able to generate snippets which can be cached.

    my $HTML = $LayoutObject->Output(
        TemplateFile   => 'AdminLog',
        Data           => \%Param,
        KeepScriptTags => 1,
    );

=cut

sub Output {
    my ( $Self, %Param ) = @_;

    $Param{Data} ||= {};

    # get and check param Data
    if ( ref $Param{Data} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need HashRef in Param Data! Got: '" . ref $Param{Data} . "'!",
        );
        $Self->FatalError();
    }

    # fill init Env
    if ( !$Self->{EnvRef} ) {
        %{ $Self->{EnvRef} } = %ENV;

        # all $Self->{*}
        for ( sort keys %{$Self} ) {
            if ( defined $Self->{$_} && !ref $Self->{$_} ) {
                $Self->{EnvRef}->{$_} = $Self->{$_};
            }
        }
    }

    # add new env
    if ( $Self->{EnvNewRef} ) {
        for ( %{ $Self->{EnvNewRef} } ) {
            $Self->{EnvRef}->{$_} = $Self->{EnvNewRef}->{$_};
        }
        undef $Self->{EnvNewRef};
    }

    # if we use the HTML5 input type 'email' jQuery Validate will always validate
    # we do not want that if CheckEmailAddresses is set to 'no' in SysConfig
    $Self->{EnvRef}->{EmailFieldType}
        = $Self->{ConfigObject}->Get('CheckEmailAddresses') ? 'email' : 'text';

    # read template from filesystem
    my $TemplateString = '';
    if ( $Param{TemplateFile} ) {
        my $File = '';
        if ( -f "$Self->{CustomTemplateDir}/$Param{TemplateFile}.dtl" ) {
            $File = "$Self->{CustomTemplateDir}/$Param{TemplateFile}.dtl";
        }
        elsif ( -f "$Self->{CustomTemplateDir}/../Standard/$Param{TemplateFile}.dtl" ) {
            $File = "$Self->{CustomTemplateDir}/../Standard/$Param{TemplateFile}.dtl";
        }
        elsif ( -f "$Self->{TemplateDir}/$Param{TemplateFile}.dtl" ) {
            $File = "$Self->{TemplateDir}/$Param{TemplateFile}.dtl";
        }
        else {
            $File = "$Self->{TemplateDir}/../Standard/$Param{TemplateFile}.dtl";
        }
        ## no critic
        if ( open my $TEMPLATEIN, '<', $File ) {
            ## use critic
            $TemplateString = do { local $/; <$TEMPLATEIN> };
            close $TEMPLATEIN;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't read $File: $!",
            );
        }
    }

    # take templates from string/array
    elsif ( defined $Param{Template} && ref $Param{Template} eq 'ARRAY' ) {
        for ( @{ $Param{Template} } ) {
            $TemplateString .= $_;
        }
    }
    elsif ( defined $Param{Template} ) {
        $TemplateString = $Param{Template};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Template or TemplateFile Param!',
        );
        $Self->FatalError();
    }

    # run output element pre filters
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
            my $TemplateList = $FilterConfig->{Templates};

            # check template list
            if ( !$TemplateList || ref $TemplateList ne 'HASH' || !%{$TemplateList} ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL} ) {
                next FILTER if !$TemplateList->{ $Param{TemplateFile} };
            }

            next FILTER
                if !$Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL};

            next FILTER if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data => \$TemplateString,
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    # filtering of comment lines
    $TemplateString =~ s/^#.*\n//gm;

    my $Output = $Self->_Output(
        Template     => $TemplateString,
        Data         => $Param{Data},
        BlockReplace => 1,
        TemplateFile => $Param{TemplateFile} || '',
    );

    # Improve dtl performance of large pages, see also bug#7267.
    # Thanks to Stelios Gikas <stelios.gikas@noris.net>!
    my @OutputLines = split /\n/, $Output;
    for my $Output (@OutputLines) {

        # do time translation (with seconds)
        $Output =~ s{
        \$TimeLong{"(.*?)"}
    }
    {
        $Self->{LanguageObject}->FormatTimeString($1);
    }egx;

        # do time translation (without seconds)
        $Output =~ s{
        \$TimeShort{"(.*?)"}
    }
    {
        $Self->{LanguageObject}->FormatTimeString($1, undef, 'NoSeconds');
    }egx;

        # do date translation
        $Output =~ s{
        \$Date{"(.*?)"}
    }
    {
        $Self->{LanguageObject}->FormatTimeString($1, 'DateFormatShort');
    }egx;

        # do translation
        $Output =~ s{
        \$Text{"(.*?)"}
    }
    {
        $Self->Ascii2Html(
            Text => $Self->{LanguageObject}->Get($1),
        );
    }egx;

        $Output =~ s{
        \$JSText{"(.*?)"}
    }
    {
        $Self->Ascii2Html(
            Text => $Self->{LanguageObject}->Get($1),
            Type => 'JSText',
        );
    }egx;

        # do html quote
        $Output =~ s{
        \$Quote{"(.*?)"}
    }
    {
        my $Text = $1;
        if ( !defined $Text || $Text =~ /^",\s*"(.+)$/ ) {
            '';
        }
        elsif ($Text =~ /^(.+?)",\s*"(.+)$/) {
            $Self->Ascii2Html(Text => $1, Max => $2);
        }
        else {
            $Self->Ascii2Html(Text => $Text);
        }
    }egx;

    }
    $Output = join "\n", @OutputLines;

    # rewrite forms, add challenge token : <form action="index.pl" method="get">
    if ( $Self->{SessionID} && $Self->{UserChallengeToken} ) {
        my $UserChallengeToken = $Self->Ascii2Html( Text => $Self->{UserChallengeToken} );
        $Output =~ s{
            (<form.+?action=".+?".+?>)
        }
        {
            my $Form = $1;
            if ( lc $Form =~ m{^http s? :}smx ) {
                $Form;
            }
            else {
                $Form . "<input type=\"hidden\" name=\"ChallengeToken\" value=\"$UserChallengeToken\"/>";
            }
        }iegx;
    }

    # Check if the browser sends the session id cookie!
    # If not, add the session id to the links and forms!
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {

        # rewrite a hrefs
        $Output =~ s{
            (<a.+?href=")(.+?)(\#.+?|)(".+?>)
        }
        {
            my $AHref   = $1;
            my $Target  = $2;
            my $End     = $3;
            my $RealEnd = $4;
            if ( lc $Target =~ /^(http:|https:|#|ftp:)/ ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/ ||
                $Target =~ /(\?|&)\Q$Self->{SessionName}\E=/) {
                $AHref.$Target.$End.$RealEnd;
            }
            else {
                $AHref.$Target.';'.$Self->{SessionName}.'='.$Self->{SessionID}.$End.$RealEnd;
            }
        }iegxs;

        # rewrite img and iframe src
        $Output =~ s{
            (<(?:img|iframe).+?src=")(.+?)(".+?>)
        }
        {
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            if (lc $Target =~ m{^http s? :}smx || !$Self->{SessionID} ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/ ||
                $Target =~ /\Q$Self->{SessionName}\E=/) {
                $AHref.$Target.$End;
            }
            else {
                $AHref.$Target.'&'.$Self->{SessionName}.'='.$Self->{SessionID}.$End;
            }
        }iegxs;

        # rewrite forms: <form action="index.pl" method="get">
        my $SessionID = $Self->Ascii2Html( Text => $Self->{SessionID} );
        $Output =~ s{
            (<form.+?action=".+?".+?>)
        }
        {
            my $Form = $1;
            if ( lc $Form =~ m{^http s? :}smx ) {
                $Form;
            }
            else {
                $Form . "<input type=\"hidden\" name=\"$Self->{SessionName}\" value=\"$SessionID\"/>";
            }
        }iegx;
    }

    # run output element post filters
    if ( $Self->{FilterElementPost} && ref $Self->{FilterElementPost} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterElementPost} };

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            next FILTER if !$FilterConfig;
            next FILTER if ref $FilterConfig ne 'HASH';

            # extract template list
            my $TemplateList = $FilterConfig->{Templates};

            # check template list
            if ( !$TemplateList || ref $TemplateList ne 'HASH' || !%{$TemplateList} ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL} ) {
                next FILTER if !$TemplateList->{ $Param{TemplateFile} };
            }

            next FILTER
                if !$Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL};

            next FILTER if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data => \$Output,
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    # Cut out all dtl:js_on_document_complete tags. These will be inserted to the
    #   place with the js_on_document_complete_placeholder in the page footer if
    #   it is present.
    # This must be done after the post output filters, so that they can also inject
    #   and mofiy existing script tags.

    if ( !$Param{KeepScriptTags} ) {

        # find document ready
        $Output =~ s{
                <!--\s{0,1}dtl:js_on_document_complete\s{0,1}-->(.+?)<!--\s{0,1}dtl:js_on_document_complete\s{0,1}-->
        }
        {
                if (!$Self->{JSOnDocumentComplete}->{$1}) {
                    $Self->{JSOnDocumentComplete}->{$1} = 1;
                    $Self->{EnvRef}->{JSOnDocumentComplete} .= $Self->_RemoveScriptTags(Code => $1);
                }
                "";
        }segxm;

        # replace document ready placeholder (only if it's not included via $Include{""})
        if ( !$Param{Include} ) {
            $Output =~ s{
                <!--\s{0,1}dtl:js_on_document_complete_placeholder\s{0,1}-->
            }
            {
                if ( $Self->{EnvRef}->{JSOnDocumentComplete} ) {
                    $Self->{EnvRef}->{JSOnDocumentComplete};
                }
                else {
                    "";
                }
            }segxm;
        }
    }

    return $Output;
}

=item JSONEncode()

Encode perl data structure to JSON string

    my $JSON = $LayoutObject->JSONEncode(
        Data        => $Data,
        NoQuotes    => 0|1, # optional: no double quotes at the start and the end of JSON string
    );

=cut

sub JSONEncode {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return if !$Param{Data};

    # get JSON encoded data
    my $JSON = $Self->{JSONObject}->Encode(
        Data => $Param{Data},
    ) || '""';

    # remove trailing and trailing double quotes if requested
    if ( $Param{NoQuotes} ) {
        $JSON =~ s{ \A "(.*)" \z }{$1}smx;
    }

    return $JSON;
}

=item Redirect()

return html for browser to redirect

    my $HTML = $LayoutObject->Redirect(
        OP => "Action=AdminUserGroup;Subaction=User;ID=$UserID",
    );

    my $HTML = $LayoutObject->Redirect(
        ExtURL => "http://some.example.com/",
    );

=cut

sub Redirect {
    my ( $Self, %Param ) = @_;

    # add cookies if exists
    my $Cookies = '';
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Cookies .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # create & return output
    if ( $Param{ExtURL} ) {

        # external redirect
        $Param{Redirect} = $Param{ExtURL};
        return $Cookies . $Self->Output( TemplateFile => 'Redirect', Data => \%Param );
    }

    # set baselink
    $Param{Redirect} = $Self->{Baselink};

    if ( $Param{OP} ) {

        # Filter out hazardous characters
        if ( $Param{OP} =~ s{\x00}{}smxg ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a null bytes (\x00) character in redirect!',
            );
        }

        if ( $Param{OP} =~ s{\r}{}smxg ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a carriage return character in redirect!',
            );
        }

        if ( $Param{OP} =~ s{\n}{}smxg ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a newline character in redirect!',
            );
        }

        # internal redirect
        $Param{OP} =~ s/^.*\?(.+?)$/$1/;
        $Param{Redirect} .= $Param{OP};
    }

    # check if IIS is used, add absolute url for IIS workaround
    # see also:
    #  o http://bugs.otrs.org/show_bug.cgi?id=2230
    #  o http://support.microsoft.com/default.aspx?scid=kb;en-us;221154
    if ( $ENV{SERVER_SOFTWARE} =~ /^microsoft\-iis/i ) {
        my $Host = $ENV{HTTP_HOST} || $Self->{ConfigObject}->Get('FQDN');
        my $HttpType = $Self->{ConfigObject}->Get('HttpType');
        $Param{Redirect} = $HttpType . '://' . $Host . '/' . $Param{Redirect};
    }
    my $Output = $Cookies . $Self->Output( TemplateFile => 'Redirect', Data => \%Param );

    # add session id to redirect if no cookie is enabled
    if ( !$Self->{SessionIDCookie} ) {

        # rewrite location header
        $Output =~ s{
            (location:\s)(.*)
        }
        {
            my $Start  = $1;
            my $Target = $2;
            my $End = '';
            if ($Target =~ /^(.+?)#(|.+?)$/) {
                $Target = $1;
                $End = "#$2";
            }
            if ($Target =~ /http/i || !$Self->{SessionID}) {
                "$Start$Target$End";
            }
            else {
                if ($Target =~ /(\?|&)$/) {
                    "$Start$Target$Self->{SessionName}=$Self->{SessionID}$End";
                }
                elsif ($Target !~ /\?/) {
                    "$Start$Target?$Self->{SessionName}=$Self->{SessionID}$End";
                }
                elsif ($Target =~ /\?/) {
                    "$Start$Target&$Self->{SessionName}=$Self->{SessionID}$End";
                }
                else {
                    "$Start$Target?&$Self->{SessionName}=$Self->{SessionID}$End";
                }
            }
        }iegx;
    }
    return $Output;
}

sub Login {
    my ( $Self, %Param ) = @_;

    # set Action parameter for the loader
    $Self->{Action} = 'Login';

    # add cookies if exists
    my $Output = '';
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # get message of the day
    if ( $Self->{ConfigObject}->Get('ShowMotd') ) {
        $Param{Motd} = $Self->Output( TemplateFile => 'Motd', Data => \%Param );
    }

    # get lost password y
    if (
        $Self->{ConfigObject}->Get('LostPassword')
        && $Self->{ConfigObject}->Get('AuthModule') eq 'Kernel::System::Auth::DB'
        )
    {
        $Self->Block(
            Name => 'LostPasswordLink',
            Data => \%Param,
        );

        $Self->Block(
            Name => 'LostPassword',
            Data => \%Param,
        );
    }

   # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateAgentCSSCalls();
    $Self->LoaderCreateAgentJSCalls();

    # Add header logo, if configured
    if ( defined $Self->{ConfigObject}->Get('AgentLogo') ) {
        my %AgentLogo = %{ $Self->{ConfigObject}->Get('AgentLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %AgentLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $AgentLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');
                }
                $Data{'URL'} = 'url(' . $WebPath . $AgentLogo{$CSSStatement} . ')';
            }
            else {
                $Data{$CSSStatement} = $AgentLogo{$CSSStatement};
            }
        }

        $Self->Block(
            Name => 'HeaderLogoCSS',
            Data => \%Data,
        );
    }

    # add login logo, if configured
    if ( defined $Self->{ConfigObject}->Get('AgentLoginLogo') ) {
        my %AgentLoginLogo = %{ $Self->{ConfigObject}->Get('AgentLoginLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %AgentLoginLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');
                $Data{'URL'} = 'url(' . $WebPath . $AgentLoginLogo{$CSSStatement} . ')';
            }
            else {
                $Data{$CSSStatement} = $AgentLoginLogo{$CSSStatement};
            }
        }

        $Self->Block(
            Name => 'LoginLogoCSS',
            Data => \%Data,
        );

        $Self->Block(
            Name => 'LoginLogo'
        );
    }

    # create & return output
    $Output .= $Self->Output( TemplateFile => 'Login', Data => \%Param );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub ChallengeTokenCheck {
    my ( $Self, %Param ) = @_;

    # return if feature is disabled
    return 1 if !$Self->{ConfigObject}->Get('SessionCSRFProtection');

    # get challenge token and check it
    my $ChallengeToken = $Self->{ParamObject}->GetParam( Param => 'ChallengeToken' ) || '';

    # check regular ChallengeToken
    return 1 if $ChallengeToken eq $Self->{UserChallengeToken};

    # check ChallengeToken of all own sessions
    my @Sessions = $Self->{SessionObject}->GetAllSessionIDs();
    for my $SessionID (@Sessions) {
        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );
        next if !$Data{UserID};
        next if $Data{UserID} ne $Self->{UserID};
        next if !$Data{UserChallengeToken};

        # check ChallengeToken
        return 1 if $ChallengeToken eq $Data{UserChallengeToken};
    }

    # no valid token found
    $Self->FatalError(
        Message => 'Invalid Challenge Token!',
    );

    # ChallengeToken ok
    return;
}

sub FatalError {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }
    my $Output = $Self->Header( Area => 'Frontend', Title => 'Fatal Error' );
    $Output .= $Self->Error(%Param);
    $Output .= $Self->Footer();
    $Self->Print( Output => \$Output );
    exit;
}

sub SecureMode {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->Header( Area => 'Frontend', Title => 'Secure Mode' );
    $Output .= $Self->Output( TemplateFile => 'AdminSecureMode', Data => \%Param );
    $Output .= $Self->Footer();
    $Self->Print( Output => \$Output );
    exit;
}

sub FatalDie {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }

    # get backend error messages
    for (qw(Message Traceback)) {
        my $Backend = 'Backend' . $_;
        $Param{$Backend} = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => $_
        ) || '';
        $Param{$Backend} = $Self->Ascii2Html(
            Text           => $Param{$Backend},
            HTMLResultMode => 1,
        );
    }
    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }
    die $Param{Message};
}

sub ErrorScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->Header( Title => 'Error' );
    $Output .= $Self->Error(%Param);
    $Output .= $Self->Footer();
    return $Output;
}

sub Error {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    for (qw(Message Traceback)) {
        my $Backend = 'Backend' . $_;
        $Param{$Backend} = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => $_
        ) || '';
    }
    if ( !$Param{BackendMessage} && !$Param{BackendTraceback} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => $Param{Message} || '?',
        );
        for (qw(Message Traceback)) {
            my $Backend = 'Backend' . $_;
            $Param{$Backend} = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => $_
            ) || '';
        }
    }
    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }
    $Param{Message} =~ s/^(.{80}).*$/$1\[\.\.\]/gs;

    if ( $Param{BackendTraceback} ) {
        $Self->Block(
            Name => 'ShowBackendTraceback',
            Data => \%Param,
        );
    }

    # create & return output
    return $Self->Output( TemplateFile => 'Error', Data => \%Param );
}

sub Warning {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    $Param{BackendMessage} = $Self->{LogObject}->GetLogEntry(
        Type => 'Notice',
        What => 'Message',
        )
        || $Self->{LogObject}->GetLogEntry(
        Type => 'Error',
        What => 'Message',
        ) || '';

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output( TemplateFile => 'Warning', Data => \%Param );
}

=item Notify()

create notify lines

    infos, the text will be translated

    my $Output = $LayoutObject->Notify(
        Priority => 'Warning',
        Info => 'Some Info Message',
    );

    data with link, the text will be translated

    my $Output = $LayoutObject->Notify(
        Priority  => 'Warning',
        Data      => '$Text{"Some DTL Stuff"}',
        Link      => 'http://example.com/',
        LinkClass => 'some_CSS_class',              # optional
    );

    errors, the text will be translated

    my $Output = $LayoutObject->Notify(
        Priority => 'Error',
        Info => 'Some Error Message',
    );

    errors from log backend, if no error extists, a '' will be returned

    my $Output = $LayoutObject->Notify(
        Priority => 'Error',
    );

=cut

sub Notify {
    my ( $Self, %Param ) = @_;

    # create & return output
    if ( !$Param{Info} && !$Param{Data} ) {
        $Param{BackendMessage} = $Self->{LogObject}->GetLogEntry(
            Type => 'Notice',
            What => 'Message',
            )
            || $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => 'Message',
            ) || '';

        $Param{Info} = $Param{BackendMessage};

        # return if we have nothing to show
        return '' if !$Param{Info};
    }

    my $BoxClass = 'Notice';

    if ( $Param{Info} ) {
        $Param{Info} =~ s/\n//g;
    }
    if ( $Param{Priority} && $Param{Priority} eq 'Error' ) {
        $BoxClass = 'Error';
    }

    if ( $Param{Link} ) {
        $Self->Block(
            Name => 'LinkStart',
            Data => {
                LinkStart => $Param{Link},
                LinkClass => $Param{LinkClass} || '',
            },
        );
    }
    if ( $Param{Data} ) {
        $Self->Block(
            Name => 'Data',
            Data => \%Param,
        );
    }
    else {
        $Self->Block(
            Name => 'Text',
            Data => \%Param,
        );
    }
    if ( $Param{Link} ) {
        $Self->Block(
            Name => 'LinkStop',
            Data => { LinkStop => '</a>', },
        );
    }
    return $Self->Output(
        TemplateFile => 'Notify',
        Data         => {
            %Param,
            BoxClass => $BoxClass,
        },
    );
}

=item Header()

generates the HTML for the page begin in the Agent interface.

    my $Output = $LayoutObject->Header(
        Type              => 'Small',                # (optional) '' (Default, full header) or 'Small' (blank header)
        ShowToolbarItems  => 0,                      # (optional) default 1 (0|1)
        ShowPrefLink      => 0,                      # (optional) default 1 (0|1)
        ShowLogoutButton  => 0,                      # (optional) default 1 (0|1)
    );

=cut

sub Header {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || '';

    # check params
    if ( !defined $Param{ShowToolbarItems} ) {
        $Param{ShowToolbarItems} = 1;
    }

    if ( !defined $Param{ShowPrefLink} ) {
        $Param{ShowPrefLink} = 1;
    }

    # do not show preferences link if the preferences module is disabled
    my $Modules = $Self->{ConfigObject}->Get('Frontend::Module');
    if ( !$Modules->{AgentPreferences} ) {
        $Param{ShowPrefLink} = 0;
    }

    if ( !defined $Param{ShowLogoutButton} ) {
        $Param{ShowLogoutButton} = 1;
    }

    # set rtl if needed
    if ( $Self->{TextDirection} && $Self->{TextDirection} eq 'rtl' ) {
        $Param{BodyClass} = 'RTL';
    }
    elsif ( $Self->{ConfigObject}->Get('Frontend::DebugMode') ) {
        $Self->Block(
            Name => 'DebugRTLButton',
        );
    }

   # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateAgentCSSCalls();

    # Add header logo, if configured
    if ( defined $Self->{ConfigObject}->Get('AgentLogo') ) {
        my %AgentLogo = %{ $Self->{ConfigObject}->Get('AgentLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %AgentLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $AgentLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');
                }
                $Data{'URL'} = 'url(' . $WebPath . $AgentLogo{$CSSStatement} . ')';
            }
            else {
                $Data{$CSSStatement} = $AgentLogo{$CSSStatement};
            }
        }

        $Self->Block(
            Name => 'HeaderLogoCSS',
            Data => \%Data,
        );
    }

    # add cookies if exists
    my $Output = '';
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # fix IE bug if in filename is the word attachment
    my $File = $Param{Filename} || $Self->{Action} || 'unknown';
    if ( $Self->{BrowserBreakDispositionHeader} ) {
        $File =~ s/attachment/bttachment/gi;
    }

    # set file name for "save page as"
    $Param{ContentDisposition} = "filename=\"$File.html\"";

    # area and title
    if ( !$Param{Area} ) {
        $Param{Area}
            = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Self->{Action} }->{NavBarName}
            || '';
    }
    if ( !$Param{Title} ) {
        $Param{Title} = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    for my $Word (qw(Value Title Area)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= $Self->{LanguageObject}->Get( $Param{$Word} ) . ' - ';
        }
    }

    # run header meta modules
    my $HeaderMetaModule = $Self->{ConfigObject}->Get('Frontend::HeaderMetaModule');
    if ( ref $HeaderMetaModule eq 'HASH' ) {
        my %Jobs = %{$HeaderMetaModule};
        for my $Job ( sort keys %Jobs ) {

            # load and run module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next if !$Object;
            $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run tool bar item modules
    if ( $Self->{UserID} && $Self->{UserType} eq 'User' ) {
        my $ToolBarModule = $Self->{ConfigObject}->Get('Frontend::ToolBarModule');
        if ( $Param{ShowToolbarItems} && ref $ToolBarModule eq 'HASH' ) {
            my %Modules;
            my %Jobs = %{$ToolBarModule};
            for my $Job ( sort keys %Jobs ) {

                # load and run module
                next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    LayoutObject => $Self,
                );
                next if !$Object;
                %Modules = ( $Object->Run( %Param, Config => $Jobs{$Job} ), %Modules );
            }

            # show tool bar items
            my $ToolBarShown = 0;
            for my $Key ( sort keys %Modules ) {
                next if !%{ $Modules{$Key} };

                # show tool bar wrapper
                if ( !$ToolBarShown ) {
                    $ToolBarShown = 1;
                    $Self->Block(
                        Name => 'ToolBar',
                        Data => \%Param,
                    );
                }
                $Self->Block(
                    Name => $Modules{$Key}->{Block},
                    Data => {
                        %{ $Modules{$Key} },
                        AccessKeyReference => $Modules{$Key}->{AccessKey}
                        ? " ($Modules{$Key}->{AccessKey})"
                        : '',
                    },
                );
            }
        }

        # show logged in notice
        if ( $Param{ShowPrefLink} ) {
            $Self->Block(
                Name => 'Login',
                Data => \%Param,
            );
        }
        else {
            $Self->Block(
                Name => 'LoginWithoutLink',
                Data => \%Param,
            );
        }

        # show logout button (if registered)
        if (
            $Param{ShowLogoutButton}
            && $Self->{ConfigObject}->Get('Frontend::Module')->{Logout}
            )
        {
            $Self->Block(
                Name => 'Logout',
                Data => \%Param,
            );
        }
    }

    # create & return output
    $Output .= $Self->Output( TemplateFile => "Header$Type", Data => \%Param );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub Footer {
    my ( $Self, %Param ) = @_;

    my $Type          = $Param{Type}           || '';
    my $HasDatepicker = $Self->{HasDatepicker} || 0;

   # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateAgentJSCalls();

    # get datepicker data, if needed in module
    if ($HasDatepicker) {
        my $VacationDays     = $Self->DatepickerGetVacationDays();
        my $VacationDaysJSON = $Self->JSONEncode(
            Data => $VacationDays
        );

        my $TextDirection = $Self->{LanguageObject}->{TextDirection} || '';

        $Self->Block(
            Name => 'DatepickerData',
            Data => {
                VacationDays => $VacationDaysJSON,
                IsRTLLanguage => ( $TextDirection eq 'rtl' ) ? 1 : 0,
            },
        );
    }

    # NewTicketInNewWindow
    if ( $Self->{ConfigObject}->Get('NewTicketInNewWindow::Enabled') ) {
        $Self->Block(
            Name => 'NewTicketInNewWindow'
        );
    }

    # Banner
    if ( !$Self->{ConfigObject}->Get('Secure::DisableBanner') ) {
        $Self->Block(
            Name => 'Banner'
        );
    }

    # create & return output
    return $Self->Output( TemplateFile => "Footer$Type", Data => \%Param );
}

sub Print {
    my ( $Self, %Param ) = @_;

    # run output content filters
    if ( $Self->{FilterContent} && ref $Self->{FilterContent} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterContent} };

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            next FILTER if !$FilterConfig;
            next FILTER if ref $FilterConfig ne 'HASH';

            # extract template list
            my $TemplateList = $FilterConfig->{Templates};

            # check template list
            if ( !$TemplateList || ref $TemplateList ne 'HASH' || !%{$TemplateList} ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL} ) {
                next FILTER if !$TemplateList->{ $Param{TemplateFile} };
            }

            next FILTER if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data => $Param{Output},
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    print ${ $Param{Output} };

    return 1;
}

sub PrintHeader {
    my ( $Self, %Param ) = @_;

    # unless explicitly specified, we set the header width
    $Param{Width} ||= 640;

    # fix IE bug if in filename is the word attachment
    my $File = $Param{Filename} || $Self->{Action} || 'unknown';
    if ( $Self->{BrowserBreakDispositionHeader} ) {
        $File =~ s/attachment/bttachment/gi;
    }

    # set file name for "save page as"
    $Param{ContentDisposition} = "filename=\"$File.html\"";

    # area and title
    if ( !$Param{Area} ) {
        $Param{Area}
            = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Self->{Action} }->{NavBarName}
            || '';
    }
    if ( !$Param{Title} ) {
        $Param{Title} = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    for my $Word (qw(Area Title Value)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= ' - ' . $Self->{LanguageObject}->Get( $Param{$Word} );
        }
    }

    # set rtl if needed
    if ( $Self->{TextDirection} && $Self->{TextDirection} eq 'rtl' ) {
        $Param{BodyClass} = 'RTL';
    }

    my $Output = $Self->Output( TemplateFile => 'PrintHeader', Data => \%Param );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    # create & return output
    return $Output;
}

sub PrintFooter {
    my ( $Self, %Param ) = @_;

    $Param{Host} = $Self->Ascii2Html( Text => $ENV{SERVER_NAME} . $ENV{REQUEST_URI} );
    $Param{Host} =~ s/&amp;/&/ig;

    # create & return output
    return $Self->Output( TemplateFile => 'PrintFooter', Data => \%Param );
}

=item Ascii2Html()

convert ascii to html string

    my $HTML = $LayoutObject->Ascii2Html(
        Text            => 'Some <> Test <font color="red">Test</font>',
        Max             => 20,       # max 20 chars folowed by [..]
        VMax            => 15,       # first 15 lines
        NewLine         => 0,        # move \r to \n
        HTMLResultMode  => 0,        # replace " " with &nbsp;
        StripEmptyLines => 0,
        Type            => 'Normal', # JSText or Normal text
        LinkFeature     => 0,        # do some URL detections
    );

also string ref is possible

    my $HTMLStringRef = $LayoutObject->Ascii2Html(
        Text => \$String,
    );

=cut

sub Ascii2Html {
    my ( $Self, %Param ) = @_;

    # check needed param
    return '' if !defined $Param{Text};

    # check text
    my $TextScalar;
    my $Text;
    if ( !ref $Param{Text} ) {
        $TextScalar = 1;
        $Text       = \$Param{Text};
    }
    elsif ( ref $Param{Text} eq 'SCALAR' ) {
        $Text = $Param{Text};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Invalid ref "' . ref $Param{Text} . '" of Text param!',
        );
        return '';
    }

    # run output filter text
    my @Filters;
    if ( $Param{LinkFeature} && $Self->{FilterText} && ref $Self->{FilterText} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterText} };

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            next FILTER if !$FilterConfig;
            next FILTER if ref $FilterConfig ne 'HASH';

            # extract template list
            my $TemplateList = $FilterConfig->{Templates};

            # check template list
            if ( !$TemplateList || ref $TemplateList ne 'HASH' || !%{$TemplateList} ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL} ) {
                next FILTER if !$TemplateList->{ $Param{TemplateFile} };
            }

            $Self->FatalDie() if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            push(
                @Filters,
                {
                    Object => $Object,
                    Filter => $FilterConfig,
                },
            );
        }

        # pre run
        for my $Filter (@Filters) {

            $Text = $Filter->{Object}->Pre(
                Filter => $Filter->{Filter},
                Data   => $Text,
            );
        }
    }

    # max width
    if ( $Param{Max} && length ${$Text} > $Param{Max} ) {
        ${$Text} = substr( ${$Text}, 0, $Param{Max} - 5 ) . '[...]';
    }

    # newline
    if ( $Param{NewLine} && length( ${$Text} ) < 140_000 ) {
        ${$Text} =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
        ${$Text} =~ s/\r/\n/g;
        ${$Text} =~ s/(.{4,$Param{NewLine}})(?:\s|\z)/$1\n/gm;
        my $ForceNewLine = $Param{NewLine} + 10;
        ${$Text} =~ s/(.{$ForceNewLine})(.+?)/$1\n$2/g;
    }

    # remove tabs
    ${$Text} =~ s/\t/ /g;

    # strip empty lines
    if ( $Param{StripEmptyLines} ) {
        ${$Text} =~ s/^\s*\n//mg;
    }

    # max lines
    if ( $Param{VMax} ) {
        my @TextList = split( "\n", ${$Text} );
        ${$Text} = '';
        my $Counter = 1;
        for (@TextList) {
            if ( $Counter <= $Param{VMax} ) {
                ${$Text} .= $_ . "\n";
            }
            $Counter++;
        }
        if ( $Counter >= $Param{VMax} ) {
            ${$Text} .= "[...]\n";
        }
    }

    # html quoting
    ${$Text} =~ s/&/&amp;/g;
    ${$Text} =~ s/</&lt;/g;
    ${$Text} =~ s/>/&gt;/g;
    ${$Text} =~ s/"/&quot;/g;

    # text -> html format quoting
    if ( $Param{LinkFeature} ) {
        for my $Filter (@Filters) {
            $Text = $Filter->{Object}->Post(
                Filter => $Filter->{Filter},
                Data   => $Text,
            );
        }
    }

    if ( $Param{HTMLResultMode} ) {
        ${$Text} =~ s/\n/<br\/>\n/g;
        ${$Text} =~ s/  /&nbsp;&nbsp;/g;
    }

    if ( $Param{Type} && $Param{Type} eq 'JSText' ) {
        ${$Text} =~ s/'/\\'/g;
    }

    return $Text if ref $Param{Text};
    return ${$Text};
}

=item LinkQuote()

so some URL link detections

    my $HTMLWithLinks = $LayoutObject->LinkQuote(
        Text => $HTMLWithOutLinks,
    );

also string ref is possible

    my $HTMLWithLinksRef = $LayoutObject->LinkQuote(
        Text => \$HTMLWithOutLinksRef,
    );

=cut

sub LinkQuote {
    my ( $Self, %Param ) = @_;

    my $Text   = $Param{Text}   || '';
    my $Target = $Param{Target} || 'NewPage' . int( rand(199) );

    # check ref
    my $TextScalar;
    if ( !ref $Text ) {
        $TextScalar = $Text;
        $Text       = \$TextScalar;
    }

    # run output filter text
    my @Filters;
    if ( $Self->{FilterText} && ref $Self->{FilterText} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterText} };

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            next FILTER if !$FilterConfig;
            next FILTER if ref $FilterConfig ne 'HASH';

            # extract template list
            my $TemplateList = $FilterConfig->{Templates};

            # check template list
            if ( !$TemplateList || ref $TemplateList ne 'HASH' || !%{$TemplateList} ) {

                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Please add a template list to output filter $FilterConfig->{Module} "
                        . "to improve performance. Use ALL if OutputFilter should modify all "
                        . "templates of the system (deprecated).",
                );
            }

            # check template list
            if ( $Param{TemplateFile} && ref $TemplateList eq 'HASH' && !$TemplateList->{ALL} ) {
                next FILTER if !$TemplateList->{ $Param{TemplateFile} };
            }

            $Self->FatalDie() if !$Self->{MainObject}->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            push @Filters, {
                Object => $Object,
                Filter => $FilterConfig,
            };
        }
    }

    for my $Filter (@Filters) {
        $Text = $Filter->{Object}->Pre( Filter => $Filter->{Filter}, Data => $Text );
    }
    for my $Filter (@Filters) {
        $Text = $Filter->{Object}->Post( Filter => $Filter->{Filter}, Data => $Text );
    }

    # do mail to quote
    ${$Text} =~ s/(mailto:.+?)(\.\s|\s|\)|\"|]|')/<a href=\"$1\">$1<\/a>$2/gi;

    # check ref && return result like called
    if ($TextScalar) {
        return ${$Text};
    }
    else {
        return $Text;
    }
}

=item HTMLLinkQuote()

so some URL link detections in HTML code

    my $HTMLWithLinks = $LayoutObject->HTMLLinkQuote(
        String => $HTMLString,
    );

also string ref is possible

    my $HTMLWithLinksRef = $LayoutObject->HTMLLinkQuote(
        String => \$HTMLString,
    );

=cut

sub HTMLLinkQuote {
    my ( $Self, %Param ) = @_;

    return $Self->{HTMLUtilsObject}->LinkQuote(
        String    => $Param{String},
        TargetAdd => 1,
        Target    => '_blank',
    );
}

=item LinkEncode()

perform URL encoding on query string parameter names or values.

    my $ParamValueEncoded = $LayoutObject->LinkEncode($ParamValue);

Don't encode entire URLs, because this will make them invalid
(?, & and ; will be encoded as well). Only pass one parameter name
or value at a time.

=cut

sub LinkEncode {
    my ( $Self, $Link ) = @_;

    return if !defined $Link;

    return URI::Escape::uri_escape_utf8($Link);
}

sub CustomerAgeInHours {
    my ( $Self, %Param ) = @_;

    my $Age = defined( $Param{Age} ) ? $Param{Age} : return;
    my $Space     = $Param{Space} || '<br/>';
    my $AgeStrg   = '';
    my $HourDsc   = 'h';
    my $MinuteDsc = 'm';
    if ( $Self->{ConfigObject}->Get('TimeShowCompleteDescription') ) {
        $HourDsc   = 'hour';
        $MinuteDsc = 'minute';
    }
    if ( $Age =~ /^-(.*)/ ) {
        $Age     = $1;
        $AgeStrg = '-';
    }

    # get hours
    if ( $Age >= 3600 ) {
        $AgeStrg .= int( ( $Age / 3600 ) ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Get($HourDsc);
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $Age <= 3600 || int( ( $Age / 60 ) % 60 ) ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Get($MinuteDsc);
    }
    return $AgeStrg;
}

sub CustomerAge {
    my ( $Self, %Param ) = @_;

    my $Age = defined( $Param{Age} ) ? $Param{Age} : return;
    my $Space     = $Param{Space} || '<br/>';
    my $AgeStrg   = '';
    my $DayDsc    = 'd';
    my $HourDsc   = 'h';
    my $MinuteDsc = 'm';
    if ( $Self->{ConfigObject}->Get('TimeShowCompleteDescription') ) {
        $DayDsc    = 'day';
        $HourDsc   = 'hour';
        $MinuteDsc = 'minute';
    }
    if ( $Age =~ /^-(.*)/ ) {
        $Age     = $1;
        $AgeStrg = '-';
    }

    # get days
    if ( $Age >= 86400 ) {
        $AgeStrg .= int( ( $Age / 3600 ) / 24 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Get($DayDsc);
        $AgeStrg .= $Space;
    }

    # get hours
    if ( $Age >= 3600 ) {
        $AgeStrg .= int( ( $Age / 3600 ) % 24 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Get($HourDsc);
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $Self->{ConfigObject}->Get('TimeShowAlwaysLong') || $Age < 86400 ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Get($MinuteDsc);
    }
    return $AgeStrg;
}

=item BuildSelection()

build a html option element based on given data

    my $HTML = $LayoutObject->BuildSelection(
        Data            => $ArrayRef,             # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
        Name            => 'TheName',             # name of element
        ID              => 'HTMLID',              # (optional) the HTML ID for this element, if not provided, the name will be used as ID as well
        Multiple        => 0,                     # (optional) default 0 (0|1)
        Size            => 1,                     # (optional) default 1 element size
        Class           => 'class',               # (optional) a css class
        Disabled        => 0,                     # (optional) default 0 (0|1) disable the element
        AutoComplete    => 'off',                 # (optional)
        OnChange        => 'javascript',          # (optional)
        OnClick         => 'javascript',          # (optional)

        SelectedID     => 1,                 # (optional) use integer or arrayref (unable to use with ArrayHashRef)
        SelectedID     => [1, 5, 3],         # (optional) use integer or arrayref (unable to use with ArrayHashRef)
        SelectedValue  => 'test',            # (optional) use string or arrayref (unable to use with ArrayHashRef)
        SelectedValue  => ['test', 'test1'], # (optional) use string or arrayref (unable to use with ArrayHashRef)

        Sort           => 'NumericValue',    # (optional) (AlphanumericValue|NumericValue|AlphanumericKey|NumericKey|TreeView|IndividualKey|IndividualValue) unable to use with ArrayHashRef
        SortIndividual => ['sec', 'min']     # (optional) only sort is set to IndividualKey or IndividualValue
        SortReverse    => 0,                 # (optional) reverse the list

        Translation    => 1,                 # (optional) default 1 (0|1) translate value
        PossibleNone   => 0,                 # (optional) default 0 (0|1) add a leading empty selection
        TreeView       => 0,                 # (optional) default 0 (0|1)
        DisabledBranch => 'Branch',          # (optional) disable all elements of this branch (use string or arrayref)
        Max            => 100,               # (optional) default 100 max size of the shown value
        HTMLQuote      => 0,                 # (optional) default 1 (0|1) disable html quote
        Title          => 'Tooltip Text',    # (optional) string will be shown as Tooltip on mouseover
        OptionTitle    => 1,                 # (optional) default 0 (0|1) show title attribute (the option value) on every option element
    );

    my $HashRef = {
        Key1 => 'Value1',
        Key2 => 'Value2',
        Key3 => 'Value3',
    };

    my $ArrayRef = [
        'KeyValue1',
        'KeyValue2',
        'KeyValue3',
        'KeyValue4',
    ];

    my $ArrayHashRef = [
        {
            Key   => '1',
            Value => 'Value1',
        },
        {
            Key      => '2',
            Value    => 'Value1::Subvalue1',
            Selected => 1,
        },
        {
            Key   => '3',
            Value => 'Value1::Subvalue2',
        },
        {
            Key      => '4',
            Value    => 'Value2',
            Disabled => 1,
        }
    ];

=cut

sub BuildSelection {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # The parameters 'Ajax' and 'OnChange' are exclusive
    if ( $Param{Ajax} && $Param{OnChange} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The parameters 'OnChange' and 'Ajax' exclude each other!"
        );
        return;
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Depend Param Ajax option!',
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Update Param Ajax option()!',
            );
            $Self->FatalError();
        }
        my $Selector = $Param{ID} || $Param{Name};
        $Param{OnChange} = "Core.AJAX.FormUpdate(\$('#"
            . $Selector . "'), '" . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    # create OptionRef
    my $OptionRef = $Self->_BuildSelectionOptionRefCreate(%Param);

    # create AttributeRef
    my $AttributeRef = $Self->_BuildSelectionAttributeRefCreate(%Param);

    # create DataRef
    my $DataRef = $Self->_BuildSelectionDataRefCreate(
        Data         => $Param{Data},
        AttributeRef => $AttributeRef,
        OptionRef    => $OptionRef,
    );

    # generate output
    my $String = $Self->_BuildSelectionOutput(
        AttributeRef => $AttributeRef,
        DataRef      => $DataRef,
        OptionTitle  => $Param{OptionTitle},
        TreeView     => $Param{TreeView},
    );
    return $String;
}

sub NoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';
    $Param{Message} = 'Insufficient Rights.' if ( !$Param{Message} );

    # create output
    my $Output;
    $Output = $Self->Header( Title => 'Insufficient Rights' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output( TemplateFile => 'NoPermission', Data => \%Param );
    $Output .= $Self->Footer() if ( $WithHeader eq 'yes' );

    # return output
    return $Output;
}

=item Permission()

check if access to a frontend module exists

    my $Access = $LayoutObject->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw', # ro|rw possible
    );

=cut

sub Permission {
    my ( $Self, %Param ) = @_;

    # check needed params
    for (qw(Action Type)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $_!",
            );
            $Self->FatalError();
        }
    }

    # check if it is ro|rw
    my %Map = (
        ro => 'GroupRo',
        rw => 'Group',

    );
    my $Permission = $Map{ $Param{Type} };
    return if !$Permission;

    # get config option for frontend module
    my $Config = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Action} };
    return if !$Config;

    my $Item = $Config->{$Permission};

    # array access restriction
    my $Access = 0;
    if ( $Item && ref $Item eq 'ARRAY' ) {
        for ( @{$Item} ) {
            my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
            if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                $Access = 1;
            }
        }
    }

    # scalar access restriction
    elsif ($Item) {
        my $Key = 'UserIs' . $Permission . '[' . $Item . ']';
        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
            $Access = 1;
        }
    }

    # no access restriction
    elsif ( !$Config->{GroupRo} && !$Config->{Group} ) {
        $Access = 1;
    }
    return $Access;
}

sub CheckCharset {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    if ( !$Param{Action} ) {
        $Param{Action} = '$Env{"Action"}';
    }

    # with utf-8 can everything be shown
    if ( $Self->{UserCharset} !~ /^utf-8$/i ) {

        # replace ' or "
        $Param{Charset} && $Param{Charset} =~ s/'|"//gi;

        # if the content charset is different to the user charset
        if ( $Param{Charset} && $Self->{UserCharset} !~ /^$Param{Charset}$/i ) {

            # if the content charset is us-ascii it is always shown correctly
            if ( $Param{Charset} !~ /us-ascii/i ) {
                $Output = '<p><i class="small">'
                    . '$Text{"This message was written in a character set other than your own."}'
                    . '$Text{"If it is not displayed correctly,"} '
                    . '<a href="'
                    . $Self->{Baselink}
                    . "Action=$Param{Action};TicketID=$Param{TicketID}"
                    . ";ArticleID=$Param{ArticleID};Subaction=ShowHTMLeMail\" target=\"HTMLeMail\" "
                    . 'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'
                    . '$Text{"click here"}</a> $Text{"to open it in a new window."}</i></p>';
            }
        }
    }

    # return note string
    return $Output;
}

sub CheckMimeType {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    if ( !$Param{Action} ) {
        $Param{Action} = '$Env{"Action"}';
    }

    # check if it is a text/plain email
    if ( $Param{MimeType} && $Param{MimeType} !~ /text\/plain/i ) {
        $Output = '<p><i class="small">$Text{"This is a"} '
            . $Param{MimeType}
            . ' $Text{"email"}, '
            . '<a href="'
            . $Self->{Baselink}
            . "Action=$Param{Action};TicketID="
            . "$Param{TicketID};ArticleID=$Param{ArticleID};Subaction=ShowHTMLeMail\" "
            . 'target="HTMLeMail" '
            . 'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'
            . '$Text{"click here"}</a> '
            . '$Text{"to open it in a new window."}</i></p>';
    }

    # just to be compat
    elsif ( $Param{Body} =~ /^<.DOCTYPE\s+html|^<HTML>/i ) {
        $Output = '<p><i class="small">$Text{"This is a"} '
            . $Param{MimeType}
            . ' $Text{"email"}, '
            . '<a href="'
            . $Self->{Baselink}
            . 'Action=$Env{"Action"};TicketID='
            . "$Param{TicketID};ArticleID=$Param{ArticleID};Subaction=ShowHTMLeMail\" "
            . 'target="HTMLeMail" '
            . 'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'
            . '$Text{"click here"}</a> '
            . '$Text{"to open it in a new window."}</i></p>';
    }

    # return note string
    return $Output;
}

sub ReturnValue {
    my ( $Self, $What ) = @_;

    return $Self->{$What};
}

=item Attachment()

returns browser output to display/download a attachment

    $HTML = $LayoutObject->Attachment(
        Type        => 'inline',        # optional, default: attachment, possible: inline|attachment
        Filename    => 'FileName.png',  # optional
        ContentType => 'image/png',
        Content     => $Content,
    );

    or for AJAX html snippets

    $HTML = $LayoutObject->Attachment(
        Type        => 'inline',        # optional, default: attachment, possible: inline|attachment
        Filename    => 'FileName.html', # optional
        ContentType => 'text/html',
        Charset     => 'utf-8',         # optional
        Content     => $Content,
        NoCache     => 1,               # optional
    );

=cut

sub Attachment {
    my ( $Self, %Param ) = @_;

    # check needed params
    for (qw(Content ContentType)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $_!",
            );
            $Self->FatalError();
        }
    }

    # return attachment
    my $Output = 'Content-Disposition: ';
    if ( $Param{Type} ) {
        $Output .= $Param{Type};
        $Output .= '; ';
    }
    else {
        $Output .= $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';
        $Output .= '; ';
    }

    # clean filename to get no problems with some browsers
    if ( $Param{Filename} ) {

        # detect if IE6 workaround is used (solution for IE problem with multi byte filename)
        # to solve this kind of problems use the following in dtl for attachment downloads:
        # <a href="$Env{"CGIHandle"}/$LQData{"Filename"}?Action=...">xxx</a>
        my $FilenameInHeader = 1;

        # check if browser is broken
        if ( $Self->{BrowserBreakDispositionHeader} && $ENV{REQUEST_URI} ) {

            # check if IE 6 workaround is used
            if ( $ENV{REQUEST_URI} =~ /\Q$Self->{CGIHandle}\E\/.+?\?Action=/ ) {
                $FilenameInHeader = 0;
            }
        }

        # only deliver filename if needed
        if ($FilenameInHeader) {
            $Output .= " filename=\"$Param{Filename}\"";
        }
    }
    $Output .= "\n";

    # get attachment size
    $Param{Size} = bytes::length( $Param{Content} );

    # add no cache headers
    if ( $Param{NoCache} ) {
        $Output .= "Expires: Tue, 1 Jan 1980 12:00:00 GMT\n";
        $Output .= "Cache-Control: no-cache\n";
        $Output .= "Pragma: no-cache\n";
    }
    $Output .= "Content-Length: $Param{Size}\n";

    if ( $Param{Charset} ) {
        $Output .= "Content-Type: $Param{ContentType}; charset=$Param{Charset};\n\n";
    }
    else {
        $Output .= "Content-Type: $Param{ContentType}\n\n";
    }

    # disable utf8 flag, to write binary to output
    $Self->{EncodeObject}->EncodeOutput( \$Output );
    $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );

    # fix for firefox HEAD problem
    if ( !$ENV{REQUEST_METHOD} || $ENV{REQUEST_METHOD} ne 'HEAD' ) {
        $Output .= $Param{Content};
    }

    # reset binmode, don't use utf8
    binmode STDOUT, ':bytes';

    return $Output;
}

=item PageNavBar()

generates a page nav bar

    my %PageNavBar = $LayoutObject->PageNavBar(
        Limit       => 100,         # marks result of TotalHits red if Limit is gerater then AllHits
        WindowSize  => 15,          # max shown pages to click
        StartHit    => 1,           # start to show items
        PageShown   => 15,          # number of shown items a page
        AllHits     => 56,          # number of total hits
        Action      => 'AgentXXX',  # e. g. 'Action=' . $Self->{LayoutObject}->{Action}
        Link        => $Link,       # e. g. 'Subaction=View;'
        AJAXReplace => 'IDElement', # IDElement which should be replaced
        IDPrefix    => 'Tickets',   # Prefix for the id parameter
    );

    return values of hash

        TotalHits  # total hits
        Result     # shown items e. g. "1-5" or "16-30"
        SiteNavBar # html for page nav bar e. g. "1 2 3 4"

        ResultLong     # shown items e. g. "1-5 of 32" or "16-30 of 64"
        SiteNavBarLong # html for page nav bar e. g. "Page: 1 2 3 4"

=cut

sub PageNavBar {
    my ( $Self, %Param ) = @_;

    my $Limit = $Param{Limit} || 0;
    $Param{AllHits}  = 0 if ( !$Param{AllHits} );
    $Param{StartHit} = 0 if ( !$Param{AllHits} );
    my $Pages = int( ( $Param{AllHits} / $Param{PageShown} ) + 0.99999 );
    my $Page  = int( ( $Param{StartHit} / $Param{PageShown} ) + 0.99999 );
    my $WindowSize = $Param{WindowSize} || 5;
    my $IDPrefix   = $Param{IDPrefix}   || 'Generic';

    # build Results (1-5 or 16-30)
    if ( $Param{AllHits} >= ( $Param{StartHit} + $Param{PageShown} ) ) {
        $Param{Results} = $Param{StartHit} . "-" . ( $Param{StartHit} + $Param{PageShown} - 1 );
    }
    else {
        $Param{Results} = "$Param{StartHit}-$Param{AllHits}";
    }

    # check total hits
    if ( $Limit == $Param{AllHits} ) {
        $Param{TotalHits} = "<span class=\"PaginationLimit\">$Param{AllHits}</span>";
    }
    else {
        $Param{TotalHits} = $Param{AllHits};
    }

    # build page nav bar
    my $WindowStart = sprintf( "%.0f", ( $Param{StartHit} / $Param{PageShown} ) );
    $WindowStart = int( ( $WindowStart / $WindowSize ) ) + 1;
    $WindowStart = ( $WindowStart * $WindowSize ) - ($WindowSize);
    my $Action = $Param{Action} || '';
    my $Link   = $Param{Link}   || '';
    my $Baselink = "$Self->{Baselink}$Action;$Link";
    my $i        = 0;
    while ( $i <= ( $Pages - 1 ) ) {
        $i++;

        # show normal page 1,2,3,...
        if ( $i <= ( $WindowStart + $WindowSize ) && $i > $WindowStart ) {
            my $BaselinkAll
                = $Baselink
                . "StartWindow=$WindowStart;StartHit="
                . ( ( ( $i - 1 ) * $Param{PageShown} ) + 1 );
            my $SelectedPage = "";
            my $PageNumber   = $i;

            if ( $Page == $i ) {
                $SelectedPage = " class=\"Selected\"";
            }

            if ( $Param{AJAXReplace} ) {
                $Self->Block(
                    Name => 'PageAjax',
                    Data => {
                        BaselinkAll  => $BaselinkAll,
                        AjaxReplace  => $Param{AJAXReplace},
                        PageNumber   => $PageNumber,
                        IDPrefix     => $IDPrefix,
                        SelectedPage => $SelectedPage
                    },
                );
            }
            else {
                $Self->Block(
                    Name => 'Page',
                    Data => {
                        BaselinkAll  => $BaselinkAll,
                        PageNumber   => $PageNumber,
                        IDPrefix     => $IDPrefix,
                        SelectedPage => $SelectedPage
                    },
                );
            }
        }

        # over window ">>" and ">|"
        elsif ( $i > ( $WindowStart + $WindowSize ) ) {
            my $StartWindow     = $WindowStart + $WindowSize + 1;
            my $LastStartWindow = int( $Pages / $WindowSize );
            my $BaselinkAllBack = $Baselink . "StartHit=" . ( $i - 1 ) * $Param{PageShown};
            my $BaselinkAllNext
                = $Baselink . "StartHit=" . ( ( $Param{PageShown} * ( $Pages - 1 ) ) + 1 );

            if ( $Param{AJAXReplace} ) {
                $Self->Block(
                    Name => 'PageForwardAjax',
                    Data => {
                        BaselinkAllBack => $BaselinkAllBack,
                        BaselinkAllNext => $BaselinkAllNext,
                        AjaxReplace     => $Param{AJAXReplace},
                        IDPrefix        => $IDPrefix,
                    },
                );
            }
            else {
                $Self->Block(
                    Name => 'PageForward',
                    Data => {
                        BaselinkAllBack => $BaselinkAllBack,
                        BaselinkAllNext => $BaselinkAllNext,
                        IDPrefix        => $IDPrefix,
                    },
                );
            }

            $i = 99999999;
        }

        # over window "<<" and "|<"
        elsif ( $i < $WindowStart && ( $i - 1 ) < $Pages ) {
            my $StartWindow     = $WindowStart - $WindowSize - 1;
            my $BaselinkAllBack = $Baselink . 'StartHit=1;StartWindow=1';
            my $BaselinkAllNext
                = $Baselink . 'StartHit=' . ( ( $WindowStart - 1 ) * ( $Param{PageShown} ) + 1 );

            if ( $Param{AJAXReplace} ) {
                $Self->Block(
                    Name => 'PageBackAjax',
                    Data => {
                        BaselinkAllBack => $BaselinkAllBack,
                        BaselinkAllNext => $BaselinkAllNext,
                        AjaxReplace     => $Param{AJAXReplace},
                        IDPrefix        => $IDPrefix,
                    },
                );
            }
            else {
                $Self->Block(
                    Name => 'PageBack',
                    Data => {
                        BaselinkAllBack => $BaselinkAllBack,
                        BaselinkAllNext => $BaselinkAllNext,
                        IDPrefix        => $IDPrefix,
                    },
                );
            }

            $i = $WindowStart - 1;
        }
    }

    $Param{SearchNavBar} = $Self->Output(
        TemplateFile   => 'Pagination',
        KeepScriptTags => $Param{KeepScriptTags},
    );

    # only show total amount of pages if there is more than one
    if ( $Pages > 1 ) {
        $Param{NavBarLong} = "- \$Text{\"Page\"}: $Param{SearchNavBar}";
    }
    else {
        $Param{SearchNavBar} = '';
    }

    # return data
    return (
        TotalHits      => $Param{TotalHits},
        Result         => $Param{Results},
        ResultLong     => "$Param{Results} \$Text{\"of\"} $Param{TotalHits}",
        SiteNavBar     => $Param{SearchNavBar},
        SiteNavBarLong => $Param{NavBarLong},
        Link           => $Param{Link},
    );
}

sub NavigationBar {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Param{Type} = $Self->{ModuleReg}->{NavBarName} || 'Ticket';
    }

    # create menu items
    my %NavBar;
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('Frontend::Module');

    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        next if !$Hash{NavBar};
        next if ref $Hash{NavBar} ne 'ARRAY';

        my @Items = @{ $Hash{NavBar} };
        for my $Item (@Items) {
            next if !$Item->{NavBar};
            $Item->{CSS} = '';

            # highlight active area link
            if (
                ( $Item->{Type} && $Item->{Type} eq 'Menu' )
                && ( $Item->{NavBar} && $Item->{NavBar} eq $Param{Type} )
                )
            {
                $Item->{CSS} .= ' Selected';
            }

            # get permissions from module if no permissions are defined for the icon
            if ( !$Item->{GroupRo} && !$Item->{Group} ) {
                if ( $Hash{GroupRo} ) {
                    $Item->{GroupRo} = $Hash{GroupRo};
                }
                if ( $Hash{Group} ) {
                    $Item->{Group} = $Hash{Group};
                }
            }

            # check shown permission
            my $Shown = 0;
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Item->{$Permission} && ref $Item->{$Permission} eq 'ARRAY' ) {
                    for ( @{ $Item->{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
                        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                            $Shown = 1;
                            last;
                        }
                    }
                }

                # scalar access restriction
                elsif ( $Item->{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Item->{$Permission} . ']';
                    if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                        last;
                    }
                }

                # no access restriction
                elsif ( !$Item->{GroupRo} && !$Item->{Group} ) {
                    $Shown = 1;
                    last;
                }
            }
            next if !$Shown;

            # set prio of item
            my $Key = ( $Item->{Block} || '' ) . sprintf( "%07d", $Item->{Prio} );
            for ( 1 .. 51 ) {
                last if !$NavBar{$Key};

                $Item->{Prio}++;
                $Key = ( $Item->{Block} || '' ) . sprintf( "%07d", $Item->{Prio} );
            }

            # show as main menu
            if ( $Item->{Type} eq 'Menu' ) {
                $NavBar{$Key} = $Item;
            }

            # show as sub of main menu
            else {
                $NavBar{Sub}->{ $Item->{NavBar} }->{$Key} = $Item;
            }
        }
    }

    # run menu item modules
    if ( ref $Self->{ConfigObject}->Get('Frontend::NavBarModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Frontend::NavBarModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next if !$Object;

            # run module
            %NavBar = ( %NavBar, $Object->Run( %Param, Config => $Jobs{$Job} ) );
        }
    }

    # show nav bar
    for my $Key ( sort keys %NavBar ) {
        next if $Key eq 'Sub';
        next if !%{ $NavBar{$Key} };
        my $Item = $NavBar{$Key};
        $Item->{NameForID} = $Item->{Name};
        $Item->{NameForID} =~ s/[ &;]//ig;
        my $Sub = $NavBar{Sub}->{ $Item->{NavBar} };

        $Self->Block(
            Name => 'ItemArea',    #$NavBar{$_}->{Block} || 'Item',
            Data => {
                %$Item,
                AccessKeyReference => $Item->{AccessKey} ? " ($Item->{AccessKey})" : '',
            },
        );

        # show sub menu
        next if !$Sub;
        $Self->Block(
            Name => 'ItemAreaSub',
            Data => $Item,
        );
        for my $Key ( sort keys %{$Sub} ) {
            my $ItemSub = $Sub->{$Key};
            $ItemSub->{NameForID} = $ItemSub->{Name};
            $ItemSub->{NameForID} =~ s/[ &;]//ig;
            $ItemSub->{NameTop} = $Item->{NameForID};
            $Self->Block(
                Name => 'ItemAreaSubItem',    #$Item->{Block} || 'Item',
                Data => {
                    %$ItemSub,
                    AccessKeyReference => $ItemSub->{AccessKey} ? " ($ItemSub->{AccessKey})" : '',
                },
            );
        }
    }

    # create & return output
    my $Output = $Self->Output( TemplateFile => 'AgentNavigationBar', Data => \%Param );

    # run nav bar output modules
    my $NavBarOutputModuleConfig = $Self->{ConfigObject}->Get('Frontend::NavBarOutputModule');
    if ( ref $NavBarOutputModuleConfig eq 'HASH' ) {
        my %Jobs = %{$NavBarOutputModuleConfig};
        for my $Job ( sort keys %Jobs ) {

            # load module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next if !$Object;

            # run module
            $Output .= $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run notification modules
    my $FrontendNotifyModuleConfig = $Self->{ConfigObject}->Get('Frontend::NotifyModule');
    if ( ref $FrontendNotifyModuleConfig eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};
        for my $Job ( sort keys %Jobs ) {

            # load module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next if !$Object;

            # run module
            $Output .= $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run nav bar modules
    if ( $Self->{ModuleReg}->{NavBarModule} ) {

        # run navbar modules
        my %Jobs = %{ $Self->{ModuleReg}->{NavBarModule} };

        # load module
        next if !$Self->{MainObject}->Require( $Jobs{Module} );
        my $Object = $Jobs{Module}->new(
            %{$Self},
            LayoutObject => $Self,
        );
        next if !$Object;

        # run module
        $Output .= $Object->Run( %Param, Config => \%Jobs );
    }
    return $Output;
}

sub TransformDateSelection {
    my ( $Self, %Param ) = @_;

    # get key prefix
    my $Prefix = $Param{Prefix} || '';

    # time zone translation if needed
    if ( $Self->{ConfigObject}->Get('TimeZoneUser') && $Self->{UserTimeZone} ) {
        my $TimeStamp = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ $Prefix . 'Year' } . '-'
                . $Param{ $Prefix . 'Month' } . '-'
                . $Param{ $Prefix . 'Day' } . ' '
                . ( $Param{ $Prefix . 'Hour' }   || 0 ) . ':'
                . ( $Param{ $Prefix . 'Minute' } || 0 )
                . ':00',
        );
        $TimeStamp = $TimeStamp - ( $Self->{UserTimeZone} * 3600 );
        (
            $Param{ $Prefix . 'Second' },
            $Param{ $Prefix . 'Minute' },
            $Param{ $Prefix . 'Hour' },
            $Param{ $Prefix . 'Day' },
            $Param{ $Prefix . 'Month' },
            $Param{ $Prefix . 'Year' }
        ) = $Self->{UserTimeObject}->SystemTime2Date( SystemTime => $TimeStamp );
    }

    # reset prefix
    $Param{Prefix} = '';

    return %Param;
}

sub BuildDateSelection {
    my ( $Self, %Param ) = @_;

    my $DateInputStyle = $Self->{ConfigObject}->Get('TimeInputFormat');
    my $Prefix         = $Param{Prefix} || '';
    my $DiffTime       = $Param{DiffTime} || 0;
    my $Format         = defined( $Param{Format} ) ? $Param{Format} : 'DateInputFormatLong';
    my $Area           = $Param{Area} || 'Agent';
    my $Optional       = $Param{ $Prefix . 'Optional' } || 0;
    my $Required       = $Param{ $Prefix . 'Required' } || 0;
    my $Used           = $Param{ $Prefix . 'Used' } || 0;
    my $Class          = $Param{ $Prefix . 'Class' } || '';

    # Defines, if the date selection should be validated on client side with JS
    my $Validate = $Param{Validate} || 0;

    # Validate that the date is in the future (e. g. pending times)
    my $ValidateDateInFuture = $Param{ValidateDateInFuture} || 0;

    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{UserTimeObject}->SystemTime2Date(
        SystemTime => $Self->{UserTimeObject}->SystemTime() + $DiffTime,
    );
    my $DatepickerHTML = '';

    # time zone translation
    if (
        $Self->{ConfigObject}->Get('TimeZoneUser')
        && $Self->{UserTimeZone}
        && $Param{ $Prefix . 'Year' }
        && $Param{ $Prefix . 'Month' }
        && $Param{ $Prefix . 'Day' }
        )
    {
        my $TimeStamp = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ $Prefix . 'Year' } . '-'
                . $Param{ $Prefix . 'Month' } . '-'
                . $Param{ $Prefix . 'Day' } . ' '
                . ( $Param{ $Prefix . 'Hour' }   || 0 ) . ':'
                . ( $Param{ $Prefix . 'Minute' } || 0 )
                . ':00',
        );
        $TimeStamp = $TimeStamp + ( $Self->{UserTimeZone} * 3600 );
        (
            $Param{ $Prefix . 'Second' },
            $Param{ $Prefix . 'Minute' },
            $Param{ $Prefix . 'Hour' },
            $Param{ $Prefix . 'Day' },
            $Param{ $Prefix . 'Month' },
            $Param{ $Prefix . 'Year' }
        ) = $Self->{UserTimeObject}->SystemTime2Date( SystemTime => $TimeStamp );
    }

    # year
    if ( $DateInputStyle eq 'Option' ) {
        my %Year;
        if ( defined $Param{YearPeriodPast} && defined $Param{YearPeriodFuture} ) {
            for ( $Y - $Param{YearPeriodPast} .. $Y + $Param{YearPeriodFuture} ) {
                $Year{$_} = $_;
            }
        }
        else {
            for ( $Y - 10 .. $Y + 1 + ( $Param{YearDiff} || 0 ) ) {
                $Year{$_} = $_;
            }
        }
        $Param{Year} = $Self->BuildSelection(
            Name        => $Prefix . 'Year',
            Data        => \%Year,
            SelectedID  => int( $Param{ $Prefix . 'Year' } || $Y ),
            Translation => 0,
            Class       => $Validate ? 'Validate_DateYear' : '',
            Title       => $Self->{LanguageObject}->Get('Year'),
        );
    }
    else {
        $Param{Year} = "<input type=\"text\" "
            . ( $Validate ? "class=\"Validate_DateYear $Class\" " : "class=\"$Class\" " )
            . "name=\"${Prefix}Year\" id=\"${Prefix}Year\" size=\"4\" maxlength=\"4\" "
            . "title=\""
            . $Self->{LanguageObject}->Get('Year')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Year' } || $Y ) ) . "\"/>";
    }

    # month
    if ( $DateInputStyle eq 'Option' ) {
        my %Month = map { $_ => sprintf( "%02d", $_ ); } ( 1 .. 12 );
        $Param{Month} = $Self->BuildSelection(
            Name        => $Prefix . 'Month',
            Data        => \%Month,
            SelectedID  => int( $Param{ $Prefix . 'Month' } || $M ),
            Translation => 0,
            Class       => $Validate ? 'Validate_DateMonth' : '',
            Title       => $Self->{LanguageObject}->Get('Month'),
        );
    }
    else {
        $Param{Month}
            = "<input type=\"text\" "
            . ( $Validate ? "class=\"Validate_DateMonth $Class\" " : "class=\"$Class\" " )
            . "name=\"${Prefix}Month\" id=\"${Prefix}Month\" size=\"2\" maxlength=\"2\" "
            . "title=\""
            . $Self->{LanguageObject}->Get('Month')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) . "\"/>";
    }

    my $DateValidateClasses = '';
    if ($Validate) {
        $DateValidateClasses
            .= "Validate_DateDay Validate_DateYear_${Prefix}Year Validate_DateMonth_${Prefix}Month";
        if ($ValidateDateInFuture) {
            $DateValidateClasses .= " Validate_DateInFuture";
        }
    }

    # day
    if ( $DateInputStyle eq 'Option' ) {
        my %Day = map { $_ => sprintf( "%02d", $_ ); } ( 1 .. 31 );
        $Param{Day} = $Self->BuildSelection(
            Name        => $Prefix . 'Day',
            Data        => \%Day,
            SelectedID  => int( $Param{ $Prefix . 'Day' } || $D ),
            Translation => 0,
            Class       => "$DateValidateClasses $Class",
            Title       => $Self->{LanguageObject}->Get('Day'),
        );
    }
    else {
        $Param{Day} = "<input type=\"text\" "
            . "class=\"$DateValidateClasses $Class\" "
            . "name=\"${Prefix}Day\" id=\"${Prefix}Day\" size=\"2\" maxlength=\"2\" "
            . "title=\""
            . $Self->{LanguageObject}->Get('Day')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Day' } || $D ) ) . "\"/>";
    }
    if ( $Format eq 'DateInputFormatLong' ) {

        # hour
        if ( $DateInputStyle eq 'Option' ) {
            my %Hour = map { $_ => sprintf( "%02d", $_ ); } ( 0 .. 23 );
            $Param{Hour} = $Self->BuildSelection(
                Name       => $Prefix . 'Hour',
                Data       => \%Hour,
                SelectedID => defined( $Param{ $Prefix . 'Hour' } )
                ? int( $Param{ $Prefix . 'Hour' } )
                : int($h),
                Translation => 0,
                Class       => $Validate ? ( 'Validate_DateHour ' . $Class ) : $Class,
                Title       => $Self->{LanguageObject}->Get('Hours'),
            );
        }
        else {
            $Param{Hour} = "<input type=\"text\" "
                . ( $Validate ? "class=\"Validate_DateHour $Class\" " : "class=\"$Class\" " )
                . "name=\"${Prefix}Hour\" id=\"${Prefix}Hour\" size=\"2\" maxlength=\"2\" "
                . "title=\""
                . $Self->{LanguageObject}->Get('Hours')
                . "\" value=\""
                . sprintf(
                "%02d",
                ( defined( $Param{ $Prefix . 'Hour' } ) ? int( $Param{ $Prefix . 'Hour' } ) : $h )
                )
                . "\"/>";
        }

        # minute
        if ( $DateInputStyle eq 'Option' ) {
            my %Minute = map { $_ => sprintf( "%02d", $_ ); } ( 0 .. 59 );
            $Param{Minute} = $Self->BuildSelection(
                Name       => $Prefix . 'Minute',
                Data       => \%Minute,
                SelectedID => defined( $Param{ $Prefix . 'Minute' } )
                ? int( $Param{ $Prefix . 'Minute' } )
                : int($m),
                Translation => 0,
                Class       => $Validate ? ( 'Validate_DateMinute ' . $Class ) : $Class,
                Title       => $Self->{LanguageObject}->Get('Minutes'),
            );
        }
        else {
            $Param{Minute} = "<input type=\"text\" "
                . ( $Validate ? "class=\"Validate_DateMinute $Class\" " : "class=\"$Class\" " )
                . "name=\"${Prefix}Minute\" id=\"${Prefix}Minute\" size=\"2\" maxlength=\"2\" "
                . "title=\""
                . $Self->{LanguageObject}->Get('Minutes')
                . "\" value=\""
                . sprintf(
                "%02d",
                (
                    defined( $Param{ $Prefix . 'Minute' } )
                    ? int( $Param{ $Prefix . 'Minute' } )
                    : $m
                    )
                ) . "\"/>";
        }
    }

    # Get first day of the week
    my $WeekDayStart = $Self->{ConfigObject}->Get('CalendarWeekDayStart');
    if ( !defined $WeekDayStart ) {
        $WeekDayStart = 1;
    }

    # Datepicker
    $DatepickerHTML = '<!--dtl:js_on_document_complete--><script type="text/javascript">//<![CDATA[
        Core.UI.Datepicker.Init({
            Day: $(\'#' . $Prefix . 'Day\'),
            Month: $(\'#' . $Prefix . 'Month\'),
            Year: $(\'#' . $Prefix . 'Year\'),
            Hour: $(\'#' . $Prefix . 'Hour\'),
            Minute: $(\'#' . $Prefix . 'Minute\'),
            DateInFuture: ' . ( $ValidateDateInFuture ? 'true' : 'false' ) . ',
            WeekDayStart: ' . $WeekDayStart . '
        });
    //]]></script>
    <!--dtl:js_on_document_complete-->';

    my $Output;

    # optional checkbox
    if ($Optional) {
        my $Checked       = '';
        my $ValidateClass = '';
        if ($Used) {
            $Checked = ' checked="checked"';
        }
        if ($Required) {
            $ValidateClass = ' class="Validate_Required"';
        }
        $Output .= "<input type=\"checkbox\" name=\""
            . $Prefix
            . "Used\" id=\"" . $Prefix . "Used\" value=\"1\""
            . $Checked
            . $ValidateClass
            . " title=\""
            . $Self->{LanguageObject}->Get('Check to activate this date')
            . "\" />&nbsp;";
    }

    # date format
    $Output .= $Self->{LanguageObject}->Time(
        Action => 'Return',
        Format => 'DateInputFormat',
        Mode   => 'NotNumeric',
        %Param,
    );

    # add Datepicker HTML to output
    $Output .= $DatepickerHTML;

    # set global var to true to add a block to the footer later
    $Self->{HasDatepicker} = 1;

    return $Output;
}

sub CustomerLogin {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{TitleArea} = $Self->{LanguageObject}->Get('Login') . ' - ';

    # set Action parameter for the loader
    $Self->{Action} = 'CustomerLogin';

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # check if message should be shown
    if ( $Param{Message} ) {
        $Self->Block(
            Name => 'Message',
            Data => \%Param,
        );
    }

    # get lost password output
    if (
        $Self->{ConfigObject}->Get('CustomerPanelLostPassword')
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq
        'Kernel::System::CustomerAuth::DB'
        )
    {
        $Self->Block(
            Name => 'LostPasswordLink',
            Data => \%Param,
        );
        $Self->Block(
            Name => 'LostPassword',
            Data => \%Param,
        );
    }

    # get lost password output
    if (
        $Self->{ConfigObject}->Get('CustomerPanelCreateAccount')
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq
        'Kernel::System::CustomerAuth::DB'
        )

    {
        $Self->Block(
            Name => 'CreateAccountLink',
            Data => \%Param,
        );
        $Self->Block(
            Name => 'CreateAccount',
            Data => \%Param,
        );
    }

   # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateCustomerCSSCalls();
    $Self->LoaderCreateCustomerJSCalls();

    # Add header logo, if configured
    if ( defined $Self->{ConfigObject}->Get('CustomerLogo') ) {
        my %CustomerLogo = %{ $Self->{ConfigObject}->Get('CustomerLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %CustomerLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $CustomerLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');
                }
                $Data{'URL'} = 'url(' . $WebPath . $CustomerLogo{$CSSStatement} . ')';
            }
            else {
                $Data{$CSSStatement} = $CustomerLogo{$CSSStatement};
            }
        }

        $Self->Block(
            Name => 'HeaderLogoCSS',
            Data => \%Data,
        );

        $Self->Block(
            Name => 'HeaderLogo',
        );
    }

    # create & return output
    $Output .= $Self->Output( TemplateFile => 'CustomerLogin', Data => \%Param );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub CustomerHeader {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || '';

    # add cookies if exists
    my $Output = '';
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # area and title
    if (
        !$Param{Area}
        && $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Area} = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Self->{Action} }
            ->{NavBarName} || '';
    }
    if (
        !$Param{Title}
        && $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Title}
            = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    if (
        !$Param{Area}
        && $Self->{ConfigObject}->Get('PublicFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Area} = $Self->{ConfigObject}->Get('PublicFrontend::Module')->{ $Self->{Action} }
            ->{NavBarName} || '';
    }
    if (
        !$Param{Title}
        && $Self->{ConfigObject}->Get('PublicFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Title}
            = $Self->{ConfigObject}->Get('PublicFrontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    for my $Word (qw(Value Title Area)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= $Self->{LanguageObject}->Get( $Param{$Word} ) . ' - ';
        }
    }

    my $Frontend;
    if ( $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{ $Self->{Action} } ) {
        $Frontend = 'Customer';
    }
    else {
        $Frontend = 'Public';
    }

    # run header meta modules for customer and public frontends
    my $HeaderMetaModule = $Self->{ConfigObject}->Get( $Frontend . 'Frontend::HeaderMetaModule' );
    if ( ref $HeaderMetaModule eq 'HASH' ) {
        my %Jobs = %{$HeaderMetaModule};
        for my $Job ( sort keys %Jobs ) {

            # load and run module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, LayoutObject => $Self );
            next if !$Object;
            $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # set rtl if needed
    if ( $Self->{TextDirection} && $Self->{TextDirection} eq 'rtl' ) {
        $Param{BodyClass} = 'RTL';
    }
    elsif ( $Self->{ConfigObject}->Get('Frontend::DebugMode') ) {
        $Self->Block(
            Name => 'DebugRTLButton',
        );
    }

    # Add header logo, if configured
    if ( defined $Self->{ConfigObject}->Get('CustomerLogo') ) {
        my %CustomerLogo = %{ $Self->{ConfigObject}->Get('CustomerLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %CustomerLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $CustomerLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');
                }
                $Data{'URL'} = 'url(' . $WebPath . $CustomerLogo{$CSSStatement} . ')';
            }
            else {
                $Data{$CSSStatement} = $CustomerLogo{$CSSStatement};
            }
        }

        $Self->Block(
            Name => 'HeaderLogoCSS',
            Data => \%Data,
        );

        $Self->Block(
            Name => 'HeaderLogo',
        );
    }

    # Generate the minified CSS and JavaScript files
    # and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateCustomerCSSCalls();

    # create & return output
    $Output .= $Self->Output(
        TemplateFile => "CustomerHeader$Type",
        Data         => \%Param,
    );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub CustomerFooter {
    my ( $Self, %Param ) = @_;

    my $Type          = $Param{Type}           || '';
    my $HasDatepicker = $Self->{HasDatepicker} || 0;

    # Generate the minified CSS and JavaScript files
    # and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateCustomerJSCalls();

    # get datepicker data, if needed in module
    if ($HasDatepicker) {
        my $VacationDays     = $Self->DatepickerGetVacationDays();
        my $VacationDaysJSON = $Self->JSONEncode(
            Data => $VacationDays,
        );

        my $TextDirection = $Self->{LanguageObject}->{TextDirection} || '';

        $Self->Block(
            Name => 'DatepickerData',
            Data => {
                VacationDays => $VacationDaysJSON,
                IsRTLLanguage => ( $TextDirection eq 'rtl' ) ? 1 : 0,
            },
        );
    }

    # Banner
    if ( !$Self->{ConfigObject}->Get('Secure::DisableBanner') ) {
        $Self->Block(
            Name => 'Banner',
        );
    }

    # create & return output
    return $Self->Output( TemplateFile => "CustomerFooter$Type", Data => \%Param );
}

sub CustomerFatalError {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }
    my $Output = $Self->CustomerHeader( Area => 'Frontend', Title => 'Fatal Error' );
    $Output .= $Self->Error(%Param);
    $Output .= $Self->CustomerFooter();
    $Self->Print( Output => \$Output );
    exit;
}

sub CustomerNavigationBar {
    my ( $Self, %Param ) = @_;

    # create menu items
    my %NavBarModule;
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('CustomerFrontend::Module');

    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        next if !$Hash{NavBar};
        next if ref $Hash{NavBar} ne 'ARRAY';

        my @Items = @{ $Hash{NavBar} };
        for my $Item (@Items) {
            next if !$Item;

            # check permissions
            my $Shown = 0;

            # get permissions from module if no permissions are defined for the icon
            if ( !$Item->{GroupRo} && !$Item->{Group} ) {
                if ( $Hash{GroupRo} ) {
                    $Item->{GroupRo} = $Hash{GroupRo};
                }
                if ( $Hash{Group} ) {
                    $Item->{Group} = $Hash{Group};
                }
            }

            # check shown permission
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Item->{$Permission} && ref $Item->{$Permission} eq 'ARRAY' ) {
                    for my $Type ( @{ $Item->{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $Type . ']';
                        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                            $Shown = 1;
                            last;
                        }
                    }
                }

                # scalar access restriction
                elsif ( $Item->{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Item->{$Permission} . ']';
                    if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                        last;
                    }
                }

                # no access restriction
                elsif ( !$Item->{GroupRo} && !$Item->{Group} ) {
                    $Shown = 1;
                    last;
                }
            }
            next if !$Shown;

            # set prio of item
            my $Key = sprintf( "%07d", $Item->{Prio} );
            for ( 1 .. 51 ) {
                last if !$NavBarModule{$Key};

                $Item->{Prio}++;
            }

            if ( $Item->{Type} eq 'Menu' ) {
                $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }

            # show as sub of main menu
            elsif ( $Item->{Type} eq 'Submenu' ) {
                $NavBarModule{Sub}->{ $Item->{NavBar} }->{ sprintf( "%07d", $Item->{Prio} ) }
                    = $Item;
            }
            else {
                $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }
        }
    }

    # run menu item modules
    if ( ref $Self->{ConfigObject}->Get('CustomerFrontend::NavBarModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('CustomerFrontend::NavBarModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                $Self->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                ConfigObject => $Self->{ConfigObject},
                LogObject    => $Self->{LogObject},
                DBObject     => $Self->{DBObject},
                LayoutObject => $Self,
                UserID       => $Self->{UserID},
                Debug        => $Self->{Debug},
            );

            # run module
            %NavBarModule = ( %NavBarModule, $Object->Run( %Param, Config => $Jobs{$Job} ) );
        }
    }

    my $Total   = keys %NavBarModule;
    my $Counter = 0;

    if ( $NavBarModule{Sub} ) {
        $Total = int($Total) - 1;
    }

    # Only highlight the first matched navigation entry. If there are several entries
    #   with the same Action and Subaction, it cannot be determined which one was used.
    #   Therefore we just highlight the first one.
    my $SelectedFlag;
    for my $Item ( sort keys %NavBarModule ) {
        next if !%{ $NavBarModule{$Item} };
        next if $Item eq 'Sub';
        $Counter++;
        my $Sub;
        if ( $NavBarModule{$Item}->{NavBar} ) {
            $Sub = $NavBarModule{Sub}->{ $NavBarModule{$Item}->{NavBar} };
        }

        # highlight active link
        $NavBarModule{$Item}->{Class} = '';
        if ( $NavBarModule{$Item}->{Link} ) {
            if (
                !$SelectedFlag
                && $NavBarModule{$Item}->{Link} =~ /Action=$Self->{Action}/
                && $NavBarModule{$Item}->{Link} =~ /$Self->{Subaction}/    # Subaction can be empty
                )
            {
                $NavBarModule{$Item}->{Class} .= ' Selected';
                $SelectedFlag = 1;
            }
        }
        if ( $Counter == $Total ) {
            $NavBarModule{$Item}->{Class} .= ' Last';
        }
        $Self->Block(
            Name => $NavBarModule{$Item}->{Block} || 'Item',
            Data => $NavBarModule{$Item},
        );

        # show sub menu
        next if !$Sub;
        $Self->Block(
            Name => 'ItemAreaSub',
            Data => $Item,
        );
        for my $Key ( sort keys %{$Sub} ) {
            my $ItemSub = $Sub->{$Key};
            $ItemSub->{NameForID} = $ItemSub->{Name};
            $ItemSub->{NameForID} =~ s/[ &;]//ig;
            $ItemSub->{NameTop} = $NavBarModule{$Item}->{NameForID};

            # check if we must mark the parent element as selected
            if ( $ItemSub->{Link} ) {
                if (
                    !$SelectedFlag
                    && $ItemSub->{Link} =~ /Action=$Self->{Action}/
                    && $ItemSub->{Link} =~ /$Self->{Subaction}/    # Subaction can be empty
                    )
                {
                    $NavBarModule{$Item}->{Class} .= ' Selected';
                    $ItemSub->{Class} .= ' SubSelected';
                    $SelectedFlag = 1;
                }
            }

            $Self->Block(
                Name => 'ItemAreaSubItem',
                Data => {
                    %$ItemSub,
                    AccessKeyReference => $ItemSub->{AccessKey} ? " ($ItemSub->{AccessKey})" : '',
                },
            );
        }
    }

    # run notification modules
    my $FrontendNotifyModuleConfig = $Self->{ConfigObject}->Get('CustomerFrontend::NotifyModule');
    if ( ref $FrontendNotifyModuleConfig eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};
        for my $Job ( sort keys %Jobs ) {

            # load module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next if !$Object;

            # run module
            $Param{Notification} .= $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # create the customer user login info (usually at the right side of the navigation bar)
    if ( !$Self->{UserLoginIdentifier} ) {
        $Param{UserLoginIdentifier} = $Self->{UserEmail} ne $Self->{UserCustomerID}
            ?
            "( $Self->{UserEmail} / $Self->{UserCustomerID} )"
            : $Self->{UserEmail};
    }
    else {
        $Param{UserLoginIdentifier} = $Self->{UserLoginIdentifier};
    }

    # only on valid session
    if ( $Self->{UserID} ) {

        # show logout button (if registered)
        if ( $FrontendModuleConfig->{Logout} ) {
            $Self->Block(
                Name => 'Logout',
                Data => \%Param,
            );
        }

        # show preferences button (if registered)
        if ( $FrontendModuleConfig->{CustomerPreferences} ) {
            if ( $Self->{Action} eq 'CustomerPreferences' ) {
                $Param{Class} = 'Selected';
            }
            $Self->Block(
                Name => 'Preferences',
                Data => \%Param,
            );
        }
    }

    # create & return output
    return $Self->Output( TemplateFile => 'CustomerNavigationBar', Data => \%Param );
}

sub CustomerError {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    for (qw(Message Traceback)) {
        $Param{ 'Backend' . $_ } = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => $_
        ) || '';
    }
    if ( !$Param{BackendMessage} && !$Param{BackendTraceback} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => $Param{Message} || '?',
        );
        for (qw(Message Traceback)) {
            $Param{ 'Backend' . $_ } = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => $_
            ) || '';
        }
    }

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output( TemplateFile => 'CustomerError', Data => \%Param );
}

sub CustomerErrorScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->CustomerHeader( Title => 'Error' );
    $Output .= $Self->CustomerError(%Param);
    $Output .= $Self->CustomerFooter();
    return $Output;
}

sub CustomerWarning {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    $Param{BackendMessage} = $Self->{LogObject}->GetLogEntry(
        Type => 'Notice',
        What => 'Message',
        )
        || $Self->{LogObject}->GetLogEntry(
        Type => 'Error',
        What => 'Message',
        ) || '';

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output( TemplateFile => 'CustomerWarning', Data => \%Param );
}

sub CustomerNoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';
    $Param{Message} ||= 'No Permission!';

    # create output
    my $Output;
    $Output = $Self->CustomerHeader( Title => 'No Permission' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output( TemplateFile => 'NoPermission', Data => \%Param );
    $Output .= $Self->CustomerFooter() if ( $WithHeader eq 'yes' );

    # return output
    return $Output;
}

=item Ascii2RichText()

converts text to rich text

    my $HTMLString = $LayoutObject->Ascii2RichText(
        String => $TextString,
    );

=cut

sub Ascii2RichText {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # ascii 2 html
    $Param{String} = $Self->{HTMLUtilsObject}->ToHTML(
        String => $Param{String},
    );

    return $Param{String};
}

=item RichText2Ascii()

converts text to rich text

    my $TextString = $LayoutObject->RichText2Ascii(
        String => $HTMLString,
    );

=cut

sub RichText2Ascii {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # ascii 2 html
    $Param{String} = $Self->{HTMLUtilsObject}->ToAscii(
        String => $Param{String},
    );

    return $Param{String};
}

=item RichTextDocumentComplete()

1) add html, body, ... tags to be a valid html document
2) replace links of inline content e. g. images to <img src="cid:xxxx" />

    $HTMLBody = $LayoutObject->RichTextDocumentComplete(
        String => $HTMLBody,
    );

=cut

sub RichTextDocumentComplete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # replace image link with content id for uploaded images
    my $StringRef = $Self->_RichTextReplaceLinkOfInlineContent(
        String => \$Param{String},
    );

    # verify html document
    $Param{String} = $Self->{HTMLUtilsObject}->DocumentComplete(
        String  => ${$StringRef},
        Charset => $Self->{UserCharset},
    );

    # do correct direction
    if ( $Self->{TextDirection} ) {
        $Param{String} =~ s/<body/<body dir="$Self->{TextDirection}"/i;
    }

    # filter links in response
    $Param{String} = $Self->HTMLLinkQuote( String => $Param{String} );

    return $Param{String};
}

=begin Internal:

=cut

=item _RichTextReplaceLinkOfInlineContent()

replace links of inline content e. g. images

    $HTMLBodyStringRef = $LayoutObject->_RichTextReplaceLinkOfInlineContent(
        String => $HTMLBodyStringRef,
    );

=cut

sub _RichTextReplaceLinkOfInlineContent {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # replace image link with content id for uploaded images
    ${ $Param{String} } =~ s{
        (<img.+?src=("|'))[^>]+ContentID=(.+?)("|')([^>]+>)
    }
    {
        $1 . 'cid:' . $3 . $4 . $5;
    }esgxi;

    return $Param{String};
}

=end Internal:

=item RichTextDocumentServe()

serve a rich text (HTML) document for local view inside of an iframe in correct charset and with correct
links for inline documents.

By default, all inline/active content (such as script, object, applet or embed tags)
will be stripped. If there are external images, they will be stripped too,
but a message will be shown allowing the user to reload the page showing the external images.

    my %HTMLFile = $LayoutObject->RichTextDocumentServe(
        Data => {
            Content     => $HTMLBodyRef,
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL               => 'AgentTicketAttachment;Subaction=HTMLView;ArticleID=123;FileID=',
        Attachments       => \%AttachmentListOfInlineAttachments,

        LoadInlineContent => 0,     # Serve the document including all inline content. WARNING: This might be dangerous.

        LoadExternalImages => 0,    # Load external images? If this is 0, a message will be included if
                                    # external images were found and removed.
    );

=cut

sub RichTextDocumentServe {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data URL Attachments)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get charset and convert content to internal charset
    if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
        my $Charset = $Param{Data}->{ContentType};
        $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
        $Charset =~ s/"|'//g;
        $Charset =~ s/(.+?);.*/$1/g;

        # convert charset
        if ($Charset) {
            $Param{Data}->{Content} = $Self->{EncodeObject}->Convert(
                Text => $Param{Data}->{Content},
                From => $Charset,
                To   => $Self->{UserCharset},
            );

            # replace charset in content
            $Param{Data}->{ContentType} =~ s/\Q$Charset\E/utf-8/gi;
            $Param{Data}->{Content} =~ s/(charset=("|'|))\Q$Charset\E/$1utf-8/gi;
        }
    }

    # add html links
    $Param{Data}->{Content} = $Self->HTMLLinkQuote(
        String => $Param{Data}->{Content},
    );

    # cleanup some html tags to be cross browser compat.
    $Param{Data}->{Content} = $Self->RichTextDocumentCleanup(
        String => $Param{Data}->{Content},
    );

    # safety check
    if ( !$Param{LoadInlineContent} ) {

        # Strip out active content first, keeping external images.
        my %SafetyCheckResult = $Self->{HTMLUtilsObject}->Safety(
            String       => $Param{Data}->{Content},
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoSVG        => 1,
            NoIntSrcLoad => 0,
            NoExtSrcLoad => 0,
            NoJavaScript => 1,
            Debug        => $Self->{Debug},
        );

        $Param{Data}->{Content} = $SafetyCheckResult{String};

        if ( !$Param{LoadExternalImages} ) {

            # Strip out external images, but show a confirmation button to
            #   load them explicitly.
            my %SafetyCheckResult = $Self->{HTMLUtilsObject}->Safety(
                String       => $Param{Data}->{Content},
                NoApplet     => 1,
                NoObject     => 1,
                NoEmbed      => 1,
                NoSVG        => 1,
                NoIntSrcLoad => 0,
                NoExtSrcLoad => 1,
                NoJavaScript => 1,
                Debug        => $Self->{Debug},
            );

            $Param{Data}->{Content} = $SafetyCheckResult{String};

            if ( $SafetyCheckResult{Replace} ) {

                # Generate blocker message.
                my $Message = $Self->Output( TemplateFile => 'AttachmentBlocker' );

                # Add it to the beginning of the body, if possible, otherwise prepend it.
                if ( $Param{Data}->{Content} =~ /<body.*?>/si ) {
                    $Param{Data}->{Content} =~ s/(<body.*?>)/$1\n$Message/si;
                }
                else {
                    $Param{Data}->{Content} = $Message . $Param{Data}->{Content};
                }
            }

        }
    }

    # build base url for inline images
    my $SessionID = '';
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
        $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
    }

    # replace inline images in content with runtime url to images
    my $AttachmentLink = $Self->{Baselink} . $Param{URL};
    $Param{Data}->{Content} =~ s{
        (=|"|')cid:(.*?)("|'|>|\/>|\s)
    }
    {
        my $Start= $1;
        my $ContentID = $2;
        my $End = $3;

        # improve html quality
        if ( $Start ne '"' && $Start ne '\'' ) {
            $Start .= '"';
        }
        if ( $End ne '"' && $End ne '\'' ) {
            $End = '"' . $End;
        }

        # find matching attachment and replace it with runtime url to image
        for my $AttachmentID (  sort keys %{ $Param{Attachments} }) {
            next if lc $Param{Attachments}->{$AttachmentID}->{ContentID} ne lc "<$ContentID>";
            $ContentID = $AttachmentLink . $AttachmentID . $SessionID;
            last;
        }

        # return new runtime url
        $Start . $ContentID . $End;
    }egxi;

    # bug #5053
    # inline images using Content-Location as identifier instead of Content-ID even RFC2557
    # http://www.ietf.org/rfc/rfc2557.txt

    # find matching attachment and replace it with runtlime url to image
    for my $AttachmentID ( sort keys %{ $Param{Attachments} } ) {
        next if !$Param{Attachments}->{$AttachmentID}->{ContentID};

        # content id cleanup
        $Param{Attachments}->{$AttachmentID}->{ContentID} =~ s/^<//;
        $Param{Attachments}->{$AttachmentID}->{ContentID} =~ s/>$//;

        $Param{Data}->{Content} =~ s{
        (=|"|')(\Q$Param{Attachments}->{$AttachmentID}->{ContentID}\E)("|'|>|\/>|\s)
    }
    {
        my $Start= $1;
        my $ContentID = $2;
        my $End = $3;

        # improve html quality
        if ( $Start ne '"' && $Start ne '\'' ) {
            $Start .= '"';
        }
        if ( $End ne '"' && $End ne '\'' ) {
            $End = '"' . $End;
        }

        # return new runtime url
        $ContentID = $AttachmentLink . $AttachmentID . $SessionID;
        $Start . $ContentID . $End;
    }egxi;
    }

    return %{ $Param{Data} };
}

=item RichTextDocumentCleanup()

please see L<Kernel::System::HTML::Layout::DocumentCleanup()>

=cut

sub RichTextDocumentCleanup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    $Param{String} = $Self->{HTMLUtilsObject}->DocumentCleanup(
        String => $Param{String},
    );

    return $Param{String};
}

=begin Internal:

=cut

sub _BlockTemplatePreferences {
    my ( $Self, %Param ) = @_;

    my %TagsOpen;
    my @Preferences;
    my $LastLayerCount = 0;
    my $Layer          = 0;
    my $LastLayer      = '';
    my $CurrentLayer   = '';
    my %UsedNames;
    my $TemplateFile = $Param{TemplateFile} || '';
    if ( !defined $Param{Template} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Template!' );
        return;
    }

    if ( $Self->{PrasedBlockTemplatePreferences}->{$TemplateFile} ) {
        return $Self->{PrasedBlockTemplatePreferences}->{$TemplateFile};
    }

    $Param{Template} =~ s{
        <!--\s{0,1}dtl:block:(.+?)\s{0,1}-->
    }
    {
        my $BlockName = $1;
        if (!$TagsOpen{$BlockName}) {
            $Layer++;
            $TagsOpen{$BlockName} = 1;
            my $CL = '';
            if ($Layer == 1) {
                $LastLayer = '';
                $CurrentLayer = $BlockName;
            }
            elsif ($LastLayerCount == $Layer) {
                $CurrentLayer = $LastLayer.'::'.$BlockName;
            }
            else {
                $LastLayer = $CurrentLayer;
                $CurrentLayer = $CurrentLayer.'::'.$BlockName;
            }
            $LastLayerCount = $Layer;
            if (!$UsedNames{$BlockName}) {
                push (@Preferences, {
                    Name => $BlockName,
                    Layer => $Layer,
                    },
                );
                $UsedNames{$BlockName} = 1;
            }
        }
        else {
            $TagsOpen{$BlockName} = 0;
            $Layer--;
        }
    }segxm;

    # check open (invalid) tags
    for ( sort keys %TagsOpen ) {
        if ( $TagsOpen{$_} ) {
            my $Message = "'dtl:block:$_' isn't closed!";
            if ($TemplateFile) {
                $Message .= " ($TemplateFile.dtl)";
            }
            $Self->{LogObject}->Log( Priority => 'error', Message => $Message );
            $Self->FatalError();
        }
    }

    # remember block data
    if ($TemplateFile) {
        $Self->{PrasedBlockTemplatePreferences}->{$TemplateFile} = \@Preferences;
    }

    return \@Preferences;
}

sub _BlockTemplatesReplace {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Template} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Template!' );
        return;
    }
    my $TemplateString = $Param{Template};

    # get availabe template block preferences
    my $BlocksRef = $Self->_BlockTemplatePreferences(
        Template => $$TemplateString,
        TemplateFile => $Param{TemplateFile} || '',
    );
    my %BlockLayer;
    my %BlockTemplates;
    for my $Block ( reverse @{$BlocksRef} ) {
        $$TemplateString =~ s{
            <!--\s{0,1}dtl:block:$Block->{Name}\s{0,1}-->(.+?)<!--\s{0,1}dtl:block:$Block->{Name}\s{0,1}-->
        }
        {
            $BlockTemplates{$Block->{Name}} = $1;
            "<!-- dtl:place_block:$Block->{Name} -->";
        }segxm;
        $BlockLayer{ $Block->{Name} } = $Block->{Layer};
    }

    # create block template string
    my @BR;
    if ( $Self->{BlockData} && %BlockTemplates ) {
        my @NotUsedBlockData;
        for my $Block ( @{ $Self->{BlockData} } ) {
            if ( $BlockTemplates{ $Block->{Name} } ) {
                push(
                    @BR,
                    {
                        Layer => $BlockLayer{ $Block->{Name} },
                        Name  => $Block->{Name},
                        Data  => $Self->_Output(
                            Template => $BlockTemplates{ $Block->{Name} },
                            Data     => $Block->{Data},
                        ),
                    }
                );
            }
            else {
                push @NotUsedBlockData, { %{$Block} };
            }
        }

        # remember not use block data
        $Self->{BlockData} = \@NotUsedBlockData;
    }

    return @BR;
}

sub _Output {
    my ( $Self, %Param ) = @_;

    # deep recursion protection
    $Self->{OutputCount}++;
    if ( $Self->{OutputCount} > 20 ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Loop detection!',
        );
        $Self->FatalDie();
    }

    # create refs
    my $GlobalRef = {
        Env    => $Self->{EnvRef},
        Data   => $Param{Data},
        Config => $Self->{ConfigObject},
    };

    my $TemplateString = $Param{Template};

    # parse/get text blocks
    my @BR = $Self->_BlockTemplatesReplace(
        Template => \$TemplateString,
        TemplateFile => $Param{TemplateFile} || '',
    );

    # check if a block structure exists
    if ( scalar @BR ) {

        # process structure
        my $BlockStructure;
        my $LastLayer = $BR[-1]->{Layer};
        for my $Block (
            reverse
            {
                Data  => $TemplateString,
                Layer => 0,
                Name  => 'TemplateString',
            },
            @BR
            )
        {

            # process and remove substructure (if exists)
            if (
                $Block->{Layer} < $LastLayer
                && ref $BlockStructure->{ $Block->{Layer} + 1 } eq 'HASH'
                )
            {
                for my $SubLayer ( sort keys %{ $BlockStructure->{ $Block->{Layer} + 1 } } ) {
                    my $SubLayerString = join '',
                        @{ $BlockStructure->{ $Block->{Layer} + 1 }->{$SubLayer} };
                    $Block->{Data}
                        =~ s{ <!-- [ ] dtl:place_block: $SubLayer [ ] --> }{$SubLayerString}xms;
                }
                undef $BlockStructure->{ $Block->{Layer} + 1 };
            }

            # for safety - clean up old same-level structures
            elsif ( $Block->{Layer} > $LastLayer ) {
                undef $BlockStructure->{ $Block->{Layer} };
            }

            # add to structure
            unshift @{ $BlockStructure->{ $Block->{Layer} }->{ $Block->{Name} } }, $Block->{Data};
            $LastLayer = $Block->{Layer};
        }

        # assign result
        $TemplateString = $BlockStructure->{0}->{TemplateString}->[0];

    }

    # remove empty blocks and block preferences
    if ( $Param{BlockReplace} ) {
        my @TemplateBlocks = split '<!-- dtl:place_block:', $TemplateString;
        $TemplateString = shift @TemplateBlocks || '';
        for my $TemplateBlock (@TemplateBlocks) {
            $TemplateBlock =~ s{ \A .+? [ ] --> }{}xms;
            $TemplateString .= $TemplateBlock;
        }
    }

    # process template
    $TemplateString ||= '';
    my $Output = '';
    for my $Line ( split( /\n/, $TemplateString ) ) {

        #        # add missing new line (striped from split)
        #        $Line .= "\n";

        # variable & env & config replacement
        my $Regexp = 1;
        while ($Regexp) {
            $Regexp = $Line =~ s{
                \$((?:|Q|LQ|)Data|(?:|Q)Env|Config|Include){"(.+?)"}
            }
            {
                if ($1 eq 'Data' || $1 eq 'Env') {
                    if ( defined $GlobalRef->{$1}->{$2} ) {
                        $GlobalRef->{$1}->{$2};
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                elsif ($1 eq 'QEnv') {
                    my $Text = $2;
                    if ( !defined $Text || $Text =~ /^",\s*"(.+)$/ ) {
                        '';
                    }
                    elsif ($Text =~ /^(.+?)",\s*"(.+)$/) {
                        if ( defined $GlobalRef->{Env}->{$1} ) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Env}->{$1}, Max => $2);
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                    else {
                        if ( defined $GlobalRef->{Env}->{$Text} ) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Env}->{$Text});
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                }
                elsif ($1 eq 'QData') {
                    my $Text = $2;
                    if ( !defined $Text || $Text =~ /^",\s*"(.+)$/ ) {
                        '';
                    }
                    elsif ($Text =~ /^(.+?)",\s*"(.+)$/) {
                        if ( defined $GlobalRef->{Data}->{$1} ) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Data}->{$1}, Max => $2);
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                    else {
                        if ( defined $GlobalRef->{Data}->{$Text} ) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Data}->{$Text});
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                }
                # link encode
                elsif ($1 eq 'LQData') {
                    if ( defined $GlobalRef->{Data}->{$2} ) {
                        $Self->LinkEncode($GlobalRef->{Data}->{$2});
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                # replace with
                elsif ($1 eq 'Config') {
                    if ( defined $Self->{ConfigObject}->Get($2) ) {
                        $Self->{ConfigObject}->Get($2);
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                # include dtl files
                elsif ($1 eq 'Include') {
                    $Self->Output(
                        %Param,
                        Include => 1,
                        TemplateFile => $2,
                    );
                }
            }egx;
        }

        # add this line to output
        $Output .= $Line . "\n";
    }
    chomp $Output;

    $Self->{OutputCount} = 0;

    return $Output;
}

=item _BuildSelectionOptionRefCreate()

create the option hash

    my $OptionRef = $LayoutObject->_BuildSelectionOptionRefCreate(
        %Param,
    );

    my $OptionRef = {
        Sort         => 'numeric',
        PossibleNone => 0,
        Max          => 100,
    }

=cut

sub _BuildSelectionOptionRefCreate {
    my ( $Self, %Param ) = @_;

    # set SelectedID option
    my $OptionRef = {};
    if ( defined $Param{SelectedID} ) {
        if ( ref $Param{SelectedID} eq 'ARRAY' ) {
            for my $Key ( @{ $Param{SelectedID} } ) {
                $OptionRef->{SelectedID}->{$Key} = 1;
            }
        }
        else {
            $OptionRef->{SelectedID}->{ $Param{SelectedID} } = 1;
        }
    }

    # set SelectedValue option
    if ( defined $Param{SelectedValue} ) {
        if ( ref $Param{SelectedValue} eq 'ARRAY' ) {
            for my $Value ( @{ $Param{SelectedValue} } ) {
                $OptionRef->{SelectedValue}->{$Value} = 1;
            }
        }
        else {
            $OptionRef->{SelectedValue}->{ $Param{SelectedValue} } = 1;
        }
    }

    # set Sort option
    $OptionRef->{Sort} = 0;
    if ( $Param{Sort} ) {
        $OptionRef->{Sort} = $Param{Sort};
    }

    # look if a individual sort is available
    if ( $Param{SortIndividual} && ref $Param{SortIndividual} eq 'ARRAY' ) {
        $OptionRef->{SortIndividual} = $Param{SortIndividual};
    }

    # set SortReverse option
    $OptionRef->{SortReverse} = 0;
    if ( $Param{SortReverse} ) {
        $OptionRef->{SortReverse} = 1;
    }

    # set Translation option
    $OptionRef->{Translation} = 1;
    if ( defined $Param{Translation} && $Param{Translation} eq 0 ) {
        $OptionRef->{Translation} = 0;
    }

    # correcting selected value hash if translation is on
    if (
        $OptionRef->{Translation}
        && $OptionRef->{SelectedValue}
        && ref $OptionRef->{SelectedValue} eq 'HASH'
        )
    {
        my %SelectedValueNew;
        for my $OriginalKey ( sort keys %{ $OptionRef->{SelectedValue} } ) {
            my $TranslatedKey = $Self->{LanguageObject}->Get($OriginalKey);
            $SelectedValueNew{$TranslatedKey} = 1;
        }
        $OptionRef->{SelectedValue} = \%SelectedValueNew;
    }

    # set PossibleNone option
    $OptionRef->{PossibleNone} = 0;
    if ( $Param{PossibleNone} ) {
        $OptionRef->{PossibleNone} = 1;
    }

    # set TreeView option
    $OptionRef->{TreeView} = 0;
    if ( $Param{TreeView} ) {
        $OptionRef->{TreeView} = 1;
        $OptionRef->{Sort}     = 'TreeView';
    }

    # set DisabledBranch option
    if ( $Param{DisabledBranch} ) {
        if ( ref $Param{DisabledBranch} eq 'ARRAY' ) {
            for my $Branch ( @{ $Param{DisabledBranch} } ) {
                $OptionRef->{DisabledBranch}->{$Branch} = 1;
            }
        }
        else {
            $OptionRef->{DisabledBranch}->{ $Param{DisabledBranch} } = 1;
        }
    }

    # set Max option
    $OptionRef->{Max} = $Param{Max} || 100;

    # set HTMLQuote option
    $OptionRef->{HTMLQuote} = 1;
    if ( defined $Param{HTMLQuote} ) {
        $OptionRef->{HTMLQuote} = $Param{HTMLQuote};
    }

    return $OptionRef;
}

=item _BuildSelectionAttributeRefCreate()

create the attribute hash

    my $AttributeRef = $LayoutObject->_BuildSelectionAttributeRefCreate(
        %Param,
    );

    my $AttributeRef = {
        name     => 'TheName',
        multiple => undef,
        size     => 5,
    }

=cut

sub _BuildSelectionAttributeRefCreate {
    my ( $Self, %Param ) = @_;

    my $AttributeRef = {};

    # check params with key and value
    for (qw(Name ID Size Class OnChange OnClick AutoComplete)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = $Param{$_};
        }
    }

    # add id attriubut
    if ( !$AttributeRef->{id} ) {
        $AttributeRef->{id} = $AttributeRef->{name};
    }

    # check params with key and value that need to be HTML-Quoted
    for (qw(Title)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = $Self->Ascii2Html( Text => $Param{$_} );
        }
    }

    # check HTML params
    for (qw(Multiple Disabled)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = lc($_);
        }
    }

    return $AttributeRef;
}

=item _BuildSelectionDataRefCreate()

create the data hash

    my $DataRef = $LayoutObject->_BuildSelectionDataRefCreate(
        Data => $ArrayRef,              # use $HashRef, $ArrayRef or $ArrayHashRef
        AttributeRef => $AttributeRef,
        OptionRef => $OptionRef,
    );

    my $DataRef  = [
        {
            Key => 11,
            Value => 'Text',
        },
        {
            Key => 'abc',
            Value => '&nbsp;&nbsp;Text',
            Selected => 1,
        },
    ];

=cut

sub _BuildSelectionDataRefCreate {
    my ( $Self, %Param ) = @_;

    my $AttributeRef = $Param{AttributeRef};
    my $OptionRef    = $Param{OptionRef};
    my $DataRef      = [];

    my $Counter = 0;

    # for HashRef and ArrayRef only
    my %DisabledElements;

    # if HashRef was given
    if ( ref $Param{Data} eq 'HASH' ) {

        # get missing parents and mark them for disable later
        if ( $OptionRef->{Sort} eq 'TreeView' ) {
            my %List = reverse %{ $Param{Data} };

            # get each data value
            for my $Key ( sort keys %List ) {
                my $Parents = '';

                # try to split its parents (e.g. Queue or Service) GrandParent::Parent::Son
                my @Elements = split /::/, $Key;

                # get each element in the hierarchy
                for my $Element (@Elements) {

                    # add its own parents for the complete name
                    my $ElementLongName = $Parents . $Element;

                    # check if element exists in the original data or if it is already marked
                    if ( !$List{$ElementLongName} && !$DisabledElements{$ElementLongName} ) {

                        # mark element as disabled
                        $DisabledElements{$ElementLongName} = 1;

                        # add the element to the original data to be disabled later
                        $Param{Data}->{ $ElementLongName . '_Disabled' } = $ElementLongName;
                    }
                    $Parents .= $Element . '::';
                }
            }
        }

        # sort hash (before the translation)
        my @SortKeys;
        if ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {
            my %List = reverse %{ $Param{Data} };
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @SortKeys, $List{$Key};
                    delete $List{$Key};
                }
            }
            push @SortKeys, sort { $a cmp $b } ( values %List );
        }

        # translate value
        if ( $OptionRef->{Translation} ) {
            for my $Row ( sort keys %{ $Param{Data} } ) {
                $Param{Data}->{$Row} = $Self->{LanguageObject}->Get( $Param{Data}->{$Row} );
            }
        }

        # sort hash (after the translation)
        if ( $OptionRef->{Sort} eq 'NumericKey' ) {
            @SortKeys = sort { $a <=> $b } ( keys %{ $Param{Data} } );
        }
        elsif ( $OptionRef->{Sort} eq 'NumericValue' ) {
            @SortKeys
                = sort { $Param{Data}->{$a} <=> $Param{Data}->{$b} } ( keys %{ $Param{Data} } );
        }
        elsif ( $OptionRef->{Sort} eq 'AlphanumericKey' ) {
            @SortKeys = sort( keys %{ $Param{Data} } );
        }
        elsif ( $OptionRef->{Sort} eq 'TreeView' ) {

            # add suffix for correct sorting
            my %SortHash;
            for ( sort keys %{ $Param{Data} } ) {
                $SortHash{$_} = $Param{Data}->{$_} . '::';
            }
            @SortKeys = sort { $SortHash{$a} cmp $SortHash{$b} } ( keys %SortHash );
        }
        elsif ( $OptionRef->{Sort} eq 'IndividualKey' && $OptionRef->{SortIndividual} ) {
            my %List = %{ $Param{Data} };
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @SortKeys, $Key;
                    delete $List{$Key};
                }
            }
            push @SortKeys, sort { $List{$a} cmp $List{$b} } ( keys %List );
        }
        elsif ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {

            # already done before the translation
        }
        else {
            @SortKeys
                = sort { $Param{Data}->{$a} cmp $Param{Data}->{$b} } ( keys %{ $Param{Data} } );
            $OptionRef->{Sort} = 'AlphanumericValue';
        }

        # create DataRef
        for my $Row (@SortKeys) {
            $DataRef->[$Counter]->{Key}   = $Row;
            $DataRef->[$Counter]->{Value} = $Param{Data}->{$Row};
            $Counter++;
        }
    }

    # if ArrayHashRef was given
    elsif ( ref $Param{Data} eq 'ARRAY' && ref $Param{Data}->[0] eq 'HASH' ) {

        # create DataRef
        for my $Row ( @{ $Param{Data} } ) {
            if ( ref $Row eq 'HASH' && defined $Row->{Key} ) {
                $DataRef->[$Counter]->{Key}   = $Row->{Key};
                $DataRef->[$Counter]->{Value} = $Row->{Value};

                # translate value
                if ( $OptionRef->{Translation} ) {
                    $DataRef->[$Counter]->{Value}
                        = $Self->{LanguageObject}->Get( $DataRef->[$Counter]->{Value} );
                }

                # set Selected and Disabled options
                if ( $Row->{Selected} ) {
                    $DataRef->[$Counter]->{Selected} = 1;
                }
                elsif ( $Row->{Disabled} ) {
                    $DataRef->[$Counter]->{Disabled} = 1;
                }
                $Counter++;
            }
        }
    }

    # if ArrayRef was given
    elsif ( ref $Param{Data} eq 'ARRAY' ) {

        # get missing parents and mark them for disable later
        if ( $OptionRef->{Sort} eq 'TreeView' ) {
            my %List = map { $_ => 1 } @{ $Param{Data} };

            # get each data value
            for my $Key ( sort keys %List ) {
                my $Parents = '';

                # try to split its parents (e.g. Queue or Service) GrandParent::Parent::Son
                my @Elements = split /::/, $Key;

                # get each element in the hierarchy
                for my $Element (@Elements) {

                    # add its own parents for the complete name
                    my $ElementLongName = $Parents . $Element;

                    # check if element exists in the original data or if it is already marked
                    if ( !$List{$ElementLongName} && !$DisabledElements{$ElementLongName} ) {

                        # mark element as disabled
                        $DisabledElements{$ElementLongName} = 1;

                        # add the element to the original data to be disabled later
                        push @{ $Param{Data} }, $ElementLongName;
                    }
                    $Parents .= $Element . '::';
                }
            }
        }

        if ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {
            my %List = map { $_ => 1 } @{ $Param{Data} };
            $Param{Data} = [];
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @{ $Param{Data} }, $Key;
                    delete $List{$Key};
                }
            }
            push @{ $Param{Data} }, sort { $a cmp $b } ( keys %List );
        }

        my %ReverseHash;

        # translate value
        if ( $OptionRef->{Translation} ) {
            my @TranslateArray;
            for my $Row ( @{ $Param{Data} } ) {
                my $TranslateString = $Self->{LanguageObject}->Get($Row);
                push @TranslateArray, $TranslateString;
                $ReverseHash{$TranslateString} = $Row;
            }
            $Param{Data} = \@TranslateArray;
        }
        else {
            for my $Row ( @{ $Param{Data} } ) {
                $ReverseHash{$Row} = $Row;
            }
        }

        # sort array
        if ( $OptionRef->{Sort} eq 'AlphanumericKey' || $OptionRef->{Sort} eq 'AlphanumericValue' )
        {
            my @SortArray = sort( @{ $Param{Data} } );
            $Param{Data} = \@SortArray;
        }
        elsif ( $OptionRef->{Sort} eq 'NumericKey' || $OptionRef->{Sort} eq 'NumericValue' ) {
            my @SortArray = sort { $a <=> $b } ( @{ $Param{Data} } );
            $Param{Data} = \@SortArray;
        }
        elsif ( $OptionRef->{Sort} eq 'TreeView' ) {

            # sort array, add '::' in the comparison, for proper sort of Items with Items::SubItems
            my @SortArray = sort { $a . '::' cmp $b . '::' } @{ $Param{Data} };
            $Param{Data} = \@SortArray;
        }

        # create DataRef
        for my $Row ( @{ $Param{Data} } ) {
            $DataRef->[$Counter]->{Key}   = $ReverseHash{$Row};
            $DataRef->[$Counter]->{Value} = $Row;
            $Counter++;
        }
    }

    # check disabled items on ArrayRef or HashRef only
    if (
        ref $Param{Data} eq 'HASH'
        || ( ref $Param{Data} eq 'ARRAY' && ref $Param{Data}->[0] ne 'HASH' )
        )
    {
        for my $Row ( @{$DataRef} ) {
            if ( $DisabledElements{ $Row->{Value} } ) {
                $Row->{Key}      = '-';
                $Row->{Disabled} = 1;
            }
        }
    }

    # DisabledBranch option
    if ( $OptionRef->{DisabledBranch} ) {
        for my $Row ( @{$DataRef} ) {
            for my $Branch ( sort keys %{ $OptionRef->{DisabledBranch} } ) {
                if ( $Row->{Value} =~ /^(\Q$Branch\E)$/ || $Row->{Value} =~ /^(\Q$Branch\E)::/ ) {
                    $Row->{Disabled} = 1;
                }
            }
        }
    }

    # Max option
    # REMARK: Don't merge the Max handling with Ascii2Html function call of
    # the HTMLQuote handling. In this case you lose the max handling if you
    # deactivate HTMLQuote
    if ( $OptionRef->{Max} ) {
        for my $Row ( @{$DataRef} ) {

            # REMARK: This is the same solution as in Ascii2Html
            $Row->{Value} =~ s/^(.{$OptionRef->{Max}}).+?$/$1\[\.\.\]/gs;

            #$Row->{Value} = substr( $Row->{Value}, 0, $OptionRef->{Max} );
        }
    }

    # HTMLQuote option
    if ( $OptionRef->{HTMLQuote} ) {
        for my $Row ( @{$DataRef} ) {
            $Row->{Key}   = $Self->Ascii2Html( Text => $Row->{Key} );
            $Row->{Value} = $Self->Ascii2Html( Text => $Row->{Value} );
        }
    }

    # SortReverse option
    if ( $OptionRef->{SortReverse} ) {
        @{$DataRef} = reverse( @{$DataRef} );
    }

    # PossibleNone option
    if ( $OptionRef->{PossibleNone} ) {
        my %None;
        $None{Key}   = '';
        $None{Value} = '-';

        unshift( @{$DataRef}, \%None );
    }

    # SelectedID and SelectedValue option
    if ( defined $OptionRef->{SelectedID} || $OptionRef->{SelectedValue} ) {
        for my $Row ( @{$DataRef} ) {
            if (
                (
                    $OptionRef->{SelectedID}->{ $Row->{Key} }
                    || $OptionRef->{SelectedValue}->{ $Row->{Value} }
                )
                && !$DisabledElements{ $Row->{Value} }
                )
            {
                $Row->{Selected} = 1;
            }
        }
    }

    # TreeView option
    if ( $OptionRef->{TreeView} ) {

        ROW:
        for my $Row ( @{$DataRef} ) {

            next ROW if !$Row->{Value};

            my @Fragment = split '::', $Row->{Value};
            $Row->{Value} = pop @Fragment;

            my $Space = '&nbsp;&nbsp;' x scalar @Fragment;
            $Space ||= '';

            $Row->{Value} = $Space . $Row->{Value};
        }
    }

    return $DataRef;
}

=item _BuildSelectionOutput()

create the html string

    my $HTMLString = $LayoutObject->_BuildSelectionOutput(
        AttributeRef => $AttributeRef,
        DataRef      => $DataRef,
        TreeView     => 0, # optional, see BuildSelection()
    );

    my $AttributeRef = {
        name => 'TheName',
        multiple => undef,
        size => 5,
    }

    my $DataRef  = [
        {
            Key => 11,
            Value => 'Text',
            Disabled => 1,
        },
        {
            Key => 'abc',
            Value => '&nbsp;&nbsp;Text',
            Selected => 1,
        },
    ];

=cut

sub _BuildSelectionOutput {
    my ( $Self, %Param ) = @_;

    # start generation, if AttributeRef and DataRef was found
    my $String;
    if ( $Param{AttributeRef} && $Param{DataRef} ) {

        # generate <select> row
        $String = '<select';
        for my $Key ( sort keys %{ $Param{AttributeRef} } ) {
            if ( $Key && defined $Param{AttributeRef}->{$Key} ) {
                $String .= " $Key=\"$Param{AttributeRef}->{$Key}\"";
            }
            elsif ($Key) {
                $String .= " $Key";
            }
        }
        $String .= ">\n";

        # generate <option> rows
        for my $Row ( @{ $Param{DataRef} } ) {
            my $Key = '';
            if ( defined $Row->{Key} ) {
                $Key = $Row->{Key};
            }
            my $Value = '';
            if ( defined $Row->{Value} ) {
                $Value = $Row->{Value};
            }
            my $SelectedDisabled = '';
            if ( $Row->{Selected} ) {
                $SelectedDisabled = ' selected="selected"';
            }
            elsif ( $Row->{Disabled} ) {
                $SelectedDisabled = ' disabled="disabled"';
            }
            my $OptionTitle = '';
            if ( $Param{OptionTitle} ) {
                $OptionTitle = ' title="' . $Value . '"';
            }
            $String .= "  <option value=\"$Key\"$SelectedDisabled$OptionTitle>$Value</option>\n";
        }
        $String .= '</select>';

        if ($Param{TreeView}) {
            $String .= ' <a href="#" title="$Text{"Show Tree Selection"}" class="ShowTreeSelection">$Text{"Show Tree Selection"}</a>';
        }

    }
    return $String;
}

sub _DisableBannerCheck {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{ConfigObject}->Get('Secure::DisableBanner');
    return   if !$Param{OutputRef};

    # remove the version tag from the header
    ${ $Param{OutputRef} } =~ s{
                ^ X-Powered-By: .+? Open \s Ticket \s Request \s System \s \(http .+? \)$ \n
            }{}smx;

    return 1;
}

=item _RemoveScriptTags()

This function will remove the surrounding <script> tags of a
piece of JavaScript code, if they are present, and return the result.

    my $CodeContent = $LayoutObject->_RemoveScriptTags(Code => $SomeCode);

=cut

sub _RemoveScriptTags {
    my ( $Self, %Param ) = @_;

    my $Code = $Param{Code} || '';

    if ( $Code =~ m/<script/ ) {

        # cut out dtl block comments of already replaced dtl blocks
        $Code =~ s{
            ^
            <!--
            \/?
            \w+
            -->
            \r?\n
        }{}smxg;

        # cut out opening script tags
        $Code =~ s{
            <script[^>]+>
            (?:\s*<!--)?
            (?:\s*//\s*<!\[CDATA\[)?
        }
        {}smxg;

        # cut out closing script tags
        $Code =~ s{
            (?:-->\s*)?
            (?://\s*\]\]>\s*)?
            </script>
        }{}smxg;

    }
    return $Code;
}

#COMPAT: to 3.0.x and lower (can be removed later)
sub TransfromDateSelection {
    my $Self = shift;

    return $Self->TransformDateSelection(@_);
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
