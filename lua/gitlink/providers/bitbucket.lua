local M = {}

function M.build(info, branch, path, l1, l2)
  local is_cloud = info.host == "bitbucket.org"

  local url
  if is_cloud then
    url = string.format(
      "https://bitbucket.org/%s/%s/src/%s/%s",
      info.owner, info.repo, branch, path
    )
  else
    url = string.format(
      "https://%s/projects/%s/repos/%s/browse/%s?at=refs%%2Fheads%%2F%s",
      info.host,
      info.owner:upper(),
      info.repo,
      path,
      branch
    )
  end

  if not l1 then return url end

  if is_cloud then
    if l1 == l2 then
      return url .. "#lines-" .. l1
    end
    return url .. "#lines-" .. l1 .. ":" .. l2
  else
    if l1 == l2 then
      return url .. "#" .. l1
    end
    return url .. "#" .. l1 .. "-" .. l2
  end
end

return M
