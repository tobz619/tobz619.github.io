{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module MyCss where

import Clay
import Clay.Stylesheet (key)
import Control.Monad
import Data.Text (Text)
import qualified Data.Text.Lazy.IO as T
import Prelude hiding ((**), div, rem)

rootInfo =
  ":root" `root` do
    ".--colour-hover-bg" & color hoverBg
    ".--colour-hover-fg" & color hoverFg
    ".--colour-active-bg" & color activeBg
    ".--colour-active-fg" & color activeFg
    ".--colour-border" & color borderCol

hoverBg, hoverFg, activeBg, activeFg :: Color
hoverBg = rgb 0x00 0xc8 0xc8
hoverFg = white
activeBg = rgb 0x00 0xde 0x32
activeFg = white

borderCol :: Color
borderCol = (rgb 0xa6 0xa6 0xa6)

myHtml =
  html ? do
    fontSize (pct 62.5)
    sym margin auto
    minWidth (px 830)
    minHeight (px 400)
    fontFamily [] [sansSerif]
    maxWidth (px 1200)

p :: Css
p =
  "p" ? do
    sym2 padding (em 0.12) (em 0.12)
    fontSize (em 1.5)
    color (rgb 0x55 0x55 0x55)

footerCSS =
  footer ? do
    display grid
    gridTemplateRows [rem 4, auto]
    gridArea "footer"
    minWidth (pct 60)
    paddingTop (rem 2)
    borderTop (rem 0.5) solid borderCol
    sym borderRadius (rem 0.1)
    gridArea "footer"

myH1 = h1 ? fontSize (rem 2.5)

myH2 = h2 ? fontSize (rem 2)

article = do
  "article.header" ? do
    fontSize (rem 1.4)
    fontStyle italic
    color (rgb 5 5 5)

contentCSS =
  "#content" ? do
    display grid
    paddingLeft (px 50)
    paddingRight (px 50)
    minWidth (px 500)
    alignContent spaceBetween
    gridTemplateColumns [fr 999, fr 1]
    gridArea "content"
    gridTemplateAreas ["text mainface"]

gridTemplateRows :: [Size a] -> Css
gridTemplateRows = key "grid-template-rows" . noCommas

gridTemplateAreas :: [Text] -> Css
gridTemplateAreas = key "grid-template-areas" . noCommas . fmap Literal

bodyCSS :: Css
bodyCSS =
  "body" ? do
    display grid
    minWidth (px 480)
    backgroundColor (rgb 0xe6 0xe6 0xe6)
    color (rgb 0x55 0x55 0x55)
    fontSize (rem 1.5)
    gridTemplateColumns [fr 1, fr 30]
    gridTemplateRows [fr 5, fr 1]
    gridTemplateAreas ["sidenav content", "sidenav footer"]
    justifyContent spaceEvenly

containerG cols rows =
  ".containerG" ? do
    display grid
    gridTemplateColumns cols
    gridTemplateRows rows
    div ? do
      backgroundColor (rgb 0xf1 0xf1 0xf1)
      border (px 1) solid black

codeCSS :: Css
codeCSS =
  ".code" ? do
    alignItems center

sideNav :: Css
sideNav = do
  "#sidenav" ? do
    zIndex 1
    overflowX hidden
    display grid
    alignContent flexStart
    minWidth (rem 16)
    gridArea "sidenav"

  "#sidenav a" <? do
    fontSize (rem 1.8)
    textTransform uppercase
    display block
    myBoxShadow 5 5 0.5
    paddingBottom (rem 2)
    textDecoration none
    maxWidth (pct 90)
    marginTop (px 5)
    color black
    border (px 3) solid black
    transitionDuration (ms 750)
    transitionTimingFunction ease

    hover & do
      backgroundColor hoverBg
      color hoverFg
      fontWeight (weight 1000)
      transitionDuration (ms 150)
      transitionTimingFunction ease
    active & do
      clickAnim


clickAnim = do
    backgroundColor activeBg
    color activeFg
    fontWeight (weight 1000)
    transitionDuration (ms 150)
    transitionTimingFunction ease

    transform (translate (px 4) (px 4))
    boxShadow . pure $ none

image :: Number -> FloatStyle -> Css
image sz fl = do
  div <? "#mainface" ? do
    marginTop (pct 40)

  div <? "#miniface" ? do
    height (px 32)
    width auto
    float floatRight
    sym margin (px 5)

myBoxShadow :: Number -> Number -> Float -> Css
myBoxShadow distX distY alpha = do
  boxShadow . pure . bsColor (rgba 0 0 0 alpha) $
    shadow (px distX) (px distY)

linksCSS =
  "#links" ? do
    display flex
    justifyContent spaceEvenly
    alignContent center    
    a <? do 
      display flex
      justifyContent center
      alignItems center
      alignContent center
      sym padding (px 3)
      transitionDuration (ms 1500)
      transitionTimingFunction ease
    a ? img <? do
      display flex
      maxWidth (em 4)
      maxHeight (em 4)
      transformBox fillBox
    a # hover <? do 
      myBoxShadow 4 4 0.5
      transform (translate (px (-2)) (px (-2)))
      multiColourBorder
      transitionDuration (ms 150)
      transitionTimingFunction ease
    a # active <? do
      clickAnim
        

hakyllCSS =
  "#hakyll" ? do
    display flex
    justifyContent center
    alignContent center

lastUpdateCSS =
  "#last-update" ? do
    display flex
    justifyContent center
    alignContent center

multiColourBorder = do
  border (px 2) solid (rgb 0x55 0x55 0xff)
    -- backgroundImage
    --   ( radialGradient
    --       (pct 120)
    --       (circle farthestCorner)
    --       (fmap (,auto) [red, orange, yellow, green, blue, indigo, violet, red])
    --   )

genCSS :: IO ()
genCSS =
  T.writeFile "css/default.css" $
    renderWith pretty [] $ do
      rootInfo
      myHtml
      bodyCSS
      contentCSS
      image 200 floatRight
      sideNav
      codeCSS
      hakyllCSS
      linksCSS
      lastUpdateCSS
      footerCSS
      containerG [auto, auto] [auto, auto]
