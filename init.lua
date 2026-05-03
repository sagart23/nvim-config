-- =============================================================================
-- Optimized Neovim Configuration for LaTeX & Manim
-- SAFE optimizations: Lazy-loading without breaking functionality
-- =============================================================================

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- OPTIMIZATION 1: Disable unused providers (SAFE - saves ~30-50ms)
-- =============================================================================
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
-- vim.g.python3_host_prog = "C:/Users/Sagar/scoop/apps/python/current/python.exe"
-- Note: Python provider needed for UltiSnips, loaded on-demand below

-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Options
-- =============================================================================
local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
--opt.conceallevel = 2  -- you set this via vim.o, move it here for consistency

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false
opt.spelllang = "en_us"

-- System
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.backup = false
opt.swapfile = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- LaTeX
vim.g.tex_flavor = "latex"

-- =============================================================================
-- Keymaps
-- =============================================================================
local map = vim.keymap.set

-- Escape
map("i", "jk", "<Esc>")

-- Save/Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Buffers
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search
map("n", "<Esc>", ":nohlsearch<CR>")

-- Center jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- File Explorer Keybindings
map("n", "<leader>e", "<cmd>Neotree reveal left<CR>", { desc = "Reveal in Explorer" })
map("n", "<C-n>", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Explorer" })

-- Quick Project Navigation
map("n", "<leader>ps", "<cmd>Neotree D:/Latex_work/projects/School<CR>", { desc = "School Projects" })
map("n", "<leader>pp", "<cmd>Neotree D:/Latex_work/projects/Personal<CR>", { desc = "Personal Projects" })
-- Quickfix navigation (ADD THIS)
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open Quickfix" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close Quickfix" })
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous Error" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next Error" })
-- =============================================================================
-- Autocmds
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- LaTeX settings
autocmd("FileType", {
    group = augroup("LaTeX", { clear = true }),
    pattern = "tex",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- FIX 2: Auto-indent LaTeX on save
--autocmd("BufWritePre", {
  --  pattern = "*.tex",
    --callback = function()
        -- Save cursor position
      --  local cursor_pos = vim.api.nvim_win_get_cursor(0)
        
        -- Format entire buffer
        --vim.cmd("silent! normal! gg=G")
        
        -- Restore cursor position
        --pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
   -- end,
--})

-- ============================================================================
-- AUTO-SAVE: Save LaTeX files every 60 seconds when editing
-- ============================================================================
local autosave_group = augroup("AutoSaveLaTeX", { clear = true })

-- Track if user is typing
local typing_timer = nil

autocmd({ "TextChanged", "TextChangedI" }, {
    group = autosave_group,
    pattern = "*.tex",
    callback = function()
        -- Clear existing timer
        if typing_timer then
            vim.fn.timer_stop(typing_timer)
        end
        
        -- Set new timer for 90 seconds (90000 ms)
        typing_timer = vim.fn.timer_start(90000, function()
            -- Only save if buffer is modified and not in insert mode
            if vim.bo.modified and vim.fn.mode() ~= 'i' then
                vim.cmd("silent! write")
                print("Auto-saved at " .. os.date("%H:%M:%S"))
            end
        end)
    end,
})

-- Also auto-save when leaving insert mode after 60 seconds of inactivity
autocmd("CursorHold", {
    group = autosave_group,
    pattern = "*.tex",
    callback = function()
        if vim.bo.modified then
            vim.cmd("silent! write")
            print("Auto-saved at " .. os.date("%H:%M:%S"))
        end
    end,
})

-- Python settings
autocmd("FileType", {
    group = augroup("Python", { clear = true }),
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

-- Highlight yank
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- =============================================================================
-- Plugins (OPTIMIZED with lazy-loading)
-- =============================================================================
require("lazy").setup({
    -- Colorscheme (must load immediately)
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "soft",
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
            vim.opt.background = "dark"
            vim.opt.termguicolors = true
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    -- OPTIMIZATION 2: Neo-tree loads on command/keypress only
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree reveal left<cr>", desc = "Reveal in Explorer" },
            { "<C-n>", "<cmd>Neotree toggle left<cr>", desc = "Toggle Explorer" },
        },
        opts = {
            close_if_last_window = true,
            window = { position = "left", width = 35 },
            filesystem = {
                filtered_items = {
                    hide_by_pattern = { "*.aux", "*.log", "*.fls", "*.synctex.gz", "*.out" },
                },
                follow_current_file = { enabled = true },
            },
        },
    },
-- FIX 1: Auto-pairs plugin for bracket closing
{
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true,  -- Use treesitter
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
                java = false,
            },
            disable_filetype = { "TelescopePrompt", "vim" },
            fast_wrap = {
                map = '<M-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                end_key = '$',
                before_key = 'h',
                after_key = 'l',
                cursor_pos_before = true,
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                manual_position = true,
                highlight = 'Search',
                highlight_grey = 'Comment'
            },
        })
        
        -- Integrate with nvim-cmp
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
},

    -- Telescope (already lazy-loaded)
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- OPTIMIZATION 3: Treesitter loads on events
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
    		require("nvim-treesitter").setup({
        		ensure_installed = { "latex", "python", "lua", "markdown" },
        		highlight = { enable = true },
    		})
	end,
    },

    -- OPTIMIZATION 4: Which-Key loads after first keypress
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({})
            
            wk.add({
                { "<leader>l", group = "LaTeX" },
                { "<leader>m", group = "Manim" },
                { "<leader>t", group = "Templates" },
                { "<leader>p", group = "Projects" },
				 { "<leader>c", group = "Quickfix" },
            })
            
            local templates_dir = vim.fn.stdpath("config") .. "/templates"
            
            if vim.fn.isdirectory(templates_dir) == 1 then
                map("n", "<leader>tq", function()
                    vim.cmd("read " .. templates_dir .. "/article.tex")
                end, { desc = "Simple Doc" })
                
                map("n", "<leader>tt", function()
                    vim.cmd("read " .. templates_dir .. "/12M_80.tex")
                end, { desc = "12 ISC Math" })
                
                map("n", "<leader>ti", function()
                    vim.cmd("read " .. templates_dir .. "/10M_80.tex")
                end, { desc = "10 ICSE Math" })
                
                map("n", "<leader>ta", function()
                    vim.cmd("read " .. templates_dir .. "/test.tex")
                end, { desc = "Class Test" })
                
                map("n", "<leader>tn", function()
                    vim.cmd("read " .. templates_dir .. "/notes.tex")
                end, { desc = "Chapter Notes" })
                
                map("n", "<leader>tk", function()
                    vim.cmd("read " .. templates_dir .. "/tikz_standalone.tex")
                end, { desc = "TikZ Template" })
                
                map("n", "<leader>tf", "<cmd>Telescope find_files cwd=" .. templates_dir .. "<CR>", { desc = "Browse Templates" })
            end
        end,
    },

   -- VimTeX (must load immediately for LaTeX files)
{
    "lervag/vimtex",
    lazy = false,
    init = function()
        -- ===================================================================
        -- PDF VIEWER: Use Windows default PDF viewer
        -- ===================================================================
        vim.g.vimtex_view_method = 'general'
        --vim.g.vimtex_view_general_viewer = 'cmd'
        --vim.g.vimtex_view_general_options = '/c start "" "@pdf"'

        -- Alternative: SumatraPDF with forward search
        vim.g.vimtex_view_general_viewer = 'SumatraPDF'
        vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'

        vim.g.vimtex_view_enabled = 1
        vim.g.vimtex_view_automatic = 1
        vim.g.vimtex_syntax_enabled = 0

        -- ===================================================================
        -- COMPILER: pdflatex by default, override per-file with magic comment
        -- Add  % !TeX program: lualatex  at top of file to use LuaLaTeX
        -- ===================================================================
        vim.g.vimtex_compiler_method = 'latexmk'

        vim.g.vimtex_compiler_latexmk_engines = {
            _        = '-pdf',        -- default: pdflatex
            pdflatex = '-pdf',
            lualatex = '-lualatex',
            xelatex  = '-xelatex',
        }

        vim.g.vimtex_compiler_latexmk_magic_comments = 1

        vim.g.vimtex_compiler_latexmk = {
            build_dir  = '',
            callback   = 1,
            continuous = 1,
            executable = 'latexmk',
            options = {
                -- NOTE: no '-pdf' here; engine is controlled by the table above
                '-shell-escape',
                '-verbose',
                '-file-line-error',
                '-synctex=1',
                '-interaction=nonstopmode',
            },
        }

        -- ===================================================================
        -- QUICKFIX
        -- ===================================================================
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
        vim.g.vimtex_quickfix_ignore_filters = {
            'Underfull',
            'Overfull',
            'specifier changed to',
        }

        -- ===================================================================
        -- MISC
        -- ===================================================================
        vim.g.vimtex_mappings_enabled = false
        vim.g.tex_flavor  = 'latex'
        vim.g.tex_conceal = 'abdmg'
        --vim.o.conceallevel = 2

        -- ===================================================================
        -- KEYMAPS
        -- ===================================================================
        vim.keymap.set('n', '<leader>b',  '<Plug>(vimtex-compile)',        { desc = 'Compile LaTeX' })
        vim.keymap.set('n', '<leader>v',  '<Plug>(vimtex-view)',           { desc = 'View PDF' })
        vim.keymap.set('n', '<leader>lc', '<Plug>(vimtex-clean)',          { desc = 'Clean aux files' })
        vim.keymap.set('n', '<leader>lo', '<Plug>(vimtex-compile-output)', { desc = 'Compiler output' })
        vim.keymap.set('n', '<leader>lt', '<Plug>(vimtex-toc-toggle)',     { desc = 'Toggle TOC' })
        vim.keymap.set('n', '<leader>le', '<Plug>(vimtex-env)',            { desc = 'Environment' })
        vim.keymap.set('n', '<F5>',       '<Plug>(vimtex-compile)',        { desc = 'Compile' })
        vim.keymap.set('n', '<F6>',       '<Plug>(vimtex-view)',           { desc = 'View PDF' })

        vim.keymap.set('n', '<leader>ll', function()
            local log_file = vim.fn.expand('%:r') .. '.log'
            if vim.fn.filereadable(log_file) == 1 then
                vim.cmd('vsplit ' .. log_file)
            else
                print("No log file found: " .. log_file)
            end
        end, { desc = 'Open log file' })
    end,
},
   

    -- OPTIMIZATION 6: LuaSnip loads on insert mode (faster than UltiSnips)
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local ls = require("luasnip")
            
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({ include = { "tex" } })
            
            require("luasnip.loaders.from_lua").lazy_load({
    		paths = { vim.fn.stdpath("config") .. "/lua/luasnip" },
	    })
            
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            map({"i", "s"}, "<C-l>", function()
                if ls.expand_or_jumpable() then ls.expand_or_jump() end
            end, { desc = "LuaSnip expand/jump" })
            
            map({"i", "s"}, "<C-h>", function()
                if ls.jumpable(-1) then ls.jump(-1) end
            end, { desc = "LuaSnip jump back" })
	   map({"i", "s"}, "<C-n>", function()
    		if require("luasnip").choice_active() then
        		require("luasnip").change_choice(1)
    		end
	   end, { desc = "Next choice" })

	  map({"i", "s"}, "<C-p>", function()
    		if require("luasnip").choice_active() then
        		require("luasnip").change_choice(-1)
    		end
	  end, { desc = "Previous choice" })
        end,
    },

    -- OPTIMIZATION 7: CMP loads on insert mode
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = {
                    { name = "luasnip", priority = 900 },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },

    -- OPTIMIZATION 8: Mason loads on demand
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = function()
            require("mason").setup({ ui = { border = "rounded" } })
        end,
    },
    
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright" },
            })
        end,
    },
    
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })
            
            vim.lsp.config("pyright", {
                capabilities = capabilities,
            })
            
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")
            
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    map("n", "gd", vim.lsp.buf.definition, opts)
                    map("n", "K", vim.lsp.buf.hover, opts)
                    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
                end,
            })
        end,
    },
}, {
    ui = { border = "rounded" },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})


-- =============================================================================
-- Manim commands for Python files
-- =============================================================================
autocmd("FileType", {
    pattern = "python",
    callback = function()
        local opts = { buffer = true }
        
        map("n", "<leader>mp", function()
            local file = vim.fn.expand("%:p")
            vim.cmd("split | terminal manim -pql " .. file)
        end, vim.tbl_extend("force", opts, { desc = "Manim preview" }))
        
        map("n", "<leader>mh", function()
            local file = vim.fn.expand("%:p")
            vim.cmd("split | terminal manim -pqh " .. file)
        end, vim.tbl_extend("force", opts, { desc = "Manim HQ" }))
        
        map("n", "<F5>", function()
            local file = vim.fn.expand("%:p")
            vim.cmd("split | terminal python " .. file)
        end, vim.tbl_extend("force", opts, { desc = "Run Python" }))
    end,
})

print("🚀 Neovim loaded successfully!")
