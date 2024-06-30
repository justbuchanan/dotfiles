#!/usr/bin/env python3

import yaml
import sys
from collections import OrderedDict

"""
This script converts i3-style themes into xresources format.
i3-style can be found here: https://github.com/acrisci/i3-style.


Recommended Usage:
Update your i3 config file's color settings to look like this:

    # Load colors from xresources
    set_from_resource $bar_separator_colors          i3wm.bar_colors.separator
    set_from_resource $bar_background_colors         i3wm.bar_colors.background
    set_from_resource $bar_statusline_colors         i3wm.bar_colors.statusline
    set_from_resource $bar_focused_workspace_colors  i3wm.bar_colors.focused_workspace
    set_from_resource $bar_active_workspace_colors   i3wm.bar_colors.active_workspace
    set_from_resource $bar_inactive_workspace_colors i3wm.bar_colors.inactive_workspace
    set_from_resource $bar_urgent_workspace_colors   i3wm.bar_colors.urgent_workspace
    set_from_resource $focused_colors                i3wm.window_colors.focused
    set_from_resource $focused_inactive_colors       i3wm.window_colors.focused_inactive
    set_from_resource $unfocused_colors              i3wm.window_colors.unfocused
    set_from_resource $urgent_colors                 i3wm.window_colors.urgent

    bar {
        colors {
            separator          $bar_separator_colors
            background         $bar_background_colors
            statusline         $bar_statusline_colors
            focused_workspace  $bar_focused_workspace_colors
            active_workspace   $bar_active_workspace_colors
            inactive_workspace $bar_inactive_workspace_colors
            urgent_workspace   $bar_urgent_workspace_colors
        }
    }

    client.focused          $focused_colors
    client.focused_inactive $focused_inactive_colors
    client.unfocused        $unfocused_colors
    client.urgent           $urgent_colors


Generate an xresources theme from an i3-style theme.

    ./i3style2xresources.py path/to/i3style/theme > ~/.Xresources.d/i3theme


Add a line to ~/.Xresources to include your theme:

    #include ".Xresources.d/i3theme"


Reload your xresources

    xrdb ~/.Xresources


Reload i3:

    i3-msg reload
"""




# i3style themes list colors by name, but in the xresources output, they're
# ordered, but not named
color_ordering = ['border', 'background', 'text', 'indicator']

# Set ordering so that output is consistent and organized
key_ordering = OrderedDict([
    ('window_colors', [
        'focused',
        'focused_inactive',
        'unfocused',
        'urgent',
    ]),
    ('bar_colors', [
        'focused_workspace',
        'active_workspace',
        'inactive_workspace',
        'urgent_workspace',

        'separator',
        'background',
        'statusline',

        # not part of i3-style, these are my custom additions
        'icon',
        'graph',
    ]),
])


# Example: print_valueset(['bar'], ['#ffffff']) -> print('i3wm.bar: #ffffff') 
# @param keypath A list of keypath components
def print_valueset(keypath, values):
    keypath_str = 'i3wm.%s:' % '.'.join(keypath)
    # pad with spaces so that all color values are horizontally-aligned
    keypath_str = "{:<37}".format(keypath_str)

    values = '     '.join(values)
    print(keypath_str + values)


# First argument is the filename of the i3-style theme
if len(sys.argv) != 2:
    print("Usage: %s <i3style-theme-file>" % sys.argv[0])
    sys.exit(1)
theme_file = sys.argv[1]

with open(theme_file, 'r') as f:
    theme = yaml.load(f.read())

print('! %s' % theme['meta']['description'])
print('! Converted from i3-style yaml theme file to xresources')
print('!')
print('!                                    BORDER      BACKGROUND  TEXT        INDICATOR')
for toplevel, subkeys in key_ordering.items():
    for subkey in subkeys:
        # color values in the theme can be either hex codes or names that
        # correspond to the 'colors' dictionary in the theme
        def resolve_color_name(name_or_hex):
            if 'colors' in theme and name_or_hex in theme['colors']:
                return theme['colors'][name_or_hex]
            else:
                return name_or_hex

        if subkey in theme[toplevel]:
            # values may be a dict or a string
            values = theme[toplevel][subkey]

            # For properties with multiple values, concatenate them in the correct order
            if isinstance(values, dict):
                values = [resolve_color_name(values[k]) for k in color_ordering if k in values]
            else:
                values = [resolve_color_name(values)]

            print_valueset([toplevel, subkey], values)

# Default values if icon and graph colors are unspecified
if 'icon' not in theme['bar_colors']:
    print_valueset(['bar_colors', 'icon'],
        [theme['bar_colors']['focused_workspace']['background']])
if 'graph' not in theme['bar_colors']:
    print_valueset(['bar_colors', 'graph'],
        [theme['bar_colors']['inactive_workspace']['text'],
        theme['bar_colors']['inactive_workspace']['border']])
