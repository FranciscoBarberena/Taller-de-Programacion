
{La oficina de presupuesto nacional está analizando las partidas de dinero enviadas a las 24 provincias en los últimos años.

1.- Realice un módulo que lea la información de las partidas de dinero y las almacene en una estructura de datos eficiente para la búsqueda por año.
De cada partida se lee el mes y año, código de provincia (entre 1 y 24) y monto enviado a dicha provincia en ese mes y año.
La información, para cada año, debe quedar almacenada de manera ordenada ascendentemente por mes.
La información se ingresa sin ningún orden.
La lectura finaliza cuando se lee la partida enviada a la provincia 24 en el mes 12 y año 2022.
Se sugiere utilizar el módulo leerPartida().

2.- Realice un módulo que reciba la estructura de datos generada en el inciso 1 y retorne una nueva estructura de datos que contenga, para cada provincia, la cantidad total de partidas recibidas y el monto total.
9:25
3.- Realice un módulo recursivo que reciba la estructura generada en el inciso 2 y retorne el código de la provincia con mayor cantidad de partidas recibidas.

4.- Realice un módulo que reciba la estructura de datos generada en 1, dos años y un mes, y retorne la cantidad total de partidas enviadas a las distintas provincias en el mes entre dichos años.}

Program Examen2023RecuperatorioT2;

Const 
  finMes = 12;
  finAno = 2022;
  finProv = 24;

Type 
  meses = 1..12;
  provincias = 1..24;
  partida = Record
    mes : meses;
    ano : integer;
    provincia : provincias;
    monto : real;
  End;
  partida_reducida = Record
    mes : meses;
    provincia : provincias;
    monto : real;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : partida_reducida;
    sig : lista;
  End;
  tipoArbol = Record
    listaAno : lista;
    ano : integer;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
  provinciaResumen = Record
    cant : integer;
    monto : real;
  End;
  contador = array[provincias] Of provinciaResumen;
Procedure leerPartida(Var p : partida);
Begin
  p.mes := random(12)+1;
  p.ano := random(2022-2010)+2011;
  p.provincia := random(24)+1;
  If (p.mes <>finMes) Or (p.ano <> finAno) Or (p.provincia<> finProv) Then
    p.monto := random(10000)+1000;
End;

Procedure CrearRegistro (p : partida; Var pr : partida_reducida);
Begin
  pr.mes := p.mes;
  pr.provincia := p.provincia;
  pr.monto := p.monto;
End;

Procedure InsertarOrdenado(Var l : lista; pr : partida_reducida);

Var 
  aux,ant,act : lista;
Begin
  new(aux);
  aux^.dato := pr;
  act := l;
  While (act<>Nil) And (act^.dato.mes  < pr.mes) Do
    Begin
      ant := act;
      act := act^.sig;
    End;
  If (act=L) Then
    l := aux
  Else ant^.sig := aux;
  aux^.sig := act;
End;

Procedure Agregar(Var t : tree; p : partida);

Var 
  pr : partida_reducida;
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.ano := p.ano;
      t^.dato.listaAno := Nil;
      CrearRegistro(p,pr);
      InsertarOrdenado(t^.dato.listaAno,pr);
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (p.ano<t^.dato.ano) Then Agregar(t^.hi,p)
  Else If (p.ano>t^.dato.ano) Then Agregar(t^.hd,p)
  Else
    Begin
      CrearRegistro(p,pr);
      InsertarOrdenado(t^.dato.listaAno,pr);
    End;
End;

Procedure CargarArbol(Var t :tree);

Var 
  p : partida;
Begin
  t := Nil;
  leerPartida(p);
  While (p.mes <>finMes) Or (p.ano <> finAno) Or (p.provincia<> finProv) Do
    Begin
      Agregar(t,p);
      leerPartida(p);
    End;
End;

