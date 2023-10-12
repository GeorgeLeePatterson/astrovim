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

-- choose a random element from `tbl`
-- `simple` is a boolean flag to return the key and nested table
function M.random_tbl_gen(tbl, simple)
  math.randomseed(os.time())
  local rnd_idx = math.random(1, #tbl)
  local keys = {}
  for k in pairs(tbl) do
    table.insert(keys, k)
  end
  local key = keys[rnd_idx]
  local value = tbl[key]

  if simple then return key, value end

  if type(value) == "table" then
    return key, value[math.random(1, #value)]
  else
    return key, value
  end
end

return M
