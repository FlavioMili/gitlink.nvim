local M = {}

function M.build(info, branch, path, l1, l2)
  local url = string.format(
    "https://%s/%s/%s/-/blob/%s/%s",
    info.host, info.owner, info.repo, branch, path
  )

  if not l1 then return url end

  if l1 == l2 then
    return url .. "#L" .. l1
  end

  return url .. "#L" .. l1 .. "-" .. l2
end

return M
