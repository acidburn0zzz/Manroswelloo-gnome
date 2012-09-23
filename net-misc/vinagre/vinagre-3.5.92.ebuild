# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="avahi +ssh spice +telepathy"

# cairo used in vinagre-tab
# gdk-pixbuf used all over the place
RDEPEND=">=dev-libs/glib-2.28.0:2
	app-crypt/libsecret
	>=x11-libs/gtk+-3.0.3:3
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3[gtk3]
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-themes/gnome-icon-theme

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	ssh? ( >=x11-libs/vte-0.20:2.90 )
	spice? ( >=net-misc/spice-gtk-0.5[gtk3] )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-apps/sed
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

if [[ ${PV} = 9999 ]]; then
	DEPEND+="
		dev-lang/vala:0.18
		app-text/yelp-tools
		gnome-base/gnome-common"
fi

pkg_setup() {
	DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"
	G2CONF="${G2CONF}
		VALAC=$(type -P valac-0.18)
		--disable-schemas-compile
		--enable-rdp
		$(use_with avahi)
		$(use_enable ssh)
		$(use_enable spice)
		$(use_with telepathy)"
}

src_install() {
	gnome2_src_install

	# Remove its own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${ED}"/usr/share/doc/vinagre
}