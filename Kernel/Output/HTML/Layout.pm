# --
# Kernel/Output/HTML/Layout.pm - provides generic HTML output
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Layout.pm,v 1.101 2008-07-05 18:40:28 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::Layout;

use lib "../../";

use strict;
use warnings;

use Kernel::Language;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.101 $) [1];

=head1 NAME

Kernel::Output::HTML::Layout - all generic html finctions

=head1 SYNOPSIS

All generic html finctions. E. g. to get options fields, template processing, ...

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a new object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::Encode;
    use Kernel::Output::HTML::Layout;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $LayoutObject = Kernel::Output::HTML::Layout->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        EncodeObject => $EncodeObject,
        Lang         => 'de',
    );

    in addition for NavigationBar() you need
        DBObject
        SessionObject
        ParamObject
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
    # Attention the SessionObject is needet for NavigationBar()
    for (qw(ConfigObject LogObject TimeObject MainObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $_!",
            );
            $Self->FatalError();
        }
    }

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

    # get use language (from browser) if no language is there!
    if ( !$Self->{UserLanguage} ) {
        my $BrowserLang = $Self->{Lang} || $ENV{HTTP_ACCEPT_LANGUAGE} || '';
        my %Data = %{ $Self->{ConfigObject}->Get('DefaultUsedLanguages') };
        LANGUAGE:
        for my $Language ( keys %Data ) {
            if ( $BrowserLang =~ /^$Language/i ) {
                $Self->{UserLanguage} = $Language;
                last LANGUAGE;
            }
        }
    }

    # create language object
    if ( !$Self->{LanguageObject} ) {
        $Self->{LanguageObject} = Kernel::Language->new(
            UserTimeZone => $Self->{UserTimeZone},
            UserLanguage => $Self->{UserLanguage},
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            Action       => $Self->{Action},
        );
    }

    # set charset if there is no charset given
    $Self->{UserCharset} = $Self->{LanguageObject}->GetRecommendedCharset();
    $Self->{Charset}     = $Self->{UserCharset};                               # just for compat.
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

    # check Frontend::Output::FilterElementPre
    $Self->{FilterElementPre} = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre');

    # check Frontend::Output::FilterElementPost
    $Self->{FilterElementPost} = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPost');

    # check Frontend::Output::FilterContent
    $Self->{FilterContent} = $Self->{ConfigObject}->Get('Frontend::Output::FilterContent');

    # check Frontend::Output::FilterText
    $Self->{FilterText} = $Self->{ConfigObject}->Get('Frontend::Output::FilterText');

    # check browser (defaut is IE because I don't have IE)
    $Self->{BrowserWrap} = 'physical';
    $Self->{Browser}     = 'Unknown';

    if ( $Self->{FilterElementPre} && $Self->{FilterElementPre}->{ActiveElementFilter} ) {
        $Self->{BrowserJavaScriptSupport} = 0;
    }
    elsif ( $Self->{FilterElementPost} && $Self->{FilterElementPost}->{ActiveElementFilter} ) {
        $Self->{BrowserJavaScriptSupport} = 0;
    }
    elsif ( $Self->{FilterContent} && $Self->{FilterContent}->{ActiveElementFilter} ) {
        $Self->{BrowserJavaScriptSupport} = 0;
    }
    else {
        $Self->{BrowserJavaScriptSupport} = 1;
    }
    if ( !$ENV{HTTP_USER_AGENT} ) {
        $Self->{Browser} = 'Unknown - no $ENV{"HTTP_USER_AGENT"}';
    }
    elsif ( $ENV{HTTP_USER_AGENT} ) {

        # msie
        if (
            $ENV{HTTP_USER_AGENT} =~ /MSIE ([0-9.]+)/i
            || $ENV{HTTP_USER_AGENT} =~ /Internet Explorer\/([0-9.]+)/i
            )
        {
            $Self->{Browser}     = 'MSIE';
            $Self->{BrowserWrap} = 'physical';

            # For IE 5.5, we break the header in a special way that makes
            # things work. I don't really want to know.
            if ( $1 =~ /(\d)\.(\d)/ ) {
                $Self->{BrowserMajorVersion} = $1;
                $Self->{BrowserMinorVersion} = $2;
                if ( $1 == 5 && $2 == 5 || $1 == 6 && $2 == 0 || $1 == 7 && $2 == 0 ) {
                    $Self->{BrowserBreakDispositionHeader} = 1;
                }
            }
        }

        # mozilla
        elsif ( $ENV{HTTP_USER_AGENT} =~ /^mozilla/i ) {
            $Self->{Browser}     = 'Mozilla';
            $Self->{BrowserWrap} = 'hard';
        }

        # opera
        elsif ( $ENV{HTTP_USER_AGENT} =~ /^opera.*/i ) {
            $Self->{Browser}     = 'Opera';
            $Self->{BrowserWrap} = 'hard';
        }

        # safari
        elsif ( $ENV{HTTP_USER_AGENT} =~ /safari/i ) {
            $Self->{Browser}     = 'Safari';
            $Self->{BrowserWrap} = 'hard';
        }

        # netscape
        elsif ( $ENV{HTTP_USER_AGENT} =~ /netscape/i ) {
            $Self->{Browser}     = 'Netscape';
            $Self->{BrowserWrap} = 'hard';
        }

        # konqueror
        elsif ( $ENV{HTTP_USER_AGENT} =~ /konqueror/i ) {
            $Self->{Browser}     = 'Konqueror';
            $Self->{BrowserWrap} = 'hard';
        }

        # w3m
        elsif ( $ENV{'HTTP_USER_AGENT'} =~ /^w3m.*/i ) {
            $Self->{Browser}                  = 'w3m';
            $Self->{BrowserJavaScriptSupport} = 0;
        }

        # lynx
        elsif ( $ENV{HTTP_USER_AGENT} =~ /^lynx.*/i ) {
            $Self->{Browser}                  = 'Lynx';
            $Self->{BrowserJavaScriptSupport} = 0;
        }

        # links
        elsif ( $ENV{HTTP_USER_AGENT} =~ /^links.*/i ) {
            $Self->{Browser} = 'Links';
        }
        else {
            $Self->{Browser} = 'Unknown - ' . $ENV{'HTTP_USER_AGENT'};
        }
    }

    # load theme
    my $Theme = $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme') || 'Standard';

    # force a theme based on host name
    if ( $Self->{ConfigObject}->Get('DefaultTheme::HostBased') && $ENV{HTTP_HOST} ) {
        for ( sort keys %{ $Self->{ConfigObject}->Get('DefaultTheme::HostBased') } ) {
            if ( $ENV{HTTP_HOST} =~ /$_/i ) {
                $Theme = $Self->{ConfigObject}->Get('DefaultTheme::HostBased')->{$_};
            }
        }
    }

    # locate template files
    $Self->{TemplateDir} = $Self->{ConfigObject}->Get('TemplateDir') . '/HTML/' . $Theme;
    if ( !-e $Self->{TemplateDir} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "No existing template directory found ('$Self->{TemplateDir}')! Check your Home in Kernel/Config.pm",
        );
        $Self->FatalDie();
    }

    # define $Env{"Images"}
    $Self->{Images} = $Self->{ConfigObject}->Get('Frontend::ImagePath');

    # load sub layout files
    my $Dir = $Self->{ConfigObject}->Get('TemplateDir') . '/HTML/';
    if ( -e $Dir ) {
        my @Files = glob("$Dir/Layout*.pm");
        for my $File (@Files) {
            if ( $File !~ /Layout.pm$/ ) {
                $File =~ s/^.*\/(.+?).pm$/$1/g;
                if ( !$Self->{MainObject}->Require("Kernel::Output::HTML::$File") ) {
                    $Self->FatalError();
                }
                push @ISA, "Kernel::Output::HTML::$File";
            }
        }
    }

    return $Self;
}

