# --
# Kernel/System/SysConfig.pm - all system config tool functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig;

use strict;
use warnings;

use Storable qw();

use Kernel::System::XML;
use Kernel::Config;
use Kernel::Language;

=head1 NAME

Kernel::System::SysConfig - to manage sys config settings

=head1 SYNOPSIS

All functions to manage sys config settings.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::SysConfig;
    use Kernel::Language;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $LanguageObject = Kernel::Language->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $SysConfigObject = Kernel::System::SysConfig->new(
        ConfigObject   => $ConfigObject,
        EncodeObject   => $EncodeObject,
        LogObject      => $LogObject,
        DBObject       => $DBObject,
        MainObject     => $MainObject,
        TimeObject     => $TimeObject,
        LanguageObject => $LanugageObject,
    );

=cut

## no critic (StringyEval)

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get home directory
    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # set utf8 if used
    $Self->{utf8}     = 1;
    $Self->{FileMode} = ':utf8';

    # create xml object
    $Self->{XMLObject} = Kernel::System::XML->new( %{$Self} );

    # create config default object
    $Self->{ConfigDefaultObject} = Kernel::Config->new( %{$Self}, Level => 'Default' );

    # create config object
    $Self->{ConfigObject} = Kernel::Config->new( %{$Self}, Level => 'First' );

    # create config clear object
    $Self->{ConfigClearObject} = Kernel::Config->new( %{$Self}, Level => 'Clear' );

    # read all config files
    $Self->{ConfigCounter} = $Self->_Init();

    # create language object if it was not provided
    $Self->{LanguageObject} = $Param{LanguageObject} || Kernel::Language->new( %{$Self} );

    return $Self;
}

=item WriteDefault()

