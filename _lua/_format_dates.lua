-- cspell:disable
local current_locale = nil
local lang_map = {
  fr = "fr_FR.UTF-8",
  en = "en_US.UTF-8",
  el = "el_GR.UTF-8",
}

-- Read YAML metadata to pick the locale
function Meta(meta)
  if meta['lang'] then
    local lang = pandoc.utils.stringify(meta['lang'])
    if lang and lang_map[lang] then
      current_locale = lang_map[lang]
    else
      current_locale = nil
    end
  end
end

-- Format inline date spans
function Span(el)
  -- Only process spans with class "date"
  if not el.classes:includes("date") then
    return nil
  end

  -- Extract ISO date text
  local text = pandoc.utils.stringify(el.content)
  local y, m, d = text:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")

  -- Validate components before using them
  if not (y and m and d) then
    return nil
  end

  -- Explicit integer conversions
  local yi = tonumber(y) or 0
  local mi = tonumber(m) or 1
  local di = tonumber(d) or 1

  -- Apply locale (fallback if not available)
  pcall(function() os.setlocale(current_locale) end)


  -- Build a safe timestamp
  local timestamp = os.time({
    year  = yi,
    month = mi,
    day   = di,
    hour  = 12
  })

  -- Localized "day month year"
  local formatted = os.date("%e %B %Y", timestamp)
    -- Trim leading space from %e
    -- formatted = formatted:gsub("^%s+", "")

  return pandoc.Span(formatted)
end

return {
  { Meta = Meta },
  { Span = Span }
}