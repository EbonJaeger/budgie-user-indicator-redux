install_data('com.github.EbonJaeger.user-indicator-redux.gschema.xml',
  install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()]
  )
endif

custom_target(
  'appdata-file-user-indicator-redux',
  input: 'user-indicator-redux.appdata.xml.in',
  output: 'com.github.EbonJaeger.user-indicator-redux.appdata.xml',
  command: [intltool, '--xml-style', podir, '@INPUT@', '@OUTPUT@'],
  install_dir: join_paths(datadir, 'metainfo'),
  install: true
)

custom_target(
  'plugin-file-user-indicator-redux',
  input: 'UserIndicatorRedux.plugin.in',
  output: 'UserIndicatorRedux.plugin',
  command: [intltool, '--desktop-style', podir, '@INPUT@', '@OUTPUT@'],
  install_dir: applet_install_dir,
  install: true
)
