{-# LANGUAGE DeriveDataTypeable #-}

module Application.Hxournal.NetworkClipboard.Client.ProgType where 

import System.FilePath
import System.Console.CmdArgs hiding (name)

data Hxournalclip_client = Create { config :: FilePath, modulename :: String }
                  | Get    { config :: FilePath, name :: String } 
                  | Put    { config :: FilePath, name :: FilePath, modulename :: String } 
                  | Delete { config :: FilePath, name :: String } 
                  | GetList { config :: FilePath } 
              deriving (Show,Data,Typeable)

create :: Hxournalclip_client
create = Create { config = "test.conf"
                , modulename = "" &= typ "MODULENAME" &= argPos 0
                }

get :: Hxournalclip_client 
get = Get { config = "test.conf" 
          , name = "" &= typ "NAME" &= argPos 0 
          } 

put :: Hxournalclip_client 
put = Put { config = "test.conf"
          , name = "" &= typ "NAME" &= argPos 0 
          , modulename = "" &= typ "NAME" &= argPos 1
          }

delete :: Hxournalclip_client 
delete = Delete { config = "test.conf"
                , name = "" &= typ "NAME" &= argPos 0 
                }

getlist :: Hxournalclip_client 
getlist = GetList { config = "test.conf" } 

mode = modes [ create, get, put, delete, getlist ]

