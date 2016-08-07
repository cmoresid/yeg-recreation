module YEGRec.Parse where

import qualified Data.Map.Strict as M
import Data.Time
import Data.List.Split

import Text.RegexPR
import Text.XML.Light
import Text.HTML.TagSoup

import Network.HTTP

import YEGRec.Types
import YEGRec.XMLUtil
import YEGRec.Util

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

parseDescription :: String -> M.Map String String
parseDescription = M.fromList . parseDescComps . extractDescComps

parseDescComps :: [String] -> [(String, String)]
parseDescComps comps = map toTuple lpairs
  where parsedComps = map (innerText . parseTags) comps
        lpairs = map (splitOn ":\160" . strip) parsedComps

extractDescComps :: String -> [String]
extractDescComps desc =  extractTags components
  where components = gmatchRegexPR p desc
        p = "<b>(.*?)<br/>"

extractTags :: [RegexMatch] -> [String]
extractTags = foldl (\acc x -> acc ++ extractTag' x) []
  where extractTag' ((tag, (_, _)), [(_, _)]) = [tag]

createEvent :: String -> String -> Day -> String -> Event
createEvent title rawDesc date link =
  let descriptionMap = parseDescription rawDesc
      getField field = M.lookup field descriptionMap
  in Event
          { eventTitle = title
          , eventDate = date
          , eventLink = link
          , eventVenue = getField "Event Venue"
          , eventAdditionalInformation = getField "Additional Information"
          , eventCityTown = getField "City / Town"
          , eventContactEmail = getField "Contact Email"
          , eventContactName = getField "Contact Name"
          , eventCost = getField "Cost"
          , eventCategory = getField "Event Category"
          , eventNeighbourhood = getField "Neighbourhood"
          , eventProjectName = getField "Project Name"
          , eventPublicEngagementCategory = getField "Public Engagement Category"
          , eventShortDescription = getField "Short Description"
          , eventWhereToPurchaseTickets = getField "Where to purchase tickets"
          , eventRawDescription = rawDesc
          }

parseEvent :: Element -> Maybe Event
parseEvent item = do
  title <- getTextContent $ findChild (unqual "title") item
  rawDesc <- getTextContent $ findChild (unqual "description") item
  date <- getTextContent (findChild (unqual "category") item) >>= parseEventDate
  link <- getTextContent $ findChild (unqual "link") item

  return $ createEvent title rawDesc date link
