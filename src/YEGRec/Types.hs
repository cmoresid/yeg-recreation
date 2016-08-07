{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module YEGRec.Types where

-------------------------------------------------------------------------------
import Data.Time

import Database.Persist.TH (mkMigrate, mkPersist, persistLowerCase, share,
  sqlSettings)

import YEGRec.Util
-------------------------------------------------------------------------------

-- |Type synonym to represent a global regex match on string
type RegexMatch = ((String, (String, String)), [(Int, String)])

-- |Creates the Event record type / entity.
share [mkMigrate "migrateAll", mkPersist sqlSettings] [persistLowerCase|
  Event json
    title String
    date Day
    link String
    venue String Maybe
    additionalInformation String Maybe
    cityTown String Maybe
    contactEmail String Maybe
    contactName String Maybe
    cost String Maybe
    category String Maybe
    neighbourhood String Maybe
    projectName String Maybe
    publicEngagementCategory String Maybe
    shortDescription String Maybe
    whereToPurchaseTickets String Maybe
    rawDescription String
    deriving Show Eq
|]
