--
--
--
-- ============================================== LEARNING NOTES, WRONG PATHS, ETC ==============================================================================


-- TODO: Also implement own Show method to be able to print out readable regex
--instance Show Tree where
    --show (BinaryOperation  c ft st) = c : (show  ft) ++ (show st)
    --show (Star c t) = c : (show t) 
    --show (Character c) = [c]
    --show (BinaryOperation c lt rt) = c : show lt ++ show rt
    --show (Star c lt) = c : (show lr)


-- Reads and stores RPN regex from input in stack structure
-- readRPNRegex :: String -> Stack 
-- readRPNRegex = foldl parseCharacter []


-- This was supposed to supplement for [c] construction, where 'c' is the char. It's purpose was to suppress printing out apostrophes when show function was used
--newtype TChar = TChar Char
--instance Show TChar where
--    show (TChar c) = [c]


{- 
-- OLD OR_CONSTRUCT_FUNCTION
constructOr :: FSM -> FSM -> FSM
constructOr (FSM aStates _ aTransitions aInitialState aFinalState) (FSM bStates _ bTransitions bInitialState bFinalState) = 
  FSM ([1] ++ (generateAStates aStates) ++ (generateBStates bStates) ++ [generateFinalState])
      [] 
      (generateATransitions aTransitions ++ generateBTransitions bTransitions ++ generateNewTransitions)
      1 
      [generateFinalState] 
  where
    generateATransitions transitions = map modifyTransitionA transitions 
    modifyTransitionA (TTransition f s t) = (TTransition (f+aStateShift) s (t+aStateShift))
    generateBTransitions transitions = map modifyTransitionB transitions 
    modifyTransitionB (TTransition f s t) = (TTransition (f+bStateShift) s (t+bStateShift))
    generateNewTransitions = [ TTransition 1 Epsilon (aInitialState+aStateShift), TTransition 1 Epsilon (bInitialState+bStateShift) ] ++ finalStateTransitions 
    aStateShift = 1
    bStateShift = length aStates + 1
    generateAStates states = map (+ aStateShift) states
    generateBStates states = map (+ bStateShift) states
    generateFinalState     = length aStates + length bStates + 2  
    
    finalStateTransitions = map  (\s -> TTransition s Epsilon generateFinalState) (aFinalState ++ bFinalState) -- 

    -- finalStateTransitions = \x -> [(TTransition f s t) | x <- aFinalState, f ] -- QUESTION: How does work list comprehension with custom data structures?

-- constructConcat :: FSM -> FSM -> FSM
-- constructIteration :: FSM -> FSM
-}

{-
readRPNRegex :: String -> Either String Tree
readRPNRegex s = case foldM parseCharacter' [] s of 
  Left x -> Left x 
  Right [] -> Left "Invalid input!"
  Right [x] -> Right x
  Right _ -> Left "Invalid input!"
  where
    parseCharacter' (r:l:s)  '.'   =  Right $ (BinaryOperation '.' l r):s
    parseCharacter' (r:l:s)  '+'   =  Right $ (BinaryOperation '+' l r):s
    parseCharacter' (r:s)    '*'   =  Right $ (Star '*' r):s
    parseCharacter' s c
      | c == '.' || c == '+' || c == '*' = Left $ "Invalid input!"
      | True = Right $ (Character c):s -}