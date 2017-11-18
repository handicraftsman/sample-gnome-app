add_global_arguments(
  ['-DGETTEXT_PACKAGE="' + conf.get('name') + '"'],
  language: 'c'
)

executable(
  conf.get('name').to_lower(), # Executable name
  [
    # Sources
    'Exitcodes.vala',
    'App.vala',
    'AppWindow.vala',
    'SettingsEngine.vala',

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
