


{El supermercado Consumo necesita un sistema para procesar la información de sus ventas.
De cada venta se conoce: DNI de cliente, código de sucursal (1 a 10), número de factura y monto.

a) Implementar un módulo que lea información de las ventas (la lectura finaliza al ingresar código de cliente 0) y retorne:

i) Una estructura de datos eficiente para la búsqueda por DNI de cliente. Para cada DNI debe almacenarse una lista de todas sus compras (número de factura y monto).

ii) Una estructura de datos que almacene la cantidad de ventas de cada sucursal.

b) Realizar un módulo que reciba la estructura generada en el inciso a)i, un monto y un DNI.
El módulo debe retornar la cantidad de facturas cuyo monto es inferior al monto ingresado para el DNI ingresado.

c) Realizar un módulo recursivo que reciba la estructura generada en inciso a)ii y un valor entero y retorne si existe o no una sucursal con cantidad de ventas igual al valor recibido.}

Program Examen2025_L;

Const 
  cantSucursales = 10;
  fin = 0;

Type 
  sucursales = 1..cantSucursales;
  venta = Record
    DNI : integer;
    sucursal : sucursales;
    factura : integer;
    monto : real;
  End;
  venta_reducida = Record
    factura : integer;
    monto : real;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : venta_reducida;
    sig : lista;
  End;
  tipoArbol = Record
    listaDNI : lista;
    dni : integer;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
  Contador = array [sucursales] Of integer;


Procedure leerVenta(Var v : venta);
Begin
  write('Ingresar DNI: ');
  readln(v.dni);
  If (v.dni <> fin) Then
    Begin
      write('Ingresar monto: ');
      readln(v.monto);
      write('Ingresar sucursal: ');
      readln(v.sucursal);
      write('Ingresar factura: ');
      readln(v.factura);
    End;
End;


Procedure AgregarAdelante ( Var l : lista; vr : venta_reducida);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := vr;
  aux^.sig := l;
  l := aux;
End;

Procedure CrearRegistro(v : venta; Var vr : venta_reducida);
Begin
  vr.monto := v.monto;
  vr.factura := v.factura;
End;

Procedure Agregar(Var t : tree; v : venta);

Var vr : venta_reducida;
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.listaDNI := Nil;
      t^.dato.dni := v.dni;
      t^.hi := Nil;
      t^.hd := Nil;
      CrearRegistro(v,vr);
      AgregarAdelante(t^.dato.listaDNI,vr);
    End
  Else If (v.dni<t^.dato.dni) Then Agregar(t^.hi,v)
  Else If (v.dni>t^.dato.dni) Then Agregar(t^.hd,v)
  Else
    Begin
      CrearRegistro(v,vr);
      AgregarAdelante(t^.dato.listaDNI,vr);
    End;
End;

Procedure ActualizarContador(sucursal : sucursales;Var v : contador);
Begin
  v[sucursal] := v[sucursal] + 1;
End;

Procedure CargarEstructuras ( Var t : tree; Var v : contador);

Var 
  ven : venta;
Begin
  leerVenta(ven);
  t := Nil;
  While (ven.dni <> fin) Do
    Begin
      Agregar(t,ven);
      ActualizarContador(ven.sucursal,v);
      leerVenta(ven);
    End;
End;

Procedure InicializarVector(Var v : contador);

Var 
  i : integer;
Begin
  For i:=1 To cantSucursales Do
    v[i] := 0;
End;

Procedure ImprimirLista(l : lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('Factura: ',l^.dato.factura);
      writeln('Monto: ', l^.dato.monto:0:2);
      l := l^.sig;
    End;
End;

Procedure ImprimirArbol(t:tree);
Begin
  If (t <> Nil ) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('-----DNI: ',t^.dato.dni);
      ImprimirLista(t^.dato.listaDNI);
      ImprimirArbol(t^.hd);
    End;
End;










{b) Realizar un módulo que reciba la estructura generada en el inciso a)i, un monto y un DNI.
El módulo debe retornar la cantidad de facturas cuyo monto es inferior al monto ingresado para el DNI ingresado.}

Function contarFacturasCumple(l : lista; monto : real) : integer;

Var aux : integer;
Begin
  aux := 0;
  While (l <>Nil) Do
    Begin
      If l^.dato.monto<monto Then
        aux := aux +1;
      l := l^.sig;
    End;
  contarFacturasCumple := aux;
End;


Function cantMenor (t : tree; monto : real; dni : integer) : integer;
Begin
  If (t=Nil) Then
    cantMenor := 0
  Else If (t^.dato.dni<dni) Then cantMenor := cantMenor(t^.hd,monto,dni)
  Else If (t^.dato.dni>dni) Then cantMenor := cantMenor(t^.hi,monto,dni)
  Else cantMenor := contarFacturasCumple(t^.dato.listaDNI,monto);
End;

{c) Realizar un módulo recursivo que reciba la estructura generada en inciso a)ii y un valor entero y retorne si existe o no una sucursal con cantidad de ventas igual al valor recibido.}

Function existe (v : contador; cantVentas,DL : integer) : boolean;

Begin
  If (dl>0) And (v[dl]=cantVentas) Then
    existe := true
  Else existe := existe(v,cantVentas,DL-1);
  If (dl=0) Then existe := false;
End;


Procedure ImprimirVector(v : contador);

Var i : integer;
Begin
  For i:=1 To cantSucursales Do
    writeln('Sucursal ',i,': ',v[i], ' ventas.');
End;

Var 
  t : tree;
  v : contador;
  dni,dl,cantVentas : integer;
  monto : real;

Begin
  randomize;
  DL := 0;
  InicializarVector(v);
  DL := cantSucursales;
  CargarEstructuras(t,v);
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t);
      ImprimirVector(v);
      write('Ingresar dni a buscar: ');
      readln(dni);
      write('Ingresar monto a buscar menores: ');
      readln(monto);
      writeln('La cantidad de facturas del dni ', dni,' con monto menores a ',monto:0:2,' fue: ',cantMenor(t,monto,dni));
      write('Ingresar cantidad de ventas de las que se quiere buscar una sucursal: ');
      readln(cantVentas);
      writeln(existe(v,cantventas,dl));
    End
 Else writeln('ARBOL VACIO');
End.
