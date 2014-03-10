# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-2.1.4.ebuild,v 1.1 2014/03/06 19:53:26 aballier Exp $

EAPI="5"

# Subslot: libavutil major.libavcodec major.libavformat major
# Since FFmpeg ships several libraries, subslot is kind of limited here.
# Most consumers will use those three libraries, if a "less used" library
# changes its soname, consumers will have to be rebuilt the old way
# (preserve-libs).
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
FFMPEG_SUBSLOT=52.55.55

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://source.ffmpeg.org/ffmpeg.git"
fi

inherit eutils flag-o-matic multilib toolchain-funcs ${SCM}

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.org/"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
elif [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
else # Release
	SRC_URI="http://ffmpeg.org/releases/${P/_/-}.tar.bz2"
fi
FFMPEG_REVISION="${PV#*_p}"

LICENSE="GPL-2 amr? ( GPL-3 ) encode? ( aac? ( GPL-3 ) )"
SLOT="0/${FFMPEG_SUBSLOT}"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi
IUSE="
	aac aacplus alsa amr amrenc bindist bluray +bzip2 cdio celt
	cpudetection debug doc +encode examples faac fdk flite fontconfig frei0r
	gme	gnutls gsm +hardcoded-tables +iconv iec61883 ieee1394 jack jpeg2k
	ladspa libass libcaca libsoxr libv4l modplug mp3 +network openal openssl opus
	oss pic pulseaudio quvi rtmp schroedinger sdl speex ssh static-libs test theora
	threads truetype twolame v4l vaapi vdpau vorbis vpx wavpack X x264 xvid
	+zlib zvbi
	"

ARM_CPU_FEATURES="armv5te armv6 armv6t2 neon armvfp:vfp"
MIPS_CPU_FEATURES="mips32r2 mipsdspr1 mipsdspr2 mipsfpu"
PPC_CPU_FEATURES="altivec"
SPARC_CPU_FEATURES="vis"
X86_CPU_FEATURES="3dnow:amd3dnow 3dnowext:amd3dnowext avx avx2 fma4 mmx mmxext sse sse2 sse3 ssse3 sse4 sse4_2:sse42"

# String for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
CPU_FEATURES="
	${ARM_CPU_FEATURES}
	${MIPS_CPU_FEATURES}
	${PPC_CPU_FEATURES}
	${SPARC_CPU_FEATURES}
	${X86_CPU_FEATURES}
"

for i in ${CPU_FEATURES}; do
	IUSE="${IUSE} ${i%:*}"
done

FFTOOLS="aviocat cws2fws ffescape ffeval ffhash fourcc2pixfmt graph2dot ismindex pktdumper qt-faststart trasher"

for i in ${FFTOOLS}; do
	IUSE="${IUSE} +fftools_$i"
done

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	bluray? ( media-libs/libbluray )
	bzip2? ( app-arch/bzip2 )
	cdio? ( || ( dev-libs/libcdio-paranoia <dev-libs/libcdio-0.90[-minimal] ) )
	celt? ( >=media-libs/celt-0.11.1 )
	encode? (
		aac? ( media-libs/vo-aacenc )
		aacplus? ( media-libs/libaacplus )
		amrenc? ( media-libs/vo-amrwbenc )
		faac? ( media-libs/faac )
		mp3? ( >=media-sound/lame-3.98.3 )
		theora? ( >=media-libs/libtheora-1.1.1[encode] media-libs/libogg )
		twolame? ( media-sound/twolame )
		wavpack? ( media-sound/wavpack )
		x264? ( >=media-libs/x264-0.0.20111017:= )
		xvid? ( >=media-libs/xvid-1.1.0 )
	)
	fdk? ( media-libs/fdk-aac )
	flite? ( app-accessibility/flite )
	fontconfig? ( media-libs/fontconfig )
	frei0r? ( media-plugins/frei0r-plugins )
	gme? ( media-libs/game-music-emu )
	gnutls? ( >=net-libs/gnutls-2.12.16 )
	gsm? ( >=media-sound/gsm-1.0.12-r1 )
	iconv? ( virtual/libiconv )
	iec61883? ( media-libs/libiec61883 sys-libs/libraw1394 sys-libs/libavc1394 )
	ieee1394? ( media-libs/libdc1394 sys-libs/libraw1394 )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg2k? ( >=media-libs/openjpeg-1.3-r2:0 )
	libass? ( media-libs/libass )
	libcaca? ( media-libs/libcaca )
	libsoxr? ( media-libs/soxr )
	libv4l? ( media-libs/libv4l )
	modplug? ( media-libs/libmodplug )
	openal? ( >=media-libs/openal-1.1 )
	openssl? ( dev-libs/openssl )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	quvi? ( media-libs/libquvi:0.4 )
	rtmp? ( >=media-video/rtmpdump-2.2f )
	sdl? ( >=media-libs/libsdl-1.2.13-r1[audio,video] )
	schroedinger? ( media-libs/schroedinger )
	speex? ( >=media-libs/speex-1.2_beta3 )
	ssh? ( net-libs/libssh )
	truetype? ( media-libs/freetype:2 )
	vaapi? ( >=x11-libs/libva-0.32 )
	vdpau? ( x11-libs/libvdpau )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	vpx? ( >=media-libs/libvpx-0.9.6 )
	X? ( x11-libs/libX11 x11-libs/libXext x11-libs/libXfixes )
	zlib? ( sys-libs/zlib )
	zvbi? ( media-libs/zvbi )
	!media-video/qt-faststart
	!media-libs/libpostproc
"

DEPEND="${RDEPEND}
	>=sys-devel/make-3.81
	doc? ( app-text/texi2html )
	fontconfig? ( virtual/pkgconfig )
	gnutls? ( virtual/pkgconfig )
	ieee1394? ( virtual/pkgconfig )
	ladspa? ( media-libs/ladspa-sdk )
	libv4l? ( virtual/pkgconfig )
	mmx? ( >=dev-lang/yasm-1.2 )
	rtmp? ( virtual/pkgconfig )
	schroedinger? ( virtual/pkgconfig )
	test? ( net-misc/wget )
	truetype? ( virtual/pkgconfig )
	v4l? ( sys-kernel/linux-headers )
"
# faac is license-incompatible with ffmpeg
REQUIRED_USE="bindist? ( encode? ( !faac !aacplus ) !openssl )
	libv4l? ( v4l )
	fftools_cws2fws? ( zlib )
	test? ( encode )"

S=${WORKDIR}/${P/_/-}
BUILD_DIR=${S}_build

src_prepare() {
	if [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
		export revision=git-N-${FFMPEG_REVISION}
	fi
	epatch_user
}

src_configure() {
	mkdir -p "${BUILD_DIR}"
	cd "${BUILD_DIR}"

	local myconf="${EXTRA_FFMPEG_CONF}"

	# options to use as use_enable in the foo[:bar] form.
	# This will feed configure with $(use_enable foo bar)
	# or $(use_enable foo foo) if no :bar is set.
	local ffuse="bzip2:bzlib cpudetection:runtime-cpudetect debug doc
			     gnutls hardcoded-tables iconv network openssl sdl:ffplay vaapi vdpau zlib"
	use openssl && myconf="${myconf} --enable-nonfree"

	# Encoders
	if use encode
	then
		ffuse="${ffuse} aac:libvo-aacenc amrenc:libvo-amrwbenc mp3:libmp3lame"
		for i in aacplus faac theora twolame wavpack x264 xvid; do
			ffuse="${ffuse} ${i}:lib${i}"
		done

		# Licensing.
		if use aac || use amrenc ; then
			myconf="${myconf} --enable-version3"
		fi
		if use aacplus || use faac ; then
			myconf="${myconf} --enable-nonfree"
		fi
	else
		myconf="${myconf} --disable-encoders"
	fi

	# libavdevice options
	ffuse="${ffuse}	cdio:libcdio iec61883:libiec61883 ieee1394:libdc1394 libcaca openal"

	# Indevs
	use v4l || myconf="${myconf} --disable-indev=v4l2 --disable-outdev=v4l2"
	for i in alsa oss jack ; do
		use ${i} || myconf="${myconf} --disable-indev=${i}"
	done
	ffuse="${ffuse}	libv4l:libv4l2 pulseaudio:libpulse X:x11grab"

	# Outdevs
	for i in alsa oss sdl ; do
		use ${i} || myconf="${myconf} --disable-outdev=${i}"
	done

	# libavfilter options
	ffuse="${ffuse} flite:libflite frei0r fontconfig ladspa libass truetype:libfreetype"

	# libswresample options
	ffuse="${ffuse} libsoxr"

	# Threads; we only support pthread for now but ffmpeg supports more
	ffuse="${ffuse} threads:pthreads"

	# Decoders
	ffuse="${ffuse} amr:libopencore-amrwb amr:libopencore-amrnb fdk:libfdk-aac jpeg2k:libopenjpeg"
	use amr && myconf="${myconf} --enable-version3"
	for i in bluray celt gme gsm modplug opus quvi rtmp ssh schroedinger speex vorbis vpx zvbi; do
		ffuse="${ffuse} ${i}:lib${i}"
	done
	use fdk && myconf="${myconf} --enable-nonfree"

	for i in ${ffuse} ; do
		myconf="${myconf} $(use_enable ${i%:*} ${i#*:})"
	done

	# CPU features
	for i in ${CPU_FEATURES}; do
		use ${i%:*} || myconf="${myconf} --disable-${i#*:}"
	done
	if use pic ; then
		myconf="${myconf} --enable-pic"
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		use x86 && myconf="${myconf} --disable-asm"
	fi
	[[ ${ABI} == "x32" ]] && myconf+=" --disable-asm" #427004

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[ "${i}" = "native" ] && i="host" # bug #273421
		myconf="${myconf} --cpu=${i}"
		break
	done

	# Mandatory configuration
	myconf="
		--enable-gpl
		--enable-postproc
		--enable-avfilter
		--enable-avresample
		--disable-stripping
		${myconf}"

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf="${myconf} --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}-"
		case ${CHOST} in
			*freebsd*)
				myconf="${myconf} --target-os=freebsd"
				;;
			mingw32*)
				myconf="${myconf} --target-os=mingw32"
				;;
			*linux*)
				myconf="${myconf} --target-os=linux"
				;;
		esac
	fi

	"${S}/configure" \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--mandir="${EPREFIX}/usr/share/man" \
		--enable-shared \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--optflags="${CFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		$(use_enable static-libs static) \
		${myconf} || die
}

src_compile() {
	cd "${BUILD_DIR}"
	emake V=1

	for i in ${FFTOOLS} ; do
		if use fftools_$i ; then
			emake V=1 tools/$i
		fi
	done
}

src_install() {
	cd "${BUILD_DIR}"
	emake V=1 DESTDIR="${D}" install install-man

	for i in ${FFTOOLS} ; do
		if use fftools_$i ; then
			dobin tools/$i
		fi
	done

	cd "${S}"
	dodoc Changelog README CREDITS doc/*.txt doc/APIchanges doc/RELEASE_NOTES
	use doc && dohtml -r doc/*
	if use examples ; then
		dodoc -r doc/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

src_test() {
	cd "${BUILD_DIR}"
	LD_LIBRARY_PATH="${BUILD_DIR}/libpostproc:${BUILD_DIR}/libswscale:${BUILD_DIR}/libswresample:${BUILD_DIR}/libavcodec:${BUILD_DIR}/libavdevice:${BUILD_DIR}/libavfilter:${BUILD_DIR}/libavformat:${BUILD_DIR}/libavutil:${BUILD_DIR}/libavresample" \
		emake V=1 fate
}
