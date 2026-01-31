










{. Una biblioteca nos ha encargado procesar la información de los préstamos realizados
durante el año 2021. De cada préstamo se conoce el ISBN del libro, el número de socio, día
y mes del préstamo y cantidad de días prestados. Implementar un programa con:
a. Un módulo que lea préstamos y retorne 2 estructuras de datos con la información de
los préstamos. La lectura de los préstamos finaliza con ISBN 0. Las estructuras deben
ser eficientes para buscar por ISBN.
i. En una estructura cada préstamo debe estar en un nodo. Los ISBN repetidos
insertarlos a la derecha.
ii. En otra estructura, cada nodo debe contener todos los préstamos realizados al ISBN.
(prestar atención sobre los datos que se almacenan).
b. Un módulo recursivo que reciba la estructura generada en i. y retorne el ISBN más
grande.
c. Un módulo recursivo que reciba la estructura generada en ii. y retorne el ISBN más
pequeño.
d. Un módulo recursivo que reciba la estructura generada en i. y un número de socio. El
módulo debe retornar la cantidad de préstamos realizados a dicho socio.
e. Un módulo recursivo que reciba la estructura generada en ii. y un número de socio. El
módulo debe retornar la cantidad de préstamos realizados a dicho socio.
f. Un módulo que reciba la estructura generada en i. y retorne una nueva estructura
ordenada por ISBN, donde cada ISBN aparezca una vez junto a la cantidad total de veces
que se prestó.
g. Un módulo que reciba la estructura generada en ii. y retorne una nueva estructura
ordenada por ISBN, donde cada ISBN aparezca una vez junto a la cantidad total de veces
que se prestó.
h. Un módulo recursivo que reciba la estructura generada en g. y muestre su contenido.
i. Un módulo recursivo que reciba la estructura generada en i. y dos valores de ISBN. El
módulo debe retornar la cantidad total de préstamos realizados a los ISBN
comprendidos entre los dos valores recibidos (incluidos).
j. Un módulo recursivo que reciba la estructura generada en ii. y dos valores de ISBN. El
módulo debe retornar la cantidad total de préstamos realizados a los ISBN
comprendidos entre los dos valores recibidos (incluidos).}

Program Actividad4;

Const 
  fin = 0;

Type 
  dias = 1..31;
  meses = 1..12;
  fechas = Record
    d : dias;
    m : meses;
  End;
  prestamo = Record
    ISBN : integer;
    socio : integer;
    date : fechas;
    duracion : integer;
  End;
  prestamo_reducido = Record
    socio : integer;
    date : fechas;
    duracion : integer;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : prestamo_reducido;
    sig : lista;
  End;
  tree3 = ^nodo3;
  tipoArbol3 = Record
    ISBN : integer;
    cant : integer;
  End;
  nodo3 = Record
    dato : tipoArbol3;
    hi : tree3;
    hd : tree3;
  End;
  tipoTree2 = Record
    ISBN : integer;
    listaISBN : lista;
  End;
  tree1 = ^nodoTree1;
  nodoTree1 = Record
    dato : prestamo;
    hi : tree1;
    hd : tree1;
  End;
  tree2 = ^nodoTree2;
  nodoTree2 = Record
    dato : tipoTree2;
    hi : tree2;
    hd : tree2;
  End;
Procedure LeerPrestamo(Var p : prestamo);
Begin
  writeln('Ingresar ISBN: ');
  readln(p.ISBN);
  If (p.ISBN<>0) Then
    Begin
      writeln('Ingresar numero de socio: ');
      readln(p.socio);
      writeln('Ingresar dia del prestamo: ');
      readln(p.date.d);
      writeln('Ingresar mes del prestamo: ');
      readln(p.date.m);
      writeln('Ingresar duracion del prestamo: ');
      readln(p.duracion);
    End;
End;
Procedure Crear_Prestamo_Reducido (p : prestamo; Var pr : prestamo_reducido);
Begin
  pr.socio := p.socio;
  pr.date := p.date;
  pr.duracion := p.duracion;
End;
Procedure AgregarAdelante(Var l : lista; pr : prestamo_reducido);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := pr;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar1(Var t : tree1; p : prestamo);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato := p;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (t^.dato.isbn>p.isbn) Then
         Agregar1(t^.hi,p)
  Else Agregar1(t^.hd,p);
