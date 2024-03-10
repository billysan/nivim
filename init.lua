
---
--- Global
---
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.confirm = true

local local_keymap_options = { noremap = true, silent = true }
local is_cheatsheet_open = false

function esc_keymap()

  if is_cheatsheet_open == true then
    close_cheatsheet()
    return
  end

  if string.find(vim.api.nvim_buf_get_name(0), "fugitiveblame") then
    vim.api.nvim_command("q")
    return
  end

  vim.api.nvim_exec('nohlsearch', true)
  end

vim.keymap.set('n', '<Esc>', esc_keymap, local_keymap_options)
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save buffer' })

--- ######################################################################
--- Lazy
--- ######################################################################
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{ 'nvim-telescope/telescope-ui-select.nvim' },
	{ 'romgrk/barbar.nvim' },
	{ 'Shatur/neovim-ayu' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'saadparwaiz1/cmp_luasnip' },
	{ "rafamadriz/friendly-snippets" },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-path' },
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
		    "nvim-lua/plenary.nvim",
		},
    	},
	{ 'voldikss/vim-floaterm' },
	{
		"crnvl96/lazydocker.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		}
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		}
	},
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
  { 'tpope/vim-fugitive' },
  {
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  };
}

local opts = {}
require("lazy").setup(plugins, opts)


---
--- ayu
---
require('ayu').setup({
  overrides = {
    Normal = { bg = "None" },
    ColorColumn = { bg = "None" },
    SignColumn = { bg = "None" },
    Folded = { bg = "None" },
    FoldColumn = { bg = "None" },
    CursorLine = { bg = "None" },
    CursorColumn = { bg = "None" },
    WhichKeyFloat = { bg = "None" },
    VertSplit = { bg = "None" },
    Comment = {
      fg = "#10FF00",
      italic = true,
    },
    Statement = {
      fg = "orange",
    },
    Exception = {
      fg = "orange"
    },
    Repeat = {
      fg = "orange"
    },
    Operator = {
      fg = "purple"
    },
  },
})
vim.cmd("colorscheme ayu-dark")


---
--- Telescope
---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
   }
  }
}
require("telescope").load_extension("ui-select")


---
--- nvim-tree
---
require("nvim-tree").setup({
  view = {
    width = "30%"
  }
})

function toggle_nvim_tree()

    local current_buffer_name = vim.api.nvim_buf_get_name(0)

    if string.find(current_buffer_name, "NvimTree") then
        vim.api.nvim_command("wincmd l")
    else
        vim.api.nvim_command("NvimTreeFocus")
    end
end


vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', local_keymap_options)
vim.keymap.set('n', '<leader>e', toggle_nvim_tree, local_keymap_options)
vim.keymap.set('n', '<leader>tk', ':NvimTreeCollapse<CR>', local_keymap_options)


---
-- Treesitter
--
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = { "python", "lua", 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'javascript', 'css' },
	highlight = { enable = true },
        indent = { enable = true },
})


---
--- lualine
---
require('lualine').setup()


--
-- Mason, mason-lspconfig, lspconfig
--
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright" }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

require("lspconfig").lua_ls.setup({ capabilities = capabilities })
require("lspconfig").pyright.setup({ capabilities = capabilities })
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', local_keymap_options)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', local_keymap_options)
vim.api.nvim_set_keymap('n', '<leader>lz', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', local_keymap_options)
vim.api.nvim_set_keymap('n', '<leader>la', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', local_keymap_options)
vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>ra', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {})
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>wl', function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, {})
vim.keymap.set('n', '<leader>f', ':!black %<CR>', local_keymap_options)


---
--- barbar
---
vim.g.barbar_auto_setup = false
require('barbar').setup({
  animation = false,
	sidebar_filetypes = {
        NvimTree = true,
	},
})

function confirm_buffer_changes()
  if vim.api.nvim_buf_get_option(0, 'modified') then
    local choice = vim.fn.input('Buffer has unsaved changes. Save changes [y/n/c]: ')
    if choice == 'y' then
      vim.cmd('w')
    elseif choice == 'c' then
      return
    end
  end
  vim.cmd('BufferClose!')
end

vim.keymap.set('n', '<leader>x', confirm_buffer_changes)
vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferNext<CR>', local_keymap_options)
vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferPrevious<CR>', local_keymap_options)


---
--- nvim-cmp
---
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'path' }
		},
		{
			{ name = 'buffer' },
		}
	)
  }
)


