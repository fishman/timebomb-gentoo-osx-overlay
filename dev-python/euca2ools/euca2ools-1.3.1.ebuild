# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

# We use the following for python packages that use the python distutils
# mechanism
inherit distutils eutils

DESCRIPTION="Command-line tools for interacting with Amazon EC2 and S3 API-compatible Web services using the REST/Query API"

HOMEPAGE="http://open.eucalyptus.com"

#SRC_URI="http://open.eucalyptus.com/downloads/135"
# TODO: How do I change the file name (135) to reflect the actual package name
# and version? In the meantime ...
# ... A mirror with the file that reflects the package name and version
SRC_URI="http://eucalyptussoftware.com/downloads/releases/${P}.tar.gz"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~x86 ~ppc64 ~x86-macos"

IUSE=""

DEPEND=">=dev-python/boto-1.8d 
 >=dev-lang/python-2.5
 >=dev-python/m2crypto-0.19.1"

RDEPEND="${DEPEND}"

DOCS="${S}/COPYING 
  ${S}/CHANGELOG
  ${S}/README
  ${S}/INSTALL"

src_compile() {
	epatch ${FILESDIR}/fix_python_env.patch
	emake build || die "emake failed"
}


src_install() {

	cd "${S}/euca2ools"
	distutils_src_install
	cd "${S}/bin"
	for tool in *; do
		newbin ${tool} ${tool}
	done


	# Install the manpages 
	if [[ -d ${S}/man ]]; then
		doman ${S}/man/* || die "doman"
	fi

}


pkg_postinst(){
	einfo ""
	einfo " Euca2ools use cryptographic credentials for authentication.  Two
	types of credentials are issued by EC2- and S3-compatible services: x509
	certificates and keys.  While some commands only require the latter, it is
	best to always specify both types of credentials."

	einfo ""
	einfo " Furthermore, unless the front end Web services reside on
	'localhost', the URLs of the EC2- and S3-compatible service endpoints must
	also be specified."
	einfo ""
	einfo "If you are running Euca2ools against Eucalyptus, sourcing the
	\"eucarc\" file that is included as part of the credentials zip-file that
	you downloaded from the Eucalyptus Web interface should be enough to set up
	all of the above variables correctly."
	einfo ""	
	einfo "For more information please refer to the:"
	einfo "   * --help option of the individual commands,"
	einfo "   * check the man pages for each command,"
	einfo "   * consult the local documentation at /usr/share/doc/$P,"
	einfo "   *consult http://open.eucalyptus.com/wiki/Documentation."
	einfo ""
}
