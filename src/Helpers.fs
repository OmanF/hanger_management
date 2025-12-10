namespace HangerManager

[<AutoOpen>]
module Helpers =
    let isUnique (checkedSet: Set<'a>) (currentSet: Set<'a>) : bool =
        Set.isEmpty (Set.intersect checkedSet currentSet)

    let stateAgent =
        MailboxProcessor<SystemMessage>.Start(fun inbox ->
            let initialState =
                { Hangars = Array.init 5 (fun _ -> [])
                  GlobalMissileSet = Set.empty }

            let rec loop (state: SystemState) =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | GetState reply -> reply.Reply state
                    | UpdateHangar(idx, hangar) -> 1 |> ignore // TODO: Implement!

                    return! loop state
                }

            loop initialState)
