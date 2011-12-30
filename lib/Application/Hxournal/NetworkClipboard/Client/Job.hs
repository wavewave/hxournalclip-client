{-# LANGUAGE OverloadedStrings #-}

module Application.Hxournal.NetworkClipboard.Client.Job where

import Debug.Trace

import qualified Data.ByteString.Lazy.Char8 as C
import qualified Data.ByteString.Char8 as SC
import Data.Aeson.Types
import Data.Aeson.Encode as E
import Data.Aeson.Parser
import qualified Data.Attoparsec as A

import Network.HTTP.Types hiding (statusCode)
import Network.HTTP.Enumerator

import System.Directory 
import System.FilePath
import Unsafe.Coerce

import Application.Hxournal.NetworkClipboard.Client.Config
import Application.Hxournal.NetworkClipboard.Type
import Data.UUID
import Data.UUID.V5
import qualified Data.ByteString as B
import Data.Time.Clock

type Url = String 

nextUUID :: HxournalclipClientConfiguration -> IO UUID
nextUUID mc = do 
  let c = hxournalclipClientURL mc 
  t <- getCurrentTime 
  return . generateNamed namespaceURL . B.unpack . SC.pack $ c ++ "/" ++ show t 

startCreate :: HxournalclipClientConfiguration -> String -> IO () 
startCreate mc name = do 
  putStrLn "job started"
  cwd <- getCurrentDirectory
  let url = hxournalclipServerURL mc 
  uuid <- nextUUID mc
  let info = HxournalclipInfo { hxournalclip_uuid = uuid , hxournalclip_name = name } 
  response <- hxournalclipToServer url ("uploadhxournalclip") methodPost info
  putStrLn $ show response 


startGet :: HxournalclipClientConfiguration -> String -> IO () 
startGet mc idee = do 
  putStrLn $"get " ++ idee
  let url = hxournalclipServerURL mc 
  r <- jsonFromServer url ("hxournalclip" </> idee) methodGet
  putStrLn $ show r 


startPut :: HxournalclipClientConfiguration 
         -> String  -- ^ hxournalclip idee
         -> String  -- ^ hxournalclip name 
         -> IO () 
startPut mc idee name = do 
  putStrLn "job started"
  cwd <- getCurrentDirectory
  let url = hxournalclipServerURL mc 
      info = case fromString idee of 
               Nothing -> error "strange in startPut" 
               Just idee' -> HxournalclipInfo { hxournalclip_uuid = idee', hxournalclip_name = name }
  response <- hxournalclipToServer url ("hxournalclip" </> idee) methodPut info
  putStrLn $ show response 


startDelete :: HxournalclipClientConfiguration -> String -> IO () 
startDelete mc idee = do 
  putStrLn "job started"
  let url = hxournalclipServerURL mc 
  r <- jsonFromServer url ("hxournalclip" </> idee) methodDelete
  putStrLn $ show r 


startGetList :: HxournalclipClientConfiguration -> IO () 
startGetList mc = do 
  putStrLn "getlist: "
  let url = hxournalclipServerURL mc 
  r <- jsonFromServer url ("listhxournalclip") methodGet
  putStrLn $ show r 


jsonFromServer :: Url -> String -> Method -> IO (Either String (Result Value))
jsonFromServer url api mthd = do 
  request <- parseUrl (url </> api)
  withManager $ \manager -> do
    let requestjson = request { 
          method = mthd,
          requestHeaders = [ ("Accept", "application/json; charset=utf-8") ] } 
    r <- httpLbs requestjson manager 
    if statusCode r == 200 
      then return . parseJson . SC.concat . C.toChunks . responseBody $ r
      else return (Left $ "status code : " ++ show (statusCode r)) 

hxournalclipToServer :: Url -> String -> Method -> HxournalclipInfo -> IO (Either String (Result Value))
hxournalclipToServer url api mthd mi = do 
  request <- parseUrl (url </> api)
  withManager $ \manager -> do
    let mijson = E.encode (toJSON mi)
        myrequestbody = RequestBodyLBS mijson 
    let requestjson = request 
          { method = mthd
          , requestHeaders = [ ("Accept", "application/json; charset=utf-8") ]
          , requestBody = myrequestbody } 
    r <- httpLbs requestjson manager 
    if statusCode r == 200 
      then return . parseJson . SC.concat . C.toChunks . responseBody $ r
      else return (Left $ "status code : " ++ show (statusCode r)) 

parseJson :: (FromJSON a) => SC.ByteString -> Either String (Result a)
parseJson bs =
  let resultjson = trace (SC.unpack bs) $ A.parse json bs 
  in case resultjson of 
       (A.Done rest rjson) -> return (parse parseJSON rjson)
       _                 -> Left "parseJson" 