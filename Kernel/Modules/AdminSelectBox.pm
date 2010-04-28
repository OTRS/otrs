# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminSelectBox.pm,v 1.34 2010-04-28 16:28:28 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;
use warnings;

use Kernel::System::CSV;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.34 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if !$Self->{$_};
    }

    $Self->{CSVObject} = Kernel::System::CSV->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{ResultFormatStrg} = $Self->{LayoutObject}->BuildSelection(
        Name => 'ResultFormat',
        Data => [ 'HTML', 'CSV' ],
    );

    # ------------------------------------------------------------ #
    # do select
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Select' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        for (qw(SQL Max ResultFormat)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # add result block
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => \%Param,
        );

        # fetch database and add row blocks
        if ( $Self->{DBObject}->Prepare( SQL => $Param{SQL}, Limit => $Param{Max} ) ) {

            my $Count = 0;
            my @Head;
            my @Data;
            my $TableOpened;

            # if there are any matching rows, they are shown
            if ( my @Row = $Self->{DBObject}->FetchrowArray( RowNames => 1 ) ) {
                do {
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
                } while ( @Row = $Self->{DBObject}->FetchrowArray( RowNames => 1 ) );
            }

            # otherwise a no matches found msg is displayed
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'NoMatches',
                );
            }

            # generate csv output
            if ( $Param{ResultFormat} eq 'CSV' ) {
                my $CSV = $Self->{CSVObject}->Array2CSV(
                    Head => \@Head,
                    Data => \@Data,
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
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSelectBox',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # print form
    # ------------------------------------------------------------ #
    else {

        # get params
        for (qw(SQL Max)) {
            $Param{SQL} = $Self->{ParamObject}->GetParam( Param => 'SQL' ) || 'SELECT * FROM ';
            $Param{Max} = $Self->{ParamObject}->GetParam( Param => 'Max' ) || 40;
        }
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
