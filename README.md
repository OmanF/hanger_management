# Hanger management system

As part of a hiring funnel, I was tasked with creating an exhaustive test plan for the system specification below (seeing as I'm a professional QA tester/Automation developer/SDET).

I liked the challenge so much, I decided I'd try to implement **the system**, and see how hard a time a developer would have had coding it, **right**. (At least I hope my implementation is!)

Of course, as with most of my hobby-coding projects, this one too is in my favorite programming language - F#.

## The specification

You are to implement a system to monitor and handle an air force hanger base.  
The system should implement the following behaviors (note that if a behavior is not strictly listed in this spec, make common-sense assumptions):

* The base has 5 hangers that on program initiation are all empty
* Each hanger can hold **up to** 10 planes (inclusive)
* Each hanger can hold **up to** 100 missiles (inclusive)
* The following missile counts apply to different planes:
  * AM-101 - Up to 12 missiles
  * ILX - Up to 10 missiles
  * EUF - Up to 10 missiles
  * AM-333 - Up to 6 missiles
  * DEUS-666 - Up to 6 missiles
  * AM-999 - Up to 24 missiles
  * These are the only allowed plane types, and their correct naming schema
  * Following the example below, it can be deduced that:
    * Planes missiles are positive, non-zero integers (i.e., `Natural` in mathematical jargon)
    * Missiles IDs must be unique **across the entire system**!

The system exposes the following endpoints to allow interactions:

* `POST /hangers/{id} body: {"Plane": "AM-101", "MissilesId": [2, 35, 10944]}` - Stations a plane and its missiles in the specified hanger, if valid, otherwise returns a descriptive error explaining the failure
* `DELETE /hangers/{hId}/planes/{pId}` - Removes the specified plane and its missiles from the specified hanger, if both are valid, otherwise returns a descriptive error explaining the failure
* `GET /hangers` - Returns a list of all hangers' details
* `GET /hangers/{id}` - Returns the content of the specific hanger, if valid, otherwise returns a descriptive error explaining the failure
* `GET /hangers/{id}/planes` - Returns a list of all the planes and their respective missile for the specified hanger, if valid, otherwise returns a descriptive error explaining the failure
* `Get /hangers/{hId}/planes/{pId}` - Returns the details of the specific plane stationed at the specific hanger, if valid, otherwise returns a descriptive error explaining the failure
* `GET /hangers/{hId}/planes{pId}/missiles` - Returns the list of missiles mounted on the specific plane stationed at the specific hanger, if valid, otherwise returns a descriptive error explaining the failure

All error reporting is done **to the console**
