# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/asciidoc/asciidoc-8.2.7.ebuild,v 1.1 2008/10/18 14:11:49 pva Exp $

DESCRIPTION="A text document format for writing short documents, articles, books and UNIX man pages"
HOMEPAGE="http://www.methods.co.nz/asciidoc/"
SRC_URI="http://www.methods.co.nz/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="examples vim-syntax"

DEPEND=">=virtual/python-2.4
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"

src_unpack() {
	unpack ${A}

	sed -i -e "s:^BINDIR=.*:BINDIR=${EPREFIX}/usr/bin:" \
		-e "s:^MANDIR=.*:MANDIR=${EPREFIX}/usr/share/man:" \
		-e "s:^CONFDIR=.*:CONFDIR=${EPREFIX}/etc/asciidoc:" \
		-e "s:^VIM_CONFDIR=.*:VIM_CONFDIR=${EPREFIX}/usr/share/vim/vimfiles:" \
		"${S}/install.sh"

	sed -i -e "s:^CONF_DIR =.*:CONF_DIR='${EPREFIX}/etc/asciidoc':" \
		"${S}/asciidoc.py"
}

src_install() {
	dodir /usr/bin

	use vim-syntax && dodir /usr/share/vim/vimfiles

	"${S}"/install.sh

	if use examples; then
		# This is a symlink to a directory
		rm -f examples/website/images
		cp -Rf images examples/website

		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	# HTML pages (with their sources)
	dohtml -r doc/*
	insinto /usr/share/doc/${PF}/html
	doins doc/*.txt

	# Misc. documentation
	dodoc BUGS CHANGELOG README
	dodoc docbook-xsl/asciidoc-docbook-xsl.txt
}

pkg_preinst() {
	# Clean any symlinks in /etc possibly installed by previous versions
	if [ -d "${EPREFIX}/etc/asciidoc" ]; then
		einfo "Cleaning old symlinks under /etc/asciidoc"
		for entry in $(find "${EPREFIX}/etc/asciidoc" -type l); do
			rm -f $entry
		done
	fi
}
