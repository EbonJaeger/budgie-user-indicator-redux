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

using Gdk;
using Gtk;

namespace UserIndicatorRedux {
    public class Plugin : Budgie.Plugin, Peas.ExtensionBase {
        public Budgie.Applet get_panel_widget (string uuid) {
            return new UserIndicatorRedux.Applet (uuid);
        }
    }

    public class Applet : Budgie.Applet {
        public string uuid { get; set; }

        private unowned Budgie.PopoverManager? manager = null;

        private Button button;
        private Popover popover;

        construct {
            // Load our CSS
            var screen = Screen.get_default ();
            var provider = new CssProvider ();
            provider.load_from_resource ("/com/github/EbonJaeger/user-indicator-redux/style.css");
            StyleContext.add_provider_for_screen (screen, provider, STYLE_PROVIDER_PRIORITY_APPLICATION);

            // Create our widgets
            button = new Button.from_icon_name ("system-shutdown-symbolic", MENU);
            button.get_style_context ().add_class ("flat");

            popover = new Popover (button);
            popover.get_child ().show_all ();

            // Toggle the popover on click
            button.clicked.connect (() => {
                if (manager == null) return;

                if (popover.visible) {
                    popover.hide ();
                } else {
                    manager.show_popover (button);
                }
            });

            add (button);
            show_all ();
        }

        public Applet (string uuid) {
            Object (uuid: uuid);
        }

        public override void update_popovers (Budgie.PopoverManager? manager) {
            this.manager = manager;
            manager.register_popover (button, popover);
        }
    }
}

[ModuleInit]
public void peas_register_types (TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Budgie.Plugin), typeof (UserIndicatorRedux.Plugin));
}