'''
This file uses app_name option to compile app resources
'''
gresources = gnome.compile_resources(
  conf.get('name'),
  configure_file(
    input: 'gresource.in.xml',
    output: 'gresource.xml',
    configuration: conf
  ),
  source_dir: '.',
  c_name: conf.get('name')
)
