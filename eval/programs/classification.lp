su(X,S,f(X,S)) :- get_su(X,S), not in(X,S) .
su(X,U,U) :- su(X,S,U) .
su(Y,U,U) :- su(X,S,U), in(Y,S) .
in(X,S) :- su(X,S,S) .

empty(es) .
class("<http://www.w3.org/2002/07/owl#Thing>") .
class("<http://www.w3.org/2002/07/owl#Nothing>") .
get_su(A,E) :- class(A), empty(E) .

ax_subtype(C,"<http://www.w3.org/2002/07/owl#Thing>") :- class(C) .
ax_subtype("<http://www.w3.org/2002/07/owl#Nothing>",C) :- class(C) .

sc_sets(H,A) :- in(A,H) .

sc_sets(H,C) :- sc_sets(H,A), ax_subtype("<http://www.w3.org/2002/07/owl#Thing>",C) .
sc_sets(H,C) :- sc_sets(H,A1), ax_subtype(A1,C) .
sc_sets(H,C) :- sc_sets(H,A1), sc_sets(H,A2), ax_subtype_con(A1,A2,C) .

ex(H,R,SuB) :- sc_sets(H,A), ax_some_pl(A,R,B), empty(E), su(B,E,SuB) .
sc_sets(H,B) :- ex(H,R,K), sc_sets(K,A), ax_some_min(R,A,B) .
sc_sets(H,"<http://www.w3.org/2002/07/owl#Nothing>") :- ex(H,R,K), sc_sets(K,"<http://www.w3.org/2002/07/owl#Nothing>") .

get_su(B,K) :- ex(H,R,K), sc_sets(H,A), ax_all(R,A,B) .
ex(H,R,U) :- su(B,K,U), ex(H,R,K), sc_sets(H,A), ax_all(A,R,B) .

sc(A,C) :- sc_sets(H, C), su(A,E,H), empty(E) .
