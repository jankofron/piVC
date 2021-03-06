(* main_server *)

open Verify ;;

val compile : ((string, ((Verify.validity * Smt_solver.Counterexample.example list option) * float)) Hashtbl.t * Mutex.t) -> in_channel -> out_channel -> unit ;;
val start_main_server : unit -> unit ;;
val get_main_server_func : unit -> in_channel -> out_channel -> unit;;
