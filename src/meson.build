add_global_arguments(
  ['-DGETTEXT_PACKAGE="sample"'],
  language: 'c'
)

executable(
  'sample', # Executable name
  [
    # Sources.
    'Exitcodes.vala',
    'App.vala',
    'AppWindow.vala',

    # Configuration
    configure_file(
      input: 'config.in.vala',
      output: 'config.vala',
      configuration: conf
    ),

    # Resources
    gresources
  ],
  vala_args: ['--pkg', 'posix'], # Required for Posix namespace
  dependencies: global_dependencies + [
    # dependency('gtksourceview-3.0') # A sample local dependency
  ],

  install: true
)
