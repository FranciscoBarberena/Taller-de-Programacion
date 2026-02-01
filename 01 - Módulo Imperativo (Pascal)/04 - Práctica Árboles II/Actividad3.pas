



{3. Implementar un programa modularizado para una librería. Implementar módulos para:
a. Almacenar los productos vendidos en una estructura eficiente para la búsqueda por
código de producto. De cada producto deben quedar almacenados su código, la
cantidad total de unidades vendidas y el monto total. De cada venta se lee código de
venta, código del producto vendido, cantidad de unidades vendidas y precio unitario. El
ingreso de las ventas finaliza cuando se lee el código de venta -1.
b. Imprimir el contenido del árbol ordenado por código de producto.
c. Retornar el código de producto con mayor cantidad de unidades vendidas.
d. Retornar la cantidad de códigos que existen en el árbol que son menores que un valor
que se recibe como parámetro.
e. Retornar el monto total entre todos los códigos de productos comprendidos entre dos
valores recibidos (sin incluir) como parámetros}

Program Actividad3;

Const 
  fin = -1;

Type 
  ventas = Record
    codeV : integer;
    cant : integer;
    codeP : integer;
    price : real;
  End;
  venta_reducida = Record
    codeP : integer;
    cant : integer;
    monto : real
  End;
  tipoArbol = Record
    codeP : integer;
    cant : integer;
    monto : real;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
Procedure LeerVenta(Var v : ventas);
Begin
  writeln('Ingresar codigo de venta: ');
  readln(v.codeV);
  If (v.Codev <> fin) Then
    Begin
      writeln('Ingresar cantidad de unidades vendidas: ');
      readln(v.cant);
      writeln('Ingresar codigo de producto: ');
      readln(v.codeP);
      write('Ingresar precio unitario: $');
      readln(v.price);
    End;
End;


Procedure CrearRegistro(v:ventas; Var vr:tipoArbol);
Begin
  vr.codeP := v.codeP;
  vr.cant := v.cant;
  vr.monto := v.cant*v.price;
End;


Procedure Agregar(Var t : tree; v : ventas);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      CrearRegistro(v,t^.dato);
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (t^.dato.codeP = v.codeP) Then
         Begin
           t^.dato.cant := t^.dato.cant+v.cant;
           t^.dato.monto := t^.dato.monto+v.cant*v.price;
         End
  Else If (t^.dato.codeP > v.codeP) Then
         Agregar(t^.hi,v)
  Else Agregar(t^.hd,v);
End;
Procedure CargarArbol ( Var t : tree);

Var 
  v : ventas;
Begin
  LeerVenta(v);
  While (v.codeV <> fin) Do
    Begin
      Agregar(t,v);
      LeerVenta(v);
    End;
End;
Procedure ImprimirArbol(t:tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('CODIGO DE PRODUCTO: ',t^.dato.codep);
      writeln('Cantidad total de unidades vendidas: ',t^.dato.cant);
      writeln('Monto total recaudado del producto: ', t^.dato.monto:0:2);
      ImprimirArbol(t^.hd);
    End;
End;
Procedure maximoUnidadesVendidas(t:tree; Var maxCant: integer; Var maxCode :
                                 integer);
Begin
  If (t<>Nil) Then
    Begin
      maximoUnidadesVendidas(t^.hi,maxcant,maxcode);
      If (t^.dato.cant>maxCant) Then
        Begin
          maxcant := t^.dato.cant;
          maxCode := t^.dato.codep
        End;
      maximoUnidadesVendidas(t^.hd,maxcant,maxcode);
    End;
End;


Function MenoresQue(t: tree; n: integer) : integer;
Begin
  If (t=Nil) Then
    MenoresQue := 0
  Else If (t^.dato.codeP>=n) Then
         MenoresQue := MenoresQue(t^.hi,n)
  Else MenoresQue := 1 + MenoresQue(t^.hi,n) + MenoresQue(t^.hd,n);
End;

{e. Retornar el monto total entre todos los códigos de productos comprendidos
entre dos valores recibidos (sin incluir) como parámetros}

Function MontoRango(t: tree; LimInf,LimSup : integer) : real;
Begin
  If (t=Nil) Then
    MontoRango := 0
  Else
    Begin
      If (t^.dato.codeP<=LimInf) Then
        MontoRango := MontoRango(t^.hd,LimInf,LimSup)
      Else If (t^.dato.codeP>=LimSup) Then
             MontoRango := MontoRango(t^.hi,LimInf,LimSup)
      Else MontoRango := t^.dato.monto + MontoRango(t^.hi,LimInf,LimSup) +
                         MontoRango(t^.hd,LimInf,LimSup)
    End;
End;

Var 
  t : tree;
  maxCant,maxCode, n,LimInf,LimSup : integer;
Begin
  MAXCODE := -1;
  maxCANT := 0;
  CargarArbol(t);
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t);
      writeln('Codigo max: ',maxCode,' Cantidad de unidades vendidas: ',maxCant);
      writeln(
 'Ingresar el codigo del que se quieren saber cuantos códigos menores a el hay'
      );
      readln(n);
      writeln('Hay ',MenoresQue(t,n),' codigos menores que ',n);
      writeln('Ingresar rango de codigos a buscar: ');
      readln(LimInf);
      readln(LimSup);
      writeln('$',MontoRango(t,LimInf,LimSup): 0: 2,
                                  ' fue el total recaudado entre esos 2 codigos'
                                                  );

    End
  Else
    writeln('El arbol esta vacio');

End.
