# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/liblangtag/liblangtag-0.4.0-r1.ebuild,v 1.7 2013/04/26 19:13:02 scarabeus Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="libcouchbase"
HOMEPAGE="http://www.couchbase.com/communities/c/getting-started"
SRC_URI="http://packages.couchbase.com/clients/c/${P}.tar.gz"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

RDEPEND=""
DEPEND="${RDEPEND}"
