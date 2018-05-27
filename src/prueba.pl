%%Espanol es la oracion en ese idioma, de igual manera con el Ingles
%traducir(Espanol, Ingles):- .

%%Conjuga el verbo regular segun la raiz que posea
verboRegular_conjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado):-
	sub_atom(InfinitivoRegular, _, 2, 0, Terminacion),
	atom_concat(Raiz, Terminacion, InfinitivoRegular),
	verboRegular(Terminacion, Tiempo, Cantidad, Persona, Conjugacion),
	atom_concat(Raiz, Conjugacion, Conjugado),
	!.

verboRegular_desconjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado):-
	atom_concat(Raiz, Conjugacion, Conjugado),
	verboRegular(Terminacion, Tiempo, Cantidad, Persona, Conjugacion),
	atom_concat(Raiz, Terminacion, InfinitivoRegular),
	verboRegular_conjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado).
	%TODO: agregar verificacion con la base de datos implementada para obtener el infinitivo correcto.
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Seccion de Bases de Datos
oracion(S0,S):- sintagma_nominal(S0,S1),
sintagma_verbal(S1,S).

sintagma_nominal(S0,S):- determinante(S0,S1),

nombre(S1,S).

sintagma_verbal(S0,S):- verbo(S0,S).
sintagma_verbal(S0,S):- verbo(S0,S1),

sintagma_nominal(S1,S).

determinante(masculino, 'singular', [el|S], S).
determinante(masculino, 'plural', [los|S], S).

nombre(masculino, 'singular', [hombre|S], S).
nombre(masculino, 'singular', [manzana|S], S).


%%%Terminados en -ar
verboRegular('ar', 'pasado', 'singular', 'primera', 'é').
verboRegular('ar', 'pasado', 'singular', 'segunda', 'ó').
verboRegular('ar', 'pasado', 'singular', 'tercera', 'ó').
verboRegular('ar', 'pasado', 'plural', 'primera', 'amos').
verboRegular('ar', 'pasado', 'plural', 'segunda', 'aron').
verboRegular('ar', 'pasado', 'plural', 'tercera', 'aron').

verboRegular('ar', 'presente', 'singular', 'primera', 'o').
verboRegular('ar', 'presente', 'singular', 'segunda', 'a').
verboRegular('ar', 'presente', 'singular', 'tercera', 'a').
verboRegular('ar', 'presente', 'plural', 'primera', 'amos').
verboRegular('ar', 'presente', 'plural', 'segunda', 'an').
verboRegular('ar', 'presente', 'plural', 'tercera', 'an').

verboRegular('ar', 'futuro', 'singular', 'primera', 'aré').
verboRegular('ar', 'futuro', 'singular', 'segunda', 'ará').
verboRegular('ar', 'futuro', 'singular', 'tercera', 'ará').
verboRegular('ar', 'futuro', 'plural', 'primera', 'aremos').
verboRegular('ar', 'futuro', 'plural', 'segunda', 'arán').
verboRegular('ar', 'futuro', 'plural', 'tercera', 'arán').


%%%Terminados en -er
verboRegular('er', 'pasado', 'singular', 'primera', 'í').
verboRegular('er', 'pasado', 'singular', 'segunda', 'ió').
verboRegular('er', 'pasado', 'singular', 'tercera', 'ió').
verboRegular('er', 'pasado', 'plural', 'primera', 'imos').
verboRegular('er', 'pasado', 'plural', 'segunda', 'ieron').
verboRegular('er', 'pasado', 'plural', 'tercera', 'ieron').

verboRegular('er', 'presente', 'singular', 'primera', 'o').
verboRegular('er', 'presente', 'singular', 'segunda', 'e').
verboRegular('er', 'presente', 'singular', 'tercera', 'e').
verboRegular('er', 'presente', 'plural', 'primera', 'emos').
verboRegular('er', 'presente', 'plural', 'segunda', 'en').
verboRegular('er', 'presente', 'plural', 'tercera', 'en').

verboRegular('er', 'futuro', 'singular', 'primera', 'eré').
verboRegular('er', 'futuro', 'singular', 'segunda', 'erá').
verboRegular('er', 'futuro', 'singular', 'tercera', 'erá').
verboRegular('er', 'futuro', 'plural', 'primera', 'eremos').
verboRegular('er', 'futuro', 'plural', 'segunda', 'erán').
verboRegular('er', 'futuro', 'plural', 'tercera', 'erán').


%%%Terminados en -ir
verboRegular('ir', 'pasado', 'singular', 'primera', 'í').
verboRegular('ir', 'pasado', 'singular', 'segunda', 'ió').
verboRegular('ir', 'pasado', 'singular', 'tercera', 'ió').
verboRegular('ir', 'pasado', 'plural', 'primera', 'imos').
verboRegular('ir', 'pasado', 'plural', 'segunda', 'ieron').
verboRegular('ir', 'pasado', 'plural', 'tercera', 'ieron').

verboRegular('ir', 'presente', 'singular', 'primera', 'o').
verboRegular('ir', 'presente', 'singular', 'segunda', 'e').
verboRegular('ir', 'presente', 'singular', 'tercera', 'e').
verboRegular('ir', 'presente', 'plural', 'primera', 'imos').
verboRegular('ir', 'presente', 'plural', 'segunda', 'en').
verboRegular('ir', 'presente', 'plural', 'tercera', 'en').

verboRegular('ir', 'futuro', 'singular', 'primera', 'iré').
verboRegular('ir', 'futuro', 'singular', 'segunda', 'irá').
verboRegular('ir', 'futuro', 'singular', 'tercera', 'irá').
verboRegular('ir', 'futuro', 'plural', 'primera', 'iremos').
verboRegular('ir', 'futuro', 'plural', 'segunda', 'irán').
verboRegular('ir', 'futuro', 'plural', 'tercera', 'irán').

