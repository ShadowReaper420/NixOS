-- Scrolling columns, each with its own inner layout, plus a "lock" that sends
-- new windows into one column. Written to be Lua 5.1 compatible.
local cfg = {
  col_width       = 0.5,   -- default column width (fraction of the work area)
  center          = false, -- true: centre the focused column, false: left-align it
  accordion_strip = 0.12,  -- height fraction for each unfocused window in accordion
  master_ratio    = 0.6,
}

local MODES = { "rows", "grid", "master", "accordion" }

local win_col = {}  -- window stable_id -> column id
local cols    = {}  -- column id -> { pos, mode, width, seen, focus_win }
local next_id = 1
local tick    = 0
local locked        -- column that new windows are forced into (nil = off)

local function active_id()
  local w = hl.get_active_window()
  return w and w.stable_id or nil
end

local function notify(text)
  if hl.notification and hl.notification.create then
    pcall(hl.notification.create, { text = text, timeout = 1500 })
  end
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
local function build(ctx)
  local groups, fresh, orphans = {}, {}, {}

  for _, t in ipairs(ctx.targets) do
    local id = t.window and t.window.stable_id
    if not id then
      table.insert(orphans, t)
    elseif win_col[id] and cols[win_col[id]] then
      local cid = win_col[id]
      groups[cid] = groups[cid] or {}
      table.insert(groups[cid], t)
    else
      table.insert(fresh, t)
    end
  end

  local function sorted()
    local list = {}
    for cid, ts in pairs(groups) do table.insert(list, { id = cid, ts = ts }) end
    table.sort(list, function(a, b) return cols[a.id].pos < cols[b.id].pos end)
    return list
  end

  for _, t in ipairs(fresh) do
    local wid = t.window.stable_id
    if locked and groups[locked] then
      win_col[wid] = locked
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
      local cid = new_col(pos)
      win_col[wid] = cid
      groups[cid] = { t }
      touch(cid, wid)  -- next new window lands after this one
    end
  end

  local list, index = sorted(), {}
  for i, c in ipairs(list) do index[c.id] = i end

  -- windows with no window object: park them in the first column
  if list[1] then
    for _, t in ipairs(orphans) do table.insert(list[1].ts, t) end
  end

  local aid = active_id()
  if aid and win_col[aid] and groups[win_col[aid]] then touch(win_col[aid], aid) end

  return list, index
end

-- Inner layouts: place targets `ts` inside box `b`.
local inner = {}

function inner.rows(ts, b)
  local h = b.h / #ts
  for i, t in ipairs(ts) do
    t:place({ x = b.x, y = b.y + (i - 1) * h, w = b.w, h = h })
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

local function recalculate(ctx)
  if #ctx.targets == 0 then return end
  local list = build(ctx)
  if #list == 0 then return end
  local a = ctx.area

  local total = 0
  for _, c in ipairs(list) do total = total + cols[c.id].width * a.w end
  local scale = total < a.w and a.w / total or 1   -- stretch to fill spare room

  local x, left, width = 0, {}, {}
  for i, c in ipairs(list) do
    left[i] = x
    width[i] = cols[c.id].width * a.w * scale
    x = x + width[i]
  end

  local f = focused(list)
  local shift = cfg.center and ((a.w - width[f]) / 2 - left[f]) or -left[f]
  shift = math.max(math.min(shift, 0), math.min(0, a.w - x))  -- don't scroll past the ends

  for i, c in ipairs(list) do
    local col = cols[c.id]
    local box = { x = a.x + left[i] + shift, y = a.y, w = width[i], h = a.h }
    local focus = 1
    for j, t in ipairs(c.ts) do
      if t.window and t.window.stable_id == col.focus_win then focus = j end
    end
    local fn = inner[col.mode] or inner.rows
    fn(c.ts, box, focus)
  end
end

local function layout_msg(ctx, msg)
  local list = build(ctx)
  if #list == 0 then return false end

  local f = focused(list)
  local cur = list[f]
  local col = cols[cur.id]
  local aid = active_id()
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

  elseif cmd == "consume" then
    local nb = list[f + (arg == "left" and -1 or 1)]
    if nb and aid and win_col[aid] == cur.id then
      win_col[aid] = nb.id
      touch(nb.id, aid)
    end
    return true

  elseif cmd == "expel" then
    if aid and win_col[aid] == cur.id and #cur.ts > 1 then
      local nxt = list[f + 1] and cols[list[f + 1].id].pos
      local cid = new_col(nxt and (col.pos + nxt) / 2 or col.pos + 1)
      win_col[aid] = cid
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
  for _, w in ipairs(hl.get_windows()) do alive[w.stable_id] = true end
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

-- Recalculation isn't triggered by focus changes, so nudge it.
hl.on("window.active", function()
  hl.dispatch(hl.dsp.layout("refresh"))
end)
hl.on("window.destroy", function() pcall(gc) end)

hl.config({ general = { layout = "lua:scrollcols" } })
