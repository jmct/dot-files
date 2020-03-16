--------------------------------------------------------------------------------
-- |
-- Module      : Main
-- Description : This is a utility for making shortcut for taskwarrior
-- invocations.
-- Copyright   : (c) José Manuel Calderón Trilla, 2020
-- License     : GPL-3
-- Maintainer  : jmct@jmct.cc
-- Portability : POSIX
--------------------------------------------------------------------------------
import System.Environment (getArgs, getProgName)
import System.Exit        (die, exitSuccess)
import System.Process     (callCommand)

import Data.List          (intersperse)

main :: IO ()
main = do
  name <- getProgName
  args <- getArgs
  case process name args of
    Left err -> die err
    Right st -> putStrLn st

type Project = String

newtype Tags    = T [String]
  deriving Eq

-- | `PartialCmd` is when we know that the project exists and what the default
--   tags are, but we don't yet know the other user-provided task info
newtype PartialCmd = PC String

-- | A list of known projects and their associated tags
knownProjects = workProjects ++ otherProjects


-- | The list of projects I'm working on at Galois
workProjects = flip zip (map T (repeat ["galois"]))
  [ "tamba"
  , "verona"
  , "recruitment"
  , "dialogue"
  , "misc"
  ]

-- | The list of projects outside of Galois
otherProjects =
  [ ("gtd",            T ["reading", "home"]                )
  , ("cmsc430",        T ["umd",     "teaching", "computer"])
  , ("transcriptions", T ["home",    "computer"]            )
  ]

-- | Given a project name and some arguments, construct the appropriate CLI
-- invocation string or error
process :: String -> [String] -> Either String String
process proj args = combine <$> getProj knownProjects proj <*> pure args


-- | Ensure that the invoked project exists, if it does, create a `PartialCmd`
--   otherwise, raise an error
getProj :: [(Project, Tags)] -> Project -> Either String PartialCmd
getProj dict proj =
  case lookup proj dict of
    Nothing -> Left ("No known project with name \"" ++ proj ++ "\"")
    Just ts -> Right (mkPartialCmd proj ts)

mkPartialCmd :: String -> Tags -> PartialCmd
mkPartialCmd proj (T tags) = PC (concat $ intersperse " " (("project:" ++ proj) : (map ('+':) tags)))

combine :: PartialCmd -> [String] -> String
combine (PC cmd) args = concat $ intersperse " " (cmd:args)
