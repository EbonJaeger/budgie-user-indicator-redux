# Dependencies

applet_deps = [
    dep_budgie,
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
    'user_button.vala',
]

shared_library(
    'userindicatorredux',
    applet_sources,
    dependencies: applet_deps,
    # vala_args: [
    #     '--pkg', 'libpeas-1.0',
    # ],
    install: true,
    install_dir: applet_install_dir
)
