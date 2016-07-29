{-# LANGUAGE Arrows #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module YEGRec.Parse where

import Text.XML.HXT.Core
import Network.HTTP
import Data.Time

import YEGRec.Types
import YEGRec.XMLUtil

getEventFeed :: String -> IO String
getEventFeed url = simpleHTTP (getRequest url) >>= getResponseBody

parseEventDate :: String -> Maybe Day
parseEventDate dt = parseTimeM True defaultTimeLocale "%Y/%m/%d" dtStripped
  where dtStripped = take 10 dt

parseEventFeedAsXml :: IO String -> IO [XmlTree]
parseEventFeedAsXml feed = do
  feedAsString <- feed
  runX $ readString [withValidate no] $ drop 3 feedAsString
