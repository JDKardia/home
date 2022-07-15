return require('nvim-treesitter.configs').setup({
  -- one of "all", "maintained", or a list of languages
  ensure_installed={
    'astro', 'bash', 'beancount', 'bibtex',
    'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'commonlisp',
    'cooklang', 'cpp', 'css', 'cuda', 'd', 'dart', 'devicetree',
    'dockerfile', 'dot', 'eex', 'elixir', 'elvish', 'erlang',
    'fennel', 'fish', 'foam', 'fusion',  'gleam',
    'glsl', 'go', 'gomod', 'gowork', 'graphql', 'haskell',
    'hcl', 'heex', 'help', 'hjson', 'hocon', 'html',
    'http', 'java', 'javascript', 'jsdoc', 'json', 'json5',
    'jsonc', 'julia', 'kotlin', 'lalrpop', 'latex', 'ledger',
    'llvm', 'lua', 'm68k', 'make', 'markdown', 'markdown_inline',
    'ninja', 'nix', 'norg', 'ocaml', 'ocaml_interface', 'ocamllex',
    'org', 'pascal', 'perl', 'pioasm', 'prisma', 'proto',
    'pug', 'python', 'ql', 'r', 'rasi', 'regex',
    'rego', 'rnoweb', 'rst', 'ruby', 'rust', 'scala',
    'scheme', 'scss', 'slint', 'solidity', 'sparql', 'supercollider',
    'surface', 'svelte', 'swift', 'teal', 'tiger', 'tlaplus',
    'todotxt', 'toml', 'tsx', 'turtle', 'typescript', 'vala',
    'verilog', 'vim', 'vue', 'wgsl', 'yaml', 'yang', 'zig'
},
  highlight={
    enable=true,
    disable={'scala', 'jsonc', 'fusion', 'jsonc'},
    -- additional_vim_regex_highlighting = true, -- DO NOT SET THIS, BREAKS SPELLSITTER
},
  rainbow={enable=true, extended_mode=true, max_file_lines=2000},
  playground = { enable = true },
})
