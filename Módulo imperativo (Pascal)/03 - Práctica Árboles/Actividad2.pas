{Escribir un programa que:
a. Implemente un módulo que genere aleatoriamente información de ventas de un comercio.
Para cada venta generar código de producto, fecha y cantidad de unidades vendidas. Finalizar
con el código de producto 0. Un producto puede estar en más de una venta. Se pide:
i. Generar y retornar un árbol binario de búsqueda de ventas ordenado por código de
producto. Los códigos repetidos van a la derecha.
ii. Generar y retornar otro árbol binario de búsqueda de productos vendidos ordenado por
código de producto. Cada nodo del árbol debe contener el código de producto y la
cantidad total de unidades vendidas.
iii. Generar y retornar otro árbol binario de búsqueda de productos vendidos ordenado por
código de producto. Cada nodo del árbol debe contener el código de producto y la lista de
las ventas realizadas del producto.
Nota: El módulo debe retornar TRES árboles.
b. Implemente un módulo que reciba el árbol generado en i. y una fecha y retorne la cantidad
total de productos vendidos en la fecha recibida.
c. Implemente un módulo que reciba el árbol generado en ii. y retorne el código de producto
con mayor cantidad total de unidades vendidas.
c. Implemente un módulo que reciba el árbol generado en iii. y retorne el código de producto
con mayor cantidad de ventas.}

Program Actividad2;

Const 
  fin = 0;

Type 
  dia = 1..31;
  mes = 1..12;
  ano = 1800..2025;
  fechas = Record
    d : dia;
    m: mes;
    y: ano;
  End;
  maximo = Record
    code : integer;
    cant : integer;
  End;
  venta = Record
    code : integer;
    date : fechas;
    cant : integer;
  End;
  venta_reducida = Record
    code : integer;
    cant: integer;
  End;
  venta_reducida2 = Record
    date : fechas;
    cant: integer;

  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato: venta_reducida2;
    sig : lista;
  End;
  tipo3 = Record
    listaVentas : lista;
    code : integer;
  End;
  arbol = ^nodo;
  nodo = Record
    dato : venta;
    hi : arbol;
    hd : arbol;
  End;
  arbol2 = ^nodo2;
  nodo2 = Record
    dato : venta_reducida;
    hi : arbol2;
    hd : arbol2;
  End;
  arbol3 = ^nodo3;
  nodo3 = Record
    dato : tipo3;
    hi : arbol3;
    hd : arbol3;
  End;
Procedure AgregarAdelante (Var l : lista; v : venta_reducida2);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := v;
  aux^.sig := l;
  l := aux;
End;
Procedure Agregar(Var a : arbol; v : venta);
Begin
  If (a=Nil) Then
    Begin
      new(a);
      a^.dato := v;
      a^.hi := Nil;
      a^.hd := Nil
    End
  Else
    If (v.code>=a^.dato.code) Then Agregar(a^.hd,v)
  Else Agregar(a^.hi,v);
End;
Procedure Agregar2(Var a : arbol2; v : venta_reducida);
Begin
  If (a=Nil) Then
    Begin
      new(a);
      a^.dato := v;
      a^.hi := Nil;
      a^.hd := Nil
    End
  Else If (v.code>a^.dato.code) Then Agregar2(a^.hd,v)
  Else If (v.code<a^.dato.code) Then  Agregar2(a^.hi,v)

  Else a^.dato.cant := a^.dato.cant + v.cant;
End;
Procedure Agregar3 (Var a:arbol3; v : venta_reducida2; code : integer);
Begin
  If (a=Nil) Then
    Begin
      new(a);
      a^.dato.code := code;
      a^.hi := Nil;
      a^.hd := Nil;
      a^.dato.listaVentas := Nil;
      AgregarAdelante(a^.dato.listaVentas,v); //AGREGO A LA LISTA CUANDO ENCUENTRO UN NODO VACIO (EL CODIGO ES NUEVO);
    End
  Else If (code>a^.dato.code) Then Agregar3(a^.hd,v,code) //avanzo
  Else If (code<a^.dato.code) Then Agregar3(a^.hi,v,code)//avanzo
  Else AgregarAdelante(a^.dato.listaVentas,v); //AGREGO A LA LISTA CUANDO ENCUENTRO UN NODO CUYO CODIGO COINCIDE, ES DECIR QUE NO ES LA PRIMERA VENTA REGISTRADA DE ESTE PRODUCTO;

End;

Procedure GenerarVentas (Var v : venta; Var vr : venta_reducida; Var vr2 :
                         venta_reducida2);
Begin
  v.date.d := random(31)+1;
  v.date.m := random(12)+1;
  v.date.y := random(2025-1800)+1800;
  v.cant := random(10000);
  vr.cant := v.cant;
  vr2.cant := v.cant;
  vr2.date := v.date;
