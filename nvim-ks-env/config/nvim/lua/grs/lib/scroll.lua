--[[ Automatic scrolling in window ]]

-- Here are the keymaps I use with these, see config/keymaps.lua
--   scroll.up:     <pageup>
--   scroll.down:   <pagedown>
--   scroll.faster: <home>
--   scroll.slower: <end>
--   scroll.reset:  <insert>
--   scroll.pause:  <delete>

local up = 'normal <c-y>'
local dn = 'normal <c-e>'
local sleep_more = 2.0
local sleep_less = 0.5

local M = {
   sleep = 500,
   direction = dn,
   timer = nil,
}

local del_timer = function()
   if M.timer ~= nil then
      M.timer:close()
      M.timer = nil
   end
end

local new_timer = function()
   del_timer()
   M.timer = vim.loop.new_timer()
   M.timer:start(
      600,
      M.sleep,
      vim.schedule_wrap(function()
         vim.cmd(vim.api.nvim_replace_termcodes(M.direction, true, true, true))
      end)
   )
end

local change = function(n, direction)
   M.sleep = M.sleep * n
   M.direction = direction
   new_timer()
end

function M.up()
   change(1, up)
end

function M.down()
   change(1, dn)
end

function M.pause()
   del_timer()
end

function M.reset()
   M.sleep = 500
   M.direction = dn
   del_timer()
end

function M.slower()
   if M.timer then
      change(sleep_more, M.direction)
   end
end

function M.faster()
   if M.timer then
      change(sleep_less, M.direction)
   end
end

return M
