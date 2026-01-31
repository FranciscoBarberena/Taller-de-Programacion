














{a) leer compras, de cada compra se lee codigo de producto, codigo de cliente, dia y mes. La  lectura finaliza con codigo de cliente 0. El modulo debe retornar
un vector donde se almacenen las compras agrupadas por mes. Las compras de cada mes se almacenan en un arbol ordenado por codigo de producto}

{b) implementar un modulo recursivo que reciba el vector generado en a) y retorne el mes con mayor cantidad de compras}

{c) Implementar un modulo que reciba el vector generado en a), un mes y un codigo de producto. Debe retornar si el producto fue comprado en el mes recibido }

Program Examen2025_O;

Const 
  fin = 0;
  cantMeses = 12;
  cantDias = 31;

Type 
  meses = 1..cantMeses;
  dias = 1..cantDias;
  fechas = Record
    mes : meses;
    dia : dias;
  End;
  compra = Record
    producto : integer;
    cliente : integer;
    date : fechas;
  End;
  compra_reducida = Record
    producto : integer;
    cliente : integer;
    dia : dias;
  End;
  tree = ^nodo;
  nodo = Record
    dato : compra_reducida;
    hi : tree;
    hd : tree;
  End;
  vector = array [meses] Of tree;
Procedure leerCompra ( Var c : compra);
Begin
  c.cliente := random(100);
  If (c.cliente <> fin) Then
    Begin
      c.producto := random(1000);
      c.date.dia := random(cantDias)+1;
      c.date.mes := random(cantMeses)+1;
    End;
End;

Procedure InicializarVector(Var v : vector; Var DL : integer);

Var 
  i : integer;
Begin
  For i:=1 To cantMeses Do
    v[i] := Nil;
  dl := cantMeses;

End;

Procedure CrearRegistro(c :compra; Var cr : compra_reducida);
Begin
  cr.dia := c.date.dia;
  cr.cliente := c.cliente;
  cr.producto := c.producto;
End;

Procedure Agregar (Var t : tree; cr : compra_reducida);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato := cr;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (cr.producto<t^.dato.producto) Then Agregar(t^.hi,cr)
  Else  Agregar(t^.hd,cr) // repetidos a la derecha
End;

Procedure CargarVector (Var v : vector; Var DL :  integer);

Var 
  c : compra;
  cr : compra_reducida;
Begin
  InicializarVector(v,DL);
  leerCompra(c);
  While (c.cliente <> fin) Do
    Begin
      CrearRegistro(c,cr);
      Agregar(v[c.date.mes],cr);
      leerCompra(c);
    End;
End;

Procedure ImprimirArbol(t : tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('Producto: ',t^.dato.producto);
      writeln('Dia: ', t^.dato.dia);
      writeln('Cliente: ',t^.dato.cliente);
      ImprimirArbol(t^.hd);
    End;
End;
Procedure ImprimirVector(v : vector);

Var i : integer;
Begin
  For i:=1 To cantMeses Do
    Begin
      writeln('------MES ',i,'--------');
      ImprimirArbol(v[i]);
    End;
End;


Function contarCompras(t : tree) : integer;
Begin
  If (t=Nil) Then
    contarCompras := 0
  Else contarCompras := 1 + contarCompras(t^.hi) + contarCompras(t^.hd);
End;

{Procedure mayorMes(v : vector; DL : integer; Var maxMes,maxCant : integer);
Begin
  If (DL>0) Then
    Begin
      If (contarCompras(v[dl]) > maxCant) Then
        Begin
          maxCant := contarCompras(v[dl]);
          maxMes := DL;
        End;
      mayorMes(v,DL-1,maxMes,maxCant);
    End;
End;

Function  mayorMess(v : vector; DL : integer;  maxMes,maxCant : integer) : integer;
Begin
  If (DL>0) Then
    Begin
      If (contarCompras(v[dl]) > maxCant) Then
        Begin
          maxCant := contarCompras(v[dl]);
          maxMes := DL;
        End;
      mayorMess := mayorMess(v,DL-1,maxMes,maxCant);
    End
  Else mayorMess := maxMes;
End;}

{b) implementar un modulo recursivo que reciba el vector generado en a) y retorne el mes con mayor cantidad de compras}

Function ultMayorMes (v:vector;dl : integer) : integer;

Var mes_anterior : integer;
Begin
  If (dl=1)Then
    ultMayorMes := 1 
  Else
    Begin
      mes_anterior := ultMayorMes(v,dl-1);
      If (contarCompras(v[dl])>contarCompras(v[mes_anterior])) Then
        ultMayorMes := dl
      Else ultMayorMes := mes_anterior;

    End;
End;


{c) Implementar un modulo que reciba el vector generado en a), un mes y un codigo de producto. Debe retornar si el producto fue comprado en el mes recibido }

Function RevisarArbol(t : tree; producto: integer) : boolean;
Begin
  If (t=Nil) Then
    RevisarArbol := false
  Else
    Begin
      If (producto<t^.dato.producto) Then RevisarArbol := RevisarArbol(t^.hi,producto)
      Else If (producto>t^.dato.producto) Then RevisarArbol := RevisarArbol(t^.hd,producto)
      Else RevisarArbol := true;
    End;
End;

Function RevisarVector (v : vector; mes : meses; producto : integer) : boolean;

Var 
  t : tree;
Begin
  t := v[mes];
  RevisarVector := RevisarArbol(t,producto);
End;

Var 
  v : vector;
  DL : integer;
  maxMes,maxCant : integer;
  mes : meses;
  producto : integer;
Begin
  randomize;
  maxMes := 0;
  maxCant := 0;
  CargarVector(v,DL);
  ImprimirVector(v);
  mayorMes(v,dl,maxMes,maxCant);
  writeln('El mes con  mayor cantidad de compras fue ',maxMes,' con: ',maxCant,' compras.');
  maxcant := 0;
  maxMes := 0;
  writeln('NUEVOO: ',ultMayorMes(v,dl));
  writeln('FUNCION El mes con  mayor cantidad de compras fue ',mayorMess(v,dl,maxMes,maxCant),' con: ',maxCant,' compras.');
  write('Ingresar mes a buscar: ');
  readln(mes);
  write('Ingresar producto a buscar: ');
  readln(producto);
  writeln('El producto ',producto,' fue comprado en el mes ',mes,'? ', RevisarVector(v,mes,producto));
End.
