

{Netflix ha publicado la lista de películas que estarán disponibles durante el mes de septiembre de 2025. De cada película se conoce: 
 código de película, código de género (1: acción, 2: aventura, 3: drama, 4: suspenso, 5: comedia, 6: bélico, 7: documental y 8: terror) 
y puntaje promedio otorgado por las críticas.
Implementar un programa que invoque a módulos para cada uno de los siguientes puntos:
a. Lea los datos de películas, los almacene por orden de llegada y agrupados por código de género, y retorne en una estructura de datos 
 adecuada. La lectura finaliza cuando se lee el código de la película -1.
b. Genere y retorne en un vector, para cada género, el código de película con mayor puntaje obtenido entre todas las críticas,
 a partir de la estructura generada en a)..
c. Ordene los elementos del vector generado en b) por puntaje utilizando alguno de los dos métodos vistos en la teoría.
d. Muestre el código de película con mayor puntaje y el código de película con menor puntaje, del vector obtenido en el punto c).}

Program Actividad3;

Const 
  cantGeneros = 8;
  fin = -1;

Type 
  generos = 1..cantGeneros;
  lista = ^nodo;
  peliculas = Record
    code : integer;
    gen : generos;
    avg : real;
  End;
  nodo = Record
    dato : peliculas;
    sig: lista;
  End;
  punteros = Record
    pri: lista;
    ult: lista;
  End;
  maximo = Record
    code : integer;
    avg : real;
  End;
  vectorListas = array [generos] Of punteros;
  vectorMaximos = array [generos] Of maximo;

Procedure InicializarListas(Var v : vectorlistas);

Var 
  i : integer;
Begin
  For i:=1 To cantGeneros Do
    Begin
      v[i].pri := Nil;
      v[i].ult := Nil;
    End;
End;
Procedure LeerPelicula (Var p : peliculas);
Begin
  writeln('Ingrese el codigo: ');
  readln(p.code);
  If (p.code <> fin) Then
    Begin
      writeln('Ingrese el genero: ');
      readln(p.gen);
      writeln('Ingrese el puntaje promedio: ');
      readln(p.avg);
    End;
End;
Procedure AgregarAtras(Var l:punteros; p : peliculas);

Var 
  aux : lista;
Begin
  new(aux);
  aux^.dato := p;
  aux^.sig := Nil;
  If (l.pri=Nil) Then
    l.pri := aux
  Else
    l.ult^.sig := aux;
  l.ult := aux;
End;
Procedure CargarListas(Var v : vectorlistas);

Var 
  p : peliculas;
Begin
  InicializarListas(v);
  LeerPelicula(p);
  While (p.code<>fin) Do
    Begin
      AgregarAtras(v[p.gen], p);
      LeerPelicula(p);
    End;
End;

Procedure InicializarVector(Var v : vectorMaximos);

Var 
  i : integer;
Begin
  For i:=1 To cantGeneros Do
    Begin
      v[i].avg := -1;
      v[i].code := -1;
    End;
End;
Procedure EncontrarMaximos( VL: vectorListas; Var v : vectorMaximos);

Var 
  i : integer;
Begin
  For i:=1 To cantGeneros Do
    Begin
      While (VL[i].pri<>Nil) Do
        Begin
          If vl[i].pri^.dato.avg>v[i].avg Then
            Begin
              v[i].avg := vl[i].pri^.dato.avg;
              v[i].code := vl[i].pri^.dato.code;
            End;
          VL[i].pri := VL[i].pri^.sig;
        End;
    End;
End;

Procedure OrdenarVector (Var v : vectorMaximos);

Var 
  i,j,posEnLaQueEstaMinimo : integer;
  elementoVector : maximo;
Begin
  For i:=1 To cantGeneros - 1 Do
    Begin
      posEnLaQueEstaMinimo := i;
      For j:=i+1 To cantGeneros Do
        Begin
          If v[j].avg<v[posEnLaQueEstaMinimo].avg Then
            posEnLaQueEstaMinimo := j;
          elementoVector := v[posEnLaQueEstaMinimo];
          v[posEnLaQueEstaMinimo] := v[i];
          v[i] := elementoVector;
        End;
    End;
End;

Procedure ImprimirMaxMin (v:vectorMaximos);
Begin
  writeln('Codigo con mayor puntaje: ', v[1].code);
  writeln('Codigo con menor puntaje: ', v[cantGeneros].code);
End;
Procedure ImprimirVector(v:vectorMaximos);

Var i : integer;
Begin
  For i:=1 To cantGeneros Do
    writeln(v[i].code);
End;

Var 
  maximos: vectorMaximos;
  listas : vectorlistas;
Begin
  InicializarVector(maximos);
  CargarListas(listas);
  EncontrarMaximos(listas,maximos);
  ImprimirVector(maximos);
  OrdenarVector(maximos);
  ImprimirMaxMin(maximos);
End.
