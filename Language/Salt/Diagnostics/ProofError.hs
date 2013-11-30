-- Copyright (c) 2013 Eric McCorkle.
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301 USA

{-# OPTIONS_GHC -funbox-strict-fields -Wall -Werror #-}

-- | A module containing a datatype for error messages for proof
-- checking.
module Language.Salt.Diagnostics.ProofError(
       ProofError(..)
       ) where

import Data.Default
import Data.Hashable
import Data.Pos
import Language.Salt.Core.Syntax
import Text.Format

data ProofError sym =
  -- | An error message representing an undefined proposition in the
  -- truth envirnoment.
    UndefProp {
      -- | The name of the undefined proposition.
      undefName :: sym,
      -- | The position at which the bad use of "exact" occurred.
      undefPos :: Pos
    }
  -- | An error message representing an attempt to use the "exact"
  -- rule with a proposition that does not match the goal.
  | ExactMismatch {
      -- | The name of the mismatched proposition in the truth environment.
      exactName :: sym,
      -- | The proposition from the truth environment.
      exactProp :: Term sym sym,
      -- | The goal proposition.
      exactGoal :: Term sym sym,
      -- | The position at which the bad use of "exact" occurred.
      exactPos :: Pos
    }
  -- | An error message representing an attempt to use the "intro"
  -- rule with a goal that is not an implies proposition.
  | IntroMismatch {
      -- | The goal proposition.
      introGoal :: Term sym sym,
      -- | The position at which the bad use of "exact" occurred.
      introPos :: Pos
    }
  -- | An error message representing an attempt to use the "introVar"
  -- rule with a goal that is not a forall proposition.
  | IntroVarMismatch {
      -- | The goal proposition.
      introVarGoal :: Term sym sym,
      -- | The position at which the bad use of "exact" occurred.
      introVarPos :: Pos
    }
  deriving (Ord, Eq)

instance Position (ProofError sym) where
  pos UndefProp { undefPos = p } = p
  pos ExactMismatch { exactPos = p } = p
  pos IntroMismatch { introPos = p } = p
  pos IntroVarMismatch { introVarPos = p } = p

instance (Default sym, Hashable sym) => Hashable (ProofError sym) where
  hashWithSalt s UndefProp { undefName = name, undefPos = p } =
    s `hashWithSalt` name `hashWithSalt` p
  hashWithSalt s ExactMismatch { exactName = name, exactProp = prop,
                                 exactGoal = goal, exactPos = p } =
    s `hashWithSalt` name `hashWithSalt`
    prop `hashWithSalt` goal `hashWithSalt` p
  hashWithSalt s IntroMismatch { introGoal = goal, introPos = p } =
    s `hashWithSalt` goal `hashWithSalt` p
  hashWithSalt s IntroVarMismatch { introVarGoal = goal, introVarPos = p } =
    s `hashWithSalt` goal `hashWithSalt` p

-- Don't add the positions here, they will be added by other error
-- message machinery.
instance (Default sym, Format sym, Ord sym) => Format (ProofError sym) where
  format UndefProp { undefName = name } =
    "proposition" <+> name <+> "is not defined in the truth environment"
  format ExactMismatch { exactName = name, exactGoal = goal,
                         exactProp = prop } = 
    "proposition" <+> name <+> equals <+> prop <+>
    "does not equal goal" <+> goal
  format IntroMismatch { introGoal = goal } =
    "goal" <+> goal <+> "is not an implication"
  format IntroVarMismatch { introVarGoal = goal } =
    "goal" <+> goal <+> "is not a universal quantification"
