{
    programs.nixvim = {
        plugins.nvim-tree = {
            enable = true;
            keymaps = {
                "tab" = "<cmd>NvimTreeOpen";
            };
        };
    };
}