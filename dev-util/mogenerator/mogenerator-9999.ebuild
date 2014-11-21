# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/surf/surf-9999.ebuild,v 1.2 2013/10/04 14:52:10 jer Exp $

EAPI=5
inherit eutils git-2

DESCRIPTION=""
HOMEPAGE="http://rentzsch.github.io/mogenerator"
EGIT_REPO_URI="git://github.com/rentzsch/mogenerator"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND=""

src_compile() {
	xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot
}

src_install() {
	install -d "${ED}"usr/bin
	install -m 755 symroot/Release/mogenerator "${ED}"usr/bin
}
