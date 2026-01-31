{ Se leen paquetes. De cada paquete se lee: codigo de envio, DNI del emisor, DNI del receptor, cantidad de objetos en el paquete y peso del paquete}
{a) Realizar un modulo que lea paquetes y retorne un arbol ordenado por peso. La lectura finaliza con CODIGO DE ENVIO 0}

{b) Un modulo que reciba el arbol y 2 valores. Debe retornar una lista con todos los paquetes cuyo peso esta entre ambos valores}

{c) Un modulo que reciba el arbol y retorne toda la informacion del paquete con mayor peso}


Program Examen2025Redictado;

Const 
  fin = 0;

Type 
  paquete = Record
    envio : integer;
    DNIEmisor : integer;
    DNIReceptor : integer;
    cantObjetos : integer;
    peso : real;
  End;
  tree = ^nodo;
  nodo = Record
    dato : paquete;
    hi : tree;
    hd : tree;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : paquete;
    sig : lista;
  End;
Procedure LeerPaquete(Var p : paquete);
Begin
  p.envio := random(100);
  If (p.envio <> fin) Then
    Begin
      p.DNIEmisor := random(5000)+1;
      p.DNIReceptor := random(5000)+1;
      p.cantObjetos := random(5)+1;
      p.peso := random(20000)+500;
    End;
End;

Procedure Agregar(Var t :tree; p : paquete);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato := p;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (p.peso<=t^.dato.peso) Then Agregar(t^.hi,p)
  Else Agregar(t^.hd,p)
End;

Procedure CargarArbol(Var t :tree);

Var 
  p : paquete;
Begin
  t := Nil;
  LeerPaquete(p);
  While (p.envio<>fin) Do
    Begin
      Agregar(t,p);
      LeerPaquete(p);
    End;
End;

Procedure ImprimirArbol(t : tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('Peso: ',t^.dato.peso:0:0,'g');
      writeln('Dni del emisor: ',t^.dato.DNIEmisor);
      writeln('Dni del receptor: ',t^.dato.DNIReceptor);
      writeln('Codigo de envio: ',t^.dato.envio);
      writeln('Cantidad de objetos: ',t^.dato.cantObjetos);
      ImprimirArbol(t^.hd);
    End;
End;
{b) Un modulo que reciba el arbol y 2 valores. Debe retornar una lista con todos los paquetes cuyo peso esta entre ambos valores}

Procedure AgregarAdelante(Var l : lista; p : paquete);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := p;
  aux^.sig := l;
  l := aux;
End;

Procedure listaRango (t : tree; LimInf,LimSup:real; Var l :lista);

Begin
  If (t<>Nil) Then
    Begin
      If (t^.dato.peso<=LimInf) Then listaRango(t^.hd,LimInf,LimSup,l)
      Else If (t^.dato.peso>=LimSup) Then listaRango(t^.hi,LimInf,LimSup,l)
      Else
        Begin
          AgregarAdelante(l,t^.dato);
          listaRango(t^.hi,LimInf,LimSup,l);
          listaRango(t^.hd,LimInf,LimSup,l);
        End;
    End;
End;

Procedure ImprimirLista(l :lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('Peso: ',l^.dato.peso:0:2);
      writeln('Dni del emisor: ',l^.dato.DNIEmisor);
      writeln('Dni del receptor: ',l^.dato.DNIReceptor);
      writeln('Codigo de envio: ',l^.dato.envio);
      writeln('Cantidad de objetos: ',l^.dato.cantObjetos);
      l := l^.sig;
    End;
End;
{c) Un modulo que reciba el arbol y retorne toda la informacion del paquete con mayor peso}

Procedure buscarMax(t : tree; Var p : paquete);
Begin
  If (t<>Nil) Then
    If (t^.hd<>Nil) Then
      buscarMax(t^.hd,p)
  Else p := t^.dato;
End;


Var t : tree;
  l : lista;
  peso1,peso2 : real;
  p : paquete;
Begin
  randomize;
  CargarArbol(t);
  ImprimirArbol(t);
  write('Ingresar limite inferior de peso: ');
  readln(peso1);
  write('Ingresar limite superior de peso: ');
  readln(peso2);
  l := Nil;
  listaRango(t,peso1,peso2,l);
  writeln('Lista de paquetes entre ',peso1:0:0,'g-',peso2:0:0,'g');
  ImprimirLista(l);
  buscarMax(t,p);
  writeln('peso maximo: ',p.peso:0:0,'g');
End.
