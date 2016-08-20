module YEGRec.Migrate where

-------------------------------------------------------------------------------
import Control.Monad.Logger
import Control.Monad.IO.Class (liftIO)

import qualified Database.Persist as DB
import qualified Database.Persist.Postgresql as DB

import Data.Maybe

import YEGRec.Configuration
import YEGRec.DB
import YEGRec.Parse
import YEGRec.Types
import YEGRec.Util
-------------------------------------------------------------------------------

-- |Alias for string
type Url = String

-- |Get latest events from feed and insert into database.
migrateEvents :: Url -> IO ()
migrateEvents url = do
  e <- getEnvironment
  c <- getConnectionString e

  runStdoutLoggingT $ DB.withPostgresqlPool c 10 $ \pool ->
    liftIO $ flip DB.runSqlPersistMPool pool $ do
      events <- liftIO $ getEvents url
      DB.insertMany_ events

-- |Retrieve RSS feed, parse feed, and return parsed events.
getEvents :: Url -> IO [Event]
getEvents url = do
  feed <- getEventFeed url
  let maybeEvents = filter isJust $ parseEventFeedXml feed
      events = map fromJust maybeEvents

  return events
