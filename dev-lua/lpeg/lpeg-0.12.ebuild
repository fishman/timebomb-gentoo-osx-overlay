# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lpeg/lpeg-0.12.ebuild,v 1.5 2014/03/04 20:34:04 vincent Exp $

EAPI=5

inherit flag-o-matic toolchain-funcs eutils multilib

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips x86"
IUSE="debug doc"

RDEPEND=">=dev-lang/lua-5.1"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	use debug && append-cflags -DLPEG_DEBUG
}

src_compile() {
    local mytarget=""
	if [[ $CHOST == *-darwin* ]]; then
		mytarget="macosx"
	fi
    emake CC="$(tc-getCC)" ${mytarget}
}

src_test() {
	lua test.lua || die
}

src_install() {
	exeinto "$(pkg-config --variable INSTALL_CMOD lua)"
	doexe lpeg.so

	dodoc HISTORY

	use doc && dohtml *
}
