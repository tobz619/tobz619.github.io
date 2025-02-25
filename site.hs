--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import  Hakyll
import  Control.Monad(forM_)


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration { 
    destinationDirectory = "docs",
    previewPort = 51500
    }

main :: IO ()
main = hakyllWith config $ do
    forM_ [ "images/*"
          , "css/*"
          , "robots.txt"
          , "CV/current-cv.pdf"
      ] $ \f -> match f $ do
        route   idRoute
        compile copyFileCompiler

    forM_ [ "about.rst"
          , "contact.markdown"
      ] $ \f -> match f $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "All Posts"           <>
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" <>
    defaultContext
