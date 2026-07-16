# Local build of https://github.com/nomisreual/mediaplayer.
#
# Upstream's default.nix builds with python313Packages but pulls pygobject3
# from python3Packages, which now defaults to Python 3.14 in nixpkgs-unstable.
# That version mismatch breaks evaluation, so we vendor the derivation here and
# take pygobject3 from the same python313Packages set. Source is the flake input
# so it stays pinned/updated via flake.lock.
{
  python313Packages,
  gobject-introspection,
  playerctl,
  glib,
  wrapGAppsHook3,
  src,
}:
python313Packages.buildPythonApplication {
  pname = "mediaplayer";
  version = "0.1.0";

  pyproject = true;
  build-system = [ python313Packages.setuptools ];

  propagatedBuildInputs = with python313Packages; [
    pygobject3
  ];

  buildInputs = [
    gobject-introspection # Needed for GObject Introspection
    playerctl # Adds the Playerctl typelib
    glib # GNOME/GLib dependencies
    wrapGAppsHook3 # Automatically wraps and sets GNOME-related env vars
  ];

  inherit src;

  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GI_TYPELIB_PATH : "${playerctl}/lib/girepository-1.0"
    )

    # Pass the gappsWrapperArgs to makeWrapperArgs
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
}
