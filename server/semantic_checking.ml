open Ast
open Scope_stack

let print_error node message location =
print_string("**Semantic Error**\n");
print_string(string_of_location location);
print_string("\n");
print_string(message);
print_string("\n")


let insert_decl s decl = 
  let curr = lookup_decl_in_curr_scope decl s in
    match curr with
	None -> insert_decl decl s
      | _ -> print_error decl "Already defined" (location_of_decl decl)

let insert_var_decl s decl = 
  insert_decl s (Ast.VarDecl(decl.location_vd, decl))

let insert_decls s decls = 
  List.iter (insert_decl s) decls

let insert_var_decls s decls = 
  List.iter (insert_var_decl s) decls 

(*TODO: finish writing*)
let check_and_get_return_type e =
  let rec cagrt = function
    | Assign (loc,l, e) -> Void(loc)
    | Constant (loc,c) ->
	begin
	  match c with
	  | ConstInt (l, i) -> Int (loc)
	  | ConstFloat (l, f) -> Float (loc)
	  | ConstBool (l, b) -> Bool (loc)
	end
    | LValue (loc,l) -> Void(loc)
    | Call (loc,s, el) -> Void(loc)
    | Plus (loc,t1, t2) -> Void(loc)
    | Minus (loc,t1, t2) -> Void(loc)
    | Times (loc,t1, t2) -> Void(loc)
    | Div (loc,t1, t2) -> Void(loc)
    | IDiv (loc,t1, t2) -> Void(loc)
    | Mod (loc,t1, t2) -> Void(loc)
    | UMinus (loc,t) -> Void(loc)
    | LT (loc,t1, t2) -> Void(loc)
    | LE (loc,t1, t2) -> Void(loc)
    | GT (loc,t1, t2) -> Void(loc)
    | GE (loc,t1, t2) -> Void(loc)
    | EQ (loc,t1, t2) -> Void(loc)
    | NE (loc,t1, t2) -> Void(loc)
    | And (loc,t1, t2) -> Void(loc)
    | Or (loc,t1, t2) -> Void(loc)
    | Not (loc,t) -> Void(loc)
    | Length (loc, t) -> Void(loc)
    | Iff (loc,t1, t2) -> Void(loc)
    | Implies (loc,t1, t2) -> Void(loc)
    | EmptyExpr -> Void(Ast.get_dummy_location)
  in
  cagrt e

(*TODO: finish writing*)
let rec check_stmt s returnType stmt = match stmt with

    Expr (loc, e) -> ignore (check_and_get_return_type e);

  | VarDeclStmt(loc,d) -> (insert_decl s (VarDecl(loc,d))) 

  | IfStmt (loc, test, then_block, else_block) -> print_string ""

  | WhileStmt (loc, test, block, annotation) -> print_string ""

  | ForStmt (loc, init, test, incr, block, annotation) -> print_string ""

  | BreakStmt (loc) -> print_string ""

  | ReturnStmt(loc,e) ->  let type_of_return = (check_and_get_return_type e) in
                          if (types_equal type_of_return returnType) then
                            print_string("")
			  else
	                    print_error stmt "Incorrect return type" loc

  | AssertStmt (loc, e) -> print_string ""

  | StmtBlock(loc,st) -> enter_scope s;
                      List.iter (check_stmt s returnType) st;
                      exit_scope s

  | EmptyStmt -> print_string ""



let check_function func s = 
  insert_var_decls s func.formals;
  check_stmt s func.returnType func.stmtBlock

let check_program program =
  print_string("Checking...\n");
  let s = create_scope_stack in
  enter_scope s;
  insert_decls s program.decls;
  let check_decl_if_necessary decl = 
    match decl with
	FnDecl(l, d) -> (check_function d s)
        | _ -> print_string("")
  in
  List.iter (check_decl_if_necessary) program.decls;
  exit_scope s