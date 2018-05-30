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
traduccion('morir', 'die').
traduccion('ser', 'be').
traduccion('abandonar','leave').
traduccion('depender','depend').
traduccion('maquillar','make up').
traduccion('abarcar','encompass').
traduccion('deplorar','deplore').
traduccion('maquillarse','make up').
traduccion('abatir','bring down').
traduccion('depositar','deposit').
traduccion('maravillar','wonder').
traduccion('abonar','pay').
traduccion('deprimir','depress').
traduccion('marcar','mark').
traduccion('abordar','approach').
traduccion('derribar','shoot down').
traduccion('marchar','march').
traduccion('abortar','abort').
traduccion('desaconsejar','advise against').
traduccion('marcharse','leave').
traduccion('abrazar','hug').
traduccion('desafinar','challenge').
traduccion('marear','marea').
traduccion('abrigar','shelter').
traduccion('desarrollar','develop').
traduccion('matar','kill').
traduccion('abrigarse','wrap').
traduccion('desarrollarse','develop').
traduccion('matricular','enroll').
traduccion('abrochar','fasten').
traduccion('desatar','tie off').
traduccion('matricularse','enroll').
traduccion('absorber','absorb').
traduccion('desayunar','have breakfast').
traduccion('maullar','meow').
traduccion('aburrir','bore').
traduccion('descansar','rest').
traduccion('meditar','meditate').
traduccion('aburrirse','get bored').
traduccion('descargar','download').
traduccion('mejorar','get better').
traduccion('abusar','abuse').
traduccion('descarrilar','derail').
traduccion('memorizar','memorize').
traduccion('acabar','finish').
traduccion('desconectar','disconnect').
traduccion('mencionar','mention').
traduccion('acampar','camp').
traduccion('desconfiar','distrust').
traduccion('mendigar','beg').
traduccion('acariciar','caress').
traduccion('descongelar','defrost').
traduccion('menguar','wane').
traduccion('acceder','access').
traduccion('descubrir','discover').
traduccion('meter','put').
traduccion('acelerar','speed ​​up').
traduccion('desear',' wish').
traduccion('mezclar','mix').
traduccion('acentuar','accentuate').
traduccion('desnudar','strip').
traduccion('migrar','migrate').
traduccion('aceptar',' accept').
traduccion('despegar','take off').
traduccion('mirar','look').
traduccion('acercar','zoom in').
traduccion('desplazar','displace').
traduccion('mistificar','mystify').
traduccion('acercarse','getting closer').
traduccion('destacar','highlight').
traduccion('modernizar','modernize').
traduccion('aclarar','clear out').
traduccion('destinar','target').
traduccion('modificar','modify').
traduccion('aclararse','clear up').
traduccion('destruir','destroy').
traduccion('modular','modular').
traduccion('acoger','welcome').
traduccion('desviar','divert').
traduccion('mojar','wet').
traduccion('acomodar','accommodate').
traduccion('detectar','detect').
traduccion('molar','molar').
traduccion('acompañar','accompany').
traduccion('deteriorar','deteriorate').
traduccion('molestar','bother').
traduccion('aconsejar','advise').
traduccion('determinar','decide').
traduccion('montar','mount').
traduccion('acoplar','couple').
traduccion('detestar','detest').
traduccion('motivar',' motivate').
traduccion('acortar','shorten').
traduccion('devorar','devour').
traduccion('movilizar','mobilize').
traduccion('acosar',' bully').
traduccion('dibujar',' draw').
traduccion('mudar','move').
traduccion('acostumbrar','accusm').
traduccion('dictar','dictate').
traduccion('mudarse','move').
traduccion('acostumbrarse','get used').
traduccion('diferenciar','differentiate').
traduccion('multiplicar','multiply').
traduccion('acrecentar','increase').
traduccion('difundir','spread').
traduccion('murmurar','murmur').
traduccion('acreditar','accredit').
traduccion('dimitir','resign').
traduccion('mutilar','maim').
traduccion('activar','activate').
traduccion('dirigir','lead').
traduccion('nadar','swim').
traduccion('actualizar',' update').
traduccion('discriminar','discriminate').
traduccion('narrar','narrate').
traduccion('actuar','act').
traduccion('disculpar','excuse').
traduccion('naufragar','sink').
traduccion('acudir','go').
traduccion('disculparse','apologize').
traduccion('navegar','surf').
traduccion('acusar',' accuse').
traduccion('discutir','argue').
traduccion('necesitar','need').
traduccion('adaptar',' adapt').
traduccion('diseñar','design').
traduccion('negociar','negotiate').
traduccion('adecuar','fit').
traduccion('disfrazar','disguise').
traduccion('neutralizar','neutralize').
traduccion('adelantar','advance').
traduccion('disfrutar','enjoy').
traduccion('neviscar','neviscar').
traduccion('adelgazar','slim down').
traduccion('disimular','hide').
traduccion('nombrar',' name').
traduccion('adivinar','guess').
traduccion('disminuir','decrease').
traduccion('notar','notice').
traduccion('adjuntar',' attach').
traduccion('disparar','shoot').
traduccion('notificar','notify').
traduccion('administrar','manage').
traduccion('disputar','dispute').
traduccion('nublar','cloudy').
traduccion('admirar',' admire').
traduccion('distinguir','distinguish').
traduccion('numerar','number').
traduccion('admitir',' admit').
traduccion('distribuir',' distribute').
traduccion('nutrir','nourish').
traduccion('adoptar','adopt').
traduccion('divergir','diverge').
traduccion('narrar','narrate').
traduccion('adorar',' adore').
traduccion('dividir','divide').
traduccion('nublar','cloudy').
traduccion('adornar','decorate').
traduccion('divisar','divide').
traduccion('obligar','obligate').
traduccion('afectar',' affect').
traduccion('divorciarse','divorce').
traduccion('observar','observe').
traduccion('afeitar',' shave').
traduccion('divulgar','divulge').
traduccion('ocultar','hide').
traduccion('afeitarse','shave').
traduccion('doblar','bend').
traduccion('ocupar','occupy').
traduccion('afinar','fine tune').
traduccion('dominar',' dominate').
traduccion('ocuparse','take care').
traduccion('afirmar','say').
traduccion('donar','donate').
traduccion('ocurrir','occur').
traduccion('afligir','afflict').
traduccion('ducharse','get a shower').
traduccion('odiar','hate').
traduccion('aflojar','loosen up').
traduccion('dudar','doubt').
traduccion('ofender',' offend').
traduccion('afrontar','front facing').
traduccion('duplicar','double').
traduccion('olvidar','forget').
traduccion('agarrar','grab').
traduccion('durar',' last').
traduccion('omitir','skip').
traduccion('agitar','shake').
traduccion('echar','throw').
traduccion('operar','operate').
traduccion('agotar','exhaust').
traduccion('echarse','lie').
traduccion('opinar','review').
traduccion('agradar','please').
traduccion('edificar','build').
traduccion('optar',' opt').
traduccion('agregar','add').
traduccion('editar','edit').
traduccion('ordenar','order').
traduccion('aguantar','endure').
traduccion('educar','educate').
traduccion('ordenar','order').
traduccion('aguardar','wait').
traduccion('efectuar','make').
traduccion('organizar','organize').
traduccion('ahogar','drown').
traduccion('ejecutar','run').
traduccion('orinar',' pee').
traduccion('ahorcar','hang').
traduccion('ejercer','exercise').
traduccion('osar','dare').
traduccion('ahorrar','save money').
traduccion('ejercitar',' exercise').
traduccion('oscilar','range').
traduccion('ajustar','adjust').
traduccion('elaborar',' elaborate').
traduccion('oxidar','oxidize').
traduccion('alargar',' enlarge').
traduccion('elevar','raise').
traduccion('paralizar','paralyze').
traduccion('alarmar','alarm').
traduccion('eliminar','remove').
traduccion('parar','sp').
traduccion('alborotar','disturb').
traduccion('emancipar','emancipate').
traduccion('pararse','sp').
traduccion('alcanzar','reach').
traduccion('embarazar','pregnant').
traduccion('parlar','parlar').
traduccion('alegar','plead').
traduccion('embarcar','embark').
traduccion('parpadear',' blink').
traduccion('alegrar','gladden').
traduccion('emborracharse','get drunk').
traduccion('participar','take part').
traduccion('alegrarse','rejoice').
traduccion('embrollar','muddle').
traduccion('partir','depart').
traduccion('alejar','ward off').
traduccion('embrujar','bewitch').
traduccion('pasar','happen').
traduccion('aligerar','lighten up').
traduccion('emerger','emerge').
traduccion('pasear','take a walk').
traduccion('alimentar','feed').
traduccion('emigrar','emigrate').
traduccion('pasmar','asnish').
traduccion('aliñar','dress').
traduccion('emitir',' emit').
traduccion('patear','kick').
traduccion('aliviar','relieve').
traduccion('empeñar','pawn').
traduccion('patinar','rollerblading').
traduccion('almacenar',' sck').
traduccion('empeñarse','engage').
traduccion('pedalear','pedal').
traduccion('alojar','accommodate').
traduccion('empezar','start').
traduccion('pegar','paste').
traduccion('alojarse',' stay').
traduccion('emplear','use').
traduccion('peinar','comb').
traduccion('alquilar','rent').
traduccion('emprender','undertake').
traduccion('peinarse','combing').
traduccion('alterar','alter').
traduccion('empujar','push').
traduccion('pelar','peel').
traduccion('alumbrar','light').
traduccion('enamorarse','fell in love').
traduccion('pelear','fight').
traduccion('alzar','raise').
traduccion('encajar',' fit in').
traduccion('pender','hang').
traduccion('amar',' love').
traduccion('encantar','love').
traduccion('penetrar','penetrate').
traduccion('amenazar',' threat').
traduccion('encargar',' place an order').
traduccion('percibir','perceive').
traduccion('amenizar','enlighten').
traduccion('enchufar','plug').
traduccion('perder',' lose').
traduccion('ampliar','enlarge').
traduccion('encoger','shrink').
traduccion('perdonar','forgive').
traduccion('amplificar','amplify').
traduccion('encuestar',' survey').
traduccion('perfeccionar',' perfect').
traduccion('analizar','analyze').
traduccion('enfadar','anger').
traduccion('perfumar','perfume').
traduccion('anhelar','long').
traduccion('enfadarse','get angry').
traduccion('perjudicar','harm').
traduccion('animar','encourage').
traduccion('enfermar','sick').
traduccion('permitir','allow').
traduccion('anotar','annotate').
traduccion('enfocar','focus').
traduccion('persistir',' persist').
traduccion('anticipar','anticipate').
traduccion('enfriar','cool').
traduccion('persuadir','persuade').
traduccion('anular','cancel').
traduccion('enganchar',' hook').
traduccion('pesar',' weigh').
traduccion('anunciar','announce').
traduccion('engañar','cheat').
traduccion('pescar','fishing').
traduccion('añadir','add').
traduccion('engañarse','deceive').
traduccion('piar','tweet').
traduccion('añorar','yearn').
traduccion('engordar','fatten').
traduccion('picar','chop').
traduccion('apagar',' turn off').
traduccion('engrasar','grease').
traduccion('pillar','pillar').
traduccion('aparcar','park').
traduccion('enhebrar','thread').
traduccion('pinchar','puncture').
traduccion('apartar','set aside').
traduccion('enlazar','link').
traduccion('pintar','paint').
traduccion('apelar','appeal').
traduccion('enojar','anger').
traduccion('pisar','step').
traduccion('apestar','stink').
traduccion('enojarse','get angry').
traduccion('planchar','iron').
traduccion('aplastar','smash').
traduccion('enredar','tangle').
traduccion('planear',' plan').
traduccion('aplaudir','applaud').
traduccion('enredarse','tangle').
traduccion('plantar','plant').
traduccion('aplazar','postpone').
traduccion('ensanchar','widen').
traduccion('plantear','pose').
traduccion('aplicar','apply').
traduccion('ensayar','test').
traduccion('platicar','talk').
traduccion('aportar','contribute').
traduccion('enseñar','teach').
traduccion('apoyar','support').
traduccion('ensuciar','dirty').
traduccion('portar','carry').
traduccion('apreciar',' appreciate').
traduccion('enterar','find out').
traduccion('posar','pose').
traduccion('aprender',' learn').
traduccion('enterarse','find out').
traduccion('practicar',' practice').
traduccion('apresurarse','hurry').
traduccion('entrañar','impress').
traduccion('pregonar','uting').
traduccion('aprovechar',' take advantage of').
traduccion('entrar','get in').
traduccion('preguntar','ask').
traduccion('apuntar','point').
traduccion('entregar','deliver').
traduccion('preguntarse','wonder').
traduccion('apuntarse','sign up').
traduccion('entrenar',' train').
traduccion('prender','turn on').
traduccion('apurarse','hurry').
traduccion('entrevistar',' interview').
traduccion('preocupar','worry').
traduccion('arañar','scratch').
traduccion('entusiasmar','enthuse').
traduccion('preocuparse',' worry').
traduccion('arder','burn').
traduccion('entusiasmarse','get excited').
traduccion('preparar','prepare').
traduccion('armar',' assemble').
traduccion('enviar','submit').
traduccion('prepararse','get prepared').
traduccion('arrancar','tear').
traduccion('envidiar',' envy').
traduccion('presentar','present').
traduccion('arrastrar','drag').
traduccion('equivocar','wrong').
traduccion('preservar','preserve').
traduccion('arreglar','fix').
traduccion('equivocarse','make a mistake').
traduccion('presionar','press').
traduccion('arrestar','arrest').
traduccion('errar','err').
traduccion('prestar','lend').
traduccion('arriesgar','risk').
traduccion('escalar','climb').
traduccion('presumir',' show off').
traduccion('arrojar','throw').
traduccion('escapar','escape').
traduccion('pretender','pretend').
traduccion('asar','roast').
traduccion('escoger','choose').
traduccion('privar','deprive').
traduccion('asegurar','ensure').
traduccion('esconder','hide').
traduccion('proceder','proceed').
traduccion('asesinar','murder').
traduccion('esconderse','hide').
traduccion('procesar','process').
traduccion('asistir','assist').
traduccion('escribir',' write').
traduccion('proclamar','proclaim').
traduccion('asociar','associate').
traduccion('escuchar','hear').
traduccion('procurar',' procure').
traduccion('asomar','show').
traduccion('escupir','spit').
traduccion('programar','program').
traduccion('asombrar','amaze').
traduccion('esforzar','strive').
traduccion('progresar','progress').
traduccion('aspirar','aspire').
traduccion('esparcir','spread').
traduccion('prohibir','ban').
traduccion('asumir','assume').
traduccion('especializarse','specialize').
traduccion('prolongar','prolong').
traduccion('asustar','frighten').
traduccion('especificar','specify').
traduccion('prometer','promise').
traduccion('asustarse','get scared').
traduccion('esperar','wait').
traduccion('pronunciar',' pronounce').
traduccion('atacar','attack').
traduccion('espirar','exhale').
traduccion('propagar','spread').
traduccion('atañer','attach').
traduccion('esquiar','ski').
traduccion('proporcionar','provide').
traduccion('atar','tie').
traduccion('estacionar','park').
traduccion('protagonizar','starring').
traduccion('aterrizar',' land').
traduccion('estallar','burst').
traduccion('proteger',' protect').
traduccion('atrapar','catch').
traduccion('estancar','stack').
traduccion('protestar',' protest').
traduccion('atrasar',' delay').
traduccion('estimar','estimate').
traduccion('provocar',' provoke').
traduccion('atreverse','dare').
traduccion('estimular',' stimulate').
traduccion('proyectar',' project').
traduccion('atribuir','attribute').
traduccion('estirar',' stretch').
traduccion('publicar',' post').
traduccion('aturdir','stun').
traduccion('estirarse','stretch').
traduccion('pulir','polish').
traduccion('aullar','howl').
traduccion('esrnudar','sneeze').
traduccion('pulsar','press').
traduccion('aumentar','increase').
traduccion('estrenar','brand new').
traduccion('puntuar','rate').
traduccion('autenticar','authenticate').
traduccion('estresar',' stress').
traduccion('purificar','purify').
traduccion('aurizar','authorize').
traduccion('estropear','spoil').
traduccion('quedar','stay').
traduccion('avanzar','move along').
traduccion('estudiar','study').
traduccion('quedarse','stay').
traduccion('averiguar','find out').
traduccion('evacuar','evacuate').
traduccion('quejarse',' complain').
traduccion('avisar','warn').
traduccion('evadir','evade').
traduccion('quemar','burn').
traduccion('ayudar','help').
traduccion('evaluar','evaluate').
traduccion('quemarse','burn').
traduccion('bailar','dance').
traduccion('evitar','avoid').
traduccion('quitar','remove').
traduccion('bajar','go down').
traduccion('evolucionar','evolve').
traduccion('quitarse','take off').
traduccion('balancear','swing').
traduccion('exagerar','exaggerate').
traduccion('radiar','radiate').
traduccion('bañar','bath').
traduccion('examinar','examine').
traduccion('rascar','scratch').
traduccion('bañarse','bath').
traduccion('excavar','dig').
traduccion('reaccionar','react').
traduccion('barajar','shuffle').
traduccion('excitar','excite').
traduccion('readmitir','readmit').
traduccion('barrer','sweep').
traduccion('exclamar','exclaim').
traduccion('realizar','perform').
traduccion('bastar','be enough').
traduccion('excluir','exclude').
traduccion('rebobinar','rewind').
traduccion('batir','shake').
traduccion('excusar','excuse').
traduccion('rebuscar','rummage').
traduccion('bautizar','baptize').
traduccion('excusarse','apologize').
traduccion('recargar','recharge').
traduccion('beber',' drink').
traduccion('exhalar','exhale').
traduccion('recelar','fear').
traduccion('beneficiar','benefit').
traduccion('exhibir',' exhibit').
traduccion('rechazar',' refuse').
traduccion('besar','kiss').
traduccion('exigir','demand').
traduccion('recibir',' receive').
traduccion('bloquear',' block').
traduccion('existir','exist').
traduccion('reciclar','recycle').
traduccion('bombear','pump').
traduccion('experimentar',' experience').
traduccion('reclamar','claim').
traduccion('bordar','embroider').
traduccion('expirar','expire').
traduccion('recoger','collect').
traduccion('borrar','delete').
traduccion('explicar','explain').
traduccion('reconquistar','reconquer').
traduccion('bostezar','yawn').
traduccion('explorar',' explore').
traduccion('reconstruir','rebuild').
traduccion('brillar','shine').
traduccion('explotar','exploit').
traduccion('recopilar','collect').
traduccion('brincar','jump').
traduccion('exportar',' export').
traduccion('recorrer','travel').
traduccion('brindar','offer').
traduccion('expresar','express').
traduccion('rectificar','rectify').
traduccion('bromear',' joke').
traduccion('exprimir','squeeze').
traduccion('recuperar','recover').
traduccion('broncear','tan').
traduccion('expulsar','expel').
traduccion('redactar','write').
traduccion('bruñir','burnish').
traduccion('extrañar','miss').
traduccion('reemplazar','replace').
traduccion('bucear','diving').
traduccion('fabricar','manufacture').
traduccion('refinar','refine').
traduccion('bullir','boil').
traduccion('facilitar',' ease').
traduccion('reflejar','reflect').
traduccion('burlar','outwit').
traduccion('facturar','check in').
traduccion('reflexionar','reflect').
traduccion('burlarse','make fun').
traduccion('fallar','fail').
traduccion('refrigerar','refrigerate').
traduccion('buscar','search').
traduccion('faltar','lack').
traduccion('regalar','give away').
traduccion('cagar','shit').
traduccion('fascinar','fascinate').
traduccion('regatear','bargain').
traduccion('calcular','calculate').
traduccion('fatigar','fatigue').
traduccion('registrar',' register').
traduccion('caldear','warm').
traduccion('felicitar',' congratulate').
traduccion('regresar',' return').
traduccion('calificar','qualify').
traduccion('festejar','celebrate').
traduccion('regular','regular').
traduccion('callar','shut up').
traduccion('fiar','trust').
traduccion('rehusar','refuse').
traduccion('callarse','shut up').
traduccion('fiarse','trust').
traduccion('reinar','reign').
traduccion('calmar',' calm').
traduccion('figurar','figure').
traduccion('relacionar','relate').
traduccion('calmarse','calm down').
traduccion('figurarse','figure').
traduccion('relajarse','chill out').
traduccion('calzar','wear').
traduccion('fijar','pin up').
traduccion('relatar','tell').
traduccion('cambiar','change').
traduccion('fijarse','set').
traduccion('rellenar','fill').
traduccion('caminar','walk').
traduccion('filmar',' film').
traduccion('remar','row').
traduccion('canalizar','channel').
traduccion('filosofar','philosophize').
traduccion('remitir','refer').
traduccion('cancelar','cancel').
traduccion('filtrar','filter').
traduccion('renovar','renovate').
traduccion('candar','candar').
traduccion('finalizar','finalize').
traduccion('renunciar','give up').
traduccion('cansar','tire out').
traduccion('financiar',' finance').
traduccion('reparar','repair').
traduccion('cansarse','get tired').
traduccion('firmar','sign').
traduccion('repartir','distribute').
traduccion('cantar',' sing').
traduccion('flirtear','flirt').
traduccion('repasar','review').
traduccion('capitular','capitulate').
traduccion('flotar','float up').
traduccion('replicar','replicate').
traduccion('capturar','capture').
traduccion('fluctuar','fluctuate').
traduccion('reportar','report').
traduccion('caracterizar','characterize').
traduccion('fluir','flow').
traduccion('representar','represent').
traduccion('cargar','load').
traduccion('fomentar','foment').
traduccion('reprochar','reproach').
traduccion('casar','marry').
traduccion('formar',' form').
traduccion('resbalar','slide').
traduccion('casarse','get marry').
traduccion('formular','formulate').
traduccion('reservar','reserve').
traduccion('castigar','punish').
traduccion('fortificar','fortify').
traduccion('resfriarse',' catch a cold').
traduccion('categorizar','categorize').
traduccion('fografiar',' phograph').
traduccion('resistir',' resist').
traduccion('causar','cause').
traduccion('fracasar','fail').
traduccion('respetar','respect').
traduccion('cautivar','captivate').
traduccion('frenar','brake').
traduccion('respirar','breathe').
traduccion('cavar','dig').
traduccion('frotar','rub').
traduccion('responder','answer').
traduccion('cazar','hunt').
traduccion('frustrar','frustrate').
traduccion('restaurar','resre').
traduccion('ceder','give').
traduccion('fumar','smoke').
traduccion('restituir','return').
traduccion('celebrar','celebrate').
traduccion('funcionar','function').
traduccion('resultar','result').
traduccion('cenar','dine').
traduccion('fundar','found').
traduccion('resumir','summarize').
traduccion('censurar','censor').
traduccion('fundir','melt').
traduccion('retirar','remove').
traduccion('centralizar','centralize').
traduccion('fusionar','fuse').
traduccion('retrasar',' delay').
traduccion('centrar','center').
traduccion('ganar','win').
traduccion('reunir','gather').
traduccion('cepillar','brush').
traduccion('gandulear','lounge').
traduccion('reunirse','get gether').
traduccion('cepillarse','brush').
traduccion('garantizar',' guarantee').
traduccion('revelar',' reveal').
traduccion('cerrar','close').
traduccion('gastar','spend').
traduccion('revisar','check').
traduccion('cesar','cease').
traduccion('generalizar','generalize').
traduccion('rezar','pray').
traduccion('charlar','chat').
traduccion('generar','generate').
traduccion('robar','steal').
traduccion('chatear','chat').
traduccion('gestionar','manage').
traduccion('rodear','surround').
traduccion('chocar','hit').
traduccion('girar','turn').
traduccion('roer','gnaw').
traduccion('chupar','suck').
traduccion('glorificar','glorify').
traduccion('roncar','snore').
traduccion('cifrar','code').
traduccion('golpear','hit').
traduccion('saborear','savor').
traduccion('circular','circular').
traduccion('gozar','enjoy').
traduccion('sabotear','sabotage').
traduccion('citar','quote').
traduccion('grabar','record').
traduccion('sacar','take').
traduccion('civilizar','civilize').
traduccion('graduar','graduate').
traduccion('saciar','satiate').
traduccion('clarear','lighten').
traduccion('graduarse','graduate').
traduccion('sacrificar','sacrifice').
traduccion('clarificar','clarify').
traduccion('granizar','hail').
traduccion('sacudir','shake').
traduccion('clasificar','sort out').
traduccion('gritar','shout').
traduccion('salar',' salt').
traduccion('clavar','nail').
traduccion('gruñir','snarl').
traduccion('saltar','skip').
traduccion('cobrar','charge').
traduccion('guardar','save').
traduccion('saludar','greet').
traduccion('cocinar','cook').
traduccion('guiar','guide').
traduccion('salvar','save').
traduccion('codificar','encode').
traduccion('gustar','like').
traduccion('sanar','heal').
traduccion('coger','take').
traduccion('habitar','live').
traduccion('satirizar','satirize').
traduccion('coincidir','coincide').
traduccion('habituar','habituate').
traduccion('secar','dry off').
traduccion('colaborar',' collaborate').
traduccion('hablar','talk').
traduccion('secarse','dry up').
traduccion('coleccionar','collect').
traduccion('halagar','flatter').
traduccion('seleccionar','select').
traduccion('colocar','place').
traduccion('hallar','find').
traduccion('señalar','point').
traduccion('colonizar','colonize').
traduccion('hallarse','be').
traduccion('separar','pull apart').
traduccion('colorear','color').
traduccion('hechizar','bewitch').
traduccion('separarse','break away').
traduccion('combatir','fight').
traduccion('hipnotizar','hypnotize').
traduccion('significar',' mean').
traduccion('combinar',' combine').
traduccion('huir','run away').
traduccion('simbolizar','symbolize').
traduccion('comentar','comment').
traduccion('humillar','humiliate').
traduccion('simpatizar','sympathize').
traduccion('comer','eat').
traduccion('hundir',' sink').
traduccion('simular','simulate').
traduccion('comerciar','trade').
traduccion('idealizar','idealize').
traduccion('sincronizar','sync up').
traduccion('cometer','commit').
traduccion('identificar','identify').
traduccion('sintetizar','synthesize').
traduccion('comparar','compare').
traduccion('ignorar','ignore').
traduccion('sinnizar','tune in').
traduccion('compartir','share').
traduccion('iluminar',' illuminate').
traduccion('situar','place').
traduccion('compensar','make up for').
traduccion('ilustrar',' illustrate').
traduccion('sobrar','over').
traduccion('compilar','compile').
traduccion('imaginar','imagine').
traduccion('sobreseer','sobreseer').
traduccion('completar',' complete').
traduccion('imaginarse','imagine').
traduccion('sobrevivir','survive').
traduccion('complicar','complicate').
traduccion('imitar','imitate').
traduccion('socorrer','help').
traduccion('comportar','behave').
traduccion('implementar','implement').
traduccion('solicitar','apply for').
traduccion('comprar',' buy').
traduccion('implicar',' imply').
traduccion('solucionar','solve').
traduccion('comprender','understand').
traduccion('importar',' import').
traduccion('someter','submit').
traduccion('comprimir','compress').
traduccion('impresionar','impress').
traduccion('soplar','blow').
traduccion('comprometer','compromise').
traduccion('imprimir',' print').
traduccion('soportar','put up with').
traduccion('comunicar','communicate').
traduccion('improvisar','improvise').
traduccion('sorprender',' surprise').
traduccion('conceder','grant').
traduccion('inaugurar','inaugurate').
traduccion('sospechar','suspect').
traduccion('concentrar','concentrate').
traduccion('inclinar','tilt').
traduccion('subir','go up').
traduccion('condenar','condemn').
traduccion('incorporar',' incorporate').
traduccion('subrayar','underline').
traduccion('condicionar','condition').
traduccion('incrementar','increase').
traduccion('suceder','happen').
traduccion('conectar','connect').
traduccion('indicar','indicate').
traduccion('sudar','sweat').
traduccion('confiar','trust').
traduccion('influir','influence').
traduccion('sufrir','suffer').
traduccion('configurar','set up').
traduccion('informar','report').
traduccion('sujetar','hold').
traduccion('confirmar','confirm').
traduccion('informarse','inform').
traduccion('sumar','add').
traduccion('confiscar','confiscate').
traduccion('ingresar','enter').
traduccion('superar','overcome').
traduccion('confundir','confuse').
traduccion('inhalar','inhale').
traduccion('suplicar','supplicate').
traduccion('confundirse','get confused').
traduccion('iniciar','start').
traduccion('suplir','supply').
traduccion('congelar','freeze').
traduccion('inmigrar','immigrate').
traduccion('suprimir','suppress').
traduccion('conjeturar','guess').
traduccion('inmiscuirse','interfere').
traduccion('surtir','supply').
traduccion('conjugar','combine').
traduccion('insertar','insert').
traduccion('suspender','lay off').
traduccion('conocerse','meet').
traduccion('insistir','insist').
traduccion('suspirar',' sigh').
traduccion('conquistar','conquer').
traduccion('inspeccionar',' inspect').
traduccion('tañer','ring').
traduccion('conservar','keep').
traduccion('inspirar','inspire').
traduccion('tapar','cover').
traduccion('considerar',' consider').
traduccion('instalar','install').
traduccion('tararear','hum').
traduccion('consistir','consist').
traduccion('instruir','instruct').
traduccion('tardar','take').
traduccion('consolidar','consolidate').
traduccion('insultar',' insult').
traduccion('tartamudear','stutter').
traduccion('constatar','note').
traduccion('integrar',' integrate').
traduccion('tatuar','tato').
traduccion('constituir','constitute').
traduccion('intentar','try').
traduccion('tejer',' knit').
traduccion('construir','build').
traduccion('intercambiar',' exchange').
traduccion('telefonear','call').
traduccion('consultar','consult').
traduccion('interesar','interest').
traduccion('temer','fear').
traduccion('consumir','consume').
traduccion('interpretar','play').
traduccion('temperar','temperate').
traduccion('contactar','contact').
traduccion('interrogar','question').
traduccion('templar','temper').
traduccion('contaminar',' pollute').
traduccion('interrumpir','interrupt').
traduccion('terminar','end up').
traduccion('contemplar','contemplate').
traduccion('inundar','flood').
traduccion('tintar','tintar').
traduccion('contestar','answer').
traduccion('invadir','encroach').
traduccion('tirar','throw').
traduccion('continuar','continue').
traduccion('inventar','invent').
traduccion('titular','headline').
traduccion('contratar','contract').
traduccion('investigar','research').
traduccion('car','play').
traduccion('contribuir','contribute').
traduccion('invitar','invite').
traduccion('lerar','lerate').
traduccion('controlar','control').
traduccion('invocar','invoke').
traduccion('mar','drink').
traduccion('conversar',' converse').
traduccion('inyectar','inject').
traduccion('rnear','turning').
traduccion('convidar','invite').
traduccion('jactarse','boast').
traduccion('ser','cough').
traduccion('convivir','live gether').
traduccion('joder','fuck').
traduccion('trabajar',' work').
traduccion('cooperar','cooperate').
traduccion('juntar','put gether').
traduccion('tragar','swallow').
traduccion('coordinar',' coordinate').
traduccion('juntarse','get gether').
traduccion('traicionar','betray').
traduccion('copiar','copy').
traduccion('jurar','swear').
traduccion('tramar','hatch').
traduccion('coquetear',' flirt').
traduccion('justificar','justify').
traduccion('tramitar','process').
traduccion('coronar',' crown').
traduccion('juzgar','judge').
traduccion('transformar','transform').
traduccion('correr','run').
traduccion('laborar','labor').
traduccion('transmitir',' transmit').
traduccion('corresponder','correspond').
traduccion('ladrar',' bark').
traduccion('transportar','transport').
traduccion('corromper','corrupt').
traduccion('lamentar',' regret').
traduccion('trasladar','move').
traduccion('cortar','cut').
traduccion('lamentarse','lament').
traduccion('tratar','try').
traduccion('cosechar','harvest').
traduccion('lamer',' lick').
traduccion('trazar','draw').
traduccion('coser','sew').
traduccion('lanzar','throw').
traduccion('tricotar','knit').
traduccion('crear','create').
traduccion('lastimar','hurt').
traduccion('triunfar','succeed').
traduccion('creer','believe').
traduccion('lastimarse','injure').
traduccion('tumbar','overthrow').
traduccion('criar','raise').
traduccion('latir','beat').
traduccion('tumbarse','lie down').
traduccion('criticar','criticize').
traduccion('lavar',' wash').
traduccion('ubicar','locate').
traduccion('crucificar','crucify').
traduccion('lavarse','wash up').
traduccion('unir','link').
traduccion('crujir','creak').
traduccion('leer','read').
traduccion('untar','spread').
traduccion('cruzar','cross').
traduccion('legalizar','legalize').
traduccion('urdir','weave').
traduccion('cruzarse','cross').
traduccion('legar','bequeath').
traduccion('urgir','urge').
traduccion('cuajar','set').
traduccion('legitimar','legitimize').
traduccion('usar','use').
traduccion('cuantificar','quantify').
traduccion('levantar','lift up').
traduccion('utilizar','use').
traduccion('cubrir','cover').
traduccion('levantarse','get up').
traduccion('vaciar','empty').
traduccion('cuidar','look after').
traduccion('levar','weigh').
traduccion('vacilar','hesitate').
traduccion('cuidarse','take care').
traduccion('liar','roll').
traduccion('vagar',' wander').
traduccion('culpar',' blame').
traduccion('liberar','break free').
traduccion('valuar','value').
traduccion('cultivar','cultivate').
traduccion('licuar','liquefy').
traduccion('variar',' vary').
traduccion('cumplir','comply').
traduccion('limitar','limit').
traduccion('vencer','overcome').
traduccion('curar','cure').
traduccion('limpiar','clean').
traduccion('vendar','bind up').
traduccion('danzar','dance').
traduccion('liquidar','liquidate').
traduccion('vender',' sell').
traduccion('dañar',' damage').
traduccion('listar',' list').
traduccion('venerar','venerate').
traduccion('debatir',' debate').
traduccion('llamar',' call').
traduccion('verificar','check').
traduccion('deber','duty').
traduccion('llamarse','called').
traduccion('viajar','travel').
traduccion('decepcionar','disappoint').
traduccion('llegar','arrive').
traduccion('vibrar','vibrate').
traduccion('decidir','decide').
traduccion('llenar','fill in').
traduccion('vigilar','look out').
traduccion('declarar',' declare').
traduccion('llevar','carry').
traduccion('vincular','link').
traduccion('declinar','decline').
traduccion('llevarse','carry off').
traduccion('violar','rape').
traduccion('decorar','decorate').
traduccion('llorar','cry').
traduccion('visitar',' visit').
traduccion('dedicar',' dedicate').
traduccion('lloviznar','drizzle').
traduccion('vislumbrar','glimpse').
traduccion('dedicarse','dedicate').
traduccion('localizar',' locate').
traduccion('vivir','live').
traduccion('definir','define').
traduccion('lograr','achieve').
traduccion('voltear','flip').
traduccion('degustar','taste').
traduccion('luchar',' struggle').
traduccion('vomitar','barf').
traduccion('dejar','leave').
traduccion('madrugar','early morning').
traduccion('votar','vote').
traduccion('delinquir','delinquir').
traduccion('madurar',' mature').
traduccion('zambullirse','dive').
traduccion('denigrar','denigrate').
traduccion('manchar','stain').

