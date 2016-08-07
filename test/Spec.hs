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

  describe "YEGRec.Parser.parseEventFeedXml" $ do
    it "parses zero events successfully" $ do
      e <- readFile "test/zero_events.rss"
      parseEventFeedXml e `shouldBe` []
    it "parses all events successfully" $ do
      e <- readFile "test/full_feed.rss"
      length (parseEventFeedXml e) `shouldBe` 200
    it "parses one event successfully" $ do
      e <- readFile "test/one_event.rss"
      parseEventFeedXml e `shouldBe` [Just
                                        Event { eventTitle = "Sean Caulfield: The Flood"
                                              , eventDate = fromGregorian 2016 2 6
                                              , eventLink = "http://www.edmonton.ca/attractions_events/schedule_festivals_events/events-calendar.aspx?trumbaEmbed=view%3devent%26eventid%3d117969785"
                                              , eventVenue = Just "Art Gallery of Alberta"
                                              , eventAdditionalInformation = Nothing
                                              , eventCityTown = Just "Edmonton"
                                              , eventContactEmail = Nothing
                                              , eventContactName = Nothing
                                              , eventCost = Just "FREE"
                                              , eventCategory = Just "Exhibits"
                                              , eventNeighbourhood = Just "Downtown"
                                              , eventProjectName = Nothing
                                              , eventPublicEngagementCategory = Nothing
                                              , eventShortDescription = Just "2016 Manning Hall Commission"
                                              , eventWhereToPurchaseTickets = Nothing
                                              , eventRawDescription = "ART GALLERY OF ALBERTA<br />2 Sir Winston Churchill Square<br />Edmonton AB T5J 2C1 <br/>Ongoing through Sunday, August 14, 2016, 5pm <br/><br/><img src=\"http://www.trumba.com/i/DgBzLSlWFXj27mZrW%2AuuZd0Y.jpg\" width=\"100\" height=\"49\" /><br/><br/>The 2016 Manning Hall Commission features a new site-specific installation by Edmonton artist Sean Caulfield entitled The Flood. The imagery presented in the work follows Caulfield&#8217;s ongoing explorations into the impact of technological advancements on our environment. <br/><br/><b>City / Town</b>:&nbsp;Edmonton <br/><b>Event Venue</b>:&nbsp;Art Gallery of Alberta <br/><b>Neighbourhood</b>:&nbsp;Downtown <br/><b>Short Description</b>:&nbsp;2016 Manning Hall Commission <br/><b>Event Category</b>:&nbsp;Exhibits <br/><b>Cost</b>:&nbsp;FREE <br/><b>More info</b>:&nbsp;<a href=\"http://www.youraga.ca/exhibit/sean-caulfield-the-flood\" target=\"_blank\" title=\"http://www.youraga.ca/exhibit/sean-caulfield-the-flood\">www.youraga.ca&#8230;</a> <br/><br/>"
                                              }]
