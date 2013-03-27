# --
# Kernel/Modules/AdminSysConfig.pm - to change, import, export ConfigParameters
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSysConfig;

use strict;
use warnings;

use Kernel::System::SysConfig;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Param (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Param} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Param!" );
        }
    }

    # create additional objects
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Data;
    my $Group = '';
    my $Anker = '';

    # write default file
    if ( !$Self->{ParamObject}->GetParam( Param => 'DontWriteDefault' ) ) {
        if ( !$Self->{SysConfigObject}->WriteDefault() ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # download
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Download' ) {
        my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        $M = sprintf '%02d', $M;
        $D = sprintf '%02d', $D;
        $h = sprintf '%02d', $h;
        $m = sprintf '%02d', $m;

        # return file
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/octet-stream',
            Content     => $Self->{SysConfigObject}->Download(),
            Filename    => "SysConfigBackup" . "_" . "$Y-$M-$D" . "_$h-$m.pm",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # import
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Import' ) {
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
        $Self->{LayoutObject}->Block( Name => 'Import' );
    }

    # ------------------------------------------------------------ #
    # upload
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Upload' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
        );
        if ( !%UploadStuff ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need File!', );
        }
        elsif ( $Self->{SysConfigObject}->Upload( Content => $UploadStuff{Content} ) ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );

        }
        else {

            # redirect
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # ------------------------------------------------------------ #
    # update config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $SubGroup = $Self->{ParamObject}->GetParam( Param => 'SysConfigSubGroup' );
        my $Group    = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(
            Group    => $Group,
            SubGroup => $SubGroup,
        );

        # list all Items
        ITEM:
        for (@List) {

            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet( Name => $_ );

            # check if config item needs no update because it is not editable
            # because of an insufficient config level of the admin user
            if ( $Self->{ParamObject}->GetParam( Param => $_ . '-InsufficientConfigLevel' ) ) {
                next ITEM;
            }

            # Reset Item
            if ( defined $Self->{ParamObject}->GetParam( Param => "Reset$_" ) ) {
                $Self->{SysConfigObject}->ConfigItemReset( Name => $_ );
                $Anker = $ItemHash{Name};
                next;
            }

            # Get ElementActive (checkbox)
            my $Active = 0;
            if (
                ( $ItemHash{Required} && $ItemHash{Required} == 1 )
                || (
                    $Self->{ParamObject}->GetParam( Param => $_ . 'ItemActive' )
                    && $Self->{ParamObject}->GetParam( Param => $_ . 'ItemActive' ) == 1
                )
                )
            {
                $Active = 1;
            }

            # ConfigElement String
            if ( defined $ItemHash{Setting}->[1]->{String} ) {

                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => $Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TextArea
            if ( defined $ItemHash{Setting}->[1]->{TextArea} ) {

                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => $Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement PulldownMenu
            elsif ( defined $ItemHash{Setting}->[1]->{Option} ) {
                my $Content = $Self->{ParamObject}->GetParam( Param => $_ );

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => $Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement Hash
            elsif ( defined $ItemHash{Setting}->[1]->{Hash} ) {
                my @Keys         = $Self->{ParamObject}->GetArray( Param => $_ . 'Key[]' );
                my @Values       = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my @DeleteNumber = $Self->{ParamObject}->GetArray( Param => $_ . 'DeleteNumber[]' );
                my %Content;
                for my $Index ( 0 .. $#Keys ) {

                    # SubHash
                    if ( $Values[$Index] eq '##SubHash##' ) {
                        my @SubHashKeys = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubHash##' . $Keys[$Index] . 'Key[]',
                        );
                        my @SubHashValues = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubHash##' . $Keys[$Index] . 'Content[]',
                        );
                        my %SubHash;
                        for my $Index2 ( 0 .. $#SubHashKeys ) {

                            # Delete SubHash Element?
                            my $Delete = $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name}
                                    . '##SubHash##'
                                    . $Keys[$Index]
                                    . '#DeleteSubHashElement'
                                    . ( $Index2 + 1 )
                            );
                            if ( !$Delete ) {
                                $SubHash{ $SubHashKeys[$Index2] } = $SubHashValues[$Index2];
                            }
                            else {
                                $Anker = $ItemHash{Name};
                            }
                        }

                        # New SubHashElement
                        my $New = $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#' . $Keys[$Index] . '#NewSubElement',
                        );
                        if ($New) {
                            $SubHash{''} = '';
                            $Anker = $ItemHash{Name};
                        }
                        $Content{ $Keys[$Index] } = \%SubHash;
                    }

                    # SubArray
                    elsif ( $Values[$Index] eq '##SubArray##' ) {
                        my @SubArray = $Self->{ParamObject}->GetArray(
                            Param => $_ . '##SubArray##' . $Keys[$Index] . 'Content[]',
                        );

                        # New SubArrayElement
                        my $New = $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#' . $Keys[$Index] . '#NewSubElement',
                        );
                        if ($New) {
                            push @SubArray, '';
                            $Anker = $ItemHash{Name};
                        }

                        # Delete SubArray Element?
                        for my $Index2 ( 0 .. $#SubArray ) {
                            my $Delete = $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name}
                                    . '##SubArray##'
                                    . $Keys[$Index]
                                    . '#DeleteSubArrayElement'
                                    . ( $Index2 + 1 )
                            );
                            if ($Delete) {
                                splice( @SubArray, $Index2, 1 );
                                $Anker = $ItemHash{Name};
                            }
                        }
                        $Content{ $Keys[$Index] } = \@SubArray;
                    }

                    # Delete Hash Element?
                    elsif (
                        !$Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name} . '#DeleteHashElement' . $DeleteNumber[$Index],
                        )
                        )
                    {
                        $Content{ $Keys[$Index] } = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New HashElement
                my $New = $Self->{ParamObject}->GetParam(
                    Param => $ItemHash{Name} . '#NewHashElement'
                );
                if ($New) {
                    $Anker = $ItemHash{Name};
                    $Content{''} = '';
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement Array
            elsif ( defined $ItemHash{Setting}->[1]->{Array} ) {
                my @Content = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );

                # New ArrayElement
                my $New = $Self->{ParamObject}->GetParam(
                    Param => $ItemHash{Name} . '#NewArrayElement'
                );
                if ($New) {
                    push @Content, '';
                    $Anker = $ItemHash{Name};
                }

                # Delete Array Element
                for my $Index ( 0 .. $#Content ) {
                    my $Delete = $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#DeleteArrayElement' . ( $Index + 1 ),
                    );
                    if ($Delete) {
                        splice( @Content, $Index, 1 );
                        $Anker = $ItemHash{Name};
                    }
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \@Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement FrontendModuleReg
            elsif ( defined $ItemHash{Setting}->[1]->{FrontendModuleReg} ) {
                my $ElementKey = $_;
                my %Content;

                # get Params
                for (qw(Description Title NavBarName)) {
                    $Content{$_}
                        = $Self->{ParamObject}->GetParam( Param => $ElementKey . '#' . $_ );
                }
                for my $Type (qw(Group GroupRo)) {
                    my @Group = $Self->{ParamObject}->GetArray(
                        Param => $ElementKey . '#' . $Type . '[]',
                    );

                    # New Group(Ro)Element
                    my $New = $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#New' . $Type . 'Element',
                    );
                    if ($New) {
                        push @Group, '';
                        $Anker = $ItemHash{Name};
                    }

                    # Delete Group Element
                    for my $Index ( 0 .. $#Group ) {
                        my $Delete = $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name}
                                . '#Delete'
                                . $Type
                                . 'Element'
                                . ( $Index + 1 )
                        );
                        if ($Delete) {
                            splice( @Group, $Index, 1 );
                            $Anker = $ItemHash{Name};
                        }
                    }
                    if ( $#Group > -1 ) {
                        $Content{$Type} = \@Group;
                    }
                }

                # Loader start
                my @Loader = $Self->{ParamObject}->GetArray(
                    Param => $ElementKey . '#Loader[]',
                );
                my @LoaderFileTypes = (
                    'CSS',
                    'CSS_IE7',
                    'CSS_IE8',
                    'JavaScript',
                );

                # New Loader Element
                my $New = $Self->{ParamObject}->GetParam(
                    Param => $ElementKey . '#NewLoaderElement',
                );
                if ($New) {
                    push @Loader, '';
                    $Anker = $ElementKey;
                }

                my %LoaderFiles;

                # If @loader have values
                if (@Loader) {

                    # Find for every file kind
                    for my $Key (@LoaderFileTypes) {
                        my @LoaderArray;
                        for my $Index ( 0 .. $#Loader ) {
                            my $Delete = $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name} . '#DeleteLoaderElement' . ( $Index + 1 ),
                            );
                            if ( !$Delete ) {
                                my $TypeKey = $Self->{ParamObject}->GetParam(
                                    Param => $ElementKey . 'LoaderType' . ( $Index + 1 )
                                ) || 'JavaScript';
                                if ( $TypeKey && ( $Key eq $TypeKey ) ) {
                                    push @LoaderArray, $Loader[$Index];
                                }
                            }
                        }
                        if (@LoaderArray) {
                            $LoaderFiles{$Key} = \@LoaderArray;
                        }
                    }
                    $Content{Loader} = \%LoaderFiles;
                }

                # Loader finish

                # NavBar get Params
                my %NavBarParams;
                for (qw(Description Name Link LinkOption Type Prio Block NavBar AccessKey)) {
                    my @Param = $Self->{ParamObject}->GetArray(
                        Param => $ElementKey . '#NavBar#' . $_ . '[]'
                    );
                    $NavBarParams{$_} = \@Param;
                }

                # Add NavBar Element
                my $NewNavBar = $Self->{ParamObject}->GetParam(
                    Param => $ItemHash{Name} . '#NavBar#AddElement'
                );
                if ($NewNavBar) {
                    push @{ $NavBarParams{Description} }, '';
                    $Anker = $ItemHash{Name};
                }

                # Create Hash
                for my $Index ( 0 .. $#{ $NavBarParams{Description} } ) {
                    for my $Type (qw(Group GroupRo)) {
                        my @Group = $Self->{ParamObject}->GetArray(
                            Param => $ElementKey
                                . '#NavBar'
                                . ( $Index + 1 ) . '#'
                                . $Type
                                . '[]'
                        );

                        # New Group(Ro)Element
                        my $New = $Self->{ParamObject}->GetParam(
                            Param => $ItemHash{Name}
                                . '#NavBar'
                                . ( $Index + 1 ) . '#New'
                                . $Type
                                . 'Element'
                        );
                        if ($New) {
                            push @Group, '';
                            $Anker = $ItemHash{Name};
                        }

                        # Delete Group Element
                        for my $Index2 ( 0 .. $#Group ) {
                            my $Delete = $Self->{ParamObject}->GetParam(
                                Param => $ItemHash{Name}
                                    . '#NavBar'
                                    . ( $Index + 1 )
                                    . '#Delete'
                                    . $Type
                                    . 'Element'
                                    . ( $Index2 + 1 )
                            );
                            if ($Delete) {
                                splice( @Group, $Index2, 1 );
                                $Anker = $ItemHash{Name};
                            }
                        }
                        if ( $#Group > -1 ) {
                            $Content{NavBar}->[$Index]->{$Type} = \@Group;
                        }
                    }
                    for (
                        qw(Description Name Link LinkOption Type Prio Block NavBar AccessKey)
                        )
                    {
                        if ( defined $NavBarParams{$_}->[$Index] ) {
                            $Content{NavBar}->[$Index]->{$_} = $NavBarParams{$_}->[$Index];
                        }
                    }
                }

                # Delete NavBar Element
                for my $Index ( 0 .. $#{ $NavBarParams{Description} } ) {
                    my $Delete = $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name} . '#NavBar#' . ( $Index + 1 ) . '#DeleteElement'
                    );
                    if ($Delete) {
                        splice( @{ $Content{NavBar} }, $Index, 1 );
                        $Anker = $ItemHash{Name};
                    }
                }

                # NavBarModule
                my $NavBarModule = $Self->{ParamObject}->GetArray(
                    Param => $ElementKey . '#NavBarModule#Module[]',
                );
                if ($NavBarModule) {

                    # get Params
                    my %NavBarModuleParams;
                    for (qw(Module Name Description Block Prio)) {
                        my @Param = $Self->{ParamObject}->GetArray(
                            Param => $ElementKey . '#NavBarModule#' . $_ . '[]',
                        );
                        $NavBarModuleParams{$_} = \@Param;
                    }

                    # Create Hash
                    for (qw(Group GroupRo Module Name Description Block Prio)) {
                        if (
                            defined $NavBarModuleParams{$_}->[0]
                            && $NavBarModuleParams{$_}->[0] ne ''
                            )
                        {
                            $Content{NavBarModule}->{$_} = $NavBarModuleParams{$_}->[0];
                        }
                    }
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeVacationDaysOneTime
            elsif ( defined $ItemHash{Setting}->[1]->{TimeVacationDaysOneTime} ) {
                my @Year   = $Self->{ParamObject}->GetArray( Param => $_ . 'year[]' );
                my @Month  = $Self->{ParamObject}->GetArray( Param => $_ . 'month[]' );
                my @Day    = $Self->{ParamObject}->GetArray( Param => $_ . 'day[]' );
                my @Values = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my %Content;
                for my $Index ( 0 .. $#Year ) {

                    # Delete TimeVacationDaysOneTime Element?
                    my $Delete = $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name}
                            . '#DeleteTimeVacationDaysOneTimeElement'
                            . ( $Index + 1 )
                    );
                    if ( !$Delete ) {
                        $Content{ $Year[$Index] }->{ int( $Month[$Index] ) }
                            ->{ int( $Day[$Index] ) }
                            = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New TimeVacationDaysOneTimeElement
                my $New = $Self->{ParamObject}->GetParam(
                    Param => $ItemHash{Name} . '#NewTimeVacationDaysOneTimeElement'
                );
                if ($New) {
                    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $Self->{TimeObject}->SystemTime(),
                    );
                    $Content{$Y}->{''}->{''} = '-new-';
                    $Anker = $ItemHash{Name};
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeVacationDays
            elsif ( defined $ItemHash{Setting}->[1]->{TimeVacationDays} ) {
                my @Month  = $Self->{ParamObject}->GetArray( Param => $_ . 'month[]' );
                my @Day    = $Self->{ParamObject}->GetArray( Param => $_ . 'day[]' );
                my @Values = $Self->{ParamObject}->GetArray( Param => $_ . 'Content[]' );
                my %Content;
                for my $Index ( 0 .. $#Month ) {

                    # Delete TimeVacationDays Element?
                    my $Delete = $Self->{ParamObject}->GetParam(
                        Param => $ItemHash{Name}
                            . '#DeleteTimeVacationDaysElement'
                            . ( $Index + 1 )
                    );
                    if ( !$Delete ) {
                        $Content{ int( $Month[$Index] ) }->{ int( $Day[$Index] ) }
                            = $Values[$Index];
                    }
                    else {
                        $Anker = $ItemHash{Name};
                    }
                }

                # New TimeVacationDaysElement
                my $New = $Self->{ParamObject}->GetParam(
                    Param => $ItemHash{Name} . '#NewTimeVacationDaysElement'
                );
                if ($New) {
                    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $Self->{TimeObject}->SystemTime(),
                    );

                    $Content{$M}->{''} = '-new-';
                    $Anker = $ItemHash{Name};
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );

                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement TimeWorkingHours
            elsif ( defined $ItemHash{Setting}->[1]->{TimeWorkingHours} ) {
                my %Content;
                for my $Index ( 1 .. $#{ $ItemHash{Setting}->[1]->{TimeWorkingHours}->[1]->{Day} } )
                {
                    my $Weekday
                        = $ItemHash{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}->[$Index]->{Name};
                    my @Hours = $Self->{ParamObject}->GetArray( Param => $_ . $Weekday . '[]' );
                    $Content{$Weekday} = \@Hours;
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );
                if ( !$Update ) {
                    $Self->{LayoutObject}->FatalError( Message => "Can't write ConfigItem!" );
                }
            }

            # ConfigElement DateTime
            elsif ( defined $ItemHash{Setting}->[1]->{DateTime} ) {

                # set a safe prefix, substitue the '::' for a '_'
                my $Prefix = $ItemHash{Name};
                $Prefix =~ s{::}{_}g;

                my %Content;
                for my $Part (qw(Year Month Day Hour Minute)) {
                    $Content{$Part} = $Self->{ParamObject}->GetParam( Param => $Prefix . $Part )
                        || '00';
                }

                # write ConfigItem
                my $Update = $Self->{SysConfigObject}->ConfigItemUpdate(
                    Key   => $_,
                    Value => \%Content,
                    Valid => $Active,
                );
            }
        }

        # submit config changes
        $Self->{SysConfigObject}->CreateConfig();

        # if running under PerlEx, reload the application (and thus the configuration)
        if (
            exists $ENV{'GATEWAY_INTERFACE'}
            && $ENV{'GATEWAY_INTERFACE'} eq "CGI-PerlEx"
            )
        {
            PerlEx::ReloadAll();
        }

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Edit;SysConfigSubGroup=$SubGroup;SysConfigGroup=$Group;#$Anker",
        );
    }

    # ------------------------------------------------------------ #
    # edit config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {
        my $SubGroup = $Self->{ParamObject}->GetParam( Param => 'SysConfigSubGroup' );
        my $Group    = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(
            Group    => $Group,
            SubGroup => $SubGroup
        );

        # get the config level of the admin user
        my $ConfigLevel = $Self->{ConfigObject}->Get('ConfigLevel') || 0;

        # list all Items
        for (@List) {

            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet( Name => $_ );

            # Required
            my $Required = '';
            if ( $ItemHash{Required} ) {
                $Required = 'disabled="disabled"';
            }

            # Valid
            my $Valid      = '';
            my $Validstyle = 'Invalid';
            if ( $ItemHash{Valid} ) {
                $Valid      = 'checked="checked"';
                $Validstyle = '';
            }

            my $Description = $ItemHash{Description}[1]{Content};

            # Generate an ID that is valid XHTML for use in id attribute
            my $ItemKeyID = $ItemHash{Name};
            $ItemKeyID =~ s{\#}{_}gsm;

            # show the config element block
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementBlock',
                Data => {
                    ItemKey     => $ItemHash{Name},
                    ItemKeyID   => $ItemKeyID,
                    Description => $Description,
                    Valid       => $Valid,
                    Validstyle  => $Validstyle,
                    Required    => $Required,
                },
            );

            # the admin users config level is not sufficient to edit this config item
            if ( $ItemHash{ConfigLevel} && $ItemHash{ConfigLevel} < $ConfigLevel ) {

                # only show the name of the config item
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementInsufficientConfigLevel',
                    Data => {
                        ItemKey     => $ItemHash{Name},
                        ItemKeyID   => $ItemKeyID,
                        Description => $Description,
                        Valid       => $Valid,
                        Validstyle  => $Validstyle,
                        Required    => $Required,
                        ConfigLevel => $ItemHash{ConfigLevel},
                    },
                );
            }
            else {

                # show the complete config item
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementSufficientConfigLevel',
                    Data => {
                        ItemKey     => $ItemHash{Name},
                        ItemKeyID   => $ItemKeyID,
                        Description => $Description,
                        Valid       => $Valid,
                        Validstyle  => $Validstyle,
                        Required    => $Required,
                    },
                );

                # show icon to reset the config item to default
                if ( $ItemHash{Diff} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementBlockReset',
                        Data => { ItemKey => $_ },
                    );
                }

                # ListConfigItem
                $Self->ListConfigItem( Hash => \%ItemHash );
            }
        }

        $Data{SubGroup} = $SubGroup;
        $Data{Group}    = $Group;
        my $Output .= $Self->{LayoutObject}->Header( Value => "$Group -> $SubGroup" );
        $Output    .= $Self->{LayoutObject}->NavigationBar();
        $Output    .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSysConfigEdit',
            Data         => \%Data,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # search config
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Search' ) {

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block(
            Name => 'SearchBox',
            Data => {
                ConfigCounter => $Self->{SysConfigObject}->{ConfigCounter},
            },
        );

        # list Groups
        my %List = $Self->{SysConfigObject}->ConfigGroupList();

        # create select Box
        $Data{List} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%List,
            SelectedID   => $Group,
            Name         => 'SysConfigGroup',
            Translation  => 0,
            PossibleNone => 1,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ConfigGroups',
            Data => \%Data,
        );

        # check if sysconfig download link should be shown
        if ( $Self->{SysConfigObject}->Download( Type => 'Check' ) ) {
            $Self->{LayoutObject}->Block( Name => 'Download' );
        }

        $Self->{LayoutObject}->Block( Name => 'ActionImport' );
        $Self->{LayoutObject}->Block( Name => 'ContentOverview' );

        my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );

        # if a search parameter was provided
        if ($Search) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResult',
                Data => {},
            );
            my @List = $Self->{SysConfigObject}->ConfigItemSearch( Search => $Search );

            # if there are any results, they are shown
            if (@List) {
                for my $Option (@List) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Row',
                        Data => $Option,
                    );
                }
            }

            # otherwise a no data found msg is displayed
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'NoDataFoundMsg',
                    Data => {},
                );
            }
        }

        # otherwise a no search term msg is shown
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoSearchTerms',
                Data => {},
            );
        }
    }

    # ------------------------------------------------------------ #
    # list subgroups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SelectGroup' ) {

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block(
            Name => 'SearchBox',
            Data => {
                ConfigCounter => $Self->{SysConfigObject}->{ConfigCounter},
            },
        );

        # list Groups
        my %List = $Self->{SysConfigObject}->ConfigGroupList();

        $Group = $Self->{ParamObject}->GetParam( Param => 'SysConfigGroup' );

        # create select Box
        $Data{List} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%List,
            SelectedID   => $Group,
            Name         => 'SysConfigGroup',
            Translation  => 0,
            PossibleNone => 1,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ConfigGroups',
            Data => \%Data,
        );

        # check if sysconfig download link should be shown
        if ( $Self->{SysConfigObject}->Download( Type => 'Check' ) ) {
            $Self->{LayoutObject}->Block( Name => 'Download' );
        }

        $Self->{LayoutObject}->Block( Name => 'ActionImport' );
        $Self->{LayoutObject}->Block( Name => 'ContentOverview' );

        $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

        %List = $Self->{SysConfigObject}->ConfigSubGroupList( Name => $Group );

        # if there are any results, they are shown
        if (%List) {
            for ( sort keys %List ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        SubGroup      => $_,
                        SubGroupCount => $List{$_},
                        Group         => $Group,
                    },
                );
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
    }

    # ------------------------------------------------------------ #
    # shows initial screen
    # ------------------------------------------------------------ #
    else {

        # secure mode message (don't allow this action till secure mode is enabled)
        if ( !$Self->{ConfigObject}->Get('SecureMode') ) {
            $Self->{LayoutObject}->SecureMode();
        }

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block(
            Name => 'SearchBox',
            Data => {
                ConfigCounter => $Self->{SysConfigObject}->{ConfigCounter},
            },
        );

        # list Groups
        my %List = $Self->{SysConfigObject}->ConfigGroupList();

        # create select Box
        $Data{List} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%List,
            SelectedID   => $Group,
            Name         => 'SysConfigGroup',
            Translation  => 0,
            PossibleNone => 1,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ConfigGroups',
            Data => \%Data,
        );

        # check if sysconfig download link should be shown
        if ( $Self->{SysConfigObject}->Download( Type => 'Check' ) ) {
            $Self->{LayoutObject}->Block( Name => 'Download' );
        }

        $Self->{LayoutObject}->Block( Name => 'ActionImport' );
        $Self->{LayoutObject}->Block( Name => 'ContentOverview' );

        $Self->{LayoutObject}->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );

    }

    my $Output .= $Self->{LayoutObject}->Header( Value => $Group );
    $Output    .= $Self->{LayoutObject}->NavigationBar();
    $Output    .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSysConfig',
        Data         => {
            %Data,
            ConfigCounter => $Self->{SysConfigObject}->{ConfigCounter},
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub ListConfigItem {
    my ( $Self, %Param ) = @_;

    my %ItemHash = %{ $Param{Hash} };
    my $Default  = '';
    my $Item     = $ItemHash{Setting}->[1];

    # ConfigElement String
    if ( defined $Item->{String} ) {

        # get default
        if ( $Item->{String}->[1]->{Default} ) {
            $Default = $Item->{String}->[1]->{Default};
        }

        my $InputType = 'text';

        if ( $Item->{String}->[1]->{Type} && $Item->{String}->[1]->{Type} eq 'Password' ) {
            $InputType = 'password';
        }

        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementString',
            Data => {
                ElementKey => $ItemHash{Name},
                Content    => $Item->{String}->[1]->{Content},
                Default    => $Default,
                InputType  => $InputType,
            },
        );

        # check
        my $Check = $Item->{String}->[1]->{Check};
        if ($Check) {

            # file
            if ( $Check eq 'File' && !-f $Item->{String}->[1]->{Content} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementStringErrorFileNotFound',
                );
            }

            # directory
            if ( $Check eq 'Directory' && !-d $Item->{String}->[1]->{Content} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementStringErrorDirectoryNotFound',
                );
            }
        }

        # Regex check
        my $RegExp = $Item->{String}->[1]->{Regex};
        if ( $RegExp && $Item->{String}->[1]->{Content} !~ /$Item->{String}->[1]->{Regex}/ ) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementStringErrorRegexMismatch',
            );
        }

        return 1;
    }

    # ConfigElement TextArea
    if ( defined $Item->{TextArea} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTextArea',
            Data => {
                ElementKey => $ItemHash{Name},
                Content    => $Item->{TextArea}->[1]->{Content},
            },
        );
        return 1;
    }

    # ConfigElement PulldownMenu
    if ( defined $Item->{Option} ) {
        my %Hash;
        my $Default = '';

        # build option list
        my $Option = $Item->{Option}->[1];
        for my $Index ( 1 .. $#{ $Option->{Item} } ) {
            $Hash{ $Option->{Item}->[$Index]->{Key} } = $Option->{Item}->[$Index]->{Content};
            if ( $Option->{Item}->[$Index]->{Key} eq $Option->{Default} ) {
                $Default = $Option->{Item}->[$Index]->{Content};
            }
        }
        my $PulldownMenu = $Self->{LayoutObject}->BuildSelection(
            Data       => \%Hash,
            SelectedID => $Option->{SelectedID},
            Name       => $ItemHash{Name},
        );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementSelect',
            Data => {
                Item    => $ItemHash{Name},
                List    => $PulldownMenu,
                Default => $Default,
            },
        );
        return 1;
    }

    # ConfigElement Hash
    if ( defined $Item->{Hash} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementHash',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # Hashelements
        my $Hash          = $Item->{Hash}->[1];
        my %SortContainer = ();
        for my $Index ( 1 .. $#{ $Hash->{Item} } ) {
            $SortContainer{$Index} = $Hash->{Item}->[$Index]->{Key};
        }
        for my $Index ( sort { $SortContainer{$a} cmp $SortContainer{$b} } keys %SortContainer ) {

            # SubHash
            if ( defined $Hash->{Item}->[$Index]->{Hash} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementSubHashStart',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );

                # SubHashElements
                for my $Index2 ( 1 .. $#{ ${Hash}->{Item}->[$Index]->{Hash}->[1]->{Item} } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubHashContent',
                        Data => {
                            ElementKey => $ItemHash{Name}
                                . '##SubHash##'
                                . $Hash->{Item}->[$Index]->{Key},
                            Key =>
                                $Hash->{Item}->[$Index]->{Hash}->[1]->{Item}->[$Index2]->{Key},
                            Content =>
                                $Hash->{Item}->[$Index]->{Hash}->[1]->{Item}->[$Index2]->{Content},
                            Index  => $Index,
                            Index2 => $Index2,
                        },
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementSubHashEnd',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );
            }

            # SubArray
            elsif ( defined $Hash->{Item}->[$Index]->{Array} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubArray##',
                        Index      => $Index,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementSubArrayStart',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubArray##',
                        Index      => $Index,
                    },
                );

                # SubArrayElements
                for my $Index2 ( 1 .. $#{ $Hash->{Item}->[$Index]->{Array}->[1]->{Item} } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubArrayContent',
                        Data => {
                            ElementKey => $ItemHash{Name}
                                . '##SubArray##'
                                . $Hash->{Item}->[$Index]->{Key},
                            Content =>
                                $Hash->{Item}->[$Index]->{Array}->[1]->{Item}->[$Index2]->{Content},
                            Index  => $Index,
                            Index2 => $Index2,
                        },
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementSubArrayEnd',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => '##SubArray##',
                        Index      => $Index,
                    },
                );
            }

            # SubOption
            # REMARK: The SubOptionHandling does not work any more
            elsif ( defined $Hash->{Item}->[$Index]->{Option} ) {

                # PulldownMenu
                my %Hash;
                for my $Index2 ( 1 .. $#{ $Hash->{Item}->[$Index]->{Option}->[1]->{Item} } ) {
                    $Hash{ $Hash->{Item}->[$Index]->{Option}->[1]->{Item}->[$Index2]->{Key} }
                        = $Hash->{Item}->[$Index]->{Option}->[1]->{Item}->[$Index2]->{Content};
                }
                my $PulldownMenu = $Self->{LayoutObject}->BuildSelection(
                    Data       => \%Hash,
                    SelectedID => $Hash->{Item}->[$Index]->{Option}->[1]->{SelectedID},
                    Name       => $ItemHash{Name} . 'Content[]',
                    Class      => 'Content',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent3',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        List       => $PulldownMenu,
                        Index      => $Index,
                    },
                );
            }

            # StandardElement
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $Hash->{Item}->[$Index]->{Key},
                        Content    => $Hash->{Item}->[$Index]->{Content},
                        Index      => $Index,
                    },
                );
            }
        }
        return 1;
    }

    # ConfigElement Array
    if ( defined $Item->{Array} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementArray',
            Data => { ElementKey => $ItemHash{Name}, },
        );

        # ArrayElements
        my $Array = $Item->{Array}->[1];
        for my $Index ( 1 .. $#{ $Array->{Item} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementArrayContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Content    => $Array->{Item}->[$Index]->{Content},
                    Index      => $Index,
                },
            );
        }
        return 1;
    }

    # ConfigElement FrontendModuleReg
    if ( defined $Item->{FrontendModuleReg} ) {
        my $FrontendModuleReg = $Item->{FrontendModuleReg}->[1];
        my %Data              = ();
        for my $Key (qw(Title Description NavBarName)) {
            $Data{ 'Key' . $Key }     = $Key;
            $Data{ 'Content' . $Key } = '';
            if ( defined $FrontendModuleReg->{$Key} ) {
                $Data{ 'Content' . $Key } = $FrontendModuleReg->{$Key}->[1]->{Content};
            }
        }
        $Data{ElementKey} = $ItemHash{Name};

        # Generate an ID that is valid XHTML for use in id attribute
        $Data{ElementKeyID} = $Data{ElementKey};
        $Data{ElementKeyID} =~ s{\#}{_}gsm;

        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementFrontendModuleReg',
            Data => \%Data,
        );

        # Array Element Group
        for my $ArrayElement (qw(Group GroupRo)) {
            for my $Index ( 1 .. $#{ $FrontendModuleReg->{$ArrayElement} } ) {

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementFrontendModuleRegContent' . $ArrayElement,
                    Data => {
                        Index      => $Index,
                        ElementKey => $ItemHash{Name},
                        Content    => $FrontendModuleReg->{$ArrayElement}->[$Index]->{Content},
                    },
                );
            }
        }

        # Define array with keys for the Loader
        my %LoaderTypes = (
            'CSS'        => 1,
            'CSS_IE7'    => 1,
            'CSS_IE8'    => 1,
            'JavaScript' => 1,
        );

        my $Counter = 1;
        for my $Index ( 1 .. $#{ $FrontendModuleReg->{Loader} } ) {

            my $Content = $FrontendModuleReg->{Loader}->[$Index];
            for my $Key ( sort keys %{$Content} ) {

                if ( $LoaderTypes{$Key} ) {
                    for my $Index2 ( 1 .. $#{ $Content->{$Key} } ) {

                        $Self->{LayoutObject}->Block(
                            Name => 'ConfigElementFrontendModuleRegContentLoader',
                            Data => {
                                Index        => $Counter,
                                ElementKey   => $ItemHash{Name},
                                ElementKeyID => $Data{ElementKeyID},
                                Content      => $Content->{$Key}->[$Index2]->{Content},
                                LoaderType   => $Self->{LayoutObject}->BuildSelection(
                                    Data       => [ sort keys %LoaderTypes ],
                                    Name       => $Data{ElementKey} . 'LoaderType' . $Counter,
                                    ID         => $Data{ElementKeyID} . 'LoaderType' . $Counter,
                                    SelectedID => $Key,
                                ),
                            },
                        );
                        $Counter++;
                    }
                }

            }
        }

        # NavBar
        for my $Index ( 1 .. $#{ $FrontendModuleReg->{NavBar} } ) {
            my %Data = ();
            for my $Key (
                qw(Description Name Link LinkOption Type Prio Block NavBar AccessKey)
                )
            {
                $Data{ 'Key' . $Key }     = $Key;
                $Data{ 'Content' . $Key } = '';
                if ( defined $FrontendModuleReg->{NavBar}->[1]->{$Key}->[1]->{Content} ) {
                    $Data{ 'Content' . $Key }
                        = $FrontendModuleReg->{NavBar}->[$Index]->{$Key}->[1]->{Content};
                }
            }
            $Data{ElementKey} = $ItemHash{Name} . '#NavBar';

            # Generate an ID that is valid XHTML for use in id attribute
            $Data{ElementKeyID} = $Data{ElementKey};
            $Data{ElementKeyID} =~ s{\#}{_}gsm;

            $Data{Index} = $Index;
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBar',
                Data => \%Data,
            );

            # Array Element Group
            for my $ArrayElement (qw(Group GroupRo)) {
                for my $Index2 ( 1 .. $#{ $FrontendModuleReg->{NavBar}[$Index]{$ArrayElement} } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementFrontendModuleRegContentNavBar' . $ArrayElement,
                        Data => {
                            Index      => $Index,
                            ArrayIndex => $Index2,
                            ElementKey => $ItemHash{Name},
                            Content =>
                                $FrontendModuleReg->{NavBar}->[$Index]->{$ArrayElement}->[$Index2]
                                ->{Content},
                        },
                    );
                }
            }
        }

        # NavBarModule
        if ( ref $FrontendModuleReg->{NavBarModule} eq 'ARRAY' ) {
            for my $Index ( 1 .. $#{ $FrontendModuleReg->{NavBarModule} } ) {
                my %Data;
                for my $Key (qw(Module Name Block Pri)) {
                    $Data{ 'Key' . $Key }     = $Key;
                    $Data{ 'Content' . $Key } = '';
                    if ( defined $FrontendModuleReg->{NavBarModule}->[1]->{$Key}->[1]->{Content} ) {
                        $Data{ 'Content' . $Key }
                            = $FrontendModuleReg->{NavBarModule}->[1]->{$Key}->[1]->{Content};
                    }
                }
                $Data{ElementKey} = $ItemHash{Name} . '#NavBarModule';

                # Generate an ID that is valid XHTML for use in id attribute
                $Data{ElementKeyID} = $Data{ElementKey};
                $Data{ElementKeyID} =~ s{\#}{_}gsm;

                $Data{Index} = $Index;

                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementFrontendModuleRegContentNavBarModule',
                    Data => \%Data,
                );
            }
        }
        elsif ( defined $FrontendModuleReg->{NavBarModule} ) {
            my %Data;
            for my $Key (qw(Module Name Description Block Prio)) {
                $Data{ 'Key' . $Key }     = $Key;
                $Data{ 'Content' . $Key } = '';
                if ( defined $FrontendModuleReg->{NavBarModule}->{$Key}->[1]->{Content} ) {
                    $Data{ 'Content' . $Key }
                        = $FrontendModuleReg->{NavBarModule}->{$Key}->[1]->{Content};
                }
            }
            $Data{ElementKey} = $ItemHash{Name} . '#NavBarModule';

            # Generate an ID that is valid XHTML for use in id attribute
            $Data{ElementKeyID} = $Data{ElementKey};
            $Data{ElementKeyID} =~ s{\#}{_}gsm;

            $Data{Index} = 0;

            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBarModule',
                Data => \%Data,
            );
        }
        return 1;
    }

    # ConfigElement TimeVacationDaysOneTime
    if ( defined $Item->{TimeVacationDaysOneTime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDaysOneTime',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );

        # New TimeVacationDaysOneTimeElement
        my $New = $Self->{ParamObject}->GetParam(
            Param => $ItemHash{Name} . '#NewTimeVacationDaysOneTimeElement',
        );
        if ($New) {
            push( @{ $Item->{TimeVacationDaysOneTime}[1]{Item} }, { Key => '', Content => '' } );
        }

        # TimeVacationDaysOneTimeElements
        for my $Index ( 1 .. $#{ $Item->{TimeVacationDaysOneTime}->[1]->{Item} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysOneTimeContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Year       => $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year},
                    Month      => $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month},
                    Day        => $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day},
                    Content =>
                        $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Content},
                    Index => $Index,
                },
            );
            if (
                $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year}
                && $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year}
                !~ /^\d\d\d\d$/
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeVacationDaysOneTimeContentInvalidYear'
                );
            }
            if (
                $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month}
                && $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month}
                !~ /^(1[0-2]|[1-9])$/
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeVacationDaysOneTimeContentInvalidMonth'
                );
            }
            if (
                $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day}
                && $Item->{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day}
                !~ /^([1-3][0-9]|[1-9])$/
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeVacationDaysOneTimeContentInvalidDay'
                );
            }
        }
        return 1;
    }

    # ConfigElement TimeVacationDays
    if ( defined $Item->{TimeVacationDays} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDays',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );

        # New TimeVacationDaysElement
        my $New = $Self->{ParamObject}->GetParam(
            Param => $ItemHash{Name} . '#NewTimeVacationDaysElement',
        );
        if ($New) {
            push( @{ $Item->{TimeVacationDays}[1]{Item} }, { Key => '', Content => '' } );
        }

        # TimeVacationDaysElements
        for my $Index ( 1 .. $#{ $Item->{TimeVacationDays}->[1]->{Item} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Month      => $Item->{TimeVacationDays}[1]{Item}[$Index]{Month},
                    Day        => $Item->{TimeVacationDays}[1]{Item}[$Index]{Day},
                    Content    => $Item->{TimeVacationDays}[1]{Item}[$Index]{Content},
                    Index      => $Index,
                },
            );
            if (
                $Item->{TimeVacationDays}[1]{Item}[$Index]{Month}
                && $Item->{TimeVacationDays}[1]{Item}[$Index]{Month}
                !~ /^(1[0-2]|[1-9])$/
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeVacationDaysContentInvalidMonth'
                );
            }

            if (
                $Item->{TimeVacationDays}[1]{Item}[$Index]{Day}
                && $Item->{TimeVacationDays}[1]{Item}[$Index]{Day}
                !~ /^([1-3][0-9]|[1-9])$/
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeVacationDaysContentInvalidDay'
                );
            }
        }
        return 1;
    }

    # ConfigElement TimeWorkingHours
    if ( defined $Item->{TimeWorkingHours} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeWorkingHours',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );

        # TimeWorkingHoursElements

        # create lookup day -> day id
        my %WeekdayLookup = (
            Mon => 1,
            Tue => 2,
            Wed => 3,
            Thu => 4,
            Fri => 5,
            Sat => 6,
            Sun => 7,
        );
        my %SortWeekdays;
        for my $Index ( 1 .. $#{ $Item->{TimeWorkingHours}->[1]->{Day} } ) {

            # assign index id to day id for sorting
            $SortWeekdays{ $WeekdayLookup{ $Item->{TimeWorkingHours}[1]{Day}[$Index]{Name} } }
                = $Index;
        }

        # get output sorted by day id
        for my $DayIndex ( 1 .. 7 ) {
            my $Index = $SortWeekdays{$DayIndex};
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeWorkingHoursContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Weekday    => $Item->{TimeWorkingHours}[1]{Day}[$Index]{Name},
                    Index      => $Index,
                },
            );

            # Hours
            my @ArrayHours = ('') x 25;

            # Active Hours
            if ( defined $Item->{TimeWorkingHours}[1]{Day}[$Index]{Hour} ) {
                for my $Index2 ( 1 .. $#{ $Item->{TimeWorkingHours}[1]{Day}[$Index]{Hour} } ) {
                    $ArrayHours[ $Item->{TimeWorkingHours}[1]{Day}[$Index]{Hour}[$Index2]{Content} ]
                        = 'checked="checked"';
                }
            }
            for my $Z ( 0 .. 23 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeWorkingHoursHours',
                    Data => {
                        ElementKey => $ItemHash{Name}
                            . $Item->{TimeWorkingHours}[1]{Day}[$Index]{Name},
                        Hour   => $Z,
                        Active => $ArrayHours[$Z],
                    },
                );
            }
        }
        return 1;
    }

    # ConfigElement DateTime
    if ( defined $Item->{DateTime} ) {

        # set a safe prefix, substitue the '::' for a '_'
        my $Prefix = $ItemHash{Name};
        $Prefix =~ s{::}{_}g;

        # set format: Long = DateTime, otherwise just Date
        # <DateTime Type="Long"> ... </DateTime>
        my $Format = 'DateInputFormat';
        if ( defined $Item->{DateTime}->[1]->{Type} && $Item->{DateTime}->[1]->{Type} eq 'Long' ) {
            $Format = 'DateInputFormatLong';
        }

        my %DateHash = (
            $Prefix . Year   => $ItemHash{Setting}[1]{DateTime}->[1]->{Year}->[1]->{Content},
            $Prefix . Month  => $ItemHash{Setting}[1]{DateTime}->[1]->{Month}->[1]->{Content},
            $Prefix . Day    => $ItemHash{Setting}[1]{DateTime}->[1]->{Day}->[1]->{Content},
            $Prefix . Hour   => $ItemHash{Setting}[1]{DateTime}->[1]->{Hour}->[1]->{Content},
            $Prefix . Minute => $ItemHash{Setting}[1]{DateTime}->[1]->{Minute}->[1]->{Content},
        );

        # transform time stamp based on user time zone
        %DateHash = $Self->{LayoutObject}->TransfromDateSelection(
            %DateHash,
            Prefix => $Prefix,
        );

        # create DateTime content
        my $Content = $Self->{LayoutObject}->BuildDateSelection(
            %DateHash,
            Prefix           => $Prefix,
            Format           => $Format,
            Validate         => 1,
            YearPeriodPast   => 10,
            YearPeriodFuture => 5,
        );

        # output DateTime config element
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementDateTime',
            Data => {
                Content => $Content,
            },
        );
        return 1;
    }

    return;
}

1;
