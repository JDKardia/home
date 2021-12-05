local _U = {}
function _U.can_exec(executable)
  return vim.fn.executable(executable) == 1
end

function _U.has_words_before()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s')
end

local list_patterns = {
  ultd = {
    li_type = 'ultd',
    main = '^%s*[*-]%s+%[.%]%s+',
    indentation = '^(%s*)[*-]%s+%[.%]',
    marker = '^%s*([*-]%s+)%[.%]%s+',
    content = '^%s*[*-]%s+%[.%]%s+(.+)',
    demotion = '^%s*[*-]%s+',
    empty = '^%s*[*-]%s+%[.%]%s+$'
  },
  oltd = {
    li_type = 'oltd',
    main = '^%s*%d+%.%s+%[.%]%s+',
    indentation = '^(%s*)%d+%.%s+',
    marker = '^%s*%d+(%.%s+)%[.%]%s+',
    number = '^%s*(%d+)%.',
    content = '^%s*%d+%.%s+%[.%]%s+(.+)',
    demotion = '^%s*%d+%.%s+',
    empty = '^%s*%d+%.%s+%[.%]%s+$'
  },
  ul = {
    li_type = 'ul',
    main = '^%s*[-*]%s+',
    indentation = '^(%s*)[-*]%s+',
    marker = '^%s*([-*]%s+)',
    pre = '^%s*[-*]',
    content = '^%s*[-*]%s+(.+)',
    demotion = '^%s*',
    empty = '^%s*[-*]%s+$'
  },
  ol = {
    li_type = 'ol',
    main = '^%s*%d+%.%s+',
    indentation = '^(%s*)%d+%.',
    marker = '^%s*%d+(%.%s+)',
    pre = '^%s*%d+%.',
    number = '^%s*(%d+)%.',
    content = '^%s*%d+%.%s+(.+)',
    demotion = '^%s*',
    empty = '^%s*%d+%.%s+$'
  }
}

function cur_line_list_type(line)
  local match
  local i = 1
  local li_types = { 'ultd', 'oltd', 'ul', 'ol' }
  local result
  local indentation
  -- local cursor = vim.api.nvim_win_get_cursor(0)
  -- line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''
  while not match and i <= 4 do
    local li_type = li_types[i]
    match = line:match(list_patterns[li_type].main)
    if match then
      result = li_type
      indentation = line:match(list_patterns[li_type].indentation)
    else
      i = i + 1
    end
  end
  return result, indentation
end

return _U
