{ ... }:
{
  # Claude Code sessions run inside the app's scope, so by default an OOM kill of
  # any command they start makes systemd stop the whole app. Kill only the
  # offender, and cap the scope so a runaway can't starve the rest of the machine.
  systemd.user.units."app-com.anthropic.Claude-.scope" = {
    overrideStrategy = "asDropin";
    text = ''
      [Scope]
      OOMPolicy=continue
      MemoryMax=64G
    '';
  };
}
