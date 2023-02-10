/*
 * This file is part of user-indicator-redux
 *
 * Copyright Budgie Desktop Developers 
 * Copyright Evan Maddock
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

using Cairo;
using Gdk;
using Gtk;

namespace UserIndicatorRedux.Widgets {
    public class UserImage : Image {
        private const string GENERIC_USER_ICON = "avatar-default";
        private const int ICON_SIZE = 48;

        public string? filename { get; construct set; default = null; }

        public UserImage () {
            Object (icon_name: GENERIC_USER_ICON, icon_size: ICON_SIZE);
        }

        public UserImage.from_file (string filename) {
            Object (filename: filename, icon_size: ICON_SIZE);
        }

        construct {
            set_from_file (filename);
            get_style_context ().add_class ("user-indicator-image");
        }

        /**
         * Try to set the user image from a file. If it fails,
         * fallback to a generic user icon.
         */
        public new void set_from_file(string filename) {
            this.filename = filename;
            var has_slash_prefix = filename.has_prefix ("/");
            var is_user_image = (has_slash_prefix && !filename.has_suffix (".face"));
            var source = (has_slash_prefix && !is_user_image) ? GENERIC_USER_ICON : filename;

            if (is_user_image) {
                try {
                    var pixbuf = new Pixbuf.from_file_at_size (source, ICON_SIZE, ICON_SIZE);
                    var surface = render_rounded (pixbuf, 1);
                    set_from_surface (surface);
                } catch (Error e) {
                    warning ("File for user image does not exist: %s", e.message);
                }
            } else {
                set_from_icon_name (source, IconSize.DIALOG);
            }
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
