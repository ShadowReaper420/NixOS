-- Scrolling columns, each with its own inner layout, plus a "lock" that sends
-- new windows into one column. Lua 5.1 compatible.
--
-- Group-aware: a Hyprland group (tabbed windows) is ONE layout target, so it
-- counts as a single window inside a column. Its visible window changes when
-- you switch tabs, so column membership is tracked by every member's id.
local cfg = {
  col_width       = 0.5,   -- default column width (fraction of the work area)
  follow_focus    = false,  -- scroll the view to bring a newly focused column into view
  focus_fit_method = 0,    -- how: 0 = centre the column, 1 = fit (minimal scroll); 2 = align left (extra)
  accordion_strip = 0.12,  -- height fraction for each unfocused window in accordion
  master_ratio    = 0.6,   -- height fraction of the big window in master
  dwindle_ratio   = 0.5,   -- share of the remaining box each dwindle split gives the window
  presets         = { 0.5, 0.667, 1.0 },  -- column widths cycled by "preset next|prev"
}

local MODES = { "rows", "dwindle", "grid", "master", "accordion" }

local win_col = {}  -- window stable_id -> column id
local cols    = {}  -- column id -> { pos, mode, width, seen, focus_win }
local next_id = 1
local tick    = 0
local locked        -- column that new windows are forced into (nil = off)

-- Read a field without letting an unexpected object shape throw.
local function field(obj, name)
  if obj == nil then return nil end
  local ok, v = pcall(function() return obj[name] end)
  if ok then return v end
  return nil
end

local function notify(text)
  if hl.notification and hl.notification.create then
    pcall(hl.notification.create, { text = text, timeout = 1500 })
  end
end

