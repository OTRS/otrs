# --
# Kernel/System/Config.pm - all system config tool functions
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: Config.pm,v 1.64.2.1 2008-01-03 23:26:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Config;

use strict;

use Kernel::System::XML;
use Kernel::Config;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.64.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Config - to manage config settings

=head1 SYNOPSIS

All functions to manage config settings.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Config;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );

    my $MainObject = Kernel::System::Main->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
    );

    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $ConfigToolObject = Kernel::System::Config->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject TimeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # create xml object
    $Self->{XMLObject} = Kernel::System::XML->new(%Param);
    # mild pretty print
    $Data::Dumper::Indent = 1;
    # create config object
    $Self->{ConfigDefaultObject} = Kernel::Config->new(%Param, Level => 'Default');
    # create config object
    $Self->{ConfigObject} = Kernel::Config->new(%Param, Level => 'First');
    # create config object
    $Self->{ConfigClearObject} = Kernel::Config->new(%Param, Level => 'Clear');

    # read all config files
    $Self->{ConfigCounter} = $Self->_Init();

    return $Self;
}

sub _Init {
    my $Self = shift;
    my %Param = @_;
    my $Counter = 0;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # load xml config files
    if (-e "$Self->{Home}/Kernel/Config/Files/") {
        my %Data = ();
        my @Files = glob("$Self->{Home}/Kernel/Config/Files/*.xml");
        foreach my $File (@Files) {
            my $ConfigFile = '';
            if (open (IN, "< $File")) {
                while (<IN>) {
                    $ConfigFile .= $_;
                }
                close (IN);
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't open file $File: $!",
                );
            }
            my $FileCachePart = $File;
            $FileCachePart =~ s/$Self->{Home}//;
            $FileCachePart =~ s/\/\//\//g;
            $FileCachePart =~ s/\//_/g;
            if ($ConfigFile) {
                my $CacheFileUsed = 0;
                my $Digest = md5_hex($ConfigFile);
                my $FileCache = "$Self->{Home}/var/tmp/SysConfig-Cache$FileCachePart-$Digest.pm";
                if (-e $FileCache) {
                    my $ConfigFileCache = '';
                    if (open (IN, "< $FileCache")) {
                        while (<IN>) {
                            $ConfigFileCache .= $_;
                        }
                        close (IN);
                        my $XMLHashRef;
                        if (eval $ConfigFileCache) {
                            $Data{$File} = $XMLHashRef;
                            $CacheFileUsed = 1;
                        }
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message => "Can't open cache file $FileCache: $!",
                        );
                    }
                }
                else {
                    # remove all cache files
                    my @List = glob("$Self->{Home}/var/tmp/SysConfig-Cache$FileCachePart-*.pm");
                    foreach my $File (@List) {
                        unlink $File;
                    }
                }
                # parse config files
                if (!$CacheFileUsed) {
                    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $ConfigFile);
                    $Data{$File} = \@XMLHash;
                    my $Dump = Data::Dumper::Dumper(\@XMLHash);
                    $Dump =~ s/\$VAR1/\$XMLHashRef/;
                    if (open (OUT, "> $FileCache")) {
                        print OUT $Dump."\n1;";
                        close (OUT);
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message => "Can't write cache file $FileCache: $!",
                        );
                    }
                }
            }
        }
        $Self->{XMLConfig} = [];
        # load framework, application, config, changes
        foreach my $Init (qw(Framework Application Config Changes)) {
            foreach my $Set (sort keys %Data) {
                if ($Data{$Set}->[1]->{otrs_config}->[1]->{init} eq $Init) {
                    push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
                    delete $Data{$Set};
                }
            }
        }
        # load misc
        foreach my $Set (sort keys %Data) {
            push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
            delete $Data{$Set};
        }
    }
    # read all config files
    foreach my $ConfigItem (reverse @{$Self->{XMLConfig}}) {
        $Counter++;
        if ($ConfigItem->{Name} && !$Self->{Config}->{$ConfigItem->{Name}}) {
            $Self->{Config}->{$ConfigItem->{Name}} = $ConfigItem;
        }
    }
    return $Counter;
}

sub WriteDefault {
    my $Self = shift;
    my %Param = @_;
    my $File = '';
    my %UsedKeys = ();
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # read all config files
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Name} && !$UsedKeys{$ConfigItem->{Name}}) {
            $UsedKeys{$ConfigItem->{Name}} = 1;
            my %Config = $Self->ConfigItemGet(
                Name => $ConfigItem->{Name},
                Default => 1,
            );

            my $Name = $Config{Name};
            $Name =~ s/\\/\\\\/g;
            $Name =~ s/'/\'/g;
            $Name =~ s/###/'}->{'/g;

            if ($Config{Valid}) {
                $File .= "\$Self->{'$Name'} = ".$Self->_XML2Perl(Data => \%Config);
            }
            elsif (!$Config{Valid} && eval('$Self->{ConfigDefaultObject}->{\''. $Name . '\'}')) {
                $File .= "delete \$Self->{'$Name'};\n";
            }
        }
    }
    # write default config file
    if (!open(OUT, "> $Self->{Home}/Kernel/Config/Files/ZZZAAuto.pm")) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't write $Self->{Home}/Kernel/Config/Files/ZZZAAuto.pm: $!!",
        );
        return;
    }
    else {
        print OUT $File;
        print OUT "\$Self->{'1'} = 1;\n";
        close (OUT);
        return 1;
    }
}

