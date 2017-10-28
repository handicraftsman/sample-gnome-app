class AppWindow : Gtk.ApplicationWindow {
  /*
   * Instance variables
   */
  public App app;
  private Gtk.HeaderBar gui_hb;

  /*
   * Setup methods
   */

  // Constructor
  public AppWindow(App _app) {
    Object(application: _app);
    this.app = _app;

    this.window_position = Gtk.WindowPosition.CENTER;
    this.default_width = 640;
    this.default_height = 480;

    this.gui_hb = new Gtk.HeaderBar();
    this.set_titlebar(gui_hb);

    this.title = dgettext(null, Config.full_name);
    this.gui_hb.title = dgettext(null, Config.full_name);
    this.gui_hb.subtitle = @"v$(Config.version)";
    this.gui_hb.show_close_button = true;

    //try {
    //  string dat = (string) GLib.resources_lookup_data(Config.path + "hello.txt", 0).get_data();
    //  this.add(new Gtk.Label(dat));
    //} catch (GLib.Error e) {
    //  print(@"Error: $(e.message)\n");
    //  Posix.exit(Exitcodes.RESOURCE_ERROR);
    //}
    this.add(new Gtk.Builder.from_resource(Config.path+"gtk/App.ui").get_object("boxWin") as Gtk.Box);
    //this.add(new Gtk.Label(dgettext(null, "hello-world")));

  }
}
