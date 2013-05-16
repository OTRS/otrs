# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;
use warnings;

use Kernel::System::CSV;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" ) if !$Self->{$Needed};
    }

    $Self->{CSVObject} = Kernel::System::CSV->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # secure mode message (don't allow this action until secure mode is enabled)
    if ( !$Self->{ConfigObject}->Get('SecureMode') ) {
        $Self->{LayoutObject}->SecureMode();
    }

    $Param{ResultFormatStrg} = $Self->{LayoutObject}->BuildSelection(
        Name => 'ResultFormat',
        Data => [ 'HTML', 'CSV' ],
    );

    # ------------------------------------------------------------ #
    # do select
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Select' ) {
        my %Errors;

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        for my $Parameter (qw(SQL Max ResultFormat)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        if ( !$Param{SQL} ) {
            $Errors{SQLInvalid} = 'ServerError';
            $Errors{ErrorType}  = 'FieldRequired';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # fetch database and add row blocks
            if ( $Self->{DBObject}->Prepare( SQL => $Param{SQL}, Limit => $Param{Max} ) ) {
                my $Count = 0;
                my @Head;
                my @Data;
                my $TableOpened;

                # add result block
                $Self->{LayoutObject}->Block(
                    Name => 'Result',
                    Data => \%Param,
                );

                my $MatchesFound;

                # if there are any matching rows, they are shown
                while ( my @Row = $Self->{DBObject}->FetchrowArray( RowNames => 1 ) ) {

                    $MatchesFound = 1;

                    if ( !$TableOpened ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ResultTableStart',
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'ResultTableEnd',
                        );
                        $TableOpened++;
                    }

                    # get csv data
                    if ( $Param{ResultFormat} eq 'CSV' ) {
                        $Count++;
                        if ( $Count == 1 ) {
                            @Head = @Row;
                            next;
                        }
                        push @Data, \@Row;
                        next;
                        last if $Count > 2000;
                    }

                    $Self->{LayoutObject}->Block(
                        Name => 'Row',
                    );

                    # get html data
                    my $Row = '';
                    for my $Item (@Row) {
                        if ( !defined $Item ) {
                            $Item = 'NULL';
                        }

                        $Self->{LayoutObject}->Block(
                            Name => 'Cell',
                            Data => {
                                Content => $Item,
                            },
                        );
                    }
                }

                # otherwise a no matches found msg is displayed
                if ( !$MatchesFound ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoMatches',
                    );
                }

                # get Separator from language file
                my $UserCSVSeparator = $Self->{LayoutObject}->{LanguageObject}->{Separator};

                if ( $Self->{ConfigObject}->Get('PreferencesGroups')->{CSVSeparator}->{Active} ) {
                    my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
                    $UserCSVSeparator = $UserData{UserCSVSeparator};
                }

                # generate csv output
                if ( $Param{ResultFormat} eq 'CSV' ) {
                    my $CSV = $Self->{CSVObject}->Array2CSV(
                        Head      => \@Head,
                        Data      => \@Data,
                        Separator => $UserCSVSeparator,
                    );
                    return $Self->{LayoutObject}->Attachment(
                        Filename    => 'admin-select.csv',
                        ContentType => 'text/csv',
                        Content     => $CSV,
                        Type        => 'attachment'
                    );
                }

                # generate html output
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminSelectBox',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Errors{ErrorMessage} = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
                $Errors{ErrorType}
                    = ( $Errors{ErrorMessage} =~ /bind/i ) ? 'BindParam' : 'SQLSyntax';
                $Errors{SQLInvalid} = 'ServerError';
            }
        }

        # add server error message block
        $Self->{LayoutObject}->Block( Name => $Errors{ErrorType} . 'ServerError' );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify(
            Info     => $Errors{ErrorMessage},
            Priority => 'Error'
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSelectBox',
            Data         => {
                %Param,
                %Errors,
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # print form
    # ------------------------------------------------------------ #
    else {

        # get params
        $Param{SQL} = $Self->{ParamObject}->GetParam( Param => 'SQL' ) || 'SELECT * FROM ';
        $Param{Max} = $Self->{ParamObject}->GetParam( Param => 'Max' ) || 40;

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSelectBox',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
