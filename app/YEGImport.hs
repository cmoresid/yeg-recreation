module Main where

-------------------------------------------------------------------------------
import YEGRec.Migrate
-------------------------------------------------------------------------------

url = "http://www.trumba.com/calendars/city-of-edmonton-calendar.rss"

main :: IO ()
main = migrateEvents url
