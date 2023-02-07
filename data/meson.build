install_data('com.github.EbonJaeger.user-indicator-redux.gschema.xml',
  install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()]
  )
endif

install_data('UserIndicatorRedux.plugin', install_dir: applet_install_dir)

appstream_file = 'com.github.EbonJaeger.user-indicator-redux.appdata.xml'
install_data(appstream_file, install_dir: join_paths(datadir, 'metainfo'))

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test(
    'validate metainfo file',
    appstream_util,
    args: ['validate', join_paths(meson.current_source_dir(), appstream_file)]
  )
endif
