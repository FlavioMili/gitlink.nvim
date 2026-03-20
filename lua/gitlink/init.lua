local M = {}

local git = require("gitlink.git")
local parse = require("gitlink.parse")

local providers = {
  github = require("gitlink.providers.github"),
  gitlab = require("gitlink.providers.gitlab"),
  bitbucket = require("gitlink.providers.bitbucket"),
}

-- Detect if we are in visual mode
local function in_visual()
  local mode = vim.fn.mode()
  return mode == "v" or mode == "V" or mode == "\22"
end

local function get_range(opts)
  if opts and opts.line1 and opts.line2 then
    return opts.line1, opts.line2
  end

  -- Only use visual marks if we are actually in visual mode
  if in_visual() then
    local l1 = vim.fn.line("v")
    local l2 = vim.fn.line(".")
    if l1 > l2 then
      l1, l2 = l2, l1
    end
    return l1, l2
  end

  return nil, nil
end

function M.get_link(opts)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return vim.notify("No file", vim.log.levels.ERROR)
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local root = git.get_repo_root(dir)
  if not root then
    return vim.notify("Not a git repo", vim.log.levels.ERROR)
  end

  local remote = git.get_remote(root)
  local info = parse.parse(remote)
  if not info then
    return vim.notify("Invalid remote", vim.log.levels.ERROR)
  end

  local branch = git.get_branch(root)
  if not branch then
    return vim.notify("No branch", vim.log.levels.ERROR)
  end

  local rel = file:sub(#root + 2)

  local l1, l2 = get_range(opts)

  local provider = providers[info.provider]
  if not provider then
    return vim.notify("Unsupported provider", vim.log.levels.ERROR)
  end

  local url = provider.build(info, branch, rel, l1, l2)

  vim.fn.setreg("+", url)
  vim.notify(url)

  return url
end

function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_user_command("GitLink", function(cmd_opts)
    M.get_link({
      line1 = cmd_opts.line1,
      line2 = cmd_opts.line2,
    })
  end, { range = true })

  if opts.keymap ~= false then
    vim.keymap.set({ "n", "v" }, "<leader>gl", function()
      -- Explicitly pass range ONLY if visual
      if in_visual() then
        local l1 = vim.fn.line("v")
        local l2 = vim.fn.line(".")
        if l1 > l2 then l1, l2 = l2, l1 end

        M.get_link({ line1 = l1, line2 = l2 })
      else
        M.get_link()
      end
    end, { desc = "Copy git link" })
  end
end

return M
