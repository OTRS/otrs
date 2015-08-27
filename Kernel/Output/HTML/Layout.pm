# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout;

use strict;
use warnings;

use Storable;
use URI::Escape qw();

use Kernel::System::Time;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::AuthSession',
    'Kernel::System::Chat',
    'Kernel::System::Encode',
    'Kernel::System::HTMLUtils',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::OTRSBusiness',
    'Kernel::System::SystemMaintenance',
    'Kernel::System::Time',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::Layout - all generic html functions

=head1 SYNOPSIS

All generic html functions. E. g. to get options fields, template processing, ...

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a new object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::Output::HTML::Layout' => {
            Lang    => 'de',
        },
    );
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

From the web installer, a special Option C<InstallerOnly> is passed
to indicate that a database connection is not yet available.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::Output::HTML::Layout' => {
            InstallerOnly => 1,
        },
    );
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    # reset block data
    delete $Self->{BlockData};

    # empty action if not defined
    $Self->{Action} = '' if !defined $Self->{Action};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get/set some common params
    if ( !$Self->{UserTheme} ) {
        $Self->{UserTheme} = $ConfigObject->Get('DefaultTheme');
    }

    # We'll keep one default TimeObject and one for the user's time zone (if needed)
    $Self->{TimeObject} = $Kernel::OM->Get('Kernel::System::Time');

    if ( $ConfigObject->Get('TimeZoneUser') && $Self->{UserTimeZone} ) {
        $Self->{UserTimeObject} = Kernel::System::Time->new( %{$Self} );
    }
    else {
        $Self->{UserTimeObject} = $Self->{TimeObject};
        $Self->{UserTimeZone}   = '';
    }

    # Determine the language to use based on the browser setting, if there
    #   is none yet.
    if ( !$Self->{UserLanguage} ) {
        my @BrowserLanguages = split /\s*,\s*/, $Self->{Lang} || $ENV{HTTP_ACCEPT_LANGUAGE} || '';
        my %Data = %{ $ConfigObject->Get('DefaultUsedLanguages') };
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
            if ( !$Self->{UserLanguage} ) {
                for my $Language ( reverse sort keys %Data ) {

                    # If Browser requests 'vi', also offer 'vi_VI' even though we don't have 'vi'
                    if ( $Language =~ m/^$BrowserLang/smxi ) {
                        $Self->{UserLanguage} = $Language;
                        last LANGUAGE;
                    }
                }
            }
        }
        $Self->{UserLanguage} ||= $ConfigObject->Get('DefaultLanguage') || 'en';
    }

    # create language object
    if ( !$Self->{LanguageObject} ) {
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Language' => {
                UserTimeZone => $Self->{UserTimeZone},
                UserLanguage => $Self->{UserLanguage},
                Action       => $Self->{Action},
            },
        );
        $Self->{LanguageObject} = $Kernel::OM->Get('Kernel::Language');
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

    # check Frontend::Output::FilterElementPost
    $Self->{FilterElementPost} = {};

    my %FilterElementPost = %{ $ConfigObject->Get('Frontend::Output::FilterElementPost') // {} };

    FILTER:
    for my $Filter ( sort keys %FilterElementPost ) {

        # extract filter config
        my $FilterConfig = $FilterElementPost{$Filter};

        next FILTER if !$FilterConfig || ref $FilterConfig ne 'HASH';

        # extract template list
        my %TemplateList = %{ $FilterConfig->{Templates} || {} };

        if ( !%TemplateList || $TemplateList{ALL} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => <<EOF,
$FilterConfig->{Module} will be ignored because it wants to operate on all templates or does not specify a template list.
EOF
            );

            next FILTER;
        }

        $Self->{FilterElementPost}->{$Filter} = $FilterElementPost{$Filter};
    }

    # check Frontend::Output::FilterContent
    $Self->{FilterContent} = $ConfigObject->Get('Frontend::Output::FilterContent');

    # check Frontend::Output::FilterText
    $Self->{FilterText} = $ConfigObject->Get('Frontend::Output::FilterText');

    # check browser
    $Self->{Browser}        = 'Unknown';
    $Self->{BrowserVersion} = 0;
    $Self->{Platform}       = '';
    $Self->{IsMobile}       = 0;

    $Self->{BrowserJavaScriptSupport} = 1;
    $Self->{BrowserRichText}          = 1;

    my $HttpUserAgent = ( defined $ENV{HTTP_USER_AGENT} ? lc $ENV{HTTP_USER_AGENT} : '' );

    if ( !$HttpUserAgent ) {
        $Self->{Browser} = 'Unknown - no $ENV{"HTTP_USER_AGENT"}';
    }
    elsif ($HttpUserAgent) {

        # check, if we are on a mobile platform.
        # tablets are handled like desktops
        # only phones are "mobile"
        if ( $HttpUserAgent =~ /mobile/ ) {
            $Self->{IsMobile} = 1;
        }

        # android
        if ( $HttpUserAgent =~ /android/ ) {
            $Self->{Platform} = 'Android';
        }

        # edge / spartan
        if ( $HttpUserAgent =~ /edge/ ) {
            $Self->{Browser} = 'Edge';
        }

        # msie
        elsif (
            $HttpUserAgent =~ /msie\s([0-9.]+)/
            || $HttpUserAgent =~ /internet\sexplorer\/([0-9.]+)/
            )
        {
            $Self->{Browser} = 'MSIE';

            if ( $1 =~ /(\d+)\.(\d+)/ ) {
                $Self->{BrowserMajorVersion} = $1;
                $Self->{BrowserMinorVersion} = $2;
            }

            # older windows mobile phones (until IE9), that still have 'MSIE' in the user agent string
            if ( $Self->{IsMobile} ) {
                $Self->{Platform} = 'Windows Phone';
            }
        }

        # mobile ie
        elsif ( $HttpUserAgent =~ /iemobile/ ) {
            $Self->{Browser}  = 'MSIE';
            $Self->{Platform} = 'Windows Phone';
        }

        # mobile ie (second try)
        elsif ( $HttpUserAgent =~ /trident/ ) {
            $Self->{Browser} = 'MSIE';

            if ( $HttpUserAgent =~ /rv:([0-9])+\.([0-9])+/ ) {
                $Self->{BrowserMajorVersion} = $2;
                $Self->{BrowserMinorVersion} = $3;
            }
        }

        # iOS
        elsif ( $HttpUserAgent =~ /(ipad|iphone|ipod)/ ) {
            $Self->{Platform} = 'iOS';
            $Self->{Browser}  = 'Safari';

            if ( $HttpUserAgent =~ /(ipad|iphone|ipod);.*cpu.*os ([0-9]+)_/ ) {
                $Self->{BrowserVersion} = $2;
            }

            if ( $HttpUserAgent =~ /crios/ ) {
                $Self->{Browser} = 'Chrome';
            }

            # RichText is supported in iOS6+.
            if ( $Self->{BrowserVersion} >= 6 ) {
                $Self->{BrowserRichText} = 1;
            }
            else {
                $Self->{BrowserRichText} = 0;
            }
        }

        # safari
        elsif ( $HttpUserAgent =~ /safari/ ) {

            # chrome
            if ( $HttpUserAgent =~ /chrome/ ) {
                $Self->{Browser} = 'Chrome';
            }
            else {
                $Self->{Browser} = 'Safari';
            }
        }

        # konqueror
        elsif ( $HttpUserAgent =~ /konqueror/ ) {
            $Self->{Browser} = 'Konqueror';

            # on konquerer disable rich text editor
            $Self->{BrowserRichText} = 0;
        }

        # firefox
        elsif ( $HttpUserAgent =~ /firefox/ ) {
            $Self->{Browser} = 'Firefox';
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

    # check mobile devices to disable richtext support
    if (
        $Self->{IsMobile}
        && $Self->{Platform} ne 'iOS'
        && $Self->{Platform} ne 'Android'
        && $Self->{Platform} ne 'Windows Phone'
        )
    {
        $Self->{BrowserRichText} = 0;
    }

    # check if rich text can be active
    if ( !$Self->{BrowserJavaScriptSupport} || !$Self->{BrowserRichText} ) {
        $ConfigObject->Set(
            Key   => 'Frontend::RichText',
            Value => 0,
        );
    }

    # check if rich text is active
    if ( !$ConfigObject->Get('Frontend::RichText') ) {
        $Self->{BrowserRichText} = 0;
    }

    # check if spell check should be active
    if ( $Self->{BrowserJavaScriptSupport} && $ConfigObject->Get('SpellChecker') ) {
        if ( $ConfigObject->Get('Frontend::RichText') ) {
            $Self->{BrowserSpellCheckerInline} = 1;
        }
        else {
            $Self->{BrowserSpellChecker} = 1;
        }
    }

    # load theme
    my $Theme = $Self->{UserTheme} || $ConfigObject->Get('DefaultTheme') || 'Standard';

    # force a theme based on host name
    my $DefaultThemeHostBased = $ConfigObject->Get('DefaultTheme::HostBased');
    if ( $DefaultThemeHostBased && $ENV{HTTP_HOST} ) {

        THEME:
        for my $RegExp ( sort keys %{$DefaultThemeHostBased} ) {

            # do not use empty regexp or theme directories
            next THEME if !$RegExp;
            next THEME if $RegExp eq '';
            next THEME if !$DefaultThemeHostBased->{$RegExp};

            # check if regexp is matching
            if ( $ENV{HTTP_HOST} =~ /$RegExp/i ) {
                $Theme = $DefaultThemeHostBased->{$RegExp};
            }
        }
    }

    # locate template files
    $Self->{TemplateDir}         = $ConfigObject->Get('TemplateDir') . '/HTML/Templates/' . $Theme;
    $Self->{StandardTemplateDir} = $ConfigObject->Get('TemplateDir') . '/HTML/Templates/' . 'Standard';

    # Check if 'Standard' fallback exists
    if ( !-e $Self->{StandardTemplateDir} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "No existing template directory found ('$Self->{TemplateDir}')! Check your Home in Kernel/Config.pm",
        );
        $Self->FatalDie();
    }

    if ( !-e $Self->{TemplateDir} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "No existing template directory found ('$Self->{TemplateDir}')!.
                Default theme used instead.",
        );

        # Set TemplateDir to 'Standard' as a fallback.
        $Theme = 'Standard';
        $Self->{TemplateDir} = $Self->{StandardTemplateDir};
    }

    $Self->{CustomTemplateDir}         = $ConfigObject->Get('CustomTemplateDir') . '/HTML/Templates/' . $Theme;
    $Self->{CustomStandardTemplateDir} = $ConfigObject->Get('CustomTemplateDir') . '/HTML/Templates/' . 'Standard';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # load sub layout files
    my $NewDir = $ConfigObject->Get('TemplateDir') . '/HTML/Layout';
    if ( -e $NewDir ) {
        my @NewFiles = $MainObject->DirectoryRead(
            Directory => $NewDir,
            Filter    => '*.pm',
        );
        for my $NewFile (@NewFiles) {
            if ( $NewFile !~ /Layout.pm$/ ) {
                $NewFile =~ s{\A.*\/(.+?).pm\z}{$1}xms;
                my $NewClassName = "Kernel::Output::HTML::Layout::$NewFile";
                if ( !$MainObject->RequireBaseClass($NewClassName) ) {
                    $Self->FatalError();
                }
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );
        return;
    }
    push @{ $Self->{BlockData} },
        {
        Name => $Param{Name},
        Data => $Param{Data},
        };
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
    return if !defined $Param{Data};

    # get JSON encoded data
    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
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

During login action, C<Login => 1> should be passed to Redirect(),
which indicates that if the browser has cookie support, it is OK
for the session cookie to be not yet set.

=cut

sub Redirect {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # add cookies if exists
    my $Cookies = '';
    if ( $Self->{SetCookies} && $ConfigObject->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Cookies .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # create & return output
    if ( $Param{ExtURL} ) {

        # external redirect
        $Param{Redirect} = $Param{ExtURL};
        return $Cookies
            . $Self->Output(
            TemplateFile => 'Redirect',
            Data         => \%Param
            );
    }

    # set baselink
    $Param{Redirect} = $Self->{Baselink};

    if ( $Param{OP} ) {

        # Filter out hazardous characters
        if ( $Param{OP} =~ s{\x00}{}smxg ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a null bytes (\x00) character in redirect!',
            );
        }

        if ( $Param{OP} =~ s{\r}{}smxg ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a carriage return character in redirect!',
            );
        }

        if ( $Param{OP} =~ s{\n}{}smxg ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Someone tries to use a newline character in redirect!',
            );
        }

        # internal redirect
        $Param{OP} =~ s/^.*\?(.+?)$/$1/;
        $Param{Redirect} .= $Param{OP};
    }

    # check if IIS 6 is used, add absolute url for IIS workaround
    # see also:
    #  o http://bugs.otrs.org/show_bug.cgi?id=2230
    #  o http://bugs.otrs.org/show_bug.cgi?id=9835
    #  o http://support.microsoft.com/default.aspx?scid=kb;en-us;221154
    if ( $ENV{SERVER_SOFTWARE} =~ /^microsoft\-iis\/6/i ) {
        my $Host = $ENV{HTTP_HOST} || $ConfigObject->Get('FQDN');
        my $HttpType = $ConfigObject->Get('HttpType');
        $Param{Redirect} = $HttpType . '://' . $Host . $Param{Redirect};
    }
    my $Output = $Cookies
        . $Self->Output(
        TemplateFile => 'Redirect',
        Data         => \%Param
        );

    # add session id to redirect if no cookie is enabled
    if ( !$Self->{SessionIDCookie} && !( $Self->{BrowserHasCookie} && $Param{Login} ) ) {

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

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Output = '';
    if ( $ConfigObject->Get('SessionUseCookie') ) {

        # always set a cookie, so that at the time the user submits
        # the password, we know already if the browser supports cookies.
        # ( the session cookie isn't available at that time ).
        my $CookieSecureAttribute = 0;
        if ( $ConfigObject->Get('HttpType') eq 'https' ) {

            # Restrict Cookie to HTTPS if it is used.
            $CookieSecureAttribute = 1;
        }
        $Self->{SetCookies}->{OTRSBrowserHasCookie} = $Kernel::OM->Get('Kernel::System::Web::Request')->SetCookie(
            Key      => 'OTRSBrowserHasCookie',
            Value    => 1,
            Expires  => '1y',
            Path     => $ConfigObject->Get('ScriptAlias'),
            Secure   => $CookieSecureAttribute,
            HttpOnly => 1,
        );
    }

    # add cookies if exists
    if ( $Self->{SetCookies} && $ConfigObject->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # get message of the day
    if ( $ConfigObject->Get('ShowMotd') ) {
        $Param{Motd} = $Self->Output(
            TemplateFile => 'Motd',
            Data         => \%Param
        );
    }

    # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateAgentCSSCalls();
    $Self->LoaderCreateAgentJSCalls();

    # Add header logo, if configured
    if ( defined $ConfigObject->Get('AgentLogo') ) {
        my %AgentLogo = %{ $ConfigObject->Get('AgentLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %AgentLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $AgentLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $ConfigObject->Get('Frontend::WebPath');
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
    if ( defined $ConfigObject->Get('AgentLoginLogo') ) {
        my %AgentLoginLogo = %{ $ConfigObject->Get('AgentLoginLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %AgentLoginLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = $ConfigObject->Get('Frontend::WebPath');
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

    # get system maintenance object
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    # check if system maintenance is active
    if ($ActiveMaintenance) {
        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => 1,
        );

        if ( $SystemMaintenanceData->{ShowLoginMessage} ) {

            my $LoginMessage =
                $SystemMaintenanceData->{LoginMessage}
                || $ConfigObject->Get('SystemMaintenance::IsActiveDefaultLoginMessage')
                || "System maintenance is active, not possible to perform a login!";

            $Self->Block(
                Name => 'SystemMaintenance',
                Data => {
                    LoginMessage => $LoginMessage,
                },
            );
        }
    }

    # show prelogin block, if in prelogin mode (e.g. SSO login)
    if ( defined $Param{'Mode'} && $Param{'Mode'} eq 'PreLogin' ) {
        $Self->Block(
            Name => 'PreLogin',
            Data => \%Param,
        );
    }

    # if not in PreLogin mode, show normal login form
    else {

        $Self->Block(
            Name => 'LoginBox',
            Data => \%Param,
        );

        # show 2 factor password input if we have at least one backend enabled
        COUNT:
        for my $Count ( '', 1 .. 10 ) {
            next COUNT if !$ConfigObject->Get("AuthTwoFactorModule$Count");

            # if no empty shared secrets are allowed, input is mandatory
            my %MandatoryOptions;
            if ( !$ConfigObject->Get("AuthTwoFactorModule${Count}::AllowEmptySecret") ) {
                %MandatoryOptions = (
                    MandatoryClass   => 'Mandatory',
                    ValidateRequired => 'Validate_Required',
                );
            }

            $Self->Block(
                Name => 'AuthTwoFactor',
                Data => {
                    %Param,
                    %MandatoryOptions,
                },
            );

            if (%MandatoryOptions) {
                $Self->Block(
                    Name => 'AuthTwoFactorMandatory',
                    Data => \%Param,
                );
            }

            last COUNT;
        }

        # get lost password
        if (
            $ConfigObject->Get('LostPassword')
            && $ConfigObject->Get('AuthModule') eq 'Kernel::System::Auth::DB'
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
    }

    # create & return output
    $Output .= $Self->Output(
        TemplateFile => 'Login',
        Data         => \%Param
    );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub ChallengeTokenCheck {
    my ( $Self, %Param ) = @_;

    # return if feature is disabled
    return 1 if !$Kernel::OM->Get('Kernel::Config')->Get('SessionCSRFProtection');

    # get challenge token and check it
    my $ChallengeToken = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ChallengeToken' ) || '';

    # check regular ChallengeToken
    return 1 if $ChallengeToken eq $Self->{UserChallengeToken};

    # check ChallengeToken of all own sessions
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my @Sessions      = $SessionObject->GetAllSessionIDs();

    SESSION:
    for my $SessionID (@Sessions) {
        my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );
        next SESSION if !$Data{UserID};
        next SESSION if $Data{UserID} ne $Self->{UserID};
        next SESSION if !$Data{UserChallengeToken};

        # check ChallengeToken
        return 1 if $ChallengeToken eq $Data{UserChallengeToken};
    }

    # no valid token found
    if ( $Param{Type} && lc $Param{Type} eq 'customer' ) {
        $Self->CustomerFatalError(
            Message => 'Invalid Challenge Token!',
        );
    }
    else {
        $Self->FatalError(
            Message => 'Invalid Challenge Token!',
        );
    }

    return;
}

sub FatalError {
    my ( $Self, %Param ) = @_;

    # Prevent endless recursion in case of problems with Template engine.
    return if ( $Self->{InFatalError}++ );

    if ( $Param{Message} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }
    my $Output = $Self->Header(
        Area  => 'Frontend',
        Title => 'Fatal Error'
    );
    $Output .= $Self->Error(%Param);
    $Output .= $Self->Footer();
    $Self->Print( Output => \$Output );
    exit;
}

sub SecureMode {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->Header(
        Area  => 'Frontend',
        Title => 'Secure Mode'
    );
    $Output .= $Self->Output(
        TemplateFile => 'AdminSecureMode',
        Data         => \%Param
    );
    $Output .= $Self->Footer();
    return $Output;
}

sub FatalDie {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }

    # get backend error messages
    for (qw(Message Traceback)) {
        my $Backend = 'Backend' . $_;
        $Param{$Backend} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
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
        $Param{$Backend} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'Error',
            What => $_
        ) || '';
    }
    if ( !$Param{BackendMessage} && !$Param{BackendTraceback} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Param{Message} || '?',
        );
        for (qw(Message Traceback)) {
            my $Backend = 'Backend' . $_;
            $Param{$Backend} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
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
    return $Self->Output(
        TemplateFile => 'Error',
        Data         => \%Param
    );
}

sub Warning {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    $Param{BackendMessage} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'Notice',
        What => 'Message',
        )
        || $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'Error',
        What => 'Message',
        ) || '';

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output(
        TemplateFile => 'Warning',
        Data         => \%Param
    );
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
        Data      => 'Template content',
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
        $Param{BackendMessage} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'Notice',
            What => 'Message',
            )
            || $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
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
    elsif ( $Param{Priority} && $Param{Priority} eq 'Success' ) {
        $BoxClass = 'Success';
    }
    elsif ( $Param{Priority} && $Param{Priority} eq 'Info' ) {
        $BoxClass = 'Info';
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
            Data => {
                LinkStop => '</a>',
            },
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

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # do not show preferences link if the preferences module is disabled
    my $Modules = $ConfigObject->Get('Frontend::Module');
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
    elsif ( $ConfigObject->Get('Frontend::DebugMode') ) {
        $Self->Block(
            Name => 'DebugRTLButton',
        );
    }

    # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateAgentCSSCalls();

    my %AgentLogo;

    # check if we need to display a custom logo for the selected skin
    my $AgentLogoCustom = $ConfigObject->Get('AgentLogoCustom');
    if (
        $Self->{SkinSelected}
        && $AgentLogoCustom
        && IsHashRefWithData($AgentLogoCustom)
        && $AgentLogoCustom->{ $Self->{SkinSelected} }
        )
    {
        %AgentLogo = %{ $AgentLogoCustom->{ $Self->{SkinSelected} } };
    }

    # Otherwise show default header logo, if configured
    elsif ( defined $ConfigObject->Get('AgentLogo') ) {
        %AgentLogo = %{ $ConfigObject->Get('AgentLogo') };
    }

    if ( %AgentLogo && keys %AgentLogo ) {

        my %Data;
        for my $CSSStatement ( sort keys %AgentLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $AgentLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $ConfigObject->Get('Frontend::WebPath');
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
    if ( $Self->{SetCookies} && $ConfigObject->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    my $File = $Param{Filename} || $Self->{Action} || 'unknown';

    # set file name for "save page as"
    $Param{ContentDisposition} = "filename=\"$File.html\"";

    # area and title
    if ( !$Param{Area} ) {
        $Param{Area} = (
            defined $Self->{Action}
            ? $ConfigObject->Get('Frontend::Module')->{ $Self->{Action} }->{NavBarName}
            : ''
        );
    }
    if ( !$Param{Title} ) {
        $Param{Title} = $ConfigObject->Get('Frontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    for my $Word (qw(Value Title Area)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= $Self->{LanguageObject}->Translate( $Param{$Word} ) . ' - ';
        }
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run header meta modules
    my $HeaderMetaModule = $ConfigObject->Get('Frontend::HeaderMetaModule');
    if ( ref $HeaderMetaModule eq 'HASH' ) {
        my %Jobs = %{$HeaderMetaModule};

        MODULE:
        for my $Job ( sort keys %Jobs ) {

            # load and run module
            next MODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next MODULE if !$Object;
            $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run tool bar item modules
    if ( $Self->{UserID} && $Self->{UserType} eq 'User' ) {
        my $ToolBarModule = $ConfigObject->Get('Frontend::ToolBarModule');
        if ( $Param{ShowToolbarItems} && ref $ToolBarModule eq 'HASH' ) {

            $Self->Block(
                Name => 'ToolBar',
                Data => \%Param,
            );

            my %Modules;
            my %Jobs = %{$ToolBarModule};

            MODULE:
            for my $Job ( sort keys %Jobs ) {

                # load and run module
                next MODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},    # UserID etc.
                );
                next MODULE if !$Object;
                %Modules = ( $Object->Run( %Param, Config => $Jobs{$Job} ), %Modules );
            }

            # show tool bar items
            MODULE:
            for my $Key ( sort keys %Modules ) {
                next MODULE if !%{ $Modules{$Key} };
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
            && $ConfigObject->Get('Frontend::Module')->{Logout}
            )
        {
            $Self->Block(
                Name => 'Logout',
                Data => \%Param,
            );
        }
    }

    # create & return output
    $Output .= $Self->Output(
        TemplateFile => "Header$Type",
        Data         => \%Param
    );

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
            Data => $VacationDays,
        );

        my $TextDirection = $Self->{LanguageObject}->{TextDirection} || '';

        $Self->Block(
            Name => 'DatepickerData',
            Data => {
                VacationDays  => $VacationDaysJSON,
                IsRTLLanguage => ( $TextDirection eq 'rtl' ) ? 1 : 0,
            },
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # NewTicketInNewWindow
    if ( $ConfigObject->Get('NewTicketInNewWindow::Enabled') ) {
        $Self->Block(
            Name => 'NewTicketInNewWindow',
        );
    }

    # AutoComplete-Config
    my $AutocompleteConfig = $ConfigObject->Get('AutoComplete::Agent');

    for my $ConfigElement ( sort keys %{$AutocompleteConfig} ) {
        $AutocompleteConfig->{$ConfigElement}->{ButtonText}
            = $Self->{LanguageObject}->Translate( $AutocompleteConfig->{$ConfigElement}->{ButtonText} );
    }

    my $AutocompleteConfigJSON = $Self->JSONEncode(
        Data => $AutocompleteConfig,
    );

    $Self->Block(
        Name => 'AutoCompleteConfig',
        Data => {
            AutocompleteConfig => $AutocompleteConfigJSON,
        },
    );

    # Search frontend (JavaScript)
    my $SearchFrontendConfig = $ConfigObject->Get('Frontend::Search::JavaScript');

    # get target javascript function
    my $JSCall = '';

    if ( $SearchFrontendConfig && $Self->{Action} ) {
        for my $Group ( sort keys %{$SearchFrontendConfig} ) {
            REGEXP:
            for my $RegExp ( sort keys %{ $SearchFrontendConfig->{$Group} } ) {
                if ( $Self->{Action} =~ /$RegExp/ ) {
                    $JSCall = $SearchFrontendConfig->{$Group}->{$RegExp};
                    last REGEXP;
                }
            }
        }
    }

    $Self->Block(
        Name => 'SearchFrontendConfig',
        Data => {
            SearchFrontendConfig => $JSCall,
        },
    );

    # Banner
    if ( !$ConfigObject->Get('Secure::DisableBanner') ) {
        $Self->Block(
            Name => 'Banner',
        );
    }

    # Don't check for business package if the database was not yet configured (in the installer)
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        $Param{OTRSBusinessIsInstalled} = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
    }

    # create & return output
    return $Self->Output(
        TemplateFile => "Footer$Type",
        Data         => \%Param
    );
}

sub Print {
    my ( $Self, %Param ) = @_;

    # run output content filters
    if ( $Self->{FilterContent} && ref $Self->{FilterContent} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterContent} };

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

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

                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            next FILTER if !$MainObject->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data         => $Param{Output},
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    # There seems to be a bug in FastCGI that it cannot handle unicode output properly.
    #   Work around this by converting to an utf8 byte stream instead.
    #   See also http://bugs.otrs.org/show_bug.cgi?id=6284 and
    #   http://bugs.otrs.org/show_bug.cgi?id=9802.
    if ( $INC{'CGI/Fast.pm'} || $ENV{FCGI_ROLE} || $ENV{FCGI_SOCKET_PATH} ) {    # are we on FCGI?
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( $Param{Output} );
        binmode STDOUT, ':bytes';
    }

    print ${ $Param{Output} };

    return 1;
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

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

                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            $Self->FatalDie() if !$MainObject->Require( $FilterConfig->{Module} );

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

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

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

                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            $Self->FatalDie() if !$MainObject->Require( $FilterConfig->{Module} );

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
        $Text = $Filter->{Object}->Pre(
            Filter => $Filter->{Filter},
            Data   => $Text
        );
    }
    for my $Filter (@Filters) {
        $Text = $Filter->{Object}->Post(
            Filter => $Filter->{Filter},
            Data   => $Text
        );
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

    return $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
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
    if ( $Kernel::OM->Get('Kernel::Config')->Get('TimeShowCompleteDescription') ) {
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
        $AgeStrg .= $Self->{LanguageObject}->Translate($HourDsc);
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $Age <= 3600 || int( ( $Age / 60 ) % 60 ) ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Translate($MinuteDsc);
    }
    return $AgeStrg;
}

sub CustomerAge {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Age = defined( $Param{Age} ) ? $Param{Age} : return;
    my $Space     = $Param{Space} || '<br/>';
    my $AgeStrg   = '';
    my $DayDsc    = 'd';
    my $HourDsc   = 'h';
    my $MinuteDsc = 'm';
    if ( $ConfigObject->Get('TimeShowCompleteDescription') ) {
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
        $AgeStrg .= $Self->{LanguageObject}->Translate($DayDsc);
        $AgeStrg .= $Space;
    }

    # get hours
    if ( $Age >= 3600 ) {
        $AgeStrg .= int( ( $Age / 3600 ) % 24 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Translate($HourDsc);
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $ConfigObject->Get('TimeShowAlwaysLong') || $Age < 86400 ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        $AgeStrg .= $Self->{LanguageObject}->Translate($MinuteDsc);
    }
    return $AgeStrg;
}

=item BuildSelection()

build a HTML option element based on given data

    my $HTML = $LayoutObject->BuildSelection(
        Data            => $ArrayRef,             # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
        Name            => 'TheName',             # name of element
        ID              => 'HTMLID',              # (optional) the HTML ID for this element, if not provided, the name will be used as ID as well
        Multiple        => 0,                     # (optional) default 0 (0|1)
        Size            => 1,                     # (optional) default 1 element size
        Class           => 'class',               # (optional) a css class, include 'Modernize' to activate InputFields
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

        Filters => {                         # (optional) filter data, used by InputFields
            LastOwners => {                  # filter id
                Name   => 'Last owners',     # name of the filter
                Values => {                  # filtered data structure
                    Key1 => 'Value1',
                    Key2 => 'Value2',
                    Key3 => 'Value3',
                },
                Active => 1,                 # (optional) default 0 (0|1) make this filter immediately active
            },
            InvolvedAgents => {
                Name   => 'Involved in this ticket',
                Values => \%HashWithData,
            },
        },
        ExpandFilters  => 1,                 # (optional) default 0 (0|1) expand filters list by default
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # The parameters 'Ajax' and 'OnChange' are exclusive
    if ( $Param{Ajax} && $Param{OnChange} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The parameters 'OnChange' and 'Ajax' exclude each other!"
        );
        return;
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need Depend Param Ajax option!',
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # create FiltersRef
    my @Filters;
    my $FilterActive;
    if ( $Param{Filters} ) {
        my $Index = 1;
        for my $Filter ( sort keys %{ $Param{Filters} } ) {
            if (
                $Param{Filters}->{$Filter}->{Name}
                && $Param{Filters}->{$Filter}->{Values}
                )
            {
                my $FilterData = $Self->_BuildSelectionDataRefCreate(
                    Data         => $Param{Filters}->{$Filter}->{Values},
                    AttributeRef => $AttributeRef,
                    OptionRef    => $OptionRef,
                );
                push @Filters, {
                    Name => $Param{Filters}->{$Filter}->{Name},
                    Data => $FilterData,
                };
                if ( $Param{Filters}->{$Filter}->{Active} ) {
                    $FilterActive = $Index;
                }
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Each Filter must provide Name and Values!',
                );
                $Self->FatalError();
            }
            $Index++;
        }
        @Filters = sort { $a->{Name} cmp $b->{Name} } @Filters;
    }

    # generate output
    my $String = $Self->_BuildSelectionOutput(
        AttributeRef  => $AttributeRef,
        DataRef       => $DataRef,
        OptionTitle   => $Param{OptionTitle},
        TreeView      => $Param{TreeView},
        FiltersRef    => \@Filters,
        FilterActive  => $FilterActive,
        ExpandFilters => $Param{ExpandFilters},
    );
    return $String;
}

sub NoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';

    my $TranslatableMessage = $Self->{LanguageObject}->Translate(
        "We are sorry, you do not have permissions anymore to access this ticket in its current state."
    );
    $TranslatableMessage .= '<br/>';
    $TranslatableMessage
        .= $Self->{LanguageObject}->Translate(" You can take one of the next actions:");
    $Param{Message} = $TranslatableMessage if ( !$Param{Message} );

    # get config option for possible next actions
    my $PossibleNextActions = $Kernel::OM->Get('Kernel::Config')->Get('PossibleNextActions');

    POSSIBLE:
    if ( IsHashRefWithData($PossibleNextActions) ) {
        $Self->Block(
            Name => 'PossibleNextActionContainer',
        );
        for my $Key ( sort keys %{$PossibleNextActions} ) {
            next POSSIBLE if !$Key;
            next POSSIBLE if !$PossibleNextActions->{$Key};

            $Self->Block(
                Name => 'PossibleNextActionRow',
                Data => {
                    Link        => $PossibleNextActions->{$Key},
                    Description => $Key,
                },
            );
        }
    }

    # create output
    my $Output;
    $Output = $Self->Header( Title => 'Insufficient Rights' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output(
        TemplateFile => 'NoPermission',
        Data         => \%Param
    );
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{ $Param{Action} };
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

sub CheckMimeType {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    if ( !$Param{Action} ) {
        $Param{Action} = '[% Env("Action") %]';
    }

    # check if it is a text/plain email
    if ( $Param{MimeType} && $Param{MimeType} !~ /text\/plain/i ) {
        $Output = '<p><i class="small">'
            . $Self->{LanguageObject}->Translate("This is a")
            . " $Param{MimeType} "
            . $Self->{LanguageObject}->Translate("email")
            . ', <a href="'
            . $Self->{Baselink}
            . "Action=$Param{Action};TicketID="
            . "$Param{TicketID};ArticleID=$Param{ArticleID};Subaction=ShowHTMLeMail\" "
            . 'target="HTMLeMail">'
            . $Self->{LanguageObject}->Translate("click here")
            . '</a> '
            . $Self->{LanguageObject}->Translate("to open it in a new window.")
            . '</i></p>';
    }

    # just to be compat
    elsif ( $Param{Body} =~ /^<.DOCTYPE\s+html|^<HTML>/i ) {
        $Output = '<p><i class="small">'
            . $Self->{LanguageObject}->Translate("This is a")
            . " $Param{MimeType} "
            . $Self->{LanguageObject}->Translate("email")
            . ', <a href="'
            . $Self->{Baselink}
            . 'Action=$Param{Action};TicketID='
            . "$Param{TicketID};ArticleID=$Param{ArticleID};Subaction=ShowHTMLeMail\" "
            . 'target="HTMLeMail">'
            . $Self->{LanguageObject}->Translate("click here")
            . '</a> '
            . $Self->{LanguageObject}->Translate("to open it in a new window.")
            . '</i></p>';
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Output .= $Kernel::OM->Get('Kernel::Config')->Get('AttachmentDownloadType') || 'attachment';
        $Output .= '; ';
    }

    if ( $Param{Filename} ) {

        # IE 10+ supports this
        my $URLEncodedFilename = URI::Escape::uri_escape_utf8( $Param{Filename} );
        $Output .= " filename=\"$Param{Filename}\"; filename*=utf-8''$URLEncodedFilename";
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
    $Output .= "X-UA-Compatible: IE=edge,chrome=1\n";
    $Output .= "X-Frame-Options: SAMEORIGIN\n";

    if ( $Param{Charset} ) {
        $Output .= "Content-Type: $Param{ContentType}; charset=$Param{Charset};\n\n";
    }
    else {
        $Output .= "Content-Type: $Param{ContentType}\n\n";
    }

    # disable utf8 flag, to write binary to output
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
    $EncodeObject->EncodeOutput( \$Output );
    $EncodeObject->EncodeOutput( \$Param{Content} );

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
            my $BaselinkAll = $Baselink
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
            my $BaselinkAllBack = $Baselink . "StartHit=" . ( ( $i - 1 ) * $Param{PageShown} + 1 );
            my $BaselinkAllNext = $Baselink . "StartHit=" . ( ( $Param{PageShown} * ( $Pages - 1 ) ) + 1 );

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
            my $BaselinkAllNext = $Baselink . 'StartHit=' . ( ( $WindowStart - 1 ) * ( $Param{PageShown} ) + 1 );

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
        $Param{NavBarLong} = "- " . $Self->{LanguageObject}->Translate("Page") . ": $Param{SearchNavBar}";
    }
    else {
        $Param{SearchNavBar} = '';
    }

    # return data
    return (
        TotalHits  => $Param{TotalHits},
        Result     => $Param{Results},
        ResultLong => "$Param{Results} "
            . $Self->{LanguageObject}->Translate("of")
            . " $Param{TotalHits}",
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

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # create menu items
    my %NavBar;
    my $FrontendModuleConfig = $ConfigObject->Get('Frontend::Module');

    MODULE:
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        next MODULE if !$Hash{NavBar};
        next MODULE if ref $Hash{NavBar} ne 'ARRAY';

        my @Items = @{ $Hash{NavBar} };

        ITEM:
        for my $Item (@Items) {
            next ITEM if !$Item->{NavBar};
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
            PERMISSION:
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Item->{$Permission} && ref $Item->{$Permission} eq 'ARRAY' ) {
                    for ( @{ $Item->{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
                        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                            $Shown = 1;
                            last PERMISSION;
                        }
                    }
                }

                # scalar access restriction
                elsif ( $Item->{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Item->{$Permission} . ']';
                    if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                        last PERMISSION;
                    }
                }

                # no access restriction
                elsif ( !$Item->{GroupRo} && !$Item->{Group} ) {
                    $Shown = 1;
                    last PERMISSION;
                }
            }
            next ITEM if !$Shown;

            # set prio of item
            my $Key = ( $Item->{Block} || '' ) . sprintf( "%07d", $Item->{Prio} );
            COUNT:
            for ( 1 .. 51 ) {
                last COUNT if !$NavBar{$Key};

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

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run menu item modules
    if ( ref $ConfigObject->Get('Frontend::NavBarModule') eq 'HASH' ) {
        my %Jobs = %{ $ConfigObject->Get('Frontend::NavBarModule') };

        MENUMODULE:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next MENUMODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next MENUMODULE if !$Object;

            # run module
            %NavBar = (
                %NavBar,
                $Object->Run(
                    %Param,
                    Config => $Jobs{$Job},
                    NavBar => \%NavBar || {}
                    )
            );
        }
    }

    # show nav bar
    ITEM:
    for my $Key ( sort keys %NavBar ) {
        next ITEM if $Key eq 'Sub';
        next ITEM if !%{ $NavBar{$Key} };
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
        next ITEM if !$Sub;
        $Self->Block(
            Name => 'ItemAreaSub',
            Data => $Item,
        );
        for my $Key ( sort keys %{$Sub} ) {
            my $ItemSub = $Sub->{$Key};
            $ItemSub->{NameForID} = $ItemSub->{Name};
            $ItemSub->{NameForID} =~ s/[ &;]//ig;
            $ItemSub->{NameTop} = $Item->{NameForID};
            $ItemSub->{Description}
                ||= $ItemSub->{Name};    # use 'name' as fallback, this is shown as the link title
            $Self->Block(
                Name => 'ItemAreaSubItem',    #$Item->{Block} || 'Item',
                Data => {
                    %$ItemSub,
                    AccessKeyReference => $ItemSub->{AccessKey} ? " ($ItemSub->{AccessKey})" : '',
                },
            );
        }
    }

    # get user preferences for custom nav bar item ordering
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $NavbarOrderItems = $UserPreferences{'UserNavBarItemsOrder'} || '';
    $Self->Block(
        Name => 'NavbarOrderItems',
        Data => {
            'NavbarOrderItems' => $NavbarOrderItems,
        },
    );

    # show search icon if any search router is configured
    if ( IsHashRefWithData( $ConfigObject->Get('Frontend::Search') ) ) {
        $Self->Block(
            Name => 'SearchIcon',
        );
    }

    # create & return output
    my $Output = $Self->Output(
        TemplateFile => 'AgentNavigationBar',
        Data         => \%Param
    );

    # run nav bar output modules
    my $NavBarOutputModuleConfig = $ConfigObject->Get('Frontend::NavBarOutputModule');
    if ( ref $NavBarOutputModuleConfig eq 'HASH' ) {
        my %Jobs = %{$NavBarOutputModuleConfig};

        OUTPUTMODULE:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next OUTPUTMODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next OUTPUTMODULE if !$Object;

            # run module
            $Output .= $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run notification modules
    my $FrontendNotifyModuleConfig = $ConfigObject->Get('Frontend::NotifyModule');
    if ( ref $FrontendNotifyModuleConfig eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};

        NOTIFICATIONMODULE:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next NOTIFICATIONMODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next NOTIFICATIONMODULE if !$Object;

            # run module
            $Output .= $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # run nav bar modules
    if ( $Self->{ModuleReg}->{NavBarModule} ) {

        # run navbar modules
        my %Jobs = %{ $Self->{ModuleReg}->{NavBarModule} };

        # load module
        if ( !$MainObject->Require( $Jobs{Module} ) ) {
            return $Output;
        }

        my $Object = $Jobs{Module}->new(
            %{$Self},
            LayoutObject => $Self,
        );

        if ( !$Object ) {
            return $Output;
        }

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
    if ( $Kernel::OM->Get('Kernel::Config')->Get('TimeZoneUser') && $Self->{UserTimeZone} ) {
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

=item BuildDateSelection()

build the HTML code to represent a date selection based on the given data.
Depending on the SysConfig settings the controls to set the date could be multiple select or input fields

    my $HTML = $LayoutObject->BuildDateSelection(
        Prefix           => 'some prefix',      # optional, (needed to specify other parameters)
        <Prefix>Year     => 2015,               # optional, defaults to current year, used to set the initial value
        <Prefix>Month    => 6,                  # optional, defaults to current month, used to set the initial value
        <Prefix>Day      => 9,                  # optional, defaults to current day, used to set the initial value
        <Prefix>Hour     => 12,                 # optional, defaults to current hour, used to set the initial value
        <Prefix>Minute   => 26,                 # optional, defaults to current minute, used to set the initial value
        <Prefix>Second   => 59,                 # optional, defaults to current second, used to set the initial value
        <Prefix>Optional => 1,                  # optional, default 0, when active a checkbox is included to specify
                                                #   if the values should be saved or not
        <Prefix>Used     => 1,                  # optional, default 0, used to set the initial state of the checkbox
                                                #   mentioned above
        <Prefix>Required => 1,                  # optional, default 0 (Deprecated)
        <prefix>Class => 'some class',          # optional, specify an additional class to the HTML elements

        Area     => 'some area',                # optional, default 'Agent' (Deprecated)
        DiffTime => 123,                        # optional, default 0, used to set the initial time influencing the
                                                #   current time (in seconds)
        OverrideTimeZone        => 1,           # optional (1 or 0), when active the time is not translated to the user
                                                #   time zone
        YearPeriodFuture        => 3,           # optional, used to define the number of years in future to be display
                                                #   in the year select
        YearPeriodPast          => 2,           # optional, used to define the number of years in past to be display
                                                #   in the year select
        YearDiff                => 0,           # optional. used to define the number of years to be displayed
                                                #   in the year select (alternatively to YearPeriodFuture and YearPeriodPast)
        ValidateDateInFuture    => 1,           # optional (1 or 0), when active sets an special class to validate
                                                #   that the date set in the controls to be in the future
        ValidateDateNotInFuture => 1,           # optional (1 or 0), when active sets an special class to validate
                                                #   that the date set in the controls not to be in the future

        Calendar => 2,                          # optional, used to define the SysConfig calendar on which the Datepicker
                                                #   will be based on to show the vacation days and the start week day
        Format => 'DateImputFormat',            # optional, or 'DateInputFormatLong', used to define if only date or
                                                #   date/time components should be shown (DateInputFormatLong shows date/time)
        Validate => 1,                          # optional (1 or 0), defines if the date selection should be validated on
                                                #   client side with JS
        Disabled => 1,                          # optional (1 or 0), when active select and checkbox controls gets the
                                                #   disabled attribute and input fields gets the read only attribute
    );

=cut

sub BuildDateSelection {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $DateInputStyle = $ConfigObject->Get('TimeInputFormat');
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
    my $ValidateDateInFuture    = $Param{ValidateDateInFuture}    || 0;
    my $ValidateDateNotInFuture = $Param{ValidateDateNotInFuture} || 0;

    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{UserTimeObject}->SystemTime2Date(
        SystemTime => $Self->{UserTimeObject}->SystemTime() + $DiffTime,
    );

    my ( $Cs, $Cm, $Ch, $CD, $CM, $CY ) = $Self->{UserTimeObject}->SystemTime2Date(
        SystemTime => $Self->{UserTimeObject}->SystemTime(),
    );

    # time zone translation
    if (
        $ConfigObject->Get('TimeZoneUser')
        && $Self->{UserTimeZone}
        && $Param{ $Prefix . 'Year' }
        && $Param{ $Prefix . 'Month' }
        && $Param{ $Prefix . 'Day' }
        && !$Param{OverrideTimeZone}
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

        # Check if the DiffTime is in a future year. In this case, we add the missing years between
        # $CY (current year) and $Y (year) to allow the user to manually set back the year if needed.
        if ( $Y > $CY ) {
            for ( $CY .. $Y ) {
                $Year{$_} = $_;
            }
        }

        $Param{Year} = $Self->BuildSelection(
            Name        => $Prefix . 'Year',
            Data        => \%Year,
            SelectedID  => int( $Param{ $Prefix . 'Year' } || $Y ),
            Translation => 0,
            Class       => $Validate ? 'Validate_DateYear' : '',
            Title       => $Self->{LanguageObject}->Translate('Year'),
            Disabled    => $Param{Disabled},
        );
    }
    else {
        $Param{Year} = "<input type=\"text\" "
            . ( $Validate ? "class=\"Validate_DateYear $Class\" " : "class=\"$Class\" " )
            . "name=\"${Prefix}Year\" id=\"${Prefix}Year\" size=\"4\" maxlength=\"4\" "
            . "title=\""
            . $Self->{LanguageObject}->Translate('Year')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Year' } || $Y ) ) . "\" "
            . ( $Param{Disabled} ? 'readonly="readonly"' : '' ) . "/>";
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
            Title       => $Self->{LanguageObject}->Translate('Month'),
            Disabled    => $Param{Disabled},
        );
    }
    else {
        $Param{Month} = "<input type=\"text\" "
            . ( $Validate ? "class=\"Validate_DateMonth $Class\" " : "class=\"$Class\" " )
            . "name=\"${Prefix}Month\" id=\"${Prefix}Month\" size=\"2\" maxlength=\"2\" "
            . "title=\""
            . $Self->{LanguageObject}->Translate('Month')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) . "\" "
            . ( $Param{Disabled} ? 'readonly="readonly"' : '' ) . "/>";
    }

    my $DateValidateClasses = '';
    if ($Validate) {
        $DateValidateClasses
            .= "Validate_DateDay Validate_DateYear_${Prefix}Year Validate_DateMonth_${Prefix}Month";

        if ( $Format eq 'DateInputFormatLong' ) {
            $DateValidateClasses
                .= " Validate_DateHour_${Prefix}Hour Validate_DateMinute_${Prefix}Minute";
        }

        if ($ValidateDateInFuture) {
            $DateValidateClasses .= " Validate_DateInFuture";
        }
        if ($ValidateDateNotInFuture) {
            $DateValidateClasses .= " Validate_DateNotInFuture";
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
            Title       => $Self->{LanguageObject}->Translate('Day'),
            Disabled    => $Param{Disabled},
        );
    }
    else {
        $Param{Day} = "<input type=\"text\" "
            . "class=\"$DateValidateClasses $Class\" "
            . "name=\"${Prefix}Day\" id=\"${Prefix}Day\" size=\"2\" maxlength=\"2\" "
            . "title=\""
            . $Self->{LanguageObject}->Translate('Day')
            . "\" value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Day' } || $D ) ) . "\" "
            . ( $Param{Disabled} ? 'readonly="readonly"' : '' ) . "/>";

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
                Title       => $Self->{LanguageObject}->Translate('Hours'),
                Disabled    => $Param{Disabled},
            );
        }
        else {
            $Param{Hour} = "<input type=\"text\" "
                . ( $Validate ? "class=\"Validate_DateHour $Class\" " : "class=\"$Class\" " )
                . "name=\"${Prefix}Hour\" id=\"${Prefix}Hour\" size=\"2\" maxlength=\"2\" "
                . "title=\""
                . $Self->{LanguageObject}->Translate('Hours')
                . "\" value=\""
                . sprintf(
                "%02d",
                ( defined( $Param{ $Prefix . 'Hour' } ) ? int( $Param{ $Prefix . 'Hour' } ) : $h )
                )
                . "\" "
                . ( $Param{Disabled} ? 'readonly="readonly"' : '' ) . "/>";

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
                Title       => $Self->{LanguageObject}->Translate('Minutes'),
                Disabled    => $Param{Disabled},
            );
        }
        else {
            $Param{Minute} = "<input type=\"text\" "
                . ( $Validate ? "class=\"Validate_DateMinute $Class\" " : "class=\"$Class\" " )
                . "name=\"${Prefix}Minute\" id=\"${Prefix}Minute\" size=\"2\" maxlength=\"2\" "
                . "title=\""
                . $Self->{LanguageObject}->Translate('Minutes')
                . "\" value=\""
                . sprintf(
                "%02d",
                (
                    defined( $Param{ $Prefix . 'Minute' } )
                    ? int( $Param{ $Prefix . 'Minute' } )
                    : $m
                    )
                ) . "\" "
                . ( $Param{Disabled} ? 'readonly="readonly"' : '' ) . "/>";
        }
    }

    # Get first day of the week
    my $WeekDayStart = $ConfigObject->Get('CalendarWeekDayStart');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $WeekDayStart = $ConfigObject->Get( "CalendarWeekDayStart::Calendar" . $Param{Calendar} );
        }
    }
    if ( !defined $WeekDayStart ) {
        $WeekDayStart = 1;
    }

    my $Output;

    # optional checkbox
    if ($Optional) {
        my $Checked = '';
        if ($Used) {
            $Checked = ' checked="checked"';
        }
        $Output .= "<input type=\"checkbox\" name=\""
            . $Prefix
            . "Used\" id=\"" . $Prefix . "Used\" value=\"1\""
            . $Checked
            . " class=\"$Class\""
            . " title=\""
            . $Self->{LanguageObject}->Translate('Check to activate this date')
            . "\" "
            . ( $Param{Disabled} ? 'disabled="disabled"' : '' )
            . "/>&nbsp;";
    }

    # date format
    $Output .= $Self->{LanguageObject}->Time(
        Action => 'Return',
        Format => 'DateInputFormat',
        Mode   => 'NotNumeric',
        %Param,
    );

    # prepare datepicker for specific calendar
    my $VacationDays = '';
    if ( $Param{Calendar} ) {
        $VacationDays = $Self->DatepickerGetVacationDays(
            Calendar => $Param{Calendar},
        );
    }
    my $VacationDaysJSON = $Self->JSONEncode(
        Data => $VacationDays,
    );

    # Add Datepicker JS to output.
    my $DatepickerJS = '
    Core.UI.Datepicker.Init({
        Day: $("#" + Core.App.EscapeSelector("' . $Prefix . '") + "Day"),
        Month: $("#" + Core.App.EscapeSelector("' . $Prefix . '") + "Month"),
        Year: $("#" + Core.App.EscapeSelector("' . $Prefix . '") + "Year"),
        Hour: $("#" + Core.App.EscapeSelector("' . $Prefix . '") + "Hour"),
        Minute: $("#" + Core.App.EscapeSelector("' . $Prefix . '") + "Minute"),
        VacationDays: ' . $VacationDaysJSON . ',
        DateInFuture: ' .    ( $ValidateDateInFuture    ? 'true' : 'false' ) . ',
        DateNotInFuture: ' . ( $ValidateDateNotInFuture ? 'true' : 'false' ) . ',
        WeekDayStart: ' . $WeekDayStart . '
    });';

    $Self->AddJSOnDocumentComplete( Code => $DatepickerJS );
    $Self->{HasDatepicker} = 1;    # Call some Datepicker init code.

    return $Output;
}

sub CustomerLogin {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{TitleArea} = $Self->{LanguageObject}->Translate('Login') . ' - ';

    # set Action parameter for the loader
    $Self->{Action} = 'CustomerLogin';
    $Param{'XLoginHeader'} = 1;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $ConfigObject->Get('SessionUseCookie') ) {

        # always set a cookie, so that at the time the user submits
        # the password, we know already if the browser supports cookies.
        # ( the session cookie isn't available at that time ).
        my $CookieSecureAttribute = 0;
        if ( $ConfigObject->Get('HttpType') eq 'https' ) {

            # Restrict Cookie to HTTPS if it is used.
            $CookieSecureAttribute = 1;
        }
        $Self->{SetCookies}->{OTRSBrowserHasCookie} = $Kernel::OM->Get('Kernel::System::Web::Request')->SetCookie(
            Key      => 'OTRSBrowserHasCookie',
            Value    => 1,
            Expires  => '1y',
            Path     => $ConfigObject->Get('ScriptAlias'),
            Secure   => $CookieSecureAttribute,
            HttpOnly => 1,
        );
    }

    # add cookies if exists
    if ( $Self->{SetCookies} && $ConfigObject->Get('SessionUseCookie') ) {
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

    # Generate the minified CSS and JavaScript files and the tags referencing them (see LayoutLoader)
    $Self->LoaderCreateCustomerCSSCalls();
    $Self->LoaderCreateCustomerJSCalls();

    # Add header logo, if configured
    if ( defined $ConfigObject->Get('CustomerLogo') ) {
        my %CustomerLogo = %{ $ConfigObject->Get('CustomerLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %CustomerLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $CustomerLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $ConfigObject->Get('Frontend::WebPath');
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

    # get system maintenance object
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    # check if system maintenance is active
    if ($ActiveMaintenance) {
        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => 1,
        );
        if ( $SystemMaintenanceData->{ShowLoginMessage} ) {
            my $LoginMessage =
                $SystemMaintenanceData->{LoginMessage}
                || $ConfigObject->Get('SystemMaintenance::IsActiveDefaultLoginMessage')
                || "System maintenance is active, not possible to perform a login!";

            $Self->Block(
                Name => 'SystemMaintenance',
                Data => {
                    LoginMessage => $LoginMessage,
                },
            );
        }
    }

    # show prelogin block, if in prelogin mode (e.g. SSO login)
    if ( defined $Param{'Mode'} && $Param{'Mode'} eq 'PreLogin' ) {
        $Self->Block(
            Name => 'PreLogin',
            Data => \%Param,
        );
    }

    # if not in PreLogin mode, show normal login form
    else {

        $Self->Block(
            Name => 'LoginBox',
            Data => \%Param,
        );

        # show 2 factor password input if we have at least one backend enabled
        COUNT:
        for my $Count ( '', 1 .. 10 ) {
            next COUNT if !$ConfigObject->Get("Customer::AuthTwoFactorModule$Count");

            $Self->Block(
                Name => 'AuthTwoFactor',
                Data => \%Param,
            );
            last COUNT;
        }

        # get lost password output
        if (
            $ConfigObject->Get('CustomerPanelLostPassword')
            && $ConfigObject->Get('Customer::AuthModule') eq
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

        # get create account output
        if (
            $ConfigObject->Get('CustomerPanelCreateAccount')
            && $ConfigObject->Get('Customer::AuthModule') eq
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
    }

    # create & return output
    $Output .= $Self->Output(
        TemplateFile => 'CustomerLogin',
        Data         => \%Param
    );

    # remove the version tag from the header if configured
    $Self->_DisableBannerCheck( OutputRef => \$Output );

    return $Output;
}

sub CustomerHeader {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || '';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # add cookies if exists
    my $Output = '';
    if ( $Self->{SetCookies} && $ConfigObject->Get('SessionUseCookie') ) {
        for ( sort keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    my $File = $Param{Filename} || $Self->{Action} || 'unknown';

    # set file name for "save page as"
    $Param{ContentDisposition} = "filename=\"$File.html\"";

    # area and title
    if (
        !$Param{Area}
        && $ConfigObject->Get('CustomerFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Area} = $ConfigObject->Get('CustomerFrontend::Module')->{ $Self->{Action} }
            ->{NavBarName} || '';
    }
    if (
        !$Param{Title}
        && $ConfigObject->Get('CustomerFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Title} = $ConfigObject->Get('CustomerFrontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    if (
        !$Param{Area}
        && $ConfigObject->Get('PublicFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Area} = $ConfigObject->Get('PublicFrontend::Module')->{ $Self->{Action} }
            ->{NavBarName} || '';
    }
    if (
        !$Param{Title}
        && $ConfigObject->Get('PublicFrontend::Module')->{ $Self->{Action} }
        )
    {
        $Param{Title} = $ConfigObject->Get('PublicFrontend::Module')->{ $Self->{Action} }->{Title}
            || '';
    }
    for my $Word (qw(Value Title Area)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= $Self->{LanguageObject}->Translate( $Param{$Word} ) . ' - ';
        }
    }

    my $Frontend;
    if ( $ConfigObject->Get('CustomerFrontend::Module')->{ $Self->{Action} } ) {
        $Frontend = 'Customer';
    }
    else {
        $Frontend = 'Public';
    }

    # run header meta modules for customer and public frontends
    my $HeaderMetaModule = $ConfigObject->Get( $Frontend . 'Frontend::HeaderMetaModule' );
    if ( ref $HeaderMetaModule eq 'HASH' ) {
        my %Jobs = %{$HeaderMetaModule};

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        MODULE:
        for my $Job ( sort keys %Jobs ) {

            # load and run module
            next MODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, LayoutObject => $Self );
            next MODULE if !$Object;
            $Object->Run( %Param, Config => $Jobs{$Job} );
        }
    }

    # set rtl if needed
    if ( $Self->{TextDirection} && $Self->{TextDirection} eq 'rtl' ) {
        $Param{BodyClass} = 'RTL';
    }
    elsif ( $ConfigObject->Get('Frontend::DebugMode') ) {
        $Self->Block(
            Name => 'DebugRTLButton',
        );
    }

    # Add header logo, if configured
    if ( defined $ConfigObject->Get('CustomerLogo') ) {
        my %CustomerLogo = %{ $ConfigObject->Get('CustomerLogo') };
        my %Data;

        for my $CSSStatement ( sort keys %CustomerLogo ) {
            if ( $CSSStatement eq 'URL' ) {
                my $WebPath = '';
                if ( $CustomerLogo{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                    $WebPath = $ConfigObject->Get('Frontend::WebPath');
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
                VacationDays  => $VacationDaysJSON,
                IsRTLLanguage => ( $TextDirection eq 'rtl' ) ? 1 : 0,
            },
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Banner
    if ( !$ConfigObject->Get('Secure::DisableBanner') ) {
        $Self->Block(
            Name => 'Banner',
        );
    }

    # AutoComplete-Config
    my $AutocompleteConfig = $ConfigObject->Get('AutoComplete::Customer');

    for my $ConfigElement ( sort keys %{$AutocompleteConfig} ) {
        $AutocompleteConfig->{$ConfigElement}->{ButtonText}
            = $Self->{LanguageObject}->Translate( $AutocompleteConfig->{$ConfigElement}{ButtonText} );
    }

    my $AutocompleteConfigJSON = $Self->JSONEncode(
        Data => $AutocompleteConfig,
    );

    $Self->Block(
        Name => 'AutoCompleteConfig',
        Data => {
            AutocompleteConfig => $AutocompleteConfigJSON,
        },
    );

    # create & return output
    return $Self->Output(
        TemplateFile => "CustomerFooter$Type",
        Data         => \%Param
    );
}

sub CustomerFatalError {
    my ( $Self, %Param ) = @_;

    # Prevent endless recursion in case of problems with Template engine.
    return if ( $Self->{InFatalError}++ );

    if ( $Param{Message} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => $Param{Message},
        );
    }
    my $Output = $Self->CustomerHeader(
        Area  => 'Frontend',
        Title => 'Fatal Error'
    );
    $Output .= $Self->Error(%Param);
    $Output .= $Self->CustomerFooter();
    $Self->Print( Output => \$Output );
    exit;
}

sub CustomerNavigationBar {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # create menu items
    my %NavBarModule;
    my $FrontendModuleConfig = $ConfigObject->Get('CustomerFrontend::Module');

    MODULE:
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        next MODULE if !$Hash{NavBar};
        next MODULE if ref $Hash{NavBar} ne 'ARRAY';

        my @Items = @{ $Hash{NavBar} };

        ITEM:
        for my $Item (@Items) {
            next ITEM if !$Item;

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
            PERMISSION:
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Item->{$Permission} && ref $Item->{$Permission} eq 'ARRAY' ) {
                    for my $Type ( @{ $Item->{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $Type . ']';
                        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                            $Shown = 1;
                            last PERMISSION;
                        }
                    }
                }

                # scalar access restriction
                elsif ( $Item->{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Item->{$Permission} . ']';
                    if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                        last PERMISSION;
                    }
                }

                # no access restriction
                elsif ( !$Item->{GroupRo} && !$Item->{Group} ) {
                    $Shown = 1;
                    last PERMISSION;
                }
            }
            next ITEM if !$Shown;

            # set prio of item
            my $Key = sprintf( "%07d", $Item->{Prio} );
            COUNT:
            for ( 1 .. 51 ) {
                last COUNT if !$NavBarModule{$Key};

                $Item->{Prio}++;
            }

            if ( $Item->{Type} eq 'Menu' ) {
                $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }

            # show as sub of main menu
            elsif ( $Item->{Type} eq 'Submenu' ) {
                $NavBarModule{Sub}->{ $Item->{NavBar} }->{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }
            else {
                $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }
        }
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run menu item modules
    if ( ref $ConfigObject->Get('CustomerFrontend::NavBarModule') eq 'HASH' ) {
        my %Jobs = %{ $ConfigObject->Get('CustomerFrontend::NavBarModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                $Self->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
                UserID       => $Self->{UserID},
                Debug        => $Self->{Debug},
            );

            # run module
            %NavBarModule = (
                %NavBarModule,
                $Object->Run(
                    %Param,
                    Config       => $Jobs{$Job},
                    NavBarModule => \%NavBarModule || {},
                ),
            );
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

    ITEM:
    for my $Item ( sort keys %NavBarModule ) {
        next ITEM if !%{ $NavBarModule{$Item} };
        next ITEM if $Item eq 'Sub';
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
        next ITEM if !$Sub;
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
    my $FrontendNotifyModuleConfig = $ConfigObject->Get('CustomerFrontend::NotifyModule');
    if ( ref $FrontendNotifyModuleConfig eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};

        NOTIFICATIONMODULE:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next NOTIFICATIONMODULE if !$MainObject->Require( $Jobs{$Job}->{Module} );
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );
            next NOTIFICATIONMODULE if !$Object;

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

        # show open chat requests (if chat engine is active)
        if ( $ConfigObject->Get('ChatEngine::Active') ) {

            my $ChatObject = $Kernel::OM->Get('Kernel::System::Chat');
            my $Chats      = $ChatObject->ChatList(
                Status        => 'request',
                TargetType    => 'Customer',
                ChatterID     => $Self->{UserID},
                ChatterType   => 'Customer',
                ChatterActive => 0,
            );

            my $Count = scalar $Chats;

            $Self->Block(
                Name => 'ChatRequests',
                Data => {
                    Count => $Count,
                    Class => ($Count) ? '' : 'Hidden',
                },
            );
        }
    }

    # create & return output
    return $Self->Output(
        TemplateFile => 'CustomerNavigationBar',
        Data         => \%Param
    );
}

sub CustomerError {
    my ( $Self, %Param ) = @_;

    # get backend error messages
    for (qw(Message Traceback)) {
        $Param{ 'Backend' . $_ } = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'Error',
            What => $_
        ) || '';
    }
    if ( !$Param{BackendMessage} && !$Param{BackendTraceback} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Param{Message} || '?',
        );
        for (qw(Message Traceback)) {
            $Param{ 'Backend' . $_ } = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
                Type => 'Error',
                What => $_
            ) || '';
        }
    }

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output(
        TemplateFile => 'CustomerError',
        Data         => \%Param
    );
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
    $Param{BackendMessage} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'Notice',
        What => 'Message',
        )
        || $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'Error',
        What => 'Message',
        ) || '';

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output(
        TemplateFile => 'CustomerWarning',
        Data         => \%Param
    );
}

sub CustomerNoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';
    $Param{Message} ||= 'No Permission!';

    # create output
    my $Output;
    $Output = $Self->CustomerHeader( Title => 'No Permission' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output(
        TemplateFile => 'NoPermission',
        Data         => \%Param
    );
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # ascii 2 html
    $Param{String} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # ascii 2 html
    $Param{String} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # replace image link with content id for uploaded images
    my $StringRef = $Self->_RichTextReplaceLinkOfInlineContent(
        String => \$Param{String},
    );

    # verify html document
    $Param{String} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentComplete(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # replace image link with content id for uploaded images
    ${ $Param{String} } =~ s{
        (<img.+?src=("|'))[^>]+ContentID=(.+?)("|')([^>]+>)
    }
    {
        my ($Start, $CID, $Close, $End) = ($1, $3, $4, $5);
        # Make sure we only get the CID and not extra stuff like session information
        $CID =~ s{^([^;&]+).*}{$1}smx;
        $Start . 'cid:' . $CID . $Close . $End;
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get charset and convert content to internal charset
    my $Charset;
    if ( $Param{Data}->{ContentType} =~ m/.+?charset=("|'|)(.+)/ig ) {
        $Charset = $2;
        $Charset =~ s/"|'//g;
    }
    if ( !$Charset ) {
        $Charset = 'us-ascii';
        $Param{Data}->{ContentType} .= '; charset="us-ascii"';
    }

    # convert charset
    if ($Charset) {
        $Param{Data}->{Content} = $Kernel::OM->Get('Kernel::System::Encode')->Convert(
            Text => $Param{Data}->{Content},
            From => $Charset,
            To   => 'utf-8',
        );

        # replace charset in content
        $Param{Data}->{ContentType} =~ s/\Q$Charset\E/utf-8/gi;
        $Param{Data}->{Content} =~ s/(charset=("|'|))\Q$Charset\E/$1utf-8/gi;
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
        my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
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
            my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
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
        ATTACHMENT_ID:
        for my $AttachmentID (  sort keys %{ $Param{Attachments} }) {
            next ATTACHMENT_ID if lc $Param{Attachments}->{$AttachmentID}->{ContentID} ne lc "<$ContentID>";
            $ContentID = $AttachmentLink . $AttachmentID . $SessionID;
            last ATTACHMENT_ID;
        }

        # return new runtime url
        $Start . $ContentID . $End;
    }egxi;

    # bug #5053
    # inline images using Content-Location as identifier instead of Content-ID even RFC2557
    # http://www.ietf.org/rfc/rfc2557.txt

    # find matching attachment and replace it with runtlime url to image
    ATTACHMENT:
    for my $AttachmentID ( sort keys %{ $Param{Attachments} } ) {
        next ATTACHMENT if !$Param{Attachments}->{$AttachmentID}->{ContentID};

        # content id cleanup
        $Param{Attachments}->{$AttachmentID}->{ContentID} =~ s/^<//;
        $Param{Attachments}->{$AttachmentID}->{ContentID} =~ s/>$//;

        next ATTACHMENT if !$Param{Attachments}->{$AttachmentID}->{ContentID};

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    $Param{String} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentCleanup(
        String => $Param{String},
    );

    return $Param{String};
}

=begin Internal:

=cut

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
            my $TranslatedKey = $Self->{LanguageObject}->Translate($OriginalKey);
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

    # dclone $Param{Data} because the subroutine unfortunately modifies
    # the original data ref
    my $DataLocal = Storable::dclone( $Param{Data} );

    # if HashRef was given
    if ( ref $DataLocal eq 'HASH' ) {

        # get missing parents and mark them for disable later
        if ( $OptionRef->{Sort} eq 'TreeView' ) {
            my %List = reverse %{$DataLocal};

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
                        $DataLocal->{ $ElementLongName . '_Disabled' } = $ElementLongName;
                    }
                    $Parents .= $Element . '::';
                }
            }
        }

        # sort hash (before the translation)
        my @SortKeys;
        if ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {
            my %List = reverse %{$DataLocal};
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @SortKeys, $List{$Key};
                    delete $List{$Key};
                }
            }
            push @SortKeys, sort { lc $a cmp lc $b } ( values %List );
        }

        # translate value
        if ( $OptionRef->{Translation} ) {
            for my $Row ( sort keys %{$DataLocal} ) {
                $DataLocal->{$Row} = $Self->{LanguageObject}->Translate( $DataLocal->{$Row} );
            }
        }

        # sort hash (after the translation)
        if ( $OptionRef->{Sort} eq 'NumericKey' ) {
            @SortKeys = sort { $a <=> $b } ( keys %{$DataLocal} );
        }
        elsif ( $OptionRef->{Sort} eq 'NumericValue' ) {
            @SortKeys = sort { $DataLocal->{$a} <=> $DataLocal->{$b} } ( keys %{$DataLocal} );
        }
        elsif ( $OptionRef->{Sort} eq 'AlphanumericKey' ) {
            @SortKeys = sort( keys %{$DataLocal} );
        }
        elsif ( $OptionRef->{Sort} eq 'TreeView' ) {

            # add suffix for correct sorting
            my %SortHash;
            for ( sort keys %{$DataLocal} ) {
                $SortHash{$_} = $DataLocal->{$_} . '::';
            }
            @SortKeys = sort { lc $SortHash{$a} cmp lc $SortHash{$b} } ( keys %SortHash );
        }
        elsif ( $OptionRef->{Sort} eq 'IndividualKey' && $OptionRef->{SortIndividual} ) {
            my %List = %{$DataLocal};
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @SortKeys, $Key;
                    delete $List{$Key};
                }
            }
            push @SortKeys, sort { lc $List{$a} cmp lc $List{$b} } ( keys %List );
        }
        elsif ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {

            # already done before the translation
        }
        else {
            @SortKeys = sort { lc $DataLocal->{$a} cmp lc $DataLocal->{$b} } ( keys %{$DataLocal} );
            $OptionRef->{Sort} = 'AlphanumericValue';
        }

        # create DataRef
        for my $Row (@SortKeys) {
            $DataRef->[$Counter]->{Key}   = $Row;
            $DataRef->[$Counter]->{Value} = $DataLocal->{$Row};
            $Counter++;
        }
    }

    # if ArrayHashRef was given
    elsif ( ref $DataLocal eq 'ARRAY' && ref $DataLocal->[0] eq 'HASH' ) {

        # get missing parents and mark them for disable later
        if ( $OptionRef->{Sort} eq 'TreeView' ) {

            # build a list of element longnames
            my @NewDataLocal;

            my %List;
            for my $ValueHash ( @{$DataLocal} ) {
                $List{ $ValueHash->{Value} } = 1;
            }

            # get each data value hash
            for my $ValueHash ( @{$DataLocal} ) {

                my $Parents = '';

                # try to split its parents (e.g. Queue or Service) GrandParent::Parent::Son
                my @Elements = split /::/, $ValueHash->{Value};

                # get each element in the hierarchy
                for my $Element (@Elements) {

                    # add its own parents for the complete name
                    my $ElementLongName = $Parents . $Element;

                    # check if element exists in the original data or if it is already marked
                    if ( !$List{$ElementLongName} && !$DisabledElements{$ElementLongName} ) {

                        # mark element as disabled
                        $DisabledElements{$ElementLongName} = 1;

                        # push the missing element to the data local array
                        push @NewDataLocal, {
                            Key      => $ElementLongName . '_Disabled',
                            Value    => $ElementLongName,
                            Disabled => 1,
                        };
                    }
                    $Parents .= $Element . '::';
                }

                # push the element to the data local array
                push @NewDataLocal, {
                    Key      => $ValueHash->{Key},
                    Value    => $ValueHash->{Value},
                    Selected => $ValueHash->{Selected} ? 1 : 0,
                    Disabled => $ValueHash->{Disabled} ? 1 : 0,
                };
            }

            # override the data local with the new one
            @{$DataLocal} = @NewDataLocal;
        }

        # create DataRef
        for my $Row ( @{$DataLocal} ) {
            if ( ref $Row eq 'HASH' && defined $Row->{Key} ) {
                $DataRef->[$Counter]->{Key}   = $Row->{Key};
                $DataRef->[$Counter]->{Value} = $Row->{Value};

                # translate value
                if ( $OptionRef->{Translation} ) {
                    $DataRef->[$Counter]->{Value} = $Self->{LanguageObject}->Translate( $DataRef->[$Counter]->{Value} );
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
    elsif ( ref $DataLocal eq 'ARRAY' ) {

        # get missing parents and mark them for disable later
        if ( $OptionRef->{Sort} eq 'TreeView' ) {
            my %List = map { $_ => 1 } @{$DataLocal};

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
                        push @{$DataLocal}, $ElementLongName;
                    }
                    $Parents .= $Element . '::';
                }
            }
        }

        if ( $OptionRef->{Sort} eq 'IndividualValue' && $OptionRef->{SortIndividual} ) {
            my %List = map { $_ => 1 } @{$DataLocal};
            $DataLocal = [];
            for my $Key ( @{ $OptionRef->{SortIndividual} } ) {
                if ( $List{$Key} ) {
                    push @{$DataLocal}, $Key;
                    delete $List{$Key};
                }
            }
            push @{$DataLocal}, sort { $a cmp $b } ( keys %List );
        }

        my %ReverseHash;

        # translate value
        if ( $OptionRef->{Translation} ) {
            my @TranslateArray;
            for my $Row ( @{$DataLocal} ) {
                my $TranslateString = $Self->{LanguageObject}->Translate($Row);
                push @TranslateArray, $TranslateString;
                $ReverseHash{$TranslateString} = $Row;
            }
            $DataLocal = \@TranslateArray;
        }
        else {
            for my $Row ( @{$DataLocal} ) {
                $ReverseHash{$Row} = $Row;
            }
        }

        # sort array
        if ( $OptionRef->{Sort} eq 'AlphanumericKey' || $OptionRef->{Sort} eq 'AlphanumericValue' )
        {
            my @SortArray = sort( @{$DataLocal} );
            $DataLocal = \@SortArray;
        }
        elsif ( $OptionRef->{Sort} eq 'NumericKey' || $OptionRef->{Sort} eq 'NumericValue' ) {
            my @SortArray = sort { $a <=> $b } ( @{$DataLocal} );
            $DataLocal = \@SortArray;
        }
        elsif ( $OptionRef->{Sort} eq 'TreeView' ) {

            # sort array, add '::' in the comparison, for proper sort of Items with Items::SubItems
            my @SortArray = sort { $a . '::' cmp $b . '::' } @{$DataLocal};
            $DataLocal = \@SortArray;
        }

        # create DataRef
        for my $Row ( @{$DataLocal} ) {
            $DataRef->[$Counter]->{Key}   = $ReverseHash{$Row};
            $DataRef->[$Counter]->{Value} = $Row;
            $Counter++;
        }
    }

    # check disabled items on ArrayRef or HashRef only
    if (
        ref $DataLocal eq 'HASH'
        || ( ref $DataLocal eq 'ARRAY' && ref $DataLocal->[0] ne 'HASH' )
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

    # TreeView option
    if ( $OptionRef->{TreeView} ) {

        ROW:
        for my $Row ( @{$DataRef} ) {

            next ROW if !$Row->{Value};

            my @Fragment = split '::', $Row->{Value};
            $Row->{Value} = pop @Fragment;

            # TODO: Here we are combining Max with HTMLQuote, check below for the REMARK:
            # Max and HTMLQuote needs to be done before spaces insert but after the split of the
            # parents, then it is not possible to do it outside
            if ( $OptionRef->{HTMLQuote} ) {
                $Row->{Value} = $Self->Ascii2Html(
                    Text => $Row->{Value},
                    Max  => $OptionRef->{Max},
                );
            }
            elsif ( $OptionRef->{Max} ) {
                if ( length $Row->{Value} > $OptionRef->{Max} ) {
                    $Row->{Value} = substr( $Row->{Value}, 0, $OptionRef->{Max} - 5 ) . '[...]';
                }
            }

            my $Space = '&nbsp;&nbsp;' x scalar @Fragment;
            $Space ||= '';

            $Row->{Value} = $Space . $Row->{Value};
        }
    }
    else {

        # HTMLQuote option
        if ( $OptionRef->{HTMLQuote} ) {
            for my $Row ( @{$DataRef} ) {
                $Row->{Key}   = $Self->Ascii2Html( Text => $Row->{Key} );
                $Row->{Value} = $Self->Ascii2Html( Text => $Row->{Value} );
            }
        }

        # TODO: Check this comment!
        # Max option
        # REMARK: Don't merge the Max handling with Ascii2Html function call of
        # the HTMLQuote handling. In this case you lose the max handling if you
        # deactivate HTMLQuote
        if ( $OptionRef->{Max} ) {

            # REMARK: This is the same solution as in Ascii2Html
            for my $Row ( @{$DataRef} ) {

                if ( ref $Row eq 'HASH' ) {
                    if ( length $Row->{Value} > $OptionRef->{Max} ) {
                        $Row->{Value} = substr( $Row->{Value}, 0, $OptionRef->{Max} - 5 ) . '[...]';
                    }
                }
                else {
                    if ( length $Row > $OptionRef->{Max} ) {
                        $Row = substr( $Row, 0, $OptionRef->{Max} - 5 ) . '[...]';
                    }
                }
            }
        }
    }

    return $DataRef;
}

=item _BuildSelectionOutput()

create the html string

    my $HTMLString = $LayoutObject->_BuildSelectionOutput(
        AttributeRef  => $AttributeRef,
        DataRef       => $DataRef,
        TreeView      => 0,              # optional, see BuildSelection()
        FiltersRef    => \@Filters,      # optional, see BuildSelection()
        FilterActive  => $FilterActive,  # optional, see BuildSelection()
        ExpandFilters => 1,              # optional, see BuildSelection()
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

        # add filters if defined
        if ( $Param{FiltersRef} && scalar @{ $Param{FiltersRef} } > 0 ) {
            my $JSON = $Self->JSONEncode(
                Data => {
                    Filters => $Param{FiltersRef},
                },
                NoQuotes => 1,
            );
            $String .= " data-filters='$JSON'";
            if ( $Param{FilterActive} ) {
                $String .= ' data-filtered="' . int( $Param{FilterActive} ) . '"';
            }
            if ( $Param{ExpandFilters} ) {
                $String .= ' data-expand-filters="' . int( $Param{ExpandFilters} ) . '"';
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

        if ( $Param{TreeView} ) {
            my $TreeSelectionMessage = $Self->{LanguageObject}->Translate("Show Tree Selection");
            $String
                .= ' <a href="#" title="'
                . $TreeSelectionMessage
                . '" class="ShowTreeSelection"><span>'
                . $TreeSelectionMessage . '</span><i class="fa fa-sitemap"></i></a>';
        }

    }
    return $String;
}

sub _DisableBannerCheck {
    my ( $Self, %Param ) = @_;

    return 1 if !$Kernel::OM->Get('Kernel::Config')->Get('Secure::DisableBanner');
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

=item WrapPlainText()

This sub has two main functionalities:
1. Check every line and make sure that "\n" is the ending of the line.
2. If the line does _not_ start with ">" (e.g. not cited text)
wrap it after the number of "MaxCharacters" (e.g. if MaxCharacters is "80" wrap after 80 characters).
Do this _just_ if the line, that should be wrapped, contains space characters at which the line can be wrapped.

If you need more info to understand what it does, take a look at the UnitTest WrapPlainText.t to see
use cases there.

my $WrappedPlainText = $LayoutObject->WrapPlainText(
    PlainText     => "Some Plain text that is longer than the amount stored in MaxCharacters",
    MaxCharacters => 80,
);

=cut

sub WrapPlainText {
    my ( $Self, %Param ) = @_;

    # Return if we did not get MaxCharacters
    # or MaxCharacters doesn't contain just an int
    if ( !IsPositiveInteger( $Param{MaxCharacters} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no or invalid MaxCharacters!",
        );
        return;
    }

    # Return if we didn't get PlainText
    if ( !defined $Param{PlainText} ) {
        return;
    }

    # Return if we got no Scalar
    if ( ref $Param{PlainText} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Had no string in PlainText!",
        );
        return;
    }

    # Return PlainText if we have less than MaxCharacters
    if ( length $Param{PlainText} < $Param{MaxCharacters} ) {
        return $Param{PlainText};
    }

    my $WorkString = $Param{PlainText};
    $WorkString =~ s/(^>.+|.{4,$Param{MaxCharacters}})(?:\s|\z)/$1\n/gm;
    return $WorkString;
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
