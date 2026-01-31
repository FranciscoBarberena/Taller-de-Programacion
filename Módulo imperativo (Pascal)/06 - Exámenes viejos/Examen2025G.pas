


{se lee información de libros. Implementar un programa que
a) almacene la información de los libros en una estructura eficiente para la búsqueda por código de autor. En cada nodo se almacena el código de autor y una lista con los libros de cada autor, donde en cada nodo se almacena el isbn y el género. de cada libro se lee código de autor, isbn y género [1..15]. El ingreso de datos finaliza con el isbn 0
b) realice  un módulo que reciba la estructura generada en a), un código de autor y un género y devuelva una lista donde se almacene en cada nodo código de autor y la cantidad de libros que escribió del género pasado como parámetro, de los autores cuyos códigos sean mayores al código pasado por parámetro
c) realice un módulo recursiva que reciba la lista creada en b) y devuelva la cantidad y el código del autor que más libros escribió}

Program Examen2025G;

Const 
  cantGeneros = 3;
  fin = 0;

Type 
  generos = 1..cantGeneros;
  libro = Record
    ISBN : integer;
    autor : integer;
    gen : generos;
  End;
  libro_reducido = Record
    ISBN : integer;
    gen : generos;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : libro_reducido;
    sig : lista;
  End;
  tipoLista2 = Record
    autor : integer;
    cant : integer;
  End;
  lista2 = ^nodoLista2;
  nodoLista2 = Record
    dato : tipoLista2;
    sig : lista2;
  End;

  tipoArbol = Record
    listaAutor : lista;
    autor : integer;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;

Procedure LeerLibro(Var l : libro);
Begin
  l.isbn := random(120);
  If (l.isbn<>fin) Then
    Begin
      l.autor := random(100)+1;
      l.gen := random(cantGeneros)+1;
    End;
End;

Procedure CrearRegistro(l : libro; Var lr : libro_reducido);
Begin
  lr.gen := l.gen;
  lr.isbn := l.isbn;
End;

Procedure AgregarAdelante(Var l : lista; lr : libro_reducido);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := lr;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar(l : libro; Var t : tree);

Var lr : libro_reducido;
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.autor := l.autor;
      t^.dato.listaAutor := Nil;
      CrearRegistro(l,lr);
      AgregarAdelante(t^.dato.listaAutor,lr);
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (l.autor<t^.dato.autor) Then Agregar(l,t^.hi)
  Else If (l.autor>t^.dato.autor) Then Agregar(l,t^.hd)
  Else
    Begin
      CrearRegistro(l,lr);
      AgregarAdelante(t^.dato.listaAutor,lr);
    End;
End;

Procedure ImprimirLista(l :lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('ISBN: ',l^.dato.isbn);
      writeln('Genero: ', l^.dato.gen);
      l := l^.sig;
    End;
End;

Procedure ImprimirArbol(t : tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('CODIGO DE AUTOR: ',t^.dato.autor);
      ImprimirLista(t^.dato.listaAutor);
      ImprimirArbol(t^.hd);
    End;
End;
Procedure ImprimirLista2(l :lista2; gen : generos);
Begin
  While (l<>Nil) Do
    Begin
      writeln('AUTOR: ',l^.dato.autor);
      writeln('Cantidad de libros escritos del genero ',gen,': ', l^.dato.cant);
      l := l^.sig;
    End;
End;











{b) realice  un módulo que reciba la estructura generada en a), un código de autor y un género y devuelva una lista donde se almacene en cada nodo código de autor y la cantidad de libros que
escribió del género pasado como parámetro, de los autores cuyos códigos sean mayores al código pasado por parámetro}


Function contarLista(l : lista; autor : integer; genero : generos) : integer;

Var aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      If (l^.dato.gen = genero) Then
        aux := aux +1;
      l := l^.sig;
    End;
  contarLista := aux;
End;

Procedure AgregarAdelante2(Var l : lista2; tl : tipoLista2);

Var aux : lista2;
Begin
  new(aux);
  aux^.dato := tl;
  aux^.sig := l;
  l := aux;
End;

Procedure armarLista(t : tree; autor : integer; genero : generos; Var l : lista2);

Var 
  tL : tipoLista2;
Begin
  If (t<>Nil) Then
    Begin
      If (autor<t^.dato.autor) Then armarLista(t^.hi,autor,genero,l)
      Else If (autor>t^.dato.autor) Then
             Begin
               armarLista(t^.hi,autor,genero,l);
               tl.autor := t^.dato.autor;
               tl.cant := contarLista(t^.dato.listaAutor,tl.autor,genero);
               AgregarAdelante2(l,tl);
               armarLista(t^.hd,autor,genero,l);
             End
      Else
        Begin
          tl.autor := t^.dato.autor;
          tl.cant := contarLista(t^.dato.listaAutor,tl.autor,genero);
          AgregarAdelante2(l,tl);
          armarLista(t^.hi,autor,genero,l);
        End;
    End;
End;
{c) realice un módulo recursiva que reciba la lista creada en b) y devuelva la cantidad y el código del autor que más libros escribió}

Procedure EncontrarMaxLista(l : lista2; Var maxAutor,maxCant : integer);
Begin
  If (l<>Nil) Then
    Begin
      If (l^.dato.cant>maxCant) Then
        Begin
          maxAutor := l^.dato.autor;
          maxCant := l^.dato.cant;
        End;
      EncontrarMaxLista(l^.sig,maxAutor,maxCant);
    End;
End;

Procedure CargarArbol(Var t : tree);

Var 
  l : libro;
Begin
  t := Nil;
  LeerLibro(l);
  While (l.isbn <> fin) Do
    Begin
      Agregar(l,t);
      LeerLibro(l);
    End;
End;

Var 
  t : tree;
  gen : generos;
  autor,maxAutor,maxCant : integer;
  l : lista2;
Begin
  CargarArbol(t);

  If (t<>Nil) Then
    Begin
      l := Nil;
      maxCant := 0;
      maxAutor := 0;
      ImprimirArbol(t);
      write('Ingresar genero a buscar: ');
      readln(gen);
      write('Ingresar autor del que se quieren buscar codigos menores a el: ');
      readln(autor);
      armarLista(t,autor,gen,l);
      ImprimirLista2(l,gen);
      EncontrarMaxLista(l,maxAutor,maxCant);
      writeln('El autor que mas libros escribio de la lista fue el ',maxAutor,' con ',maxCant,' libros.');
    End
  Else writeln('ARBOL VACIO.');
End.
