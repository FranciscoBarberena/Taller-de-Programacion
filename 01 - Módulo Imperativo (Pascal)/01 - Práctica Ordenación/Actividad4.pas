
{Una librería requiere el procesamiento de la información de sus productos. De cada
producto se conoce el código del producto, código de rubro (del 1 al 6) y precio.
Implementar un programa que invoque a módulos para cada uno de los siguientes puntos:
a. Lea los datos de los productos y los almacene ordenados por código de producto y
agrupados por rubro, en una estructura de datos adecuada. El ingreso de los productos finaliza
cuando se lee el precio -1.
b. Una vez almacenados, muestre los códigos de los productos pertenecientes a cada rubro.
c. Genere un vector (de a lo sumo 20 elementos) con los productos del rubro 3. Considerar que
puede haber más o menos de 20 productos del rubro 3. Si la cantidad de productos del rubro 3
es mayor a 20, almacenar los primeros 30 que están en la lista e ignore el resto.
d. Ordene, por precio, los elementos del vector generado en c) utilizando alguno de los dos
métodos vistos en la teoría.
e. Muestre los precios del vector resultante del punto d).
f. Calcule el promedio de los precios del vector resultante del punto d).}

Program Actividad4;

Const 
  cantRubros = 6;
  fin = -1;
  DF = 20;

Type 
  rubros = 1..cantRubros;
  producto = Record
    code : integer;
    rub : rubros;
    price : real;
  End;
  lista = ^nodo;
  nodo = Record
    dato : producto;
    sig : lista;
  End;
  listas = array [rubros] Of lista;
  vector20 = array[1..DF] Of producto;
Procedure InsertarOrdenado (Var l : lista; p : producto);

Var 
  act, ant, aux : lista;
Begin
  new(aux);
  aux^.dato := p;
  act := l;
  ant := l;
  While (act<>Nil) And (act^.dato.code < p.code) Do
    Begin
      ant := act;
      act := act^.sig;
    End;
  If (act = ant) Then
    l := aux
  Else
    ant^.sig := aux;
  aux^.sig := act;
End;
Procedure LeerProducto(Var p : producto);
Begin
  writeln('Ingrese el precio: ');
  readln(p.price);
  If (p.price <> fin) Then
    Begin
      writeln('Ingrese el codigo: ');
      readln(p.code);
      writeln('Ingrese el rubro: ');
      readln(p.rub);
    End;
End;
Procedure InicializarListas ( Var v : listas);

Var i : integer;
Begin
  For i:=1 To cantRubros Do
    v[i] := Nil;
End;
Procedure CargarLista (Var v : listas);

Var 
  p : producto;
Begin
  InicializarListas(v);
  LeerProducto(p);
  While (p.price <> fin) Do
    Begin
      InsertarOrdenado (v[p.rub], p);
      LeerProducto(p);
    End;
End;
Procedure ImprimirListas ( v : listas);

Var 
  i : integer;
Begin
  For i:=1 To cantRubros Do
    Begin
      While v[i] <>Nil Do
        Begin
          writeln('Rubro ',i,': ',v[i]^.dato.code);
          v[i] := v[i]^.sig;
        End;
    End;
End;

Procedure GenerarVector (Var v : vector20; l : lista; Var dl : integer);

Begin
  dl := 0;
  While (l <> Nil) And (dl<DF) Do
    Begin
      dl := dl +1;
      v[dl] := l^.dato;
      l := l^.sig;
    End;
End;

Procedure OrdenarVector (Var v : vector20; dl : integer);

Var 
  i,j,pos : integer;
  elementoVector : producto;
Begin
  For i:=1 To DL-1 Do
    Begin
      pos := i;
      For j:=i+1 To dl Do
        If v[j].price<v[pos].price Then
          pos := j;
      elementoVector := v[pos];
      v[pos] := v[i];
      v[i] := elementoVector;
    End;
End;

Procedure imprimirVector (v:vector20; dl : integer);

Var i: integer;
Begin
  For i:=1 To dl Do
    writeln('Producto ',i,': $',v[i].price);
End;

Function promedio (v:vector20; dl : integer) : real;

Var i : integer;
  suma : real;
Begin

  suma := 0;
  For i:=1 To dl Do
    Begin
      suma := suma + v[i].price;
    End;
  promedio := suma/dl;
End;

Var 
  v : vector20;
  l : listas;
  dl : integer;
Begin
  CargarLista(l);
  ImprimirListas(l);
  GenerarVector( v,l[3],dl);
  OrdenarVector(v,DL);
  imprimirVector(v,dl);
  If (dl<>0) Then
    writeln('El promedio fue: ',promedio(v,dl))
  Else writeln('No se ingresaron datos del rubro 3.');
End.
