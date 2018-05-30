%%Espanol es la oracion en ese idioma, de igual manera con el Ingles
%traducir(Espanol, Ingles):- .

%%%Interfaz

interfaz():-
	writeln('¿Qué desea hacer?'),
	writeln('1: Traducir de Inglés a Español.'),
	writeln('2: Traducir de Español a Inglés.'),
	read(Eleccion),
	writeln('Escriba la frase a traducir: '),
	read(Texto),
	eleccion(Eleccion, Texto).

eleccion(Eleccion, Texto):- %Para palabras solas
	Eleccion = 1,
	sub_atom(Texto, _, 1, 0, SignoPregunta),
	dif('?', SignoPregunta),
	ingles_español([Texto], Respuesta),
	write_term(Respuesta, [fullstop(true)]),
	!.
eleccion(Eleccion, Texto):- %Para texto
	Eleccion = 1,
	atomic_list_concat(Lista, ' ', Texto),
	ingles_español(Lista, Traduccion),
	atomic_list_concat(Traduccion, ' ', Respuesta),
	write_term(Respuesta, [fullstop(true)]),
	!.

eleccion(Eleccion, Texto):- %Para palabras solas
	Eleccion = 2,
	español_ingles([Texto], Respuesta),
	write_term(Respuesta, [fullstop(true)]),
	!.	
eleccion(Eleccion, Texto):-
	Eleccion = 2,
	atomic_list_concat(Lista, ' ', Texto),
	%español_ingles(Lista, Traduccion),
	%atomic_list_concat(Traduccion, ' ', Respuesta),
	%write_term(Respuesta, [fullstop(true)]),
	writeln('No está implementado'),
	!.
	
eleccion(_):-
	writeln('Opción de traducción incorrecta'),
	!.

%%Obtiene el verbo en infinitivo de la conjugación. Útil para conversión Español->Inglés

español_ingles([Lista|Sobrante], Resultado):-
	Sobrante = [],
	traduccion(Lista, Resultado),
	!.
	
verboRegular_desconjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado):-
	atom_concat(Raiz, Conjugacion, Conjugado),
	verboRegular(Terminacion, Tiempo, Cantidad, Persona, Conjugacion),
	atom_concat(Raiz, Terminacion, InfinitivoRegular),
	verboRegular_conjugador(InfinitivoRegular, Tiempo, Cantidad, Persona, Conjugado).
	%TODO: agregar verificacion con la base de datos implementada para obtener el infinitivo correcto.

%%%%%%%%%%%%%%%%%%%%%%Sección para traducir de inglés a español.

ingles_español(Lista, Resultado):-
	traduccion(Resultado, Lista).

ingles_español(Lista, Resultado):-
	quitar_signo_pregunta(Lista, Traducir),
	pregunta(Traducir, Sobrante, Resultado1),
	predicado(Sobrante, [], Resultado2),
	append(Resultado1, Resultado2, ResultadoMedio),
	agregar_signo_pregunta(Resultado, ResultadoMedio),
	!.	
                                                                                                                                                                                 	
ingles_español(Lista, Resultado):- 
	noPredicado(Lista,Sobrante, Resultado1), 
	predicado(Sobrante, [], Resultado2),
	append(Resultado1, Resultado2, Resultado).

pregunta([Ingles|Lista], Sobrante, Resultado):-
	traduccion(Español, Ingles),
	verbo(Cantidad, Persona, Lista, ListaTransitoria, Resultado1),
	[Verbo|_] = Lista,
	dif(Resultado1, [Verbo]),
	sintagma_nominal(Cantidad, Persona, ListaTransitoria, Sobrante, Resultado2),
	append(Resultado1, Resultado2, MedioResultado),
	append([Español], MedioResultado, Resultado).
	
pregunta([Ingles|Lista], Sobrante, Resultado):-
	Ingles = 'how',
	traduccion(Español, 'howAlt'),
	predicado(Lista, ListaTransitoria, Resultado1),
	verbo(Cantidad, Persona, ListaTransitoria, ListaTransitoria2, Resultado2),
	sintagma_nominal(Cantidad, Persona, ListaTransitoria2, Sobrante, Resultado3),
	append([Español], Resultado1, MedioResultado1),
	append(Resultado2, Resultado3, MedioResultado2),
	append(MedioResultado1, MedioResultado2, Resultado).
	
