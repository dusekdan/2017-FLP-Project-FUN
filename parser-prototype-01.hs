import Options.Applicative;
import Data.Semigroup ((<>));
import Control.Monad;
import System.IO

-- QUESTION: WILL THIS DO FOR YOU AS ARGUMENT PARSING?
-- QUESTION: HOW WILL ACTUALLY THE SCRIPT WILL BE RUN
-- Arguments data structure
data Arguments = Arguments
  { represent  :: Bool
  , transform :: Bool 
  , path :: String
  }

-- Argument handling with optparse-applicative package
sample :: Parser Arguments
sample = Arguments
      <$> switch (long "represent" <> short 'r' <> help "Converts regular expression from input to internal representation and prints it out of it.")
      <*> switch (long "transform" <>  short 't' <>  help "Converts regular expression from input to finite state machine on output.")
      <*> argument str (metavar "FILE" <> value "")


-- QUESTION: POSSIBLE ISSUES WITH PLAGIATORISM FOR THIS PIECE OF CODE?
-- Tree structure represents parsed regex from input
data Tree = BinaryOperation Char Tree Tree | Character Char | UnaryOperation Tree deriving Show
type Stack = [Tree]

-- Function that executes a step of parsing (http://stackoverflow.com/questions/36277160/haskell-reverse-polish-notation-regular-expression-to-expression-tree)
parseCharacter :: Stack -> Char -> Stack
parseCharacter (r:l:s) '.' = (BinaryOperation '.' l r):s
parseCharacter (r:l:s) '+' = (BinaryOperation '+' l r):s
--parseCharacter (t:s) 
-- QUESTION: HOW DO I HANDLE * (STAR) CHARACTER HERE, WHEN IT IS ONLY UNARY OPERATOR
parseCharacter s c = (Character c):s
-- Reads and stores RPN regex from input in stack structure
readRPNRegex :: String -> Stack
readRPNRegex =  foldl parseCharacter []

printRPNRegex :: Stack -> String
printRPNRegex x = "Unwrapped..."


main :: IO ()
main = do
  processInput =<< execParser opts
      where
        opts = info (sample <**> helper)
          ( fullDesc
         <> progDesc "Based on provided parameters transforms a regular expression to finite state machine. "
         <> header "Converts regex from the input to finite state machine on output." )
  

-- QUESTION: IS THIS ACCEPTABLE WAY OF PROCESSING CONTENTS OF THE FILE?
-- QUESTION: HOW SHOULD I REALLY GET THE FILE CONTENTS TO BE ABLE TO WORK WITH IT PURELY? (OR IS IT ACCEPTABLE TO WORK WITH IO String?)
processInput :: Arguments -> IO ()
processInput (Arguments r t file)
  | (r == True && t == True) = putStrLn "You can not issue both -r and -t switches."
  | (r == True && t == False) = getFileContents file -- putStrLn $ rbranch "string_filename" -- $ ensureFile file
  | (r == False && t == True) = putStrLn $ tbranch "string_filename" -- $ ensureFile file
  | otherwise = putStrLn "You have to enter at least some parameters!"

ensureFile :: String -> String
ensureFile file
  | file == "" = "FILE-IS-STDIN"
  | otherwise = file

rbranch :: String -> String 
rbranch file = "Welcome in R branch, with file: " 

-- ++ (show $ readRPNRegex $ getFileContents file)

tbranch :: String -> String
tbranch file = "Welcome in T branch, with file: " 
-- ++ (show $ readRPNRegex $ getFileContents file)

-- Process input from file in this function (since when you go IO you never go back)
-- Note that it is okay to use if in putStrLn line (tried already) QUESTION?
getFileContents file = do
  fh <- openFile file ReadMode
  content <- hGetContents fh
  putStrLn $ unlines $ map show $ map readRPNRegex $ lines content
  hClose fh  

--processInput (Arguments r t ) = if (t == True && r == True) then (putStrLn $ "You can not have both -t and -r switches provided" ) else putStrLn $ ("You provided " ++ (show t) ++ (show r)) 