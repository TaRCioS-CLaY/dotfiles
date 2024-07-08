-- :fennel:1708960991
local wk = require("which-key")
local options = {buffer = nil, silent = true, noremap = true, nowait = true}
local functions = require("functions")
local _local_1_ = functions
local require_and = _local_1_["require-and"]
local keymaps_set = _local_1_["keymaps-set"]
if (nil == vim.g.colors_name) then
  vim.opt.background = "dark"
  vim.cmd.colorscheme("gruvbox")
else
end
do
  local augid_3_ = vim.api.nvim_create_augroup("_format-on-save", {clear = true})
end
vim.opt["clipboard"] = "unnamed,unnamedplus"
local function _4_()
  return vim.cmd.edit((vim.fn.stdpath("config") .. "/init.fnl"))
end
return wk.register({O = {name = "Abrir arquivos de configura\195\167\195\163o", i = {_4_, "init"}, p = {"<cmd>exe 'edit' stdpath('config').'/fnl/plugins'<CR>", "plugins"}, u = {name = "Arquivos do usu\195\161rio", i = {"<cmd>exe 'edit' stdpath('config').'/fnl/user/init.fnl'<CR>", "init.lua do usu\195\161rio"}, p = {"<cmd>exe 'edit' stdpath('config').'/lua/user/plugins.lua'<CR>", "plugins.lua do usu\195\161rio"}}, s = {"<cmd>exe 'source' stdpath('config').'/init.lua'<CR>", "Atualizar (source) configura\195\167\195\181es do vim"}}}, vim.tbl_extend("force", options, {mode = "n", prefix = "<leader>"}))