%Los siguientes verbos sólo pueden ser agregados a la lista si la traducción es únicamente de ingles a español ****Esto es para verbos que en ingles sean irregulares
traduccion('tener', 'have').
traduccion('tener', 'has').

%Adjetivos			Forma de los adejetivos: traduccion('español', 'ingles').
traduccion('lentamente','slowly').
traduccion('deprimido', 'depressed'). 
traduccion('aburrido','bored').
traduccion('aburrido','boring').
traduccion('ácido','acid').
traduccion('alegre','cheerful').
traduccion('alto','tall').
traduccion('amargo','bitter').
traduccion('ancho','wide').
traduccion('atrevido','daring').
traduccion('azul','blue').
traduccion('bajo','short').
traduccion('bajo','low').
traduccion('blanco','white').
traduccion('blando','soft').
traduccion('bonito','pretty').
traduccion('buen','good').
traduccion('bueno','good').
traduccion('caliente','hot').
traduccion('capaz','capable').
traduccion('capaz','able').
traduccion('central','central').
traduccion('común','common').
traduccion('conocido','known').
traduccion('contento','happy').
traduccion('corto','short').
traduccion('débil','weak').
traduccion('delgado','thin').
traduccion('derecho','rigth').
traduccion('diferente','different').
traduccion('difícil','difficult').
traduccion('divertido','funny').
traduccion('dulce','sweet').
traduccion('duro','hard').
traduccion('enfermo','ill').
traduccion('estrecho','tight').
traduccion('exterior','outside').
traduccion('fácil','easy').
traduccion('falso','false').
traduccion('famoso','famous').
traduccion('feo','ugly').
traduccion('final','final').
traduccion('fresco','fresh').
traduccion('frío','cold').
traduccion('fuerte','strong').
traduccion('gordo','fat').
traduccion('gran','big').
traduccion('grande','big').
traduccion('guapo','handsome').
traduccion('guay','cool').
traduccion('húmedo','damp').
traduccion('igual','same').
traduccion('igual','equal').
traduccion('imposible','impossible').
traduccion('interesante','interesting').
traduccion('interior','inside').
traduccion('inutil','unsuccessful').
traduccion('inutil','useless').
traduccion('izquierdo','left').
traduccion('joven','young').
traduccion('largo','long').
traduccion('lento','slow').
traduccion('listo','smart').
traduccion('malo','bad').
traduccion('masivo','massive').
traduccion('mayor','bigger').
traduccion('mejor','best').
traduccion('menor','smaller').
traduccion('mucho','a lot of').
traduccion('muerto','dead').
traduccion('musical','musical').
traduccion('nacional','national').
traduccion('natural','natural').
traduccion('negro','black').
traduccion('nuevo','new').
traduccion('peor','worse').
traduccion('pequeño','little').
traduccion('perfecto','perfect').
traduccion('pobre','poor').
traduccion('poco','little').
traduccion('poco','few').
traduccion('popular','popular').
traduccion('posible','possible').
traduccion('primer','first').
traduccion('primero','first').
traduccion('principal','principal').
traduccion('próximo','next').
traduccion('rápido','fast').
traduccion('raro','rare').
traduccion('real','real').
traduccion('recto','straigth').
traduccion('rico','rich').
traduccion('rojo','red').
traduccion('salado','salty').
traduccion('sano','healthy').
traduccion('seco','dry').
traduccion('segundo','second').
traduccion('simple','simple').
traduccion('sinvergüenza','shameless').
traduccion('social','social').
traduccion('solo','alone').
traduccion('soso','unsalted').
traduccion('tímido','shy').
traduccion('tonto','shy').
traduccion('triste','sad').
traduccion('útil','useful').
traduccion('verdadero','true').
traduccion('verde','green').
traduccion('viejo','old').
traduccion('enfadado','angry').
traduccion('feliz','happy').
traduccion('triste','sad').
traduccion('hambriento','hungry').
traduccion('somnoliento','sleepy').
traduccion('muy cansado','exhausted').
traduccion('despierto','awake').
traduccion('dormido','asleep').
traduccion('bueno','good').
traduccion('malo','bad').
traduccion('hermosa ','beautiful').
traduccion('feo','ugly').
traduccion('guapo','handsome').
traduccion('hermoso','lovely').
traduccion('sencillo','plain').
traduccion('ácido','sour').
traduccion('amargo','bitter').
traduccion('dulce','sweet').
traduccion('asqueroso ','disgusting').
traduccion('negro','black').
traduccion('blanco','white').
traduccion('rojo','red').
traduccion('azul','blue').
traduccion('amarillo ','yellow').
traduccion('naranja ','orange').
traduccion('verde','green').
traduccion('morado ','purple').
traduccion('gris','grey').
traduccion('marrón ','brown').
traduccion('limpio','clean').
traduccion('ordenado','tidy').
traduccion('sucio','dirty').
traduccion('desordenado','messy').
traduccion('caliente','hot').
traduccion('caluroso','warm').
traduccion('fresco','cool').
traduccion('frío','cold').
traduccion('mojado','wet').
traduccion('seco','dry').
traduccion('lluvioso','rainy').
traduccion('soleado','sunny').
traduccion('nevado','snowy').
traduccion('nuboso','foggy').
traduccion('temprano','early').
traduccion('tarde','late').
traduccion('verdadero','true').
traduccion('cierto','true').
traduccion('falso','false').
traduccion('gordo','fat').
traduccion('delgado','thin').
traduccion('alto','tall').
traduccion('bajo','short').
traduccion('grande','big').
traduccion('pequeño','small').
traduccion('lleno','full').
traduccion('vacío','empty').
traduccion('aburrido','boring').
traduccion('interesante','interesting').
traduccion('lento','slow').
traduccion('rápido','fast').

