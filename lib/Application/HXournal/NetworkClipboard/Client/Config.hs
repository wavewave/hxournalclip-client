{-# LANGUAGE OverloadedStrings #-}

module Application.HXournal.NetworkClipboard.Client.Config where

import Control.Applicative
import Data.Configurator as C
import Data.Configurator.Types

data HXournalClipClientConfiguration = HXournalClipClientConfiguration { 
  hxournalclipServerURL :: String,
  hxournalclipClientURL :: String
} deriving (Show)

getHXournalClipClientConfiguration :: Config -> IO (Maybe HXournalClipClientConfiguration)
getHXournalClipClientConfiguration config = do  
  s <- C.lookup config "server" 
  c <- C.lookup config "client" 
  return  (HXournalClipClientConfiguration  <$> s <*> c )