-- Stable ids of every window behind a target: the window itself plus all
-- members of its group (tabs).
local function ids_of_window(w)
  local ids, seen = {}, {}
  local function add(x)
    local id = field(x, "stable_id")
    if id and not seen[id] then
      seen[id] = true
      ids[#ids + 1] = id
    end
  end

  if not w then return ids end
  add(w)

  local g = field(w, "group")
  local m = g and field(g, "members")
  if m ~= nil then
    if field(m, "stable_id") then
      add(m)                                  -- a single window
    elseif type(m) == "table" then
      for _, mw in ipairs(m) do add(mw) end   -- a list of windows
    end
  end
  return ids
end

local function has(ids, id)
  if not ids then return false end
  for _, v in ipairs(ids) do
    if v == id then return true end
  end
  return false
end

local function assign(w, cid)
  for _, id in ipairs(ids_of_window(w)) do win_col[id] = cid end
end

local function new_col(pos)
  local id = next_id
  next_id = next_id + 1
  cols[id] = { pos = pos, mode = "rows", width = cfg.col_width, seen = 0 }
  return id
end

local function touch(cid, wid)
  tick = tick + 1
  cols[cid].seen = tick
  if wid then cols[cid].focus_win = wid end
end

-- Index (in `list`) of the column that had focus most recently.
local function focused(list)
  local best, bi = nil, 1
  for i, c in ipairs(list) do
    local s = cols[c.id].seen
    if not best or s > best then best, bi = s, i end
  end
  return bi
end

-- Group this workspace's targets into columns; give unseen windows a column.
-- Returns: sorted column list, column id -> index map, target -> ids map.
local function build(ctx)
  local groups, fresh, orphans, idmap = {}, {}, {}, {}

  for _, t in ipairs(ctx.targets) do
    local ids = ids_of_window(t.window)
    idmap[t] = ids
    if #ids == 0 then
      table.insert(orphans, t)
    else
      local cid
      for _, id in ipairs(ids) do
        if win_col[id] and cols[win_col[id]] then
          cid = win_col[id]
          break
        end
      end
      if cid then
        for _, id in ipairs(ids) do win_col[id] = cid end  -- keep tabs together
        groups[cid] = groups[cid] or {}
        table.insert(groups[cid], t)
      else
        table.insert(fresh, t)
      end
    end
  end

  local function sorted()
    local list = {}
    for cid, ts in pairs(groups) do table.insert(list, { id = cid, ts = ts }) end
    table.sort(list, function(a, b) return cols[a.id].pos < cols[b.id].pos end)
    return list
  end

  for _, t in ipairs(fresh) do
    local ids = idmap[t]
    local cid
    if locked and groups[locked] then
      cid = locked
      table.insert(groups[locked], t)
    else
      local list = sorted()
      local pos = 1
      if #list > 0 then
        local fi = focused(list)
        local after = cols[list[fi].id].pos
        local nxt = list[fi + 1] and cols[list[fi + 1].id].pos
        pos = nxt and (after + nxt) / 2 or after + 1
      end
      cid = new_col(pos)
      groups[cid] = { t }
      touch(cid, ids[1])  -- next new window lands after this one
    end
    for _, id in ipairs(ids) do win_col[id] = cid end
  end

  local list, index = sorted(), {}
  for i, c in ipairs(list) do index[c.id] = i end

  -- targets without a window object: park them in the first column
  if list[1] then
    for _, t in ipairs(orphans) do table.insert(list[1].ts, t) end
  end

  local aw = hl.get_active_window()
  local aid = field(aw, "stable_id")
  if aid and win_col[aid] and groups[win_col[aid]] then
    touch(win_col[aid], aid)
  end

  return list, index, idmap
end

-- Inner layouts: place targets `ts` inside box `b`.
-- `focus` is the index of the column's remembered focused target.
local inner = {}

function inner.rows(ts, b)
  local h = b.h / #ts
  for i, t in ipairs(ts) do
    t:place({ x = b.x, y = b.y + (i - 1) * h, w = b.w, h = h })
  end
end

-- Each window takes a share of the remaining box, splitting its longer side,
-- like Hyprland's dwindle layout.
function inner.dwindle(ts, b)
  local box = { x = b.x, y = b.y, w = b.w, h = b.h }
  local r = cfg.dwindle_ratio
  for i, t in ipairs(ts) do
    if i == #ts then
      t:place(box)
      return
    end
    if box.w >= box.h then
      local w1 = box.w * r
      t:place({ x = box.x, y = box.y, w = w1, h = box.h })
      box = { x = box.x + w1, y = box.y, w = box.w - w1, h = box.h }
    else
      local h1 = box.h * r
      t:place({ x = box.x, y = box.y, w = box.w, h = h1 })
      box = { x = box.x, y = box.y + h1, w = box.w, h = box.h - h1 }
    end
  end
end

function inner.master(ts, b)
  if #ts == 1 then ts[1]:place(b); return end
  local mh = b.h * cfg.master_ratio
  ts[1]:place({ x = b.x, y = b.y, w = b.w, h = mh })
  local h = (b.h - mh) / (#ts - 1)
  for i = 2, #ts do
    ts[i]:place({ x = b.x, y = b.y + mh + (i - 2) * h, w = b.w, h = h })
  end
end

function inner.grid(ts, b)
  local n = #ts
  local c = math.ceil(math.sqrt(n))
  local r = math.ceil(n / c)
  local w, h = b.w / c, b.h / r
  for i, t in ipairs(ts) do
    local cx, cy = (i - 1) % c, math.floor((i - 1) / c)
    t:place({ x = b.x + cx * w, y = b.y + cy * h, w = w, h = h })
  end
end

function inner.accordion(ts, b, focus)
  local n = #ts
  if n == 1 then ts[1]:place(b); return end
  local strip = b.h * cfg.accordion_strip
  local big = b.h - strip * (n - 1)
  local y = b.y
  for i, t in ipairs(ts) do
    local h = (i == focus) and big or strip
    t:place({ x = b.x, y = y, w = b.w, h = h })
    y = y + h
  end
end

-- Per-workspace viewport: how far the tape is scrolled (vx, in px) and what the
-- focused column looked like last time, so we only follow when focus changes.
local views = {}

local function ws_key(ctx)
  for _, t in ipairs(ctx.targets) do
    local ws = field(t.window, "workspace")
    local id = ws and field(ws, "id")
    if id ~= nil then return id end
  end
  return "?"
end

-- Column positions on the tape: left edges, widths and total content width.
local function geometry(list, aw)
  local total = 0
  for _, c in ipairs(list) do total = total + cols[c.id].width * aw end
  local scale = total < aw and aw / total or 1   -- stretch to fill spare room

  local left, width, x = {}, {}, 0
  for i, c in ipairs(list) do
    left[i] = x
    width[i] = cols[c.id].width * aw * scale
    x = x + width[i]
  end
  return left, width, x
end

local function clamp_view(vx, content, aw)
  return math.max(0, math.min(vx, math.max(0, content - aw)))
end

-- New viewport offset that brings a column (at `left`, `width`) into view.
local function bring_into_view(vx, left, width, aw)
  if cfg.focus_fit_method == 0 then
    return left + width / 2 - aw / 2            -- centre it
  elseif cfg.focus_fit_method == 2 then
    return left                                 -- align left
  end
  -- fit: scroll as little as possible
  if width >= aw or left < vx then return left end
  if left + width > vx + aw then return left + width - aw end
  return vx
end

local function recalculate(ctx)
  if #ctx.targets == 0 then return end
  local list, _, idmap = build(ctx)
  if #list == 0 then return end
  local a = ctx.area

  local left, width, content = geometry(list, a.w)

  local wk = ws_key(ctx)
  local st = views[wk]
  if not st then
    st = { vx = 0 }
    views[wk] = st
  end

  -- Like scrolling:follow_focus: when the focused column changes (or its
  -- position/width on the tape changes), scroll to bring it into view.
  local f = focused(list)
  local cur = list[f]
  local vx = st.vx
  local changed = st.fcol ~= cur.id or st.fleft ~= left[f] or st.fwidth ~= width[f]
  if cfg.follow_focus and changed then
    vx = bring_into_view(vx, left[f], width[f], a.w)
  end
  st.fcol, st.fleft, st.fwidth = cur.id, left[f], width[f]
  vx = clamp_view(vx, content, a.w)
  st.vx = vx
  local shift = -vx

  for i, c in ipairs(list) do
    local col = cols[c.id]
    local box = { x = a.x + left[i] + shift, y = a.y, w = width[i], h = a.h }
    local focus = 1
    for j, t in ipairs(c.ts) do
      if has(idmap[t], col.focus_win) then focus = j end
    end
    local fn = inner[col.mode] or inner.rows
    fn(c.ts, box, focus)
  end
end

local function layout_msg(ctx, msg)
  local list, _, _ = build(ctx)
  if #list == 0 then return false end

  local f = focused(list)
  local cur = list[f]
  local col = cols[cur.id]
  local aw = hl.get_active_window()
  local aid = field(aw, "stable_id")
  local cmd, arg = msg:match("^(%S+)%s*(.*)$")

  if cmd == "refresh" then
    return true

  elseif cmd == "mode" then
    if arg == "next" or arg == "prev" then
      local i = 1
      for k, m in ipairs(MODES) do if m == col.mode then i = k end end
      i = (i - 1 + (arg == "next" and 1 or -1)) % #MODES + 1
      col.mode = MODES[i]
    else
      for _, m in ipairs(MODES) do if m == arg then col.mode = m end end
    end
    return true

  elseif cmd == "width" then
    local n = tonumber(arg)
    if n then
      local first = arg:sub(1, 1)
      col.width = (first == "+" or first == "-") and col.width + n or n
      col.width = math.max(0.1, math.min(1, col.width))
    end
    return true

  elseif cmd == "move" then
    -- scroll the view by columns (+col / -col) or logical px (+200 / -200)
    local st = views[ws_key(ctx)]
    if st then
      local left, _, content = geometry(list, ctx.area.w)
      local vx = st.vx
      if arg == "+col" then
        for i = 1, #list do
          if left[i] > vx + 1 then vx = left[i]; break end
        end
      elseif arg == "-col" then
        for i = #list, 1, -1 do
          if left[i] < vx - 1 then vx = left[i]; break end
        end
      else
        vx = vx + (tonumber(arg) or 0)
      end
      st.vx = clamp_view(vx, content, ctx.area.w)
    end
    return true

  elseif cmd == "preset" then
    local step = (arg == "prev") and -1 or 1
    local idx = 0
    for i, w in ipairs(cfg.presets) do
      if math.abs(w - col.width) < 0.01 then idx = i end
    end
    if idx == 0 then
      idx = (step == 1) and 1 or #cfg.presets   -- not on a preset: jump to an end
    else
      idx = (idx - 1 + step) % #cfg.presets + 1
    end
    col.width = cfg.presets[idx]
    return true

  elseif cmd == "consume" then
    local nb = list[f + (arg == "left" and -1 or 1)]
    if nb and aid and win_col[aid] == cur.id then
      assign(aw, nb.id)       -- moves the whole group if the window is tabbed
      touch(nb.id, aid)
    end
    return true

  elseif cmd == "expel" then
    if aid and win_col[aid] == cur.id and #cur.ts > 1 then
      local nxt = list[f + 1] and cols[list[f + 1].id].pos
      local cid = new_col(nxt and (col.pos + nxt) / 2 or col.pos + 1)
      assign(aw, cid)
      touch(cid, aid)
    end
    return true

  elseif cmd == "swapcol" then
    local nb = list[f + (arg == "left" and -1 or 1)]
    if nb then col.pos, cols[nb.id].pos = cols[nb.id].pos, col.pos end
    return true

  elseif cmd == "lock" then
    if locked == cur.id then
      locked = nil
      notify("Column unlocked")
    else
      locked = cur.id
      notify("Column locked")
    end
    return true

  elseif cmd == "unlock" then
    locked = nil
    notify("Column unlocked")
    return true
  end

  return false
end

-- Forget windows and columns that no longer exist.
local function gc()
  local alive = {}
  for _, w in ipairs(hl.get_windows()) do
    local id = field(w, "stable_id")
    if id then alive[id] = true end
  end
  local used = {}
  for wid, cid in pairs(win_col) do
    if alive[wid] then used[cid] = true else win_col[wid] = nil end
  end
  for cid in pairs(cols) do
    if not used[cid] then cols[cid] = nil end
  end
  if locked and not cols[locked] then locked = nil end
end

hl.layout.register("scrollcols", { recalculate = recalculate, layout_msg = layout_msg })

-- True when the active workspace is using this layout. Layout messages go to
-- whatever layout is active, so sending "refresh" to any other layout makes
-- Hyprland pop up "no such layoutmsg".
local function uses_scrollcols()
  local ok, ws = pcall(hl.get_active_workspace)
  local name = ok and field(ws, "tiled_layout") or nil
  if name == nil then
    local ok2, v = pcall(hl.get_config, "general.layout")
    name = ok2 and v or nil
  end
  return name ~= nil and tostring(name):find("scrollcols", 1, true) ~= nil
end

-- Recalculation isn't triggered by focus changes (or tab switches), so nudge it.
hl.on("window.active", function()
  if uses_scrollcols() then
    hl.dispatch(hl.dsp.layout("refresh"))
  end
end)
hl.on("window.destroy", function() pcall(gc) end)

hl.config({ general = { layout = "lua:scrollcols" } })
