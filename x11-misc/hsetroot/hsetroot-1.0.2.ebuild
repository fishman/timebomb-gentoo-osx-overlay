# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/hsetroot/hsetroot-1.0.2.ebuild,v 1.11 2009/05/17 17:50:54 nixnut Exp $

DESCRIPTION="Tool which allows you to compose wallpapers ('root pixmaps') for X"
HOMEPAGE="http://thegraveyard.org/hsetroot.php"
SRC_URI="http://thegraveyard.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	>=media-libs/imlib2-1.0.6.2003"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-libs/libX11
	x11-libs/libXt"

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
