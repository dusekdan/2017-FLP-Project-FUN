-- rv-2-rka
-- xdusek21
-- Daniel Dušek

import Options.Applicative
import Data.Semigroup ((<>))
import Control.Monad
import System.IO
import Data.Either
import Data.List (delete)
import System.Exit (exitWith)

{- My custom modules -}
import Types

-- Extra mile: Module that allows output FSM to be displayed in PDF
import FSMDrawer

{----------------------------------------------------------- 
        COMMANDLINE ENTRY POINT & ARGUMENTS PROCESSING 
------------------------------------------------------------}

main :: IO ()
main = do
  processInput =<< execParser opts
      where
        opts = info (parameterDefinitions <**> helper)
          ( fullDesc
         <> progDesc "Reads regular expression in reverse polish notation (postfix) from input file and based on -r|-t switch displays or transforms it to finite state machine."
         <> header "Postfix regex to FSM convertor." )  

parameterDefinitions :: Parser Arguments
parameterDefinitions = Arguments
      <$> (parseRepresent <|> parseTransform <|> parseTransformDraw)
      <*> argument str (metavar "FILE" <> value "")
  where
    parseRepresent = flag' Represent
        ( long "represent" 
        <> short 'r' 
        <> help "Converts regular expression from input to internal representation and then prints it back to standard output."
        )

    parseTransform = flag' Transform
        ( long "transform" 
        <> short 't' 
        <> help "Converts regular expression from input to finite state machine on output."
        )

    parseTransformDraw = flag' TransformDraw
        ( long "trasform-draw"
        <> short 'd'
        <> help "Does the basic transformation but instead of printing string on output, generates image of final state machine."
        )

{-- Based on chosen flag calls for corresponding processing function --}
processInput :: Arguments -> IO ()
processInput (Arguments a file) = case a of
    Represent -> demonstrateRegexRepresentation file
    Transform -> transformRV2FSM file
    TransformDraw -> transformRV2Image file 


{----------------------------------------------------------- 
        INPUT PARSING & OUTPUT FORMATTING FUNCTIONS 
------------------------------------------------------------}

{-- 
    Content serving IO functions for both -r and -t switches
    Note: I designed these functions to be the only ones interacting with IO, hence the $-madness on their last lines 
--}
demonstrateRegexRepresentation :: String -> IO ()
demonstrateRegexRepresentation file = do
  content <- ensureProperInput file
  if lines content == [] then putStr ""
  else putStr $ reverse $ representTree' $ head $ map readRPNRegex $ lines content

transformRV2FSM :: String -> IO ()
transformRV2FSM file = do
    content <- ensureProperInput file
    if lines content == [] then putStr $ show $ FSM [1] [] [] 1 [] 
    else putStr $ rv2rka' $ head $ map readRPNRegex $ lines content

