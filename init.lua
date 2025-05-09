---
--- Global
---
-- Set the mapleader and maplocalleader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font support
vim.g.have_nerd_font = true
vim.opt.termguicolors = true

-- NvimTree asked for this
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set various options using vim.opt
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.confirm = true

local local_keymap_options = { noremap = true, silent = true }
local is_cheatsheet_open = false

function move_right_if_in_tree()
	-- Check if the current buffer name contains "NvimTree"
	if string.find(vim.api.nvim_buf_get_name(0), "NvimTree") then
		-- If "NvimTree" is in the buffer name, move focus to the right window
		vim.api.nvim_command("wincmd l")
	end
end

-- Define the function to handle ESC key mapping
function esc_keymap()
	-- Check if cheatsheet is open, if so close it
	if is_cheatsheet_open == true then
		close_cheatsheet()
		return
	end

	-- Check if the current buffer is a fugitiveblame buffer, if so close it with :q
	if string.find(vim.api.nvim_buf_get_name(0), "fugitiveblame") then
		vim.api.nvim_command("q")
		return
	end

	-- Clear the search highlight
	vim.api.nvim_exec("nohlsearch", true)
end

-- Set key mappings for saving the buffer in normal mode and insert mode
vim.keymap.set("n", "<Esc>", esc_keymap, local_keymap_options)
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>a", { desc = "Save buffer" })

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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
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
		build = ":TSUpdate",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "romgrk/barbar.nvim" },
	{ "Shatur/neovim-ayu" },
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
	{ "voldikss/vim-floaterm" },
	{
		"crnvl96/lazydocker.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "tpope/vim-fugitive" },
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}

local opts = {}
require("lazy").setup(plugins, opts)


---
--- lsp
---
vim.lsp.config.basedpyright = {
  name = "basedpyright",
  filetypes = { "python" },
  cmd = { "basedpyright-langserver", "--stdio" },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = true,
        },
      },
    },
  },
}
vim.lsp.enable({'basedpyright'})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.cmd("set completeopt+=noselect")
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_set_keymap("n", "gd", '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', local_keymap_options)
vim.api.nvim_set_keymap("n", "gr", '<cmd>lua require("telescope.builtin").lsp_references()<CR>', local_keymap_options)
vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, {})
vim.o.winborder = 'rounded'


---
--- ayu
---
require("ayu").setup({
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
			fg = "orange",
		},
		Repeat = {
			fg = "orange",
		},
		Operator = {
			fg = "purple",
		},
	},
})
vim.cmd("colorscheme ayu-dark")


---
--- Telescope
---
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fa", builtin.find_files, {})
vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, {})
require("telescope").setup({
    defaults = {
        path_display = { truncate = 1 },
    },
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", {})


---
--- nvim-tree
---
require("nvim-tree").setup({
	view = {
		width = "30%",
	},
	update_focused_file = {
		enable = true,
	},
})
-- Define a function named toggle_nvim_tree
function toggle_nvim_tree()
	-- Get the name of the current buffer
	local current_buffer_name = vim.api.nvim_buf_get_name(0)

	-- Check if the current buffer name contains "NvimTree"
	if string.find(current_buffer_name, "NvimTree") then
		-- If "NvimTree" is in the buffer name, move focus to the right window
		vim.api.nvim_command("wincmd l")
	else
		-- If "NvimTree" is not in the buffer name, focus on the NvimTree window
		vim.api.nvim_command("NvimTreeFocus")
	end
end
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", local_keymap_options)
vim.keymap.set("n", "<leader>e", toggle_nvim_tree, local_keymap_options)
vim.keymap.set("n", "<leader>tk", ":NvimTreeCollapse<CR>", local_keymap_options)


---
-- Treesitter
--
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = { "python", "lua", "bash", "c", "html", "lua", "markdown", "vim", "vimdoc", "javascript", "css" },
	highlight = { enable = true },
	indent = { enable = true },
})


---
--- lualine
---
require("lualine").setup({
	extensions = {'nvim-tree'},
})


---
--- barbar
---
vim.g.barbar_auto_setup = false
require("barbar").setup({
	animation = false,
	sidebar_filetypes = {
		NvimTree = true,
	},
})

