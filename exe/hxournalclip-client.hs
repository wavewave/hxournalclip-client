module Main where

import System.Console.CmdArgs

import Application.HXournal.NetworkClipboard.Client.ProgType
import Application.HXournal.NetworkClipboard.Client.Command

main :: IO () 
main = do 
  putStrLn "hxournalclip-client"
  param <- cmdArgs mode
  commandLineProcess param