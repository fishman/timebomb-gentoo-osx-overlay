# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR="RHANDOM"
MODULE_VERSION="2.03"
inherit perl-module

DESCRIPTION=""

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

RDEPEND="dev-perl/Crypt-Rijndael"
DEPEND="${RDEPEND}"

SRC_TEST="do"
