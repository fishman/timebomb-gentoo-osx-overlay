# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-9999.ebuild,v 1.25 2013/10/14 18:21:00 mgorny Exp $

EAPI=5

ESVN_REPO_URI="http://llvm.org/svn/llvm-project/libcxx/trunk"

[ "${PV%9999}" != "${PV}" ] && SCM="subversion" || SCM=""

inherit ${SCM} flag-o-matic toolchain-funcs multilib multilib-minimal

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~x64-macos ~x86-macos"
IUSE="elibc_glibc +mac static-libs test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( sys-devel/clang )
	app-arch/xz-utils"

DOCS=( CREDITS.TXT )

src_prepare() {
	# cp -f "${FILESDIR}/Makefile" lib/ || die
	multilib_copy_sources
}

multilib_src_compile() {
	cd "${BUILD_DIR}/lib" || die
    export TRIPLE=-apple-
    ./buildit
    install_name_tool -id "${EPREFIX}"/usr/lib/libc++.1.dylib libc++.1.dylib
	# emake shared
	# use static-libs && emake static
}

multilib_src_install() {
	cd "${BUILD_DIR}/lib"
	# if use static-libs ; then
	#     dolib.a libc++.a
	#     gen_static_ldscript
	# fi
	insinto /usr/lib
    doins libc++*dylib
}

multilib_src_install_all() {
	einstalldocs
	insinto /usr/include/c++/v1
	doins -r include/*
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
