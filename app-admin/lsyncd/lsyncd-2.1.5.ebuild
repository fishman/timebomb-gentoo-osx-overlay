# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lsyncd/lsyncd-2.1.5.ebuild,v 1.3 2013/12/24 12:42:40 ago Exp $

EAPI=5

DESCRIPTION="Live Syncing (Mirror) Daemon"
HOMEPAGE="http://code.google.com/p/lsyncd/"
SRC_URI="http://lsyncd.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x64-macos amd64 x86 ~amd64-linux ~arm-linux ~x86-linux"

CDEPEND=">=dev-lang/lua-5.1[deprecated]"
DEPEND="${CDEPEND}
	virtual/pkgconfig
       " 
if [[ ${CHOST} == *-darwin* ]] ; then
   DEPEND="${DEPEND} >=sys-kernel/xnu-2422.1.72"
fi
RDEPEND="${CDEPEND}
	net-misc/rsync"

src_configure() {
	if [[ ${CHOST} == *-darwin* ]] ; then
            myconf="--without-inotify --with-fsevents"
        fi	
	econf \
	      ${myconf} \
	      --docdir="${EPREFIX}"/usr/share/doc/${P}
}
