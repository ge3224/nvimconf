--[[ Bible Reference Generator ]]

-- Bible book to chapter ID mapping
local bible_books = {
  ['Genesis'] = 1001070105,
  ['Exodus'] = 1001070106,
  ['Leviticus'] = 1001070107,
  ['Numbers'] = 1001070108,
  ['Deuteronomy'] = 1001070109,
  ['Joshua'] = 1001070110,
  ['Judges'] = 1001070111,
  ['Ruth'] = 1001070112,
  ['1 Samuel'] = 1001070113,
  ['2 Samuel'] = 1001070114,
  ['1 Kings'] = 1001070115,
  ['2 Kings'] = 1001070116,
  ['1 Chronicles'] = 1001070117,
  ['2 Chronicles'] = 1001070118,
  ['Ezra'] = 1001070119,
  ['Nehemiah'] = 1001070120,
  ['Esther'] = 1001070121,
  ['Job'] = 1001070122,
  ['Psalms'] = 1001070123,
  ['Proverbs'] = 1001070124,
  ['Ecclesiastes'] = 1001070125,
  ['Song of Solomon'] = 1001070126,
  ['Isaiah'] = 1001070127,
  ['Jeremiah'] = 1001070128,
  ['Lamentations'] = 1001070129,
  ['Ezekiel'] = 1001070130,
  ['Daniel'] = 1001070131,
  ['Hosea'] = 1001070132,
  ['Joel'] = 1001070133,
  ['Amos'] = 1001070134,
  ['Obadiah'] = 1001070135,
  ['Jonah'] = 1001070136,
  ['Micah'] = 1001070137,
  ['Nahum'] = 1001070138,
  ['Habakkuk'] = 1001070139,
  ['Zephaniah'] = 1001070140,
  ['Haggai'] = 1001070141,
  ['Zechariah'] = 1001070142,
  ['Malachi'] = 1001070143,
  ['Matthew'] = 1001070144,
  ['Mark'] = 1001070145,
  ['Luke'] = 1001070146,
  ['John'] = 1001070147,
  ['Acts'] = 1001070148,
  ['Romans'] = 1001070149,
  ['1 Corinthians'] = 1001070150,
  ['2 Corinthians'] = 1001070151,
  ['Galatians'] = 1001070152,
  ['Ephesians'] = 1001070153,
  ['Philippians'] = 1001070154,
  ['Colossians'] = 1001070155,
  ['1 Thessalonians'] = 1001070156,
  ['2 Thessalonians'] = 1001070157,
  ['1 Timothy'] = 1001070158,
  ['2 Timothy'] = 1001070159,
  ['Titus'] = 1001070160,
  ['Philemon'] = 1001070161,
  ['Hebrews'] = 1001070162,
  ['James'] = 1001070163,
  ['1 Peter'] = 1001070164,
  ['2 Peter'] = 1001070165,
  ['1 John'] = 1001070166,
  ['2 John'] = 1001070167,
  ['3 John'] = 1001070168,
  ['Jude'] = 1001070169,
  ['Revelation'] = 1001070170,
}

-- Abbreviation to full book name mapping
local book_abbreviations = {
  ['Ge'] = 'Genesis',
  ['Ex'] = 'Exodus',
  ['Le'] = 'Leviticus',
  ['Nu'] = 'Numbers',
  ['De'] = 'Deuteronomy',
  ['Jos'] = 'Joshua',
  ['Jg'] = 'Judges',
  ['Ru'] = 'Ruth',
  ['1Sa'] = '1 Samuel',
  ['2Sa'] = '2 Samuel',
  ['1Ki'] = '1 Kings',
  ['2Ki'] = '2 Kings',
  ['1Ch'] = '1 Chronicles',
  ['2Ch'] = '2 Chronicles',
  ['Ezr'] = 'Ezra',
  ['Ne'] = 'Nehemiah',
  ['Es'] = 'Esther',
  ['Job'] = 'Job',
  ['Ps'] = 'Psalms',
  ['Pr'] = 'Proverbs',
  ['Ec'] = 'Ecclesiastes',
  ['Ca'] = 'Song of Solomon',
  ['Isa'] = 'Isaiah',
  ['Jer'] = 'Jeremiah',
  ['La'] = 'Lamentations',
  ['Eze'] = 'Ezekiel',
  ['Da'] = 'Daniel',
  ['Ho'] = 'Hosea',
  ['Joe'] = 'Joel',
  ['Am'] = 'Amos',
  ['Ob'] = 'Obadiah',
  ['Jon'] = 'Jonah',
  ['Mic'] = 'Micah',
  ['Na'] = 'Nahum',
  ['Hab'] = 'Habakkuk',
  ['Zep'] = 'Zephaniah',
  ['Hag'] = 'Haggai',
  ['Zec'] = 'Zechariah',
  ['Mal'] = 'Malachi',
  ['Mt'] = 'Matthew',
  ['Mr'] = 'Mark',
  ['Lu'] = 'Luke',
  ['Joh'] = 'John',
  ['Ac'] = 'Acts',
  ['Ro'] = 'Romans',
  ['1Co'] = '1 Corinthians',
  ['2Co'] = '2 Corinthians',
  ['Ga'] = 'Galatians',
  ['Eph'] = 'Ephesians',
  ['Php'] = 'Philippians',
  ['Col'] = 'Colossians',
  ['1Th'] = '1 Thessalonians',
  ['2Th'] = '2 Thessalonians',
  ['1Ti'] = '1 Timothy',
  ['2Ti'] = '2 Timothy',
  ['Tit'] = 'Titus',
  ['Phm'] = 'Philemon',
  ['Heb'] = 'Hebrews',
  ['Jas'] = 'James',
  ['1Pe'] = '1 Peter',
  ['2Pe'] = '2 Peter',
  ['1Jo'] = '1 John',
  ['2Jo'] = '2 John',
  ['3Jo'] = '3 John',
  ['Jude'] = 'Jude',
  ['Re'] = 'Revelation',
}

