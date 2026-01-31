
{. Una agencia dedicada a la venta de autos ha organizado su stock y, tiene la información de
los autos en venta. Implementar un programa que:
a) Genere la información de los autos (patente, año de fabricación (2015..2024), marca,
color y modelo, finalizando con marca ‘MMM’) y los almacene en dos estructuras de
datos:
i. Una estructura eficiente para la búsqueda por patente.
ii. Una estructura eficiente para la búsqueda por marca. Para cada marca se deben
almacenar juntas las patentes y colores de los autos pertenecientes a ella.
b) Invoque a un módulo que reciba la estructura generado en a) i y una marca y retorne la
cantidad de autos de dicha marca que posee la agencia.
c) Invoque a un módulo que reciba la estructura generado en a) ii y una marca y retorne
la cantidad de autos de dicha marca que posee la agencia.
d) Invoque a un módulo que reciba el árbol generado en a) i y retorne una estructura con
la información de los autos agrupados por año de fabricación.
e) Invoque a un módulo que reciba el árbol generado en a) i y una patente y devuelva el
modelo del auto con dicha patente.
f) Invoque a un módulo que reciba el árbol generado en a) ii y una patente y devuelva el
color del auto con dicha patente.}

Program Actividad2;

Const 
  PriAno = 2015;
  UltAno = 2024;
  Fin = 'MMM';
  DF = 10;

Type 
  anos = PriAno..UltAno;
  str10 = string[10];
  str40 = string[40];
  autos = Record
    patente : str10;
    ano : anos;
    marca : str40;
    color : str40;
    modelo : str40;
  End;
  auto_reducido = Record
    patente : str10;
    marca : str40;
    color : str40;
    modelo : str40;
  End;
  lista2 = ^nodoLista2;
  nodoLista2 = Record
    dato : auto_reducido;
    sig : lista2;
  End;
  vector = array [anos] Of lista2;
  tree1 = ^nodo1;
  nodo1 = Record
    dato : autos;
    hi : tree1;
    hd: tree1;
  End;
  lista = ^nodoLista;
  datoLista = Record
    patente : str10;
    color : str40;
  End;
  nodoLista = Record
    dato : datoLista;
    sig : lista;
  End;
  datoArbol2 = Record
    listaMarca : lista;
    marca : str40;
  End;
  tree2 = ^nodo2;
  nodo2 = Record
    dato : datoArbol2;
    hi : tree2;
    hd: tree2;
  End;

Procedure InicializarVector(Var v : vector);

Var 
  i : integer;
Begin
  For i:=PriAno To UltAno Do
    v[i] := Nil;
End;

Procedure LeerAuto(Var a : autos);
Begin
  write('Ingresar marca: ');
  readln(a.marca);
  If (a.marca <> fin) Then
    Begin
      {write('Ingresar anio: ');
      readln(a.ano);}
      write('Ingresar patente: ');
      readln(a.patente);
      write('Ingresar color: ');
      readln(a.color);
      {write('Ingresar modelo: ');
      readln(a.modelo);}
    End;
End;

Procedure Agregar(Var t : tree1; a : autos);
Begin
  If (t= Nil) Then
    Begin
      new (t);
      t^.dato := a;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (a.patente<t^.dato.patente) Then Agregar(t^.hi,a)
  Else Agregar(t^.hd,a);
End;

Procedure AgregarAdelante(Var L : lista; p : str10; c : str40);

Var 
  aux : lista;
Begin
  new(aux);
  aux^.dato.patente := p;
  aux^.dato.color := c;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar2(Var t : tree2; a : autos);
Begin
  If (t= Nil) Then
    Begin
      new (t);
      t^.dato.marca := a.marca;
      t^.dato.listaMarca := Nil;
      AgregarAdelante(t^.dato.listaMarca,a.patente,a.color);
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (a.marca<t^.dato.marca) Then Agregar2(t^.hi,a)
  Else If (a.marca>t^.dato.marca) Then Agregar2(t^.hd,a)
  Else AgregarAdelante(t^.dato.listaMarca,a.patente,a.color);
End;

Procedure CargarArboles ( Var t1 : tree1; Var t2 : tree2);

Var 
  a : autos;
Begin
  t1 := Nil;
  t2 := Nil;
  LeerAuto(a);
  While (a.marca<>fin) Do
    Begin
      Agregar(t1,a);
      Agregar2(t2,a);
      LeerAuto(a);
    End;
End;


{b) Invoque a un módulo que reciba la estructura generado en a) i y una marca y retorne la
cantidad de autos de dicha marca que posee la agencia.}

Function cantidadMarca (t:tree1; marca : str40): integer;
Begin
  If (t=Nil) Then
    cantidadMarca := 0
  Else If (marca = t^.dato.marca) Then
         cantidadMarca := 1 + cantidadMarca (t^.hi,marca) +cantidadMarca (t^.hd,marca)
  Else cantidadMarca := cantidadMarca (t^.hi,marca) + cantidadMarca (t^.hd,marca);
End;

{c) Invoque a un módulo que reciba la estructura generado en a) ii y una marca y
retorne
la cantidad de autos de dicha marca que posee la agencia.}

