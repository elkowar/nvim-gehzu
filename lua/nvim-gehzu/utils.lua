local _0_0
do
  local name_0_ = "nvim-gehzu.utils"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local autoload = (require("nvim-gehzu.aniseed.autoload")).autoload
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {autoload("nvim-gehzu.aniseed.core"), autoload("nvim-gehzu.aniseed.fennel"), autoload("nvim-gehzu.aniseed.nvim"), autoload("nvim-gehzu.aniseed.string")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {autoload = {a = "nvim-gehzu.aniseed.core", fennel = "nvim-gehzu.aniseed.fennel", nvim = "nvim-gehzu.aniseed.nvim", str = "nvim-gehzu.aniseed.string"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local nvim = _local_0_[3]
local str = _local_0_[4]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-gehzu.utils"
do local _ = ({nil, _0_0, nil, {{}, nil, nil, nil}})[2] end
local split_last
do
  local v_0_
  do
    local v_0_0
    local function split_last0(s, sep)
      for i = #s, 1, -1 do
        local c = s:sub(i, i)
        if (sep == c) then
          local left = s:sub(1, (i - 1))
          local right = s:sub((i + 1))
          return { left, right }
        end
      end
      return {s}
    end
    v_0_0 = split_last0
    _0_0["split-last"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["split-last"] = v_0_
  split_last = v_0_
end
local find_where
do
  local v_0_
  do
    local v_0_0
    local function find_where0(pred, xs)
      for _, x in ipairs(xs) do
        if pred(x) then
          return x
        end
      end
      return nil
    end
    v_0_0 = find_where0
    _0_0["find-where"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["find-where"] = v_0_
  find_where = v_0_
end
local find_map
do
  local v_0_
  do
    local v_0_0
    local function find_map0(f, xs)
      for _, x in ipairs(xs) do
        local res = f(x)
        if (nil ~= res) then
          return res
        end
      end
      return nil
    end
    v_0_0 = find_map0
    _0_0["find-map"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["find-map"] = v_0_
  find_map = v_0_
end
local keep_if
do
  local v_0_
  do
    local v_0_0
    local function keep_if0(f, x)
      if f(x) then
        return x
      end
    end
    v_0_0 = keep_if0
    _0_0["keep-if"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["keep-if"] = v_0_
  keep_if = v_0_
end
return nil