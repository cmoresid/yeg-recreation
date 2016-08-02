import Test.Hspec
import Test.QuickCheck
import Data.Time

import YEGRec.Types
import YEGRec.Parse

main :: IO ()
main = hspec $ do
  describe "YEGRec.Parser.parseDateTime" $ do
    it "parses a valid date from date string" $
      parseEventDate "2016/08/02 (Tue)" `shouldBe` (Just $ fromGregorian 2016 8 2)
    it "returns Nothing for invalid date string" $
      parseEventDate "" `shouldBe` Nothing

  describe "YEGRec.Parser.parseEventFeedXml" $
    it "parses one event successfully" $ do
      e <- readFile "test/one_event.rss"
      parseEventFeedXml e `shouldBe` [Just
                                        Event {_title = "Sean Caulfield: The Flood"
                                                 , _eventDate = Just $ fromGregorian 2016 2 6
                                                 , _link = "http://www.edmonton.ca/attractions_events/schedule_festivals_events/events-calendar.aspx?trumbaEmbed=view%3devent%26eventid%3d117969785"
                                                 , _venue = Nothing
                                                 , _additionalInformation = Nothing
                                                 , _cityTown = Nothing
                                                 , _contactEmail = Nothing
                                                 , _contactName = Nothing
                                                 , _cost = Nothing
                                                 , _eventCategory = Nothing
                                                 , _neighbourhood = Nothing
                                                 , _projectName = Nothing
                                                 , _publicEngagementCategory = Nothing
                                                 , _shortDescription = Nothing
                                                 , _whereToPurchaseTickets = Nothing
                                                 , _rawDescription = Nothing
                                                 }]
