-- =============================================================================
-- tex.lua  –  LuaSnip snippets for LaTeX
-- Replaces UltiSnips tex.snippets entirely
-- =============================================================================

local ls   = require("luasnip")
local s    = ls.snippet
local sn   = ls.snippet_node
local t    = ls.text_node
local i    = ls.insert_node
local d    = ls.dynamic_node
local f    = ls.function_node
local c    = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep  = require("luasnip.extras").rep
local as   = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

-- =============================================================================
-- CONDITIONS  (using your conditions.lua, not conds.in_math)
-- =============================================================================
local conds_ok, conds_mod = pcall(require, "conditions")
local in_math    = conds_ok and conds_mod.in_math    or function() return true end
local in_tikz    = conds_ok and conds_mod.in_tikz    or function() return false end
local in_bullets = conds_ok and conds_mod.in_bullets or function() return false end
local in_text    = conds_ok and conds_mod.in_text    or function() return true end

-- =============================================================================
-- HELPERS
-- =============================================================================
local function get_visual(_, parent)
    local sel = parent.snippet.env.SELECT_RAW
    if sel and #sel > 0 then
        return sn(nil, t(sel))
    end
    return sn(nil, i(1))
end

-- =============================================================================
-- SNIPPET TABLE
-- =============================================================================
local tex = {}

-- ---------------------------------------------------------------------------
-- QUESTION TAGS
-- ---------------------------------------------------------------------------
table.insert(tex, s(
    { trig = "ptag", name = "Physics Tag" },
    fmta("% SUB: PH | CH: <> | MK: <> | D: <> | T: <>", {
        i(1, "Kinematics1D"),
        i(2, "3"),
        c(3, { t("L1"), t("L2"), t("L3"), t("L4") }),
        c(4, { t("NUM"), t("REG"), t("CF"), t("MCQ"), t("DIA"), t("APP"), t("DEV") }),
    })
))

table.insert(tex, s(
    { trig = "mtag", name = "Math Tag" },
    fmta("% SUB: MA | CH: <> | MK: <> | D: <> | T: <>", {
        i(1, "Algebra"),
        i(2, "4"),
        c(3, { t("L1"), t("L2"), t("L3"), t("L4") }),
        c(4, { t("NUM"), t("REG"), t("MCQ"), t("APP"), t("DEV") }),
    })
))

-- ---------------------------------------------------------------------------
-- ENVIRONMENTS
-- ---------------------------------------------------------------------------

-- Generic begin/end  (beg – muscle memory from UltiSnips)
table.insert(tex, s(
    { trig = "beg", name = "begin/end block" },
    fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1), i(0), rep(1) })
))

-- Quick environment chooser  (env)
-- FIX: args[1][1] not args[1]
local common_envs = {
    t("enumerate"), t("itemize"), t("center"),
    t("tikzpicture"), t("subparts"), t("align*"),
}
table.insert(tex, s(
    { trig = "env", name = "Common environment chooser" },
    fmta("\\begin{<>}\n\t<>\n\\end{<>}", {
        c(1, common_envs),
        i(0),
        f(function(args) return args[1][1] end, { 1 }),   -- BUG FIX
    })
))

-- enumerate  (enum)
table.insert(tex, s(
    { trig = "enum", name = "Enumerate" },
    fmta("\\begin{enumerate}\n\t\\item <>\n\\end{enumerate}", { i(0) })
))

-- itemize  (item)
table.insert(tex, s(
    { trig = "item", name = "Itemize" },
    fmta("\\begin{itemize}\n\t\\item <>\n\\end{itemize}", { i(0) })
))

-- description
table.insert(tex, s(
    { trig = "desc", name = "Description" },
    fmta("\\begin{description}\n\t\\item[<>] <>\n\\end{description}", { i(1), i(0) })
))

-- align*  (ali)
table.insert(tex, s(
    { trig = "ali", name = "Align*" },
    fmta("\\begin{align*}\n\t<>\n\\end{align*}", { i(1) })
))

-- ---------------------------------------------------------------------------
-- BOXES  (sagar-boxes.sty custom environments)
-- ---------------------------------------------------------------------------

-- definition box
table.insert(tex, s(
    { trig = "bbox-def", name = "Definition box" },
    fmta("\\begin{definition}{<>}\n\t<>\n\\end{definition}", { i(1, "Title"), i(0) })
))

-- theorem box
table.insert(tex, s(
    { trig = "bbox-thm", name = "Theorem box" },
    fmta("\\begin{theorem}{<>}\n\t<>\n\\end{theorem}", { i(1, "Title"), i(0) })
))

-- example box with optional solution inside
table.insert(tex, s(
    { trig = "bbox-eg", name = "Example box" },
    fmta("\\begin{example}{<>}\n\t<>\n\t\\begin{Mysolutionbox}\n\t\t<>\n\t\\end{Mysolutionbox}\n\\end{example}", {
        i(1, "Title"), i(2, "Question"), i(0)
    })
))

-- example box without solution
table.insert(tex, s(
    { trig = "bbox-egx", name = "Example box (no solution)" },
    fmta("\\begin{example}{<>}\n\t<>\n\\end{example}", { i(1, "Title"), i(0) })
))

-- note box
table.insert(tex, s(
    { trig = "bbox-note", name = "Note box" },
    fmta("\\begin{noteBox}\n\t<>\n\\end{noteBox}", { i(0) })
))