End;
Procedure Agregar2(Var t : tree2; ISBN : integer;pr : prestamo_reducido);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.ISBN := ISBN;
      t^.dato.listaISBN := Nil;
      AgregarAdelante(t^.dato.listaISBN,pr);
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (t^.dato.isbn>isbn) Then
         Agregar2(t^.hi,ISBN,pr)
  Else If (t^.dato.isbn<isbn) Then Agregar2(t^.hd,ISBN,pr)
  Else AgregarAdelante(t^.dato.listaISBN,pr);
End;
Procedure ImprimirArbol(t:tree1);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('CODIGO DE ISBN: ',t^.dato.ISBN);
      writeln('Numero de socio: ',t^.dato.socio);
      writeln('Fecha: ', t^.dato.date.d,'/',t^.dato.date.d);
      writeln('Duracion: ',t^.dato.duracion);
      ImprimirArbol(t^.hd);
    End;
End;

Procedure ImprimirLista(l:lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('Numero de socio: ',l^.dato.socio);
      writeln('Fecha: ', l^.dato.date.d,'/',l^.dato.date.d);
      writeln('Duracion: ',l^.dato.duracion);
      l := l^.sig;
    End;
End;
Procedure ImprimirArbol2(t:tree2);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol2(t^.hi);
      writeln('CODIGO DE ISBN: ',t^.dato.ISBN);
      ImprimirLista(t^.dato.listaISBN);
      ImprimirArbol2(t^.hd);
    End;
End;


Procedure CargarArboles(Var t1 : tree1; Var t2 : tree2);

Var 
  p: prestamo;
  pr: prestamo_reducido;
Begin
  t1 := Nil;
  t2 := Nil;
  LeerPrestamo(p);
  While (p.ISBN <> fin) Do
    Begin
      Crear_Prestamo_Reducido(p,pr);
      Agregar1(t1,p);
      Agregar2(t2,p.ISBN,pr);
      LeerPrestamo(p);
    End;
End;

Function ISBNmaximo(t:tree1) : integer;
Begin
  If (t<>Nil) And (t^.hd <> Nil) Then
    ISBNmaximo := ISBNmaximo(t^.hd)
  Else If (t=Nil) Then ISBNmaximo := 0 //arbol vacio
  Else ISBNmaximo := t^.dato.ISBN;
End;

Function ISBNminimo (t : tree2) : integer;
Begin
  If (t<>Nil) And (t^.hi <> Nil) Then
    ISBNminimo := ISBNminimo(t^.hi)
  Else If (t=Nil) Then ISBNminimo := 0
  Else ISBNminimo := t^.dato.ISBN;
End;

Function cantSocio (t : tree1; n : integer) : integer;
Begin
  If (t=Nil) Then
    cantSocio := 0
  Else If (t^.dato.socio=n) Then
         cantSocio := 1 + cantSocio(t^.hd,n) + cantSocio(t^.hi,n)
  Else cantSocio := cantSocio(t^.hd,n) + cantSocio(t^.hi,n);
End;




{e. Un módulo recursivo que reciba la estructura generada en ii. y un número de
socio. El
módulo debe retornar la cantidad de préstamos realizados a dicho socio.}
Function contarLista(l : lista; n : integer) : integer;

Var 
  aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      If (l^.dato.socio = n) Then
        aux := aux + 1;
      l := l^.sig;
    End;
  contarLista := aux;
End;
Function cantSocio2(t : tree2; n : integer) : integer;

Begin
  If (t=Nil) Then
    cantSocio2 := 0
  Else  cantSocio2 := ContarLista(t^.dato.listaISBN,n) + cantSocio2(t^.hi,n)+
                      cantSocio2(t^.hd,n)

End;








{f. Un módulo que reciba la estructura generada en i. y retorne una nueva estructura
ordenada por ISBN, donde cada ISBN aparezca una vez junto a la cantidad total de veces
que se prestó.}

Procedure Agregar3 (isbn : integer; Var t3 : tree3);
Begin
  If (t3=Nil) Then
    Begin
      new(t3);
      t3^.dato.ISBN := ISBN;
      t3^.dato.cant := 1;
      t3^.hi := Nil;
      t3^.hd := Nil;
    End
  Else
    If (t3^.dato.ISBN<isbn) Then
      Agregar3 (isbn, t3^.hd)
  Else If (t3^.dato.ISBN>isbn) Then
         Agregar3 (isbn, t3^.hi)
  Else t3^.dato.cant := t3^.dato.cant + 1;
End;

Procedure CargarArbol3 (t1 : tree1; Var t3:tree3);
Begin
  If (t1<>Nil) Then
    Begin
      CargarArbol3(t1^.hi,t3);
      Agregar3(t1^.dato.ISBN,t3);
      CargarArbol3(t1^.hd,t3);
    End;
End;

Procedure ImprimirArbol3(t:tree3);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol3(t^.hi);
      writeln('CODIGO DE ISBN: ',t^.dato.ISBN);
      writeln('Cantidad de apariciones del ISBN anterior: ',t^.dato.cant);
      ImprimirArbol3(t^.hd);
    End;
End;


Function contarLista2(l : lista) : integer;

Var 
  aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      aux := aux + 1;
      l := l^.sig;
    End;
  contarLista2 := aux;
End;

Procedure Agregar4(t2 : tree2; Var t4: tree3);
Begin
  If (t4=Nil) Then
    Begin
      new(t4);
      t4^.dato.isbn := t2^.dato.ISBN;
      t4^.hi := Nil;
      t4^.hd := Nil;
      t4^.dato.cant := ContarLista2(t2^.dato.listaISBN);
    End
  Else If (t2^.dato.isbn>=t4^.dato.ISBN) Then
         Agregar4(t2,t4^.hd)
  Else Agregar4(t2,t4^.hi)
End;


Procedure CargarArbol4 ( t2 : tree2; Var t4 : tree3);
Begin
  If (t2<>Nil) Then
    Begin
      CargarArbol4(t2^.hd,t4);
      Agregar4(t2,t4);
      CargarArbol4(t2^.hi,t4)
    End;
End;




{i. Un módulo recursivo que reciba la estructura generada en i. y dos valores de
ISBN. El
módulo debe retornar la cantidad total de préstamos realizados a los ISBN
comprendidos entre los dos valores recibidos (incluidos).}

Function cantEnRango (t:tree1; LimInf,LimSup : integer) : integer;
Begin
  If (t=Nil) Then
    cantEnRango := 0
  Else
    If t^.dato.ISBN<LimInf Then
      cantEnRango := cantEnRango(t^.hd,LimInf,LimSup)
  Else If t^.dato.ISBN> LimSup Then
         cantEnRango := cantEnRango(t^.hi,LimInf,LimSup)
  Else cantEnRango := 1 + cantEnRango(t^.hi,LimInf,LimSup) + cantEnRango(t^.hd,
                      LimInf,LimSup)
End;

Function cantEnRango2 (t:tree2; LimInf,LimSup : integer) : integer;
Begin
  If (t=Nil) Then
    cantEnRango2 := 0
  Else
    If t^.dato.ISBN<LimInf Then
      cantEnRango2 := cantEnRango2(t^.hd,LimInf,LimSup)
  Else If t^.dato.ISBN> LimSup Then
         cantEnRango2 := cantEnRango2(t^.hi,LimInf,LimSup)
  Else cantEnRango2 := ContarLista2(t^.dato.listaISBN) + cantEnRango2(t^.hi,
                       LimInf,LimSup) + cantEnRango2(t^.hd,
                       LimInf,LimSup)
End;



Var 
  t1 : tree1;
  t2 : tree2;
  t3,t4 : tree3;
  n,LimInf,LimSup : integer;
Begin
  CargarArboles(t1,t2);
  If (t1<>Nil) Then
    Begin
      t3 := Nil;
      t4 := Nil;
      writeln('El ISBN mas grande fue: ',ISBNmaximo(t1));
      writeln('El ISBN mas chico fue: ',ISBNminimo(t2));
      write('Ingresar numero de socio a buscar: ');
      readln(n);
      writeln('El socio con numero ',n,' es parte de ',cantSocio(t1,n),
      ' prestamos.');
      writeln('El socio con numero ',n,' es parte de ',cantSocio2(t2,n),
      ' prestamos.');
      writeln('----------------');
      CargarArbol3(t1,t3);
      CargarArbol4(t2,t4);
      ImprimirArbol3(t4);
      writeln('----------------');
      write('Ingresar limite inferior: ');
      readln(LimInf);
      write('Ingresar limite superior: ');
      readln(LimSup);
      writeln(

        'La cantidad total de prestamos realizados de libros entre los codigos '
              ,LimInf,' y ',LimSup,' fue: ',cantEnRango(t1,LimInf,LimSup));
      writeln(


        'La cantidad total de prestamos realizados de libros entre los codigos '
              ,LimInf,' y ',LimSup,' fue: ',cantEnRango2(t2,LimInf,LimSup));

    End
  Else writeln('El arbol esta vacio');
End.
