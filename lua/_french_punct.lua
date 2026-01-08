-- cspell:disable
-- Adpapted from:
-- Copyright: © 2022 Christopher Fuhrman
-- License: MIT – see LICENSE for details
function Inlines(inlines)
    local i = 1
    local ascii_punctuation_pattern = '[;!%?%%:]'
    -- local nbsp = '\u{202f}'
    local nbsp = '\u{00A0}'
    while inlines[i] do
        if inlines[i].t == 'Str' then
            if string.len(inlines[i].text) > 1 and string.match(inlines[i].text:sub(-1), ascii_punctuation_pattern) then
                -- insert nbsp before last char
                inlines[i].text = inlines[i].text:sub(1, -2) .. nbsp .. inlines[i].text:sub(-1)
            end
            -- unicode is a problem in patterns, so we just brute force it?
            inlines[i].text = string.gsub(inlines[i].text, "€", nbsp .. "€")
            -- inlines[i].text = string.gsub(inlines[i].text, "»", nbsp .. "»")
            -- inlines[i].text = string.gsub(inlines[i].text, "«", "«" .. nbsp)
        end
        -- special cases where punctuation can follow
        if inlines[i+1]
            and (inlines[i].t == 'Quoted'
                or inlines[i].t == 'Cite'
                or inlines[i].t == 'Link'
                or inlines[i].t == 'Emph'
                or inlines[i].t == 'Strong'
                or inlines[i].t == 'Strikeout'
                or inlines[i].t == 'Code'
                or inlines[i].t == 'RawInline'
                or (inlines[i].t == 'Str' and inlines[i].text:match("»%s*$"))
            )
            and inlines[i+1].t == 'Str'
            and inlines[i+1].text:match(ascii_punctuation_pattern) then
                inlines[i+1].text = nbsp .. inlines[i+1].text
            -- skip the item we just spaced
            i = i + 1
        end
        i = i + 1
    end
    return inlines
end