-- Function to get chapter ID by book name or abbreviation
local function get_book_id(book_input)
  -- First try as full book name
  local chapter_id = bible_books[book_input]
  if chapter_id then
    return chapter_id
  end

  -- If not found, try as abbreviation
  local full_name = book_abbreviations[book_input]
  if full_name then
    return bible_books[full_name]
  end

  -- Return nil if not found
  return nil
end

-- Load Bible data from JSON file (once at startup)
local bible_data = nil
local function load_bible_data()
  if bible_data then
    return bible_data
  end

  local data_path = vim.fn.stdpath('config') .. '/plugin/bible-data.json'
  local file = io.open(data_path, 'r')
  if not file then
    return nil, 'Failed to open bible-data.json'
  end

  local content = file:read('*all')
  file:close()

  local ok, data = pcall(vim.fn.json_decode, content)
  if not ok or not data then
    return nil, 'Failed to parse bible-data.json'
  end

  bible_data = data
  return bible_data
end

-- Function to get chapter info from JSON data
local function get_chapter_info(book_name, chapter_num)
  local c_id = get_book_id(book_name)
  if not c_id then
    return nil, 'Book not found: ' .. book_name
  end

  -- Load Bible data
  local data, err = load_bible_data()
  if not data then
    return nil, err
  end

  -- Calculate book number from c_id
  local book_number = tostring(c_id - 1001070104)
  local chapter_str = tostring(chapter_num)

  -- Look up in data
  if not data[book_number] then
    return nil, 'Book ' .. book_number .. ' not found in data'
  end

  if not data[book_number][chapter_str] then
    return nil, 'Chapter ' .. chapter_str .. ' not found in book ' .. book_number
  end

  return data[book_number][chapter_str]
end

-- Function to generate the numbered links
local function generate_numbered_links()
  -- Prompt for input parameters
  local book_name = vim.fn.input 'Enter book name or abbreviation: '
  local c_id = get_book_id(book_name)
  if not c_id then
    vim.notify('Book not found: ' .. book_name, vim.log.levels.ERROR)
    return
  end
  local x = vim.fn.input 'Enter chapter number: '

  -- Get chapter info from JSON data
  local chapter_info, err = get_chapter_info(book_name, x)

  if not chapter_info then
    vim.notify(err or 'Failed to get chapter info', vim.log.levels.ERROR)
    return
  end

  -- Use data directly from JSON
  local count = chapter_info.count
  local v_id = chapter_info.first_verse_id

  vim.notify(
    string.format('Generating %d verses starting from ID %d', count, v_id),
    vim.log.levels.INFO
  )

  -- Get current cursor position
  local row = vim.api.nvim_win_get_cursor(0)[1]
  -- Generate the lines
  local lines = {}
  for i = 1, count do
    local header = string.format('### %s:%d', x, i)
    local link = string.format('[Ref. %d](https://wol.jw.org/en/wol/dx/r1/lp-e/%d/%d)', i, c_id, v_id + i - 1)

    table.insert(lines, header)
    table.insert(lines, '')
    table.insert(lines, link)

    -- Add empty line after each entry except the last one
    if i < count then
      table.insert(lines, '')
    end
  end

  -- Insert the lines at current cursor position
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
end

-- Create the keymapping (adjust the key combination as needed)
vim.keymap.set('n', '<leader>bv', function()
  generate_numbered_links()
end, { noremap = true, desc = 'Generate numbered links' })