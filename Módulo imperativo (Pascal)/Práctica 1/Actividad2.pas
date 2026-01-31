{
El administrador de un edificio de oficinas cuenta, en papel, con la información del pago de
las expensas de dichas oficinas.
Implementar un programa que invoque a módulos para cada uno de los siguientes puntos:
a. Genere un vector, sin orden, con a lo sumo las 300 oficinas que administra. De cada oficina
se ingresa el código de identificación, DNI del propietario y valor de la expensa. La lectura
finaliza cuando se ingresa el código de identificación -1, el cual no se procesa.
b. Ordene el vector, aplicando el método de inserción, por código de identificación de la
oficina.
c. Ordene el vector aplicando el método de selección, por código de identificación de la oficina
}
program punto2;
const
df = 300;
type
office = record
	code : integer;
	DNI : integer;
	value : real;
end;
indice = 0..DF;
storage = array [1..DF] of office;
procedure LeerOficina (var o : office);
begin
	writeln('Ingresar código: ');
	readln(o.code);
	if (o.code <> -1) then 
	begin
		writeln('Ingresar DNI: ');
		readln(o.DNI);
		writeln('Ingresar valor de expensas: ');
		readln(o.value);
	end;
end;
procedure CargarVector (var v : storage; var DL : indice);
var
	o : office;
begin
	LeerOficina(o);
	DL:=0;
	while(DL<DF) and (o.code <> -1) do begin
		DL:=DL+1;
		v[DL]:=o;
		LeerOficina(o);
	end;
end;
procedure OrdenarSeleccion (var v : storage; dl : indice);
var
	i,j,pos : indice;
	elemento : office;
begin
	for i:=1 to DL - 1 do begin
		pos:=i;
		for j:=i+1 to dl do 
			if (V[j].code<V[pos].code) then
				pos:=j;
		elemento:=v[pos];
		v[pos]:=v[i];
		v[i]:=elemento;
	end;
end;
procedure OrdenarInsercion (var v : storage; DL : indice);
var
	i,j : indice;
	actual : office;
begin
	for i:=2 to DL do begin
		actual:=v[i];
		j:=i-1;
		while(j>0) and (v[j].code>actual.code) do begin
			v[j+1]:=v[j];
			j:=j-1;
		end;
		v[j+1]:=actual;
	end;
end;
procedure ImprimirVector(v:storage;DL:indice);
var
	i : integer;
begin
	for i:=1 to DL do begin
		writeln('El código es: ', V[i].code);
		writeln('El DNI es: ', V[i].DNI);
		writeln('El valor de las expensas es: ', V[i].value);
	end;
end;
var
	DL : indice;
	v : storage;
begin
	CargarVector(v,DL);
	OrdenarSeleccion(v,DL);
	{OrdenarInsercion(v,DL);}
	ImprimirVector(V,DL);
end.
