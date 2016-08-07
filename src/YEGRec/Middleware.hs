{-# LANGUAGE OverloadedStrings #-}

module YEGRec.Middleware where

-------------------------------------------------------------------------------
import Data.Aeson (Value (Null), (.=), object)

import Network.HTTP.Types.Status (internalServerError500)

import Network.Wai (Middleware)
import Network.Wai.Middleware.RequestLogger (logStdout, logStdoutDev)

import Web.Scotty.Trans (status, showError, json)

import YEGRec.Configuration
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
