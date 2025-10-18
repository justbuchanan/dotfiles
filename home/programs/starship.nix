{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "$username$hostname$directory$nix_shell$git_branch$git_status$nodejs$lua$golang$rust$php$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      username = {
        show_always = false;
        format = "[$user]($style) ";
      };
      hostname = {
        ssh_only = true;
        format = "[@$hostname]($style) ";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
      };
      rust = {
        format = "[$symbol]($style)";
      };
      nix_shell = {
        format = "[$symbol]($style)";
      };
    };
  };
}