-- important box
table.insert(tex, s(
    { trig = "bbox-imp", name = "Important box" },
    fmta("\\begin{important}\n\t<>\n\\end{important}", { i(0) })
))

-- error box
table.insert(tex, s(
    { trig = "bbox-err", name = "Error/Common mistake box" },
    fmta("\\begin{errorbox}\n\tDo NOT write: $<>$\n\\end{errorbox}", { i(0) })
))

-- solution box
table.insert(tex, s(
    { trig = "bbox-sol", name = "Solution box" },
    fmta("\\begin{Mysolutionbox}\n\t<>\n\\end{Mysolutionbox}", { i(0) })
))

-- answer box
table.insert(tex, s(
    { trig = "bbox-ans", name = "Answer box" },
    fmta("\\begin{Answer}\n\t<>\n\\end{Answer}", { i(0) })
))

-- hint box
table.insert(tex, s(
    { trig = "bbox-hint", name = "Hint box" },
    fmta("\\begin{hintbox}\n\t<>\n\\end{hintbox}", { i(0) })
))

-- teaching tip box
table.insert(tex, s(
    { trig = "bbox-tip", name = "Teaching tip box" },
    fmta("\\begin{teachingtip}\n\t<>\n\\end{teachingtip}", { i(0) })
))

-- choice node version: pick any box type from one trigger
table.insert(tex, s(
    { trig = "bbox", name = "Box chooser" },
    fmta("\\begin{<>}\n\t<>\n\\end{<>}", {
        c(1, {
            t("noteBox"),
            t("important"),
            t("errorbox"),
            t("teachingtip"),
            t("hintbox"),
            t("Mysolutionbox"),
            t("Answer"),
        }),
        i(2),
        f(function(args) return args[1][1] end, { 1 }),
    })
))

-- ---------------------------------------------------------------------------
-- ENVIRONMENTS
-- ---------------------------------------------------------------------------

-- center
table.insert(tex, s(
    { trig = "envcentre", name = "Center environment" },
    fmta("\\begin{center}\n\t<>\n\\end{center}", { i(0) })
))

-- parts  (exam.cls)
table.insert(tex, s(
    { trig = "envparts", name = "Parts environment" },
    fmta("\\begin{parts}\n\t\\part[<>] <> \\droppoints\n\\end{parts}", { i(1, "4"), i(0) })
))

-- subparts  (exam.cls)
table.insert(tex, s(
    { trig = "envsubparts", name = "Subparts environment" },
    fmta("\\begin{subparts}\n\t\\subpart[<>] <>\n\\end{subparts}", { i(1, "2"), i(0) })
))

-- tikzpicture standalone
table.insert(tex, s(
    { trig = "envtikz", name = "tikzpicture environment" },
    fmta("\\begin{tikzpicture}\n\t<>\n\\end{tikzpicture}", { i(0) })
))

-- tikzpicture inside figure
table.insert(tex, s(
    { trig = "envtikzfig", name = "tikzpicture in figure" },
    fmta([[
\begin{figure}[<>]
    \centering
    \begin{tikzpicture}
        <>
    \end{tikzpicture}
    \caption{<>}
    \label{fig:<>}
\end{figure}]], { i(1, "ht"), i(0), i(2, "Caption"), i(3, "label") })
))

-- axis / pgfplots inside tikzpicture
table.insert(tex, s(
    { trig = "envaxis", name = "pgfplots axis" },
    fmta([[
\begin{tikzpicture}
    \begin{axis}[
        axis lines = middle,
        xlabel = {$<>$},
        ylabel = {$<>$},
        xmin = <>, xmax = <>,
        ymin = <>, ymax = <>,
        samples = 200,
        grid = major,
    ]
        \addplot[<>]{<>};
    \end{axis}
\end{tikzpicture}]], {
        i(1, "x"), i(2, "y"),
        i(3, "-5"), i(4, "5"),
        i(5, "-2"), i(6, "10"),
        i(7, "blue, thick"), i(8, "x^2"),
    })
))

-- multicols
table.insert(tex, s(
    { trig = "envcols", name = "Multicols" },
    fmta("\\begin{multicols}{<>}\n\t<>\n\\end{multicols}", { i(1, "2"), i(0) })
))

-- minipage
table.insert(tex, s(
    { trig = "envmini", name = "Minipage" },
    fmta("\\begin{minipage}{<>\\textwidth}\n\t<>\n\\end{minipage}", { i(1, "0.5"), i(0) })
))

-- two minipages side by side
table.insert(tex, s(
    { trig = "envmini2", name = "Two minipages side by side" },
    fmta([[
\begin{minipage}{<>\textwidth}
    <>
\end{minipage}%
\hfill
\begin{minipage}{<>\textwidth}
    <>
\end{minipage}]], { i(1, "0.48"), i(2), i(3, "0.48"), i(0) })
))

-- questions  (exam.cls)
table.insert(tex, s(
    { trig = "envquestions", name = "Questions environment" },
    fmta("\\begin{questions}\n\t\\question[<>] <> \\droppoints\n\\end{questions}", { i(1, "4"), i(0) })
))

