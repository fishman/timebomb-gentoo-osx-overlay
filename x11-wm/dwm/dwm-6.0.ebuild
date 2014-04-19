# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/dwm/dwm-6.0.ebuild,v 1.12 2013/02/06 15:19:31 jer Exp $

EAPI="4"

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://dwm.suckless.org/"
SRC_URI="http://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-macos ~x64-macos"
IUSE="xinerama systray"

DEPEND="x11-libs/libX11
	xinerama? (
		x11-proto/xineramaproto
		x11-libs/libXinerama
		)"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s/CFLAGS = -std=c99 -pedantic -Wall -Os/CFLAGS += -std=c99 -pedantic -Wall/" \
		-e "/^LDFLAGS/{s|=|+=|g;s|-s ||g}" \
		-e "s/#XINERAMALIBS =/XINERAMALIBS ?=/" \
		-e "s/#XINERAMAFLAGS =/XINERAMAFLAGS ?=/" \
		-e "s@/usr/X11R6/include@${EPREFIX}/usr/include/X11@" \
		-e "s@/usr/X11R6/lib@${EPREFIX}/usr/lib@" \
		-e "s@-I/usr/include@@" -e "s@-L/usr/lib@@" \
		config.mk || die
	sed -i \
		-e '/@echo CC/d' \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die

	restore_config config.h
	epatch "${FILESDIR}/01-dwm-6.0-pertag2.diff"
	epatch "${FILESDIR}/02-dwm-6.0-push.diff"
	epatch "${FILESDIR}/03-dwm-6.0-cycle.diff"
	epatch "${FILESDIR}/04-dwm-6.0-gaplessgrid.diff"
	epatch "${FILESDIR}/05-dwm-6.0-pidgin.diff"
	epatch "${FILESDIR}/06-dwm-6.0-monocle_count.diff"
	epatch "${FILESDIR}/07-dwm-6.0-monocle_borderless.diff"
	epatch "${FILESDIR}/08-dwm-6.0-clicktofocus.diff"
	epatch "${FILESDIR}/09-dwm-6.0-viewontag.diff"
	epatch "${FILESDIR}/10-dwm-6.0-scratchpad.diff"
	epatch "${FILESDIR}/11-dwm-6.0-togglemax.diff"
	epatch "${FILESDIR}/12-dwm-6.0-autoresize.diff"
	epatch "${FILESDIR}/13-dwm-6.0-increase_mfact_limit.diff"
	# epatch "${FILESDIR}/14-dwm-6.0-remember-tags.diff"
	epatch "${FILESDIR}/15-dwm-6.0-centred-floating.diff"
	epatch "${FILESDIR}/16-dwm-6.0-focusurgent.diff"
	epatch "${FILESDIR}/17-dwm-6.0-statuscolors.diff"
	# epatch "${FILESDIR}/18-dwm-6.0-save_floats.diff"
	epatch "${FILESDIR}/20-dwm-6.0-centerwindow.diff"
	if use systray; then
		epatch "${FILESDIR}/19-dwm-6.0-systray.diff"
	fi
	epatch_user
}

src_compile() {
	if use xinerama; then
		emake CC=$(tc-getCC) dwm
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/dwm-session2 dwm

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/dwm.desktop

	dodoc README

	save_config config.h
}

pkg_postinst() {
	einfo "This ebuild has support for user defined configs"
	einfo "Please read this ebuild for more details and re-emerge as needed"
	einfo "if you want to add or remove functionality for ${PN}"
	if ! has_version x11-misc/dmenu; then
		elog "Installing ${PN} without x11-misc/dmenu"
		einfo "To have a menu you can install x11-misc/dmenu"
	fi
	einfo "You can custom status bar with a script in HOME/.dwm/dwmrc"
	einfo "the ouput is redirected to the standard input of dwm"
	einfo "Since dwm-5.4, status info in the bar must be set like this:"
	einfo "xsetroot -name \"\`date\` \`uptime | sed 's/.*,//'\`\""
}
