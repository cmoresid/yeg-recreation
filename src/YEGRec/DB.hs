{-# LANGUAGE FlexibleContexts #-}

module YEGRec.DB where

-------------------------------------------------------------------------------
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Logger (runNoLoggingT, runStdoutLoggingT)
import Control.Monad.Trans.Class (MonadTrans, lift)
import Control.Monad.Reader (MonadReader, ReaderT, asks, runReaderT)

import qualified Data.Text as T
import Data.Text.Encoding (encodeUtf8)

import qualified Database.Persist as DB
import qualified Database.Persist.Postgresql as DB

import System.Environment (lookupEnv)

import Web.Heroku (parseDatabaseUrl)

import YEGRec.Types
import YEGRec.Configuration
-------------------------------------------------------------------------------

-- |Create a connection pool based on current environment.
getConnectionPool :: Environment -> IO DB.ConnectionPool
getConnectionPool e = do
  s <- getConnectionString e
  let n = getConnectionPoolSize e
  case e of
    Development -> runStdoutLoggingT $ DB.createPostgresqlPool s n
    Test -> runNoLoggingT $ DB.createPostgresqlPool s n
    Production -> runStdoutLoggingT $ DB.createPostgresqlPool s n

-- |Retrieve the size of the connection pool based on the environment we're in.
getConnectionPoolSize :: Environment -> Int
getConnectionPoolSize e =
  case e of
    Development -> 1
    Test -> 1
    Production -> 8

-- |Retrieve the database URL from the environment and
getConnectionString :: Environment -> IO DB.ConnectionString
getConnectionString e = do
  m <- lookupEnv "DATABASE_URL"
  let s = case m of
            Nothing -> error "$DATABASE_URL is not defined"
            Just u -> createConnectionString $ parseDatabaseUrl u
  return s

{-|
  Takes the results of Web.Heroku.parseDatabaseUrl and converts it into an HDBC
  compatible connection string.
-}
createConnectionString :: [(T.Text, T.Text)] -> DB.ConnectionString
createConnectionString l =
    let f (k, v) = T.concat [k, T.pack "=", v]
    in encodeUtf8 $ T.unwords $ map f l

-- |Executes a command against the database, while fitting into Scotty env.
runDB :: (MonadTrans t, MonadIO (t ConfigM)) =>
  DB.SqlPersistT IO a -> t ConfigM a
runDB q = do
  p <- lift (asks pool)
  liftIO $ DB.runSqlPool q p

-- |Performs any SQL migrations, if necessary.
migrateSchema :: Config -> IO ()
migrateSchema c =
  liftIO $ flip DB.runSqlPersistMPool (pool c) $ DB.runMigration migrateAll
