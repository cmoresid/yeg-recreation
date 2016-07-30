module YEGRec.Util where

import Network.HTTP

extract :: Maybe String -> String
extract (Just m) = m
extract Nothing = "Unknown"

downloadFile :: String -> IO String
downloadFile url = simpleHTTP (getRequest url) >>= getResponseBody
