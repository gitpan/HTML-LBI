package HTML::LBI;
#############################################################
#  HTML::LBI
#  Whyte.Wolf DreamWeaver HTML Library Module
#  Version 1.01
#
#  Copyright (c) 2002 by S.D. Campbell <whytwolf@spots.ab.ca>
#
#  Created 03 February 2002; Revised 12 February 2002 by SDC
#
#  Description:
#	A perl module for use with CGI scripts that opens a 
#	Macromedia Dreamweaver library file (.lbi) and returns
#	the resulting HTML code snippet.
#
#############################################################
#
#  Construction:
#	  use HTML::LBI;
#
#	  $html = new HTML::LBI("file.lbi");
#
#  Use:
#	Create a new instance of HTML::LBI as above by passing
#	a pathname to the library file (absolute or relative)
#	to the constructor.  The constructor will return
#	the HTML from the .lbi file, which can then be printed out.
#
#  Errors:
#	Should the library file fail to open an error will be set
#	in $HTML::LBI::errmsg
#
#############################################################
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#############################################################

use Exporter;

@ISA = qw(Exporter);
@EXPORT = qw($VERSION);
@EXPORT_OK = qw($errmsg);

use strict;
use vars qw($errmsg $VERSION @ISA @EXPORT);

$VERSION = '1.01';

$errmsg = "";

#############################################################
# new
#
#  The constructor for the class.  Requires a HTML Library
#  filename.  Returns a reference to the new object or undef
#  on error.

sub new {
    my $class = shift;
    my $file = shift;

    my $self = {
				file => $file,
				lbi => beginLbi($file),
		};

    unless(open(LBI_FILE, $file)){
		$errmsg = "Library File $file not opened: $!\n";
		return undef;
    }

    while(<LBI_FILE>){
		$$self{lbi} .= $_;
    }

    $$self{lbi} .= &endLbi;

    bless $self, $class;
    return $$self{lbi};
}

#############################################################
# beginLbi
#
#  Returns the begin library string and file name back into
#  the parsed HTML.

sub beginLbi {
    my $filename = shift;
    return "\n<!-- \#BeginLibraryItem \"$filename\" -->\n";
}


#############################################################
# endLbi
#
#  Returns the end library string back into the parsed HTML.

sub endLbi {
    return "\n<!-- \#EndLibraryItem -->\n";
}


1;
__END__

=head1 NAME

HTML::LBI - DreamWeaver HTML Library Module

=head1 SYNOPSIS

  use HTML::LBI;

  $html = new HTML::LBI("file.lbi");


=head1 DESCRIPTION

A perl module for use with CGI scripts that opens a 
Macromedia Dreamweaver library file (.lbi) and returns
the resulting HTML code snippet.

=head2 EXPORT

None.

=head1 METHODS

=head2 Creation

=over 4

=item new HTML::LBI("file.lbi")

Creates a new HTML::LBI object and loads HTML from the Dreamweaver
library 'file.lbi' (can specify a relative or absolute path).  Returns
the HTML from the library, which could then be printed to STDOUT.

=back

=head1 DIAGNOSTICS

=over 4

=item Library File $file not opened:

(F) The library file was not opened properly.  
This message is stored in $HTML::LBI::errmsg

=back

=head1 AUTHOR

S.D. Campbell, whytwolf@spots.ab.ca

=head1 SEE ALSO

perl(1), HTML::Template, HTML::DWT.

=cut