=item Download()

download config changes

    $ConfigToolObject->Download();

or if you want to check if it exists (returns true or false)

    $ConfigToolObject->Download(Type => 'Check');

=cut

sub Download {
    my $Self = shift;
    my %Param = @_;
    my $File = '';
    my $Home = $Self->{'Home'};
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (! -e "$Home/Kernel/Config/Files/ZZZAuto.pm") {
        return $File;
    }
    elsif (!open(IN, "< $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        if ($Param{Type}) {
            return;
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Can't open $Home/Kernel/Config/Files/ZZZAuto.pm: $!");
            return '';
        }
    }
    else {
        while (<IN>) {
            $File .= $_;
        }
        close (IN);
        if ($Param{Type}) {
            my $Length = length($File);
            if ($Length > 25) {
                return 1;
            }
            else {
                return;
            }
        }
        else {
            return $File;
        }
    }
}

=item Upload()

upload of config changes

    $ConfigToolObject->Upload(
        Content => $Content,
    );

=cut

sub Upload {
    my $Self = shift;
    my %Param = @_;
    my $File = '';
    my $Home = $Self->{'Home'};
    # check needed stuff
    foreach (qw(Content)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!open(OUT, "> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm!");
        return;
    }
    else {
        print OUT $Param{Content};
        close (OUT);
        return 1;
    }
}

=item CreateConfig()

submit config settings to application

    $ConfigToolObject->CreateConfig();

=cut

sub CreateConfig {
    my $Self = shift;
    my %Param = @_;
    my $File = '';
    my %UsedKeys = ();
    my $Home = $Self->{'Home'};
    # remember to update defaults
    $Self->{Update} = 1;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # read all config files
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Name} && !$UsedKeys{$ConfigItem->{Name}}) {
            my %Config = $Self->ConfigItemGet(
                Name => $ConfigItem->{Name},
            );
            my %ConfigDefault = $Self->ConfigItemGet(
                Name => $ConfigItem->{Name},
                Default => 1,
            );
            $UsedKeys{$ConfigItem->{Name}} = 1;
            my $Name = $Config{Name};
            $Name =~ s/\\/\\\\/g;
            $Name =~ s/'/\'/g;
            $Name =~ s/###/'}->{'/g;
            if ($Config{Valid}) {
                my $C = $Self->_XML2Perl(Data => \%Config);
                my $D = $Self->_XML2Perl(Data => \%ConfigDefault);
                my ($A1, $A2);
                eval "\$A1 = $C";
                eval "\$A2 = $D";
                if (!defined($A1) && !defined($A2)) {
                    # do nothing
                }
                elsif ((defined($A1) && !defined($A2)) || (!defined($A1) && defined($A2)) ||
                    $Self->DataDiff(Data1 => $A1, Data2 => $A2) || ($Config{Valid} && !$ConfigDefault{Valid})
                ) {
                    $File .= "\$Self->{'$Name'} = $C";
                }
                else {
                    # do nothing
                }
            }
            elsif (!$Config{Valid} && ($ConfigDefault{Valid} || eval('$Self->{ConfigDefaultObject}->{\''. $Name . '\'}'))) {
                $File .= "delete \$Self->{'$Name'};\n";
            }
        }
    }
    if (!open(OUT, "> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm!");
        return;
    }
    else {
        print OUT $File;
        print OUT "\$Self->{'1'} = 1;\n";
        close(OUT);
        return 1;
    }
}

=item ConfigItemUpdate()

submit config settings and save it

    $ConfigToolObject->ConfigItemUpdate(
        Valid => 1,
        Key => 'WebUploadCacheModule',
        Value => 'Kernel::System::Web::UploadCache::DB',
    );

=cut