writes the default configuration file perl cache
(Kernel/Config/Files/ZZZAAuto.pm). It is the Perl representation
of the default XML configuration data (Kernel/Config/Files/*.xml).

=cut

sub WriteDefault {
    my ( $Self, %Param ) = @_;

    my $File = '';
    my %UsedKeys;

    # read all config files
    for my $ConfigItem ( @{ $Self->{XMLConfig} } ) {
        if ( $ConfigItem->{Name} && !$UsedKeys{ $ConfigItem->{Name} } ) {

            $UsedKeys{ $ConfigItem->{Name} } = 1;

            my %Config = $Self->ConfigItemGet(
                Name    => $ConfigItem->{Name},
                Default => 1,
            );

            my $Name = $Config{Name};
            $Name =~ s/\\/\\\\/g;
            $Name =~ s/'/\'/g;
            $Name =~ s/###/'}->{'/g;

            if ( $Config{Valid} ) {
                $File .= "\$Self->{'$Name'} = " . $Self->_XML2Perl( Data => \%Config );
            }
            elsif ( eval( '$Self->{ConfigDefaultObject}->{\'' . $Name . '\'}' ) ) {
                $File .= "delete \$Self->{'$Name'};\n";
            }
        }
    }

    # write default config file
    my $Out;
    $Out .= "# OTRS config file (automatically generated)\n";
    $Out .= "# VERSION:1.1\n";
    $Out .= "package Kernel::Config::Files::ZZZAAuto;\n";
    $Out .= "use strict;\n";
    $Out .= "use warnings;\n";
    if ( $Self->{utf8} ) {
        $Out .= "use utf8;\n";
    }
    $Out .= "sub Load {\n";
    $Out .= "    my (\$File, \$Self) = \@_;\n";
    $Out .= $File;
    $Out .= "}\n";
    $Out .= "1;\n";

    return $Self->_FileWriteAtomic(
        Filename => "$Self->{Home}/Kernel/Config/Files/ZZZAAuto.pm",
        Content  => \$Out,
    );
}

=item Download()

download config changes. This will return the content of
Kernel/Config/Files/ZZZAuto.pm, the file which contains all
configuration changes that the users made via AdminSysConfig.

    my $ConfigurationData = $SysConfigObject->Download();

If you want to check if it exists (returns true or false),
call it like this:

    my $ConfigurationExists = $SysConfigObject->Download(
        Type => 'Check',
    );

=cut

sub Download {
    my ( $Self, %Param ) = @_;

    my $Home = $Self->{Home};

    my $In;
    if ( !-e "$Home/Kernel/Config/Files/ZZZAuto.pm" ) {
        return '';
    }
    ## no critic
    elsif ( !open( $In, "<$Self->{FileMode}", "$Home/Kernel/Config/Files/ZZZAuto.pm" ) ) {
        ## use critic
        return if $Param{Type};

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't open $Home/Kernel/Config/Files/ZZZAuto.pm: $!"
        );
        return '';
    }

    # read file
    my $File = '';
    while (<$In>) {
        $File .= $_;
    }
    close($In);

    # return true/false on check
    if ( $Param{Type} ) {
        my $Length = length($File);
        if ( $Length > 25 ) {
            return 1;
        }
        return;
    }

    # return file
    return $File;
}

=item Upload()

upload of config changes. Pass the contents of
the file Kernel/Config/Files/ZZZAuto.pm here, as
read by L</Download()>.

Warning: this will replace the existing user
configuration changes.

    $SysConfigObject->Upload(
        Content => $Content,
    );

=cut

sub Upload {
    my ( $Self, %Param ) = @_;

    my $Home = $Self->{Home};

    # check needed stuff
    for (qw(Content)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $FileLocation = $Self->{MainObject}->FileWrite(
        Location => "$Home/Kernel/Config/Files/ZZZAuto.pm",
        Content  => \$Param{Content},
        Mode     => 'binmode',
    );

    return 1;
}

=item CreateConfig()

Submit config settings to application. This function will write
the internal state of the current SysConfig object to disk, saving
all changes that were made by the users to Kernel/Config/Files/ZZZAuto.pm.
Only values which differ from the default configuration are stored in this file.

    $SysConfigObject->CreateConfig();

if you want to create an empty file, for example on initial creation, you can
use the EmptyFile param.

    $SysConfigObject->CreateConfig( EmptyFile => 1 );

=cut

sub CreateConfig {
    my ( $Self, %Param ) = @_;

    my $File = '';
    my %UsedKeys;
    my $Home = $Self->{Home};

    # remember to update ZZZAAuto.pm and ZZZAuto.pm
    $Self->{Update} = 1;

    # read all config files and only save the changed config options
    if ( !$Param{EmptyFile} ) {

        for my $ConfigItem ( @{ $Self->{XMLConfig} } ) {

            if ( $ConfigItem->{Name} && !$UsedKeys{ $ConfigItem->{Name} } ) {

                my %Config = $Self->ConfigItemGet(
                    Name => $ConfigItem->{Name}
                );

                my %ConfigDefault = $Self->ConfigItemGet(
                    Name    => $ConfigItem->{Name},
                    Default => 1,
                );
                $UsedKeys{ $ConfigItem->{Name} } = 1;

                my $Name = $Config{Name};
                $Name =~ s/\\/\\\\/g;
                $Name =~ s/'/\'/g;
                $Name =~ s/###/'}->{'/g;

                if ( $Config{Valid} ) {

                    my $C = $Self->_XML2Perl( Data => \%Config );
                    my $D = $Self->_XML2Perl( Data => \%ConfigDefault );
                    my ( $A1, $A2 );
                    eval "\$A1 = $C";
                    eval "\$A2 = $D";

                    if ( !defined $A1 && !defined $A2 ) {

                        # do nothing
                    }
                    elsif (
                        ( defined $A1 && !defined $A2 )
                        || ( !defined $A1 && defined $A2 )
                        || $Self->_DataDiff( Data1 => \$A1, Data2 => \$A2 )
                        || ( $Config{Valid} && !$ConfigDefault{Valid} )
                        )
                    {
                        $File .= "\$Self->{'$Name'} = $C";
                    }
                    else {

                        # do nothing
                    }
                }
                elsif (
                    !$Config{Valid}
                    && (
                        $ConfigDefault{Valid}
                        || eval( '$Self->{ConfigDefaultObject}->{\'' . $Name . '\'}' )
                    )
                    )
                {
                    $File .= "delete \$Self->{'$Name'};\n";
                }
            }
        }
    }

    # write new config file
    my $Out;
    $Out .= "# OTRS config file (automatically generated)\n";
    $Out .= "# VERSION:1.1\n";
    $Out .= "package Kernel::Config::Files::ZZZAuto;\n";
    $Out .= "use strict;\n";
    $Out .= "use warnings;\n";
    if ( $Self->{utf8} ) {
        $Out .= "use utf8;\n";
    }
    $Out .= "sub Load {\n";
    $Out .= "    my (\$File, \$Self) = \@_;\n";
    $Out .= $File;
    $Out .= "}\n";
    $Out .= "1;\n";

    return $Self->_FileWriteAtomic(
        Filename => "$Self->{Home}/Kernel/Config/Files/ZZZAuto.pm",
        Content  => \$Out,
    );
}

=item ConfigItemUpdate()

submit config settings and save it.

    $SysConfigObject->ConfigItemUpdate(
        Valid        => 1,
        Key          => 'WebUploadCacheModule',
        Value        => 'Kernel::System::Web::UploadCache::DB',
        NoValidation => 1,    # (optional) no validation or auto-correction will be done, to prevent loops.
    );

=cut

sub ConfigItemUpdate {
    my ( $Self, %Param ) = @_;

    my $Home = $Self->{Home};

    # remember to update ZZZAAuto.pm and ZZZAuto.pm
    $Self->{Update} = 1;

    # check needed stuff
    for (qw(Valid Key Value)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if we need to create config file
    if ( !-e "$Home/Kernel/Config/Files/ZZZAuto.pm" && !$Self->CreateConfig( EmptyFile => 1 ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create empty $Home/Kernel/Config/Files/ZZZAuto.pm!",
        );
        return;
    }

    # check if config file is writable
    my $Out;
    ## no critic
    if ( !open( $Out, ">>$Self->{FileMode}", "$Home/Kernel/Config/Files/ZZZAuto.pm" ) ) {
        ## use critic
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm: $!",
        );
        return;
    }
    close($Out);

    # only validate and auto correct if param NoValidation is undefined or false
    if ( !$Param{NoValidation} ) {

        # validate the value, and auto-correct it if neccessary
        my $ValidateOk = $Self->ConfigItemValidate(
            Key   => $Param{Key},
            Value => $Param{Value},
        );

        # auto correct the value if the validation failed
        if ( !$ValidateOk ) {

            my $Result = $Self->ConfigItemValidate(
                Key         => $Param{Key},
                Value       => $Param{Value},
                Valid       => $Param{Valid},
                AutoCorrect => 1,
            );

            # no need to go further as the update of the config item
            # is done from within ConfigItemValidate() during auto-correction
            return 1;
        }
    }

    $Param{Key} =~ s/\\/\\\\/g;
    $Param{Key} =~ s/'/\'/g;
    $Param{Key} =~ s/###/'}->{'/g;

    # get option to store it
    my $Option = '';
    if ( !$Param{Valid} ) {
        $Option = "delete \$Self->{'$Param{Key}'};\n";
    }
    else {
        $Option = $Self->{MainObject}->Dump( $Param{Value}, 'ascii' );
        $Option =~ s/\$VAR1/\$Self->{'$Param{Key}'}/;
    }

    # set option in runtime
    my $OptionRuntime = $Option;
    $OptionRuntime =~ s/Self->/Self->\{ConfigObject\}->/;
    eval $OptionRuntime;

    # get config file and insert it
    my $In;
    ## no critic
    if ( !open( $In, "<$Self->{FileMode}", "$Home/Kernel/Config/Files/ZZZAuto.pm" ) ) {
        ## use critic

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't read $Home/Kernel/Config/Files/ZZZAuto.pm: $!",
        );
        return;
    }

    # update content
    my @FileOld = <$In>;
    my @FileNew;
    my $Insert = 0;
    for my $Line ( reverse @FileOld ) {
        push( @FileNew, $Line );
        if ( !$Insert && ( $Line =~ /^}/ || $Line =~ /^\$Self->\{'1'\} = 1;/ ) ) {
            push( @FileNew, $Option );
            $Insert = 1;
        }
    }
    close($In);

    my $Content;
    for my $Line ( reverse @FileNew ) {
        $Content .= $Line;
    }

    return $Self->_FileWriteAtomic(
        Filename => "$Self->{Home}/Kernel/Config/Files/ZZZAuto.pm",
        Content  => \$Content,
    );
}

=item ConfigItemGet()

get a current configuration setting, including changes
that the users made:

    my %Config = $SysConfigObject->ConfigItemGet(
        Name => 'Ticket::NumberGenerator',
    );

To get the default value of a configuration setting, pass
the Default flag:

    my %Config = $SysConfigObject->ConfigItemGet(
        Name    => 'Ticket::NumberGenerator',
        Default => 1,
    );

=cut

sub ConfigItemGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $Level = '';
    if ( $Param{Default} ) {
        $Level = 'Default';
    }

    # return on invalid config item
    return if !$Self->{Config}->{ $Param{Name} };

    # copy config and store it as default
    my $Dump = $Self->{MainObject}->Dump( $Self->{Config}->{ $Param{Name} }, 'ascii' );
    $Dump =~ s/\$VAR1 =/\$ConfigItem =/;

    # rh as 8 bug fix
    $Dump =~ s/\$\{\\\$VAR1->\{'.+?'}\[0\]}/\{\}/g;
    my $ConfigItem;
    if ( !eval $Dump ) {
        die "ERROR: $!: $@ in $Dump";
    }

    # add current valid state
    if ( !$Param{Default} && !defined $Self->_ModGet( ConfigName => $ConfigItem->{Name} ) ) {
        $ConfigItem->{Valid} = 0;
    }
    elsif ( !$Param{Default} ) {
        $ConfigItem->{Valid} = 1;
    }

    # update xml with current config setting
    if ( $ConfigItem->{Setting}->[1]->{String} ) {

        # fill default
        $ConfigItem->{Setting}->[1]->{String}->[1]->{Default}
            = $ConfigItem->{Setting}->[1]->{String}->[1]->{Content};
        my $String = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($String) ) {
            $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} = $String;
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{TextArea} ) {

        # fill default
        $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Default}
            = $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content};
        my $TextArea = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($TextArea) ) {
            $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content} = $TextArea;
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{Option} ) {

        # fill default
        $ConfigItem->{Setting}->[1]->{Option}->[1]->{Default}
            = $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID};
        my $Option = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($Option) ) {
            $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} = $Option;
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{Hash} ) {
        my $HashRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($HashRef) ) {
            my @Array;
            if ( ref $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} eq 'ARRAY' ) {
                @Array = @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} };
            }
            @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} } = (undef);
            my %Hash;
            if ( ref $HashRef eq 'HASH' ) {
                %Hash = %{$HashRef};
            }
            for my $Key ( sort keys %Hash ) {
                if ( ref $Hash{$Key} eq 'ARRAY' ) {
                    my @Array = ( undef, { Content => '', } );
                    @{ $Array[1]{Item} } = (undef);
                    for my $Content ( @{ $Hash{$Key} } ) {
                        push( @{ $Array[1]{Item} }, { Content => $Content } );
                    }
                    push(
                        @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} },
                        {
                            Key     => $Key,
                            Content => '',
                            Array   => \@Array,
                        },
                    );
                }
                elsif ( ref $Hash{$Key} eq 'HASH' ) {
                    my @Array = ( undef, { Content => '', } );
                    @{ $Array[1]{Item} } = (undef);
                    for my $Key2 ( sort keys %{ $Hash{$Key} } ) {
                        push(
                            @{ $Array[1]{Item} },
                            { Content => $Hash{$Key}{$Key2}, Key => $Key2 }
                        );
                    }
                    push(
                        @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} },
                        {
                            Key     => $Key,
                            Content => '',
                            Hash    => \@Array,
                        },
                    );
                }
                else {
                    my $Option = 0;
                    for my $Index ( 1 .. $#Array ) {
                        if (
                            defined( $Array[$Index]{Key} )
                            && $Array[$Index]{Key} eq $Key
                            && defined( $Array[$Index]{Option} )
                            )
                        {
                            $Option = 1;
                            $Array[$Index]{Option}[1]{SelectedID} = $Hash{$Key};
                            push(
                                @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} },
                                {
                                    Key     => $Key,
                                    Content => '',
                                    Option  => $Array[$Index]{Option},
                                },
                            );
                        }
                    }
                    if ( $Option == 0 ) {
                        push(
                            @{ $ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item} },
                            {
                                Key     => $Key,
                                Content => $Hash{$Key},
                            },
                        );
                    }
                }
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{Array} ) {
        my $ArrayRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($ArrayRef) ) {
            @{ $ConfigItem->{Setting}->[1]->{Array}->[1]->{Item} } = (undef);
            my @Array;
            if ( ref $ArrayRef eq 'ARRAY' ) {
                @Array = @{$ArrayRef};
            }
            for my $Key (@Array) {
                push(
                    @{ $ConfigItem->{Setting}->[1]->{Array}->[1]->{Item} },
                    { Content => $Key, },
                );
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{FrontendModuleReg} ) {
        my $HashRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($HashRef) ) {
            @{ $ConfigItem->{Setting}->[1]->{FrontendModuleReg} } = (undef);
            my %Hash;
            if ( ref $HashRef eq 'HASH' ) {
                %Hash = %{$HashRef};
            }
            for my $Key ( sort keys %Hash ) {
                @{ $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} } = (undef);
                if ( $Key eq 'Group' || $Key eq 'GroupRo' ) {
                    my @Array = (undef);
                    for my $Content ( @{ $Hash{$Key} } ) {
                        push(
                            @{ $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} },
                            { Content => $Content }
                        );
                    }
                }
                elsif ( $Key eq 'Loader' ) {
                    my %LoaderFiles;
                    for my $Key2 ( %{ $Hash{$Key} } ) {
                        if (
                            $Key2 eq 'CSS'
                            || $Key2 eq 'CSS_IE8'
                            || $Key2 eq 'JavaScript'
                            )
                        {
                            if ( ref $Key2 ne 'ARRAY' ) {
                                my @Files = (undef);
                                for my $Index ( 0 .. $#{ $Hash{$Key}->{$Key2} } ) {
                                    my $LoaderFile = $Hash{$Key}->{$Key2}[$Index];
                                    push(
                                        @Files,
                                        { Content => $LoaderFile },
                                    );
                                }
                                $LoaderFiles{$Key2} = \@Files;
                            }
                        }
                    }
                    push(
                        @{ $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} },
                        \%LoaderFiles,
                    );
                }
                elsif ( $Key eq 'NavBar' || $Key eq 'NavBarModule' ) {
                    if ( ref $Hash{$Key} eq 'ARRAY' ) {
                        for my $Content ( @{ $Hash{$Key} } ) {
                            my %NavBar;
                            for ( sort keys %{$Content} ) {
                                if ( $_ eq 'Group' || $_ eq 'GroupRo' ) {
                                    @{ $NavBar{$_} } = (undef);
                                    for my $Group ( @{ $Content->{$_} } ) {
                                        push( @{ $NavBar{$_} }, { Content => $Group } );
                                    }
                                }
                                else {
                                    push(
                                        @{ $NavBar{$_} },
                                        ( undef, { Content => $Content->{$_} } )
                                    );
                                }
                            }
                            push(
                                @{
                                    $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}
                                },
                                \%NavBar
                            );
                        }
                    }
                    else {
                        my %NavBar;
                        my $Content = $Hash{$Key};
                        for ( sort keys %{$Content} ) {
                            if ( $_ eq 'Group' || $_ eq 'GroupRo' ) {
                                @{ $NavBar{$_} } = (undef);
                                for my $Group ( @{ $Content->{$_} } ) {
                                    push( @{ $NavBar{$_} }, { Content => $Group } );
                                }
                            }
                            else {
                                push(
                                    @{ $NavBar{$_} },
                                    ( undef, { Content => $Content->{$_} } )
                                );
                            }
                        }
                        $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} = \%NavBar;
                    }
                }
                else {
                    push(
                        @{ $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} },
                        { Content => $Hash{$Key} }
                    );
                }
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{TimeWorkingHours} ) {
        my $DaysRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($DaysRef) ) {
            @{ $ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day} } = (undef);
            my %Days;
            if ( ref $DaysRef eq 'HASH' ) {
                %Days = %{$DaysRef};
            }
            for my $Day ( sort keys %Days ) {
                my @Array = (undef);
                for my $Hour ( @{ $Days{$Day} } ) {
                    push( @Array, { Content => $Hour, } );
                }
                push(
                    @{ $ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day} },
                    {
                        Name => $Day,
                        Hour => \@Array,
                    },
                );
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{TimeVacationDays} ) {
        my $HashRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($HashRef) ) {
            @{ $ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item} } = (undef);
            my %Hash;
            if ( ref $HashRef eq 'HASH' ) {
                %Hash = %{$HashRef};
            }
            for my $Month ( sort { $a <=> $b } keys %Hash ) {

                if ( $Hash{$Month} ) {
                    my %Days = %{ $Hash{$Month} };
                    for my $Day ( sort { $a <=> $b } keys %Days ) {
                        push(
                            @{ $ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item} },
                            {
                                Month   => $Month,
                                Day     => $Day,
                                Content => $Hash{$Month}->{$Day},
                            },
                        );
                    }
                }
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime} ) {
        my $HashRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($HashRef) ) {
            @{ $ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item} } = (undef);
            my %Hash;
            if ( ref $HashRef eq 'HASH' ) {
                %Hash = %{$HashRef};
            }
            for my $Year ( sort { $a <=> $b } keys %Hash ) {
                my %Months = %{ $Hash{$Year} };
                if (%Months) {
                    for my $Month ( sort { $a <=> $b } keys %Months ) {
                        for my $Day ( sort { $a <=> $b } keys %{ $Hash{$Year}->{$Month} } ) {
                            push(
                                @{
                                    $ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]
                                        ->{Item}
                                },
                                {
                                    Year    => $Year,
                                    Month   => $Month,
                                    Day     => $Day,
                                    Content => $Hash{$Year}->{$Month}->{$Day},
                                },
                            );
                        }
                    }
                }
            }
        }
    }
    if ( $ConfigItem->{Setting}->[1]->{DateTime} ) {

        # get data into a perl Hash
        my $HashRef = $Self->_ModGet( ConfigName => $ConfigItem->{Name}, Level => $Level );
        if ( !$Param{Default} && defined($HashRef) ) {

            # set perl hash into the correct XML structure for a DateTime setting
            # Setting => [
            #    undef,
            #    {
            #        Year => [
            #            undef,
            #            {
            #                Content => '2012',
            #            },
            #        ],
            #        ...
            #    },
            # ],
            for my $Part (qw(Year Month Day Hour Minute)) {
                $ConfigItem->{Setting}->[1]->{DateTime}->[1]->{$Part}->[1]->{Content}
                    = $HashRef->{$Part};
            }
        }
    }

    if ( !$Param{Default} ) {
        my %ConfigItemDefault = $Self->ConfigItemGet(
            Name    => $Param{Name},
            Default => 1,
        );
        my $C = $Self->_XML2Perl( Data => $ConfigItem );
        my $D = $Self->_XML2Perl( Data => \%ConfigItemDefault );
        my ( $A1, $A2 );
        eval "\$A1 = $C";
        eval "\$A2 = $D";
        if ( $ConfigItemDefault{Valid} ne $ConfigItem->{Valid} ) {
            $ConfigItem->{Diff} = 1;
        }
        elsif ( !defined $A1 && !defined $A2 ) {
            $ConfigItem->{Diff} = 0;
        }
        elsif (
            ( defined $A1 && !defined $A2 )
            || ( !defined $A1 && defined $A2 )
            || $Self->_DataDiff( Data1 => \$A1, Data2 => \$A2 )
            )
        {
            $ConfigItem->{Diff} = 1;
        }
    }
    if (
        $ConfigItem->{Setting}->[1]->{Option}
        && $ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}
        )
    {
        my $Home = $Self->{Home};
        my @List = $Self->{MainObject}->DirectoryRead(
            Directory => $Home,
            Filter    => "$ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}",
        );

        for my $Item (@List) {
            $Item =~ s/\Q$Home\E//g;
            $Item =~ s/^[A-z]://g;
            $Item =~ s/\\/\//g;
            $Item =~ s/\/\//\//g;
            $Item =~ s/^\///g;
            $Item =~ s/^(.*)\.pm/$1/g;
            $Item =~ s/\//::/g;
            $Item =~ s/\//::/g;
            my $Value = $Item;
            my $Key   = $Item;
            $Value =~ s/^.*::(.+?)$/$1/g;

            if ( !$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item} ) {
                push( @{ $ConfigItem->{Setting}->[1]->{Option}->[1]->{Item} }, undef );
            }
            push(
                @{ $ConfigItem->{Setting}->[1]->{Option}->[1]->{Item} },
                {
                    Key     => $Key,
                    Content => $Value,
                },
            );
        }
    }
    return %{$ConfigItem};
}

=item ConfigItemReset()

reset a configuration setting to its default value.

    $SysConfigObject->ConfigItemReset(
        Name => 'Ticket::NumberGenerator',
    );

=cut

sub ConfigItemReset {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %ConfigItemDefault = $Self->ConfigItemGet(
        Name    => $Param{Name},
        Default => 1,
    );
    my $A = $Self->_XML2Perl( Data => \%ConfigItemDefault );
    my ($B);
    eval "\$B = $A";

    $Self->ConfigItemUpdate( Key => $Param{Name}, Value => $B, Valid => $ConfigItemDefault{Valid} );
    return 1;
}

=item ConfigGroupList()

get the list of all available config groups.

    my %ConfigGroupList = $SysConfigObject->ConfigGroupList();

=cut

sub ConfigGroupList {
    my ( $Self, %Param ) = @_;

    my %List;
    my %Count;
    for my $ConfigItem ( @{ $Self->{XMLConfig} } ) {
        if ( $ConfigItem->{Group} && ref $ConfigItem->{Group} eq 'ARRAY' ) {
            for my $Group ( @{ $ConfigItem->{Group} } ) {
                if ( $Group->{Content} ) {
                    $Count{ $Group->{Content} }++;
                    $List{ $Group->{Content} } = "$Group->{Content} ($Count{$Group->{Content}})";
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupList()

get the list of all config sub groups of a given group.

    my %ConfigGroupList = $SysConfigObject->ConfigSubGroupList(
        Name => 'Framework',
    );

=cut

sub ConfigSubGroupList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %List;
    for my $ConfigItem ( @{ $Self->{XMLConfig} } ) {
        if ( $ConfigItem->{Group} && ref $ConfigItem->{Group} eq 'ARRAY' ) {
            my $Hit = 0;
            for my $Group ( @{ $ConfigItem->{Group} } ) {
                if ( $Group->{Content} && $Group->{Content} eq $Param{Name} ) {
                    $Hit = 1;
                }
            }
            if ($Hit) {
                for my $SubGroup ( @{ $ConfigItem->{SubGroup} } ) {
                    if ( $SubGroup->{Content} ) {

                        # get sub count
                        my @List = $Self->ConfigSubGroupConfigItemList(
                            Group    => $Param{Name},
                            SubGroup => $SubGroup->{Content},
                        );
                        $List{ $SubGroup->{Content} } = ( $#List + 1 );
                    }
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupConfigItemList()

get the list of config items of a config sub group

    my @ConfigItemList = $SysConfigObject->ConfigSubGroupConfigItemList(
        Group    => 'Framework',
        SubGroup => 'Web',
    );

=cut

sub ConfigSubGroupConfigItemList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Group SubGroup)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %Data;
    if ( $Self->{'Cache::ConfigSubGroupConfigItemList'} ) {
        %Data = %{ $Self->{'Cache::ConfigSubGroupConfigItemList'} };
    }
    else {
        my %Used;
        for my $ConfigItem ( @{ $Self->{XMLConfig} } ) {
            my $Name = $ConfigItem->{Name};
            if ( $ConfigItem->{Group} && ref $ConfigItem->{Group} eq 'ARRAY' ) {
                for my $Group ( @{ $ConfigItem->{Group} } ) {
                    if (
                        $Group
                        && $ConfigItem->{SubGroup}
                        && ref $ConfigItem->{SubGroup} eq 'ARRAY'
                        )
                    {
                        for my $SubGroup ( @{ $ConfigItem->{SubGroup} } ) {
                            if (
                                !$Used{ $ConfigItem->{Name} }
                                && $SubGroup->{Content}
                                && $Group->{Content}
                                )
                            {
                                $Used{ $ConfigItem->{Name} } = 1;
                                push(
                                    @{
                                        $Data{ $Group->{Content} . '::' . $SubGroup->{Content} }
                                    },
                                    $ConfigItem->{Name}
                                );
                            }
                        }
                    }
                }
            }
        }
        $Self->{'Cache::ConfigSubGroupConfigItemList'} = \%Data;
    }
    if ( $Data{ $Param{Group} . '::' . $Param{SubGroup} } ) {
        return reverse @{ $Data{ $Param{Group} . '::' . $Param{SubGroup} } };
    }
    return ();
}

=item ConfigItemSearch()

search for sub groups of config items. It will return all subgroups
with settings which contain the search term.

    my @List = $SysConfigObject->ConfigItemSearch(
        Search => 'some topic',
    );

=cut

sub ConfigItemSearch {
    my ( $Self, %Param ) = @_;

    my @List;
    my %Used;

    # check needed stuff
    for (qw(Search)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Param{Search} =~ s/\*//;
    my %Groups = $Self->ConfigGroupList();
    for my $Group ( sort keys(%Groups) ) {
        my %SubGroups = $Self->ConfigSubGroupList( Name => $Group );
        for my $SubGroup ( sort keys %SubGroups ) {
            my @Items = $Self->ConfigSubGroupConfigItemList(
                Group    => $Group,
                SubGroup => $SubGroup,
            );
            for my $Item (@Items) {
                my $Config = $Self->_ModGet( ConfigName => $Item );
                if ( $Config && !$Used{ $Group . '::' . $SubGroup } ) {
                    if ( ref $Config eq 'ARRAY' ) {
                        for ( @{$Config} ) {
                            if ( !$Used{ $Group . '::' . $SubGroup } ) {
                                if ( $_ && $_ =~ /\Q$Param{Search}\E/i ) {
                                    push(
                                        @List,
                                        {
                                            SubGroup      => $SubGroup,
                                            SubGroupCount => $SubGroups{$SubGroup},
                                            Group         => $Group,
                                        },
                                    );
                                    $Used{ $Group . '::' . $SubGroup } = 1;
                                }
                            }
                        }
                    }
                    elsif ( ref $Config eq 'HASH' ) {
                        for my $Key ( sort keys %{$Config} ) {
                            if ( !$Used{ $Group . '::' . $SubGroup } ) {
                                if ( $Config->{$Key} && $Config->{$Key} =~ /\Q$Param{Search}\E/i ) {
                                    push(
                                        @List,
                                        {
                                            SubGroup      => $SubGroup,
                                            SubGroupCount => $SubGroups{$SubGroup},
                                            Group         => $Group,
                                        },
                                    );
                                    $Used{ $Group . '::' . $SubGroup } = 1;
                                }
                            }
                        }
                    }
                    else {
                        if ( $Config =~ /\Q$Param{Search}\E/i ) {
                            push(
                                @List,
                                {
                                    SubGroup      => $SubGroup,
                                    SubGroupCount => $SubGroups{$SubGroup},
                                    Group         => $Group,
                                },
                            );
                            $Used{ $Group . '::' . $SubGroup } = 1;
                        }
                    }
                }
                if ( $Item =~ /\Q$Param{Search}\E/i ) {
                    if ( !$Used{ $Group . '::' . $SubGroup } ) {
                        push(
                            @List,
                            {
                                SubGroup      => $SubGroup,
                                SubGroupCount => $SubGroups{$SubGroup},
                                Group         => $Group,
                            },
                        );
                        $Used{ $Group . '::' . $SubGroup } = 1;
                    }
                }
                else {
                    my %ItemHash = $Self->ConfigItemGet( Name => $Item );
                    for my $Index ( 1 .. $#{ $ItemHash{Description} } ) {
                        if ( !$Used{ $Group . '::' . $SubGroup } ) {
                            my $Description = $ItemHash{Description}[$Index]{Content};

                        # compare with the English description and also with the translated sentence
                            if (
                                ( $Description =~ /\Q$Param{Search}\E/i )
                                || (
                                    $Self->{LanguageObject}->Get($Description)
                                    =~ /\Q$Param{Search}\E/i
                                )
                                )
                            {
                                push(
                                    @List,
                                    {
                                        SubGroup      => $SubGroup,
                                        SubGroupCount => $SubGroups{$SubGroup},
                                        Group         => $Group,
                                    },
                                );
                                $Used{ $Group . '::' . $SubGroup } = 1;
                            }
                        }
                    }
                }
            }
        }
    }
    return @List;
}

