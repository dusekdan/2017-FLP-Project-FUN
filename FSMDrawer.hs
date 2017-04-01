module FSMDrawer where

    import Data.List (delete, head)
    import Types

    convertToTex (FSM s _ t i f) = documentHeading ++ renderStates ++ renderTransitions t ++ ";" ++ documentFooting where 
          
          renderStates = "\n\\node[initial,state] (" ++ show i ++ ") {$" ++ show i ++ "$};\n"
                        ++ unlines ( map 
                                        (\state -> "\\node[state] (" ++ show state ++ ")" ++ renderNodeOrdering state  ++ " {$" ++ show state ++ "$};")
                                         (delete (head f) (delete i s))
                                   )
                        ++ unlines (
                                     map 
                                        (\fs -> "\\node[state, accepting] (" ++ show fs ++ ") [below right of=" ++ show (fs-1)  ++ "] {$" ++ show fs ++ "$};") f
                                   )
          
          renderTransitions t = "\n\\path" 
                                ++ unlines (map (\t -> renderTransitionPath t) t) 
          
          renderTransitionPath (TTransition f s t) = 
                        "\n(" ++ show f ++ ") edge " 
                        ++ renderEdge t s 
                        ++"  node {" ++ renderSymbol s ++ "} (" ++ show t ++ ")"

          renderSymbol s
                        | (s == Epsilon) = "$\\epsilon$"
                        | otherwise = show s
          
          renderEdge t s
                        | (mod t 2) == 0 = "[" ++ colorizeEdge s ++ "bend left=20]"
                        | otherwise = "[" ++ colorizeEdge s ++ "bend right]"
          
          colorizeEdge s
                        | s == Epsilon = ""
                        | otherwise = "purple, thick, "
          
          renderNodeOrdering s
                        | ((mod s 2) == 0 && (mod s 10) /= 0)  = " [right of=" ++ show (s-1) ++ "] "
                        | (mod s 10) == 0 = " [below left of=" ++ show (s-9) ++ "] "
                        | otherwise = " [right of=" ++ show (s-1) ++ "] " 


    {-- Extension for FSM drawing  --}
    documentHeading = "\\documentclass{standalone}\n\\usepackage{pgf}\n\\usepackage{tikz}\n\\usetikzlibrary{arrows,automata}\n\\usepackage[latin1]{inputenc}\n\\begin{document}\n\\begin{tikzpicture}\n[->,>=stealth',shorten >=1pt,auto,node distance=3.0cm,semithick]\\tikzstyle{every state}\n=[fill=none,draw=black,text=black]"
    documentFooting = "\\end{tikzpicture}\n\\end{document}\n"