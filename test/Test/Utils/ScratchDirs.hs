-- Copyright (c) 2014 Eric McCorkle.
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

-- | A module with utility code for creating scratch directories.
module Test.Utils.ScratchDirs(
       prepareScratchDir
       ) where

import System.Directory

scratchDirName :: FilePath
scratchDirName = "scratch"

-- | Prepare the scratch directory for a test, creating and clearing it.
prepareScratchDir :: IO FilePath
prepareScratchDir =
  do
    exists <- doesDirectoryExist scratchDirName
    if exists
       then do
         removeDirectoryRecursive scratchDirName
         createDirectory scratchDirName
         return scratchDirName
       else do
         createDirectory scratchDirName
         return scratchDirName