-- Function to confirm and handle buffer changes before closing the buffer.
local function confirm_buffer_changes()
	-- Check if the current buffer has been modified
	if vim.api.nvim_buf_get_option(0, "modified") then
		-- Define the options for the user prompt
		local options = { "&Yes", "&No", "&Cancel" }
		local message = "Save file?"
		-- Show a confirmation dialog to the user
		local choice = vim.fn.confirm(message, table.concat(options, "\n"), 0)

		-- Handle user choice
		if choice == 1 then
			vim.cmd("w") -- Save the buffer
		elseif choice == 3 then
			return -- Cancel buffer closing
		end
	end
	vim.cmd("BufferClose!") -- Close the buffer
end

vim.keymap.set("n", "<leader>x", confirm_buffer_changes)
vim.api.nvim_set_keymap("n", "<C-Right>", ":BufferNext<CR>", local_keymap_options)
vim.api.nvim_set_keymap("n", "<C-Left>", ":BufferPrevious<CR>", local_keymap_options)


---
--- lazygit
---
require("lazy").setup({})
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", local_keymap_options)

---
--- floaterm
---
vim.keymap.set("n", "<A-i>", ":FloatermToggle<CR>", local_keymap_options)

---
--- noice, notify
---
require("notify").setup({
	background_colour = "#000000",
	render = "wrapped-compact",
	stages = "static",
	top_down = true,
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
				row = "10%",
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
require("todo-comments").setup({
	highlight = {
		pattern = [[.*<(KEYWORDS)\s*]],
	},
	search = {
		pattern = [[\b(KEYWORDS)]],
	},
})

---
--- fugitive
---
-- Function to toggle Git blame view in Neovim
function toggle_git_blame()
	-- Check if current buffer is already in fugitiveblame view
	if string.find(vim.api.nvim_buf_get_name(0), "fugitiveblame") then
		-- Close the buffer if already in fugitiveblame view
		vim.api.nvim_command("q")
	else
		move_right_if_in_tree()
		-- Open Git blame view if not already in fugitiveblame view
		vim.api.nvim_command("Git blame")
	end
end
vim.keymap.set("n", "<leader>gb", toggle_git_blame, local_keymap_options)

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
	"⠀⠀⢻⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀    ⠀ ⠀⠀⠀⠀⠀⠀⣿⣿⡟⠀⠀",
	"⠀⠀⠈⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀",
	"⠀⠀⠀⠸⣿⡄⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⢠⣿⠇⠀⠀⠀",
	"⠀⠀⠀⠀⢻⡇⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⢸⡟⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠃⠀⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡇⠀⠘⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡄⢀⣄⠀⠀⠀⠀⣠⡀⢠⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠘⠿⠟⠁⢸⣿⣇⠀⠀⣼⣿⣷⠈⠻⠿⠃⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

dashboard.section.buttons.val = {
	dashboard.button("<ctrl>n", "🌿 > open tree", toggle_nvim_tree),
	dashboard.button("<space>fa", "🔎 > find file", builtin.find_files),
	dashboard.button("fr", "🗃️ > recent", ":Telescope oldfiles<CR>"),
	dashboard.button("<space>th", "📜 > cheatsheet", show_cheatsheet),
	dashboard.button("q", "❌ > quit nvim", ":qa<CR>"),
}

---
--- cheatsheet
---
local cheatsheet_window = nil

function show_cheatsheet()
	move_right_if_in_tree()

	local Popup = require("nui.popup")
	local event = require("nui.utils.autocmd").event

	cheatsheet_window = Popup({
		enter = true,
		focusable = false,
		border = {
			style = "rounded",
		},
		position = "50%",
		size = {
			width = "50%",
			height = "70%",
		},
	})

	-- mount/open the component
	cheatsheet_window:mount()
	is_cheatsheet_open = true

	-- unmount component when cursor leaves buffer
	cheatsheet_window:on(event.BufLeave, function()
		cheatsheet_window:unmount()
	end)
	local cheatsheet_path = vim.fn.stdpath("config") .. "/cheatsheet.md"
	local file_contents = vim.fn.readfile(cheatsheet_path)
	-- set content
	vim.api.nvim_buf_set_lines(cheatsheet_window.bufnr, 0, 1, false, file_contents)
	return cheatsheet_window
end

-- Function to close the cheatsheet window
function close_cheatsheet()
	cheatsheet_window:unmount() -- Unmount the cheatsheet window
	is_cheatsheet_open = false -- Update the flag to indicate cheatsheet is closed
end
vim.keymap.set("n", "<leader>th", show_cheatsheet, {})