Procedure ImprimirLista(l : lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('MES: ',l^.dato.mes);
      writeln('monto: ',l^.dato.monto:0:2);
      writeln('Provincia: ',l^.dato.provincia);
      l := l^.sig;
    End;
End;

Procedure ImprimirArbol ( t :tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('-----------ANO-------------');
      writeln('-----------',t^.dato.ano,'-------------');
      ImprimirLista(t^.dato.listaAno);
      ImprimirArbol(t^.hd);
    End;
End;

Procedure InicializarContador(Var vc : contador);

Var 
  i : integer;
Begin
  For i:=1 To 24 Do
    Begin
      vc[i].cant := 0;
      vc[i].monto := 0;
    End;
End;



{2.- Realice un módulo que reciba la estructura de datos generada en el inciso 1 y retorne una nueva estructura de datos que contenga, para cada provincia, la cantidad total de partidas recibidas y el
monto total.}
Procedure ActualizarVector(l : lista; Var vc : contador);
Begin
  While (l<>Nil) Do
    Begin
      vc[l^.dato.provincia].cant := vc[l^.dato.provincia].cant + 1;
      vc[l^.dato.provincia].monto := vc[l^.dato.provincia].monto + l^.dato.monto;
      l := l^.sig;
    End;
End;

Procedure contarProvincias (t : tree; Var vc : contador);
Begin
  If (t<>Nil) Then
    Begin
      contarProvincias(t^.hi,vc);
      ActualizarVector(t^.dato.listaAno,vc);
      contarProvincias(t^.hd,vc);

    End;
End;

Procedure ImprimirVector(vc : contador);

Var 
  i : integer;
Begin
  For i:=1 To 24 Do
    Begin
      writeln('Cantidad de partidas de la provincia ',i,': ',vc[i].cant);
      writeln('Monto total de partidas de la provincia ',i,': $',vc[i].monto:0:2);

    End;
End;
{3.- Realice un módulo recursivo que reciba la estructura generada en el inciso 2 y retorne el código de la provincia con mayor cantidad de partidas recibidas.}

Procedure EncontrarMax (v : contador; Var maxCode,maxCant : integer; DL : integer);

Begin
  If (dl>0) Then
    Begin
      If (v[dl].cant>maxCant) Then
        Begin
          maxCAnt := v[dl].cant;
          maxCode := dl;
        End;
      EncontrarMax(v,maxCode,maxCant,DL-1);
    End;
End;
{4.- Realice un módulo que reciba la estructura de datos generada en 1, dos años y un mes, y retorne la cantidad total de partidas enviadas a las distintas provincias en el mes entre dichos años.}

Function cantEnElMes ( l : lista; mes : meses) : integer;

Var 
  aux : integer;
Begin
  aux := 0;
  While (l<>Nil) And (mes>=l^.dato.mes) Do
    Begin
      If (mes = l^.dato.mes) Then
        aux := aux +1;
      l := l^.sig;
    End;
  cantEnElMes := aux;
End;

Function cantEntreRangos (t : tree; LimInf,LimSup : integer; mes : meses) : integer;
Begin
  If (t=Nil) Then
    cantEntreRangos := 0
  Else If (t^.dato.ano<LimInf) Then cantEntreRangos := cantEntreRangos(t^.hd,limInf,limSup,mes)
  Else If (t^.dato.ano>LimSup) Then cantEntreRangos := cantEntreRangos(t^.hi,limInf,limSup,mes)
  Else
    cantEntreRangos := cantEnElMes(t^.dato.listaAno,mes) + cantEntreRangos(t^.hi,limInf,limSup,mes) + cantEntreRangos(t^.hd,limInf,limSup,mes);
End;


Var 
  t : tree;
  vc : contador;
  DL,maxCode,maxCant,LimInf,limsup: integer;
  mes : meses;
Begin
  randomize;
  InicializarContador(vc);
  CargarArbol(t);
  ImprimirArbol(t);
  contarProvincias(t,vc);
  ImprimirVector(vc);
  dl := 24;
  maxCode := 0;
  maxCant := 0;
  EncontrarMax(vc,maxCode,maxCAnt,dl);
  writeln('La provincia con mayor cantidad de partidas fue la ',maxCode,' con ',maxCant, ' partidas.');
  writeln('Ingresar rango de anos a buscar (2011-2022): ');
  readln(LimInf);
  readln(LimSup);
  write('Ingresar mes que se quiere buscar: ');
  readln(mes);
  writeln('La cantidad de partidas en el mes ',mes,' y entre los anos ',LimInf, '-',LimSup,' fue de: ',cantEntreRangos(t,LimInf,LimSup,mes));
End.
