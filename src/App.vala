class App : Gtk.Application {

  /*
   * Static variables
   */
  public static App app;

  /*
   * Instance variables
   */
  private Settings settings;
  public AppWindow win;
  public bool preferences_win_shown = false;
  SimpleAction av_quit;
  SimpleAction av_preferences;
  SimpleAction av_about;
  SimpleAction av_notify;

  /*
   * Setup methods
   */

  // Constructor
  public App() {
    // Docs:
    // https://valadoc.org/gio-2.0/GLib.Application.html
    // https://valadoc.org/gtk+-3.0/Gtk.Application.html

    // `Config` object is generated in /src/meson.build
    Object(application_id: Config.id, flags: 0);

    // Add options
    this.add_main_option("version", 'V', 0, OptionArg.NONE, "Display version number", null);
    this.add_main_option("int-demo", '1', 0, OptionArg.INT, "Integer demo", "INT32");
    this.add_main_option("int64-demo", '2', 0, OptionArg.INT64, "Integer (64-bit) demo", "INT64");
    this.add_main_option("bool-demo", '3', 0, OptionArg.NONE, "Boolean demo", "BOOL");
    this.add_main_option("string-demo", '4', 0, OptionArg.STRING, "String demo", "STRING");
  }

  // Option checker
  public override int handle_local_options(VariantDict opts) {
    // Use this.hold() and this.release() to prevent your app from quitting
    // while processing a request. You need to release the app before returning
    // from a function though.
    this.hold();

    // Use `opts.lookup_value(string opt_name, VariantType type)` to check
    // options. This function returns null (!) if option is not set.
    // If returned value is not null, you can get the option value
    // using `Variant.get_type()`, where `type` - requested variable type.

    // Docs:
    // https://valadoc.org/glib-2.0/GLib.OptionArg.html
    // https://valadoc.org/glib-2.0/GLib.Variant.html
    // https://valadoc.org/glib-2.0/GLib.VariantType.html
    // https://valadoc.org/glib-2.0/GLib.VariantDict.html

    // Prints version and quits if requested
    if (opts.lookup_value("version", VariantType.BOOLEAN) != null) {
      print(@"$(Config.version)\n");
      this.release();
      return Exitcodes.COMMAND_LINE_ERROR;
    }

    // Integer demo.
    Variant opt_int_demo = opts.lookup_value("int-demo", VariantType.INT32);
    if (opt_int_demo != null) {
      int32 val = opt_int_demo.get_int32();
      print(@"Integer demo: $val\n");
    }

    // Integer (64-bit) demo.
    Variant opt_int64_demo = opts.lookup_value("int64-demo", VariantType.INT64);
    if (opt_int64_demo != null) {
      int64 val = opt_int64_demo.get_int64();
      print(@"Integer demo: $val\n");
    }

    // Boolean demo. You do not need to check boolean value - it can only be true or null
    Variant opt_bool_demo = opts.lookup_value("bool-demo", VariantType.BOOLEAN);
    if (opt_bool_demo != null) {
      print(@"Bool demo\n");
    }

    // String demo
    Variant opt_string_demo = opts.lookup_value("string-demo", VariantType.STRING);
    if (opt_string_demo != null) {
      string val = opt_string_demo.get_string();
      print(@"String demo: $val\n");
    }

    this.release();
    // By returning -1 you indicate that application should not exit with returned code/
    // `activate()` signal is emitted after returning from this method.
    return -1;
  }

  // Activate method
  public override void activate() {
    this.hold();

    // Create the settings
    this.settings = new Settings(Config.id);
    this.dark_theme = this.dark_theme;

    // Create the main window
    this.win = new AppWindow(this);
    this.win.show_all();

    // Register the `quit` action
    av_quit = new SimpleAction("quit", null);
    av_quit.activate.connect(am_quit);
    this.add_action(av_quit);

    // Register the 'preferences' action
    av_preferences = new SimpleAction("preferences", null);
    av_preferences.activate.connect(am_preferences);
    this.add_action(av_preferences);

    // Register the `about` action
    av_about = new SimpleAction("about", null);
    av_about.activate.connect(am_about);
    this.add_action(av_about);

    // Register the `notify` action
    av_notify = new SimpleAction("notify", null);
    av_notify.activate.connect(am_notify);
    this.add_action(av_notify);

    this.release();
  }

  // Main function
  public static int main(string[] args) {
    Notify.init(Config.full_name);
    Intl.bindtextdomain(Config.name, "/usr/local/share/locale/");
    Intl.bind_textdomain_codeset(Config.name, "UTF-8");
    Intl.textdomain(Config.name);
    Intl.setlocale(LocaleCategory.ALL, "");
	  Environment.set_prgname(Config.name);
    Environment.set_application_name(Config.name);
    app = new App();
    return app.run(args);
  }

  /*
   * Action methods
   */

  // Quits the app
  private void am_quit() {
    this.hold();
    this.quit();
    this.release();
  }

  // Shows the preferences window
  private void am_preferences() {
    this.hold();
    if (!preferences_win_shown) {
      Gtk.Window preferences_win;
      var builder = new Gtk.Builder.from_resource(Config.path+"gtk/App.ui");

      preferences_win = builder.get_object("winPreferences") as Gtk.Dialog;
      preferences_win.destroy.connect(() => {preferences_win_shown = false;});
      preferences_win.application = this;
      preferences_win.modal = true;
      preferences_win.attached_to = this.win;
      preferences_win.transient_for = this.win;
      preferences_win_shown = true;

      var switch_dark_theme = builder.get_object("switchDarkTheme") as Gtk.Switch;
      switch_dark_theme.set_state(this.dark_theme);
      switch_dark_theme.state_set.connect((val) => { return this.conf_set_dark_theme(val); });
      preferences_win.show_all();
    }
    this.release();
  }

  // Shows the about dialog
  private void am_about() {
    this.hold();
    string[] authors = {
      "Nickolay Ilyushin <nickolay02@inbox.ru>"
    };
    Gtk.show_about_dialog(
      win,
      program_name: dgettext(null, Config.full_name),
      license_type: Gtk.License.MIT_X11,
      authors: authors
    );
    this.release();
  }

  // Sends a simple notification using libnotify
  private void am_notify() {
    this.hold();
    try {
      Notify.Notification notification = new Notify.Notification(
        dgettext(null, "Short summary"),
        dgettext(null, "A long description"),
        "dialog-information"
      );
      notification.show();
    } catch (Error e) {
      print(@"Error: $(e.message)\n");
    }
    this.release();
  }

  /*
   * Configuration methods
   */

  private bool conf_set_dark_theme(bool val) {
    this.hold();
    this.dark_theme = val;
    this.release();
    return val;
  }

  /*
   * Utilities
   */

  public bool dark_theme {
    get {
      return this.settings.get_boolean("prefers-dark-theme");
    }
    set {
      this.settings.set_boolean("prefers-dark-theme", value);
      Gtk.Settings.get_default().gtk_application_prefer_dark_theme = value;
    }
  }

}
