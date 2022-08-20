local M = {}
local fn = vim.fn
local api = vim.api
M.original_color = nil

local get_kitty_background = function()
	if M.original_color == nil then
		fn.jobstart({ "kitty", "@", "get-colors" }, {
			on_stdout = function(_, d, _)
				for _, result in ipairs(d) do
					if string.match(result, "^background") then
						local color = vim.split(result, "%s+")[2]
						M.original_color = color
						break
					end
				end
			end,
			on_stderr = function(_, d, _)
				if #d > 1 then
					api.nvim_err_writeln(
						"Chameleon.nvim: Error getting background. Make sure kitty remote control is turned on."
					)
				end
			end,
		})
	end
end

local change_background = function(color, sync)
	local arg = 'background="' .. color .. '"'
	local command = "kitty @ set-colors " .. arg
	if not sync then
		fn.jobstart(command, {
			on_stderr = function(_, d, _)
				if #d > 1 then
					api.nvim_err_writeln(
						"Chameleon.nvim: Error changing background. Make sure kitty remote control is turned on."
					)
				end
			end,
		})
	else
		fn.system(command)
	end
end

local function get_color(group, attr)
	return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

local setup_autocmds = function()
	local autocmd = api.nvim_create_autocmd
	local autogroup = api.nvim_create_augroup
	local bg_change = autogroup("BackgroundChange", { clear = true })

	autocmd("ColorScheme", {
		pattern = "*",
		callback = function()
			local color = get_color("Normal", "bg")
			change_background(color)
		end,
		group = bg_change,
	})

	autocmd("User", {
		pattern = "NvChadThemeReload",
		callback = function()
			local color = get_color("Normal", "bg")
			if color then
				change_background(color)
			end
		end,
		group = bg_change,
	})

	autocmd("VimLeavePre", {
		callback = function()
			if M.original_color ~= nil then
				change_background(M.original_color, true)
			end
		end,
		group = autogroup("BackgroundRestore", { clear = true }),
	})
end

M.setup = function()
	get_kitty_background()
	setup_autocmds()
	local color = get_color("Normal", "bg")
	change_background(color, true)
end

return M
