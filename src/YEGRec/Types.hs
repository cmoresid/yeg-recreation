module YEGRec.Types where

import Data.Time
import YEGRec.Util

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
  , _publicEngagementCategory :: Maybe String
  , _shortDescription :: Maybe String
  , _whereToPurchaseTickets :: Maybe String
  , _rawDescription :: Maybe String
  }
  deriving (Show, Eq)

createMinimalEvent :: Maybe String -> Maybe Day -> Maybe String -> Event
createMinimalEvent title date link = Event
  { _title = extract title
  , _eventDate = date
  , _link = extract link
  , _venue = Nothing
  , _additionalInformation = Nothing
  , _cityTown = Nothing
  , _contactEmail = Nothing
  , _contactName = Nothing
  , _cost = Nothing
  , _eventCategory = Nothing
  , _neighbourhood = Nothing
  , _projectName = Nothing
  , _publicEngagementCategory = Nothing
  , _shortDescription = Nothing
  , _whereToPurchaseTickets = Nothing
  , _rawDescription = Nothing
  }
