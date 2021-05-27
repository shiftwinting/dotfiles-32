vim.cmd("packadd packer.nvim")
return require("packer").startup(function()
    use {"wbthomason/packer.nvim", opt = true}

    local config = function(name) require("plugins." .. name) end
    local use_with_config = function(path, name)
        use {path, config = config(name)}
    end

    -- basic
    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"
    use "tpope/vim-commentary"
    use_with_config("lewis6991/gitsigns.nvim", "gitsigns")

    -- additional functionality
    use "wellle/targets.vim"
    use_with_config("justinmk/vim-sneak/", "sneak")
    use_with_config("windwp/nvim-autopairs", "autopairs")
    use_with_config("svermeulen/vim-subversive", "subversive")
    use_with_config("svermeulen/vim-cutlass", "cutlass")
    use_with_config("SirVer/ultisnips", "ultisnips")
    use {
        "nvim-telescope/telescope.nvim",
        requires = {"nvim-lua/popup.nvim"},
        config = config("telescope")
    }
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

    -- integrations
    use_with_config("numToStr/Navigator.nvim", "navigator")
    use_with_config("mcchrish/nnn.vim", "nnn")

    -- development
    use "neovim/nvim-lspconfig"
    use "nvim-lua/plenary.nvim"
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = config("treesitter")
    }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use "windwp/nvim-ts-autotag"
    use_with_config("vim-test/vim-test", "vim-test")

    -- visual
    use "sainnhe/sonokai"
    use "kyazdani42/nvim-web-devicons"

    -- local
    use_with_config("~/git/buftabline.nvim", "buftabline")
    use "~/git/nvim-lsp-ts-utils"
    use "~/git/null-ls"

    -- misc
    use "blankname/vim-fish"
    use {
        "iamcco/markdown-preview.nvim",
        ft = {"markdown"},
        config = "vim.cmd[[doautocmd BufEnter]]",
        run = "cd app && yarn install",
        cmd = "MarkdownPreview"
    }
end)
