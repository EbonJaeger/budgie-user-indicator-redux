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

using GLib;

namespace UserIndicatorRedux {
    [DBus (name = "org.freedesktop.Accounts")]
    public interface AccountsRemote : Object {
        public abstract string find_user_by_name (string username) throws DBusError, IOError;
    }

    [DBus (name = "org.freedesktop.Accounts.User")]
    public interface AccountUserRemote : Object {
        public signal void changed ();
    }

    [DBus (name = "org.freedesktop.DBus.Properties")]
    public interface PropertiesRemote : Object {
        public signal void properties_changed ();

        public abstract Variant get (string iface, string property) throws DBusError, IOError;
    }

    [DBus (name = "org.freedesktop.login1.Manager")]
    public interface LogindRemote : Object {
        public abstract string can_hibernate () throws DBusError, IOError;

        public abstract void suspend (bool interactive) throws DBusError, IOError;
        public abstract void hibernate (bool interactive) throws DBusError, IOError;
    }

    [DBus (name = "org.gnome.ScreenSaver")]
    public interface ScreensaverRemote : Object {
        public abstract void lock () throws Error;
    }

    [DBus (name = "org.gnome.SessionManager")]
    public interface SessionManagerRemote : Object {
        public abstract void logout (uint mode) throws DBusError, IOError;
        public abstract async void reboot () throws Error;
        public abstract async void shutdown () throws Error;
    }
}
