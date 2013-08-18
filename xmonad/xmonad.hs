
import XMonad
import XMonad.Layout
import XMonad.Layout.Spacing


main :: IO ()
main = do
	xmonad $ defaultConfig
			{ borderWidth			= 1
			, normalBorderColor		= "#EFEFEF"
			, focusedBorderColor	= "#000000"
			, layoutHook = spacing 2 $ Tall 1 (3/100) (1/2)
			}

