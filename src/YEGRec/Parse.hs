module YEGRec.Parse where

import Text.XML.Light
import Network.HTTP
import Data.Time

import YEGRec.Types
import YEGRec.XMLUtil

getEventFeed :: String -> IO String
getEventFeed url = simpleHTTP (getRequest url) >>= getResponseBody

parseEventDate :: String -> Maybe Day
parseEventDate dt = parseTimeM True defaultTimeLocale "%Y/%m/%d" dtStripped
  where dtStripped = take 10 dt

parseEventFeedXml :: String -> [Maybe Event]
parseEventFeedXml feed =
  case parseXMLDoc feed of
    Nothing -> []
    Just doc -> map parseEvent $ findElements (unqual "item") doc

parseEvent :: Element -> Maybe Event
parseEvent item =
  let title = getTextContent $ findChild (unqual "title") item
      description = getTextContent $ findChild (unqual "description") item
      category = getTextContent $ findChild (unqual "category") item
      link = getTextContent $ findChild (unqual "link") item
      date = case category of
        Nothing -> Nothing
        Just dt -> parseEventDate dt
  in Just (createMinimalEvent title date link)
