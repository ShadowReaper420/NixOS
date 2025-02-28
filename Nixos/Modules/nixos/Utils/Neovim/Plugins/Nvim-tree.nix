{
    programs.nixvim = {
        keymaps = [ {
            action ="<cmd>NvimTreeOpen<CR>";
            key = "<Tab>";
            mode = "n";
         } 
        ];
        
        plugins.nvim-tree = {
            enable = true;
        };
    };
}