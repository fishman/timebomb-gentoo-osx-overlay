# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs multilib git-2

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"
EGIT_REPO_URI="git://github.com/antirez/lua-cmsgpack.git"
MY_PN="${PN/-/_}"
MY_MODULE="${MY_PN#*_}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
dev-libs/msgpack
>=dev-lang/lua-5.1"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_compile() {
	$(tc-getCC) -fPIC -I${EPREFIX}/usr/include ${CFLAGS} -c -o ${MY_PN}.o lua_${MY_PN}.c || die
	if [[ ${CHOST} == *-apple-darwin* ]]; then
		$(tc-getCC) ${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir) -bundle -undefined dynamic_lookup -o ${MY_MODULE}.so ${MY_PN}.o || die
	else
		$(tc-getCC) ${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir) -shared -o ${MY_MODULE}.so ${MY_PN}.o || die
	fi
}

src_test() {
	lua test.lua
}

src_install() {
	local modpath=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)
	insinto ${modpath#${EPREFIX}}
	doins ${MY_MODULE}.so
}
