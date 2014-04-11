# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luafilesystem/luafilesystem-1.5.0.ebuild,v 1.10 2014/03/04 20:35:11 vincent Exp $

EAPI="5"
inherit multilib toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="http://keplerproject.github.com/luafilesystem/"

if [[ ${PV} == "9999" ]]; then
    EGIT_REPO_URI="git://github.com/keplerproject/luafilesystem.git"
    SRC_URI=""
    KEYWORDS=""
    inherit git-r3
else
    SRC_URI="mirror://github/keplerproject/luafilesystem/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/lua-5.1"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|-O2|${CFLAGS}|" \
		-e "/^LIB_OPTION/s|= |= ${LDFLAGS} |" \
		-e "s|gcc|$(tc-getCC)|" \
		config || die

	local lua_ver="$(pkg-config --variable V lua)"
	if [[ $CHOST == *-darwin* ]]; then
		sed -i "/^LIB_OPTION/s/^.*$/LIB_OPTION= -bundle -undefined dynamic_lookup/" \
			config || die
	fi
	sed -i -e "s/5.1/${lua_ver}/" config || die
}

src_install() {
	emake PREFIX="${ED}usr" install || die
	dodoc README || die
	dohtml doc/us/* || die
}