End;
Procedure CargarArboles ( Var a : arbol ; Var a2: arbol2 ; Var a3:arbol3);


Var 
  v : venta;
  vr : venta_reducida;
  vr2: venta_reducida2;
Begin

  v.code:=random(200);
  vr.code := v.code;
  While ( v.code <> fin) Do
    Begin
      GenerarVentas(v,vr,vr2);
      Agregar(a,v);
      Agregar2(a2,vr);
      Agregar3(a3,vr2,v.code);
      v.code := random(200);
      vr.code := v.code;

    End;
End;
Procedure ImprimirLista( l : lista; code : integer);
Begin
  writeln('CODIGO: ', code);
  While (l<>Nil) Do
    Begin
      writeln('FECHA: ',l^.dato.date.d,'/',l^.dato.date.m,'/',l^.dato.date.y);
      writeln('Cantidad de cant vendidas en fecha anterior: ',l^.dato.cant);
      L := L^.sig;
    End;
End;
Procedure ImprimirArbol ( a : arbol3);
Begin
  If ( a <> Nil ) Then
    Begin
      ImprimirArbol (a^.HI);

      ImprimirLista(a^.dato.listaVentas,a^.dato.code);
      ImprimirArbol (a^.HD);
    End;
End;



Function esLaMismaFecha(f, f2 : fechas) : boolean;
Begin
  If (f.d=f2.d) And (f.m=f2.m) And (f.y=f2.y) Then
    esLaMismaFecha := true
  Else esLaMismaFecha := false;
End;
Function cantidadEnFecha (a : arbol; f : fechas;c : integer) : integer;
Begin
  If ( a <> Nil ) Then
    Begin
      cantidadEnFecha := cantidadEnFecha (a^.HI,f,c);
      If (esLaMismaFecha(f,a^.dato.date)) Then
        c := c+1;
      cantidadEnFecha := cantidadEnFecha (a^.HD,f,c);
    End
  Else
    cantidadEnFecha := c;
End;





{c. Implemente un módulo que reciba el árbol generado en ii. y retorne el có
digo de producto
con mayor cantidad total de unidades vendidas.}


Procedure LeerFecha(Var fecha : fechas);
Begin
  writeln('Ingresar dia: ');
  readln(fecha.d);
  writeln('Ingresar mes: ');
  readln(fecha.m);
  writeln('Ingresar ano: ');
  readln(fecha.y);
End;
Function ElementosEnLaLista(l : lista) : integer;

Var aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      aux := aux+1;
      l := l^.sig;
    End;
  
  ElementosEnLaLista := aux;
End;
Procedure ActualizarMaximo(Cant_a_Comparar : integer; Var max : maximo; code:
                           integer);
Begin
  If (Cant_a_Comparar>max.cant) Then
    Begin
      max.cant := Cant_a_Comparar;
      max.code := code;
    End;
End;

Function encontrarCodeMaxcant (a:arbol2; max : maximo) : integer;
Begin
  If (a<>Nil) Then
    Begin
      encontrarCodeMaxcant := encontrarCodeMaxcant(a^.hi,max);
      ActualizarMaximo(a^.dato.cant,max,a^.dato.code);
      encontrarCodeMaxcant := encontrarCodeMaxcant(a^.hd,max);
    End
  Else
    encontrarCodeMaxcant := max.code;
End;



{c. Implemente un módulo que reciba el árbol generado en iii. y retorne el có
digo de producto
con mayor cantidad de ventas.}

Function encontrarCodeMaxVentas (a : arbol3; max : maximo) : integer;
Begin
  If (a<>Nil) Then
    Begin
      encontrarCodeMaxVentas := encontrarCodeMaxVentas(a^.hi,max);
      ActualizarMaximo(ElementosEnLaLista(a^.dato.listaVentas),max,a^.dato.code);
      encontrarCodeMaxVentas := encontrarCodeMaxVentas(a^.hd,max);
    End
    else encontrarCodeMaxVentas:=max.code;
End;


Var 
  a : arbol;
  a2 : arbol2;
  a3: arbol3;
  fecha : fechas;
  cantAux : integer;
  max : maximo;
Begin
  max.code := 0;
  max.cant := -1;
  cantAux := 0;
  a := Nil;
  a2 := Nil;
  randomize;
  CargarArboles(a,a2,a3);
  ImprimirArbol(a3);
  LeerFecha(fecha);
  writeln('Cantidad de productos vendidos en ', fecha.d,'/',fecha.m,'/',fecha.y,
         ': ', cantidadEnFecha(a,fecha,cantAux));
  writeln('Codigo del producto con mayor cantidad de unidades vendidas: ',
          encontrarCodeMaxcant(a2,max));
  writeln('Codigo del producto con mayor cantidad de ventas realizadas: ',encontrarCodeMaxVentas(a3,max));

End.
