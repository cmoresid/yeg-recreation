module YEGRec.Util where

import Network.HTTP
import qualified Data.Text as T

extract :: Maybe String -> String
extract (Just m) = m
extract Nothing = "Unknown"

downloadFile :: String -> IO String
downloadFile url = simpleHTTP (getRequest url) >>= getResponseBody

strip :: String -> String
strip = T.unpack . T.strip . T.pack

toTuple :: [a] -> (a, a)
toTuple [a, b] = (a, b)
