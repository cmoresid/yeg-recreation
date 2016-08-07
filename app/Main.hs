module Main where

import Control.Concurrent.STM
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT, asks, ask, runReaderT)
import Control.Monad.Trans.Class (MonadTrans, lift)

import qualified Database.Persist as DB
import qualified Database.Persist.Postgresql as DB

import Data.Default.Class (def)

import System.Environment (lookupEnv)

import Web.Scotty.Trans (ActionT, Options, ScottyT, defaultHandler, delete,
  get, json, jsonData, middleware, notFound, param, post, put, scottyOptsT,
  settings, showError, status, verbose)

import YEGRec.Configuration
import YEGRec.DB
import YEGRec.Middleware
import YEGRec.Types

runApplication :: Config -> IO ()
runApplication c = do
  o <- getOptions (env c)
  let r m = runReaderT (runConfigM m) c
  scottyOptsT o r r application

application :: ScottyT Error ConfigM ()
application = do
  runDB $ DB.runMigration migrateAll
  e <- lift (asks env)
  middleware $ loggingM e
  defaultHandler $ defaultH e

getConfig :: IO Config
getConfig = do
  e <- getEnvironment
  p <- getConnectionPool e
  return Config { env = e, pool = p}

main :: IO ()
main = getConfig >>= runApplication
