
import XMonad
import XMonad.Layout
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import System.IO
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog



myWorkspaces = ["1:browse", "2:rj-dev", "3:bm-dev", "4:jb-dev"]


main :: IO ()
main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobar/xmobar.hs"
	xmonad $ defaultConfig
			{ borderWidth			= 1
			, normalBorderColor		= "#EFEFEF"
			, focusedBorderColor	= "#000000"
			, layoutHook = spacing 2 $ Tall 1 (3/100) (1/2)
			, terminal = "xterm"
			, workspaces = myWorkspaces
			, logHook = dynamicLogWithPP xmobarPP
				{ ppOutput = hPutStrLn xmproc
				, ppTitle = xmobarColor "blue" "" . shorten 50
				, ppLayout = const "" -- to disable the layout info on xmobar
				}
			}

