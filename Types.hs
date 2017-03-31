module Types where

    import Data.List (intercalate)

    -- Arguments data structures
    data Action 
      = Represent 
      | Transform 

    data Arguments = Arguments
      {   action  ::  Action 
      ,   path    ::  String
      }


    -- Regex tree data structures
    data Tree = BinaryOperation Char Tree Tree | Character Char | Star Char Tree deriving Show 

    -- Finite State Machine structures
    -- For fast debug in ghci: FSM [1,2] ['a','b'] [TTransition 1 'a' 2, TTransition 2 'b' 3] 1 [2]
    data FSM = FSM
        {   states       ::  [TState] 
        ,   alphabet     ::  [Char]                -- Actually is not neccessary, project specification does not require to store this
        ,   transitions  ::  [TTransition]  
        ,   initialState ::  TState
        ,   finalStates  ::  [TState]
        } 

    type TState = Int
    
    data TTransition = TTransition
        {   from         ::  TState
        ,   symbol       ::  TransitionLabel
        ,   to           ::  TState
        }

    data TransitionLabel 
      = TransitionLabel Char 
      | Epsilon
    
    -- Finite State Machine structures show overloads
    instance Show TTransition where
        show (TTransition f s t) = show f ++ "," ++  show s ++ "," ++ show t

    instance Show TransitionLabel where
        show (TransitionLabel c) = [c]
        show (Epsilon)           = ""
 
    instance Show FSM where
        show (FSM s _ t i f) = intercalate "\n"  [displayStates s, displayInitialState, displayFinalStates f, displayTransitions t]
            where
                displayStates       =   intercalate "," . map show     -- ETA reduced from:  displayStates s = intercalate ","  (map show s)  
                displayInitialState =   show i
                displayFinalStates  =   intercalate ","  . map show    -- ETA reduced from: displayFinalStates f = ... 
                displayTransitions  =   intercalate "\n" . map show    -- ETA reduced as all of those above

    -- Other usefull constant functions 
    regexNotValid = "Invalid Input"