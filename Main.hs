--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (forM_)
import Hakyll
import MyCss(genCSS)
import GHC.IO

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
        "CV/current-cv.pdf",
        "assets/*"
      ]
      $ \f -> match f $ do
        route idRoute
        compile copyFileCompiler

    forM_
      [ "about.md",
        "contact.markdown"
      ]
      $ \f -> match f $ do
        route $ setExtension "html"
        compile $
          pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
      route $ setExtension "html"
      compile $
        pandocCompiler
          >>= loadAndApplyTemplate "templates/post.html" postCtx
          >>= loadAndApplyTemplate "templates/default.html" postCtx
          >>= relativizeUrls

    match "creations.html" $ do
      route idRoute
      compile $
        pandocCompiler
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    -- create ["videos.html"] $ do
    --   route idRoute
    --   compile $ do
    --     videos <- loadAll "videos/*"
    --     let videoCtx = listField "videos" defaultContext (return videos) <>
    --                    defaultContext
    --     makeItem ""
    --       >>= loadAndApplyTemplate "templates/videos.html" videoCtx
    --       >>= loadAndApplyTemplate "templates/default.html" defaultContext
    --       >>= relativizeUrls

    create ["archive.html"] $ do
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let archiveCtx =
              listField "posts" postCtx (return posts)
                <> constField "title" "All Posts"
                <> defaultContext

        makeItem ""
          >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
          >>= loadAndApplyTemplate "templates/default.html" archiveCtx
          >>= relativizeUrls

    match "index.html" $ do
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let indexCtx =
              listField "posts" postCtx (return posts)
                <> defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y"
    <> defaultContext
