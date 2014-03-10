# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpv/mpv-9999.ebuild,v 1.39 2014/01/25 13:29:24 scarabeus Exp $

EAPI=5

EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"

inherit base waf-utils pax-utils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="Video player based on MPlayer/mplayer2"
HOMEPAGE="http://mpv.io/"
SRC_URI="https://waf.googlecode.com/files/waf-1.7.13"
[[ ${PV} == *9999* ]] || \
SRC_URI+=" https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
IUSE="+alsa bluray bs2b +cdio -doc-pdf dvb +dvd dvdnav +enca encode +iconv jack -joystick
jpeg ladspa lcms +libass libcaca libguess lirc lua luajit +mpg123 -openal +opengl
oss portaudio +postproc pulseaudio pvr +quvi -radio samba +shm v4l vaapi vcd vda vdpau
vf-dlopen wayland +X xinerama +xscreensaver +xv aqua"

REQUIRED_USE="
	dvdnav? ( dvd )
	enca? ( iconv )
	lcms? ( opengl )
	libguess? ( iconv )
	luajit? ( lua )
	opengl? ( || ( wayland X aqua ) )
	pvr? ( v4l )
	radio? ( v4l || ( alsa oss ) )
	vaapi? ( X )
	vdpau? ( X )
	wayland? ( opengl )
	xinerama? ( X )
	xscreensaver? ( X )
	xv? ( X )
"

RDEPEND+="
	|| (
		>=media-video/libav-9:=[encode?,threads,vaapi?,vdpau?]
		>=media-video/ffmpeg-1.2:0=[encode?,threads,vaapi?,vdpau?]
	)
	sys-libs/ncurses
	sys-libs/zlib
	X? (
		x11-libs/libXext
		x11-libs/libXxf86vm
		opengl? ( virtual/opengl )
		lcms? ( media-libs/lcms:2 )
		vaapi? ( >=x11-libs/libva-0.34.0[X(+)] )
		vdpau? ( >=x11-libs/libvdpau-0.2 )
		xinerama? ( x11-libs/libXinerama )
		xscreensaver? ( x11-libs/libXScrnSaver )
		xv? ( x11-libs/libXv )
	)
	alsa? ( media-libs/alsa-lib )
	bluray? ( >=media-libs/libbluray-0.2.1 )
	bs2b? ( media-libs/libbs2b )
	cdio? (
		|| (
			dev-libs/libcdio-paranoia
			<dev-libs/libcdio-0.90[-minimal]
		)
	)
	dvb? ( virtual/linuxtv-dvb-headers )
	dvd? (
		>=media-libs/libdvdread-4.1.3
		dvdnav? ( >=media-libs/libdvdnav-4.2.0 )
	)
	enca? ( app-i18n/enca )
	iconv? ( virtual/libiconv )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( virtual/jpeg )
	ladspa? ( media-libs/ladspa-sdk )
	libass? (
		>=media-libs/libass-0.9.10:=[enca?,fontconfig]
		virtual/ttf-fonts
	)
	libcaca? ( >=media-libs/libcaca-0.99_beta18 )
	libguess? ( >=app-i18n/libguess-1.0 )
	lirc? ( app-misc/lirc )
	lua? (
		!luajit? ( >=dev-lang/lua-5.1 )
		luajit? ( dev-lang/luajit:2 )
	)
	mpg123? ( >=media-sound/mpg123-1.14.0 )
	openal? ( >=media-libs/openal-1.13 )
	portaudio? ( >=media-libs/portaudio-19_pre20111121 )
	postproc? (
		|| (
			media-libs/libpostproc
			>=media-video/ffmpeg-1.2:0[encode?,threads,vaapi?,vdpau?]
		)
	)
	pulseaudio? ( media-sound/pulseaudio )
	quvi? (
		>=media-libs/libquvi-0.4.1:=
		|| (
			>=media-video/libav-9[network]
			>=media-video/ffmpeg-1.2:0[network]
		)
	)
	samba? ( net-fs/samba )
	v4l? ( media-libs/libv4l )
	vda? ( >=media-video/ffmpeg-2.1.0[vda] )
	wayland? (
		>=dev-libs/wayland-1.2.0
		media-libs/mesa[egl,wayland]
		>=x11-libs/libxkbcommon-0.3.0
	)