=item ConfigItemTranslatableStrings()

returns a unique list of all translatable strings in the
XML configuration.

=cut

sub ConfigItemTranslatableStrings {
    my ( $Self, %Param ) = @_;

    # empty translation list
    $Self->{ConfigItemTranslatableStrings} = {};

    # get all groups
    my %ConfigGroupList = $Self->ConfigGroupList();
    for my $Group ( sort keys %ConfigGroupList ) {

        # get all sub groups
        my %ConfigSubGroupList = $Self->ConfigSubGroupList(
            Name => $Group,
        );
        for my $SubGroup ( sort keys %ConfigSubGroupList ) {

            # get items
            my @ConfigItemList = $Self->ConfigSubGroupConfigItemList(
                Group    => $Group,
                SubGroup => $SubGroup,
            );
            for my $ConfigItem (@ConfigItemList) {

                # get attributes of each config item
                my %Config = $Self->ConfigItemGet(
                    Name    => $ConfigItem,
                    Default => 1,
                );
                next if !%Config;

                # get translatable strings
                $Self->_ConfigItemTranslatableStrings( Data => \%Config );
            }
        }
    }

    my @Strings;
    for my $Key ( sort keys %{ $Self->{ConfigItemTranslatableStrings} } ) {
        push @Strings, $Key;
    }
    return @Strings;
}

