
data Regex  = 
	  Empty             -- The empty String
	| Null              -- The empty set, nothing can match this
	| Atom Char			-- A single Symbol in the language
	| Seq Regex Regex   -- (a)(b)
	| Alt Regex Regex	-- a|b
	| Star Regex	    -- Kleene Star (a)*
	deriving (Eq, Show)

-- [deriv re c] gives the derivative of the regex re with respect to the Atom c : (d/dc) re
deriv ::  Regex -> Char -> Regex  
deriv Empty _ = Null
deriv Null  _ = Null 
deriv (Atom re) c = if re == c then Empty else Null 
deriv (Seq a b) c = (buildAlt
						(buildSeq (deriv a c) b)
						(buildSeq Empty (deriv b c)))

deriv (Alt a b) c = (buildAlt (deriv a c) (deriv b c))
deriv (Star re) c = (buildSeq (deriv re c) (buildStar re))


buildSeq Null pat2 = Null
buildSeq pat1 Null = Null 
buildSeq Empty pat2 = pat2
buildSeq pat1 Empty = pat1
buildSeq pat1 pat2 = (Seq pat1 pat2)

buildAlt Null pat2 = pat2
buildAlt pat1 Null = pat1
buildAlt pat1 pat2 = (Alt pat1 pat2)      

-- Star allows 0 or more matches
buildStar Null  = Empty      -- 0 matches
buildStar Empty = Empty
buildStar pat   = (Star pat)

--match :: Regex -> [String] -> Bool
match regex string = case string of 
							[] -> regex
							otherwise -> match (deriv regex (head string)) (tail string)