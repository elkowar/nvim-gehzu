local _0_0
do
  local name_0_ = "nvim-gehzu"
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
local autoload = (require("aniseed.autoload")).autoload
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("aniseed.fennel"), require("nvim-gehzu.main"), require("nvim-gehzu.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {fennel = "aniseed.fennel", main = "nvim-gehzu.main", utils = "nvim-gehzu.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local fennel = _local_0_[1]
local main = _local_0_[2]
local utils = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-gehzu"
do local _ = ({nil, _0_0, nil, {{}, nil, nil, nil}})[2] end
local go_to_definition
do
  local v_0_
  do
    local v_0_0
    local function go_to_definition0(w)
      local function _2_()
        local word = (w or main["get-current-word"]())
        local segs = utils["split-last"](word, ".")
        local _3_0 = segs
        if ((type(_3_0) == "table") and (nil ~= (_3_0)[1]) and (nil ~= (_3_0)[2])) then
          local mod = (_3_0)[1]
          local ident = (_3_0)[2]
          return main["goto-definition"](ident, mod)
        elseif ((type(_3_0) == "table") and (nil ~= (_3_0)[1])) then
          local ident = (_3_0)[1]
          return main["goto-definition"](ident)
        end
      end
      local function _3_(_241)
        return print(("Error executing go_to_definition: " .. fennel.traceback(_241)))
      end
      return xpcall(_2_, _3_)
    end
    v_0_0 = go_to_definition0
    _0_0["go_to_definition"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["go_to_definition"] = v_0_
  go_to_definition = v_0_
end
local show_definition
do
  local v_0_
  do
    local v_0_0
    local function show_definition0(w)
      local function _2_()
        local word = (w or main["get-current-word"]())
        local segs = utils["split-last"](word, ".")
        local _3_0 = segs
        if ((type(_3_0) == "table") and (nil ~= (_3_0)[1]) and (nil ~= (_3_0)[2])) then
          local mod = (_3_0)[1]
          local ident = (_3_0)[2]
          return main["gib-definition"](ident, mod)
        elseif ((type(_3_0) == "table") and (nil ~= (_3_0)[1])) then
          local ident = (_3_0)[1]
          return main["gib-definition"](ident)
        end
      end
      local function _3_(_241)
        return print(("Error executing show_definition: " .. fennel.traceback(_241)))
      end
      return xpcall(_2_, _3_)
    end
    v_0_0 = show_definition0
    _0_0["show_definition"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["show_definition"] = v_0_
  show_definition = v_0_
end
return nil