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

        private GLib.Settings settings;

        private LogindInterface logind_interface;
        private ScreenSaverInterface screensaver_interface;
        private SessionManagerInterface session_interface;

        private unowned string username;

        private Box user_header;
        private HashMap<uint, Widgets.UserBox?> user_boxes;

        private ModelButton settings_button;
        private ModelButton lock_button;
        private ModelButton logout_button;
        private ModelButton suspend_button;
#if WITH_HIBERNATE
        private ModelButton hibernate_button;
#endif
        private ModelButton restart_button;
        private ModelButton shutdown_button;

        construct {
            user_boxes = new HashMap<uint, Widgets.UserBox?> ();
            username = Environment.get_user_name ();

            var box = new Box (Orientation.VERTICAL, 0);
            box.get_style_context ().add_class ("user-indicator-menu");

            user_header = new Box (Orientation.VERTICAL, 12);

            settings_button = new ModelButton () {
                text = "User Settings..."
            };
            settings_button.get_style_context ().add_class ("flat");
            settings_button.get_style_context ().add_class ("user-indicator-button");
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

            lock_button = new ModelButton () {
                text = "Lock"
            };
            lock_button.get_style_context ().add_class ("user-indicator-button");

            logout_button = new ModelButton () {
                text = "Logout..."
            };
            logout_button.get_style_context ().add_class ("user-indicator-button");

            suspend_button = new ModelButton () {
                text = "Suspend"
            };
            suspend_button.get_style_context ().add_class ("user-indicator-button");

#if WITH_HIBERNATE
            hibernate_button = new ModelButton () {
                text = "Hibernate"
            };
            hibernate_button.get_style_context ().add_class ("user-indicator-button");
#endif

            restart_button = new ModelButton () {
                text = "Reboot..."
            };
            restart_button.get_style_context ().add_class ("user-indicator-button");

            shutdown_button = new ModelButton () {
                text = "Shutdown..."
            };
            shutdown_button.get_style_context ().add_class ("user-indicator-button");

            user_header.pack_end (settings_button);
            box.pack_start (user_header, false, false, 0);
            box.pack_start (new Separator (Orientation.HORIZONTAL), true, true, 2);
            box.pack_start (lock_button);
            box.pack_start (logout_button);
            box.pack_start (new Separator (Orientation.HORIZONTAL), true, true, 2);
            box.pack_start (suspend_button);
#if WITH_HIBERNATE
            box.pack_start (hibernate_button);
#endif
            box.pack_start (restart_button);
            box.pack_start (shutdown_button);
            add (box);

            user_manager = Act.UserManager.get_default ();
            init_user ();
            user_manager.notify["is-loaded"].connect (init_user);

            init_interfaces.begin ();

            lock_button.clicked.connect (() => {
                hide ();

                try {
                    screensaver_interface.lock ();
                } catch (Error e) {
                    warning ("Unable to lock the screen: %s", e.message);
                }
            });

            logout_button.clicked.connect (() => {
                hide ();

                session_interface.logout.begin (0, (obj, res) => {
                    try {
                        session_interface.logout.end (res);
                    } catch (Error e) {
                        if (e is IOError.CANCELLED) return;
                        warning ("Unable to open logout dialog: %s", e.message);
                    }
                });
            });

            suspend_button.clicked.connect (() => {
                hide ();

                try {
                    logind_interface.suspend (true);
                } catch (Error e) {
                    warning ("Unable to suspend: %s", e.message);
                }
            });

#if WITH_HIBERNATE
            hibernate_button.clicked.connect (() => {
                hide ();

                try {
                    logind_interface.hibernate (true);
                } catch (Error e) {
                    warning ("Unable to hibernate: %s", e.message);
                }
            });
#endif

            restart_button.clicked.connect (() => {
                hide ();

                session_interface.reboot.begin ((obj, res) => {
                    try {
                        session_interface.reboot.end (res);
                    } catch (Error e) {
                        if (e is IOError.CANCELLED) return;
                        warning ("Unable to open reboot dialog: %s", e.message);
                    }
                });
            });

            shutdown_button.clicked.connect (() => {
                hide ();

                session_interface.shutdown.begin ((obj, res) => {
                    try {
                        session_interface.shutdown.end (res);
                    } catch (Error e) {
                        if (e is IOError.CANCELLED) return;
                        warning ("Unable to open shutdown dialog: %s", e.message);
                    }
                });
            });

#if WITH_HIBERNATE
            show.connect (() => {
                var can_hibernate = false;
                try {
                    var resp = logind_interface.can_hibernate ();
                    if (resp == "yes") can_hibernate = true;
                } catch (Error e) {
                    warning ("Unable to check if we can hibernate: %s", e.message);
                }

                hibernate_button.sensitive = can_hibernate;
                hibernate_button.tooltip_text = can_hibernate ? null : "This system does not support hibernation";
            });
#endif
        }

        public Popover (GLib.Settings settings, Widget? parent_window) {
            Object (relative_to: parent_window);
            get_child ().show_all ();
            this.settings = settings;
            settings.bind ("show-user-settings", settings_button, "visible", SettingsBindFlags.GET);
            settings.bind ("show-suspend", suspend_button, "visible", SettingsBindFlags.GET);
#if WITH_HIBERNATE
            settings.bind ("show-hibernate", hibernate_button, "visible", SettingsBindFlags.GET);
#endif
        }

        private async void init_interfaces () {
            try {
                logind_interface = yield Bus.get_proxy<LogindInterface> (BusType.SYSTEM, "org.freedesktop.login1", "/org/freedesktop/login1");
            } catch (Error e) {
                warning ("Unable to connect to LoginD interface: %s", e.message);
            }

            try {
                screensaver_interface = yield Bus.get_proxy<ScreenSaverInterface> (BusType.SESSION, "org.gnome.ScreenSaver", "/org/gnome/ScreenSaver");
            } catch (Error e) {
#if HAVE_GNOME_SCREENSAVER
                warning ("Unable to connect to GNOME ScreenSaver interface: %s", e.message);
#else
                warning ("Unable to connect to Budgie ScreenSaver interface: %s", e.message);
#endif
            }

            try {
                session_interface = yield Bus.get_proxy<SessionManagerInterface> (BusType.SESSION, "org.gnome.SessionManager", "/org/gnome/SessionManager");
            } catch (Error e) {
                warning ("Unable to connect to SessionManager interface: %s", e.message);
            }
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