-- oneparchoices  (exam.cls MCQ)
table.insert(tex, s(
    { trig = "envchoices", name = "MCQ oneparchoices" },
    fmta([[
\begin{oneparchoices}
    \choice <>
    \choice <>
    \choice <>
    \choice <>
\end{oneparchoices}]], { i(1, "A"), i(2, "B"), i(3, "C"), i(4, "D") })
))

-- tabular
table.insert(tex, s(
    { trig = "envtab", name = "Tabular" },
    fmta("\\begin{tabular}{<>}\n\t\\toprule\n\t<> \\\\\\\\\n\t\\midrule\n\t<> \\\\\\\\\n\t\\bottomrule\n\\end{tabular}", {
        i(1, "c c c"), i(2, "H1 & H2 & H3"), i(0)
    })
))

-- ---------------------------------------------------------------------------
-- FLAGS  (sagar-notes.sty)
-- ---------------------------------------------------------------------------

-- \hint{}
table.insert(tex, s(
    { trig = "flhint", name = "Hint flag" },
    fmta("\\hint{<>}", { i(0) })
))

-- \ans{}
table.insert(tex, s(
    { trig = "flans", name = "Answer flag" },
    fmta("\\ans{<>}", { i(0) })
))

-- \trs{}  teacher-only
table.insert(tex, s(
    { trig = "fltrs", name = "Teacher-only flag" },
    fmta("\\trs{<>}", { i(0) })
))

-- \teacheronly{} inline
table.insert(tex, s(
    { trig = "fltonly", name = "teacheronly inline" },
    fmta("\\teacheronly{<>}", { i(0) })
))

-- \answeronly{} inline
table.insert(tex, s(
    { trig = "flaonly", name = "answeronly inline" },
    fmta("\\answeronly{<>}", { i(0) })
))

-- full teacher/student mode switch block
table.insert(tex, s(
    { trig = "flmode", name = "Mode switch comment block" },
    fmta([[
%\\teachermode   % uncomment for teacher version
\\studentmode    % uncomment for student version
]], {})
))


-- figure
table.insert(tex, s(
    { trig = "fig", name = "Figure environment" },
    fmta([[
\begin{figure}[<>]
	\centering
	\includegraphics[width=0.8\textwidth]{<>}
	\caption{<>}
	\label{fig:<>}
\end{figure}]], { i(1, "htpb"), i(2), i(3), i(4) })
))

-- table (tblr)
table.insert(tex, s(
    { trig = "stbl", name = "Simple table (tabular)" },
    fmta([[
\begin{table}[<>]
    \centering
    \begin{tabular}{<>}
        \hline
        <> \\
        \hline
        <> \\
        \hline
    \end{tabular}
    \caption{<>}
    \label{tab:<>}
\end{table}
]], {
        i(1, "ht"),
        i(2, "c c c"),
        i(3, "Header1 & Header2 & Header3"),
        i(4, "Data1 & Data2 & Data3"),
        i(5, "Caption"),
        i(6, "label"),
    })
))

table.insert(tex, s(
    { trig = "ptbl", name = "Professional table (tblr)" },
    fmta([[
\begin{table}[<>]
    \centering
    \caption{<>}
    \label{tab:<>}
    \begin{tblr}{
        colspec = {<>},
        row{1} = {bg=primaryblue!80!black, fg=white, font=\sffamily\bfseries},
        row{odd} = {bg=backgroundgray},
    }
        <> \\
        <>
    \end{tblr}
\end{table}
]], {
        i(1, "ht"),
        i(2, "Caption"),
        i(3, "label"),
        i(4, "c c c"),
        i(5, "Header1 & Header2 & Header3"),
        i(6, "Data1 & Data2 & Data3"),
    })
))

-- package
table.insert(tex, s(
    { trig = "pac", name = "usepackage" },
    fmta("\\usepackage[<>]{<>}<>", { i(1, "options"), i(2, "package"), i(0) })
))

-- ---------------------------------------------------------------------------
-- MATH WRAPPERS  (highest priority – typed constantly)
-- ---------------------------------------------------------------------------

-- mk  →  \( \displaystyle ... \)   inline with full-size fractions
table.insert(tex, as(
    { trig = "mk", name = "Inline math (displaystyle)" },
    fmta("\\( \\displaystyle <> \\)<>", { i(1), i(0) })
))

-- ml  →  \( ... \)   plain inline math
table.insert(tex, as(
    { trig = "ml", name = "Inline math" },
    fmta("\\( <> \\)<>", { i(1), i(0) })
))

-- dm  →  display math block
table.insert(tex, as(
    { trig = "dm", name = "Display math" },
    fmta("\\[\n\t<>\n\\]<>", { i(1), i(0) })
))

