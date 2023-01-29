local run = function()
  local pwd = os.getenv('PWD')
  local init_file = os.getenv('INIT_FILE')

  vim.opt.runtimepath:prepend(pwd)

  install_plug('https://github.com/nvim-lua/plenary.nvim.git')

  if init_file ~= '' then
    vim.cmd.source(init_file)
  end
end

_G.install_plug = function(repo)
  local vendor_dir = os.getenv('VENDOR_DIR')
  local name = repo:gsub('^.*/', '')

  local dir = vendor_dir .. '/' .. name
  if not vim.loop.fs_stat(dir) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', repo, dir })
  end

  vim.opt.runtimepath:prepend(dir)

  local dir_plugin = dir .. '/plugin'

  if vim.loop.fs_stat(dir_plugin) then
    local files = vim.fn.readdir(dir_plugin, function(f)
      if f:match('%.lua$') or f:match('%.vim$') then
        return 1
      end
    end)

    for _, f in ipairs(files) do
      vim.cmd.runtime(('plugin/%s'):format(f))
    end
  end
end

run()
