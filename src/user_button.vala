/*
 * This file is part of user-indicator-redux, taken and adapted from
 * Budgie Desktop.
 *
 * Copyright Budgie Desktop Developers, Evan Maddock
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

using Cairo;
using Gdk;
using GLib;
using Gtk;

namespace UserIndicatorRedux.Widgets {
    /**
     * Creates a button using the current user's profile picture, if they
     * have one set, falling back to a generic user icon.
     */
    public class UserButton : Button {
        const string ACCOUNTS_DBUS_NAME = "org.freedesktop.Accounts";
        const string ACCOUNTS_USER_IFACE = "org.freedesktop.Accounts.User";

        private const string GENERIC_USER_ICON = "user-info";

        private AccountsRemote? user_manager;
        private AccountUserRemote? user;
        private PropertiesRemote? user_props;

        private unowned string username;

        construct {
            get_style_context ().add_class ("user-icon-button");
            username = Environment.get_user_name ();
            setup_dbus.begin ();
        }

        public UserButton () {
            Object (always_show_image: true, relief: ReliefStyle.NONE);
        }

        private async void setup_dbus () {
            try {
                user_manager = yield Bus.get_proxy<AccountsRemote> (SYSTEM, ACCOUNTS_DBUS_NAME, "/org/freedesktop/Accounts");
                var uid = user_manager.find_user_by_name (username);

                try {
                    user_props = yield Bus.get_proxy<PropertiesRemote> (SYSTEM, ACCOUNTS_DBUS_NAME, uid);
                    update_user_info ();
                } catch (Error e) {
                    warning ("Unable to connect to Accounts User Service: %s", e.message);
                }

                try {
                    user = yield Bus.get_proxy<AccountUserRemote> (SYSTEM, ACCOUNTS_DBUS_NAME, uid);
                    user.changed.connect (update_user_info);
                } catch (Error e) {
                    warning ("Unable to connect to Accounts User Service: %s", e.message);
                }
            } catch (Error e) {
                warning ("Unable to connect to Accounts Service: %s", e.message);
            }
        }

        /**
         * Sets the user name and profile picture from DBus.
         */
        private void update_user_info () {
            var user_image = get_user_image ();
            var user_name = get_user_name ();

            set_user_image (user_image);
            set_label (user_name);
        }

        /**
         * Gets the name of the image for the current user.
         *
         * If no image has been set for this user, a generic icon is returned instead.
         */
        private string get_user_image () {
            if (user_props == null) return GENERIC_USER_ICON;

            try {
                var variant = user_props.get (ACCOUNTS_USER_IFACE, "IconFile");
                if (variant != null && variant.is_of_type (VariantType.STRING)) {
                    var icon_file = variant.get_string ();
                    if (icon_file != "") return icon_file;
                }
            } catch (Error e) {
                warning ("Unable to get user image: %s", e.message);
            }

            return GENERIC_USER_ICON;
        }

        /**
         * Gets the real name of the current user.
         *
         * If no name has been set for this user, their username is returned instead.
         */
        private string get_user_name () {
            if (user_props == null) return username;

            try {
                var variant = user_props.get (ACCOUNTS_USER_IFACE, "RealName");
                if (variant != null && variant.is_of_type (VariantType.STRING)) {
                    var real_name = variant.get_string ();
                    if (real_name != "") return real_name;
                }
            } catch (Error e) {
                warning ("Unable to get user image: %s", e.message);
            }

            return username;
        }

        /**
         * Try to set the user image from a file. If it fails,
         * fallback to a generic user icon.
         */
        private void set_user_image (string source) {
            var has_slash_prefix = source.has_prefix ("/");
            var is_user_image = (has_slash_prefix && !source.has_suffix (".face"));

            if (has_slash_prefix && !is_user_image) {
                source = GENERIC_USER_ICON;
            }

            var user_image = new Image () {
                margin_end = 6
            };

            if (is_user_image) {
                try {
                    var pixbuf = new Pixbuf.from_file_at_size (source, 24, 24);
                    var surface = render_rounded (pixbuf, 1);
                    user_image.set_from_surface (surface);
                } catch (Error e) {
                    warning ("File for user image does not exist: %s", e.message);
                }
            } else {
                user_image.set_from_icon_name (source, IconSize.LARGE_TOOLBAR);
            }

            set_image (user_image);
        }

        /**
         * Takes a `Gdk.Pixbuf` and turns it into a circle.
         *
         * This was ported from the C functions to do the same thing in
         * Budgie Control Center.
         */
        private Surface render_rounded (Pixbuf source, int scale) {
            var size = source.width;
            var surface = new ImageSurface (Format.ARGB32, size, size);
            var context = new Context (surface);

            // Clip a circle
            context.arc (size/2, size/2, size/2, 0, 2 * Math.PI);
            context.clip ();
            context.new_path ();

            Gdk.cairo_set_source_pixbuf (context, source, 0, 0);
            context.paint ();

            var rounded = Gdk.pixbuf_get_from_surface (surface, 0, 0, size, size);
            return Gdk.cairo_surface_create_from_pixbuf (rounded, scale, null);
        }
    }
}