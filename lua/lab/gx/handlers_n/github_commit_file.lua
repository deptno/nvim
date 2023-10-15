local is_git_hash = require('lab/gx/lib/is_git_hash')
local remove_suffix = require("lab/gx/lib/remove_suffix")

local handler = function(line, matched)
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
  local fail_prefix = 'fatal:'

  if git_root:sub(1, #fail_prefix) == fail_prefix then
    vim.notify(git_root)
  end
  local origin = vim.fn.system([[git remote -v | head -1 | awk '{print $2}']]):gsub('\n', '')
  local parts = {}

  for part in origin:gmatch("[^@:/]+") do
    table.insert(parts, part)
  end

  local domain = parts[2]
  local username = parts[3]
  local repository = remove_suffix('.git', parts[4])

  local Job = require("plenary.job")
  local command = "open"

  Job:new({
    command,
    args = {
      string.format("https://%s/%s/%s/commit/%s", domain, username, repository, matched)
    },
  }):sync()

  vim.notify(string.format("Open github commit: %s", matched), vim.log.levels.INFO)
end
local match = is_git_hash
local name = 'github commit'

return {
  handler = handler,
  match = match,
  name = name,
}