sub ConfigItemUpdate {
    my $Self = shift;
    my %Param = @_;
    my $Home = $Self->{'Home'};
    # remember to update defaults
    $Self->{Update} = 1;
    # check needed stuff
    foreach (qw(Valid Key Value)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!open(OUT, ">> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm: $!");
        return;
    }
    else {
        # diff
        my %ConfigDefault = $Self->ConfigItemGet(
            Name => $Param{Key},
            Default => 1,
        );
        my %Config = $Self->ConfigItemGet(
            Name => $Param{Key},
        );
        $Param{Key} =~ s/\\/\\\\/g;
        $Param{Key} =~ s/'/\'/g;
        $Param{Key} =~ s/###/'}->{'/g;
        # store in config
        if (!$Param{Valid}) {
            my $Dump = "delete \$Self->{'$Param{Key}'};\n";
            print OUT $Dump;
            close(OUT);
            return 1;
        }
        else {
            my $Dump = Data::Dumper::Dumper($Param{Value});
            $Dump =~ s/\$VAR1/\$Self->{'$Param{Key}'}/;
            print OUT $Dump;
            close(OUT);
            return 1;
        }
    }
}

=item ConfigItemUpdateFinish()

insert the final line "$Self->{'1'} = 1;" after building the file
ZZZAuto.pm

    $ConfigToolObject->ConfigItemUpdateFinish();

=cut

sub ConfigItemUpdateFinish {
    my $Self = shift;
    my %Param = @_;
    my $Home = $Self->{'Home'};

    if (!open(OUT, ">> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write finish tag $Home/Kernel/Config/Files/ZZZAuto.pm: $!");
        return;
    }
    else {
        print OUT "\$Self->{'1'} = 1;\n";
        close(OUT);
        return 1;
    }
}

=item ConfigItemGet()

get the current config setting

    my %Config = $ConfigToolObject->ConfigItemGet(
        Name => 'Ticket::NumberGenerator',
    );

get the default config setting

    my %Config = $ConfigToolObject->ConfigItemGet(
        Name => 'Ticket::NumberGenerator',
        Default => 1,
    );

=cut

