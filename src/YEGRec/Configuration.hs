{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts #-}

module YEGRec.Configuration where

-------------------------------------------------------------------------------
import Control.Concurrent.STM
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT, asks, ask, runReaderT)
import Control.Monad.Trans.Class (MonadTrans, lift)

import Data.Default (def)
import Data.Text.Lazy (Text)

import qualified Database.Persist as DB
import qualified Database.Persist.Postgresql as DB

import Network.Wai.Handler.Warp (Settings, defaultSettings,
  setFdCacheDuration, setPort)

import Web.Scotty.Trans (ActionT, Options, settings, verbose)

import System.Environment (lookupEnv)
-------------------------------------------------------------------------------

-- |Defines the different environments that this app can run in.
data Environment = Development | Production | Test deriving (Show, Read, Eq)

-- |Encapsulates the configuration information needed to run the application.
data Config = Config { env :: Environment, pool :: DB.ConnectionPool }

-- |Error definition.
type Error = Text

-- |Defines common action.
type Action = ActionT Error ConfigM ()

-- |Allows interfacing with Scotty's application monad.
newtype ConfigM a =
  ConfigM
    {runConfigM :: ReaderT Config IO a
    } deriving (Applicative, Functor, Monad, MonadIO, MonadReader Config)

-- |Get which environment to run from the environment variable "SCOTTY_ENV"
getEnvironment :: IO Environment
getEnvironment = fmap (maybe Development read) (lookupEnv "SCOTTY_ENV")

-- |Get the port number that the app should run on.
getPort :: IO (Maybe Int)
getPort = do
  m <- lookupEnv "PORT"
  let p = case m of
            Nothing -> Nothing
            Just s -> Just $ read s
  return p

getSettings :: Environment -> IO Settings
getSettings e = do
  let s = defaultSettings
      s' = case e of
            Development -> setFdCacheDuration 0 s
            Test -> s
            Production -> s
  m <- getPort
  let s'' = case m of
              Nothing -> s'
              Just p -> setPort p s'
  return s''

getOptions :: Environment -> IO Options
getOptions e = do
  s <- getSettings e
  return def
    { settings = s
    , verbose = case e of
        Development -> 1
        Test -> 0
        Production -> 1
    }