sub SetEnv {
    my ( $Self, %Param ) = @_;

    for (qw(Key Value)) {
        if ( !defined( $Param{$_} ) ) {
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
            Time => $Row[0],
            Priority => $Row[1],
            Facility => $Row[2],
            Message => $Row[3],
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

sub _BlockTemplatePreferences {
    my ( $Self, %Param ) = @_;

    my %TagsOpen       = ();
    my @Preferences    = ();
    my $LastLayerCount = 0;
    my $Layer          = 0;
    my $LastLayer      = '';
    my $CurrentLayer   = '';
    my %UsedNames      = ();
    my $TemplateFile   = $Param{TemplateFile} || '';
    if ( !defined( $Param{Template} ) ) {
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
    for ( keys %TagsOpen ) {
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

    my %BlockLayer     = ();
    my %BlockTemplates = ();
    my @BR             = ();
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
    if ( $Self->{BlockData} && %BlockTemplates ) {
        my @NotUsedBlockData = ();
        for my $Block ( @{ $Self->{BlockData} } ) {
            if ( $BlockTemplates{ $Block->{Name} } ) {
                push(
                    @BR,
                    {
                        Layer => $BlockLayer{ $Block->{Name} },
                        Name  => $Block->{Name},
                        Data  => $Self->_Output(
                            Template => "<!--start $Block->{Name}-->"
                                . $BlockTemplates{ $Block->{Name} }
                                . "<!--stop $Block->{Name} -->",
                            Data => $Block->{Data},
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

=item Output()

use a dtl template and get html back

    my $HTML = $LayoutObject->Output(
        TemplateFile => 'AdminLog',
        Data => \%Param,
    );

=cut

sub Output {
    my ( $Self, %Param ) = @_;

    # get and check param Data
    if ( $Param{Data} ) {
        if ( ref( $Param{Data} ) ne 'HASH' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need HashRef in Param Data! Got: '" . ref( $Param{Data} ) . "'!",
            );
            $Self->FatalError();
        }
    }
    else {
        $Param{Data} = {};
    }

    # fill init Env
    if ( !$Self->{EnvRef} ) {
        %{ $Self->{EnvRef} } = %ENV;

        # all $Self->{*}
        for ( keys %{$Self} ) {
            if ( defined( $Self->{$_} ) && !ref( $Self->{$_} ) ) {
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

    # read template from filesystem
    my $TemplateString = '';
    if ( $Param{TemplateFile} ) {
        my $File = '';
        if ( -f "$Self->{TemplateDir}/$Param{TemplateFile}.dtl" ) {
            $File = "$Self->{TemplateDir}/$Param{TemplateFile}.dtl";
        }
        else {
            $File = "$Self->{TemplateDir}/../Standard/$Param{TemplateFile}.dtl";
        }
        if ( open my $TEMPLATEIN, '<', $File ) {
            $TemplateString = do { local $/; <$TEMPLATEIN> };
            close $TEMPLATEIN;

            # filtering of comment lines
            $TemplateString =~ s/^#.*\n//gm;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't read $File: $!",
            );
        }
    }
    elsif ( defined( $Param{Template} ) && ref( $Param{Template} ) eq 'ARRAY' ) {
        for ( @{ $Param{Template} } ) {
            $TemplateString .= $_;
        }
    }
    elsif ( defined( $Param{Template} ) ) {
        $TemplateString = $Param{Template};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Template or TemplateFile Param!',
        );
        $Self->FatalError();
    }
    my $Output = $Self->_Output(
        Template     => $TemplateString,
        Data         => $Param{Data},
        BlockReplace => 1,
        TemplateFile => $Param{TemplateFile} || '',
    );

    return $Output;
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

    # custom pre filters
    if ( $Self->{FilterElementPre} ) {
        my %Filters = %{ $Self->{FilterElementPre} };
        for my $Filter ( sort keys %Filters ) {
            if ( $Self->{MainObject}->Require( $Filters{$Filter}->{Module} ) ) {
                my $Object = $Filters{$Filter}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    MainObject   => $Self->{MainObject},
                    LogObject    => $Self->{LogObject},
                    Debug        => $Self->{Debug},
                    LayoutObject => $Self,
                );

                # run module
                $Object->Run(
                    %{ $Filters{$Filter} },
                    Data         => \$TemplateString,
                    TemplateFile => $Param{TemplateFile},
                );
            }
            else {
                $Self->FatalDie();
            }
        }
    }

    # parse/get text blocks
    my @BR = $Self->_BlockTemplatesReplace(
        Template => \$TemplateString,
        TemplateFile => $Param{TemplateFile} || '',
    );
    my $ID        = 0;
    my %LayerHash = ();
    my $OldLayer  = 1;
    for my $Block (@BR) {

        # reset layer counter if we switched on layer lower
        if ( $Block->{Layer} > $OldLayer ) {
            $LayerHash{ $Block->{Layer} } = 0;
        }

        # count current layer
        $LayerHash{ $Block->{Layer} }++;

        # create current id (1:2:3)
        undef $ID;
        for ( my $i = 1; $i <= $Block->{Layer}; $i++ ) {
            if ( defined($ID) ) {
                $ID .= ':';
            }
            if ( defined( $LayerHash{$i} ) ) {
                $ID .= $LayerHash{$i};
            }
        }

        # add block counter to template blocks
        if ( $Block->{Layer} == 1 ) {
            $TemplateString =~ s{
                (<!--\s{0,1}dtl:place_block:$Block->{Name})(\s{0,1}-->)
            }
            {
                "$1:".$LayerHash{$Block->{Layer}}.$2;
            }segxm;
        }

        # add block counter to in block blocks
        $Block->{Data} =~ s{
            (<!--\s{0,1}dtl:place_block:.+?)(\s{0,1}-->)
        }
        {
            "$1:$ID:-$2";
        }segxm;

        # count up place_block counter
        $ID =~ s/^(.*:)(\d+)$/$1-/g;

        my $NewID = '';
        if ( $ID =~ /^(.*:)(\d+)$/ ) {
            $NewID = $1 . ( $2 + 1 );
        }
        elsif ( $ID =~ /^(\d+)$/ ) {
            $NewID = ( $1 + 1 );
        }
        elsif ( $ID =~ /^(.*:)-$/ ) {
            $NewID = $ID;
        }

        $TemplateString =~ s{
            <!--\sdtl:place_block:$Block->{Name}:$ID\s-->
        }
        {
            $Block->{Data}<!-- dtl:place_block:$Block->{Name}:$NewID -->
        }sxm;
        $OldLayer = $Block->{Layer};
    }

    # remove empty blocks and block preferences
    if ( $Param{BlockReplace} ) {
        $TemplateString =~ s{ <!--\s{0,1}dtl:place_block:.+?\s{0,1}--> }{}sgxm;
    }

    # process template
    my $Output = '';
    for my $Line ( split( /\n/, $TemplateString ) ) {

        #        # add missing new line (striped from split)
        #        $Line .= "\n";
        if ( $Line =~ /<dtl/ ) {

            # do template set (<dtl set $Data{"adasd"} = "lala">)
            # do system call (<dtl system-call $Data{"adasd"} = "uptime">)
            $Line =~ s{
                <dtl\W(system-call|set)\W\$(Data|Env|Config)\{\"(.+?)\"\}\W=\W\"(.+?)\">
            }
            {
                my $Data = '';
                if ($1 eq 'set') {
                    $Data = $4;
                }
                else {
                    open (SYSTEM, " $4 | ") || print STDERR "Can't open $4: $!";
                    while (<SYSTEM>) {
                        $Data .= $_;
                    }
                    close (SYSTEM);
                }

                $GlobalRef->{$2}->{$3} = $Data;
                # output replace with nothing!
                '';
            }egx;

            # do template if dynamic
            $Line =~ s{
                <dtl\Wif\W\(\$(Env|Data|Text|Config)\{\"(.*)\"\}\W(eq|ne|=~|!~)\W\"(.*)\"\)\W\{\W\$(Data|Env|Text)\{\"(.*)\"\}\W=\W\"(.*)\";\W\}>
            }
            {
                my $Type = $1 || '';
                my $TypeKey = $2 || '';
                my $Con = $3 || '';
                my $ConVal = defined $4 ? $4 : '';
                my $IsType = $5 || '';
                my $IsKey = $6 || '';
                my $IsValue = $7 || '';
                # do ne actions
                if ($Type eq 'Text') {
                    my $Tmp = $Self->{LanguageObject}->Get($TypeKey) || '';
                    if (eval '($Tmp '.$Con.' $ConVal)') {
                        $GlobalRef->{$IsType}->{$IsKey} = $IsValue;
                        # output replace with nothing!
                        '';
                    }
                }
                elsif ($Type eq 'Env' || $Type eq 'Data') {
                    my $Tmp = $GlobalRef->{$Type}->{$TypeKey};
                    if (!defined($Tmp)) {
                        $Tmp = '';
                    }
                    if (eval '($Tmp '.$Con.' $ConVal)') {
                        $GlobalRef->{$IsType}->{$IsKey} = $IsValue;
                        # output replace with nothing!
                        '';
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                elsif ($Type eq 'Config') {
                    my $Tmp = $Self->{ConfigObject}->Get($TypeKey);
                    if (defined($Tmp) && eval '($Tmp '.$Con.' $ConVal)') {
                        $GlobalRef->{$IsType}->{$IsKey} = $IsValue;
                        '';
                    }
                }
            }egx;
        }

        # variable & env & config replacement (three times)
        my $Regexp = 1;
        while ($Regexp) {
            $Regexp = $Line =~ s{
                \$((?:|Q|LQ|)Data|(?:|Q)Env|Config|Include){"(.+?)"}
            }
            {
                if ($1 eq 'Data' || $1 eq 'Env') {
                    if (defined $GlobalRef->{$1}->{$2}) {
                        $GlobalRef->{$1}->{$2};
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                elsif ($1 eq 'QEnv') {
                    my $Text = $2;
                    if (!defined($Text) || $Text =~ /^","(.+)$/) {
                        '';
                    }
                    elsif ($Text =~ /^(.+?)","(.+)$/) {
                        if (defined $GlobalRef->{Env}->{$1}) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Env}->{$1}, Max => $2);
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                    else {
                        if (defined $GlobalRef->{Env}->{$Text}) {
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
                    if (!defined($Text) || $Text =~ /^","(.+)$/) {
                        '';
                    }
                    elsif ($Text =~ /^(.+?)","(.+)$/) {
                        if (defined $GlobalRef->{Data}->{$1}) {
                            $Self->Ascii2Html(Text => $GlobalRef->{Data}->{$1}, Max => $2);
                        }
                        else {
                            # output replace with nothing!
                            '';
                        }
                    }
                    else {
                        if (defined $GlobalRef->{Data}->{$Text}) {
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
                    if (defined $GlobalRef->{Data}->{$2}) {
                        $Self->LinkEncode($GlobalRef->{Data}->{$2});
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                # replace with
                elsif ($1 eq 'Config') {
                    if (defined $Self->{ConfigObject}->Get($2)) {
                        $Self->{ConfigObject}->Get($2);
                    }
                    else {
                        # output replace with nothing!
                        '';
                    }
                }
                # include dtl files
                elsif ($1 eq 'Include') {
                    $Param{TemplateFile} = $2;
                    $Self->Output(%Param);
                }
            }egx;
        }

        # add this line to output
        $Output .= $Line . "\n";
    }
    chomp $Output;

    # do time translation (with seconds)
    $Output =~ s{
        \$TimeLong({"(.+?)"}|{""})
    }
    {
        if (defined($2)) {
            $Self->{LanguageObject}->FormatTimeString($2);
        }
        else {
            '';
        }
    }egx;

    # do time translation (without seconds)
    $Output =~ s{
        \$TimeShort({"(.+?)"}|{""})
    }
    {
        if (defined($2)) {
            $Self->{LanguageObject}->FormatTimeString($2, undef, 'NoSeconds');
        }
        else {
            '';
        }
    }egx;

    # do date translation
    $Output =~ s{
        \$Date({"(.+?)"}|{""})
    }
    {
        $Self->{LanguageObject}->FormatTimeString($2, 'DateFormatShort');
    }egx;

    # do translation
    for ( 1 .. 2 ) {
        $Output =~ s{
            \$Text({"(.+?)"}|{""})
        }
        {
            if (defined($2)) {
                $Self->Ascii2Html(
                    Text => $Self->{LanguageObject}->Get($2),
                );
            }
            else {
                '';
            }
        }egx;
    }

    $Output =~ s{
        \$JSText({"(.+?)"}|{""})
    }
    {
        if (defined($2)) {
            $Self->Ascii2Html(
                Text => $Self->{LanguageObject}->Get($2),
                Type => 'JSText',
            );
        }
        else {
            '';
        }
    }egx;

    # do html quote
    $Output =~ s{
        \$Quote({"(.+?)"}|{""})
    }
    {
        my $Text = $2;
        if (!defined($Text) || $Text =~ /^","(.+)$/) {
            '';
        }
        elsif ($Text =~ /^(.+?)","(.+)$/) {
            $Self->Ascii2Html(Text => $1, Max => $2);
        }
        else {
            $Self->Ascii2Html(Text => $Text);
        }
    }egx;

    # Check if the browser sends the session id cookie!
    # If not, add the session id to the links and forms!
    if ( !$Self->{SessionIDCookie} ) {

        # rewrite a hrefs
        $Output =~ s{
            (<a.+?href=")(.+?)(\#.+?|)(">|".+?>)
        }
        {
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            my $RealEnd = $4;
            if ($Target =~ /^(http:|https:|#|ftp:)/i ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/ ||
                $Target =~ /(\?|&)\Q$Self->{SessionName}\E=/) {
                $AHref.$Target.$End.$RealEnd;
            }
            else {
                $AHref.$Target.'&'.$Self->{SessionName}.'='.$Self->{SessionID}.$End.$RealEnd;
            }
        }iegx;

        # rewrite img src
        $Output =~ s{
            (<img.+?src=")(.+?)(">|".+?>)
        }
        {
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            if ($Target =~ /^(http:|https:)/i || !$Self->{SessionID} ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/ ||
                $Target =~ /\Q$Self->{SessionName}\E/) {
                $AHref.$Target.$End;
            }
            else {
                $AHref.$Target.'&'.$Self->{SessionName}.'='.$Self->{SessionID}.$End;
            }
        }iegx;

        # rewrite forms: <form action="index.pl" method="get">
        $Output =~ s{
            (<form.+?action=")(.+?)(">|".+?>)
        }
        {
            my $Start  = "$1";
            my $Target = $2;
            my $End    = "$3";
            if ($Target =~ /^(http:|https:)/i || !$Self->{SessionID}) {
                $Start.$Target.$End;
            }
            else {
                $Start.$Target.$End."<input type=\"hidden\" name=\"$Self->{SessionName}\" value=\"$Self->{SessionID}\"/>";
            }
        }iegx;
    }

    # do correct direction
    if (
        $Self->{LanguageObject}->{TextDirection}
        && $Self->{LanguageObject}->{TextDirection} eq 'rtl'
        )
    {
        $Output =~ s{
            <(table.+?)>
        }
        {
            my $Table = $1;
            if ($Table !~ /dir=/) {
                "<$Table dir=\"".$Self->{LanguageObject}->{TextDirection}."\">";
            }
            else {
                "<$Table>";
            }
        }iegx;
        $Output =~ s{
            align="(left|right)"
        }
        {
            if ($1 =~ /left/i) {
                "align=\"right\"";
            }
            else {
                "align=\"left\"";
            }
        }iegx;
    }

    # custom post filters
    if ( $Self->{FilterElementPost} ) {
        my %Filters = %{ $Self->{FilterElementPost} };
        for my $Filter ( sort keys %Filters ) {
            if ( $Self->{MainObject}->Require( $Filters{$Filter}->{Module} ) ) {
                my $Object = $Filters{$Filter}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    MainObject   => $Self->{MainObject},
                    LogObject    => $Self->{LogObject},
                    Debug        => $Self->{Debug},
                    LayoutObject => $Self,
                );

                # run module
                $Object->Run(
                    %{ $Filters{$Filter} },
                    Data         => \$Output,
                    TemplateFile => $Param{TemplateFile},
                );
            }
            else {
                $Self->FatalDie();
            }
        }
    }
    $Self->{OutputCount} = 0;

    # return output
    return $Output;
}

=item Redirect()

return html for browser to redirect

    my $HTML = $LayoutObject->Redirect(
        OP => "Action=AdminUserGroup&Subaction=User&ID=$UserID",
    );

    my $HTML = $LayoutObject->Redirect(
        ExtURL => "http://some.example.com/",
    );

=cut

sub Redirect {
    my ( $Self, %Param ) = @_;

    my $SessionIDCookie = '';
    my $Cookies         = '';

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( keys %{ $Self->{SetCookies} } ) {
            $Cookies .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # create & return output
    if ( $Param{ExtURL} ) {

        # external redirect
        $Param{Redirect} = $Param{ExtURL};
        return $Cookies . $Self->Output( TemplateFile => 'Redirect', Data => \%Param );
    }

    # internal redirect
    $Param{OP} =~ s/^.*\?(.+?)$/$1/;
    $Param{Redirect} = $Self->{Baselink} . $Param{OP};

    # check if IIS is used, add absolute url for IIS workaround
    # see also:
    #  o http://bugs.otrs.org/show_bug.cgi?id=2230
    #  o http://support.microsoft.com/default.aspx?scid=kb;en-us;221154
    if ( $ENV{SERVER_SOFTWARE} =~ /^microsoft\-iis/i ) {
        my $Host = $ENV{HTTP_HOST} || $Self->{ConfigObject}->Get('FQDN');
        $Param{Redirect}
            = $Self->{ConfigObject}->Get('HttpType') . '://' . $Host . '/' . $Param{Redirect};
    }
    my $Output = $Cookies . $Self->Output( TemplateFile => 'Redirect', Data => \%Param );
    if ( !$Self->{SessionIDCookie} ) {

        # rewrite location header
        $Output =~ s{
            (location: )(.*)
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

    my $Output = '';

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # get message of the day
    if ( $Self->{ConfigObject}->Get('ShowMotd') ) {
        $Param{"Motd"} = $Self->Output( TemplateFile => 'Motd', Data => \%Param );
    }

    # get language options
    $Param{Language} = $Self->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
        Name       => 'Lang',
        SelectedID => $Self->{UserLanguage},
        OnChange   => 'submit()',
        HTMLQuote  => 0,
    );

    # get lost password y
    if (
        $Self->{ConfigObject}->Get('LostPassword')
        && $Self->{ConfigObject}->Get('AuthModule') eq 'Kernel::System::Auth::DB'
        )
    {
        $Self->Block(
            Name => 'LostPassword',
            Data => \%Param,
        );
    }

    # create & return output
    $Output .= $Self->Output( TemplateFile => 'Login', Data => \%Param );
    return $Output;
}

sub FatalError {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$Param{Message}",
        );
    }
    my $Output = $Self->Header( Area => 'Frontend', Title => 'Fatal Error' );
    $Output .= $Self->Error(%Param);
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
        $Param{$Backend} = $Self->Ascii2Html(
            Text           => $Param{$Backend},
            HTMLResultMode => 1,
        );
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
            $Param{$Backend} = $Self->Ascii2Html(
                Text           => $Param{$Backend},
                HTMLResultMode => 1,
            );
        }
    }
    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }
    $Param{Message} =~ s/^(.{80}).*$/$1\[\.\.\]/gs;

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
    $Param{BackendMessage} = $Self->Ascii2Html(
        Text           => $Param{BackendMessage},
        HTMLResultMode => 1,
    );

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
        Priority => 'warning'
        Info => 'Some Info Message',
    );

    data with link, the text will be translated

    my $Output = $LayoutObject->Notify(
        Priority => 'warning'
        Data => '$Text{"Some DTL Stuff"}',
        Link => 'http://example.com/',
    );

    errors, the text will be translated

    my $Output = $LayoutObject->Notify(
        Priority => 'error'
        Info => 'Some Error Message',
    );

    errors from log backend, if no error extists, a '' will be returned

    my $Output = $LayoutObject->Notify(
        Priority => 'error'
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
        return if !$Param{Info};
    }
    if ( $Param{Info} ) {
        $Param{Info} =~ s/\n//g;
    }
    if ( $Param{Priority} && $Param{Priority} eq 'Error' ) {
        $Self->Block(
            Name => 'Error',
            Data => {},
        );
    }
    else {
        $Self->Block(
            Name => 'Warning',
            Data => {},
        );
    }
    if ( $Param{Link} ) {
        $Self->Block(
            Name => 'LinkStart',
            Data => { LinkStart => $Param{Link}, },
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
    return $Self->Output( TemplateFile => 'Notify', Data => \%Param );
}

sub Header {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    my $Type = $Param{Type} || '';

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( keys %{ $Self->{SetCookies} } ) {
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
    for my $Word (qw(Area Title Value)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= ' :: ' . $Self->{LanguageObject}->Get( $Param{$Word} );
        }
    }

    # run header meta modules
    my $HeaderMetaModule = $Self->{ConfigObject}->Get('Frontend::HeaderMetaModule');
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

    # create & return output
    $Output .= $Self->Output( TemplateFile => "Header$Type", Data => \%Param );
    return $Output;
}

sub Footer {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || '';

    # unless explicitly specified, we set the footer width to use the whole space
    if ( !$Param{Width} ) {
        $Param{Width} = '100%';
    }

    # create & return output
    return $Self->Output( TemplateFile => "Footer$Type", Data => \%Param );
}

sub Print {
    my ( $Self, %Param ) = @_;

    # custom post filters
    if ( $Self->{FilterContent} ) {
        my %Filters = %{ $Self->{FilterContent} };
        for my $Filter ( sort keys %Filters ) {
            if ( $Self->{MainObject}->Require( $Filters{$Filter}->{Module} ) ) {
                my $Object = $Filters{$Filter}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    MainObject   => $Self->{MainObject},
                    LogObject    => $Self->{LogObject},
                    Debug        => $Self->{Debug},
                    LayoutObject => $Self,
                );

                # run module
                $Object->Run(
                    %{ $Filters{$Filter} },
                    Data         => $Param{Output},
                    TemplateFile => $Param{TemplateFile},
                );
            }
            else {
                $Self->FatalDie();
            }
        }
    }
    print ${ $Param{Output} };
}

sub PrintHeader {
    my ( $Self, %Param ) = @_;

    # unless explicitly specified, we set the header width
    if ( !$Param{Width} ) {
        $Param{Width} = 640;
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
    for my $Word (qw(Area Title Value)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= " :: " . $Self->{LanguageObject}->Get( $Param{$Word} );
        }
    }

    # create & return output
    return $Self->Output( TemplateFile => 'PrintHeader', Data => \%Param );
}

sub PrintFooter {
    my ( $Self, %Param ) = @_;

    $Param{Host} = $Self->Ascii2Html( Text => $ENV{SERVER_NAME} . $ENV{REQUEST_URI}, );
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

=cut

sub Ascii2Html {
    my ( $Self, %Param ) = @_;

    my $Max             = $Param{Max}             || '';
    my $VMax            = $Param{VMax}            || '';
    my $NewLine         = $Param{NewLine}         || '';
    my $HTMLMode        = $Param{HTMLResultMode}  || '';
    my $StripEmptyLines = $Param{StripEmptyLines} || '';
    my $Type            = $Param{Type}            || '';

    return if !defined $Param{Text};

    # check ref
    my $TextScalar;
    my $Text;
    if ( !ref $Param{Text} ) {
        $TextScalar = 1;
        $Text       = \$Param{Text};
    }
    else {
        $Text = $Param{Text};
    }

    my @Filters = ();
    if ( $Param{LinkFeature} && $Self->{FilterText} ) {
        my %Filters = %{ $Self->{FilterText} };
        for my $Filter ( sort keys %Filters ) {

            # load module
            my $Object = $Filters{$Filter}->{Module};
            if ( !$Self->{FilterTextObject}->{$Object} ) {
                if ( !$Self->{MainObject}->Require( $Filters{$Filter}->{Module} ) ) {
                    $Self->FatalDie();
                }
                $Self->{FilterTextObject}->{$Object} = $Filters{$Filter}->{Module}->new(
                    %{$Self},
                    LayoutObject => $Self,
                );
            }
            push(
                @Filters,
                {
                    Object => $Self->{FilterTextObject}->{$Object},
                    Filter => $Filters{$Filter}
                },
            );
        }

        # pre run
        for my $Filter (@Filters) {
            $Text = $Filter->{Object}->Pre( Filter => $Filter->{Filter}, Data => $Text );
        }
    }

    # max width
    if ($Max) {
        ${$Text} =~ s/^(.{$Max}).+?$/$1\[\.\.\]/gs;
    }

    # newline
    if ( $NewLine && length($Text) < 60_000 ) {
        ${$Text} =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
        ${$Text} =~ s/\r/\n/g;
        ${$Text} =~ s/(.{4,$NewLine})(?:\s|\z)/$1\n/gm;
        my $ForceNewLine = $NewLine + 10;
        ${$Text} =~ s/(.{$ForceNewLine})(.+?)/$1\n$2/g;
    }

    # remove taps
    ${$Text} =~ s/\t/ /g;

    # strip empty lines
    if ($StripEmptyLines) {
        ${$Text} =~ s/^\s*\n//mg;
    }

    # max lines
    if ($VMax) {
        my @TextList = split( "\n", ${$Text} );
        ${$Text} = '';
        my $Counter = 1;
        for (@TextList) {
            if ( $Counter <= $VMax ) {
                ${$Text} .= $_ . "\n";
            }
            $Counter++;
        }
        if ( $Counter >= $VMax ) {
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
            $Text = $Filter->{Object}->Post( Filter => $Filter->{Filter}, Data => $Text );
        }
    }

    if ($HTMLMode) {
        ${$Text} =~ s/\n/<br\/>\n/g;
        ${$Text} =~ s/  /&nbsp;&nbsp;/g;
    }
    if ( $Type eq 'JSText' ) {
        ${$Text} =~ s/'/\\'/g;
    }

    # check ref && return result like called
    if ( defined $TextScalar ) {
        return ${$Text};
    }
    else {
        return $Text;
    }
}

=item LinkQuote()

so some URL link detections

    my $HTMLWithLinks = $LayoutObject->LinkQuote(
        Text => $HTMLWithOutLinks,
    );

=cut

sub LinkQuote {
    my ( $Self, %Param ) = @_;

    my $Text   = $Param{Text}   || '';
    my $Target = $Param{Target} || 'NewPage' . int( rand(199) );

    # check ref
    my $TextScalar;
    if ( !ref($Text) ) {
        $TextScalar = $Text;
        $Text       = \$TextScalar;
    }

    my @Filters = ();
    if ( $Self->{FilterText} ) {
        my %Filters = %{ $Self->{FilterText} };
        for my $Filter ( sort keys %Filters ) {
            if ( $Self->{MainObject}->Require( $Filters{$Filter}->{Module} ) ) {
                my $Object = $Filters{$Filter}->{Module}->new( %{$Self} );

                # run module
                if ($Object) {
                    push( @Filters, { Object => $Object, Filter => $Filters{$Filter} } );
                }
            }
            else {
                $Self->FatalDie();
            }
        }
    }
    for my $Filter (@Filters) {
        $Text = $Filter->{Object}->Pre( Filter => $Filter->{Filter}, Data => $Text );
    }
    for my $Filter (@Filters) {
        $Text = $Filter->{Object}->Post( Filter => $Filter->{Filter}, Data => $Text );
    }

    # do mail to quote
    ${$Text} =~ s/(mailto:.*?)(\.\s|\s|\)|\"|]|')/<a href=\"$1\">$1<\/a>$2/gi;

    # check ref && return result like called
    if ($TextScalar) {
        return ${$Text};
    }
    else {
        return $Text;
    }
}

=item LinkEncode()

do some url encoding - e. g. replace + with %2B in links

    my $URLEncoded = $LayoutObject->LinkEncode($URL);

=cut

sub LinkEncode {
    my ( $Self, $Link ) = @_;

    return if !defined($Link);

    $Link =~ s/&/%26/g;
    $Link =~ s/=/%3D/g;
    $Link =~ s/\!/%21/g;
    $Link =~ s/"/%22/g;
    $Link =~ s/\#/%23/g;
    $Link =~ s/\$/%24/g;
    $Link =~ s/'/%27/g;
    $Link =~ s/\+/%2B/g;
    $Link =~ s/\?/%3F/g;
    $Link =~ s/\|/%7C/g;
    $Link =~ s/§/\%A7/g;
    $Link =~ s/ /\+/g;
    return $Link;
}

sub CustomerAgeInHours {
    my ( $Self, %Param ) = @_;

    my $Age = defined( $Param{Age} ) ? $Param{Age} : return;
    my $Space = $Param{Space} || '<br/>';
    my $AgeStrg = '';
    if ( $Age =~ /^-(.*)/ ) {
        $Age     = $1;
        $AgeStrg = '-';
    }

    # get hours
    if ( $Age >= 3600 ) {
        $AgeStrg .= int( ( $Age / 3600 ) ) . ' ';
        if ( int( ( $Age / 3600 ) % 24 ) > 1 ) {
            $AgeStrg .= $Self->{LanguageObject}->Get('hours');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('hour');
        }
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $Age <= 3600 || int( ( $Age / 60 ) % 60 ) ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        if ( int( ( $Age / 60 ) % 60 ) > 1 ) {
            $AgeStrg .= $Self->{LanguageObject}->Get('minutes');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('minute');
        }
    }
    return $AgeStrg;
}

sub CustomerAge {
    my ( $Self, %Param ) = @_;

    my $Age = defined( $Param{Age} ) ? $Param{Age} : return;
    my $Space = $Param{Space} || '<br/>';
    my $AgeStrg = '';
    if ( $Age =~ /^-(.*)/ ) {
        $Age     = $1;
        $AgeStrg = '-';
    }

    # get days
    if ( $Age >= 86400 ) {
        $AgeStrg .= int( ( $Age / 3600 ) / 24 ) . ' ';
        if ( int( ( $Age / 3600 ) / 24 ) > 1 ) {
            $AgeStrg .= $Self->{LanguageObject}->Get('days');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('day');
        }
        $AgeStrg .= $Space;
    }

    # get hours
    if ( $Age >= 3600 ) {
        $AgeStrg .= int( ( $Age / 3600 ) % 24 ) . ' ';
        if ( int( ( $Age / 3600 ) % 24 ) > 1 ) {
            $AgeStrg .= $Self->{LanguageObject}->Get('hours');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('hour');
        }
        $AgeStrg .= $Space;
    }

    # get minutes (just if age < 1 day)
    if ( $Self->{ConfigObject}->Get('TimeShowAlwaysLong') || $Age < 86400 ) {
        $AgeStrg .= int( ( $Age / 60 ) % 60 ) . ' ';
        if ( int( ( $Age / 60 ) % 60 ) > 1 ) {
            $AgeStrg .= $Self->{LanguageObject}->Get('minutes');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('minute');
        }
    }
    return $AgeStrg;
}

# OptionStrgHashRef()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.

sub OptionStrgHashRef {
    my ( $Self, %Param ) = @_;

    my $Output     = '';
    my $Name       = $Param{Name} || '';
    my $Max        = $Param{Max} || 80;
    my $Multiple   = $Param{Multiple} ? 'multiple' : '';
    my $HTMLQuote  = defined( $Param{HTMLQuote} ) ? $Param{HTMLQuote} : 1;
    my $LT         = defined( $Param{LanguageTranslation} ) ? $Param{LanguageTranslation} : 1;
    my $Selected   = defined( $Param{Selected} ) ? $Param{Selected} : '-not-possible-to-use-';
    my $SelectedID = defined( $Param{SelectedID} ) ? $Param{SelectedID} : '-not-possible-to-use-';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $PossibleNone       = $Param{PossibleNone} || '';
    my $SortBy             = $Param{SortBy} || 'Value';
    my $Size               = $Param{Size} || '';
    $Size = "size=$Size" if ($Size);

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
        $Param{OnChange} = "AJAXUpdate('" . $Param{Ajax}->{Subaction} . "', "
            . " '$Name',"
            . "['"
            . join( "', '", @{ $Param{Ajax}->{Depend} } ) . "'], ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    # check data
    if ( !$Param{Data} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no Data Param ref in OptionStrgHashRef()!',
        );
        $Self->FatalError();
    }
    elsif ( ref( $Param{Data} ) ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need HashRef in Param Data! Got: '" . ref( $Param{Data} ) . "'!",
        );
        $Self->FatalError();
    }
    my %Data    = %{ $Param{Data} };
    my $OnStuff = '';
    if ( $Param{OnChangeSubmit} ) {
        $OnStuff .= ' onchange="submit()" ';
    }
    if ( $Param{OnChange} ) {
        $OnStuff = " onchange=\"$Param{OnChange}\" ";
    }
    if ( $Param{OnClick} ) {
        $OnStuff = " onclick=\"$Param{OnClick}\" ";
    }

    # set default value
    my $NoSelectedDataGiven = 0;
    if ( $Selected eq '-not-possible-to-use-' && $SelectedID eq '-not-possible-to-use-' ) {
        $NoSelectedDataGiven = 1;
    }
    if ( ( $Name eq 'ValidID' || $Name eq 'Valid' ) && $NoSelectedDataGiven ) {
        $Selected = $Self->{ConfigObject}->Get('DefaultValid');
    }
    elsif ( ( $Name eq 'LanguageID' || $Name eq 'Language' ) && $NoSelectedDataGiven ) {
        $Selected = $Self->{ConfigObject}->Get('DefaultLanguage');
    }
    elsif ( ( $Name eq 'ThemeID' || $Name eq 'Theme' ) && $NoSelectedDataGiven ) {
        $Selected = $Self->{ConfigObject}->Get('DefaultTheme');
    }
    elsif ( ( $Name eq 'LanguageID' || $Name eq 'Language' ) && $NoSelectedDataGiven ) {
        $Selected = $Self->{ConfigObject}->Get('DefaultLanguage');
    }

    #    elsif ($NoSelectedDataGiven) {
    #        # else set 1?
    #        $SelectedID = 1;
    #    }
    # build select string
    $Output .= "<select name=\"$Name\" $Multiple $OnStuff $Size>\n";
    if ($PossibleNone) {
        $Output .= '<option VALUE="">-$Text{"none"}-</option>';
    }

    # hash cleanup
    for ( keys %Data ) {
        if ( !defined( $Data{$_} ) ) {
            delete $Data{$_};
        }
    }

    my @Order = ();
    if ( $SortBy eq 'Key' ) {
        for ( sort keys %Data ) {
            push @Order, $_;
        }
    }
    else {
        for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
            push @Order, $_;
        }
    }
    for (@Order) {
        if ( defined($_) && defined( $Data{$_} ) ) {

            # check if SelectedIDRefArray exists
            if ( $SelectedIDRefArray && ref($SelectedIDRefArray) eq 'ARRAY' ) {
                for my $ID ( @{$SelectedIDRefArray} ) {
                    if ( $ID eq $_ ) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }

            # build select string
            if ( $_ eq $SelectedID || $Data{$_} eq $Selected || $Param{SelectedIDRefArrayOK}->{$_} )
            {
                $Output .= '  <option selected value="' . $Self->Ascii2Html( Text => $_ ) . '">';
            }
            else {
                $Output .= '  <option value="' . $Self->Ascii2Html( Text => $_ ) . '">';
            }
            if ($LT) {
                $Data{$_} = $Self->{LanguageObject}->Get( $Data{$_} );
            }
            if ($HTMLQuote) {
                $Output .= $Self->Ascii2Html( Text => $Data{$_}, Max => $Max );
            }
            else {
                $Output .= $Data{$_};
            }
            $Output .= "</option>\n";
        }
    }
    $Output .= "</select><a id=\"AJAXImage$Name\"></a>\n";
    return $Output;
}

# OptionElement()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.
#
#
# build a html option element based on given data
#
#    my $HTML = $LayoutObject->OptionElement(
#        Name            => 'SomeParamName',
#        Data            => {
#            ParamA => {
#                Position    => 1,
#                Value       => 'Some Nice Text A',
#            },
#            ParamB => {
#                Position    => 2,
#                Value       => 'Some Nice Text B',
#                Selected    => 1,
#            },
#        },
#        # optional
#        Max             => 80, # max size of the shown value
#        Multiple        => 0, # 1|0
#        Size            => '', # option element size
#        HTMLQuote       => 1, # 1|0
#        PossibleNone    => 0, # 1|0 add a leading empty selection
#    );

sub OptionElement {
    my ( $Self, %Param ) = @_;

    my $Output       = '';
    my $Name         = $Param{Name} || '';
    my $Max          = $Param{Max} || 80;
    my $Multiple     = $Param{Multiple} ? 'multiple' : '';
    my $HTMLQuote    = defined( $Param{HTMLQuote} ) ? $Param{HTMLQuote} : 1;
    my $Translation  = defined( $Param{Translation} ) ? $Param{Translation} : 1;
    my $PossibleNone = $Param{PossibleNone} || '';
    my $Size         = $Param{Size} || '';
    $Size = "size=\"$Size\"" if ($Size);

    # check needed stuff
    for (qw(Name Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no Data Param ref in OptionStrgHashRef()!",
            );
            $Self->FatalError();
        }
    }
    if ( !$Param{Data} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Got no Data Param ref in OptionStrgHashRef()!",
        );
        $Self->FatalError();
    }
    elsif ( ref( $Param{Data} ) ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need HashRef in Param Data! Got: '" . ref( $Param{Data} ) . "'!",
        );
        $Self->FatalError();
    }

    # detect
    # $Param{Data}{Key}{Value}
    my $Hash2 = 0;
    for my $Key ( %{ $Param{Data} } ) {
        if ( ref( $Param{Data}->{$Key} ) eq 'HASH' ) {
            $Hash2 = 1;
            last;
        }
    }
    if ($Hash2) {

        # get sort prio
        my %DataSort = ();
        for my $Key ( keys %{ $Param{Data} } ) {
            if ( $Param{Data}->{$Key}->{Position} ) {
                $DataSort{$Key} = $Param{Data}->{$Key}->{Position};
            }
            else {
                $DataSort{$Key} = 0;
            }
        }

        # build option element
        $Output .= "<select name=\"$Name\" $Multiple $Size>\n";
        if ($PossibleNone) {
            $Output .= '<option VALUE="">-$Text{"none"}-</option>';
        }
        for my $Key ( sort { $DataSort{$a} <=> $DataSort{$b} } keys %DataSort ) {
            $Output .= '  <option value="' . $Self->Ascii2Html( Text => $Key ) . '"';
            if ( $Param{Data}->{$Key}->{Selected} ) {
                $Output .= ' selected';
            }
            $Output .= '>';
            if ($Translation) {
                $Param{Data}->{$Key}->{Value}
                    = $Self->{LanguageObject}->Get( $Param{Data}->{$Key}->{Value} );
            }
            if ($HTMLQuote) {
                $Output .= $Self->Ascii2Html( Text => $Param{Data}->{$Key}->{Value}, Max => $Max );
            }
            else {
                $Output .= $Param{Data}->{$Key}->{Value};
            }
            $Output .= "</option>\n";
        }
        $Output .= "</select>\n";
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Got corrupt Data param! Got: '" . ref( $Param{Data} ) . "'!",
        );
        $Self->FatalError();
    }
    return $Output;
}

=item BuildSelection()

build a html option element based on given data

    my $HTML = $LayoutObject->BuildSelection(
        Data => $ArrayRef,                # use $HashRef, $ArrayRef or $ArrayHashRef (see below)

        Name       => 'TheName',          # name of element
        Multiple   => 0,                  # (optional) default 0 (0|1)
        Size       => 1,                  # (optional) default 1 element size
        Class      => 'class',            # (optional) a css class
        Disabled   => 0,                  # (optional) default 0 (0|1) disable the element
        OnChange   => 'javascript',       # (optional)
        OnClick    => 'javascript',       # (optional)

        SelectedID    => 1,               # (optional) use integer or arrayref (unable to use with ArrayHashRef)
        SelectedID    => [1, 5, 3],       # (optional) use integer or arrayref (unable to use with ArrayHashRef)
        SelectedValue => 'test',          # (optional) use string or arrayref (unable to use with ArrayHashRef)
        SelectedValue => ['test', 'test1'], # (optional) use string or arrayref (unable to use with ArrayHashRef)
        Sort => 'NumericValue',           # (optional) (AlphanumericValue|NumericValue|AlphanumericKey|NumericKey|TreeView) unable to use with ArrayHashRef
        SortReverse    => 0,              # (optional) reverse the list
        Translation    => 1,              # (optional) default 1 (0|1) translate value
        PossibleNone   => 0,              # (optional) default 0 (0|1) add a leading empty selection
        TreeView       => 0,              # (optional) default 0 (0|1)
        DisabledBranch => 'Branch',       # (optional) disable all elements of this branch (use string or arrayref)
        Max            => 100,            # (optional) default 100 max size of the shown value
        HTMLQuote      => 0,              # (optional) default 1 (0|1) disable html quote
        Title          => 'Tooltip Text', # (optional) string will be shown as Tooltip on mouseover
    );

    my $HashRef = {
        'Key1' => 'Value1',
        'Key2' => 'Value2',
        'Key3' => 'Value3',
    };

    my $ArrayRef = [
        'KeyValue1',
        'KeyValue2',
        'KeyValue3',
        'KeyValue4',
    ];

    my $ArrayHashRef = [
        {
            Key => '1',
            Value => 'Value1',
        },
        {
            Key => '2',
            Value => 'Value1::Subvalue1',
            Selected => 1,
        },
        {
            Key => '3',
            Value => 'Value1::Subvalue2',
        },
        {
            Key => '4',
            Value => 'Value2',
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
        $Param{OnChange} = "AJAXUpdate('" . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Depend} } ) . "'], ['"
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
    );
    $String .= "<a id=\"AJAXImage$Param{Name}\"></a>\n";
    return $String;
}

#=item _BuildSelectionOptionRefCreate()
#
#create the option hash
#
#    my $OptionRef = $LayoutObject->_BuildSelectionOptionRefCreate(
#        %Param,
#    );
#
#    my $OptionRef = {
#        Sort => 'numeric',
#        PossibleNone => 0,
#        Max => 100,
#    }
#
#=cut

sub _BuildSelectionOptionRefCreate {
    my ( $Self, %Param ) = @_;

    my $OptionRef = {};

    # set SelectedID option
    if ( defined( $Param{SelectedID} ) ) {
        if ( ref( $Param{SelectedID} ) eq 'ARRAY' ) {
            for my $Key ( @{ $Param{SelectedID} } ) {
                $OptionRef->{SelectedID}->{$Key} = 1;
            }
        }
        else {
            $OptionRef->{SelectedID}->{ $Param{SelectedID} } = 1;
        }
    }

    # set SelectedValue option
    if ( defined( $Param{SelectedValue} ) ) {
        if ( ref( $Param{SelectedValue} ) eq 'ARRAY' ) {
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

    # set SortReverse option
    $OptionRef->{SortReverse} = 0;
    if ( $Param{SortReverse} ) {
        $OptionRef->{SortReverse} = 1;
    }

    # set Translation option
    $OptionRef->{Translation} = 1;
    if ( defined( $Param{Translation} ) && $Param{Translation} eq 0 ) {
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
        for my $OriginalKey ( keys %{ $OptionRef->{SelectedValue} } ) {
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
        if ( ref( $Param{DisabledBranch} ) eq 'ARRAY' ) {
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

#=item _BuildSelectionAttributeRefCreate()
#
#create the attribute hash
#
#    my $AttributeRef = $LayoutObject->_BuildSelectionAttributeRefCreate(
#        %Param,
#    );
#
#    my $AttributeRef = {
#        name => 'TheName',
#        multiple => undef,
#        size => 5,
#    }
#
#=cut

sub _BuildSelectionAttributeRefCreate {
    my ( $Self, %Param ) = @_;

    my $AttributeRef = {};

    # check params with key and value
    for (qw(Name Size Class OnChange OnClick)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = $Param{$_};
        }
    }

    # check params with key and value that need to be HTML-Quoted
    for (qw(Title)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = $Self->Ascii2Html( Text => $Param{$_} );
        }
    }

    # check key only params
    for (qw(Multiple Disabled)) {
        if ( $Param{$_} ) {
            $AttributeRef->{ lc($_) } = undef;
        }
    }

    return $AttributeRef;
}

#=item _BuildSelectionDataRefCreate()
#
#create the data hash
#
#    my $DataRef = $LayoutObject->_BuildSelectionDataRefCreate(
#        Data => $ArrayRef,              # use $HashRef, $ArrayRef or $ArrayHashRef
#        AttributeRef => $AttributeRef,
#        OptionRef => $OptionRef,
#    );
#
#    my $DataRef  = [
#        {
#            Key => 11,
#            Value => 'Text',
#        },
#        {
#            Key => 'abc',
#            Value => '&nbsp;&nbsp;Text',
#            Selected => 1,
#        },
#    ];
#
#=cut

sub _BuildSelectionDataRefCreate {
    my ( $Self, %Param ) = @_;

    my $AttributeRef = $Param{AttributeRef};
    my $OptionRef    = $Param{OptionRef};
    my $DataRef      = [];

    my $Counter = 0;

    # if HashRef was given
    if ( ref( $Param{Data} ) eq 'HASH' ) {

        # translate value
        if ( $OptionRef->{Translation} ) {
            for my $Row ( keys %{ $Param{Data} } ) {
                $Param{Data}->{$Row} = $Self->{LanguageObject}->Get( $Param{Data}->{$Row} );
            }
        }

        # sort hash
        my @SortKeys;
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
            for ( keys %{ $Param{Data} } ) {
                $SortHash{$_} = $Param{Data}->{$_} . '::';
            }
            @SortKeys = sort { $SortHash{$a} cmp $SortHash{$b} } ( keys %SortHash );
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
    elsif ( ref( $Param{Data} ) eq 'ARRAY' && ref( $Param{Data}->[0] ) eq 'HASH' ) {

        # create DataRef
        for my $Row ( @{ $Param{Data} } ) {
            if ( ref($Row) eq 'HASH' && $Row->{Key} ) {
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
    elsif ( ref( $Param{Data} ) eq 'ARRAY' ) {
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

            # add suffix for correct sorting
            my @SortArray;
            for my $Row ( @{ $Param{Data} } ) {
                push @SortArray, ( $Row . '::' );
            }

            # sort array
            @SortArray = sort(@SortArray);

            # remove suffix
            my @SortArray2;
            for my $Row (@SortArray) {
                $/ = '::';
                chomp($Row);
                push @SortArray2, $Row;
            }
            $Param{Data} = \@SortArray;
        }

        # create DataRef
        for my $Row ( @{ $Param{Data} } ) {
            $DataRef->[$Counter]->{Key}   = $ReverseHash{$Row};
            $DataRef->[$Counter]->{Value} = $Row;
            $Counter++;
        }
    }

    # SelectedID and SelectedValue option
    if ( $OptionRef->{SelectedID} || $OptionRef->{SelectedValue} ) {
        for my $Row ( @{$DataRef} ) {
            if (
                $OptionRef->{SelectedID}->{ $Row->{Key} }
                || $OptionRef->{SelectedValue}->{ $Row->{Value} }
                )
            {
                $Row->{Selected} = 1;
            }
        }
    }

    # DisabledBranch option
    if ( $OptionRef->{DisabledBranch} ) {
        for my $Row ( @{$DataRef} ) {
            for my $Branch ( keys %{ $OptionRef->{DisabledBranch} } ) {
                if ( $Row->{Value} =~ /^($Branch)$/ || $Row->{Value} =~ /^($Branch)::/ ) {
                    $Row->{Disabled} = 1;
                }
            }
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

    # Max option
    if ( $OptionRef->{Max} ) {
        for my $Row ( @{$DataRef} ) {
            $Row->{Value} = substr( $Row->{Value}, 0, $OptionRef->{Max} );
        }
    }

    # TreeView option
    if ( $OptionRef->{TreeView} ) {
        for my $Row ( @{$DataRef} ) {
            if ( $Row->{Value} ) {
                my @Fragment = split( '::', $Row->{Value} );
                $Row->{Value} = pop(@Fragment);
                my $Space = '';
                for (@Fragment) {
                    $Space .= '&nbsp;&nbsp;';
                }
                $Row->{Value} = $Space . $Row->{Value};
            }
        }
    }

    return $DataRef;
}

#=item _BuildSelectionOutput()
#
#create the html string
#
#    my $HTMLString = $LayoutObject->_BuildSelectionOutput(
#        AttributeRef => $AttributeRef,
#        DataRef => $DataRef,
#    );
#
#    my $AttributeRef = {
#        name => 'TheName',
#        multiple => undef,
#        size => 5,
#    }
#
#    my $DataRef  = [
#        {
#            Key => 11,
#            Value => 'Text',
#            Disabled => 1,
#        },
#        {
#            Key => 'abc',
#            Value => '&nbsp;&nbsp;Text',
#            Selected => 1,
#        },
#    ];
#
#=cut

sub _BuildSelectionOutput {
    my ( $Self, %Param ) = @_;

    my $String;

    # start generation, if AttributeRef and DataRef was found
    if ( $Param{AttributeRef} && $Param{DataRef} ) {

        # generate <select> row
        $String = "<select";
        for my $Key ( keys %{ $Param{AttributeRef} } ) {
            if ( $Key && defined( $Param{AttributeRef}->{$Key} ) ) {
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
            if ( defined( $Row->{Key} ) ) {
                $Key = $Row->{Key};
            }
            my $Value = '';
            if ( defined( $Row->{Value} ) ) {
                $Value = $Row->{Value};
            }
            my $SelectedDisabled = '';
            if ( $Row->{Selected} ) {
                $SelectedDisabled = " selected";
            }
            elsif ( $Row->{Disabled} ) {
                $SelectedDisabled = " disabled";
            }
            $String .= "  <option value=\"$Key\"$SelectedDisabled>$Value</option>\n";
        }
        $String .= "</select>";
    }
    return $String;
}

sub NoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';
    my $Output = '';
    $Param{Message} = 'No Permission!' if ( !$Param{Message} );

    # create output
    $Output = $Self->Header( Title => 'No Permission' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output( TemplateFile => 'NoPermission', Data => \%Param );
    $Output .= $Self->Footer() if ( $WithHeader eq 'yes' );

    # return output
    return $Output;
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
        $Param{ContentCharset} && $Param{ContentCharset} =~ s/'|"//gi;

        # if the content charset is different to the user charset
        if ( $Param{ContentCharset} && $Self->{UserCharset} !~ /^$Param{ContentCharset}$/i ) {

            # if the content charset is us-ascii it is always shown correctly
            if ( $Param{ContentCharset} !~ /us-ascii/i ) {
                $Output = '<p><i class="small">'
                    . '$Text{"This message was written in a character set other than your own."}'
                    . '$Text{"If it is not displayed correctly,"} '
                    . '<a href="'
                    . $Self->{Baselink}
                    . "Action=$Param{Action}&TicketID=$Param{TicketID}"
                    . "&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" target=\"HTMLeMail\" "
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
            . "Action=$Param{Action}&TicketID="
            . "$Param{TicketID}&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" "
            . 'target="HTMLeMail" '
            . 'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'
            . '$Text{"click here"}</a> '
            . '$Text{"to open it in a new window."}</i></p>';
    }

    # just to be compat
    elsif ( $Param{Body} =~ /^<.DOCTYPE html PUBLIC|^<HTML>/i ) {
        $Output = '<p><i class="small">$Text{"This is a"} '
            . $Param{MimeType}
            . ' $Text{"email"}, '
            . '<a href="'
            . $Self->{Baselink}
            . 'Action=$Env{"Action"}&TicketID='
            . "$Param{TicketID}&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" "
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
        Type        => 'inline', # inline|attachment
        Filename    => 'FileName.png',
        ContentType => 'image/png',
        Content     => $Content,
    );

    or

    $HTML = $LayoutObject->Attachment(
        Type        => 'inline', # inline|attachment
        Filename    => 'FileName.png',
        ContentType => 'image/png',
        Content     => $Content,
        NoCache     => 1,
    );

=cut

sub Attachment {
    my ( $Self, %Param ) = @_;

    # check needed objects
    for (qw(Content ContentType)) {
        if ( !defined( $Param{$_} ) ) {
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
        $Output .= " filename=\"$Param{Filename}\"";
    }
    $Output .= "\n";

    # get attachment size
    {
        use bytes;
        $Param{Size} = length( $Param{Content} );
        no bytes;
    }

    # add no cache headers
    if ( $Param{NoCache} ) {
        $Output .= "Expires: Tue, 1 Jan 1980 12:00:00 GMT\n";
        $Output .= "Cache-Control: no-cache\n";
        $Output .= "Pragma: no-cache\n";
    }
    $Output .= "Content-Length: $Param{Size}\n";
    $Output .= "Content-Type: $Param{ContentType}\n\n";

    # disable utf8 flag, to write binary to output
    $Self->{EncodeObject}->EncodeOutput( \$Output );
    $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );

    # fix for firefox HEAD problem
    if ( !$ENV{REQUEST_METHOD} || $ENV{REQUEST_METHOD} ne 'HEAD' ) {
        $Output .= $Param{Content};
    }

    # don't use the active element filter for attachements, perhaps you destroy a xml
    delete $Self->{FilterElementPre}->{ActiveElementFilter};
    delete $Self->{FilterElementPost}->{ActiveElementFilter};
    delete $Self->{FilterContent}->{ActiveElementFilter};

    # reset binmode, don't use utf8
    binmode(STDOUT);

    return $Output;
}

sub PageNavBar {
    my ( $Self, %Param ) = @_;

    my $Limit = $Param{Limit} || 0;
    $Param{AllHits}  = 0 if ( !$Param{AllHits} );
    $Param{StartHit} = 0 if ( !$Param{AllHits} );
    my $Pages = int( ( $Param{AllHits} / $Param{PageShown} ) + 0.99999 );
    my $Page  = int( ( $Param{StartHit} / $Param{PageShown} ) + 0.99999 );
    my $WindowSize = $Param{WindowSize} || 15;

    # build Results (1-5 or 16-30)
    if ( $Param{AllHits} >= ( $Param{StartHit} + $Param{PageShown} ) ) {
        $Param{Results} = $Param{StartHit} . "-" . ( $Param{StartHit} + $Param{PageShown} - 1 );
    }
    else {
        $Param{Results} = "$Param{StartHit}-$Param{AllHits}";
    }

    # check total hits
    if ( $Limit == $Param{AllHits} ) {
        $Param{TotalHits} = "<font color=red>$Param{AllHits}</font>";
    }
    else {
        $Param{TotalHits} = $Param{AllHits};
    }

    # build page nav bar
    my $WindowStart = sprintf( "%.0f", ( $Param{StartHit} / $Param{PageShown} ) );
    $WindowStart = int( ( $WindowStart / $WindowSize ) ) + 1;
    $WindowStart = ( $WindowStart * $WindowSize ) - ($WindowSize);
    my $i = 0;
    while ( $i <= ( $Pages - 1 ) ) {
        $i++;
        if ( $i <= ( $WindowStart + $WindowSize ) && $i > $WindowStart ) {
            $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}"
                . "StartWindow=$WindowStart&StartHit=" . ( ( ( $i - 1 ) * $Param{PageShown} ) + 1 );
            $Param{SearchNavBar} .= '">';
            if ( $Page == $i ) {
                $Param{SearchNavBar} .= '<b>' . ($i) . '</b>';
            }
            else {
                $Param{SearchNavBar} .= ($i);
            }
            $Param{SearchNavBar} .= '</a> ';
        }

        # over window
        elsif ( $i > ( $WindowStart + $WindowSize ) ) {
            my $StartWindow     = $WindowStart + $WindowSize + 1;
            my $LastStartWindow = int( $Pages / $WindowSize );
            $Param{SearchNavBar} .= "&nbsp;<a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}"
                . "StartHit=" . $i * $Param{PageShown};
            $Param{SearchNavBar} .= '">' . "&gt;&gt;</a>&nbsp;";
            $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}"
                . "StartHit=" . ( ( $Param{PageShown} * ( $Pages - 1 ) ) + 1 );
            $Param{SearchNavBar} .= '">' . "&gt;|</a> ";
            $i = 99999999;
        }
        elsif ( $i < $WindowStart && ( $i - 1 ) < $Pages ) {
            my $StartWindow = $WindowStart - $WindowSize - 1;
            $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}"
                . "StartHit=1&StartWindow=1";
            $Param{SearchNavBar} .= '">' . "|&lt;</a>&nbsp;";
            $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}"
                . "StartHit=" . ( ( $WindowStart - 1 ) * ( $Param{PageShown} ) + 1 );
            $Param{SearchNavBar} .= '">' . "&lt;&lt;</a>&nbsp;";
            $i = $WindowStart - 1;
        }
    }

    # return data
    return (
        TotalHits  => $Param{TotalHits},
        Result     => $Param{Results},
        SiteNavBar => $Param{SearchNavBar},
        Link       => $Param{Link},
    );
}

sub NavigationBar {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    if ( !$Param{Type} ) {
        $Param{Type} = $Self->{ModuleReg}->{NavBarName} || $Self->{LastNavBarName} || 'Ticket';
    }

    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastNavBarName',
        Value     => $Param{Type},
    );

    # run notification modules
    my $FrontendNotifyModuleConfig = $Self->{ConfigObject}->Get('Frontend::NotifyModule');
    if ( ref($FrontendNotifyModuleConfig) eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
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
                $Output .= $Object->Run( %Param, Config => $Jobs{$Job} );
            }
            else {
                $Self->FatalError();
            }
        }
    }

    # create menu items
    my %NavBarModule         = ();
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('Frontend::Module');

    MODULE:
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        next MODULE if !$Hash{NavBar} || ref( $Hash{NavBar} ) ne 'ARRAY';

        my @Items = @{ $Hash{NavBar} };
        for my $Item (@Items) {
            if (
                ( $Item->{NavBar} && $Item->{NavBar} eq $Param{Type} )
                || ( $Item->{Type} && $Item->{Type} eq 'Menu' )
                || !$Item->{NavBar}
                )
            {

                # highligt avtive area link
                if (
                    ( $Item->{Type} && $Item->{Type} eq 'Menu' )
                    && ( $Item->{NavBar} && $Item->{NavBar} eq $Param{Type} )
                    )
                {
                    next if !$Self->{ConfigObject}->Get('Frontend::NavBarStyle::ShowSelectedArea');
                    $Item->{ItemAreaCSSSuffix} = 'active';
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
                    if ( $Item->{$Permission} && ref( $Item->{$Permission} ) eq 'ARRAY' ) {
                        for ( @{ $Item->{$Permission} } ) {
                            my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
                            if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                                $Shown = 1;
                            }
                        }
                    }

                    # scalar access restriction
                    elsif ( $Item->{$Permission} ) {
                        my $Key = 'UserIs' . $Permission . '[' . $Item->{$Permission} . ']';
                        if ( $Self->{$Key} && $Self->{$Key} eq 'Yes' ) {
                            $Shown = 1;
                        }
                    }

                    # no access restriction
                    elsif ( !$Item->{GroupRo} && !$Item->{Group} ) {
                        $Shown = 1;
                    }
                }
                next if !$Shown;

                my $Key = ( $Item->{Block} || '' ) . sprintf( "%07d", $Item->{Prio} );
                for ( 1 .. 51 ) {
                    last if !$NavBarModule{$Key};

                    $Item->{Prio}++;
                    $Key = ( $Item->{Block} || '' ) . sprintf( "%07d", $Item->{Prio} );
                }
                $NavBarModule{$Key} = $Item;

            }
        }
    }

    # run menu item modules
    if ( ref( $Self->{ConfigObject}->Get('Frontend::NavBarModule') ) eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Frontend::NavBarModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
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
            else {
                $Self->FatalError();
            }
        }
    }

    my $NavBarType = $Self->{ConfigObject}->Get('Frontend::NavBarStyle') || 'Classic';
    $Self->Block(
        Name => $NavBarType,
        Data => \%Param,
    );
    for ( sort keys %NavBarModule ) {
        $Self->Block(
            Name => $NavBarModule{$_}->{Block} || 'Item',
            Data => $NavBarModule{$_},
        );
    }

    # create & return output
    $Output = $Self->Output( TemplateFile => 'AgentNavigationBar', Data => \%Param ) . $Output;
    if ( $Self->{ModuleReg}->{NavBarModule} ) {

        # run navbar modules
        my %Jobs = %{ $Self->{ModuleReg}->{NavBarModule} };

        # load module
        if ( $Self->{MainObject}->Require( $Jobs{Module} ) ) {
            my $Object = $Jobs{Module}->new(
                %{$Self},
                ConfigObject => $Self->{ConfigObject},
                LogObject    => $Self->{LogObject},
                DBObject     => $Self->{DBObject},
                LayoutObject => $Self,
                UserID       => $Self->{UserID},
                Debug        => $Self->{Debug},
            );

            # run module
            $Output .= $Object->Run( %Param, Config => \%Jobs );
        }
        else {
            $Self->FatalError();
        }
    }
    return $Output;
}

sub WindowTabStart {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Tab} || ( $Param{Tab} && ref( $Param{Tab} ) ne 'ARRAY' ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Tab as ARRAY ref in WindowTabStart()!',
        );
        $Self->FatalError();
    }

    $Self->Block(
        Name => 'WindowTabStart',
        Data => \%Param,
    );

    my @Tabs = @{ $Param{Tab} };
    my $Size = int( 100 / ( $#Tabs + 1 ) );
    for my $Hash (@Tabs) {
        $Hash->{Size} = $Size;
        if ( $Hash->{Ready} ) {
            $Hash->{Image} = 'ready.png';
        }
        else {
            $Hash->{Image} = 'notready.png';
        }
        $Self->Block(
            Name => 'Tab',
            Data => { %{$Hash}, },
        );
    }
    return $Self->Output( TemplateFile => 'AgentWindowTab', Data => \%Param );
}

sub WindowTabStop {
    my ( $Self, %Param ) = @_;

    $Self->Block(
        Name => 'WindowTabStop',
        Data => \%Param,
    );

    if ( $Param{Layer0Footer} ) {
        for my $Hash ( @{ $Param{Layer0Footer} } ) {
            $Self->Block(
                Name => 'Layer0Footer',
                Data => { %{$Hash}, },
            );
        }
    }
    if ( $Param{Layer1Footer} ) {
        for my $Hash ( @{ $Param{Layer1Footer} } ) {
            $Self->Block(
                Name => 'Layer1Footer',
                Data => { %{$Hash}, },
            );
        }
    }
    return $Self->Output( TemplateFile => 'AgentWindowTab', Data => \%Param );
}

sub TransfromDateSelection {
    my ( $Self, %Param ) = @_;

    my $DateInputStyle = $Self->{ConfigObject}->Get('TimeInputFormat');
    my $Prefix         = $Param{'Prefix'} || '';
    my $Format         = defined( $Param{Format} ) ? $Param{Format} : 'DateInputFormatLong';

    # time zone translation
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
            $Param{ $Prefix . 'Secunde' },
            $Param{ $Prefix . 'Minute' },
            $Param{ $Prefix . 'Hour' },
            $Param{ $Prefix . 'Day' },
            $Param{ $Prefix . 'Month' },
            $Param{ $Prefix . 'Year' }
        ) = $Self->{UserTimeObject}->SystemTime2Date( SystemTime => $TimeStamp, );
    }
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
    my $Used           = $Param{ $Prefix . 'Used' } || 0;
    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{UserTimeObject}->SystemTime2Date(
        SystemTime => $Self->{UserTimeObject}->SystemTime() + $DiffTime,
    );

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
            $Param{ $Prefix . 'Secunde' },
            $Param{ $Prefix . 'Minute' },
            $Param{ $Prefix . 'Hour' },
            $Param{ $Prefix . 'Day' },
            $Param{ $Prefix . 'Month' },
            $Param{ $Prefix . 'Year' }
        ) = $Self->{UserTimeObject}->SystemTime2Date( SystemTime => $TimeStamp, );
    }

    # year
    if ( $DateInputStyle eq 'Option' ) {
        my %Year = ();
        if ( defined( $Param{YearPeriodPast} ) && defined( $Param{YearPeriodFuture} ) ) {
            for ( $Y - $Param{YearPeriodPast} .. $Y + $Param{YearPeriodFuture} ) {
                $Year{$_} = $_;
            }
        }
        else {
            for ( $Y - 10 .. $Y + 1 + ( $Param{YearDiff} || 0 ) ) {
                $Year{$_} = $_;
            }
        }
        $Param{Year} = $Self->OptionStrgHashRef(
            Name                => $Prefix . 'Year',
            Data                => \%Year,
            SelectedID          => int( $Param{ $Prefix . 'Year' } || $Y ),
            LanguageTranslation => 0,
        );
    }
    else {
        $Param{Year} = "<input type=\"text\" name=\""
            . $Prefix
            . "Year\" size=\"4\" maxlength=\"4\" "
            . "value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Year' } || $Y ) ) . "\"/>";
    }

    # month
    if ( $DateInputStyle eq 'Option' ) {
        my %Month = ();
        for ( 1 .. 12 ) {
            my $Tmp = sprintf( "%02d", $_ );
            $Month{$_} = $Tmp;
        }
        $Param{Month} = $Self->OptionStrgHashRef(
            Name                => $Prefix . 'Month',
            Data                => \%Month,
            SelectedID          => int( $Param{ $Prefix . 'Month' } || $M ),
            LanguageTranslation => 0,
        );
    }
    else {
        $Param{Month} = "<input type=\"text\" name=\""
            . $Prefix
            . "Month\" size=\"2\" maxlength=\"2\" "
            . "value=\""
            . sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) . "\"/>";
    }

    # day
    if ( $DateInputStyle eq 'Option' ) {
        my %Day = ();
        for ( 1 .. 31 ) {
            my $Tmp = sprintf( "%02d", $_ );
            $Day{$_} = $Tmp;
        }
        $Param{Day} = $Self->OptionStrgHashRef(
            Name                => $Prefix . 'Day',
            Data                => \%Day,
            SelectedID          => int( $Param{ $Prefix . 'Day' } || $D ),
            LanguageTranslation => 0,
        );
    }
    else {
        $Param{Day} = "<input type=\"text\" name=\""
            . $Prefix
            . "Day\" size=\"2\" maxlength=\"2\" "
            . "value=\""
            . ( $Param{ $Prefix . 'Day' } || $D ) . "\"/>";
    }
    if ( $Format eq 'DateInputFormatLong' ) {

        # hour
        if ( $DateInputStyle eq 'Option' ) {
            my %Hour = ();
            for ( 0 .. 23 ) {
                my $Tmp = sprintf( "%02d", $_ );
                $Hour{$_} = $Tmp;
            }
            $Param{Hour} = $Self->OptionStrgHashRef(
                Name       => $Prefix . 'Hour',
                Data       => \%Hour,
                SelectedID => defined( $Param{ $Prefix . 'Hour' } )
                ? int( $Param{ $Prefix . 'Hour' } )
                : int($h),
                LanguageTranslation => 0,
            );
        }
        else {
            $Param{Hour} = "<input type=\"text\" name=\""
                . $Prefix
                . "Hour\" size=\"2\" maxlength=\"2\" "
                . "value=\""
                . sprintf(
                "%02d",
                ( defined( $Param{ $Prefix . 'Hour' } ) ? int( $Param{ $Prefix . 'Hour' } ) : $h )
                )
                . "\"/>";
        }

        # minute
        if ( $DateInputStyle eq 'Option' ) {
            my %Minute = ();
            for ( 0 .. 59 ) {
                my $Tmp = sprintf( "%02d", $_ );
                $Minute{$_} = $Tmp;
            }
            $Param{Minute} = $Self->OptionStrgHashRef(
                Name       => $Prefix . 'Minute',
                Data       => \%Minute,
                SelectedID => defined( $Param{ $Prefix . 'Minute' } )
                ? int( $Param{ $Prefix . 'Minute' } )
                : int($m),
                LanguageTranslation => 0,
            );
        }
        else {
            $Param{Minute} = "<input type=\"text\" name=\""
                . $Prefix
                . "Minute\" size=\"2\" maxlength=\"2\" "
                . "value=\""
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
    my $Output;

    # optional checkbox
    if ($Optional) {
        my $Checked = '';
        if ($Used) {
            $Checked = ' checked';
        }
        $Output .= "<input type=\"checkbox\" name=\""
            . $Prefix
            . "Used\" value=\"1\""
            . $Checked
            . "/>&nbsp;";
    }

    # date format
    $Output .= $Self->{LanguageObject}->Time(
        Action => 'Return',
        Format => 'DateInputFormat',
        Mode   => 'NotNumeric',
        %Param,
    );

    # show calendar lookup
    if ( $Self->{BrowserJavaScriptSupport} ) {
        if ( $Area eq 'Agent' && $Self->{ConfigObject}->Get('TimeCalendarLookup') ) {

            # loas site preferences
            $Self->Output(
                TemplateFile => 'HeaderSmall',
                Data         => {},
            );
            $Output .= $Self->Output(
                TemplateFile => 'AgentCalendarSmallIcon',
                Data => { Prefix => $Prefix, }
            );
        }
        elsif ( $Area eq 'Customer' && $Self->{ConfigObject}->Get('TimeCalendarLookup') ) {

            # loas site preferences
            $Self->Output(
                TemplateFile => 'CustomerHeaderSmall',
                Data         => {},
            );
            $Output .= $Self->Output(
                TemplateFile => 'CustomerCalendarSmallIcon',
                Data => { Prefix => $Prefix, }
            );
        }
    }

    return $Output;
}

=item OutputCSV()

returns a csv based on a array

    $CSV = $LayoutObject->OutputCSV(
        Head => ['RowA', 'RowB', ],
        Data => [
            [1,4],
            [7,3],
            [1,9],
            [34,4],
        ],
    );

=cut

sub OutputCSV {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    my @Head   = ('##No Head Data##');
    if ( $Param{Head} ) {
        @Head = @{ $Param{Head} };
    }
    my @Data = ( ['##No Data##'] );
    if ( $Param{Data} ) {
        @Data = @{ $Param{Data} };
    }
    for my $Entry (@Head) {

        # csv quote
        $Entry =~ s/"/""/g if ($Entry);
        $Entry = '' if ( !defined($Entry) );
        $Output .= "\"$Entry\";";
    }
    $Output .= "\n";
    for my $EntryRow (@Data) {
        for my $Entry ( @{$EntryRow} ) {

            # csv quote
            $Entry =~ s/"/""/g if ($Entry);
            $Entry = '' if ( !defined($Entry) );
            $Output .= "\"$Entry\";";
        }
        $Output .= "\n";
    }
    return $Output;
}

=item OutputHTMLTable()

returns a html table based on a array

    $HTML = $LayoutObject->OutputHTMLTable(
        Head => ['RowA', 'RowB', ],
        Data => [
            [1,4],
            [7,3],
            [1,9],
            [34,4],
        ],
    );

=cut

sub OutputHTMLTable {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    my @Head   = ('##No Head Data##');
    if ( $Param{Head} ) {
        @Head = @{ $Param{Head} };
    }
    my @Data = ( ['##No Data##'] );
    if ( $Param{Data} ) {
        @Data = @{ $Param{Data} };
    }

    $Output .= '<table border="0" width="100%" cellspacing="0" cellpadding="3">';
    $Output .= "<tr>\n";
    for my $Entry (@Head) {
        $Output .= "<td class=\"contentvalue\">$Entry</td>\n";
    }
    $Output .= "</tr>\n";
    for my $EntryRow (@Data) {
        $Output .= "<tr>\n";
        for my $Entry ( @{$EntryRow} ) {
            $Output .= "<td class=\"small\">$Entry</td>\n";
        }
        $Output .= "</tr>\n";
    }
    $Output .= "</table>\n";
    return $Output;
}

sub CustomerLogin {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{TitleArea} = ' :: ' . $Self->{LanguageObject}->Get('Login');

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( keys %{ $Self->{SetCookies} } ) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }

    # get language options
    $Param{Language} = $Self->OptionStrgHashRef(
        Data                => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
        Name                => 'Lang',
        SelectedID          => $Self->{UserLanguage},
        OnChange            => 'submit()',
        HTMLQuote           => 0,
        LanguageTranslation => 0,
    );

    # get lost password output
    if (
        $Self->{ConfigObject}->Get('CustomerPanelLostPassword')
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq
        'Kernel::System::CustomerAuth::DB'
        )
    {
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
            Name => 'CreateAccount',
            Data => \%Param,
        );
    }

    # create & return output
    $Output .= $Self->Output( TemplateFile => 'CustomerLogin', Data => \%Param );
    return $Output;
}

sub CustomerHeader {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    my $Type = $Param{Type} || '';

    # add cookies if exists
    if ( $Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie') ) {
        for ( keys %{ $Self->{SetCookies} } ) {
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
    for my $Word (qw(Area Title Value)) {
        if ( $Param{$Word} ) {
            $Param{TitleArea} .= ' :: ' . $Self->{LanguageObject}->Get( $Param{$Word} );
        }
    }

    # run header meta modules
    my $HeaderMetaModule = $Self->{ConfigObject}->Get('CustomerFrontend::HeaderMetaModule');
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

    # create & return output
    $Output .= $Self->Output( TemplateFile => "CustomerHeader$Type", Data => \%Param );
    return $Output;
}

sub CustomerFooter {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || '';

    # unless explicitly specified, we set the footer width to the defaults, which are:
    # 800 pixel for the standard footer
    # 100% for any others (small)
    if ( !$Param{Width} ) {
        if ( $Type eq '' ) {
            $Param{Width} = '800';
        }
        else {
            $Param{Width} = '100%';
        }
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
    my %NavBarModule         = ();
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('CustomerFrontend::Module');
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        if ( $Hash{NavBar} && ref( $Hash{NavBar} ) eq 'ARRAY' ) {
            my @Items = @{ $Hash{NavBar} };
            for my $Item (@Items) {
                for ( 1 .. 51 ) {
                    if ( $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } ) {
                        $Item->{Prio}++;
                    }
                    if ( !$NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } ) {
                        last;
                    }
                }
                $NavBarModule{ sprintf( "%07d", $Item->{Prio} ) } = $Item;
            }
        }
    }
    for ( sort keys %NavBarModule ) {
        $Self->Block(
            Name => $NavBarModule{$_}->{Block} || 'Item',
            Data => $NavBarModule{$_},
        );
    }

    # run notification modules
    my $FrontendNotifyModuleConfig = $Self->{ConfigObject}->Get('CustomerFrontend::NotifyModule');
    if ( ref($FrontendNotifyModuleConfig) eq 'HASH' ) {
        my %Jobs = %{$FrontendNotifyModuleConfig};
        for my $Job ( sort keys %Jobs ) {

            # log try of load module
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Try to load module: $Jobs{$Job}->{Module}!",
                );
            }
            if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                my $Object = $Jobs{$Job}->{Module}->new(
                    ConfigObject   => $Self->{ConfigObject},
                    LogObject      => $Self->{LogObject},
                    DBObject       => $Self->{DBObject},
                    TimeObject     => $Self->{TimeObject},
                    UserTimeObject => $Self->{UserTimeObject},
                    LayoutObject   => $Self,
                    UserID         => $Self->{UserID},
                    Debug          => $Self->{Debug},
                );

                # log loaded module
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Module: $Jobs{$Job}->{Module} loaded!",
                    );
                }

                # run module
                $Param{Notification} .= $Object->Run( %Param, Config => $Jobs{$Job} );
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't load module $Jobs{$Job}->{Module}!",
                );
            }
        }
    }
    if ( $Self->{UserEmail} ne $Self->{UserCustomerID} ) {
        $Param{UserLoginTop} = "$Self->{UserEmail}/$Self->{UserCustomerID}";
    }
    else {
        $Param{UserLoginTop} = $Self->{UserEmail};
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
        $Param{ 'Backend' . $_ } = $Self->Ascii2Html(
            Text           => $Param{ 'Backend' . $_ },
            HTMLResultMode => 1,
        );
    }
    if ( !$Param{'BackendMessage'} && !$Param{'BackendTraceback'} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => $Param{Message} || '?',
        );
        for (qw(Message Traceback)) {
            $Param{ 'Backend' . $_ } = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => $_
            ) || '';
            $Param{ 'Backend' . $_ } = $Self->Ascii2Html(
                Text           => $Param{ 'Backend' . $_ },
                HTMLResultMode => 1,
            );
        }
    }

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output( TemplateFile => 'CustomerError', Data => \%Param );
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
    $Param{BackendMessage} = $Self->Ascii2Html(
        Text           => $Param{BackendMessage},
        HTMLResultMode => 1,
    );

    if ( !$Param{Message} ) {
        $Param{Message} = $Param{BackendMessage};
    }

    # create & return output
    return $Self->Output( TemplateFile => 'CustomerWarning', Data => \%Param );
}

sub CustomerNoPermission {
    my ( $Self, %Param ) = @_;

    my $WithHeader = $Param{WithHeader} || 'yes';
    my $Output = '';
    $Param{Message} = 'No Permission!' if ( !$Param{Message} );

    # create output
    $Output = $Self->CustomerHeader( Title => 'No Permission' ) if ( $WithHeader eq 'yes' );
    $Output .= $Self->Output( TemplateFile => 'NoPermission', Data => \%Param );
    $Output .= $Self->CustomerFooter() if ( $WithHeader eq 'yes' );

    # return output
    return $Output;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.101 $ $Date: 2008-07-05 18:40:28 $

=cut
