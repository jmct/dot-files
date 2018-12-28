{-# LANGUAGE FlexibleContexts #-}
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.WorkspaceNames

import System.IO
import qualified Data.Map as M

import Control.Monad (liftM2)

myTerminal = "urxvt"

-- myKeys :: XConfig Layout -> M.Map (ButtonMask, KeySym) (X ())
myKeys conf = M.fromList
    [((modm .|. shiftMask, xK_r), renameWorkspace def)]
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
             }

main =  myStatusBar myConf >>= xmonad
