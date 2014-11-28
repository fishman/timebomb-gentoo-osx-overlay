# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/tig/tig-1.2.1.ebuild,v 1.4 2013/09/30 17:17:49 ago Exp $

EAPI=5

inherit bash-completion-r1 toolchain-funcs git-r3 autotools

DESCRIPTION="Tig: text mode interface for git"
HOMEPAGE="http://jonas.nitro.dk/tig/"

if [[ ${PV} == "9999" ]] ; then
    EGIT_BRANCH="master"
    EGIT_REPO_URI="git://github.com/jonas/tig.git"
else
    SRC_URI="http://jonas.nitro.dk/tig/releases/${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

CDEPEND="sys-libs/ncurses"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-vcs/git"

src_unpack() {
    if [[ ${PV} == "9999" ]] ; then
        git-r3_src_unpack
        cd "${S}"
        eautoreconf
    else
        unpack ${A}
    fi
}

src_prepare() {
	# pre-generated manpages are in the root directory
    if [[ ${PV} != "9999" ]] ; then
        sed -i '/^MANDOC/s#doc/##g' Makefile || die
    fi
}

src_configure() {
	econf CURSES_LIB="$($(tc-getPKG_CONFIG) --libs ncursesw)"
}

src_compile() {
	# fix version set wrong in tarball
	emake VERSION=${PV}
}

src_install() {
    if [[ ${PV} == "9999" ]] ; then
        emake DESTDIR="${D}" install
    else
        emake DESTDIR="${D}" install install-doc-man
        dodoc BUGS NEWS
        dohtml manual.html README.html
    fi
	newbashcomp contrib/tig-completion.bash ${PN}
}