=item ConfigItemValidate()

Validates if the given value for this config item is correct.
If no value is given, the current value of the config item will be validated.
Returns true if it is valid, false otherwise.

    my $Result = $SysConfigObject->ConfigItemValidate(
        Key         => 'Ticket::Frontend::AgentTicketOwner###PriorityDefault',
        Value       => '3 normal',  # (optional)
        Valid       => 1,           # (optional) only used if AutoCorrect is set
        AutoCorrect => 1,           # (optional) auto-correct the config item
    );

=cut

sub ConfigItemValidate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );
        return;
    }

    # get the current config item
    my %ConfigItem = $Self->ConfigItemGet(
        Name => $Param{Key},
    );

    # check if a validate module is defined for this config option
    return 1 if !$ConfigItem{ValidateModule};
    return 1 if ref $ConfigItem{ValidateModule} ne 'ARRAY';
    return 1 if !$ConfigItem{ValidateModule}->[1]->{Content};

    # load the validate module
    my $ValidateObject = $Self->_LoadBackend(
        Module => $ConfigItem{ValidateModule}->[1]->{Content},
    );

    # module could not be loaded
    return if !$ValidateObject;

    # take the given value
    my $Value = $Param{Value};

    # if no value is given, take the already stored value
    if ( !defined $Param{Value} ) {

        # string
        if ( $ConfigItem{Setting}->[1]->{String}->[1]->{Content} ) {
            $Value = $ConfigItem{Setting}->[1]->{String}->[1]->{Content};
        }

        # textarea
        elsif ( $ConfigItem{Setting}->[1]->{TextArea}->[1]->{Content} ) {
            $Value = $ConfigItem{Setting}->[1]->{TextArea}->[1]->{Content};
        }

        # option
        # (more complex, so give the complete data structure)
        elsif ( $ConfigItem{Setting}->[1]->{Option}->[1] ) {
            $Value = $ConfigItem{Setting}->[1]->{Option}->[1];
        }

        # hash
        elsif ( $ConfigItem{Setting}->[1]->{Hash}->[1]->{Item} ) {
            $Value = $ConfigItem{Setting}->[1]->{Hash}->[1]->{Item};
        }

        # array
        elsif ( $ConfigItem{Setting}->[1]->{Array}->[1]->{Item} ) {
            $Value = $ConfigItem{Setting}->[1]->{Array}->[1]->{Item};
        }

        # FrontendModuleReg
        # (more complex, so give the complete data structure)
        elsif ( $ConfigItem{Setting}->[1]->{FrontendModuleReg}->[1] ) {
            $Value = $ConfigItem{Setting}->[1]->{FrontendModuleReg}->[1];
        }

        # TimeWorkingHours
        elsif ( $ConfigItem{Setting}->[1]->{TimeWorkingHours}->[1]->{Day} ) {
            $Value = $ConfigItem{Setting}->[1]->{TimeWorkingHours}->[1]->{Day};
        }

        # TimeVacationDays
        elsif ( $ConfigItem{Setting}->[1]->{TimeVacationDays}->[1]->{Item} ) {
            $Value = $ConfigItem{Setting}->[1]->{TimeVacationDays}->[1]->{Item};
        }

        # TimeVacationDaysOneTime
        elsif ( $ConfigItem{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item} ) {
            $Value = $ConfigItem{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item};
        }

        # DateTime
        elsif ( $ConfigItem{Setting}->[1]->{DateTime}->[1] ) {
            $Value = $ConfigItem{Setting}->[1]->{DateTime}->[1];
        }

        # unknown config item can not be validated, so return true
        else {
            return 1;
        }
    }

    # if auto-correction is requested
    if ( $Param{AutoCorrect} ) {

        # get the auto-correct value
        $Value = $ValidateObject->GetAutoCorrectValue(
            Data => $Value,
        );

        # if the valid param is given, use it, otherwise take valid setting from config item
        my $Valid = defined $Param{Valid} ? $Param{Valid} : $ConfigItem{Valid};

        # skip validation of invalid items
        return 1 if !$Valid;

        # update the config item with the new value
        my $UpdateSuccess = $Self->ConfigItemUpdate(
            Valid        => $Valid,
            Key          => $Param{Key},
            Value        => $Value,
            NoValidation => 1,
        );

        # return the update result
        return $UpdateSuccess;
    }

    # only validation is needed
    else {

        # validate the value
        my $ValidateOk = $ValidateObject->Validate(
            Data => $Value,
        );

        # return the validation result
        return $ValidateOk;
    }
}