sub ConfigItemGet {
    my $Self = shift;
    my %Param = @_;
    my $XMLConfig;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $Level = '';
    if ($Param{Default}) {
        $Level = 'Default';
    }

    if ($Self->{Config}->{$Param{Name}}) {
        # copy config and store it as default
        my $Dump = Data::Dumper::Dumper($Self->{Config}->{$Param{Name}});
        $Dump =~ s/\$VAR1 =/\$ConfigItem =/;
        # rh as 8 bug fix
        $Dump =~ s/\${\\\$VAR1->{'.+?'}\[0\]}/\{\}/g;
        my $ConfigItem;
        if (!eval "$Dump") {
            die "ERROR: $!: $@ in $Dump";
        }
        # add current valid state
        if (!$Param{Default} && !defined($Self->_ModGet(ConfigName => $ConfigItem->{Name}))) {
            $ConfigItem->{Valid} = 0;
        }
        elsif (!$Param{Default}) {
            $ConfigItem->{Valid} = 1;
        }
        # update xml with current config setting
        if ($ConfigItem->{Setting}->[1]->{String}) {
            # fill default
            $ConfigItem->{Setting}->[1]->{String}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{String}->[1]->{Content};
            my $String = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($String)) {
                $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} = $String;
            }
        }
        if ($ConfigItem->{Setting}->[1]->{TextArea}) {
            # fill default
            $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content};
            my $TextArea = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($TextArea)) {
                $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content} = $TextArea;
            }
        }
        if ($ConfigItem->{Setting}->[1]->{Option}) {
            # fill default
            $ConfigItem->{Setting}->[1]->{Option}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID};
            my $Option = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($Option)) {
                $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} = $Option;
            }
        }
        if ($ConfigItem->{Setting}->[1]->{Hash}) {
            my $HashRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($HashRef)) {
                my @Array = ();
                if (ref($ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}) eq 'ARRAY') {
                    @Array = @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}};
                }
                @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}} = (undef);
                my %Hash = %{$HashRef};
                foreach my $Key (sort keys %Hash) {
                    if (ref($Hash{$Key}) eq 'ARRAY') {
                        my @Array = (undef,{Content => '',});
                        @{$Array[1]{Item}} = (undef);
                        foreach my $Content (@{$Hash{$Key}}) {
                            push (@{$Array[1]{Item}}, {Content => $Content});
                        }
                        push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                Key => $Key,
                                Content => '',
                                Array => \@Array,
                            },
                        );
                    }
                    elsif (ref($Hash{$Key}) eq 'HASH') {
                        my @Array = (undef,{Content => '',});
                        @{$Array[1]{Item}} = (undef);
                        foreach my $Key2 (keys %{$Hash{$Key}}) {
                            push (@{$Array[1]{Item}}, {Content => $Hash{$Key}{$Key2}, Key => $Key2});
                        }
                        push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                Key => $Key,
                                Content => '',
                                Hash => \@Array,
                            },
                        );
                    }
                    else {
                        my $Option = 0;
                        foreach my $Index (1..$#Array) {
                            if (defined ($Array[$Index]{Key}) && $Array[$Index]{Key} eq $Key && defined ($Array[$Index]{Option})) {
                                $Option = 1;
                                $Array[$Index]{Option}[1]{SelectedID} = $Hash{$Key};
                                push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                        Key => $Key,
                                        Content => '',
                                        Option => $Array[$Index]{Option},
                                    },
                                );
                            }
                        }
                        if ($Option == 0) {
                            push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                    Key => $Key,
                                    Content => $Hash{$Key},
                                },
                            );
                        }
                    }
                }
            }
        }
        if ($ConfigItem->{Setting}->[1]->{Array}) {
            my $ArrayRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($ArrayRef)) {
                @{$ConfigItem->{Setting}->[1]->{Array}->[1]->{Item}} = (undef);
                my @Array = @{$ArrayRef};
                foreach my $Key (@Array) {
                    push (@{$ConfigItem->{Setting}->[1]->{Array}->[1]->{Item}}, {
                            Content => $Key,
                        },
                    );
                }
            }
        }
        if ($ConfigItem->{Setting}->[1]->{FrontendModuleReg}) {
            my $HashRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($HashRef)) {
                @{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}} = (undef);
                my %Hash = %{$HashRef};
                foreach my $Key (sort keys %Hash) {
                    @{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}} = (undef);
                    if ($Key eq 'Group' || $Key eq 'GroupRo') {
                        my @Array = (undef);
                        foreach my $Content (@{$Hash{$Key}}) {
                            push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}},
                                {
                                    Content => $Content,
                                }
                            );
                        }
                    }
                    elsif ($Key eq 'NavBar' || $Key eq 'NavBarModule') {
                        if (ref($Hash{$Key}) eq 'ARRAY') {
                            foreach my $Content (@{$Hash{$Key}}) {
                                my %NavBar;
                                foreach (sort keys %{$Content}) {
                                    if ($_ eq 'Group' || $_ eq 'GroupRo') {
                                        @{$NavBar{$_}} = (undef);
                                        foreach my $Group (@{$Content->{$_}}) {
                                            push (@{$NavBar{$_}}, {Content => $Group});
                                        }
                                    }
                                    else {
                                        push (@{$NavBar{$_}}, (undef, {Content => $Content->{$_}}));
                                    }
                                }
                                push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}, \%NavBar);
                            }
                        }
                        else {
                            my %NavBar;
                            my $Content = $Hash{$Key};
                            foreach (sort keys %{$Content}) {
                                if ($_ eq 'Group' || $_ eq 'GroupRo') {
                                    @{$NavBar{$_}} = (undef);
                                    foreach my $Group (@{$Content->{$_}}) {
                                        push (@{$NavBar{$_}}, {Content => $Group});
                                    }
                                }
                                else {
                                    push (@{$NavBar{$_}}, (undef, {Content => $Content->{$_}}));
                                }
                            }
                            $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} = \%NavBar;
                        }
                    }
                    else {
                        push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}},
                            {Content => $Hash{$Key}}
                        );
                    }
                }
            }
        }
        if ($ConfigItem->{Setting}->[1]->{TimeWorkingHours}) {
            my $DaysRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($DaysRef)) {
                @{$ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}} = (undef);
                my %Days = %{$DaysRef};
                foreach my $Day (keys %Days) {
                    my @Array = (undef);
                    foreach my $Hour (@{$Days{$Day}}) {
                        push (@Array, { Content => $Hour, });
                    }
                    push (@{$ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}}, {
                            Name => $Day,
                            Hour => \@Array,
                        },
                    );
                }
            }
        }
        if ($ConfigItem->{Setting}->[1]->{TimeVacationDays}) {
            my $HashRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($HashRef)) {
                @{$ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item}} = (undef);
                my %Hash = %{$HashRef};
                foreach my $Month (sort {$a <=> $b} keys %Hash) {

                    if ($Hash{$Month}) {
                        my %Days = %{$Hash{$Month}};
                        foreach my $Day (sort {$a <=> $b} keys %Days) {

                            push (@{$ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item}}, {
                                    Month => $Month,
                                    Day => $Day,
                                    Content => $Hash{$Month}->{$Day},
                                },
                            );
                        }
                    }
                }
            }
        }
        if ($ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}) {
            my $HashRef = $Self->_ModGet(ConfigName => $ConfigItem->{Name}, Level => $Level);
            if (!$Param{Default} && defined($HashRef)) {
                @{$ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}} = (undef);
                my %Hash = %{$HashRef};
                foreach my $Year (sort {$a <=> $b} keys %Hash) {
                    my %Months = %{$Hash{$Year}};
                    if (%Months) {
                        foreach my $Month (sort {$a <=> $b} keys %Months) {
                            foreach my $Day (sort {$a <=> $b} keys %{$Hash{$Year}->{$Month}}) {
                                push (@{$ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}}, {
                                        Year => $Year,
                                        Month => $Month,
                                        Day => $Day,
                                        Content => $Hash{$Year}->{$Month}->{$Day},
                                    },
                                );
                            }
                        }
                    }
                }
            }
        }
        if (!$Param{Default}) {
            my %ConfigItemDefault = $Self->ConfigItemGet(
                Name => $Param{Name},
                Default => 1,
            );
            my $C = $Self->_XML2Perl(Data => $ConfigItem);
            my $D = $Self->_XML2Perl(Data => \%ConfigItemDefault);
            my ($A1, $A2);
            eval "\$A1 = $C";
            eval "\$A2 = $D";
            if ($ConfigItemDefault{Valid} ne $ConfigItem->{Valid}) {
                $ConfigItem->{Diff} = 1;
            }
            elsif (!defined($A1) && !defined($A2)) {
                $ConfigItem->{Diff} = 0;
            }
            elsif ((defined($A1) && !defined($A2)) || (!defined($A1) && defined($A2)) || $Self->DataDiff(Data1 => $A1, Data2 => $A2)) {
                $ConfigItem->{Diff} = 1;
            }
        }
        if ($ConfigItem->{Setting}->[1]->{Option} && $ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}) {
            my $Home = $Self->{Home};
            my @List = glob($Home."/$ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}");
            foreach my $Item (@List) {
                $Item =~ s/$Home//g;
                $Item =~ s/^[A-z]://g;
                $Item =~ s/\\/\//g;
                $Item =~ s/\/\//\//g;
                $Item =~ s/^\///g;
                $Item =~ s/^(.*)\.pm/$1/g;
                $Item =~ s/\//::/g;
                $Item =~ s/\//::/g;
                my $Value = $Item;
                my $Key = $Item;
                $Value =~ s/^.*::(.+?)$/$1/g;
                if (!$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}) {
                    push (@{$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}}, undef);
                }
                push (@{$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}}, {
                        Key => $Key,
                        Content => $Value,
                    },
                );
            }
        }
        return %{$ConfigItem};
    }
}

