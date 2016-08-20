{-# LANGUAGE OverloadedStrings #-}

module Main where

-------------------------------------------------------------------------------
import Control.Monad.Reader (runReaderT)

import System.Environment (lookupEnv)

import Web.Scotty.Trans (ActionT, Options, ScottyT, defaultHandler, delete,
  get, middleware, notFound, param, post, put, scottyOptsT)
-------------------------------------------------------------------------------
import YEGRec.Configuration
import YEGRec.DB
import YEGRec.Migrate
import YEGRec.Middleware
import YEGRec.Types
-------------------------------------------------------------------------------

-- |Get configuration information of ENV variables.
getConfig :: IO Config
getConfig = do
  e <- getEnvironment
  p <- getConnectionPool e
  return Config { env = e, pool = p}

-- |Configure Scotty application.
runApplication :: Config -> IO ()
runApplication c = do
  o <- getOptions (env c)
  let r m = runReaderT (runConfigM m) c
      app = application c
  scottyOptsT o r app

-- |Configure Scotty application
application :: Config -> ScottyT Error ConfigM ()
application c = do
  middleware $ loggingM (env c)
  defaultHandler $ defaultH (env c)
  -- Add event routes
  get "/api/events" getEventsA
  -- Add not found handler
  notFound notFoundA

-- |Beam me up Scotty!
main :: IO ()
main = do
  c <- getConfig
  migrateSchema c
  runApplication c
