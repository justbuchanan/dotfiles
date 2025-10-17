{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Justin Buchanan";
    userEmail = "justbuchanan@gmail.com";

    attributes = [
      "*.pdf diff=pdf"
    ];

    extraConfig = {
      push = {
        default = "simple";
      };

      # turn off noob warnings
      advice = {
        statusHints = false;
        detachedHead = false;
      };

      diff = {
        # smarter diffs
        indentHeuristic = true;
      };

      # TODO
      # "diff \"pdf\"" = {
      #   textconv = "pdfinfo";
      #   binary = false;
      # };

      core = {
        # Use a pager only if content is > 1 screenful
        # stackoverflow.com/questions/2183900
        pager = "less -F -X";
      };

      init = {
        defaultBranch = "main";
      };

      # TODO
      # "credential \"https://github.com\"" = {
      #   helper = "!/usr/bin/gh auth git-credential";
      # };
      # "credential \"https://gist.github.com\"" = {
      #   helper = "!/usr/bin/gh auth git-credential";
      # };
    };

    aliases = {
      edit-unmerged = "!$EDITOR `git diff --name-only --diff-filter=U`";
      rhead = "reset HEAD~1";
      co = "checkout";
      nuke = "!git add . && git reset --hard";
      preview-commit = "diff --cached";
      glog = "log --graph --abbrev-commit --decorate --date=relative --all --oneline";
    };
  };
}
