start : sentence+

sentence : inductive
         | assertion
         | definition
         | stupid

stupid : "Declare" /(.)+/
       | "Set" /(.)+/
       | "Reserved" /(.)+/
       | "Notation" /(.)+/

// ident
FIRST_LETTER : ("a".."z") | ("A".."Z") | "_"
SUBSEQUENT_LETTER : ("a".."z") | ("A".."Z") | ("0".."9") | "'" | "_"
IDENT : FIRST_LETTER SUBSEQUENT_LETTER*
access_ident : "." IDENT
name : IDENT | "_"

// term
qualid : IDENT | qualid access_ident

PROP : "Prop"
SET : "Set"
TYPE : "Type"

arg : term
    | "(" IDENT ":=" term ")"
sort : PROP | SET | TYPE  // are this all the same thing?

// "exists" and "=" are not a part of the language
term : "forall" binders "," term
     | term "->" term  // fake
     | term arg+
     | "if" term "then" term "else" term
     | sort
     | qualid
     | "(" term ")"

// this is really wrong
tactic : name term "."
       | name "."
       | name term ";" tactic
       | name ";" tactic

proof : "Proof." tactic* ("Qed." | "Abort.")

// binder (is wrong but closer)
binder : name
       | name+ [":" term]
       | "(" name+ [":" term] ")"
       | "(" name [":" term] ":=" term ")"
binders : binder+

ind_body : IDENT [binders] ":" term ":=" [["|"] IDENT [binders] ":" term] ("|" IDENT [binders] ":" term)*
inductive : "Inductive" ind_body "."

definition : "Definition" IDENT [binders] [":" term] ":=" term "."

// TODO: does proof belong here?
assertion : assertion_keyword IDENT [binders] ":" term "." proof
assertion_keyword : "Theorem" | "Lemma"

%ignore " "
%ignore "\n"

COMMENT : "(**" /(.|\n)+?/ "*)"
%ignore COMMENT

