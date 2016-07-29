module YEGRec.Types where

import Data.Time

data Event = Event
  { _title :: String
  , _eventDate :: Maybe Day
  , _link :: String
  , _venue :: Maybe String
  , _additionalInformation :: Maybe String
  , _cityTown :: Maybe String
  , _contactEmail :: Maybe String
  , _contactName :: Maybe String
  , _cost :: Maybe String
  , _eventCategory :: Maybe String
  , _neighbourhood :: Maybe String
  , _projectName :: Maybe String
  , _publicEngagementCateogry :: Maybe String
  , _shortDescription :: Maybe String
  , _whereToPurchaseTickets :: Maybe String
  , _rawDescription :: Maybe String
  }

parseEventDate :: String -> Maybe Day
parseEventDate dt = parseTimeM True defaultTimeLocale "%Y/%m/%d" dtStripped
  where dtStripped = take 10 dt