"
ASM_DEP="dev-lang/yasm"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-lang/perl-5.8
	dev-python/docutils
	doc-pdf? ( dev-python/rst2pdf )
	X? (
		x11-proto/videoproto
		x11-proto/xf86vidmodeproto
		xinerama? ( x11-proto/xineramaproto )
		xscreensaver? ( x11-proto/scrnsaverproto )
	)
	amd64? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )
"
DOCS=( Copyright README.md etc/example.conf etc/input.conf )

pkg_setup() {
	if use !libass; then
		ewarn
		ewarn "You've disabled the libass flag. No OSD or subtitles will be displayed."
	fi

	einfo "For additional format support you need to enable the support on your"
	einfo "libavcodec/libavformat provider:"
	einfo "    media-video/libav or media-video/ffmpeg"
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		default_src_unpack
	fi

	cp "${DISTDIR}"/waf-1.7.13 "${S}"/waf || die
	chmod 0755 "${S}"/waf || die
}

src_prepare() {
	base_src_prepare
}

src_configure() {
	# keep build reproducible
	# do not add -g to CFLAGS
	# SDL output is fallback for platforms where nothing better is available
	# media-sound/rsound is in pro-audio overlay only
	waf-utils_src_configure \
		--disable-build-date \
		--disable-debug-build \
		--disable-sdl1 \
		--disable-sdl2 \
		--disable-rsound \
		$(use_enable encode encoding) \
		$(use_enable joystick) \
		$(use_enable bluray libbluray) \
		$(use_enable vcd) \
		$(use_enable quvi libquvi) \
		$(use_enable samba libsmbclient) \
		$(use_enable lirc) \
		$(use_enable lua) \
		$(usex luajit '--lua=luajit' '') \
		$(use_enable doc-pdf pdf-build) \
		$(use_enable vf-dlopen vf-dlopen-filters) \
		$(use_enable cdio cdda) \
		$(use_enable dvd dvdread) \
		$(use_enable dvdnav) \
		$(use_enable enca) \
		$(use_enable iconv) \
		$(use_enable libass) \
		$(use_enable libguess) \
		$(use_enable dvb) \
		$(use_enable pvr) \
		$(use_enable v4l libv4l2) \
		$(use_enable v4l tv) \
		$(use_enable v4l tv-v4l2) \
		$(use_enable radio) \
		$(use_enable radio radio-capture) \
		$(use_enable radio radio-v4l2) \
		$(use_enable mpg123) \
		$(use_enable jpeg) \
		$(use_enable libcaca caca) \
		$(use_enable postproc libpostproc) \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable ladspa) \
		$(use_enable portaudio) \
		$(use_enable bs2b libbs2b) \
		$(use_enable openal) \
		$(use_enable oss oss-audio) \
		$(use_enable pulseaudio pulse) \
		$(use_enable shm) \
		$(use_enable X x11) \
		$(use_enable vaapi) \
		$(use_enable vda vda-hwaccel) \
		$(use_enable vdpau) \
		$(use_enable aqua cocoa) \
		$(use_enable wayland) \
		$(use_enable xinerama) \
		$(use_enable xv) \
		$(use_enable opengl gl) \
		$(use_enable lcms lcms2) \
		$(use_enable xscreensaver xss) \
		--confdir="${EPREFIX}"/etc/${PN} \
		--mandir="${EPREFIX}"/usr/share/man \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	waf-utils_src_install

	if use luajit; then
		pax-mark -m "${ED}"usr/bin/mpv
	fi
}
