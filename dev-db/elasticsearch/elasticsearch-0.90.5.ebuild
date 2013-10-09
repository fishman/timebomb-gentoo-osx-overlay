# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit user

DESCRIPTION="A Distributed RESTful Search Engine"
HOMEPAGE="http://www.elasticsearch.org/"
SRC_URI="https://download.elasticsearch.org/elasticsearch/elasticsearch/${PN}-${PV}.tar.gz"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
# RDEPEND=">=virtual/jre-1.6.0"

ES_HOME="/opt/elasticsearch"

pkg_setup() {
	enewgroup elasticsearch
	enewuser elasticsearch -1 -1 /var/lib/elasticsearch elasticsearch
}

src_install() {
	dodir "${ES_HOME}"
	dodir /etc/elasticsearch
	dodir /var/log/elasticsearch

	insinto /etc/elasticsearch
	doins "${FILESDIR}"/elasticsearch.yml
	doins "${FILESDIR}"/logging.yml

	# fowners elasticsearch:elasticsearch /etc/elasticsearch/{elasticsearch,logging}.yml
	# fowners elasticsearch:elasticsearch /var/log/elasticsearch

	newinitd "${FILESDIR}/elasticsearch.initd" elasticsearch

	insinto "${ES_HOME}"
	doins -r bin
	doins -r config
	doins -r README.textile
	doins -r LICENSE.txt
	doins -r NOTICE.txt

	insinto "${ES_HOME}/lib"
    echo "lib"
	doins lib/*

    if use x86; then
        sigar_lib="libsigar-x86-linux.so"
    elif use amd64; then
        sigar_lib="libsigar-amd64-linux.so"
    fi
    if [[ ${CHOST} == *-darwin* ]]; then
        sigar_lib="libsigar-universal64-macosx.dylib"
        install_name_tool -id "${EPREFIX}${ES_HOME}/lib/sigar/${sigar_lib}" "lib/sigar/${sigar_lib}" || die
    fi


	insinto "${ES_HOME}/lib/sigar"
	doins lib/sigar/*.jar
	doins lib/sigar/${sigar_lib}
    fperms 0755 ${ES_HOME}/bin/elasticsearch

    insinto /usr/bin
    insopts -m0755
	doins "${FILESDIR}"/elasticsearch
}
