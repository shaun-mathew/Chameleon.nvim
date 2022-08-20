# 🦎 Chameleon.nvim

Chameleon is a Neovim plugin that changes your Kitty terminal's background in response to your Neovim's colorscheme.

https://user-images.githubusercontent.com/16690478/184077261-dfeaa604-e9d7-4008-9856-77b621844adc.mp4

## 🔌 Requirements

- Neovim >= 0.7.0
- Kitty remote control turned on. Set `allow_remote_control yes` in kitty.conf

## 💿 Installation

### [packer](https://github.com/wbthomason/packer.nvim)

#### Neovim Setup
```lua
-- Lua
use {
  "shaun-mathew/Chameleon.nvim",
  config = function()
    require("chameleon").setup()
  end
}
```

#### NvChad Setup
```lua
-- init.lua
["/home/shaun/repos/chameleon.nvim"] = {
  after = "ui",
  config = function()
    require("chameleon").setup()
  end,
}
```

### 📄 TODO
- [ ] Add more configuration options (e.g. disable autostart)
- [ ] Allow for toggling of plugin
- [ ] Support other terminals (e.g. Alacritty)
