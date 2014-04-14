# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit flag-o-matic

DESCRIPTION="Data serialization and communication toolwork"
HOMEPAGE="http://thrift.apache.org/about/"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pic +cpp +c_glib csharp java erlang python perl php php_extension ruby haskell go"

#FIXME: java.eclassesnotused          1
RDEPEND=">=dev-libs/boost-1.40.0
	virtual/yacc
	dev-libs/openssl
	cpp? (
		>=sys-libs/zlib-1.2.3
		dev-libs/libevent
	)
	csharp? ( >=dev-lang/mono-1.2.4 )
	java? (
		>=virtual/jdk-1.5
		dev-java/ant
		dev-java/ant-ivy
		dev-java/commons-lang
		dev-java/slf4j-api
	)
	erlang? ( >=dev-lang/erlang-12.0.0 )
	python? (
		>=dev-lang/python-2.4.0
		!dev-python/thrift
	)
	perl? (
		dev-lang/perl
		dev-perl/Bit-Vector
		dev-perl/Class-Accessor
	)
	php? ( >=dev-lang/php-5.0.0 )
	php_extension? ( >=dev-lang/php-5.0.0 )
	ruby? ( virtual/rubygems )
	haskell? ( dev-haskell/haskell-platform )
	go? ( sys-devel/gcc[go] )
	"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2[cxx]
	c_glib? ( dev-libs/glib )
	sys-devel/flex
	"

src_unpack(){
	unpack ${A}
	#hack for version 0.9.1
	cd "${S}/test/cpp/"
	ln -s . .libs
}

src_configure() {
	local myconf
	for USEFLAG in ${IUSE}; do
		myconf+=" $(use_with ${USEFLAG/+/})"
	done
	# This flags either result in compilation errors
	# or byzantine runtime behaviour.
	filter-flags -fwhole-program -fwhopr

	econf \
		--prefix=${EPREFIX}/usr \
		--exec-prefix=${EPREFIX}/usr \
		PY_PREFIX=${EPREFIX}/usr \
		JAVA_PREFIX=${EPREFIX}/usr/local/lib \
		PHP_PREFIX=${EPREFIX}/usr/local/lib \
		PHP_CONFIG_PREFIX=${EPREFIX}/etc/php.d \
		PERL_PREFIX=${EPREFIX}/usr/local/lib \
		${myconf}
}

src_compile() {
	emake || die "emake install failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
