-- cspell:disable
function Quoted(el)
    local NNBSP = '\u{00A0}'
    local inlines = el.content
    local open_quote, close_quote

    if el.quotetype == "DoubleQuote" then
        open_quote  = pandoc.Str("«")
        close_quote = pandoc.Str("»")
    elseif el.quotetype == "SingleQuote" then
        open_quote  = pandoc.Str("‹")
        close_quote = pandoc.Str("›")
    else
        return el
    end

    -- Insert opening mark and narrow NBSP at the start
    table.insert(inlines, 1, pandoc.Str(NNBSP))
    table.insert(inlines, 1, open_quote)

    -- Append narrow NBSP and closing mark at the end
    table.insert(inlines, pandoc.Str(NNBSP))
    table.insert(inlines, close_quote)

    return inlines
end