-- ---------------------------------------------------------------------------
-- MATH SNIPPETS  (all gated behind your conditions.lua in_math)
-- ---------------------------------------------------------------------------
local math_snips = {

    -- Fraction  ff  (visual-aware)
    s({ trig = "ff", name = "Fraction", snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}", { d(1, get_visual), i(2) }),
        { condition = in_math }),

    -- Summation
    s({ trig = "sum", name = "Summation" },
        fmta("\\sum_{<>}^{<>}<>", { i(1, "i=1"), i(2, "n"), i(0) }),
        { condition = in_math }),

    -- Integral
    s({ trig = "dint", name = "Integral", snippetType = "autosnippet" },
        fmta("\\int_{<>}^{<>} <> \\, d<>", { i(1, "-\\infty"), i(2, "\\infty"), i(3), i(4, "x") }),
        { condition = in_math }),

    -- Limit
    s({ trig = "lim", name = "Limit" },
        fmta("\\lim_{<> \\to <>} ", { i(1, "n"), i(2, "\\infty") }),
        { condition = in_math }),

    -- Partial derivative
    s({ trig = "part", name = "Partial derivative" },
        fmta("\\frac{\\partial <>}{\\partial <>}<>", { i(1, "V"), i(2, "x"), i(0) }),
        { condition = in_math }),

    -- Matrix  bmat
    s({ trig = "bmat", name = "bmatrix" },
        fmta("\\begin{bmatrix}\n\t<> & <> \\\\\\\\\n\t<> & <>\n\\end{bmatrix}", { i(1), i(2), i(3), i(4) }),
        { condition = in_math }),

    -- pmat
    s({ trig = "pmat", name = "pmatrix", snippetType = "autosnippet" },
        fmta("\\begin{pmatrix} <> \\end{pmatrix}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- cases
    s({ trig = "case", name = "cases", snippetType = "autosnippet" },
        fmta("\\begin{cases}\n\t<>\n\\end{cases}", { i(1) }),
        { condition = in_math }),

    -- Infinity  000
    s({ trig = "000", name = "infinity", snippetType = "autosnippet" },
        t("\\infty"),
        { condition = in_math }),

    -- ldots
    s({ trig = "ld..", name = "ldots", snippetType = "autosnippet" },
        t("\\ldots"),
        { condition = in_math }),

    -- implies  ->
    s({ trig = "->", name = "implies", snippetType = "autosnippet" },
        t("\\implies"),
        { condition = in_math }),

    -- iff
    s({ trig = "iff", name = "iff", snippetType = "autosnippet" },
        t("\\iff"),
        { condition = in_math }),

    -- times  xx
    s({ trig = "xx", name = "times", snippetType = "autosnippet" },
        t("\\times "),
        { condition = in_math }),

    -- cdot  **
    s({ trig = "**", name = "cdot", snippetType = "autosnippet" },
        t("\\cdot "),
        { condition = in_math }),

    -- equals  ==
    s({ trig = "==", name = "aligned equals", snippetType = "autosnippet" },
        t("&= "),
        { condition = in_math }),

    -- ampersand  aaa
    s({ trig = "aaa", name = "ampersand", snippetType = "autosnippet" },
        t("& "),
        { condition = in_math }),

    -- text in math  tt
    s({ trig = "tt", name = "text in math", snippetType = "autosnippet" },
        fmta("\\text{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- sqrt  zsq
    s({ trig = "zsq", name = "sqrt", snippetType = "autosnippet" },
        fmta("\\sqrt{<>}", { d(1, get_visual) }),
        { condition = in_math }),

    -- superscript 2  sr
    s({ trig = "sr", name = "^2", snippetType = "autosnippet", wordTrig = false },
        t("^2"),
        { condition = in_math }),

    -- superscript 3  cb
    s({ trig = "cb", name = "^3", snippetType = "autosnippet", wordTrig = false },
        t("^3"),
        { condition = in_math }),

    -- to the power  td
    s({ trig = "td", name = "^{...}", snippetType = "autosnippet", wordTrig = false },
        fmta("^{<>}", { i(1) }),
        { condition = in_math }),

    -- subscript  __
    s({ trig = "__", name = "subscript", snippetType = "autosnippet" },
        fmta("_{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- overline / bar
    s({ trig = "bar", name = "overline", snippetType = "autosnippet" },
        fmta("\\overline{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- hat
    s({ trig = "hat", name = "hat", snippetType = "autosnippet" },
        fmta("\\hat{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- vec
    s({ trig = "vec", name = "vec", snippetType = "autosnippet" },
        fmta("\\vec{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- norm
    s({ trig = "norm", name = "norm", snippetType = "autosnippet" },
        fmta("\\|<>\\|<>", { i(1), i(0) }),
        { condition = in_math }),

    -- conjugate  conj
    s({ trig = "conj", name = "conjugate", snippetType = "autosnippet" },
        fmta("\\overline{<>}<>", { i(1), i(0) }),
        { condition = in_math }),

    -- Trig functions
    s({ trig = "zsin", name = "sin", snippetType = "autosnippet" },
        fmta("\\sin{<>}<>", { i(1), i(0) }), { condition = in_math }),
    s({ trig = "zcos", name = "cos", snippetType = "autosnippet" },
        fmta("\\cos{<>}<>", { i(1), i(0) }), { condition = in_math }),
    s({ trig = "ztan", name = "tan", snippetType = "autosnippet" },
        fmta("\\tan{<>}<>", { i(1), i(0) }), { condition = in_math }),
    s({ trig = "zcot", name = "cot", snippetType = "autosnippet" },
        fmta("\\cot{<>}<>", { i(1), i(0) }), { condition = in_math }),
    s({ trig = "zsec", name = "sec", snippetType = "autosnippet" },
        fmta("\\sec{<>}<>", { i(1), i(0) }), { condition = in_math }),

    -- Inverse trig
    s({ trig = "asin", name = "arcsin", snippetType = "autosnippet" },
        fmta("\\sin^{-1}(<>)", { i(1) }), { condition = in_math }),
    s({ trig = "acos", name = "arccos", snippetType = "autosnippet" },
        fmta("\\cos^{-1}(<>)", { i(1) }), { condition = in_math }),
    s({ trig = "atan", name = "arctan", snippetType = "autosnippet" },
        fmta("\\tan^{-1}(<>)", { i(1) }), { condition = in_math }),

    -- Set notation
    s({ trig = "inn", name = "in", snippetType = "autosnippet" },
        t("\\in "), { condition = in_math }),
    s({ trig = "notin", name = "not in", snippetType = "autosnippet" },
        t("\\not\\in "), { condition = in_math }),
    s({ trig = "cc", name = "subset", snippetType = "autosnippet" },
        t("\\subset "), { condition = in_math }),
    s({ trig = "set", name = "set", snippetType = "autosnippet" },
        fmta("\\{<>\\}<>", { i(1), i(0) }), { condition = in_math }),

    -- Brackets (work in math, useful everywhere)
    s({ trig = "ceil", name = "ceil", snippetType = "autosnippet" },
        fmta("\\left\\lceil <> \\right\\rceil<>", { i(1), i(0) }), { condition = in_math }),
    s({ trig = "floor", name = "floor", snippetType = "autosnippet" },
        fmta("\\left\\lfloor <> \\right\\rfloor<>", { i(1), i(0) }), { condition = in_math }),

    -- Arrows
    s({ trig = "!>", name = "mapsto", snippetType = "autosnippet" },
        t("\\mapsto "), { condition = in_math }),
    s({ trig = "<->", name = "leftrightarrow", snippetType = "autosnippet" },
        t("\\leftrightarrow"), { condition = in_math }),
    s({ trig = "=>", name = "implies (=>)", snippetType = "autosnippet" },
        t("\\implies"), { condition = in_math }),
    s({ trig = "=<", name = "impliedby", snippetType = "autosnippet" },
        t("\\impliedby"), { condition = in_math }),

    -- Comparison
    s({ trig = "<=", name = "leq", snippetType = "autosnippet" },
        t("\\le "), { condition = in_math }),
    s({ trig = ">=", name = "geq", snippetType = "autosnippet" },
        t("\\ge "), { condition = in_math }),
    s({ trig = "!=", name = "neq", snippetType = "autosnippet" },
        t("\\neq "), { condition = in_math }),
    s({ trig = ">>", name = "gg", snippetType = "autosnippet" },
        t("\\gg"), { condition = in_math }),
    s({ trig = "<<", name = "ll", snippetType = "autosnippet" },
        t("\\ll"), { condition = in_math }),
    s({ trig = "~~", name = "sim", snippetType = "autosnippet" },
        t("\\sim "), { condition = in_math }),

    -- Quantifiers
    s({ trig = "EE", name = "exists", snippetType = "autosnippet" },
        t("\\exists "), { condition = in_math }),
    s({ trig = "AA", name = "forall", snippetType = "autosnippet" },
        t("\\forall "), { condition = in_math }),

    -- Calculus shorthands
    s({ trig = "ooo", name = "infty", snippetType = "autosnippet" },
        t("\\infty"), { condition = in_math }),

    -- mathcal
    s({ trig = "mcal", name = "mathcal", snippetType = "autosnippet" },
        fmta("\\mathcal{<>}<>", { i(1), i(0) }), { condition = in_math }),

    -- nabla
    s({ trig = "nabl", name = "nabla", snippetType = "autosnippet" },
        t("\\nabla "), { condition = in_math }),

    -- Taylor / product / limsup
    s({ trig = "taylor", name = "Taylor series" },
        fmta("\\sum_{<>}^{<>} <> (x-a)^<> <> ", { i(1, "k"), i(2, "\\infty"), i(3, "c_k"), rep(1), i(0) }),
        { condition = in_math }),
    s({ trig = "prod", name = "Product" },
        fmta("\\prod_{<>}^{<>} <> ", { i(1, "n=1"), i(2, "\\infty"), i(0) }),
        { condition = in_math }),

    -- Italics (outside math too)
    s({ trig = "tii", name = "textit", snippetType = "autosnippet" },
        fmta("\\textit{<>}<>", { i(1), i(0) })),
}

for _, snip in ipairs(math_snips) do
    table.insert(tex, snip)
end

-- ---------------------------------------------------------------------------
-- BRACKETS  (auto, math context)
-- ---------------------------------------------------------------------------
local brackets = {
    { trig = "lr(",  fmt = "\\left( <> \\right)<>" },
    { trig = "lr[",  fmt = "\\left[ <> \\right]<>" },
    { trig = "lr{",  fmt = "\\left\\{ <> \\right\\}<>" },
    { trig = "lr|",  fmt = "\\left| <> \\right|<>" },
    { trig = "lra",  fmt = "\\left\\langle <> \\right\\rangle<>" },
}
for _, b in ipairs(brackets) do
    table.insert(tex, as({ trig = b.trig }, fmta(b.fmt, { i(1), i(0) })))
end

-- ---------------------------------------------------------------------------
-- GREEK LETTERS  (auto, semicolon prefix – safe outside math too)
-- ---------------------------------------------------------------------------
local greek = {
    { trig = ";a",  txt = "alpha"   }, { trig = ";b",  txt = "beta"    },
    { trig = ";g",  txt = "gamma"   }, { trig = ";G",  txt = "Gamma"   },
    { trig = ";l",  txt = "lambda"  }, { trig = ";L",  txt = "Lambda"  },
    { trig = ";p",  txt = "pi"      }, { trig = ";P",  txt = "Pi"      },
    { trig = ";D",  txt = "Delta"   }, { trig = ";d",  txt = "delta"   },
    { trig = ";w",  txt = "omega"   }, { trig = ";W",  txt = "Omega"   },
    { trig = ";s",  txt = "sigma"   }, { trig = ";S",  txt = "Sigma"   },
    { trig = ";h",  txt = "theta"   }, { trig = ";T",  txt = "Theta"   },
    { trig = ";f",  txt = "phi"     }, { trig = ";F",  txt = "Phi"     },
    { trig = ";e",  txt = "epsilon" }, { trig = ";r",  txt = "rho"     },
    { trig = ";m",  txt = "mu"      }, { trig = ";n",  txt = "nu"      },
    { trig = ";x",  txt = "xi"      }, { trig = ";c",  txt = "chi"     },
    { trig = ";k",  txt = "kappa"   }, { trig = ";z",  txt = "zeta"    },
}
for _, g in ipairs(greek) do
    table.insert(tex, as({ trig = g.trig, name = g.txt }, t("\\" .. g.txt)))
end

-- ---------------------------------------------------------------------------
-- SIMPLE TEXT COMMANDS  (auto)
-- ---------------------------------------------------------------------------
local commands = {
    { trig = "-e",  text = "\\item "    },
    { trig = "-p",  text = "\\part"     },
    { trig = "-sp", text = "\\subpart"  },
}
for _, cmd in ipairs(commands) do
    table.insert(tex, as({ trig = cmd.trig, name = cmd.text }, t(cmd.text)))
end

-- ---------------------------------------------------------------------------
-- SI UNITS
-- ---------------------------------------------------------------------------
local si_snippets = {
    { trig = "1SI", name = "m/s",   text = "\\SI{<>}{\\meter \\per \\second}<>",          nodes = { i(1), i(0) } },
    { trig = "2SI", name = "m/s²",  text = "\\SI{<>}{\\meter \\per \\second\\squared}<>", nodes = { i(1), i(0) } },
    { trig = "3SI", name = "cm",    text = "\\SI{<>}{\\centi\\meter}<>",                  nodes = { i(1), i(0) } },
    { trig = "SI",  name = "custom",text = "\\SI{<>}{<>}<>",                              nodes = { i(1), i(2), i(0) } },
}
for _, sni in ipairs(si_snippets) do
    table.insert(tex, as({ trig = sni.trig, name = sni.name }, fmta(sni.text, sni.nodes)))
end

-- ---------------------------------------------------------------------------
-- DIMENSIONAL ANALYSIS
-- ---------------------------------------------------------------------------
table.insert(tex, s(
    { trig = "dimn", name = "Dimensional formula" },
    fmta("$ [M^{<>} \\; L^{<>} \\; T^{<>}] $ <>", { i(1,"0"), i(2,"1"), i(3,"-1"), i(0) })
))

-- ---------------------------------------------------------------------------
-- SCHOOL / TEMPLATE SNIPPETS
-- ---------------------------------------------------------------------------
table.insert(tex, s(
    { trig = "CAJCS", name = "School name" },
    t("\\textbf{\\textcolor{purple}{\\Large{ The Cathedral and John Connon School}}} \\\\")
))

table.insert(tex, s(
    { trig = "CAJCS_Logo", name = "School logo" },
    t("\\includegraphics[scale=0.4]{clogo} \\\\")
))

-- Image snippets
table.insert(tex, s(
    { trig = ";image_scale", name = "Image (scale)" },
    fmta("\\begin{center}\n\t\\includegraphics[scale=<>]{<>}\n\\end{center}", { i(1, "0.5"), i(2) })
))

table.insert(tex, s(
    { trig = ";image_width", name = "Image (width)" },
    fmta("\\begin{center}\n\t\\includegraphics[width=<>\\textwidth]{<>}\n\\end{center}", { i(1, "0.8"), i(2) })
))

-- ---------------------------------------------------------------------------
-- TEACHER / HINT / ANSWER FLAGS
-- ---------------------------------------------------------------------------
table.insert(tex, s("teacherflag", t({
    "\\newif\\ifteacher",
    "%\\teachertrue      % Teacher version",
    "\\teacherfalse   % Student version",
})))

table.insert(tex, s("teacherflag2",
    fmta("\\ifteacher\n<>\n\\fi", { i(1) })
))

table.insert(tex, s("hintflag", t({
    "\\newif\\ifhint",
    "%\\hinttrue      % Version with hint",
    "\\hintfalse   % Version without hint",
})))

table.insert(tex, s("hintflag2",
    fmta("\\ifhint\n<>\n\\fi", { i(1) })
))

table.insert(tex, s("answerflag", t({
    "\\newif\\ifanswer",
    "%\\answertrue      % Version with answers",
    "\\answerfalse   % Version without answers",
})))

table.insert(tex, s("answerflag2",
    fmta("\\ifanswer\n<>\n\\fi", { i(1) })
))

-- ---------------------------------------------------------------------------
-- UNIT PLAN TEMPLATE
-- ---------------------------------------------------------------------------
table.insert(tex, s(
    { trig = ";unitplan", name = "Unit plan template" },
    fmta([[
{ \Large Grade <> Mathematics Unit Plan: <>}

\textbf{Overview}

<>

\textbf{Enduring Understandings}
\begin{itemize}
	\item
\end{itemize}

\textbf{Essential Questions}
\begin{itemize}
	\item
\end{itemize}

\textbf{Prerequisite Knowledge}
\begin{itemize}
	\item
\end{itemize}

\textbf{Assessment Evidence}
\begin{itemize}
	\item
\end{itemize}

\textbf{Learning Plan}

\textbf{Day 1:}

\textbf{Objectives:}
\begin{itemize}
	\item
\end{itemize}
\textbf{Learning Activities:}
\begin{itemize}
	\item
\end{itemize}
\textbf{DoK Level 2-3 Questions:}
\begin{itemize}
	\item
\end{itemize}
\textbf{Assessment Strategies:}
\begin{itemize}
	\item
\end{itemize}

\textbf{Summary of Lesson}

]], { i(1, "9"), i(2, "Chapter"), i(0) })
))

-- Add unit plan day
table.insert(tex, s(
    { trig = ";uadd_day", name = "Add unit plan day" },
    fmta([[
\textbf{Day <>: <>}

\textbf{Objectives:}
\begin{itemize}
	\item <>
\end{itemize}
\textbf{Learning Activities:}
\begin{itemize}
	\item
\end{itemize}
\textbf{DoK Level 2-3 Questions:}
\begin{itemize}
	\item
\end{itemize}
\textbf{Assessment Strategies:}
\begin{itemize}
	\item
\end{itemize}
]], { i(1, "2"), i(2, "Date"), i(0) })
))

-- ---------------------------------------------------------------------------
-- GRAPH / PGFPLOTS SNIPPETS
-- ---------------------------------------------------------------------------
table.insert(tex, s(
    { trig = "gr-trig01", name = "Trig graph (pgfplots)" },
    t({
        "\\begin{tikzpicture}",
        "    \\begin{axis}[",
        "        axis lines = center,",
        "        xlabel = {$x$}, ylabel = {$y$},",
        "        xmin = -2*pi, xmax = 2*pi,",
        "        ymin = -2, ymax = 2,",
        "        domain = -2*pi:2*pi, samples = 200,",
        "        grid = major,",
        "        xtick = {-6.283,-4.712,-3.141,-1.571,0,1.571,3.141,4.712,6.283},",
        "        xticklabels = {$-2\\pi$,$-\\frac{3\\pi}{2}$,$-\\pi$,$-\\frac{\\pi}{2}$,$0$,$\\frac{\\pi}{2}$,$\\pi$,$\\frac{3\\pi}{2}$,$2\\pi$},",
        "        width = 14cm, height = 9cm,",
        "    ]",
        "    \\addplot[blue, thick] {sin(deg(x))};",
        "    \\addlegendentry{$y = \\sin(x)$}",
        "    \\addplot[red, thick] {cos(deg(x))};",
        "    \\addlegendentry{$y = \\cos(x)$}",
        "    \\end{axis}",
        "\\end{tikzpicture}",
    })
))

table.insert(tex, s(
    { trig = "gr-simple", name = "Simple function plot" },
    fmta([[
\begin{figure}[ht]
	\centering
	\begin{tikzpicture}
		\begin{axis}[
			ymin=<>, ymax=<>,
			axis lines = middle,
		]
		\addplot[domain=<>:<>, samples=200]{<>};
		\end{axis}
	\end{tikzpicture}
	\caption{<>}
	\label{fig:<>}
\end{figure}]], {
        i(1, "-1"), i(2, "10"),
        i(3, "-5"), i(4, "5"),
        i(5, "x^2"),
        i(6, "Graph"), i(7, "graph"),
    })
))

-- ---------------------------------------------------------------------------
-- TIKZ ENVIRONMENT WRAPPER
-- ---------------------------------------------------------------------------
table.insert(tex, as(
    { trig = "tkzz", name = "tikzpicture in figure" },
    fmta([[
\begin{figure}[<>]
\centering
\begin{tikzpicture}
	<>
\end{tikzpicture}
\caption{<>}
\label{<>}
\end{figure}]], { i(1, "ht"), i(0), i(2), i(3) })
))

-- ---------------------------------------------------------------------------
-- TIKZ / tkzEuclide SNIPPETS  (all gated: condition = in_tikz where useful)
-- Note: triggers starting with ;t- are safe – won't fire accidentally
-- ---------------------------------------------------------------------------

-- Points
local tikz_text_snips = {
    { trig = ";t-pt-def",       body = { "\\tkzDefPoints{0/0/O, 2/0/A, 3/2/B}" } },
    { trig = ";t-pt-mid",       body = { "\\tkzDefMidPoint(A,B) \\tkzGetPoint{M}" } },
    { trig = ";t-pt-rotation",  body = { "\\tkzDefPointBy[rotation=center A angle 60](B) \\tkzGetPoint{C}" } },
    { trig = ";t-pt-reflection",body = { "\\tkzDefPointBy[reflection = over C--D](O) \\tkzGetPoint{O'}" } },
    { trig = ";t-pt-projection",body = { "\\tkzDefPointBy[projection = onto A--B](a) \\tkzGetPoint{k}" } },
    -- Lines
    { trig = ";t-ln-seg",       body = { "\\tkzDrawSegment[color=red,thin](A,B)" } },
    { trig = ";t-ln-segs",      body = { "\\tkzDrawSegments(A,B B,C)" } },
    { trig = ";t-ln-mark",      body = { "\\tkzMarkSegment[pos=0.5,mark=|](A,B)" } },
    { trig = ";t-ln-perp",      body = { "\\tkzDefPointBy[projection=onto A--B](C) \\tkzGetPoint{D}", "\\tkzDrawSegment[](C,D)" } },
    { trig = ";t-ln-perpbis",   body = { "\\tkzDefLine[mediator](A,B) \\tkzGetPoints{C}{D}", "\\tkzDrawLine[dashed](C,D)" } },
    -- Circles
    { trig = ";t-circ-1",       body = { "\\tkzDrawCircle(A,B)" } },
    { trig = ";t-circ-2",       body = { "\\draw (2,0) circle (2);" } },
    { trig = ";t-circ-in",      body = { "\\tkzDefCircle[in](A,B,C) \\tkzGetPoints{I}{x}", "\\tkzDrawCircles[new](I,x)" } },
    { trig = ";t-circ-circum",  body = { "\\tkzDefCircle[circum](A,B,C) \\tkzGetPoint{K}", "\\tkzDrawCircles[new](K,A)" } },
    -- Angles
    { trig = ";t-ang-mark",     body = { "\\tkzMarkAngle[size=1,mark=|](A,O,B)" } },
    { trig = ";t-ang-right",    body = { "\\tkzMarkRightAngle[fill=red!20,size=.8](A,O,B)" } },
    { trig = ";t-ang-bisector", body = { "\\tkzDefLine[bisector](A,O,B) \\tkzGetPoint{C}", "\\tkzDrawSegment[dashed](O,C)" } },
    -- Intersections
    { trig = ";t-int-ll",       body = { "\\tkzInterLL(A,B)(C,D) \\tkzGetPoint{I}" } },
    { trig = ";t-int-lc",       body = { "\\tkzInterLC(A,B)(O,C) \\tkzGetPoints{E}{F}" } },
    { trig = ";t-int-cc",       body = { "\\tkzInterCC(D,B)(O,C) \\tkzGetPoints{V}{U}" } },
    -- Labels
    { trig = ";t-lbl-pt",       body = { "\\tkzLabelPoints[below](A,B,C)" } },
    { trig = ";t-lbl-seg",      body = { "\\tkzLabelSegment[above,pos=.8](A,B){$a$}" } },
    -- Basic shapes
    { trig = ";t-trect",        body = { "\\draw (0,0) rectangle (3,2);" } },
    { trig = ";t-tcirc",        body = { "\\draw (0,0) circle (2);" } },
    { trig = ";t-tellipse",     body = { "\\draw (0,0) ellipse (2 and 1);" } },
    { trig = ";t-tline",        body = { "\\draw (0,0) -- (3,2);" } },
    { trig = ";t-tarrow",       body = { "\\draw[->] (0,0) -- (3,2);" } },
    { trig = ";t-tdash",        body = { "\\draw[dashed] (0,0) -- (3,2);" } },
    { trig = ";t-tcurve",       body = { "\\draw (0,0) .. controls (1,2) and (3,2) .. (4,0);" } },
    { trig = ";t-tgrid",        body = { "\\draw[step=0.5cm,gray,very thin] (-2,-2) grid (2,2);" } },
    { trig = ";t-taxis",        body = { "\\draw[->] (-2,0) -- (2,0) node[below]{$x$};", "\\draw[->] (0,-2) -- (0,2) node[left]{$y$};" } },
    { trig = ";t-tnode",        body = { "\\node at (1,1) {Hello TikZ!};" } },
    { trig = ";t-tarc",         body = { "\\draw (0,0) arc (0:180:2);" } },
    { trig = ";t-tcircfill",    body = { "\\fill[blue] (0,0) circle (1);" } },
    { trig = ";t-tshift",       body = { "\\draw[shift={(2,1)}] (0,0) rectangle (3,2);" } },
    { trig = ";t-trotate",      body = { "\\draw[rotate=30] (0,0) rectangle (2,1);" } },
    { trig = ";t-tscale",       body = { "\\draw[scale=2] (0,0) rectangle (2,1);" } },
    -- Polar
    { trig = "tpo-concentric",  body = { "\\foreach \\r in {1,2,3,4} {", "  \\draw (0,0) circle (\\r);", "}" } },
    { trig = "tpo-radial",      body = { "\\foreach \\a in {0,45,90,135,180,225,270,315} {", "  \\draw[red] (0,0) -- (\\a:4);", "}" } },
    { trig = "tpo-sector",      body = { "\\filldraw[fill=blue!20, draw=black] (0,0) -- (30:3) arc (30:60:3) -- cycle;" } },
}

for _, sni in ipairs(tikz_text_snips) do
    table.insert(tex, s({ trig = sni.trig }, t(sni.body)))
end

-- ---------------------------------------------------------------------------
-- REGISTER
-- ---------------------------------------------------------------------------
require("luasnip").add_snippets("tex", tex)
