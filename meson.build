project(
    'budgie-user-indicator-redux',
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

# Handle i18n on the .desktop file
# Originally stolem from TingPing, stolen again from Budgie Desktop:
# https://github.com/vinszent/gnome-twitch/blob/master/data/meson.build
# Later changed to use intltool as we use _Key style files
intltool = find_program('intltool-merge')

# Screensaver stuff

budgie_screensaver = find_program('budgie-screensaver', required: false)
gnome_screensaver = find_program('gnome-screensaver', required: false)
if not budgie_screensaver.found() and not gnome_screensaver.found()
  warning('Either Budgie or GNOME Screensaver is required for screen locking functionality. Ensure that one of them is installed at runtime.')
endif

# Dependencies

dep_accountsservice = dependency('accountsservice')
dep_budgie = dependency('budgie-1.0', version: '>= 2')
dep_gee = dependency('gee-0.8', version: '>= 0.20.0')
dep_gtk3 = dependency('gtk+-3.0', version: '>= 3.24.0')
dep_glib = dependency('glib-2.0', version: '>= 2.64.0')
dep_giounix = dependency('gio-unix-2.0', version: '>= 2.64.0')
dep_peas = dependency('libpeas-1.0', version: '>= 1.26.0')
dep_vala = dependency('vapigen', version: '>= 0.52.5')

# Directories

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
datadir = join_paths(prefix, get_option('datadir'))
localedir = join_paths(prefix, get_option('localedir'))
podir = join_paths(meson.project_source_root(), 'po')
vapidir = join_paths(meson.project_source_root(), 'vapi')
applet_install_dir = join_paths(libdir, 'budgie-desktop', 'plugins', 'com.github.EbonJaeger.user-indicator-redux')

# Code configuration

with_hibernate = get_option('with-hibernate')
if with_hibernate == true
  add_project_arguments('-D', 'WITH_HIBERNATE', language: 'vala')
endif

config_data = configuration_data()
config_data.set('package_name', meson.project_name())
config_data.set('localedir', localedir)
config_file = configure_file(input: 'config.h.in', output: 'config.h', configuration: config_data)
config_dep = declare_dependency(sources: config_file, include_directories: include_directories('.'))

gnome = import('gnome')

subdir('data')
subdir('style')
subdir('po')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true
)