%Nombres			Forma de los nombres: traduccion('español', 'ingles'). ****Únicamente el singular
traduccion('carro', 'car').
traduccion('tijera', 'scissor'). %Mal escrito pero es caso especial
traduccion('autódromo','racetrack').
traduccion('acción','action').
traduccion('edad','age').
traduccion('aire','air').
traduccion('animal','animal').
traduccion('respuesta','answer').
traduccion('manzana','apple').
traduccion('arte','art').
traduccion('bebé','baby').
traduccion('espalda','back').
traduccion('bola','ball').
traduccion('pelota','ball').
traduccion('banco','bank').
traduccion('cama','bed').
traduccion('factura','bill').
traduccion('pájaro','bird').
traduccion('sangre','blood').
traduccion('barco','boat').
traduccion('cuerpo','body').
traduccion('hueso','bone').
traduccion('libro','book').
traduccion('fondo','bottom').
traduccion('caja','box').
traduccion('niño','boy').
traduccion('hermano','brother').
traduccion('edificio','building').
traduccion('negocio','business').
traduccion('llamada','call').
traduccion('capital','capital').
traduccion('caso','case').
traduccion('estuche','case').
traduccion('gato','cat').
traduccion('causa','cause').
traduccion('céntimo','cent').
traduccion('centro','center').
traduccion('siglo','century').
traduccion('oportunidad','chance').
traduccion('cambio','change').
traduccion('cheque','check').
traduccion('niño','child').
traduccion('iglesia','church').
traduccion('círculo','circle').
traduccion('ciudad','city').
traduccion('clase','class').
traduccion('curso','class').
traduccion('ropa','clothes').
traduccion('nube','cloud').
traduccion('costa','coast').
traduccion('color','color').
traduccion('empresa','company').
traduccion('consonante','consonant').
traduccion('copia','copy').
traduccion('maíz','corn').
traduccion('algodón','cotton').
traduccion('país','country').
traduccion('curso','course').
traduccion('vaca','cow').
traduccion('multitud','crowd').
traduccion('día','day').
traduccion('diccionario','dictionary').
traduccion('dirección','direction').
traduccion('distancia','distance').
traduccion('médico','doctor').
traduccion('dólar','dollar').
traduccion('puerta','door').
traduccion('oreja','ear').
traduccion('tierra','earth').
traduccion('huevo','egg').
traduccion('energía','energy').
traduccion('ejemplo','example').
traduccion('experiencia','experience').
traduccion('ojo','eye').
traduccion('juego, partido','game').
traduccion('jardín','garden').
traduccion('carburante','gas').
traduccion('chica','girl').
traduccion('vidrio','glass').
traduccion('vaso','glass').
traduccion('oro','gold').
traduccion('gobierno','government').
traduccion('hierba','grass').
traduccion('césped','grass').
traduccion('grupo','group').
traduccion('pelo','hair').
traduccion('mano','hand').
traduccion('sombrero','hat').
traduccion('cabeza','head').
traduccion('corazón','heart').
traduccion('calor, calefacción','heat').
traduccion('historia','history').
traduccion('agujero, hueco','hole').
traduccion('casa','home').
traduccion('hogar','home').
traduccion('caballo','horse').
traduccion('hora','hour').
traduccion('casa','house').
traduccion('hielo','ice').
traduccion('idea','idea').
traduccion('pulgada','inch').
traduccion('industria','industry').
traduccion('información','information').
traduccion('insecto','insect').
traduccion('interés','interest').
traduccion('hierro','iron').
traduccion('plancha','iron').
traduccion('isla','island').
traduccion('puesto de trabajo','job').
traduccion('llave','key').
traduccion('lago','lake').
traduccion('tierra','land').
traduccion('idioma','language').
traduccion('ley','law').
traduccion('pierna','leg').
traduccion('nivel','level').
traduccion('mentira','lie').
traduccion('vida','life').
traduccion('luz','light').
traduccion('línea','line').
traduccion('lista','list').
traduccion('máquina','machine').
traduccion('hombre','man').
traduccion('mapa','map').
traduccion('material','material').
traduccion('carne','meat').
traduccion('medio','middle').
traduccion('milla','mile').
traduccion('leche','milk').
traduccion('mente','mind').
traduccion('minuto','minute').
traduccion('dinero','money').
traduccion('mes','month').
traduccion('luna','moon').
traduccion('boca','mouth').
traduccion('música','music').
traduccion('nación','nation').
traduccion('noche','night').
traduccion('nariz','nose').
traduccion('nota','note').
traduccion('número','number').
traduccion('objeto','object').
traduccion('océano','ocean').
traduccion('oficina','office').
traduccion('aceite','oil').
traduccion('petróleo','petrol').
traduccion('página','page').
traduccion('par','pair').
traduccion('papel','paper').
traduccion('párrafo','paragraph').
traduccion('parque','park').
traduccion('parte','part').
traduccion('fiesta','party').
traduccion('partido','game').
traduccion('pasado','past').
traduccion('persona','person').
traduccion('gente','people').
traduccion('libra','pound').
traduccion('presidente','president').
traduccion('problema','problem').
traduccion('producto','product').
traduccion('propiedad','property').
traduccion('pregunta','question').
traduccion('carrera','race').
traduccion('radio','radio').
traduccion('lluvia','rain').
traduccion('razón','reason').
traduccion('récord','record').
traduccion('región','region').
traduccion('anillo','ring').
traduccion('río','river').
traduccion('camino','road').
traduccion('roca','rock').
traduccion('fila','row').
traduccion('regla','rule').
traduccion('arena','sand').
traduccion('escuela','school').
traduccion('ciencia','science').
traduccion('mar','sea').
traduccion('asiento','seat').
traduccion('segundo','second').
traduccion('frase','sentence').
traduccion('set','set').
traduccion('serie','set').
traduccion('lado','side').
traduccion('señal','sign').
traduccion('signo','sign').
traduccion('hermana','sister').
traduccion('talla','size').
traduccion('tamaño','size').
traduccion('piel','skin').
traduccion('nieve','snow').
traduccion('soldado','soldier').
traduccion('solución','solution').
traduccion('hijo','son').
traduccion('primavera','spring').
traduccion('cuadrado','square').
traduccion('estrella','star').
traduccion('estado','state').
traduccion('parada','stop').
traduccion('calle','street').
traduccion('estudiante','student').
traduccion('azúcar','sugar').
traduccion('sol','sun').
traduccion('pueblo','village').
traduccion('vocal','vowel').
traduccion('guerra','war').
traduccion('tiempo','weather').
traduccion('peso','weight').
traduccion('esposa','wife').
traduccion('ventana','window').
traduccion('invierno','winter').
traduccion('mujer','woman').
traduccion('palabra','word').
traduccion('mundo','world').

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

