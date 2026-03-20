local M = {}

local function normalize(remote)
  remote = remote:gsub("^ssh://[^@]+@([^:/]+):%d+/", "https://%1/")
  remote = remote:gsub("^git@([^:]+):", "https://%1/")
  remote = remote:gsub("%.git$", "")
  return remote
end

function M.parse(remote)
  if not remote then return nil end

  remote = normalize(remote)

  local host, path = remote:match("^https?://([^/]+)/(.+)$")
  if not host then return nil end

  -- Bitbucket Server quirk
  path = path:gsub("^scm/", "")

  local parts = {}
  for p in path:gmatch("[^/]+") do
    table.insert(parts, p)
  end

  if #parts < 2 then return nil end

  local repo = table.remove(parts)
  local owner = table.concat(parts, "/")

  local provider
  if host:match("github%.com") then
    provider = "github"
  elseif host:match("gitlab") then
    provider = "gitlab"
  elseif host:match("bitbucket%.org") then
    provider = "bitbucket"
  else
    provider = "" -- check later
  end

  return {
    provider = provider,
    host = host,
    owner = owner,
    repo = repo,
  }
end

return M
