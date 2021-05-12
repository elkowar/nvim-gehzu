local _0_0
do
  local name_0_ = "nvim-gehzu.main"
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
    return {require("nvim-gehzu.aniseed.core"), require("nvim-gehzu.aniseed.fennel"), require("popup"), require("nvim-gehzu.aniseed.string"), require("nvim-treesitter"), require("nvim-gehzu.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "nvim-gehzu.aniseed.core", fennel = "nvim-gehzu.aniseed.fennel", popup = "popup", str = "nvim-gehzu.aniseed.string", ts = "nvim-treesitter", utils = "nvim-gehzu.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local popup = _local_0_[3]
local str = _local_0_[4]
local ts = _local_0_[5]
local utils = _local_0_[6]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-gehzu.main"
do local _ = ({nil, _0_0, nil, {{}, nil, nil, nil}})[2] end
local query_module_header
do
  local v_0_ = vim.treesitter.parse_query("fennel", "(function_call \n      name: (identifier) @module-header-name (#eq? @module-header-name \"module\")\n      [(identifier) (field_expression)] @module-name\n      (table ((identifier) @import-type\n              (table ((identifier) @key (_) @value)*)\n             )*\n      )\n     )")
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["query-module-header"] = v_0_
  query_module_header = v_0_
end
local read_module_imports_fnl
do
  local v_0_
  do
    local v_0_0
    local function read_module_imports_fnl0(bufnr)
      local parser = vim.treesitter.get_parser(bufnr, "fennel")
      if (nil ~= parser) then
        local _let_0_ = parser:parse()
        local tstree = _let_0_[1]
        if (nil ~= tstree) then
          local tsnode = tstree:root()
          if (nil ~= tsnode) then
            local current_module_name = nil
            local last_module = nil
            local modules = {}
            for id, node, metadata in query_module_header:iter_captures(tsnode, bufnr, 0, -1) do
              local name = query_module_header.captures[id]
              if (nil ~= name) then
                local r1, c1, r2, c2 = node:range()
                if ((nil ~= r1) and (nil ~= c1) and (nil ~= r2) and (nil ~= c2)) then
                  local node_text = vim.treesitter.get_node_text(node, 0)
                  if (nil ~= node_text) then
                    local _2_0 = name
                    if (_2_0 == "module-name") then
                      current_module_name = node_text
                    elseif (_2_0 == "key") then
                      last_module = node_text
                    elseif (_2_0 == "value") then
                      modules[last_module] = node_text
                    end
                  else
                    print("[76] Value node-text=(vim.treesitter.get_node_text node 0) was nil")
                  end
                else
                  print("[75] (at least) one of the values of (r1 c1 r2 c2)=(node:range) was nil")
                end
              else
                print("[74] Value name=(. query-module-header.captures id) was nil")
              end
            end
            return current_module_name, modules
          else
            return print("[69] Value tsnode=(tstree:root) was nil")
          end
        else
          return print("[68] (at least) one of the values of [tstree]=(parser:parse) was nil")
        end
      else
        return print("[67] Value parser=(vim.treesitter.get_parser bufnr \"fennel\") was nil")
      end
    end
    v_0_0 = read_module_imports_fnl0
    _0_0["read-module-imports-fnl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["read-module-imports-fnl"] = v_0_
  read_module_imports_fnl = v_0_
end
local get_current_word
do
  local v_0_
  do
    local v_0_0
    local function get_current_word0()
      local col = (vim.api.nvim_win_get_cursor(0))[2]
      local line = vim.api.nvim_get_current_line()
      return (vim.fn.matchstr(line:sub(1, (col + 1)), "\\k*$") .. string.sub(vim.fn.matchstr(line:sub((col + 1)), "^\\k*"), 2))
    end
    v_0_0 = get_current_word0
    _0_0["get-current-word"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get-current-word"] = v_0_
  get_current_word = v_0_
end
local pop
do
  local v_0_
  do
    local v_0_0
    local function pop0(text, ft)
      local width = 20
      for _, line in ipairs(text) do
        width = math.max(width, #line)
      end
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
      vim.api.nvim_buf_set_option(bufnr, "filetype", ft)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
      return popup.create(bufnr, {padding = {1, 1, 1, 1}, width = width})
    end
    v_0_0 = pop0
    _0_0["pop"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["pop"] = v_0_
  pop = v_0_
end
local all_module_paths
do
  local v_0_
  do
    local v_0_0
    do
      local paths = str.split(package.path, ";")
      for _, path in ipairs(str.split(vim.o.runtimepath, ",")) do
        table.insert(paths, (path .. "/fnl/?.fnl"))
        table.insert(paths, (path .. "/fnl/?/init.fnl"))
        table.insert(paths, (path .. "/lua/?.lua"))
        table.insert(paths, (path .. "/lua/?/init.lua"))
      end
      v_0_0 = paths
    end
    _0_0["all-module-paths"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["all-module-paths"] = v_0_
  all_module_paths = v_0_
end
local file_exists_3f
do
  local v_0_
  do
    local v_0_0
    local function file_exists_3f0(path)
      local file = io.open(path, "r")
      if (nil ~= file) then
        io.close(file)
        return true
      else
        return false
      end
    end
    v_0_0 = file_exists_3f0
    _0_0["file-exists?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["file-exists?"] = v_0_
  file_exists_3f = v_0_
end
local find_module_path
do
  local v_0_
  do
    local v_0_0
    local function find_module_path0(module_name)
      local module_name0 = module_name:gsub("%.", "/")
      local function _2_(_241)
        return utils["keep-if"](file_exists_3f, _241:gsub("?", module_name0))
      end
      return utils["find-map"](_2_, all_module_paths)
    end
    v_0_0 = find_module_path0
    _0_0["find-module-path"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["find-module-path"] = v_0_
  find_module_path = v_0_
end
local get_filetype
do
  local v_0_
  do
    local v_0_0
    local function get_filetype0(filename)
      local _2_0 = utils["split-last"](filename, ".")
      if ((type(_2_0) == "table") and true and ((_2_0)[2] == "fnl")) then
        local _ = (_2_0)[1]
        return "fennel"
      elseif ((type(_2_0) == "table") and true and ((_2_0)[2] == "lua")) then
        local _ = (_2_0)[1]
        return "lua"
      end
    end
    v_0_0 = get_filetype0
    _0_0["get-filetype"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get-filetype"] = v_0_
  get_filetype = v_0_
end
local read_file_to_lines
do
  local v_0_
  do
    local v_0_0
    local function read_file_to_lines0(path)
      local tbl_0_ = {}
      for line, _ in io.lines(path) do
        tbl_0_[(#tbl_0_ + 1)] = line
      end
      return tbl_0_
    end
    v_0_0 = read_file_to_lines0
    _0_0["read-file-to-lines"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["read-file-to-lines"] = v_0_
  read_file_to_lines = v_0_
end
local read_module_file
do
  local v_0_
  do
    local v_0_0
    local function read_module_file0(module_name)
      local path = find_module_path(module_name)
      if (nil ~= path) then
        local ft = get_filetype(path)
        if (nil ~= ft) then
          local result = read_file_to_lines(path)
          if (nil ~= result) then
            return result, ft
          else
            return print("[146] Value result=(read-file-to-lines path) was nil")
          end
        else
          return print("[145] Value ft=(get-filetype path) was nil")
        end
      else
        return print("[144] Value path=(find-module-path module-name) was nil")
      end
    end
    v_0_0 = read_module_file0
    _0_0["read-module-file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["read-module-file"] = v_0_
  read_module_file = v_0_
end
local make_def_query
do
  local v_0_
  do
    local v_0_0
    local function make_def_query0(symbol)
      return vim.treesitter.parse_query("fennel", ("(function_call\n          name: (identifier) @fn-name (#match? @fn-name \"defn|def|defn-|def-|fn|local|macro\")\n          .\n          (identifier) @symbol-name (#contains? @symbol-name \"" .. symbol .. "\"))"))
    end
    v_0_0 = make_def_query0
    _0_0["make-def-query"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["make-def-query"] = v_0_
  make_def_query = v_0_
end
local create_buf_with
do
  local v_0_
  do
    local v_0_0
    local function create_buf_with0(lines, visible)
      assert(a["table?"](lines), "text must be given as list of lines")
      local bufnr = vim.api.nvim_create_buf(visible, true)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
      return bufnr
    end
    v_0_0 = create_buf_with0
    _0_0["create-buf-with"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["create-buf-with"] = v_0_
  create_buf_with = v_0_
end
local find_definition_node_fnl
do
  local v_0_
  do
    local v_0_0
    local function find_definition_node_fnl0(lines, symbol)
      assert(a["table?"](lines), "text must be given as list of lines")
      local query = make_def_query(symbol)
      if (nil ~= query) then
        local bufnr = create_buf_with(lines, false)
        if (nil ~= bufnr) then
          local parser = vim.treesitter.get_parser(bufnr, "fennel")
          if (nil ~= parser) then
            local _let_0_ = parser:parse()
            local tstree = _let_0_[1]
            if (nil ~= tstree) then
              local tsnode = tstree:root()
              if (nil ~= tsnode) then
                for id, node, metadata in query:iter_captures(tsnode, bufnr, 0, -1) do
                  if ("symbol-name" == query.captures[id]) then
                    return node
                  end
                end
                return nil
              else
                return print("[173] Value tsnode=(tstree:root) was nil")
              end
            else
              return print("[172] (at least) one of the values of [tstree]=(parser:parse) was nil")
            end
          else
            return print("[171] Value parser=(vim.treesitter.get_parser bufnr \"fennel\") was nil")
          end
        else
          return print("[170] Value bufnr=(create-buf-with lines false) was nil")
        end
      else
        return print("[169] Value query=(make-def-query symbol) was nil")
      end
    end
    v_0_0 = find_definition_node_fnl0
    _0_0["find-definition-node-fnl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["find-definition-node-fnl"] = v_0_
  find_definition_node_fnl = v_0_
end
local find_definition_str_fnl
do
  local v_0_
  do
    local v_0_0
    local function find_definition_str_fnl0(lines, symbol)
      local node = find_definition_node_fnl(lines, symbol)
      if (nil ~= node) then
        local parent = node:parent()
        if (nil ~= parent) then
          local r1, c1, r2, c2 = parent:range()
          if ((nil ~= r1) and (nil ~= c1) and (nil ~= r2) and (nil ~= c2)) then
            local code_lines = {}
            for i = (r1 + 1), r2 do
              table.insert(code_lines, lines[i])
            end
            return code_lines
          else
            return print("[183] (at least) one of the values of (r1 c1 r2 c2)=(parent:range) was nil")
          end
        else
          return print("[182] Value parent=(node:parent) was nil")
        end
      else
        return print("[181] Value node=(find-definition-node-fnl lines symbol) was nil")
      end
    end
    v_0_0 = find_definition_str_fnl0
    _0_0["find-definition-str-fnl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["find-definition-str-fnl"] = v_0_
  find_definition_str_fnl = v_0_
end
local goto_definition
do
  local v_0_
  do
    local v_0_0
    local function goto_definition0(word, mod)
      if mod then
        local cur_mod_name, imports = read_module_imports_fnl(0)
        if ((nil ~= cur_mod_name) and (nil ~= imports)) then
          local actual_mod = (imports[mod] or mod)
          if (nil ~= actual_mod) then
            local module_file_path = find_module_path(actual_mod)
            if (nil ~= module_file_path) then
              local module_lines, module_ft = read_module_file(actual_mod)
              if ((nil ~= module_lines) and (nil ~= module_ft)) then
                local node = find_definition_node_fnl(module_lines, word)
                if (nil ~= node) then
                  local parent = node:parent()
                  if (nil ~= parent) then
                    local r1, c1, r2, c2 = parent:range()
                    if ((nil ~= r1) and (nil ~= c1) and (nil ~= r2) and (nil ~= c2)) then
                      vim.cmd(("view " .. module_file_path))
                      return vim.fn.cursor((r1 + 2), c1)
                    else
                      return print("[197] (at least) one of the values of (r1 c1 r2 c2)=(parent:range) was nil")
                    end
                  else
                    return print("[196] Value parent=(node:parent) was nil")
                  end
                else
                  return print("[195] Value node=(find-definition-node-fnl module-lines word) was nil")
                end
              else
                return print("[194] (at least) one of the values of (module-lines module-ft)=(read-module-file actual-mod) was nil")
              end
            else
              return print("[193] Value module-file-path=(find-module-path actual-mod) was nil")
            end
          else
            return print("[192] Value actual-mod=(or (. imports mod) mod) was nil")
          end
        else
          return print("[191] (at least) one of the values of (cur-mod-name imports)=(read-module-imports-fnl 0) was nil")
        end
      else
        local module_lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
        if (nil ~= module_lines) then
          local node = find_definition_node_fnl(module_lines, word)
          if (nil ~= node) then
            local parent = node:parent()
            if (nil ~= parent) then
              local r1, c1, r2, c2 = parent:range()
              if ((nil ~= r1) and (nil ~= c1) and (nil ~= r2) and (nil ~= c2)) then
                return vim.fn.cursor((r1 + 2), c1)
              else
                return print("[205] (at least) one of the values of (r1 c1 r2 c2)=(parent:range) was nil")
              end
            else
              return print("[204] Value parent=(node:parent) was nil")
            end
          else
            return print("[203] Value node=(find-definition-node-fnl module-lines word) was nil")
          end
        else
          return print("[202] Value module-lines=(vim.api.nvim_buf_get_lines 0 1 -1 false) was nil")
        end
      end
    end
    v_0_0 = goto_definition0
    _0_0["goto-definition"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["goto-definition"] = v_0_
  goto_definition = v_0_
end
local gib_definition
do
  local v_0_
  do
    local v_0_0
    local function gib_definition0(word, mod)
      if mod then
        local cur_mod_name, imports = read_module_imports_fnl(0)
        if ((nil ~= cur_mod_name) and (nil ~= imports)) then
          local actual_mod = (imports[mod] or mod)
          if (nil ~= actual_mod) then
            local module_lines, module_ft = read_module_file(actual_mod)
            if ((nil ~= module_lines) and (nil ~= module_ft)) then
              local definition_lines = find_definition_str_fnl(module_lines, word)
              if (nil ~= definition_lines) then
                return pop(definition_lines, module_ft)
              else
                return print("[214] Value definition-lines=(find-definition-str-fnl module-lines word) was nil")
              end
            else
              return print("[213] (at least) one of the values of (module-lines module-ft)=(read-module-file actual-mod) was nil")
            end
          else
            return print("[212] Value actual-mod=(or (. imports mod) mod) was nil")
          end
        else
          return print("[211] (at least) one of the values of (cur-mod-name imports)=(read-module-imports-fnl 0) was nil")
        end
      else
        local current_file_lines = read_file_to_lines(vim.fn.expand("%"))
        if (nil ~= current_file_lines) then
          local definition_lines = find_definition_str_fnl(current_file_lines, word)
          if (nil ~= definition_lines) then
            return pop(definition_lines, vim.bo.filetype)
          else
            return print("[219] Value definition-lines=(find-definition-str-fnl current-file-lines word) was nil")
          end
        else
          return print("[218] Value current-file-lines=(read-file-to-lines (vim.fn.expand \"%\")) was nil")
        end
      end
    end
    v_0_0 = gib_definition0
    _0_0["gib-definition"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["gib-definition"] = v_0_
  gib_definition = v_0_
end
return nil