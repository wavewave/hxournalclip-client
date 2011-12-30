{-# LANGUAGE OverloadedStrings #-}

module Application.Hxournal.NetworkClipboard.Client.Config where

import Control.Applicative
import Data.Configurator as C
import Data.Configurator.Types

data HxournalclipClientConfiguration = HxournalclipClientConfiguration { 
  hxournalclipServerURL :: String,
  hxournalclipClientURL :: String
} deriving (Show)

getHxournalclipClientConfiguration :: Config -> IO (Maybe HxournalclipClientConfiguration)
getHxournalclipClientConfiguration config = do  
  s <- C.lookup config "server" 
  c <- C.lookup config "client" 
  return  (HxournalclipClientConfiguration  <$> s <*> c )
