module Main where

import System.Console.CmdArgs

import Application.Hxournal.NetworkClipboard.Client.ProgType
import Application.Hxournal.NetworkClipboard.Client.Command

main :: IO () 
main = do 
  putStrLn "hxournalclip-client"
  param <- cmdArgs mode
  commandLineProcess param