quitar_signo_pregunta(ListaConSigno, ListaSinSigno):-
	atomic_list_concat(ListaConSigno, ' ', TextoConSigno),
	sub_atom(TextoConSigno, _, 1, 0, '?'),
	atom_concat(TextoSinSigno, '?', TextoConSigno),
	atomic_list_concat(ListaSinSigno, ' ', TextoSinSigno).
	
agregar_signo_pregunta(ListaConSigno, ListaSinSigno):-
	atomic_list_concat(ListaSinSigno, ' ', TextoSinSigno),
	atom_concat(TextoSinSigno, '?', TextoConSigno),
	atomic_list_concat(ListaConSigno, ' ', TextoConSigno).

noPredicado(Lista, Sobrante, Resultado):- 
	sintagma_nominal(Cantidad, Persona, Lista, ListaTransitoria, Resultado1),
	verbo(Cantidad, Persona, ListaTransitoria, Sobrante, Resultado2),
	append(Resultado1, Resultado2, Resultado).
	
predicado([], [], []).
predicado([Ingles|Sobrante], Sobrante, [Español]):- 
	traduccion(Español, Ingles).
predicado(Lista, Sobrante, Resultado):- 
	sintagma_nominal(Lista, Sobrante, Resultado).
predicado([Resultado|Sobrante], Sobrante, Resultado). %Caso en que no se pueda traducir


sintagma_nominal(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Español]):- %Caso de pronombre
	traduccion(Español, Ingles),
	pronombre(Cantidad, Persona, Español).
sintagma_nominal(Cantidad, Persona, [_|Lista], Sobrante, [Articulo, Español]):- %Caso de tercera persona con artículo
	articulo(Genero, Cantidad, Articulo),
	nombre(Genero, Cantidad, Lista, Sobrante, Español),
	Persona = 'tercera'.
sintagma_nominal(Cantidad, Persona, Lista, Sobrante, [Español]):- %Caso de tercera persona sin artículo
	nombre(_, Cantidad, Lista, Sobrante, Español),
	Persona = 'tercera'.
sintagma_nominal(_, _, [Sujeto|Sobrante], Sobrante, [Sujeto]):- %Caso para nombres propios
	[Verbo|_] = Sobrante,
	verbo(_, _, [Verbo], [], Verificador), 	%Verificador sirve para saber si el verbo fue traducido, debe haber un verbo por el orden de la oración.
	dif([Verbo], Verificador).			%Ej: Sarah eats apple. Si es un nombre propio siempre le va a seguir un verbo. Solo singular.
sintagma_nominal(_, _, [Articulo|Lista], Sobrante, [Articulo, Ingles]):- %Caso en que no se pueda traducir
	[Ingles|Sobrante] = Lista.
	
sintagma_nominal([_|Lista], Sobrante, [Articulo, Español]):- %Sintagma para el predicado con artículo
	articulo(Genero, Cantidad, Articulo),
	nombre(Genero, Cantidad, Lista, Sobrante, Español).
sintagma_nominal([Articulo|Lista], Sobrante, [Articulo, Ingles]):- %Caso en que no se pueda traducir el predicado
	[Ingles|Sobrante] = Lista.


nombre(Genero, Cantidad, [Ingles|Sobrante], Sobrante, EspañolPlural):- %Caso de ser plural (-es)
	sub_atom(Ingles, 0, _, 2, Base),
	traduccion(EspañolSingular, Base),
	nombre(Genero, EspañolSingular),
	atom_concat(EspañolSingular, 's', EspañolPlural),
	Cantidad = 'plural'.
nombre(Genero, Cantidad, [Ingles|Sobrante], Sobrante, EspañolPlural):- %Caso de ser plural (-s)
	sub_atom(Ingles, 0, _, 1, Base),
	traduccion(EspañolSingular, Base),
	nombre(Genero, EspañolSingular),
	atom_concat(EspañolSingular, 's', EspañolPlural),
	Cantidad = 'plural'.
