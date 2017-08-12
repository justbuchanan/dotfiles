import subprocess as proc
from colorama import init, Fore, Back, Style
init()


# run the command and print it in color to the console
def run_cmd(args, **kwargs):
    print(Fore.BLUE + '$ %s' % ' '.join(args) + Style.RESET_ALL)
    proc.check_call(args, **kwargs)
