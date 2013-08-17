
import XMonad
import XMonad.Layout


main :: IO ()
main = do
	xmonad $ defaultConfig
			{ borderWidth			= 1
			, normalBorderColor		= "#EFEFEF"
			, focusedBorderColor	= "#000000"
			, terminal				= "xterm"
			}

