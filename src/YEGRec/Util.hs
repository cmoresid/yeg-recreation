module YEGRec.Util where

import Network.HTTP
import qualified Data.Text as T

-- |Downloads the latest RSS event feed.
getEventFeed :: String -> IO String
getEventFeed feedUrl = simpleHTTP (getRequest feedUrl) >>= getResponseBody

-- |Trims the whitespace from the front and back of string.
strip :: String -> String
strip = T.unpack . T.strip . T.pack

-- |Converts a list of length 2 to a 2-tuple.
toTuple :: [a] -> (a, a)
toTuple [a, b] = (a, b)
