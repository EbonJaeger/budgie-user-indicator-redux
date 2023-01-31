# Dependencies

applet_deps = [
    dep_accountsservice,
    dep_budgie,
    dep_gee,
    dep_gtk3,
    dep_glib,
    dep_giounix,
    dep_peas,
]

# Sources

applet_sources = [
    'applet.vala',
    'dbus.vala',
    'popover.vala',
    'Widgets/user_box.vala',
    'Widgets/user_image.vala',
]

shared_library(
    'userindicatorredux',
    applet_sources,
    dependencies: applet_deps,
    install: true,
    install_dir: applet_install_dir
)
