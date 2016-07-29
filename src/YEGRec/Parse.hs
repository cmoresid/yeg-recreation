{-# LANGUAGE Arrows #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module YEGRec.Parse where

import Text.XML.HXT.Core
import Network.HTTP

import YEGRec.Types

getEventFeed :: String -> IO String
getEventFeed url = simpleHTTP (getRequest url) >>= getResponseBody

parseEventFeedAsXml :: IO String -> IO [XmlTree]
parseEventFeedAsXml feed = do
  feedAsString <- feed
  runX $ readString [withValidate no] $ drop 3 feedAsString

atTag tag = deep (isElem >>> hasName tag)
text = getChildren >>> getText
