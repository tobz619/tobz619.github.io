module MyCss where

{-# LANGUAGE OverloadedStrings #-}
import           Clay
import qualified Data.Text.Lazy.IO as T

test :: Css
test = undefined

fancyButton :: Css
fancyButton = ".fancy-button" ?
 do backgroundColor tomato
    sym2 padding    (em 0.5) (em 1)
    sym borderRadius (px 5)
    color             white
    border            solid (px 1) red

     hover &
       do color        green

main :: IO ()
main - T.putStr $ renderWith compact test