---
--- lazygit
---
require("lazy").setup({})
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', local_keymap_options)


---
--- floaterm
---
vim.keymap.set('n', '<A-i>', ':FloatermToggle<CR>', local_keymap_options)


---
--- lazydocker
---
require("lazydocker").setup({})
vim.keymap.set("n", "<leader>dk", "<cmd>LazyDocker<CR>", local_keymap_options)


---
--- noice, notify
---
require('notify').setup({
	background_colour = "#000000",
  render = "wrapped-compact",
  stages = "static",
  top_down = false,
})
require("noice").setup({
  views = {
    cmdline_popup = {
      position = {
        row = "40%",
        col = "50%",
      },
    },
    popupmenu = {
        relative = "editor",
        position = {
          row = '10%',
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    command_palette = true,
  },
})


---
--- todo-comments
---
require('todo-comments').setup({
  highlight = {
    pattern = [[.*<(KEYWORDS)\s*]]
  },
  search = {
    pattern = [[\b(KEYWORDS)]]
  },
})

---
--- fugitive
---
function toggle_git_blame()

    if string.find(vim.api.nvim_buf_get_name(0), "fugitiveblame") then
        vim.api.nvim_command("q")
    else
        vim.api.nvim_command("Git blame")
    end
end

vim.keymap.set('n', '<leader>gb', toggle_git_blame, local_keymap_options)


---
--- alpha.nvim
---
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀",
"⠀⢰⣿⣿⣿⣆⢀⣶⣶⣄⠀⢀⣤⡀⠀⠀⢀⣤⡀⠀⣠⣶⣶⡀⣰⣿⣿⣿⡆⠀",
"⠀⢸⣿⣿⣿⡟⠀⣿⣿⡿⠀⢸⣿⣿⠆⠰⣿⣿⡇⠀⢿⣿⣿⠀⢻⣿⣿⣿⡇⠀",
"⠀⢸⣿⣿⣿⡇⠀⠘⠛⠀⠀⠈⠿⠋⠀⠀⠙⠿⠁⠀⠀⠛⠃⠀⢸⣿⣿⣿⡇⠀",
"⠀⠘⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⠃⠀",
"⠀⠀⢻⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀ניבים⠀ ⠀⠀⠀⠀⠀⠀⣿⣿⡟⠀⠀",
"⠀⠀⠈⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀",
"⠀⠀⠀⠸⣿⡄⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⢠⣿⠇⠀⠀⠀",
"⠀⠀⠀⠀⢻⡇⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⢸⡟⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠃⠀⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡇⠀⠘⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡄⢀⣄⠀⠀⠀⠀⣠⡀⢠⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠘⠿⠟⠁⢸⣿⣇⠀⠀⣼⣿⣷⠈⠻⠿⠃⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
}

dashboard.section.buttons.val = {
    dashboard.button( "<ctrl>n", "🌿 > open tree" , toggle_nvim_tree),
    dashboard.button( "<space>fa", "🔎 > find file", builtin.find_files),
    dashboard.button( "r", "🗃️ > recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( '<space>t', '📜 > cheatsheet', show_cheatsheet),
    dashboard.button( "q", "❌ > quit nvim", ":qa<CR>"),
}


---
--- cheatsheet
---
local cheatsheet_window = nil

function show_cheatsheet()
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event

  cheatsheet_window = Popup({
    enter = false,
    focusable = false,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
  })

  -- mount/open the component
  cheatsheet_window:mount()
  is_cheatsheet_open = true

  -- unmount component when cursor leaves buffer
  cheatsheet_window:on(event.BufLeave, function()
    cheatsheet_window:unmount()
  end)
  local cheatsheet_path = vim.fn.stdpath('config') .. '/cheatsheet.md'
  local file_contents = vim.fn.readfile(cheatsheet_path)
  -- set content
  vim.api.nvim_buf_set_lines(cheatsheet_window.bufnr, 0, 1, false, file_contents)
  return cheatsheet_window
end

function close_cheatsheet()
  cheatsheet_window:unmount()
  is_cheatsheet_open = false
end

vim.keymap.set('n', '<leader>t', show_cheatsheet, {})

