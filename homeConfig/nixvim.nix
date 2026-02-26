{ pkgs, lib, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.onedark.enable = true;
    plugins = {
      commentary.enable = true;
      lualine.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding = true;
        };
      };
      direnv.enable = true;
      zellij.enable = true;
      yazi.enable = true;
      nix.enable = true;
      lsp.enable = true;
      git-conflict.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            cpp = [ "clang-format" ];
            nix = [ "nixfmt" ];
            python = [ "ruff-format" ];
            bash = [
              "shellcheck"
              "shfmt"
            ];
            "*" = [ "keep-sorted" ];
          };
          format_on_save = "{ timeout_ms = 1000, lsp_fallback = true }";
          format_after_save = "{ lsp_fallback = true }";
          log_level = "trace";
          notify_no_formatters = true;
          notify_on_error = true;
          formatters = {
            shellcheck = {
              command = lib.getExe pkgs.shellcheck;
            };
            shfmt = {
              command = lib.getExe pkgs.shfmt;
            };
            nixfmt = {
              command = lib.getExe pkgs.nixfmt;
            };
            ruff-format = {
              command = "${pkgs.ruff}/bin/ruff-format";
            };
            keep-sorted = {
              command = lib.getExe pkgs.keep-sorted;
            };
            clang-format = {
              command = "${pkgs.clang-tools}/bin/clang-format";
            };
          };
        };
      };
    };
    lsp = {
      inlayHints.enable = true;
      servers = {
        nixd = {
          enable = true;
          package = pkgs.nixd;
          config = {
            cmd = [ "nixd" ];
            filetypes = [ "nix" ];
          };
        };
        svelte = {
          enable = true;
          package = pkgs.svelte-language-server;
          config = {
            cmd = [
              "svelteserver"
              "--stdio"
            ];
            filetypes = [ "svelte" ];
          };
        };
        cmake = {
          enable = true;
          package = pkgs.cmake-language-server;
          config = {
            cmd = [ "cmake-language-server" ];
            filetypes = [
              "cmake"
              "CMakeLists.txt"
            ];
          };
        };
        clangd = {
          enable = true;
          package = pkgs.clang-tools;
          config = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
          };
        };
      };
    };
  };
}
