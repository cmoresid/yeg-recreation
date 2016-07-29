import Test.Hspec
import Test.QuickCheck
import Data.Time

import YEGRec.Types

main :: IO ()
main = hspec $
  describe "YEGRec.Types.parseDateTime" $ do
    it "parses a valid date from date string" $
      parseEventDate "2016/08/02 (Tue)" `shouldBe` (Just $ fromGregorian 2016 8 2)
    it "returns Nothing for invalid date string" $
      parseEventDate "" `shouldBe` Nothing