sub ConfigItemReset {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %ConfigItemDefault = $Self->ConfigItemGet(
        Name => $Param{Name},
        Default => 1,
    );
    my $A = $Self->_XML2Perl(Data => \%ConfigItemDefault);
    my ($B);
    eval "\$B = $A";
    $Self->ConfigItemUpdate(Key => $Param{Name}, Value => $B, Valid => $ConfigItemDefault{Valid});
    return 1;
}

=item ConfigGroupList()

get a list of config groups

    my %ConfigGroupList = $ConfigToolObject->ConfigGroupList();

=cut

sub ConfigGroupList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %List = ();
    my %Count = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
            foreach my $Group (@{$ConfigItem->{Group}}) {
                if ($Group->{Content}) {
                    $Count{$Group->{Content}}++;
                    $List{$Group->{Content}} = "$Group->{Content} ($Count{$Group->{Content}})";
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupList()

get a list of config sub groups

    my %ConfigGroupList = $ConfigToolObject->ConfigSubGroupList(Name => 'Framework');

=cut

sub ConfigSubGroupList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %List = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
            my $Hit = 0;
            foreach my $Group (@{$ConfigItem->{Group}}) {
                if ($Group->{Content} && $Group->{Content} eq $Param{Name}) {
                    $Hit = 1;
                }
            }
            if ($Hit) {
                foreach my $SubGroup (@{$ConfigItem->{SubGroup}}) {
                    if ($SubGroup->{Content}) {
                        # get sub count
                        my @List = $Self->ConfigSubGroupConfigItemList(
                            Group => $Param{Name},
                            SubGroup => $SubGroup->{Content},
                        );
                        $List{$SubGroup->{Content}} = ($#List+1);
                    }
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupConfigItemList()

get a list of config items of a sub group

    my @ConfigItemList = $ConfigToolObject->ConfigSubGroupConfigItemList(
        Group => 'Framework',
        SubGroup => 'Web',
    );

=cut

sub ConfigSubGroupConfigItemList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Group SubGroup)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %Data = ();
    if ($Self->{'Cache::ConfigSubGroupConfigItemList'}) {
        %Data = %{$Self->{'Cache::ConfigSubGroupConfigItemList'}};
    }
    else {
        my %Used = ();
        foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
            my $Name = $ConfigItem->{Name};
            if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
                foreach my $Group (@{$ConfigItem->{Group}}) {
                    if ($Group && $ConfigItem->{SubGroup} && ref($ConfigItem->{SubGroup}) eq 'ARRAY') {
                        foreach my $SubGroup (@{$ConfigItem->{SubGroup}}) {
                            if (!$Used{$ConfigItem->{Name}} && $SubGroup->{Content} && $Group->{Content}) {
                                $Used{$ConfigItem->{Name}} = 1;
                                push (@{$Data{$Group->{Content}.'::'.$SubGroup->{Content}}},$ConfigItem->{Name});
                            }
                        }
                    }
                }
            }
        }
        $Self->{'Cache::ConfigSubGroupConfigItemList'} = \%Data;
    }
    if ($Data{$Param{Group}.'::'.$Param{SubGroup}}) {
        return @{$Data{$Param{Group}.'::'.$Param{SubGroup}}};
    }
    else {
        return ();
    }
}

=item ConfigItemSearch()

search sub groups of config items

    my @List = $ConfigToolObject->ConfigItemSearch(
        Search => 'some topic'
    );

=cut

sub ConfigItemSearch {
    my $Self = shift;
    my %Param = @_;
    my @List = ();
    my %Used = ();
    # check needed stuff
    foreach (qw(Search)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    $Param{Search} =~ s/\*//;
    my %Groups = $Self->ConfigGroupList();
    foreach my $Group (sort keys(%Groups)) {
        my %SubGroups = $Self->ConfigSubGroupList(Name => $Group);
        foreach my $SubGroup (sort keys %SubGroups) {
            my @Items = $Self->ConfigSubGroupConfigItemList(
                Group => $Group,
                SubGroup => $SubGroup,
            );
            foreach my $Item (@Items) {
                my $Config = $Self->_ModGet(ConfigName=> $Item);
                if ($Config && !$Used{$Group.'::'.$SubGroup}) {
                    if (ref($Config) eq 'ARRAY') {
                        foreach (@{$Config}) {
                            if (!$Used{$Group.'::'.$SubGroup}) {
                                if ($_ && $_ =~ /\Q$Param{Search}\E/i) {
                                    push (@List, {
                                            SubGroup => $SubGroup,
                                            SubGroupCount => $SubGroups{$SubGroup},
                                            Group => $Group,
                                        },
                                    );
                                    $Used{$Group.'::'.$SubGroup} = 1;
                                }
                            }
                        }
                    }
                    elsif (ref($Config) eq 'HASH') {
                        foreach my $Key (keys %{$Config}) {
                            if (!$Used{$Group.'::'.$SubGroup}) {
                                if ($Config->{$Key} && $Config->{$Key} =~ /\Q$Param{Search}\E/i) {
                                    push (@List, {
                                            SubGroup => $SubGroup,
                                            SubGroupCount => $SubGroups{$SubGroup},
                                            Group => $Group,
                                        },
                                    );
                                    $Used{$Group.'::'.$SubGroup} = 1;
                                }
                            }
                        }
                    }
                    else {
                        if ($Config =~ /\Q$Param{Search}\E/i) {
                            push (@List, {
                                    SubGroup => $SubGroup,
                                    SubGroupCount => $SubGroups{$SubGroup},
                                    Group => $Group,
                                },
                            );
                            $Used{$Group.'::'.$SubGroup} = 1;
                        }
                    }
                }
                if ($Item =~ /\Q$Param{Search}\E/i) {
                    if (!$Used{$Group.'::'.$SubGroup}) {
                        push (@List, {
                                SubGroup => $SubGroup,
                                SubGroupCount => $SubGroups{$SubGroup},
                                Group => $Group,
                            },
                        );
                        $Used{$Group.'::'.$SubGroup} = 1;
                    }
                }
                else {
                    my %ItemHash = $Self->ConfigItemGet(Name => $Item);
                    foreach my $Index (1..$#{$ItemHash{Description}}) {
                        if (!$Used{$Group.'::'.$SubGroup}) {
                            my $Description = $ItemHash{Description}[$Index]{Content};
                            if ($Description =~ /\Q$Param{Search}\E/i) {
                                push (@List, {
                                        SubGroup => $SubGroup,
                                        SubGroupCount => $SubGroups{$SubGroup},
                                        Group => $Group,
                                    },
                                );
                                $Used{$Group.'::'.$SubGroup} = 1;
                            }
                        }
                    }
                }
            }
        }
    }
    return @List;
}

sub _ModGet {
    my $Self = shift;
    my %Param = @_;
    my $Content;
    my $ConfigObject;
    # do not use ZZZ files
    if ($Param{Level} && $Param{Level} eq 'Default') {
        $ConfigObject = $Self->{ConfigDefaultObject};
    }
    elsif ($Param{Level} && $Param{Level} eq 'Clear') {
        $ConfigObject = $Self->{ConfigClearObject};
    }
    else {
        $ConfigObject = $Self->{ConfigObject};
    }
    if ($Param{ConfigName} =~ /^(.*)###(.*)###(.*)$/) {
        if (defined($ConfigObject->Get($1))) {
            $Content = $ConfigObject->Get($1)->{$2}->{$3};
        }
    }
    elsif ($Param{ConfigName} =~ /^(.*)###(.*)$/) {
        if (defined($ConfigObject->Get($1))) {
            $Content = $ConfigObject->Get($1)->{$2};
        }
    }
    else {
        if (defined($ConfigObject->Get($Param{ConfigName}))) {
            $Content = $ConfigObject->Get($Param{ConfigName});
        }
    }
    return $Content;
}

sub DataDiff {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Data1 Data2)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # ''
    if (ref($Param{Data1}) eq '' && ref($Param{Data2}) eq '') {
        if (!defined($Param{Data1}) && !defined($Param{Data2})) {
            # do noting, it's ok
            return 0;
        }
        elsif (!defined($Param{Data1}) || !defined($Param{Data2})) {
            # return diff, because its different
            return 1;
        }
        elsif ($Param{Data1} ne $Param{Data2}) {
            # return diff, because its different
            return 1;
        }
        else {
            # return 0, because its not different
            return 0;
        }
    }
    # SCALAR
    if (ref($Param{Data1}) eq 'SCALAR' && ref($Param{Data2}) eq 'SCALAR') {
        if (!defined(${$Param{Data1}}) && !defined(${$Param{Data2}})) {
            # do noting, it's ok
            return 0;
        }
        elsif (!defined(${$Param{Data1}}) || !defined(${$Param{Data2}})) {
            # return diff, because its different
            return 1;
        }
        elsif (${$Param{Data1}} ne ${$Param{Data2}}) {
            # return diff, because its different
            return 1;
        }
        else {
            # return 0, because its not different
            return 0;
        }
    }
    # ARRAY
    if (ref($Param{Data1}) eq 'ARRAY' && ref($Param{Data2}) eq 'ARRAY') {
        my @A = @{$Param{Data1}};
        my @B = @{$Param{Data2}};
        # check if the count is different
        if ($#A ne $#B) {
            return 1;
        }
        # compare array
        foreach my $Count (0..$#A) {
            if (!defined($A[$Count]) && !defined($B[$Count])) {
                # do noting, it's ok
            }
            elsif (!defined($A[$Count]) || !defined($B[$Count])) {
                # return diff, because its different
                return 1;
            }
            elsif ($A[$Count] ne $B[$Count]) {
                if (ref($A[$Count]) eq 'ARRAY' || ref($A[$Count]) eq 'HASH') {
                    if ($Self->DataDiff(Data1 => $A[$Count], Data2 => $B[$Count])) {
                        return 1;
                    }
                }
                else {
                    return 1;
                }
            }
        }
        return 0;
    }
    # HASH
    if (ref($Param{Data1}) eq 'HASH' && ref($Param{Data2}) eq 'HASH') {
        my %A = %{$Param{Data1}};
        my %B = %{$Param{Data2}};
        # compare %A with %B and remove it if checked
        foreach my $Key (keys %A) {
            if (!defined($A{$Key}) && !defined($B{$Key})) {
                # do noting, it's ok
            }
            elsif (!defined($A{$Key}) || !defined($B{$Key})) {
                # return diff, because its different
                return 1;
            }
            elsif ($A{$Key} eq $B{$Key}) {
                delete $A{$Key};
                delete $B{$Key};
            }
            # return if values are different
            else {
                if (ref($A{$Key}) eq 'ARRAY' || ref($A{$Key}) eq 'HASH') {
                    if ($Self->DataDiff(Data1 => $A{$Key}, Data2 => $B{$Key})) {
                        return 1;
                    }
                    else {
                        delete $A{$Key};
                        delete $B{$Key};
                    }
                }
                else {
                    return 1;
                }
            }
        }
        # check rest
        if (%B) {
            return 1;
        }
        else {
            return 0;
        }
    }
    return 1;
}

sub _XML2Perl {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Data)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $Data;
    if ($Param{Data}->{Setting}->[1]->{String}) {
        $Data = $Param{Data}->{Setting}->[1]->{String}->[1]->{Content};
        my $D = $Data;
        $Data = $D;
        # store in config
        my $Dump = Data::Dumper::Dumper($Data);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{Option}) {
        $Data = $Param{Data}->{Setting}->[1]->{Option}->[1]->{SelectedID};
        my $D = $Data;
        $Data = $D;
        # store in config
        my $Dump = Data::Dumper::Dumper($Data);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{TextArea}) {
        $Data = $Param{Data}->{Setting}->[1]->{TextArea}->[1]->{Content};
        $Data =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
        my $D = $Data;
        $Data = $D;
        # store in config
        my $Dump = Data::Dumper::Dumper($Data);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{Hash}) {
        my %Hash = ();
        my @Array = ();
        if (ref($Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}) eq 'ARRAY') {
            @Array = @{$Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}};
        }
        foreach my $Item (1..$#Array) {
            if (defined($Array[$Item]->{Hash})) {
                my %SubHash = ();
                foreach my $Index (1..$#{$Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}}) {
                    $SubHash{$Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]->{Key}} = $Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]->{Content};
                }
                $Hash{$Array[$Item]->{Key}} = \%SubHash;
            }
            elsif (defined($Array[$Item]->{Array})) {
                my @SubArray = ();
                foreach my $Index (1..$#{$Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item}}) {
                    push (@SubArray, $Param{Data}->{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item}->[$Index]->{Content});
                }
                $Hash{$Array[$Item]->{Key}} = \@SubArray;
            }
            else {
                $Hash{$Array[$Item]->{Key}} = $Array[$Item]->{Content};
            };
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\%Hash);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{Array}) {
        my @ArrayNew = ();
        my @Array = ();
        if (ref($Param{Data}->{Setting}->[1]->{Array}->[1]->{Item}) eq 'ARRAY') {
            @Array = @{$Param{Data}->{Setting}->[1]->{Array}->[1]->{Item}};
        }
        foreach my $Item (1..$#Array) {
            push (@ArrayNew, $Array[$Item]->{Content});
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\@ArrayNew);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{FrontendModuleReg}) {
        my %Hash = ();
        foreach my $Key (sort keys %{$Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]}) {
            if ($Key eq 'Group' || $Key eq 'GroupRo') {
                my @Array = ();
                foreach my $Index (1..$#{$Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}) {
                    push(@Array, $Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[$Index]->{Content});
                }
                $Hash{$Key} = \@Array;
            }
            elsif ($Key eq 'NavBar' || $Key eq 'NavBarModule') {
                if (ref($Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}) eq 'ARRAY') {
                    foreach my $Index (1..$#{$Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}) {
                        my $Content = $Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[$Index];
                        my %NavBar = ();
                        foreach my $Key (sort keys %{$Content}) {
                            if ($Key eq 'Group' || $Key eq 'GroupRo') {
                                my @Array = ();
                                foreach my $Index (1..$#{$Content->{$Key}}) {
                                    push(@Array, $Content->{$Key}->[$Index]->{Content});
                                }
                                $NavBar{$Key} = \@Array;
                            }
                            else {
                                if ($Key ne 'Content') {
                                    $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                                }
                            }
                        }
                        if ($Key eq 'NavBar') {
                            push (@{$Hash{$Key}}, \%NavBar);
                        }
                        else {
                            $Hash{$Key} = \%NavBar;
                        }
                    }
                }
                else {
                    my $Content = $Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key};
                    my %NavBar = ();
                    foreach my $Key (sort keys %{$Content}) {
                        if ($Key eq 'Group' || $Key eq 'GroupRo') {
                            my @Array = ();
                            foreach my $Index (1..$#{$Content->{$Key}}) {
                                push(@Array, $Content->{$Key}->[1]->{Content});
                            }
                            $NavBar{$Key} = \@Array;
                        }
                        else {
                            if ($Key ne 'Content') {
                                $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                            }
                        }
                    }
                    $Hash{$Key} = \%NavBar;
                }
            }
            else {
                if ($Key ne 'Content') {
                    $Hash{$Key} = $Param{Data}->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[1]->{Content};
                }
            }
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\%Hash);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{TimeWorkingHours}) {
        my %Days = ();
        my @Array = @{$Param{Data}->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}};
        foreach my $Day (1..$#Array) {
            my @Array2 = ();
            if ($Array[$Day]->{Hour}) {
                my @Hours = @{$Array[$Day]->{Hour}};
                foreach my $Hour (1..$#Hours) {
                    push (@Array2, $Hours[$Hour]->{Content});
                }
            }
            $Days{$Array[$Day]->{Name}} = \@Array2;
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\%Days);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{TimeVacationDays}) {
        my %Hash = ();
        my @Array = @{$Param{Data}->{Setting}->[1]->{TimeVacationDays}->[1]->{Item}};
        foreach my $Item (1..$#Array) {
            $Hash{$Array[$Item]->{Month}}->{$Array[$Item]->{Day}} = $Array[$Item]->{Content};
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\%Hash);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ($Param{Data}->{Setting}->[1]->{TimeVacationDaysOneTime}) {
        my %Hash = ();
        my @Array = @{$Param{Data}->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}};
        foreach my $Item (1..$#Array) {
            $Hash{$Array[$Item]->{Year}}->{$Array[$Item]->{Month}}->{$Array[$Item]->{Day}} = $Array[$Item]->{Content};
        }
        # store in config
        my $Dump = Data::Dumper::Dumper(\%Hash);
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    return $Data;
}

sub DESTROY {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{Update}) {
        # write default file
        $Self->WriteDefault();
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.64.2.1 $ $Date: 2008-01-03 23:26:45 $

=cut
