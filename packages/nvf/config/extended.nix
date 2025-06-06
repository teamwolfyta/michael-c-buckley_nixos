_: {
  vim = {
    languages = import ./languages;
    keymaps = import ./keymaps/extended.nix;

    autocomplete.blink-cmp.enable = true;
    tabline.nvimBufferline.enable = true;

    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };

    filetree.neo-tree.enable = true;

    ui = {
      noice.enable = true;
      breadcrumbs = {
        enable = true;
        lualine.winbar.enable = true;
        navbuddy.enable = true;
      };
    };

    runner.run-nvim = {
      enable = true;
    };

    visuals = {
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
      indent-blankline.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
