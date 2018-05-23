module Test.Exercise2 where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array (foldl, head)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Record as Record
import Test.Unit (Test, TestSuite, failure, success, suite, suiteSkip, test, testSkip)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests = do
  suite "Ex 2 (ADTs)" do
    suite "1 Printing area" do
      test "of circle" do
        let shape = Circle (Point {x: 0.0, y: 0.0}) 10.0
        Assert.equal 314.0 (area shape)
      test "of rectangle" do
        let shape = Rectangle (Point {x: 0.0, y: 0.0}) 5.0 10.0
        Assert.equal 50.0 (area shape)
      test "of line" do
        let shape = Line (Point {x: 0.0, y: 0.0}) (Point {x: 1.0, y: 1.0})
        Assert.equal 0.0 (area shape)
        
    test "2 Newtype: get value out of newtype" do
      let adminId = AdminId "superuser247"
      Assert.equal "superuser247" (unwrapId adminId)
      
    suite "3 Maybe: printing usernames" do
      test "Prints username if given a username" do
        let maybeUsername = Just "johndoe"
        Assert.equal "Username: johndoe" (showUsername maybeUsername)
      test "Prints 'No username' if given nothing" do
        let maybeUsername = Nothing
        Assert.equal "No username" (showUsername maybeUsername)
      
    suite "4 Either: either the thing we want or an error" do
      test "Prints username if given a user" do
        let userResult = Right { id: 1, username: "johndoe" }
        Assert.equal "johndoe" (showUserResult userResult)
      test "Prints the error string if given an error" do
        let userResult = Left "Could not find user"
        Assert.equal "Could not find user" (showUserResult userResult)
        
    suite "5 Maybe: Find largest number" do
      test "returns largest number" do
        Assert.equal
          (Just 176)
          (largestNumber [3, 7, 5, 176, 12])
      test "doesn't return a value if no numbers are given" do
        Assert.equal
          Nothing
          (largestNumber [])
      
data Shape
  = Circle Point Radius
  | Rectangle Point Width Height
  | Line Point Point
    
data Point = Point
  { x :: Number
  , y :: Number
  }
    
type Radius = Number
type Width = Number
type Height = Number

pi :: Number
pi = 3.14
      
area :: Shape -> Number
area (Circle _ rad) = pi * rad * rad
area (Rectangle _ width height) = width * height
area (Line _ _) = 0.0

newtype AdminId = AdminId String

unwrapId :: AdminId -> String
unwrapId (AdminId id) = id

largestNumber :: Array Int -> Maybe Int
largestNumber [] = Nothing
largestNumber [a] = Just a
largestNumber x = case (head x) of
  Just a -> Just $ foldl (\i j -> max i j) a x
  _ -> Nothing

showUsername :: Maybe String -> String
showUsername (Just u) = "Username: " <> u
showUsername _ = "No username"

type User =
  { id :: Int
  , username :: String }

showUserResult :: Either String User -> String
showUserResult (Right u) = u.username
showUserResult _ = "Could not find user"
