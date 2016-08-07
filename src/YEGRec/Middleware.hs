{-# LANGUAGE OverloadedStrings #-}

module YEGRec.Middleware where

-------------------------------------------------------------------------------
import Data.Aeson (Value (Null), (.=), object)

import qualified Database.Persist as DB
import qualified Database.Persist.Postgresql as DB

import Network.HTTP.Types.Status (internalServerError500, notFound404)

import Network.Wai (Middleware)
import Network.Wai.Middleware.RequestLogger (logStdout, logStdoutDev)

import Web.Scotty.Trans (status, showError, json)

import YEGRec.Configuration
import YEGRec.Types
import YEGRec.DB
-------------------------------------------------------------------------------

-- |Defines the logging middleware.
loggingM :: Environment -> Middleware
loggingM Development = logStdoutDev
loggingM Test = id
loggingM Production = logStdout

-- |This is the default handler. It is called when all other routes fail.
defaultH :: Environment -> Error -> Action
defaultH e x = do
  status internalServerError500
  let o = case e of
            Development -> object ["error" .= showError x]
            Test -> object["error" .= showError x]
  json o

notFoundA :: Action
notFoundA = do
  status notFound404
  json Null

getEventsA :: Action
getEventsA = do
  ts <- runDB (DB.selectList [] [])
  json (ts :: [DB.Entity Event])