=item ConfigItemCheckAll()

Validates all config items which have a validation module.
Automatically corrects wrong values.

    my $Result = $SysConfigObject->ConfigItemCheckAll();

=cut

sub ConfigItemCheckAll {
    my ( $Self, %Param ) = @_;

    # get all config groups
    my %Groups = $Self->ConfigGroupList();

    for my $Group ( sort keys(%Groups) ) {

        # get all subgroups for this group
        my %SubGroups = $Self->ConfigSubGroupList( Name => $Group );

        for my $SubGroup ( sort keys %SubGroups ) {

            # get all items for this subgroup
            my @Items = $Self->ConfigSubGroupConfigItemList(
                Group    => $Group,
                SubGroup => $SubGroup,
            );

            # check each item
            ITEM:
            for my $Item (@Items) {

                # validate the value of this item
                my $ValidateOk = $Self->ConfigItemValidate(
                    Key => $Item,
                );

                # validation is ok
                next ITEM if $ValidateOk;

                # validation is not ok, auto-correct the value
                my $AutoCorrectOk = $Self->ConfigItemValidate(
                    Key         => $Item,
                    AutoCorrect => 1,
                );
            }
        }
    }

    return 1;
}

=begin Internal:

=cut

sub _Init {
    my ( $Self, %Param ) = @_;

    my $Counter = 0;

    # load xml config files
    if ( -e "$Self->{Home}/Kernel/Config/Files/" ) {
        my %Data;
        my $Directory = "$Self->{Home}/Kernel/Config/Files/";
        my @Files     = $Self->{MainObject}->DirectoryRead(
            Directory => $Directory,
            Filter    => "*.xml",
        );

        # get the md5 representing the current configuration state
        my $ConfigChecksum = $Self->{ConfigObject}->ConfigChecksum();

        for my $File (@Files) {
            my $ConfigFile = '';
            my $In;
            ## no critic
            if ( open( $In, '<', $File ) ) {
                ## use critic

                $ConfigFile = do { local $/; <$In> };
                close $In;
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't open file $File: $!",
                );
            }
            my $FileCachePart = $File;
            $FileCachePart =~ s/\Q$Self->{Home}\E//;
            $FileCachePart =~ s/\/\//\//g;
            $FileCachePart =~ s/\//_/g;
            if ($ConfigFile) {
                my $CacheFileUsed = 0;
                my $Digest        = $Self->{MainObject}->MD5sum(
                    String => $ConfigFile . $ConfigChecksum,
                );
                my $FileCache = "$Self->{Home}/var/tmp/SysConfig-Cache$FileCachePart-$Digest.pm";
                if ( -e $FileCache ) {
                    my $ConfigFileCache = '';
                    my $In;
                    if ( open( $In, "<$Self->{FileMode}", $FileCache ) ) {
                        $ConfigFileCache = do { local $/; <$In> };
                        close $In;
                        my $XMLHashRef;
                        if ( eval $ConfigFileCache ) {
                            $Data{$File} = $XMLHashRef;
                            $CacheFileUsed = 1;
                        }
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Can't open cache file $FileCache: $!",
                        );
                    }
                }
                else {

                    # remove all cache files
                    my @List = $Self->{MainObject}->DirectoryRead(
                        Directory => "$Self->{Home}/var/tmp",
                        Filter    => "SysConfig-Cache$FileCachePart-*.pm",
                    );
                    for my $File (@List) {
                        unlink $File;
                    }
                }

                # parse config files
                if ( !$CacheFileUsed ) {
                    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $ConfigFile );
                    $Data{$File} = \@XMLHash;
                    my $Dump = $Self->{MainObject}->Dump( \@XMLHash, 'ascii' );
                    $Dump =~ s/\$VAR1/\$XMLHashRef/;
                    my $Out;

                    if ( $Self->{utf8} ) {
                        $Out .= "use utf8;\n";
                    }
                    $Out .= $Dump . "\n1;";

                    $Self->_FileWriteAtomic(
                        Filename => $FileCache,
                        Content  => \$Out,
                    );
                }
            }
        }
        $Self->{XMLConfig} = [];

        # load framework, application, config, changes
        for my $Init (qw(Framework Application Config Changes)) {
            for my $Set ( sort keys %Data ) {
                if (
                    defined $Data{$Set}->[1]->{otrs_config}->[1]->{init}
                    && $Data{$Set}->[1]->{otrs_config}->[1]->{init} eq $Init
                    )
                {

                    # just use valid entries
                    if ( $Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem} ) {
                        push(
                            @{ $Self->{XMLConfig} },
                            @{ $Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem} }
                        );
                    }
                    delete $Data{$Set};
                }
            }
        }

        # load misc
        for my $Set ( sort keys %Data ) {
            push(
                @{ $Self->{XMLConfig} },
                @{ $Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem} }
            );
            delete $Data{$Set};
        }
    }

    # remove duplicate entries
    my %Used;
    my @XMLConfig;
    for my $ConfigItem ( reverse @{ $Self->{XMLConfig} } ) {
        next if !$ConfigItem;
        next if !$ConfigItem->{Name};
        next if $Used{ $ConfigItem->{Name} };
        $Used{ $ConfigItem->{Name} } = 1;
        push @XMLConfig, $ConfigItem;
    }
    $Self->{XMLConfig} = \@XMLConfig;

    # read all config files
    for my $ConfigItem ( reverse @{ $Self->{XMLConfig} } ) {
        $Counter++;
        if ( $ConfigItem->{Name} && !$Self->{Config}->{ $ConfigItem->{Name} } ) {
            $Self->{Config}->{ $ConfigItem->{Name} } = $ConfigItem;
        }
    }
    return $Counter;
}

