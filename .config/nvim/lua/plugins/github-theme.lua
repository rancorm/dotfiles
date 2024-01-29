return {	
  "projekt0n/github-nvim-theme",
  init = function()
    local function get_apple_interface_style()
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
	local result = handle:read("*a")

	handle:close()

	return result
    end

    local function is_binary(binary_name)
	local command = "command -v " .. binary_name .. " > /dev/null 2>&1 || { echo >&2 'not found'; exit 1; }"
	local exit_code = os.execute(command)

	return exit_code == 0
    end

    -- Themes
    local has_defaults = is_binary("defaults")

    --- Check for macOS defaults
    if has_defaults then
	local apple_interface_style = get_apple_interface_style()

	-- Set theme based on system interface style
	if apple_interface_style == "Dark\n" then
	    cmd([[colorscheme github_dark_default]])
	elseif apple_interface_style == "Light\n" then
	    cmd([[colorscheme github_light_default]])
	end
    else
	-- Set theme
	cmd([[colorscheme github_dark_default]])
    end
  end
}
