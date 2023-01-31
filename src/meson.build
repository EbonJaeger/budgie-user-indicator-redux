# Dependencies

applet_deps = [
    dep_budgie,
    dep_gtk3,
    dep_glib,
    dep_giounix,
    dep_peas,
    dep_vala
]

# Sources

applet_sources = []

shared_library(
    'userindicator-redux',
    applet_sources,
    dependencies: applet_deps,
    install: true,
    install_dir: applet_install_dir
)
