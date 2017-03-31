import Options.Applicative;
import Data.Semigroup ((<>));
import Control.Monad;
import System.IO

-- Arguments data structures
data Action 
  = Represent 
  | Transform 

data Arguments = Arguments
  { action :: Action 
  , path :: String
  }

-- Argument handling with optparse-applicative package
sample :: Parser Arguments
sample = Arguments
      <$> (parseRepresent <|> parseTransform)
      <*> argument str (metavar "FILE" <> value "")
  where
    parseRepresent = flag' Represent
        ( long "represent" 
        <> short 'r' 
        <> help "Converts regular expression from input to internal representation and prints it out of it."
        )

    parseTransform = flag' Transform
        ( long "transform" 
        <> short 't' 
        <> help "Converts regular expression from input to finite state machine on output."
        )

-- Regex data structures
data Tree = BinaryOperation Char Tree Tree | Character Char | Star Char Tree deriving Show -- jmena operací místo současných konstruktorů
type Stack = [Tree] 

-- TODO: Also implement own Show method to be able to print out readable regex
--instance Show Tree where
    --show (BinaryOperation  c ft st) = c : (show  ft) ++ (show st)
    --show (Star c t) = c : (show t) 
    --show (Character c) = [c]
    --show (BinaryOperation c lt rt) = c : show lt ++ show rt
    --show (Star c lt) = c : (show lr)

-- TODO: Finish these data structures
-- Finite State Machine structures
data FSM = FSM
    { 	states :: [TState] 
    ,  	alphabet :: [Char]
    ,	transitions :: [TTransition]  
    ,	initialState :: TState
    ,	finalStates :: [TState]
    } 

instance Show FSM where
	show (FSM s a t i f) = displayStates  ++ displayInitialStates ++ displayFinalStates ++ displayTransitions
		where
			displayStates = "Printing out states\n"
			displayInitialStates = "Printing out initial states\n"
			displayFinalStates = "Priting out final states\n"
			displayTransitions = "Printing out transitions\nPrinting out transitions\nPrinting out transitions\nPrinting out transitions\nPrinting out transitions\n"

-- Transition 
data TTransition = TTransition
	{	from :: TState
	,	symbol :: Char
	,	to :: TState
	} deriving (Show)

type TState = Int deriving (Show)


representTree :: Tree -> String 
representTree (Character c) = [c]
representTree (Star c tree) = c : representTree tree
representTree (BinaryOperation c leftTree rightTree) =  c :  (representTree rightTree) ++ (representTree leftTree)   


-- Function that executes a step of parsing (http://stackoverflow.com/questions/36277160/haskell-reverse-polish-notation-regular-expression-to-expression-tree)
-- TODO-NO-RESPECT: Replace this with something that does not consider [Tree], but Tree only
parseCharacter :: Stack -> Char -> Stack
parseCharacter (r:l:s)  '.'   =  (BinaryOperation '.' l r):s
parseCharacter (r:l:s)  '+'   =  (BinaryOperation '+' l r):s
parseCharacter (r:s)    '*'   =  (Star '*' r):s
parseCharacter s c            =  (Character c):s

-- Reads and stores RPN regex from input in stack structure
readRPNRegex :: String -> Stack
readRPNRegex = foldl parseCharacter []  -- $$$ REFERENCE NA Tree || binop/character  $$$
-- foldl parseCharacter [] 
-- readRPNRegex :: String -> Maybe Tree
-- readRPNRegex s =
--    case result of 
--        [t] -> Just t
--        []  -> Nothing
--        _   -> error "whoops"
--        where result = foldl step [] s

-- printRPNRegex :: Stack -> String
-- printRPNRegex x = "Unwrapped..."


main :: IO ()
main = do
  processInput =<< execParser opts
      where
        opts = info (sample <**> helper)
          ( fullDesc
         <> progDesc "Based on provided parameters transforms a regular expression to finite state machine. "
         <> header "Converts regex from the input to finite state machine on output." )
  


processInput :: Arguments -> IO ()
processInput (Arguments a file) = case a of
    Represent -> demonstrateRegexRepresentation file
    Transform -> putStrLn $ tbranch "string_filename" 


tbranch :: String -> String
tbranch file = "Welcome in T branch, with file: " 


-- Demonstrates program's capability to store RV from input in internal representation
demonstrateRegexRepresentation :: String -> IO ()
demonstrateRegexRepresentation file = do
  content <- readFile file
  putStrLn $ reverse $ representTree $ head $ head $ map readRPNRegex $ lines content   -- TODO: Consider encapsulating issue with double head, it's not really nice
