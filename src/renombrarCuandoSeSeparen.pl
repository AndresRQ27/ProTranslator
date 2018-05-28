%%Espanol es la oracion en ese idioma, de igual manera con el Ingles
%traducir(Espanol, Ingles):- .

%%Obtiene el verbo en infinitivo de la conjugación. Útil para conversión Español->Inglés
verboRegular_desconjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado):-
	atom_concat(Raiz, Conjugacion, Conjugado),
	verboRegular(Terminacion, Tiempo, Cantidad, Persona, Conjugacion),
	atom_concat(Raiz, Terminacion, InfinitivoRegular),
	verboRegular_conjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado).
	%TODO: agregar verificacion con la base de datos implementada para obtener el infinitivo correcto.

%%%%%%%%%%%%%%%%%%%%%%Sección para traducir de inglés a español.

%TODO: Preguntas, ¿adverbios?, nombre y caso sin traducción
	
traducir(S0, S, Resultado):- 
	noPredicado(S0,S1, Resultado1), 
	predicado(S1,S, Resultado2),
	append(Resultado1, Resultado2, Resultado),
	!.

noPredicado(S0, S, Resultado):- 
	sintagma_nominal(Cantidad, Persona, S0, S1, Resultado1),
	verbo(Cantidad, Persona, S1, S, Resultado2),
	append(Resultado1, Resultado2, Resultado).
	
predicado([], [], []).
predicado([Ingles|S], S, [Español]):- 
	traduccion(Español, Ingles).
predicado(S0, S, Resultado):- 
	sintagma_nominal(S0, S, Resultado).

sintagma_nominal(Cantidad, Persona, [Ingles|S], S, [Español]):- %Caso de pronombre
	traduccion(Español, Ingles),
	pronombre(Cantidad, Persona, Español).
sintagma_nominal(Cantidad, Persona, [_|S0], S, [Articulo, Español]):-
	articulo(Genero, Cantidad, Articulo),
	nombre(Genero, Cantidad, S0, S, Español),
	Persona = 'tercera'.
sintagma_nominal([_|S0], S, [Articulo, Español]):- %Sintagma para el predicado
	articulo(Genero, Cantidad, Articulo),
	nombre(Genero, Cantidad, S0, S, Español).

nombre(Genero, Cantidad, [Ingles|S], S, EspañolPlural):- %Caso de ser plural (-es)
	sub_atom(Ingles, 0, _, 2, Base),
	traduccion(EspañolSingular, Base),
	nombre(Genero, EspañolSingular),
	atom_concat(EspañolSingular, 's', EspañolPlural),
	Cantidad = 'plural'.
nombre(Genero, Cantidad, [Ingles|S], S, EspañolPlural):- %Caso de ser plural (-s)
	sub_atom(Ingles, 0, _, 1, Base),
	traduccion(EspañolSingular, Base),
	nombre(Genero, EspañolSingular),
	atom_concat(EspañolSingular, 's', EspañolPlural),
	Cantidad = 'plural'.
nombre(Genero, Cantidad, [Ingles|S], S, Español):- %Caso de ser singular
	traduccion(Español, Ingles),
	nombre(Genero, Español),
	Cantidad = 'singular'.

verbo(Cantidad, Persona, [Will|S0], S, [Conjugacion]):- %Caso de ser futuro
	Will = 'will',
	S0 = [Ingles|S],
	traduccion(Español, Ingles),
	averiguarConjugacion(Español, 'futuro', Cantidad, Persona, Conjugacion).
	
verbo(Cantidad, Persona, [Ingles|S], S, [Conjugacion]):- %Caso de ser pasado (versión -ied)
	sub_atom(Ingles, 0, _, 3, BaseIncompleta), %Sobra el -ed, obteniendo la base del verbo
	atom_concat(BaseIncompleta, 'y', Base),
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|S], S, [Conjugacion]):- %Caso de ser pasado (version -ed)
	sub_atom(Ingles, 0, _, 2, Base), %Sobra el -ed, obteniendo la base del verbo
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|S], S, [Conjugacion]):- %Caso de ser pasado (version -d)
	sub_atom(Ingles, 0, _, 1, Base), %Sobra el -ed, obteniendo la base del verbo
	atom_concat(Base, UltimaLetra, Ingles),
	UltimaLetra = 'd',
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
	