transformRV2Image  :: String -> IO ()
transformRV2Image file = do
    content <- ensureProperInput file
    if lines content == [] then putStr (convertToTex $ FSM [1] [] [] 1 [] )
    else putStr ( rka2Image' ( head ( map readRPNRegex (lines content) ) ) )


ensureProperInput :: String -> IO String
ensureProperInput file = case file == "" of 
    True -> hGetContents stdin
    False -> readFile file 

{-- 
    Input regex parsing functions
    Inspired by: * http://stackoverflow.com/questions/36277160/haskell-reverse-polish-notation-regular-expression-to-expression-tree
                 * Also from Ing. Marek Kidon consultations
    Extra mile: Function is actually capable of determining (and reacting) on invalid regex on input (i.e. for ab++ prints information about invalid input)
--}
readRPNRegex :: String -> Either String Tree
readRPNRegex s = case foldM parseCharacter' [] s of 
  Right [e]  -> Right e
  Left  e    -> Left  e
  _          -> Left  regexNotValid
  where
    parseCharacter' (r:l:s)  '.'   =  Right $ (BinaryOperation '.' l r):s
    parseCharacter' (r:l:s)  '+'   =  Right $ (BinaryOperation '+' l r):s
    parseCharacter' (r:s)    '*'   =  Right $ (Star '*' r):s
    parseCharacter' s c 
                | c == '.' || c == '+' || c == '*' = Left $ regexNotValid
                | True = Right $ (Character c):s

{-- 
    Regex tree representation functions (-r switch) 
--}
representTree' :: Either String Tree -> String 
representTree' (Left e) = reverse e
representTree' (Right t) = representTree t 

representTree :: Tree -> String 
representTree (Character c) = [c]
representTree (Star c tree) = c : (representTree tree)
representTree (BinaryOperation c leftTree rightTree) =  c :  (representTree  rightTree) ++ (representTree leftTree)   

{--
    FSM transformation functions (-t switch)
--}
rv2rka' :: Either String Tree -> String 
rv2rka' (Left e) = e
rv2rka' (Right t) = show $ rv2rka t

rv2rka :: Tree -> FSM
rv2rka (Character a) = FSM [1,2] [] [TTransition 1 (TransitionLabel a) 2] 1 [2] -- Only basic automaton for 'a'
rv2rka (BinaryOperation '+' leftTree rightTree) = constructUnion (rv2rka leftTree) (rv2rka rightTree)
rv2rka (BinaryOperation '.' leftTree rightTree) = constructConcat (rv2rka leftTree) (rv2rka rightTree)
rv2rka (Star '*' tree) = constructIteration $ rv2rka tree
rv2rka t =  FSM [1] [] [] 1 []


{----------------------------------------------------------- 
          REGEX TO FSM ALGORITHM FUNCTIONS
Algorithm I followed is described in README documentation(s) 
------------------------------------------------------------}

{-- 
    Reusable FSM construction helper functions 
--}
shiftTransition :: Int -> TTransition -> TTransition
shiftTransition shift (TTransition f s t) = (TTransition (f+shift) s (t+shift)) 

{--
  Functions for Union, Concatenation and Iteration of FSMs 
--}
constructUnion :: FSM -> FSM -> FSM
constructUnion (FSM aS _ aT aIS aFS) (FSM bS _ bT bIS bFS) = FSM ([1] ++ generateNewStates) [] generateNewTransitions 1 [newFinalState]
  where
    bStateShift            =    1 + length aS
    newFinalState          =    2 + (length $ aS ++ bS)
    generateNewStates      =    map (+1) aS ++ map (+bStateShift) bS ++ [newFinalState]
    generateNewTransitions =    map (shiftTransition 1) aT 
                                    ++ map (shiftTransition bStateShift) bT 
                                    ++ generateEpsTransitions
    generateEpsTransitions =    [TTransition 1 Epsilon (aIS + 1), TTransition 1 Epsilon (bIS + bStateShift)] 
                                    ++ map (\s -> TTransition s Epsilon newFinalState) (map (+1) aFS ++  map (+bStateShift) bFS)

constructConcat :: FSM -> FSM -> FSM
constructConcat (FSM aS _ aT aIS aFS) (FSM bS _ bT bIS bFS) = FSM (generateNewStates) [] generateNewTransitions 1 [newFinalState]
  where 
    bStateShift            =    1 + length aS
    generateNewStates      =    aS ++ [bStateShift] ++ map (+bStateShift) bS
    newFinalState          =    last generateNewStates
    generateNewTransitions =    [TTransition (length aS) Epsilon (1 + length aS), TTransition (1 + length aS) Epsilon (2 + length aS)] 
                                    ++  aT 
                                    ++ map (shiftTransition bStateShift) bT  

constructIteration :: FSM -> FSM
constructIteration (FSM aS _ aT aIS aFS) = FSM ([1] ++ generateNewStates) [] generateNewTransitions 1 [newFinalState]
  where
    generateNewStates      =    map (+1) aS ++ [newFinalState]
    newFinalState          =    2 + length (aS) 
    generateNewTransitions =    [TTransition 1 Epsilon 2, TTransition newFinalState Epsilon 1, TTransition 1 Epsilon newFinalState] 
                                    ++ map (\s -> TTransition s Epsilon newFinalState) (map (+1) aFS) 
                                    ++ map (shiftTransition 1) aT 


{-- Extension: FSM drawing --}
rka2Image' :: Either String Tree -> String 
rka2Image' (Left e) = e
rka2Image' (Right t) = convertToTex $ rv2rka t