nombre(Genero, Cantidad, [Ingles|Sobrante], Sobrante, Español):- %Caso de ser singular
	traduccion(Español, Ingles),
	nombre(Genero, Español),
	Cantidad = 'singular'.


verbo(Cantidad, Persona, [Will|Lista], Sobrante, [Conjugacion]):- %Caso de ser futuro
	Will = 'will',
	Lista = [Ingles|Sobrante],
	traduccion(Español, Ingles),
	averiguarConjugacion(Español, 'futuro', Cantidad, Persona, Conjugacion).
	
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser pasado (versión -ied)
	sub_atom(Ingles, 0, _, 3, BaseIncompleta), %Sobra el -ed, obteniendo la base del verbo
	atom_concat(BaseIncompleta, 'y', Base),
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser pasado (version -ed)
	sub_atom(Ingles, 0, _, 2, Base), %Sobra el -ed, obteniendo la base del verbo
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser pasado (version -d)
	sub_atom(Ingles, 0, _, 1, Base), %Sobra el -ed, obteniendo la base del verbo
	atom_concat(Base, UltimaLetra, Ingles),
	UltimaLetra = 'd', %Para diferenciar entre S de presente y D de pasado
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser pasado (version was)
	Ingles = 'was',
	averiguarConjugacion('ser', 'pasado', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser pasado (version were)
	Ingles = 'were',
	averiguarConjugacion('ser', 'pasado', Cantidad, Persona, Conjugacion).
	
verbo(_, _, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser presente con 's' (He, She, It)
	sub_atom(Ingles, 0, _, 1, Base),
	traduccion(Español, Base),
	averiguarConjugacion(Español, 'presente', 'singular', 'tercera', Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser presente sin 's' (Todos excepto He, She, It)
	traduccion(Español, Ingles),
	averiguarConjugacion(Español, 'presente', Cantidad, Persona, Conjugacion).
verbo(_, _, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser presente is
	Ingles = 'am',
	Conjugacion = 'estoy'.
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser presente is
	Ingles = 'is',
	averiguarConjugacion('ser', 'presente', Cantidad, Persona, Conjugacion).
verbo(Cantidad, Persona, [Ingles|Sobrante], Sobrante, [Conjugacion]):- %Caso de ser presente are
	Ingles = 'are',
	averiguarConjugacion('ser', 'presente', Cantidad, Persona, Conjugacion).
	
verbo(_, _, [Ingles|Sobrante], Sobrante, [Ingles]). %Caso en el que el verbo no tenga traducción

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

%Todo siempre empieza con traduccion().

%Preguntas
traduccion('¿Dónde', 'where').
traduccion('¿Cuándo', 'when').
traduccion('¿Qué', 'what').
traduccion('¿Por qué', 'why').
traduccion('¿Quién', 'who').
traduccion('¿Cómo', 'how').
traduccion('¿Cuán', 'howAlt').

%Pronombres			Forma de los pronombres: traduccion('español', 'ingles'). 
traduccion('yo','i').
traduccion('usted','you').
traduccion('él','he').
traduccion('ella','she').
traduccion('nosotros','us').
traduccion('ellos','they').
traduccion('estos', 'these').
traduccion('este', 'this').
traduccion('eso', 'that').
traduccion('esos', 'those').

%Verbos				Forma de los verbos: traducción('español', 'ingles'). ****Sólo infinitivos
traduccion('intentar', 'try').
traduccion('morir', 'die').
traduccion('correr', 'run').
traduccion('ser', 'be').

%Los siguientes verbos sólo pueden ser agregados a la lista si la traducción es únicamente de ingles a español ****Esto es para verbos que en ingles sean irregulares
traduccion('tener', 'have').
traduccion('tener', 'has').

%Adjetivos			Forma de los adejetivos: traduccion('español', 'ingles').
traduccion('lentamente','slowly').
traduccion('rápido', 'fast').
traduccion('deprimido', 'depressed'). 

%Nombres			Forma de los nombres: traduccion('español', 'ingles'). ****Únicamente el singular
traduccion('carro', 'car').
traduccion('tijera', 'scissor'). %Mal escrito pero es caso especial
traduccion('autódromo','racetrack').

%Clasificación de nombres	Forma de la clasificación de los nombres: nombre('genero', 'palabra').
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
pronombre('singular', 'tercera', 'este').
pronombre('singular', 'tercera', 'eso').
pronombre('plural', 'tercera', 'estos').
pronombre('plural', 'tercera', 'esos').

%Por defecto el programa elije ellos, para no tener 
%que diferenciar entre masculino y femenino, comentar él/ellos 
%en caso de usar los anteriores

%%%Verbos		Forma de los verbos irregulares: verboIrregular('infinitivo', 'tiempo', 'cantidad', 'persona', conjugación). ****Esto se tiene que hacer para cada conjugación irrgular que tenga el verbo. Si alguna conjugación coincide con un verbo regular (ej: morí es primera persona, pasado, singular y es igual a la terminación de los -ir).
verboIrregular('morir', 'pasado', 'singular', 'segunda', 'murió').
verboIrregular('morir', 'pasado', 'singular', 'tercera', 'murió').
verboIrregular('morir', 'presente', 'singular', 'primera', 'muero').
verboIrregular('morir', 'presente', 'singular', 'segunda', 'muere').
verboIrregular('morir', 'presente', 'singular', 'tercera', 'muere').

verboIrregular('ser', 'pasado', 'singular', 'primera', 'fui').
verboIrregular('ser', 'pasado', 'singular', 'segunda', 'fue').
verboIrregular('ser', 'pasado', 'singular', 'tercera', 'fue').
verboIrregular('ser', 'pasado', 'plural', 'primera', 'fuimos').
verboIrregular('ser', 'pasado', 'plural', 'segunda', 'fueron').
verboIrregular('ser', 'pasado', 'plural', 'tercera', 'fueron').
verboIrregular('ser', 'presente', 'singular', 'primera', 'soy').
verboIrregular('ser', 'presente', 'singular', 'segunda', 'es').
verboIrregular('ser', 'presente', 'singular', 'tercera', 'es').
verboIrregular('ser', 'presente', 'plural', 'primera', 'somos').
verboIrregular('ser', 'presente', 'plural', 'segunda', 'son').
verboIrregular('ser', 'presente', 'plural', 'tercera', 'son').

verboIrregular('tener', 'pasado', 'singular', 'primera', 'tuve').
verboIrregular('tener', 'pasado', 'singular', 'segunda', 'tuvo').
verboIrregular('tener', 'pasado', 'singular', 'tercera', 'tuvo').
verboIrregular('tener', 'pasado', 'plural', 'primera', 'tuvimos').
verboIrregular('tener', 'pasado', 'plural', 'segunda', 'tuvieron').
verboIrregular('tener', 'pasado', 'plural', 'tercera', 'tuvieron').
verboIrregular('tener', 'presente', 'singular', 'primera', 'tengo').
verboIrregular('tener', 'presente', 'singular', 'segunda', 'tiene').
verboIrregular('tener', 'presente', 'singular', 'tercera', 'tiene').
verboIrregular('tener', 'presente', 'plural', 'segunda', 'tienen').
verboIrregular('tener', 'presente', 'plural', 'tercera', 'tienen').
verboIrregular('tener', 'futuro', 'singular', 'primera', 'tendré').
verboIrregular('tener', 'futuro', 'singular', 'segunda', 'tendrá').
verboIrregular('tener', 'futuro', 'singular', 'tercera', 'tendrá').
verboIrregular('tener', 'futuro', 'plural', 'primera', 'tendremos').
verboIrregular('tener', 'futuro', 'plural', 'segunda', 'tendrán').
verboIrregular('tener', 'futuro', 'plural', 'tercera', 'tendrán').

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



















translate('Prolog es uno de los primeros lenguajes de programación lógica y sigue siendo popular hoy en día. Es un lenguaje de programación comúnmente asociado con la lingüística computacional y la inteligencia artificial y se utiliza en sistemas expertos, demostración de teoremas y comparación de patrones sobre árboles de análisis de lenguaje natural y procesamiento del lenguaje natural.', 'Prolog is one of the first logic programming languages and it remains popular today. It is a programming language commonly associated with computational linguistics and artificial intelligence and is used in expert systems, theorem proving and pattern matching over natural language parse trees and natural language processing').

