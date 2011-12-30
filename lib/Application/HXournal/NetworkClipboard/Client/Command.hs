module Application.HXournal.NetworkClipboard.Client.Command where

import Application.HXournal.NetworkClipboard.Client.ProgType
import Application.HXournal.NetworkClipboard.Client.Job
import Application.HXournal.NetworkClipboard.Client.Config
import Data.Configurator

commandLineProcess :: HXournalClip_client -> IO ()
commandLineProcess (Create cfg mn) = do 
  putStrLn "create called"
  mc <- getHXournalClipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startCreate mn) mc
commandLineProcess (Get cfg n) = do 
  putStrLn "get called"
  mc <- getHXournalClipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startGet n) mc
commandLineProcess (Put cfg n mn) = do 
  putStrLn "put called"
  mc <- getHXournalClipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (\c-> startPut c n mn) mc
commandLineProcess (Delete cfg n) = do 
  putStrLn "delete called"
  mc <- getHXournalClipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") (flip startDelete n) mc
commandLineProcess (GetList cfg) = do 
  putStrLn "getlist called"
  mc <- getHXournalClipClientConfiguration =<< load [Required cfg] 
  maybe (error "cannot parse config") startGetList mc