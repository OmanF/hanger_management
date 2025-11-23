# Hangar management system

As part of a hiring funnel, I was tasked with creating an exhaustive test plan for the system specification below (seeing as I'm a professional QA tester/Automation developer/SDET).

I liked the challenge so much, I decided I'd try to implement **the system**, and see how hard a time a developer would have had coding it, **right**. (At least I hope my implementation is!)

Of course, as with most of my hobby-coding projects, this one too is in my favorite programming language - F#.

## The specification

You are to implement a system to monitor and handle an air force hangar base.  
The system should implement the following behaviors (note that if a behavior is not strictly listed in this spec, make common-sense assumptions):

* The base has 5 hangars that on program initiation are all empty
* Each hangar can hold **up to** 10 planes (inclusive)
* Each hangar can hold **up to** 100 missiles (inclusive)
* The following missile counts apply to different planes:
  * AM-101 - Up to 12 missiles
  * ILX - Up to 10 missiles
  * EUF - Up to 10 missiles
  * AM-333 - Up to 6 missiles
  * DEUS-666 - Up to 6 missiles
  * AM-999 - Up to 24 missiles
  * These are the only allowed plane types, and their correct naming schema
  * Following the example below, it can be deduced that:
    * Planes' missiles are positive, non-zero integers (i.e., `Natural` in mathematical jargon)
    * Missiles IDs must be unique **across the entire system**!

The system exposes the following endpoints to allow interactions:

* `POST /hangars/{id} body: {"Plane": "AM-101", "MissilesId": [2, 35, 10944]}` - Stations a plane and its missiles in the specified hangar, if valid, otherwise returns a descriptive error explaining the failure
* `DELETE /hangars/{hId}/planes/{pId}` - Removes the specified plane and its missiles from the specified hangar, if both are valid, otherwise returns a descriptive error explaining the failure
* `GET /hangars` - Returns a list of all hangars' details
* `GET /hangars/{id}` - Returns the content of the specific hangar, if valid, otherwise returns a descriptive error explaining the failure
* `GET /hangars/{id}/planes` - Returns a list of all the planes and their respective missile for the specified hangar, if valid, otherwise returns a descriptive error explaining the failure
* `Get /hangars/{hId}/planes/{pId}` - Returns the details of the specific plane stationed at the specific hangar, if valid, otherwise returns a descriptive error explaining the failure
* `GET /hangars/{hId}/planes{pId}/missiles` - Returns the list of missiles mounted on the specific plane stationed at the specific hangar, if valid, otherwise returns a descriptive error explaining the failure

All error reporting is done **to the console**

## The implementation

I started implementing by documenting the test cases I could come up with in a BDD fashion, using `Gherkin` syntax and `.feature` files, though not using any BDD library for the actual implementation... I don't like any of the F# supporting libraries out there, and `SpecFlow`'s C#-centric APIs are not something I feel like dealing with.  
Instead, using the great `Expecto` framework, I just "translated" each BDD case into test code... you know, like if I didn't use BDD but any other way of documenting tests that didn't have a framework attached to it.

The actual code implementation... what was supposed to be an easy, "coupl'a hours coding" turned out to be a domain-modelling brain-teaser, and implementation that stretched my F# know-how, admittedly not something to brag about, to its limits.

But it **was** fun.  
And that, when all's said and done, what's important, so... *WIN*!
