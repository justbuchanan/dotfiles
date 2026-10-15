{ ... }:
{
  # Shadow the google-chrome package's google-chrome.desktop (same desktop file
  # ID, and ~/.nix-profile/share precedes /run/current-system/sw/share in
  # XDG_DATA_DIRS), so fuzzel and default-browser links both use this one.
  #
  # With more than one Chrome profile, a bare `google-chrome-stable` shows the
  # profile picker, and picking a profile that already has a window focuses that
  # window -- which in niri means jumping to whatever workspace it's on. Naming
  # the profile skips the picker; Chrome then opens a new window on the current
  # workspace (switch profiles from within Chrome when needed).
  xdg.desktopEntries.google-chrome =
    let
      chrome = "google-chrome-stable --profile-directory=Default";
    in
    {
      name = "Google Chrome";
      genericName = "Web Browser";
      comment = "Access the Internet";
      exec = "${chrome} %U";
      icon = "google-chrome";
      terminal = false;
      startupNotify = true;
      categories = [
        "Network"
        "WebBrowser"
      ];
      # Same as the package's entry, so it stays a valid default browser.
      mimeType = [
        "application/pdf"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/google-chrome"
      ];
      settings.StartupWMClass = "google-chrome";
      actions = {
        new-window = {
          name = "New Window";
          exec = "${chrome} --new-window";
        };
        new-private-window = {
          name = "New Incognito Window";
          exec = "${chrome} --incognito";
        };
      };
    };
}
