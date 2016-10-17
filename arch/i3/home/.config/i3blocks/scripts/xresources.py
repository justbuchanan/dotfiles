
import re
import subprocess as proc

def xresources_value(propname):
    out = proc.check_output(['xrdb', '-query']).decode('utf-8')

    match = re.search('%s:(.+)' % re.escape(propname), out)
    result = match.group(1).strip()
    if ' ' in result:
        result = result.split(' ')

    return result

# if __name__ == '__main__':
#     val = xresources_value('i3wm.bar_colors.urgent_workspace')
#     print(val)

