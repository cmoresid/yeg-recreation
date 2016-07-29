{-# LANGUAGE Arrows #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module YEGRec.XMLUtil where

import Text.XML.HXT.Core

atTag tag = deep (isElem >>> hasName tag)

text = getChildren >>> getText
