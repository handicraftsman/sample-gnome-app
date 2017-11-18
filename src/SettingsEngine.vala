class SettingsEngine {
  private static Settings settings;

  public static void init() {
    settings = new Settings(Config.id);
    dark_theme = dark_theme;
  }

  public static bool dark_theme {
    get {
      return settings.get_boolean("prefers-dark-theme");
    }
    set {
      settings.set_boolean("prefers-dark-theme", value);
      Gtk.Settings.get_default().gtk_application_prefer_dark_theme = value;
    }
  }
}