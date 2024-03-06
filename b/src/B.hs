module B
  ( run
  ) where

import A qualified

run :: IO ()
run = do
  A.run
  putStrLn "B.run"
