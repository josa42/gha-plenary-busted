local pwd = os.getenv('PWD')
local vendor_dir = os.getenv('VENDOR_DIR')
local init_file = os.getenv('INIT_FILE')

_G.install_plug = function(repo)
  local name = repo:gsub('^.*/', '')

  local dir = vendor_dir .. '/' .. name
  if not vim.loop.fs_stat(dir) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', repo, dir })
  end

  vim.opt.runtimepath:prepend(dir)

  if vim.loop.fs_stat(dir .. '/plugin') then
    for _, f in ipairs(vim.fn.readdir(dir .. '/plugin')) do
      vim.cmd.runtime(('plugin/%s'):format(f))
    end
  end
end

vim.opt.runtimepath:prepend(pwd)

install_plug('https://github.com/nvim-lua/plenary.nvim.git')

if init_file ~= '' then
  vim.cmd.source(init_file)
end

require('plenary.busted')
