import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import qualified XMonad.StackSet as W

myTerminal :: String
myTerminal = "urxvtc"

myWorkspaces = ["1:Term","2:Web","3:Code","4:VM","5:Music","6:Video","7:Chat","8:Misc","9:Misc2"]

myManageHook = composeAll
    [ className =? "Gimp"       			--> doShift "8:Misc"
    , className =? "MPlayer"    			--> doShift "6:Video"
	, className =? "mpv"     				--> doShift "6:Video"
    , className =? "Chromium"   			--> doShift "2:Web"
	, className =? "Firefox"    			--> doShift "2:Web"
	, className =? "Pidgin" 				--> doShift "7:Chat"
	, className =? "Skype" 					--> doShift "7:Chat"
	, className =? "VirtualBox" 			--> doShift "4:VM"
	, stringProperty "WM_NAME" =? "ncmpc" 	--> doShift "5:Music"
    , className =? "Gnuplot"    			--> doShift "9:Misc2"
    , isFullscreen 							--> (doF W.focusDown <+> doFullFloat)
    ]

main = do
    xmproc <- spawnPipe "`which xmobar` ~/.xmonad/.xmobarrc"
    xmonad $ defaultConfig
        { terminal = myTerminal
        , manageHook = manageDocks <+>  myManageHook 
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $   layoutHook defaultConfig 
        , workspaces = myWorkspaces
		, logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask    -- Rebind Mod to the Windows key
        } `additionalKeysP`
        [ ("<XF86TouchpadToggle>", spawn "~/.bin/toggle-touchpad.sh")
        , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3%+")
        , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3%-")
        , ("<XF86AudioMute>",        spawn "amixer sset Master toggle")
        ]
        `additionalKeys`
        [ ((mod4Mask, xK_p), spawn "exe=`dmenu_run | yeganesh` && eval \"exec $exe\"")
		, ((mod4Mask, xK_l), spawn "xscreensaver-command --lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
