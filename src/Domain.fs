namespace HangerManager

[<AutoOpen>]
module Domain =
    type Errors =
        | PlaneNameError of string
        | PlaneMissilesListError of string
        | PlaneMissilesCapacityError of string
        | PlaneMissilesUniquenessError of string
        | PlaneDisembarkError of string
        | HangarMissilesCapacityError of string
        | HangarPlanesCapacityError of string
        | HangarNotFoundError of string
        | PlaneNotFoundError of string
        | InvalidInputError of string

// Note that this is a simplistic, toy, project
// There is no user validation, no authentication/authorization
// All relevant types are public and can be instantiated by any calling function without confirmation
// In production, constructor would be `private` and take a `Role` input parameter, where only certain roles even have the permission to construct
// With a proper authN/authZ system in place, to verify a user *is* who they claim *to be*
type Missile = int //  TODO: Create type `Nat` and switch to it
