install_data(
  configure_file(
    input: 'gschema.in.xml',
    output: conf.get('name') + '.gschema.xml',
    configuration: conf
  ),
  install_dir: join_paths(
    get_option('datadir'),
    'glib-2.0',
    'schemas'
  )
)
meson.add_install_script('post_install.py')