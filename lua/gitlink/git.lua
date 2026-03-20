local M = {}

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function run(args, cwd)
  local cmd = { "git", "-C", cwd }
  vim.list_extend(cmd, args)

  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return trim(out[1])
end

function M.get_repo_root(path)
  return run({ "rev-parse", "--show-toplevel" }, path)
end

function M.get_branch(root)
  return run({ "rev-parse", "--abbrev-ref", "HEAD" }, root)
end

function M.get_remote(root)
  return run({ "remote", "get-url", "origin" }, root)
end

return M