verbo(Cantidad, Persona, [Ingles|S], S, [Conjugacion]):- %Caso de ser presente con 's' (He, She, It)
	sub_atom(Ingles, 0, _, 1, Base),
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'presente', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|S], S, [Conjugacion]):- %Caso de ser presente sin 's' (Todos excepto He, She, It)
	traduccion(Español, Ingles),
	averiguarConjugacion(Español, 'presente', Cantidad, Persona, Conjugacion).

%%Prueba si el verbo a conjugar está en la lista de verbos irregulares.
averiguarConjugacion(Infinitivo, Tiempo, Cantidad, Persona, Conjugacion):-
	verboIrregular(Infinitivo, Tiempo, Cantidad, Persona, Conjugacion).

%%Conjuga el verbo como si fuera un verbo regular.	
averiguarConjugacion(Infinitivo, Tiempo, Cantidad, Persona, Conjugacion):-
	verboRegular_conjugador(Infinitivo, Tiempo, Cantidad, Persona, Conjugacion).
	
%%Conjuga el verbo regular segun la raiz que posea. 
verboRegular_conjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado):-
	sub_atom(InfinitivoRegular, _, 2, 0, Terminacion),
	atom_concat(Raiz, Terminacion, InfinitivoRegular),
	verboRegular(Terminacion, Tiempo, Cantidad, Persona, Conjugacion),
	atom_concat(Raiz, Conjugacion, Conjugado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Sección de Bases de Datos

%Pronombres
traduccion('yo','i').
traduccion('usted','you').
traduccion('él','he').
traduccion('ella','she').
traduccion('nosotros','us').
traduccion('ellos','they').

%Verbos
traduccion('intentar', 'try').
traduccion('morir', 'die').
traduccion('correr', 'run').

%Adjetivos
traduccion('lentamente','slowly').
traduccion('rápido', 'fast').

%Nombres
traduccion('carro', 'car').
traduccion('tijera', 'scissor'). %Mal escrito pero es caso especial
traduccion('autódromo','racetrack').

nombre('masculino', 'carro').
nombre('femenino', 'tijera').
nombre('masculino', 'autódromo').

articulo('masculino', 'singular', 'el').
articulo('masculino', 'plural', 'los').
articulo('femenino', 'singular', 'la').
articulo('femenino', 'plural', 'las').

pronombre('singular', 'primera', 'yo').
pronombre('singular', 'segunda', 'usted').
pronombre('singular', 'tercera', 'él').
pronombre('plural', 'segunda', 'ustedes'). %No se utiliza pues 'you' es para plural/singular
pronombre('plural', 'primera', 'nosotros').
pronombre('plural', 'tercera', 'ellos').
%pronombre('masculino', 'singular', 'tercera', 'él').
%pronombre('masculino', 'plural', 'tercera', 'ellos').
%pronombre('femenino', 'singular', 'tercera', 'ella').
%pronombre('femenino', 'plural', 'tercera', 'ellas').

%Por defecto el programa elije ellos, para no tener 
%que diferenciar entre masculino y femenino, comentar él/ellos 
%en caso de usar los anteriores

%%%Verbos
verboIrregular('morir', 'pasado', 'singular', 'segunda', 'murió').
verboIrregular('morir', 'pasado', 'singular', 'tercera', 'murió').
verboIrregular('morir', 'presente', 'singular', 'primera', 'muero').
verboIrregular('morir', 'presente', 'singular', 'segunda', 'muere').
verboIrregular('morir', 'presente', 'singular', 'tercera', 'muere').

%%Terminados en -ar
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


%%Terminados en -er
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


%%Terminados en -ir
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