=item _DataDiff()

compares two data structures with each other. Returns 1 if
they are different, undef otherwise.

Data parameters need to be passed by reference and can be SCALAR,
ARRAY or HASH.

    my $DataIsDifferent = $SysConfigObject->_DataDiff(
        Data1 => \$Data1,
        Data2 => \$Data2,
    );

=cut

sub _DataDiff {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data1 Data2)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # ''
    if ( ref $Param{Data1} eq '' && ref $Param{Data2} eq '' ) {

        # do nothing, it's ok
        return if !defined $Param{Data1} && !defined $Param{Data2};

        # return diff, because its different
        return 1 if !defined $Param{Data1} || !defined $Param{Data2};

        # return diff, because its different
        return 1 if $Param{Data1} ne $Param{Data2};

        # return, because its not different
        return;
    }

    # SCALAR
    if ( ref $Param{Data1} eq 'SCALAR' && ref $Param{Data2} eq 'SCALAR' ) {

        # do nothing, it's ok
        return if !defined ${ $Param{Data1} } && !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if !defined ${ $Param{Data1} } || !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if ${ $Param{Data1} } ne ${ $Param{Data2} };

        # return, because its not different
        return;
    }

    # ARRAY
    if ( ref $Param{Data1} eq 'ARRAY' && ref $Param{Data2} eq 'ARRAY' ) {
        my @A = @{ $Param{Data1} };
        my @B = @{ $Param{Data2} };

        # check if the count is different
        return 1 if $#A ne $#B;

        # compare array
        for my $Count ( 0 .. $#A ) {

            # do nothing, it's ok
            next if !defined $A[$Count] && !defined $B[$Count];

            # return diff, because its different
            return 1 if !defined $A[$Count] || !defined $B[$Count];

            if ( $A[$Count] ne $B[$Count] ) {
                if ( ref $A[$Count] eq 'ARRAY' || ref $A[$Count] eq 'HASH' ) {
                    return 1 if $Self->_DataDiff( Data1 => $A[$Count], Data2 => $B[$Count] );
                    next;
                }
                return 1;
            }
        }
        return;
    }

    # HASH
    if ( ref $Param{Data1} eq 'HASH' && ref $Param{Data2} eq 'HASH' ) {
        my %A = %{ $Param{Data1} };
        my %B = %{ $Param{Data2} };

        # compare %A with %B and remove it if checked
        for my $Key ( sort keys %A ) {

            # Check if both are undefined
            if ( !defined $A{$Key} && !defined $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return diff, because its different
            return 1 if !defined $A{$Key} || !defined $B{$Key};

            if ( $A{$Key} eq $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return if values are different
            if ( ref $A{$Key} eq 'ARRAY' || ref $A{$Key} eq 'HASH' ) {
                return 1 if $Self->_DataDiff( Data1 => $A{$Key}, Data2 => $B{$Key} );
                delete $A{$Key};
                delete $B{$Key};
                next;
            }
            return 1;
        }

        # check rest
        return 1 if %B;
        return;
    }

    if ( ref $Param{Data1} eq 'REF' && ref $Param{Data2} eq 'REF' ) {
        return 1 if $Self->_DataDiff( Data1 => ${ $Param{Data1} }, Data2 => ${ $Param{Data2} } );
        return;
    }

    return 1;
}

=item DESTROY()

this destructor will recreate the configuration file after
changes were detected during module execution.

=cut

sub DESTROY {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Update} ) {

        # write default file
        $Self->WriteDefault();
    }
    return 1;
}

