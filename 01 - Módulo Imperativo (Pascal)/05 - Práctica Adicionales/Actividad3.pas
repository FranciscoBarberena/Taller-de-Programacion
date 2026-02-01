
{Implementar un módulo que lea compras de videojuegos. De cada compra se lee
código del videojuego, código de cliente y mes. La lectura finaliza con el código de
cliente 0. Se sugiere utilizar el módulo leerCompra(). El módulo debe retornar un árbol
binario de búsqueda ordenado por código de videojuego. En el árbol, para cada código
de videojuego debe almacenarse una lista con código de cliente y mes perteneciente a
cada compra.
b) Implementar un módulo que reciba el árbol generado en a) y un código de videojuego.
El módulo debe retornar la lista de las compras de ese videojuego.
c) Implementar un módulo recursivo que reciba la lista generada en b) y un mes. El
módulo debe retorne la cantidad de clientes que compraron en el mes ingresado.
NOTA: Implementar el programa principal, que invoque a los incisos a, b y c.}

Program Actividad3;

Const 
  fin = 0;

Type 
  compra = Record
    cod_videojuego : integer;
    cod_cliente : integer;
    mes : integer;
  End;
  tipoLista = Record
    codigo : integer;
    mes : integer;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : tipoLista;
    sig : lista;
  End;
  tipoArbol = Record
    codigo : integer;
    listaCodVid : lista;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
Procedure LeerCompra(Var c : compra);
Begin
  c.cod_cliente := random(200);
  If (c.cod_cliente<>fin) Then
    Begin
      c.mes := random(12)+1;
      c.cod_videojuego := random(200)+1000;
    End;
End;

Procedure AgregarAdelante(Var l : lista; cod, mes : integer);

Var 
  aux : lista;
Begin
  new(aux);
  aux^.dato.codigo := cod;
  aux^.dato.mes := mes;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar(Var t : tree; c : compra);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.codigo := c.cod_videojuego;
      t^.dato.listaCodVid := Nil;
      AgregarAdelante(t^.dato.listaCodVid,c.cod_cliente,c.mes)
    End
  Else If (c.cod_videojuego<t^.dato.codigo) Then
         Agregar(t^.hi,c)
  Else If (c.cod_videojuego>t^.dato.codigo) Then
         Agregar(t^.hd,c)
  Else AgregarAdelante(t^.dato.listaCodVid,c.cod_cliente,c.mes);
End;


Procedure CargarArbol(Var t : tree);

Var 
  c : compra;
Begin
  t := Nil;
  LeerCompra(c);
  While (c.cod_cliente<>fin) Do
    Begin
      Agregar(t,c);
      LeerCompra(c);
    End;
End;
Procedure ImprimirLista(l:lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('Codigo de cliente: ',l^.dato.codigo);
      writeln('Mes: ',l^.dato.mes);
      l := l^.sig;
    End;
End;
Procedure EncontrarLista(t:tree; Var l : lista; codigo : integer;Var encontre : boolean);
Begin
  If (t=Nil) Then
    l := Nil
  Else If (Not encontre) Then
         Begin
           If (codigo<t^.dato.codigo) Then EncontrarLista(t^.hi,l,codigo,encontre)
           Else If (codigo>t^.dato.codigo) Then EncontrarLista(t^.hd,l,codigo,encontre)
           Else
             Begin
               l := t^.dato.listaCodVid;
               encontre := true;
             End;
         End;
End;
Procedure ImprimirArbol(t:tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('Codigo: ',t^.dato.codigo);
      ImprimirLista(t^.dato.listaCodVid);
      ImprimirArbol(t^.hd);
    End;
End;
Function cantClientesMes (l : lista; mes : integer) : integer;
Begin
  If (l=Nil) Then cantClientesMes := 0
  Else If (l^.dato.mes = mes) Then cantClientesMes := 1 + cantClientesMes(l^.sig,mes)
  Else cantClientesMes := cantClientesMes(l^.sig,mes);
End;

Var 
  t : tree;
  encontre: boolean;
  l : lista;
  codigo,mes : integer;
Begin
  CargarArbol(t);
  ImprimirArbol(t);
  write('Ingresar codigo a buscar: ');
  readln(codigo);
  encontre := false;
  EncontrarLista(t,l,codigo,encontre);
  ImprimirLista(l);
  write('Ingresar mes a buscar: ');
  readln(mes);
  writeln('La cantidad de clientes en el mes ',mes,' fue: ',cantClientesMes(l,mes));
End.
