project(
    'budgie-indicator-applet-redux',
    ['vala', 'c'],
    version: '0.1.0',
    license: 'GPL-2.0',
    meson_version: '>= 0.57.0',
    default_options: [
        'b_lto=false',
        'c_std=gnu11',
        'buildtype=release',
        'optimization=3',
        'warning_level=3',
    ],
)

# Dependencies

dep_budgie = dependency('budgie-1.0', version: '>= 2')
dep_gtk3 = dependency('gtk+-3.0', version: '>= 3.24.0')
dep_glib = dependency('glib-2.0', version: '>= 2.64.0')
dep_giounix = dependency('gio-unix-2.0', version: '>= 2.64.0')
dep_peas = dependency('libpeas-1.0', version: '>= 1.26.0')
dep_vala = dependency('vapigen', version: '>= 0.52.5')

# Directories

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
datadir = join_paths(prefix, get_option('datadir'))
applet_install_dir = join_paths(libdir, 'budgie-desktop', 'plugins', 'com.github.EbonJaeger.budgie-user-indicator-applet-redux')

# Code configuration

with_hibernate = get_option('with-hibernate')
if with_hibernate == true
  add_project_arguments('-D', 'WITH_HIBERNATE', language: 'vala')
endif

subdir('data')
subdir('src')