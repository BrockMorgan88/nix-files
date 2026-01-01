{pkgs, ... }:
{
  programs.vscode = let 
    pythonexts = with pkgs.vscode-extensions.ms-python; [
      vscode-pylance
      python
      debugpy
    ];
    msexts = with pkgs.vscode-extensions.ms-vscode; [
      cpptools
      cmake-tools
      makefile-tools
    ];
    codeexts = with pkgs.vscode-extensions; [
      mkhl.direnv
      bbenoist.nix
      platformio.platformio-vscode-ide
      christian-kohler.path-intellisense
      vscode-icons-team.vscode-icons
    ];
    better-cpp-syntax = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "better-cpp-syntax";
        publisher = "jeff-hykin";
        version = "1.27.1";
        hash = "sha256-GO/ooq50KLFsiEuimqTbD/mauQYcD/p2keHYo/6L9gw=";
      };
    };
    doxdocgen = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "doxdocgen";
        publisher = "cschlosser";
        version = "1.4.0";
        hash = "sha256-InEfF1X7AgtsV47h8WWq5DZh6k/wxYhl2r/pLZz9JbU=";
      };
    };
    msg = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "msg";
        publisher = "ajshort";
        version = "0.1.1";
        hash = "sha256-aL2znsL/iANHn/xCzAgjsysRTL3k1KxaBtmW/zGCYEI=";
      };
    };
    treefmt = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "treefmt-vscode";
        publisher = "ibecker";
        version = "2.2.1";
        hash = "sha256-3kyEznwTWqdHdCWtoChGBCwRL7tMjtdLI+SQ7TqJh9I=";
      };
    };
    svelte = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "svelte-vscode";
        publisher = "svelte";
        version = "109.12.0";
        hash = "sha256-pPzpP7xYZ2cxj1euA3jj6d0g0c+tK+1is+o4zeMdT/Q=";
      };
    };
    python-environments = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-python-envs";
        publisher = "ms-python";
        version = "1.12.0";
        hash = "sha256-8dCnGBuxv+8QwP0FrUZIKFxllVOR2z+wIhyyJgxsRns=";
      };
    };
    ros2 = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-ros2";
        publisher = "jaehyunshim";
        version = "0.0.9";
        hash = "sha256-g0r/IuvAPVYEODAIVql0u2k3uyuK4dYC/tnFgyl4WQQ=";
      };
    };
    python-environment-mgr = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "python-environment-manager";
        publisher = "donjayamanne";
        version = "1.2.7";
        hash = "sha256-w3csu6rJm/Z6invC/TR7tx6Aq5DD77VM62nem8/QMlg=";
      };
    };
    git-patch = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "gitpatch";
        publisher = "paragdiwan";
        version = "0.2.1";
        hash = "sha256-jpdRmTUfwbyJI8ruqHQEcSFwht7HSPrI9r+ZAaNf5Q4=";
      };
    };
    xkb-symbols = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "xkb";
        publisher = "compilouit";
        version = "0.1.2";
        hash = "sha256-k8EmkiebEKB8hDaJqT3KVXy1d9Cc5aUDL9gP1mOBN88=";
      };
    };
    
    otherexts = [
      better-cpp-syntax
      doxdocgen
      msg
      treefmt
      svelte
      python-environments
      ros2
      python-environment-mgr
      git-patch
      xkb-symbols
    ];
  in {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ platformio-core avrdude ]);
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pythonexts ++ msexts ++ codeexts ++ otherexts;
      userSettings = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "clang-format";
        "[cpp]" = {
          "editor.defaultFormatter" = "ms-vscode.cpptools";
        };
        "C_Cpp.clang_format_style" = "{BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, ColumnLimit: 0, AccessModifierOffset: -4, NamespaceIndentation: All, FixNamespaceComments: false, AlignConsecutiveMacros: true,}";
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "workbench.iconTheme" = "vscode-icons";
        "svelte.enable-ts-plugin" = true;
        "editor.fontFamily" = "'Iosevka Nerd Font', 'Regular'";
        "editor.fontSize" = 14;
      };
    };
  };
}