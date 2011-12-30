module Application.Hxournal.NetworkClipboard.Client.Command where

import Application.Hxournal.NetworkClipboard.Client.ProgType
import Application.Hxournal.NetworkClipboard.Client.Job
import Application.Hxournal.NetworkClipboard.Client.Config
import Data.Configurator

commandLineProcess :: Hxournalclip_client -> IO ()
commandLineProcess (Create cfg mn) = do 
  putStrLn "create called"
  mc <- getHxournalclipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startCreate mn) mc
commandLineProcess (Get cfg n) = do 
  putStrLn "get called"
  mc <- getHxournalclipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startGet n) mc
commandLineProcess (Put cfg n mn) = do 
  putStrLn "put called"
  mc <- getHxournalclipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (\c-> startPut c n mn) mc
commandLineProcess (Delete cfg n) = do 
  putStrLn "delete called"
  mc <- getHxournalclipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startDelete n) mc
commandLineProcess (GetList cfg) = do 
  putStrLn "getlist called"
  mc <- getHxournalclipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") startGetList mc