{-# LANGUAGE FlexibleContexts #-}
import XMonad
import XMonad.StackSet (current, screen)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.WorkspaceNames
import XMonad.Layout.ThreeColumns
import System.IO
import qualified Data.Map as M

import Control.Monad (liftM2)

import qualified XMonad.StackSet as W
import qualified XMonad.Operations as O
import XMonad.Prompt.Shell
import XMonad.Prompt.Workspace
import XMonad.Prompt

import XMonad.Layout.Spacing

myFloatingWindows = ["Zoom"
                    ,"zoom"
                    ,"galculator"
                    ,"Galculator"
                    ]

myTerminal = "urxvt"

myWorkspaces = ["web", "tamba", "verona"] ++ map show [4..8] ++ ["email"]

myLayoutHook = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True (ThreeColMid 1 (3/100) (1/2) ||| layoutHook def)

promptConf = def { position = CenteredAt 0.5 0.5
                 , height   = 54
                 , font     = "-*-courier-*-*-*-*-*-240-*-*-*-*-*-*"
                 , defaultText = ""
                 , promptBorderWidth = 10
                 }

spotifyPlayPause :: X ()
spotifyPlayPause =
  spawn $ unwords ["dbus-send", "--print-reply", "--dest=org.mpris.MediaPlayer2.spotify"
                  ,"/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.PlayPause"
                  ]

spotifyNext :: X ()
spotifyNext =
  spawn $ unwords ["dbus-send", "--print-reply", "--dest=org.mpris.MediaPlayer2.spotify"
                  ,"/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.Next"
                  ]

spotifyPrevious :: X ()
spotifyPrevious =
  spawn $ unwords ["dbus-send", "--print-reply", "--dest=org.mpris.MediaPlayer2.spotify"
                  ,"/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.Previous"
                  ]

myKeys :: XConfig Layout -> M.Map (ButtonMask, KeySym) (X ())
myKeys conf = M.fromList
    [((modm,               xK_n), renameWorkspace promptConf)
    ,((modm,               xK_p), spawn "dmenu_run -fn 'FiraCode-8'")
    ,((modm,               xK_semicolon), spotifyPlayPause)
    ,((modm .|. shiftMask, xK_n), spotifyNext)
    ,((modm .|. shiftMask, xK_p), spotifyPrevious)
    ,((modm .|. shiftMask, xK_r), sendMessage ToggleStruts)
    ,((modm .|. shiftMask, xK_Return), spawnTerm)
    ]
  where
    modm = XMonad.modMask conf

myStatusBar conf = do
  h <- spawnPipe "xmobar"
  return $ docks $ conf
    { layoutHook = avoidStruts (layoutHook conf)
    , logHook = do
        logHook conf
        pp <- workspaceNamesPP xmobarPP
        dynamicLogWithPP pp { ppOutput = hPutStrLn h }
    , keys = liftM2 M.union tsKey (keys conf)
    }
 where
  tsKey conf = M.singleton (modMask conf, xK_b) (sendMessage ToggleStruts)

myManageHook = composeAll
  [ className =? f --> doFloat | f <- myFloatingWindows ]


myConf = def { terminal = myTerminal
             , keys     = liftM2 M.union myKeys (keys def)
             , workspaces = myWorkspaces
             , layoutHook = myLayoutHook
             , manageHook = myManageHook
             , borderWidth = 5
             , normalBorderColor = "#000000"
             , focusedBorderColor = "#a54242"
             }

getScreen :: X (ScreenId)
getScreen = fmap (screen . current . windowset) get

spawnTerm :: X ()
spawnTerm = do
  sid <- getScreen
  let opt = if sid == 1 then " -fn \"xft:FiraCode:size=10\"" else ""
  spawn $ myTerminal ++ opt

main = myStatusBar myConf >>= xmonad
