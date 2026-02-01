

























{La Feria del Libro necesita un sistema para obtener estadísticas sobre los libros
presentados.
a) Implementar un módulo que lea información de los libros. De cada libro se conoce:
ISBN, código del autor y código del género (1: literario, 2: filosofía, 3: biología, 4: arte,
5: computación, 6: medicina, 7: ingeniería) . La lectura finaliza con el valor 0 para el
ISBN. Se sugiere utilizar el módulo leerLibro(). El módulo deber retornar dos
estructuras:
i. Un árbol binario de búsqueda ordenado por código de autor. Para cada código de autor
debe almacenarse la cantidad de libros correspondientes al código.
ii. Un vector que almacene para cada género, el código del género y la cantidad de libros del
género.
b) Implementar un módulo que reciba el vector generado en a), lo ordene por cantidad
de libros de mayor a menor y retorne el nombre de género con mayor cantidad
cantidad de libros.
c) Implementar un módulo que reciba el árbol generado en a) y dos códigos. El módulo
debe retornar la cantidad total de libros correspondientes a los códigos de autores
entre los dos códigos ingresados (incluidos ambos).
NOTA: Implementar el programa principal, que invoque a los incisos a, b y c.}

Program Actividad4;

Const 
  fin = 0;

Type 
  subGenero = 1..7;
  libro = Record
    isbn : integer;
    code : integer;
    genero : subGenero;
  End;
  tipoArbol = Record
    code : integer;
    cant : integer;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
  vector = array[subgenero] Of tipoArbol;


Var v: array [1..7] Of string = ('literario', 'filosofía', 'arte', 'biología', 'computación', 'medicina',
                                 'ingeniería');

Procedure leerLibro (Var l : libro);
Begin
  l.isbn := Random(1000);
  If (l.isbn <> fin) Then
    Begin
      l.code := Random(300) + 100;
      l.genero := Random(7) + 1;
    End;
End;

Procedure Agregar (Var t :tree; l : libro);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.code := l.code;
      t^.dato.cant := 1;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (l.code<t^.dato.code) Then Agregar(t^.hi,l)
  Else If (l.code>t^.dato.code) Then Agregar(t^.hd,l)
  Else t^.dato.cant := t^.dato.cant + 1;
End;

Procedure InicializarVector(Var vec : vector);

Var 
  i : integer;
Begin
  For i:=1 To 7 Do
    Begin
      vec[i].code := i;
      vec[i].cant := 0;
    End;
End;

Procedure ActualizarVector(Var vec : vector; l : libro);
Begin
  vec[l.genero].cant := vec[l.genero].cant+1;
End;

Procedure CargarEstructuras ( Var t : tree; Var vec : vector);

Var l : libro;
Begin
  t := Nil;
  InicializarVector(vec);
  leerLibro(l);
  While (l.isbn<>fin) Do
    Begin
      Agregar(t,l);
      ActualizarVector(vec,l);
      leerLibro(l);
    End;
End;

Procedure ImprimirArbol(t:tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('Codigo de autor: ',t^.dato.code);
      writeln('Cantidad de libros de dicho codigo: ',t^.dato.cant);
      ImprimirArbol(t^.hd);
    End;
End;
{b) Implementar un módulo que reciba el vector generado en a), lo ordene por cantidad
de libros de mayor a menor y retorne el nombre de género con mayor cantidad
cantidad de libros.}

Procedure OrdenarVector(Var vec : vector; Var generoMax : String);

Var 
  i,j,pos : integer;
  elem: tipoArbol;
Begin
  For i:=1 To 7-1 Do
    Begin
      pos := i;
      For j:=i+1 To 7 Do
        If (vec[j].cant>vec[pos].cant) Then
          pos := j;
      elem := vec[pos];
      vec[pos] := vec[i];
      vec[i] := elem;
    End;
  generoMax := v[vec[1].code];
End;

Procedure ImprimirVector(vec : vector);

Var i : integer;
Begin
  For i:=1 To 7 Do
    Begin
      writeln('Genero: ',vec[i].code);
      writeln('Cant: ',vec[i].cant);
    End;
End;




{c) Implementar un módulo que reciba el árbol generado en a) y dos códigos. El módulo
debe retornar la cantidad total de libros correspondientes a los códigos de autores
entre los dos códigos ingresados (incluidos ambos).
NOTA: Implementar el programa principal, que invoque a los incisos a, b y c.
}

Function cantidadRango (t : tree; LimInf,Limsup : integer) : integer;
Begin
  If (t=Nil) Then
    cantidadRango := 0
  Else If (LimInf>t^.dato.code) Then cantidadRango := cantidadRango(t^.hd,LimInf,LimSup)
  Else If (LimSup<t^.dato.code) Then cantidadRango := cantidadRango(t^.hi,LimInf,LimSup)
  Else cantidadRango := t^.dato.cant + cantidadRango(t^.hi,LimInf,LimSup) + cantidadRango(t^.hd,LimInf,LimSup)
End;

Var 
  t : tree;
  vec : vector;
  gen : string;
  LimInf,LimSup : integer;
Begin
  randomize;
  CargarEstructuras(t,vec);
  If (t<> Nil) Then
    Begin
      ImprimirArbol(t);
      OrdenarVector(vec,gen);
      ImprimirVector(vec);
      writeln('El genero max fue: ',gen);
      writeln('Ingresar limites del rango a buscar: ');
      readln(LimInf);
      readln(LimSup);
      writeln('La cantidad de libros entre los codigos de autor ',LimInf,' y ', LimSup,' fue: ',cantidadRango(t,LimInf,LimSup));
    End
  Else writeln('Error: arbol vacio');
End.
