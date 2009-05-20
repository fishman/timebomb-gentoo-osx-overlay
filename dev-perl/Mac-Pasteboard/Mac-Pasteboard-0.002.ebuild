# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Manipulate Mac OS X clipboards/pasteboards."
SRC_URI="mirror://cpan/authors/id/W/WY/WYANT/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~wyant/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND="dev-lang/perl"
