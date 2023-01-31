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
using Gee;
using Gtk;
using Pango;

namespace UserIndicatorRedux {
    public class Popover : Budgie.Popover {
        private unowned Act.UserManager user_manager;

        private unowned string username;

        private Box user_header;
        private HashMap<uint, Widgets.UserBox?> user_boxes;

        construct {
            user_boxes = new HashMap<uint, Widgets.UserBox?> ();
            username = Environment.get_user_name ();
            get_style_context ().add_class ("user-menu");

            var box = new Box (Orientation.VERTICAL, 0);

            user_header = new Box (Orientation.VERTICAL, 12);

            var settings_button = new ModelButton () {
                text = "User Settings..."
            };
            settings_button.get_style_context ().add_class ("flat");
            settings_button.clicked.connect (() => {
                var info = new DesktopAppInfo ("budgie-user-accounts-panel.desktop");
                if (info == null) return;

                try {
                    info.launch (null, null);
                    hide ();
                } catch (Error e) {
                    warning ("Unable to launch User settings: %s", e.message);
                }
            });

            user_header.pack_end (settings_button);
            box.pack_start (user_header, false, false, 0);
            box.pack_start (new Separator (Orientation.HORIZONTAL), true, true, 2);
            add (box);

            user_manager = Act.UserManager.get_default ();
            init_user ();
            user_manager.notify["is-loaded"].connect (init_user);
        }

        public Popover (Widget? parent_window) {
            Object (relative_to: parent_window);
        }

        private void init_user () {
            if (!user_manager.is_loaded) return;

            unowned var user = user_manager.get_user (username);
            user.notify["is-loaded"].connect (() => {
                var uid = user.uid;

                if (user_boxes.has_key (uid)) return;

                var user_box = new Widgets.UserBox (user);
                user_boxes[uid] = user_box;
                user_header.pack_start (user_box);
            });
        }
    }
}