-- Overrides to core/init.lua

-- Globals
local g = vim.g

-- Local opts
local opt = vim.opt

local config = require("core.utils").load_config()

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Default tab definitions
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

-- Set default numbering to relative
opt.relativenumber = true
