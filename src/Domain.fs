namespace HangerManager

// #region Toy project disclaimer
// Note that this is a simplistic, toy, project
// There is no user validation, no authentication/authorization
// All relevant types are public and can be instantiated by any calling function without confirmation
// In production, constructor would be `private` and take a `Role` input parameter, where only certain roles even have the permission to construct
// With a proper authN/authZ system in place, to verify a user *is* who they claim *to be*
// #endregion

[<AutoOpen>]
module Domain =
    [<Measure>]
    type mID

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

    // Intentionally making missiles IDs "plain" `int`s, albeit `[<Measure>]` type `mID` and not a constrained `Nat`
    // While less F#-idiomatic - exercising M.I.S.U. - "Make Unpresentable State Invalid"
    // using plain `int`s, and validating them (e.g., forming a set) at the boundaries (e.g., API layer) is more pragmatic
    // especially considering that constrained types also require private builders **and** extractors, which would complicate using them
    // Be smart about it, but when the trade-off favors it, choose pragmatism over idioms
    type Plane =
        { Name: string
          Missiles: int<mID> list } // Would love to have it `Set<int<mID>>`, but this will be an interactive user input - can't guarantee it will be, need to validate!

    type Hangar = Plane array // Actually a `ResizeArray<Plane>`, under-the-hood, but for the constraints of this toy project, there will be no noticeable performance hit

    type SystemState =
        { Hangars: Hangar array // Same comment as above
          GlobalMissileSet: Set<int<mID>> }

    type SystemMessage =
        | GetState of AsyncReplyChannel<SystemState>
        | UpdateHangar of (int * Hangar) * AsyncReplyChannel<Result<SystemState, Errors>>