=item _FileWriteAtomic()

writes a file in an atomic operation. This is achieved by creating
a temporary file, filling and renaming it. This avoids inconsistent states
when the file is updated.

    my $Success = $SysConfigObject->_FileWriteAtomic(
        Filename => "$Self->{Home}/Kernel/Config/Files/ZZZAAuto.pm",
        Content  => \$NewContent,
    );

=cut

sub _FileWriteAtomic {
    my ( $Self, %Param ) = @_;

    for (qw(Filename Content)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $TempFilename = $Param{Filename} . '.' . $$;
    my $FH;

    ## no critic
    if ( !open( $FH, ">$Self->{FileMode}", $TempFilename ) ) {
        ## use critic

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't open file $TempFilename: $!",
        );
        return;
    }

    print $FH ${ $Param{Content} };
    close $FH;

    if ( !rename $TempFilename, $Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not rename $TempFilename to $Param{Filename}: $!"
        );
        return;
    }

    return 1;
}

sub _ConfigItemTranslatableStrings {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # ARRAY
    if ( ref $Param{Data} eq 'ARRAY' ) {
        for my $Key ( @{ $Param{Data} } ) {
            next if !$Key;
            $Self->_ConfigItemTranslatableStrings( Data => $Key );
        }
        return;
    }

    # HASH
    if ( ref $Param{Data} eq 'HASH' ) {
        for my $Key ( sort keys %{ $Param{Data} } ) {
            if (
                ref $Param{Data}->{$Key} eq ''
                && $Param{Data}->{Translatable}
                && $Param{Data}->{Content}
                )
            {
                return if !$Param{Data}->{Content};
                return if $Param{Data}->{Content} =~ /^\d+$/;
                $Self->{ConfigItemTranslatableStrings}->{ $Param{Data}->{Content} } = 1;
            }
            $Self->_ConfigItemTranslatableStrings( Data => $Param{Data}->{$Key} );
        }
    }
    return;
}

sub _ModGet {
    my ( $Self, %Param ) = @_;

    my $Content;
    my $ConfigObject;

    # do not use ZZZ files
    if ( $Param{Level} && $Param{Level} eq 'Default' ) {
        $ConfigObject = $Self->{ConfigDefaultObject};
    }
    elsif ( $Param{Level} && $Param{Level} eq 'Clear' ) {
        $ConfigObject = $Self->{ConfigClearObject};
    }
    else {
        $ConfigObject = $Self->{ConfigObject};
    }

    # get config value of HASH->HASH->HASH
    if ( $Param{ConfigName} =~ /^(.*)###(.*)###(.*)$/ ) {
        my $Config = $ConfigObject->Get($1);
        if ( defined $Config && ref $Config eq 'HASH' ) {
            my $ConfigSub = $Config->{$2};
            if ( defined $ConfigSub && ref $ConfigSub eq 'HASH' ) {
                $Content = $ConfigSub->{$3};
            }
        }
    }

    # get config value of HASH->HASH
    elsif ( $Param{ConfigName} =~ /^(.*)###(.*)$/ ) {
        my $Config = $ConfigObject->Get($1);
        if ( defined $Config && ref $Config eq 'HASH' ) {
            $Content = $Config->{$2};
        }
    }

    # get config value
    else {
        my $Config = $ConfigObject->Get( $Param{ConfigName} );
        if ( defined $Config ) {
            $Content = $Config;
        }
    }
    return $Content;
}

