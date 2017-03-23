-- Import relevant modules
import System.IO    -- for readFile
import System.Environment -- for parameter handling



-- Hardcored file to be read (testing only)
-- inputFileName = "TestData/test-input.in"
inputFileName = "TestData/test-input.in"

rv2rka :: String -> IO ()
rv2rka inputFile = do
    putStrLn "Original content of file will be printed to output"
    arguments <- getArgs
    putStrLn (show arguments)
    --contents <- readFile inputFileName
    --putStrLn contents
    putStrLn "Done"


main = do
    arguments <- getArgs
    rv2rka inputFileName



-- Stack implementation from Stack Overflow 
-- data Tree
--     = Symbol Char
--     | Concat Tree Tree
--     | Star Tree
--     deriving Show
-- 
-- type Stack = [Tree]
-- 
-- step :: Stack -> Char -> Stack
-- step (r:l:s) '.' = (Concat r l):s
-- step (t:s) '+' = (Star t):s
-- step s c = (Symbol c):s
-- 
-- parse :: String -> Stack
-- parse = foldl step []

-- print implementation
-- print var = putStrLn (show var)