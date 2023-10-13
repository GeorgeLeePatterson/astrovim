local M = {}

-- extend list `l` with `value` `num` times
function M.list_extend_rep(l, value, num)
  if num == nil or num == 0 then num = 1 end
  if not value or #value == 0 then return l end
  for _ = 1, num do
    table.insert(l, value)
  end
  return l
end

-- choose a random element from `list`
function M.random_gen(list)
  math.randomseed(os.time())
  return list[math.random(1, #list)]
end

function M.get_random_key(tbl)
  local keys = vim.tbl_keys(tbl)
  return M.random_gen(keys)
end

-- choose a random element from `tbl`
-- `simple` is a boolean flag to return the key and nested table
function M.random_tbl_gen(tbl, simple)
  local key = M.get_random_key(tbl)
  local value = tbl[key]

  if simple then return key, value end

  if type(value) == "table" then
    local t_key = M.get_random_key(value)
    return key, value[t_key]
  end

  return key, value
end

return M