sub _XML2Perl {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $ConfigItem = $Param{Data}->{Setting}->[1];
    my $Data;
    if ( $ConfigItem->{String} ) {
        $Data = $ConfigItem->{String}->[1]->{Content};
        my $D = $Data;
        $Data = $D;

        # store in config
        my $Dump = $Self->{MainObject}->Dump( $Data, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{Option} ) {
        $Data = $ConfigItem->{Option}->[1]->{SelectedID};
        my $D = $Data;
        $Data = $D;

        # store in config
        my $Dump = $Self->{MainObject}->Dump( $Data, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{TextArea} ) {
        $Data = $ConfigItem->{TextArea}->[1]->{Content};
        $Data =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
        my $D = $Data;
        $Data = $D;

        # store in config
        my $Dump = $Self->{MainObject}->Dump( $Data, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{Hash} ) {
        my %Hash;
        my @Array;
        if ( ref $ConfigItem->{Hash}->[1]->{Item} eq 'ARRAY' ) {
            @Array = @{ $ConfigItem->{Hash}->[1]->{Item} };
        }
        for my $Item ( 1 .. $#Array ) {
            if ( defined $Array[$Item]->{Hash} ) {
                my %SubHash;
                for my $Index (
                    1 .. $#{ $ConfigItem->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item} }
                    )
                {
                    $SubHash{
                        $ConfigItem->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]
                            ->{Key}
                        }
                        = $ConfigItem->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]
                        ->{Content};
                }
                $Hash{ $Array[$Item]->{Key} } = \%SubHash;
            }
            elsif ( defined $Array[$Item]->{Array} ) {
                my @SubArray;
                for my $Index (
                    1 .. $#{ $ConfigItem->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item} }
                    )
                {
                    push(
                        @SubArray,
                        $ConfigItem->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item}->[$Index]
                            ->{Content}
                    );
                }
                $Hash{ $Array[$Item]->{Key} } = \@SubArray;
            }
            else {
                $Hash{ $Array[$Item]->{Key} } = $Array[$Item]->{Content};
            }
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Hash, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{Array} ) {
        my @ArrayNew;
        my @Array;
        if ( ref $ConfigItem->{Array}->[1]->{Item} eq 'ARRAY' ) {
            @Array = @{ $ConfigItem->{Array}->[1]->{Item} };
        }
        for my $Item ( 1 .. $#Array ) {
            push @ArrayNew, $Array[$Item]->{Content};
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \@ArrayNew, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{FrontendModuleReg} ) {
        my %Hash;
        for my $Key ( sort keys %{ $ConfigItem->{FrontendModuleReg}->[1] } ) {
            if ( $Key eq 'Group' || $Key eq 'GroupRo' ) {
                my @Array;
                for my $Index ( 1 .. $#{ $ConfigItem->{FrontendModuleReg}->[1]->{$Key} } ) {
                    push(
                        @Array,
                        $ConfigItem->{FrontendModuleReg}->[1]->{$Key}->[$Index]->{Content}
                    );
                }
                $Hash{$Key} = \@Array;
            }
            elsif ( $Key eq 'NavBar' || $Key eq 'NavBarModule' ) {
                if ( ref $ConfigItem->{FrontendModuleReg}->[1]->{$Key} eq 'ARRAY' ) {
                    for my $Index ( 1 .. $#{ $ConfigItem->{FrontendModuleReg}->[1]->{$Key} } ) {
                        my $Content = $ConfigItem->{FrontendModuleReg}->[1]->{$Key}->[$Index];
                        my %NavBar;
                        for my $Key ( sort keys %{$Content} ) {
                            if ( $Key eq 'Group' || $Key eq 'GroupRo' ) {
                                my @Array;
                                for my $Index ( 1 .. $#{ $Content->{$Key} } ) {
                                    push @Array, $Content->{$Key}->[$Index]->{Content};
                                }
                                $NavBar{$Key} = \@Array;
                            }
                            else {
                                if ( $Key ne 'Content' ) {
                                    $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                                }
                            }
                        }
                        if ( $Key eq 'NavBar' ) {
                            push @{ $Hash{$Key} }, \%NavBar;
                        }
                        else {
                            $Hash{$Key} = \%NavBar;
                        }
                    }
                }
                else {
                    my $Content = $ConfigItem->{FrontendModuleReg}->[1]->{$Key};
                    my %NavBar;
                    for my $Key ( sort keys %{$Content} ) {
                        if ( $Key eq 'Group' || $Key eq 'GroupRo' ) {
                            my @Array;
                            for my $Index ( 1 .. $#{ $Content->{$Key} } ) {
                                push @Array, $Content->{$Key}->[$Index]->{Content};
                            }
                            $NavBar{$Key} = \@Array;
                        }
                        else {
                            if ( $Key ne 'Content' ) {
                                $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                            }
                        }
                    }
                    $Hash{$Key} = \%NavBar;
                }
            }
            elsif ( $Key eq 'Loader' ) {
                my $Content = $ConfigItem->{FrontendModuleReg}->[1]->{$Key}->[1];
                my %Loader;
                for my $Key ( sort keys %{$Content} ) {
                    if (
                        $Key eq 'CSS'
                        || $Key eq 'CSS_IE8'
                        || $Key eq 'JavaScript'
                        )
                    {
                        my @Array;
                        for my $Index ( 1 .. $#{ $Content->{$Key} } ) {
                            push @Array, $Content->{$Key}->[$Index]->{Content};
                        }
                        $Loader{$Key} = \@Array;
                    }
                    else {
                        if ( $Key ne 'Content' ) {
                            $Loader{$Key} = $Content->{$Key}->[1]->{Content};
                        }
                    }
                }
                if (%Loader) {
                    $Hash{$Key} = \%Loader;
                }
            }
            else {
                if ( $Key ne 'Content' ) {
                    $Hash{$Key} = $ConfigItem->{FrontendModuleReg}->[1]->{$Key}->[1]->{Content};
                }
            }
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Hash, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{TimeWorkingHours} ) {
        my %Days;
        my @Array = @{ $ConfigItem->{TimeWorkingHours}->[1]->{Day} };
        for my $Day ( 1 .. $#Array ) {
            my @Array2;
            if ( $Array[$Day]->{Hour} ) {
                my @Hours = @{ $Array[$Day]->{Hour} };
                for my $Hour ( 1 .. $#Hours ) {
                    push @Array2, $Hours[$Hour]->{Content};
                }
            }
            $Days{ $Array[$Day]->{Name} } = \@Array2;
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Days, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{TimeVacationDays} ) {
        my %Hash;
        my @Array = @{ $ConfigItem->{TimeVacationDays}->[1]->{Item} };
        for my $Item ( 1 .. $#Array ) {
            $Hash{ $Array[$Item]->{Month} }->{ $Array[$Item]->{Day} } = $Array[$Item]->{Content};
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Hash, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{TimeVacationDaysOneTime} ) {
        my %Hash;
        my @Array = @{ $ConfigItem->{TimeVacationDaysOneTime}->[1]->{Item} };
        for my $Item ( 1 .. $#Array ) {
            $Hash{ $Array[$Item]->{Year} }->{ $Array[$Item]->{Month} }->{ $Array[$Item]->{Day} }
                = $Array[$Item]->{Content};
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Hash, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }
    if ( $ConfigItem->{DateTime} ) {
        my %Hash;

        # gather data from the XML structure and set it to a Perl hash
        for my $Part (qw(Year Month Day Hour Minute)) {
            $Hash{$Part} = $ConfigItem->{DateTime}->[1]->{$Part}->[1]->{Content};
        }

        # store in config
        my $Dump = $Self->{MainObject}->Dump( \%Hash, 'ascii' );
        $Dump =~ s/\$VAR1 =//;
        $Data = $Dump;
    }

    return $Data;
}

=item _LoadBackend()

Returns a newly loaded backend object

    my $BackendObject = $SysConfigObject->_LoadBackend(
        Module => 'Kernel::System::SysConfig::StateValidate',
    );

=cut

sub _LoadBackend {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Module} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Module!',
        );
        return;
    }

    # check if backend object is already cached
    return $Self->{Cache}->{LoadSysConfigBackend}->{ $Param{Module} }
        if $Self->{Cache}->{LoadSysConfigBackend}->{ $Param{Module} };

    # load the backend module
    if ( !$Self->{MainObject}->Require( $Param{Module} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load sysconfig backend module $Param{Module}!",
        );
        return;
    }

    # IMPORTANT
    # we need to create our own config object here,
    # otherwise the <OTRS_CONFIG_> variables would not be replaced,
    # e.g. as for <OTRS_CONFIG_TempDir>
    my $ConfigObject = Kernel::Config->new( %{$Self} );

    # create new instance
    my $BackendObject = $Param{Module}->new(
        %{$Self},
        %Param,
        ConfigObject => $ConfigObject,
    );

    # check for backend object
    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of sysconfig backend module $Param{Module}!",
        );
        return;
    }

    # cache the backend object
    $Self->{Cache}->{LoadSysConfigBackend}->{ $Param{Module} } = $BackendObject;

    return $BackendObject;
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
