module YEGRec.XMLUtil where

import Text.XML.Light

getTextContent :: Maybe Element -> Maybe String
getTextContent elm =
  case elm of
    Nothing -> Nothing
    Just item ->
      let [Text title_content] = elContent item
      in Just (cdData title_content)
