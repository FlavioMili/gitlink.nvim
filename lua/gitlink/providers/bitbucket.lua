local M = {}

local function owner_segment(owner)
  if owner:sub(1, 1) == "~" then
    return "users/" .. owner:sub(2)
  else
    return "projects/" .. owner:upper()
  end
end

function M.build(info, branch, path, l1, l2)
  local url

  if info.host == "bitbucket.org" then
    url = string.format(
      "https://bitbucket.org/%s/%s/src/%s/%s",
      info.owner, info.repo, branch, path
    )
  else
    url = string.format(
      "https://%s/%s/repos/%s/browse/%s?at=refs%%2Fheads%%2F%s",
      info.host,
      owner_segment(info.owner),
      info.repo,
      path,
      branch
    )
  end

  if not l1 then return url end

  if info.host == "bitbucket.org" then
    if l1 == l2 then return url .. "#lines-" .. l1 end
    return url .. "#lines-" .. l1 .. ":" .. l2
  else
    if l1 == l2 then return url .. "#" .. l1 end
    return url .. "#" .. l1 .. "-" .. l2
  end
end

return M
