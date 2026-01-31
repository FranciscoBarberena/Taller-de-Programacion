
{2.- Escribir un programa que:
a. Implemente un módulo recursivo que genere y retorne una lista de números enteros
“random” en el rango 100-200. Finalizar con el número 100.
b. Un módulo recursivo que reciba la lista generada en a) e imprima los valores de la lista en el
mismo orden que están almacenados.
c. Implemente un módulo recursivo que reciba la lista generada en a) e imprima los valores de
la lista en orden inverso al que están almacenados.
d. Implemente un módulo recursivo que reciba la lista generada en a) y devuelva el mínimo
valor de la lista.
e. Implemente un módulo recursivo que reciba la lista generada en a) y un valor y devuelva
verdadero si dicho valor se encuentra en la lista o falso en caso contrario.}

Program actividad2;

Const 
  LimInf = 100;
  LimSup = 200;

Type 
  lista = ^nodo;
  nodo = Record
    dato : integer;
    sig : lista;
  End;
Procedure AgregarAdelante(Var l : lista; num : integer);

Var aux : lista;
Begin
  new (aux);
  aux^.dato := num;
  aux^.sig := l;
  l := aux;
End;
Procedure GenerarLista(Var l : lista);

Var num : integer;
Begin
  num := random(LimSup-LimInf+1)+ LimInf;
  If num <> LimInf Then
    Begin
      AgregarAdelante(l,num);
      GenerarLista(l);
    End;
End;
Procedure ImprimirListaEnOrden ( l : lista);
Begin
  If (l<>Nil) Then
    Begin
      writeln(l^.dato);
      l := l^.sig;
      ImprimirListaEnOrden(l)
    End
  Else writeln('Fin de la lista');
End;
Procedure ImprimirListaAlReves ( l : lista);
Begin
  If (l<>Nil) Then
    Begin
      ImprimirListaAlReves(l^.sig);
      writeln(l^.dato);
    End;
End;
Function encontrarMinimoLista(l : lista;  aux : integer) : integer;

Begin
  If (l<>Nil) And (l^.dato<aux) Then
    aux := l^.dato;
  If (l<>Nil) Then
    Begin
      aux := encontrarMinimoLista(l^.sig,aux);
    End;
  encontrarMinimoLista := aux;
End;







Function estaEnLalista (l : lista; n : integer) : boolean;

Var 
  aux : boolean;
Begin
  aux := false;
  If (l<>Nil) And (l^.dato <> n) Then
    aux := estaEnLalista(l^.sig, n)
  Else If (l<>Nil) Then
         aux := true;
  estaEnLalista := aux;
End;


Var 
  l : lista;
  aux,n : integer;
Begin
  randomize;
  aux := 9999;
  l := Nil;
  GenerarLista(l);
  ImprimirListaEnOrden(l);
  ImprimirListaAlReves(l);
  writeln('MINIMO: ',encontrarMinimoLista(l,aux));
  writeln('Ingrese el numero a buscar: ');
  readln(n);
  writeln(n, ' esta en la lista? ', estaEnLalista(l,n));
End.
