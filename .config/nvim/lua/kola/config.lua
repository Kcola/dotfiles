local configs_found, configs = pcall(function()
  return vim.fn.json_decode(vim.fn.readfile(vim.fn.expand(CONFIG_PATH)))
end)

if not configs_found then
  return {
    get = NOOP,
  }
end

local repo = ""

local job = vim.fn.jobstart("git remote get-url origin", {
  stdout_buffered = true,
  on_stdout = function(_, data)
    if data then
      local remote = data[1]
      if remote then
        local remote_name = remote:match("([^/]+)$")
        repo = remote_name
      end
    end
  end,
})
vim.fn.jobwait({ job })

return {
  get = function()
    return configs[repo] or {}
  end,
}
