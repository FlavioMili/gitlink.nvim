# GitLink

GitLink is a simple plugin that gives you the link to your git repository right from your code.
It can also link the selected lines if you are in visual mode.

Currently it supports these git hosts:
- Bitbucket
- Github
- Gitlab

## Installation
Add this in a `gitlink.lua` file and then include it in your `plugins.init.lua`.

```lua
return {
  "FlavioMili/gitlink.nvim",

-- select your shortcut
  keys = { { "<leader>gl", function()
        local gl = require("gitlink")
        local mode = vim.fn.mode()
        local l1, l2

        if mode:match("[vV\22]") then
          local vstart = vim.fn.getpos("v")[2]
          local cursor = vim.api.nvim_win_get_cursor(0)[1]

          l1, l2 = vstart, cursor
          if l1 > l2 then l1, l2 = l2, l1 end
        end

        if l1 then gl.get_link({ line1 = l1, line2 = l2 })
        else gl.get_link() end
      end,
      mode = { "n", "v" },
      desc = "Copy git link",
    },
  },

  config = function()
    require("gitlink").setup()
  end,
}
```
