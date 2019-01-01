{-# LANGUAGE FlexibleContexts #-}
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.WorkspaceNames

import System.IO
import qualified Data.Map as M

import Control.Monad (liftM2)

import qualified XMonad.StackSet as W
import qualified XMonad.Operations as O
import XMonad.Prompt.Shell
import XMonad.Prompt.Workspace
import XMonad.Prompt

import XMonad.Layout.Spacing

myTerminal = "urxvt"

myWorkspaces = ["misc", "social", "tamba", "haccs"] ++ map show [5..9]

myLayoutHook = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True (layoutHook def)

promptConf = def { position = CenteredAt 0.5 0.5
                 , height   = 54
                 , font     = "-*-courier-*-*-*-*-*-240-*-*-*-*-*-*"
                 , defaultText = ""
                 , promptBorderWidth = 10
                 }

myKeys :: XConfig Layout -> M.Map (ButtonMask, KeySym) (X ())
myKeys conf = M.fromList
    [((modm .|. shiftMask, xK_r), workspacePrompt promptConf (O.windows . W.greedyView))
    ,((modm,               xK_n), renameWorkspace promptConf)]
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


myConf = def { terminal = myTerminal
             , keys     = liftM2 M.union myKeys (keys def)
             , workspaces = myWorkspaces
             , layoutHook = myLayoutHook
             , borderWidth = 5
             , normalBorderColor = "#000000"
             , focusedBorderColor = "#a54242"
             }

main = myStatusBar myConf >>= xmonad
