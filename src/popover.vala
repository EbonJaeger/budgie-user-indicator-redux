/*
 * This file is part of user-indicator-redux
 *
 * Copyright Evan Maddock
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

using Gtk;

namespace UserIndicatorRedux {
    public class Popover : Budgie.Popover {
        private Widgets.UserButton user_button;

        construct {
            get_style_context ().add_class ("user-menu");

            var box = new Box (Orientation.VERTICAL, 0);

            user_button = new Widgets.UserButton ();

            box.pack_start (user_button);
            box.pack_start (new Separator (Orientation.HORIZONTAL), true, true, 2);
            add (box);
        }

        public Popover (Widget? parent_window) {
            Object (relative_to: parent_window);
        }
    }
}