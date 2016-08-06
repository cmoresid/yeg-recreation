module YEGRec.Types where

import Data.Time
import YEGRec.Util

data Event = Event
  { _title :: String
  , _eventDate :: Day
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
  , _rawDescription :: String
  }
  deriving (Show, Eq)
