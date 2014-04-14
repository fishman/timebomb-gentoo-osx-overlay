# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
ETYPE="headers"
DESCRIPTION="XNU headers from Applce Inc."
HOMEPAGE="http://opensource.apple.com/"

SRC_URI="http://opensource.apple.com/tarballs/xnu/xnu-${PV}.tar.gz"

LICENSE="APPLE_LICENSE"
SLOT="0"
KEYWORDS="~x64-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/xnu-${PV}

src_unpack() {
	unpack ${A}
}

src_compile() {
	echo "Compiled"
}

src_install() {
	dodir /usr/include/
	cp -r ${S}/bsd ${ED}/usr/include/
	find ${ED}/usr/include -type f -not -name "*.h" -exec rm -fr {} \;
	echo installed!
}