Function ContarLista(L : lista) : integer;

Var 
  aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      aux := aux +1;
      l := l^.sig;
    End;
  ContarLista := aux;
End;

Function cantidadMarca2(t : tree2; marca : str40): integer;
Begin
  If (t=Nil) Then
    cantidadMarca2 := 0
  Else
    If (marca=t^.dato.marca) Then cantidadMarca2 := ContarLista(t^.dato.
                                                    listaMarca)
  Else If (marca<t^.dato.marca) Then cantidadMarca2 := cantidadMarca2(t^.hi,marca)
  Else cantidadMarca2 := cantidadMarca2(t^.hd,marca)
End;
{d) Invoque a un módulo que reciba el árbol generado en a) i y retorne una estructura con
la información de los autos agrupados por año de fabricación.}

Procedure CrearRegistro(a : autos; Var ar : auto_reducido);
Begin
  ar.color := a.color;
  ar.patente := a.patente;
  ar.marca := a.marca;
  ar.modelo := a.modelo;
End;

Procedure AgregarAdelante2(Var L : lista2; ar : auto_reducido);

Var 
  aux : lista2;
Begin
  new(aux);
  aux^.dato := ar;
  aux^.sig := l;
  l := aux;
End;


Procedure AgruparPorAno (t : tree1; Var v : vector);

Var 
  ar : auto_reducido;
Begin
  If (t<>Nil) Then
    Begin
      AgruparPorAno(t^.hi,v);
      CrearRegistro(t^.dato,ar);
      AgregarAdelante2(v[t^.dato.ano],ar);
      AgruparPorAno(t^.hd,v);
    End;
End;

Procedure ImprimirLista ( l : lista2);
Begin
  While (l<>Nil) Do
    Begin
      writeln('Patente: ',l^.dato.patente);
      writeln('Marca: ',l^.dato.marca);
      writeln('Modelo: ',l^.dato.modelo);
      writeln('Color: ',l^.dato.color);
      l := l^.sig;
      writeln('------------');
    End;
End;

Procedure ImprimirVector(v : vector);

Var 
  i : integer;
Begin
  For i:=PriAno To UltAno Do
    Begin
      If (v[i] = Nil) Then
        writeln('No se cargaron autos del ano ',i)
      Else
        Begin
          writeln('Autos del ano ',i,': ');
          ImprimirLista(v[i]);
        End;
    End;
End;
{e) Invoque a un módulo que reciba el árbol generado en a) i y una patente y devuelva el
modelo del auto con dicha patente.}

Procedure buscarModeloDePatente (t : tree1; patente:str10; Var modelo : str40);
Begin
  If (t=Nil) Then
    modelo := 'No esta la patente'
  Else If (modelo <> 'No esta la patente') Then
         Begin
           If (patente<t^.dato.patente) Then buscarModeloDePatente(t^.hi,patente,modelo)
           Else If (patente>t^.dato.patente) Then buscarModeloDePatente(t^.hd,patente,modelo)
           Else modelo := t^.dato.modelo;
         End;
End;
{f) Invoque a un módulo que reciba el árbol generado en a) ii y una patente y devuelva el
color del auto con dicha patente.}

Procedure buscarEnLista(l : lista; patente : str10; Var color : str40);
Begin
  While (l<>Nil) Do
    Begin
      If (l^.dato.patente = patente) Then
        Begin
          color := l^.dato.color;
          l := Nil;
        End
      Else
        Begin
          l := l^.sig;
          color := 'No esta la patente';
        End;
    End;
End;

Procedure buscarColorDePatente(t:tree2; patente : str10; Var color : str40);
Begin
  If (t<>Nil) Then
    Begin
      buscarColorDePatente(t^.hi,patente,color);
      buscarEnLista(t^.dato.listaMarca,patente,color);
      buscarColorDePatente(t^.hd,patente,color)
    End;
End;

Var 
  t1 : tree1;
  t2: tree2;
  marca,modelo,color : str40;
  patente : str10;
  v: vector;
Begin
  CargarArboles(t1,t2);
  If (t1<> Nil) Then
    Begin
      InicializarVector(v);


{write('Ingresar marca a buscar: ');
      readln(marca);
      writeln('La cantidad de autos de la marca ',marca,' fue ', cantidadMarca(t1,marca));
      writeln('La cantidad de autos de la marca ',marca,' fue ',cantidadMarca2(t2,marca));
      write('Ingresar marca a buscar: ');
      readln(marca);
      AgruparPorAno(t1,v);
      ImprimirVector(v);
      write('Ingresar patente de la que se quiere buscar el modelo: ');
      readln(patente);
      buscarModeloDePatente(t1,patente,modelo);
      If (modelo <>'No esta la patente') Then
        writeln('El modelo del auto con patente ',patente,' es ',modelo)
      Else writeln(modelo);}

      write('Ingresar patente de la que se quiere buscar el color: ');
      readln(patente);
      buscarColorDePatente(t2,patente,color);
      If (color <>'No esta la patente') Then
        writeln('El color del auto con patente ',patente,' es ',color)
      Else writeln(color);

    End
  Else writeln('Error: el arbol esta vacio');
End.
