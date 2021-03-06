# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dmenu/dmenu-4.5-r4.ebuild,v 1.1 2014/01/22 14:46:23 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="http://tools.suckless.org/dmenu/"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-macos"
IUSE="xft xinerama"

RDEPEND="
	x11-libs/libX11
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
	xft? ( virtual/pkgconfig )
	xinerama? ( virtual/pkgconfig )
"

src_prepare() {
	# Respect our flags
	sed -i \
		-e '/^CFLAGS/{s|=.*|+= -ansi -pedantic -Wall $(INCS) $(CPPFLAGS)|}' \
		-e '/^LDFLAGS/s|= -s|+=|' \
		config.mk || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i \
			-e 's/ansi/D_DARWIN_C_SOURCE -ansi/' \
			config.mk || die
	fi
	# Make make verbose
	sed -i \
		-e 's|^	@|	|g' \
		-e '/^	echo/d' \
		Makefile || die
	use xft && epatch "${FILESDIR}"/${PN}-4.5-xft-3.patch

	epatch_user
}

src_compile() {
	emake CC=$(tc-getCC) \
		"XFTINC=$( $(tc-getPKG_CONFIG) --cflags xft 2>/dev/null )" \
		"XFTLIBS=$( $(tc-getPKG_CONFIG) --libs xft 2>/dev/null )" \
		"XINERAMAFLAGS=$(
			usex xinerama "-DXINERAMA $(
				$(tc-getPKG_CONFIG) --cflags xinerama 2>/dev/null
			)" ''
		)" \
		"XINERAMALIBS=$(
			usex xinerama "$( $(tc-getPKG_CONFIG) --libs xinerama 2>/dev/null)" ''
		)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
}
