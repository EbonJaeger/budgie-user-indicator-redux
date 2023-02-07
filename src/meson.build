# Compile our resources

gresource = join_paths(meson.current_source_dir(), 'user-indicator-redux.gresource.xml')

applet_resources = gnome.compile_resources(
    'user-indicator-redux-resources',
    gresource,
    dependencies: [ style ],
    c_name: 'user_indicator_redux',
)

lib_applet_resources = static_library(
    'user-indicator-redux-resources',
    applet_resources,
    dependencies: [ dep_glib ],
    install: false,
    c_args: [ '-Wno-overlength-strings' ],
)

# Dependencies

applet_deps = [
    config_dep,
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
    vala_args: [
        '--pkg=config',
        '--vapidir=' + vapidir,
        '--target-glib=2.38',
        '--gresources=' + gresource,
    ],
    c_args: [
        '-include', 'config.h'
    ],
    link_whole: [
        lib_applet_resources,
    ],
    install: true,
    install_dir: applet_install_dir
)
