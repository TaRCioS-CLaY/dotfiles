(local plugins_fennel
       [{1 :kyazdani42/nvim-tree.lua
         :enabled true
         :dependencies [:nvim-tree/nvim-web-devicons]
         :opts {:git {:ignore false}}
         :keys [[:<F3> :<cmd>NvimTreeToggle<CR>]
                [:<F4> :<cmd>NvimTreeFindFile<CR>]]}])

plugins_fennel
