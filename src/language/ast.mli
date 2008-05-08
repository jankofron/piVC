(*
 * The abstract syntax tree
 * The entire interface is public, and is included in the file. We might want to prune
 * the interface later.
 *)

type quantification = Unquantified | Existential | Universal;;

type location = {
  loc_start  : Lexing.position;
  loc_end    : Lexing.position;
}
val gdl : unit -> location
val get_dummy_location : unit -> location
val create_location : Lexing.position -> Lexing.position -> location
val col_number_of_position : Lexing.position -> int
val location_union : location -> location -> location

type identifier = {
  name: string;
  location_id: location;
  decl : (varDecl option) ref;
  is_length : bool;
}

and varType = 
  | Bool of location
  | Int of location
  | Float of location
  | Array of varType * location
  | Void of location
  | Identifier of identifier * location
  | ErrorType
	
and varDecl = {
  varType : varType;
  varName : identifier;
  location_vd : location;
  var_id : (string option) ref;
  quant: quantification;
  is_param : bool;
}
val create_varDecl : varType -> identifier -> location -> varDecl
val create_existential_varDecl : varType -> identifier -> location -> varDecl
val create_universal_varDecl : varType -> identifier -> location -> varDecl
val create_param_varDecl : varType -> identifier -> location -> varDecl

val is_integral_type : varType -> bool ;;

(*val set_quantification_on_varDecl_List : varDecl list -> quantification -> unit*)

val string_of_quantification : quantification -> string

val create_identifier : string -> location -> identifier
val create_length_identifier : string -> location -> identifier
type lval =
  | NormLval of location * identifier
  | ArrayLval of location * expr * expr

and constant =
  | ConstInt of location * int
  | ConstFloat of location * float
  | ConstBool of location * bool
    
and expr =
  | Assign of location * lval * expr
  | Constant of location * constant
  | LValue of location * lval
  | Call of location * identifier * expr list
  | Plus of location * expr * expr
  | Minus of location * expr * expr
  | Times of location * expr * expr
  | Div of location * expr * expr
  | IDiv of location * expr * expr	
  | Mod of location * expr * expr
  | UMinus of location * expr
  | ForAll of location * varDecl list * expr
  | Exists of location * varDecl list * expr
  | ArrayUpdate of location * expr * expr * expr
  | LT of location * expr * expr
  | LE of location * expr * expr
  | GT of location * expr * expr
  | GE of location * expr * expr
  | EQ of location * expr * expr
  | NE of location * expr * expr
  | And of location * expr * expr
  | Or of location * expr * expr
  | Not of location * expr
  | Iff of location * expr * expr
  | Implies of location * expr * expr
  | Length of location * expr
  | EmptyExpr
    
and stmt =
  | Expr of location * expr
  | VarDeclStmt of location * varDecl
  | IfStmt of location * expr * stmt * stmt
  | WhileStmt of location * expr * stmt * expr * rankingAnnotation option
  | ForStmt of location * expr * expr * expr * stmt * expr * rankingAnnotation option
  | BreakStmt of location
  | ReturnStmt of location * expr
  | AssertStmt of location * expr
  | StmtBlock of location * stmt list
  | EmptyStmt

and rankingAnnotation = {
  tuple : expr list;
  location_ra : location;
}
	
type fnDecl = {
  fnName       : identifier;
  formals    : varDecl list;
  returnType   : varType;
  stmtBlock : stmt;
  preCondition : expr;
  postCondition : expr;
  fnRankingAnnotation : rankingAnnotation option;
  location_fd : location;
}
val create_fnDecl : identifier -> varDecl list -> varType -> stmt -> expr -> expr -> rankingAnnotation option -> location -> fnDecl


type predicate = {
  predName   : identifier;
  formals_p  : varDecl list;
  expr       : expr;
  location_p : location;
}

type decl = 
  | VarDecl of location * varDecl
  | FnDecl of location * fnDecl
  | Predicate of location * predicate

val name_of_decl : decl -> string

val type_of_decl : decl -> varType

type program = {
  decls : decl list;
  location : location;
}
val create_program : decl list -> location -> program

val get_root_decl : program -> string -> decl option

(*val identifier_of_lval : lval -> identifier*)

val location_of_decl : decl -> location 

val location_of_stmt : stmt -> location

val location_of_expr : expr -> location

val location_of_lval : lval -> location

val location_of_ranking_annotation : rankingAnnotation -> location  

val id_of_varDecl : varDecl -> string

val varDecl_of_identifier : identifier -> varDecl

val type_of_identifier : identifier -> varType

val id_of_identifier : identifier -> string

val varDecl_of_decl : decl -> varDecl

val identifier_of_array_expr : expr -> identifier   

(******************
Printing functions
*******************)

val string_of_location : location -> string
val string_of_identifier : identifier -> string
val string_of_type : varType -> string
val string_of_lval : lval -> string (*temp*)
val string_of_constant : constant -> string (*temp*)
val string_of_expr : expr -> string
val string_of_var_decl : varDecl -> string			     
val string_of_stmt : stmt -> int -> string
val string_of_decl : decl -> string
val string_of_program : program -> string
val string_of_ranking_annotation : rankingAnnotation -> string