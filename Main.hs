--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (forM_)
import Hakyll
import MyCss(genCSS)
import GHC.IO
import Data.List (unsnoc)

--------------------------------------------------------------------------------
config :: Configuration
config =
  defaultConfiguration
    { destinationDirectory = "docs",
      previewPort = 51500
    }

main :: IO ()
main = do 
  putStrLn $ "Generating css"
  _ <- genCSS
  putStrLn $ "CSS generated"
  
  hakyllWith config $ do
    forM_
      [ "images/*",
        "css/*.css",
        "robots.txt",
        "assets/*"
      ]
      $ \f -> match f $ do
        route idRoute
        compile copyFileCompiler

    match "CV/*.pdf" $ do
      route $ constRoute "cv.pdf"
      compile $ copyFileCompiler

    forM_
      [ "about.md",
        "contact.md"
      ]
      $ \f -> match f $ do
        route $ setExtension "html"
        compile $
          pandocCompiler
            >>= loadAndApplyTemplate "html/templates/default.html" defaultContext
            >>= relativizeUrls

    match "html/templates/*" $ compile templateBodyCompiler

    match "posts/*" $ do
      route $ setExtension "html"
      compile $
        pandocCompiler
          >>= loadAndApplyTemplate "html/templates/post.html" postCtx
          >>= loadAndApplyTemplate "html/templates/default.html" postCtx
          >>= relativizeUrls

    match "html/base/creations.html" $ do
      route $ customRoute (baseName . toFilePath)
      compile $
        pandocCompiler
          >>= loadAndApplyTemplate "html/templates/default.html" defaultContext
          >>= relativizeUrls


    create ["archive.html"] $ do
      route $ customRoute (baseName . toFilePath)
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let archiveCtx =
              listField "posts" postCtx (return posts)
                <> constField "title" "All Posts"
                <> defaultContext

        makeItem ""
          >>= loadAndApplyTemplate "html/templates/archive.html" archiveCtx
          >>= loadAndApplyTemplate "html/templates/default.html" archiveCtx
          >>= relativizeUrls

    match "html/base/index.html" $ do
      route $ customRoute (baseName . toFilePath)
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let indexCtx =
              listField "posts" postCtx (return posts)
                <> defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= loadAndApplyTemplate "html/templates/default.html" indexCtx
          >>= relativizeUrls

    match "html/login/login.html" $ do
      route $ customRoute (baseName . toFilePath)
      compile $ copyFileCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y"
    <> defaultContext

baseName :: [Char] -> [Char]
baseName = maybe "error" snd . unsnoc . splitOn '/'
  where splitOn ident xs = foldr splitter [[]] xs
          where splitter x (hd:rest)
                  | x == ident = ([]:hd:rest)
                  | otherwise = ((x:hd):rest)