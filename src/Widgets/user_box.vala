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

using Act;
using Gtk;

namespace UserIndicatorRedux.Widgets {
    public class UserBox : ListBoxRow {
        public User? user { get; construct; default = null; }
        public string fullname { get; construct set; }

        private UserImage user_image;
        private Label fullname_label;
        private Label type_label;

        public UserBox (User user) {
            Object (user: user);
        }

        construct {
            get_style_context ().add_class ("user-indicator-userbox");

            fullname_label = new Label ("%s".printf (fullname)) {
                valign = START,
                margin_top = 8
            };
            fullname_label.get_style_context ().add_class ("user-indicator-userbox-name");

            type_label = new Label (null) {
                halign = START,
                valign = START
            };
            type_label.get_style_context ().add_class ("user-indicator-userbox-type");

            if (user == null) {
                user_image = new UserImage ();
            } else {
                user_image = new UserImage.from_file (user.icon_file);

                var type = (UserAccountType) user.account_type;
                type_label.label = "%s".printf (account_type_for_display (type));

                user.changed.connect (update);
                update ();
            }

            var grid = new Grid () {
                column_spacing = 12
            };
            grid.attach (user_image, 0, 0, 3, 3);
            grid.attach (fullname_label, 3, 0, 2, 1);
            grid.attach (type_label, 3, 1, 2, 1);

            add (grid);
            show_all ();
        }

        private void update () {
            if (user == null) return;

            fullname_label.label = "%s".printf (user.real_name);
            var type = (UserAccountType) user.account_type;
            type_label.label = "%s".printf (account_type_for_display (type));
            user_image.set_from_file (user.icon_file);
        }

        /**
         * Format a user account type for display.
         */
        private string account_type_for_display (UserAccountType type) {
            var ret = _("Unknown");

            switch (type) {
                case UserAccountType.ADMINISTRATOR:
                    ret = _("Administrator");
                    break;
                case UserAccountType.STANDARD:
                    ret = _("Standard");
                    break;
                default:
                    ret = _("Unknown");
                    break;
            }

            return ret;
        }
    }
}
